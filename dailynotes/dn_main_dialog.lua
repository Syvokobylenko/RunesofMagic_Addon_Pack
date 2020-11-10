-----------------------------------------------------------------------------
--  DailyNotes - Main Dialog
-----------------------------------------------------------------------------

local Nyx = LibStub("Nyx")
local DailyNotes = _G.DailyNotes

local MAX_LIST_ENTRIES = 15

local function SetHeaderText(this,text)
    this:SetText(text)
    this:SetWidth(this:GetTextWidth() + 8)
end

function DailyNotes.InitDialog()
    UIPanelBackdropFrame_SetTexture( DailyNotesFrame, "Interface/Common/PanelCommonFrame", 256 , 256 )

    DailyNotesFrameTitle:SetText("DailyNotes |cffa0a000"..DailyNotes.VERSION)
    SetHeaderText(DailyNotesListCountHeader,DailyNotes.L.DN_F_COUNT)
    SetHeaderText(DailyNotesListTargetHeader,DailyNotes.L.DN_F_TARGET)
    SetHeaderText(DailyNotesListNameHeader,DailyNotes.L.DN_F_NAME)
    SetHeaderText(DailyNotesListLevelHeader,DailyNotes.L.DN_F_LEVEL)
    SetHeaderText(DailyNotesListZoneHeader,DailyNotes.L.DN_F_ZONE)
    SetHeaderText(DailyNotesListItemHeader,DailyNotes.L.DN_F_ITEM)
    SetHeaderText(DailyNotesListREW1Header,DailyNotes.L.DN_F_REW1)
    SetHeaderText(DailyNotesListREW2Header,DailyNotes.L.DN_F_REW2)
    DailyNotesDailyCount:SetText(DailyNotes.L.DN_F_DAILIES)
    DailyNotesDailyFinished:SetText(DailyNotes.L.DN_F_FINISHED)

    DNFFilterZoneDropDownLabel:SetText(DailyNotes.L.DN_F_C_ZONE)
    DailyNotesAutoQuestTake:SetText(DailyNotes.L.DN_F_Q_TAKE)
    DailyNoteAQAll:SetText(DailyNotes.L.DN_F_Q_ALL)
    DailyNoteAQClear:SetText(DailyNotes.L.DN_F_Q_NONE)
    DailyNoteAQKill:SetText(DailyNotes.L.DN_F_Q_KILL)
    DailyNoteAQGather:SetText(DailyNotes.L.DN_F_Q_GATHER)
    DailyNoteOptions:SetText(DailyNotes.L.DN_F_Q_OPTIONS)
end

DailyNotes.fct_compare={
 -- count
 function (a,b)  return a[4]>b[4] end,
 -- target
 function (a,b)  return false end,
 -- name
 function (a,b)  return TEXT("Sys"..a[1].."_name")<TEXT("Sys"..b[1].."_name") end,
 -- level
 function (a,b)  if DN_Options.showcharlevel then return a[2].rlvl>b[2].rlvl end return a[2].lvl>b[2].lvl end,
 -- zone
 function (a,b)  return GetZoneLocalName(a[2].zone)<GetZoneLocalName(b[2].zone) end,
 -- item
 function (a,b)  return DailyNotes.GetQuestItemName(a[2])<DailyNotes.GetQuestItemName(b[2]) end,
 -- xp
 function (a,b)  return a[2].rew[1]>b[2].rew[1] end,
 -- energy
 function (a,b)  return (a[2].rew[4] or 0)>(b[2].rew[4] or 0) end,
}

function DailyNotes.GetQuestItemName(qdata)
  local itemid = next(qdata.items or {})
  if itemid then return TEXT("Sys"..itemid.."_name") end
  local mobid = next(qdata.mobs or {})
  if mobid then return DailyNotes.GetNPCInfo(mobid) end
  return ""
end


---------------------------------
function DailyNotes.UpdateList()

  local filter = DailyNotes.BuildFilterFunction()

  -- Get filtered list
  DailyNotes.view_lines={}
  local total_finished_count =0
  for QID,qdata in pairs(DailyNotes.DB_Quests) do
    local finished, itemcounts, count = DailyNotes.GetQuestItems_FromTempTable(qdata)
    total_finished_count = total_finished_count + finished

    if filter(QID,qdata) then
        table.insert(DailyNotes.view_lines,{QID,qdata,finished,count,itemcounts})
    end
  end

  -- Sort
  if DN_Options.Sort and DN_Options.Sort<0 and DailyNotes.fct_compare[-DN_Options.Sort] then
    table.sort(DailyNotes.view_lines, function (a,b) return DailyNotes.fct_compare[-DN_Options.Sort](b,a) end)
  else
    table.sort(DailyNotes.view_lines, DailyNotes.fct_compare[DN_Options.Sort] or DailyNotes.fct_compare[1])
  end


  -- Update view
  if #DailyNotes.view_lines > MAX_LIST_ENTRIES then
    DailyNotesListScrollBar:Show()
    DailyNotesListScrollBar:SetMinMaxValues(0, #DailyNotes.view_lines-MAX_LIST_ENTRIES)
  else
    DailyNotesListScrollBar:Hide()
    DailyNotesListScrollBar:SetMinMaxValues(0, 0)
  end

  -- Quests total; finished quest
  DailyNotesListSize:SetText(#DailyNotes.view_lines.." / ".. DailyNotes.Quest_count)
  DailyNotesFinAble:SetText(total_finished_count)

  DailyNotes.UpdateListView()
end

function DailyNotes.GetQuestItems_FromTempTable(qudata)

    if not qudata then return end
    if not qudata.items then return 0,{},0 end

    local itemcounts = {}
    local max_completed=nil
    local finish_able
    local total=0
    for iid,count in pairs(qudata.items) do
        local icount = DailyNotes.item_counts[iid] or 0
        itemcounts[iid] = icount
        finish_able = math.floor(icount/count)
        total = total + icount
        if not max_completed or finish_able<max_completed then
            max_completed = finish_able
        end
    end

    return max_completed,itemcounts,total
end


function DailyNotes.BuildFilterFunction()

    local filter = { "return function(QID,qdata)"}

    DN_Options.filter = DN_Options.filter or {}

    -- Zone
    local nzone_filter = DN_Char_Options.FilterZone or -3
    if nzone_filter == -3 then
        nzone_filter = GetCurrentWorldMapID()
    end

    if nzone_filter~= -2 then
        table.insert(filter,
            string.format("if qdata.zone~=%i and qdata.zone~=DailyNotes.DB_Zones[%i] and %i~=DailyNotes.DB_Zones[qdata.zone] then return false end",
                           nzone_filter, nzone_filter, nzone_filter))
    end

    -- Undone
    if DN_Options.filter.undone then
        table.insert(filter,"if CheckQuest(QID)==1 or CheckQuest(QID)==2 then return false end")
    end

    -- level
    local mlvl, slvl = Nyx.GetPlayerLevel()

    if DN_Options.filter.main then
        table.insert(filter,string.format("if qdata.rlvl>%i then return false end ", mlvl))
    end

    if DN_Options.filter.sec then
        table.insert(filter, string.format("if qdata.lvl>%i and (qdata.rlvl>%i or qdata.lvl-10>%i) then return false end ",
                                slvl, mlvl,slvl))
    end

    -- type
    table.insert(filter,"local typ = qdata.typ%10")
    table.insert(filter,"local ispublic = (qdata.rew[4] and qdata.rew[4]>0)")

    if not DN_Options.filter.repeatable then
        table.insert(filter,"if typ==3 then return false end")
    end

    if not DN_Options.filter.epic then
        table.insert(filter,"if typ==6 then return false end")
    end

    if not DN_Options.filter.public then
        table.insert(filter,"if ispublic then return false end")
    end

    if not DN_Options.filter.daily then
        table.insert(filter,"if not (typ==3 or typ==6 or ispublic) then return false end")
    end

    if not DN_Options.filter.energy then
        table.insert(filter,"if qdata.rew[4]~=nil and qdata.rew[4]>0 then return false end")
    end

    if not DN_Options.filter.xp then
        table.insert(filter,"if qdata.rew[1]>0 then return false end")
    end


    -- item count
    if DN_Options.filter.finished or DN_Options.filter.started then
        table.insert(filter,"local finished,_,count = DailyNotes.GetQuestItems_FromTempTable(qdata)")

        if DN_Options.filter.finished then
            table.insert(filter,"if finished==0 then return false end")
        end
        if DN_Options.filter.started then
            table.insert(filter,"if count==0 then return false end")
        end
    end


    table.insert(filter,"return true end")

    local f,msg = loadstring(table.concat(filter," "))
    assert(f,msg)

    return f()
end


function DailyNotes.List_Header_OnClick(this)

  local id = this:GetID()
  DailyNotesListCountHeaderSortIcon:SetFile("");
  DailyNotesListTargetHeaderSortIcon:SetFile("");
  DailyNotesListLevelHeaderSortIcon:SetFile("");
  DailyNotesListNameHeaderSortIcon:SetFile("");
  DailyNotesListZoneHeaderSortIcon:SetFile("");
  DailyNotesListItemHeaderSortIcon:SetFile("");
  DailyNotesListREW1HeaderSortIcon:SetFile("");
  DailyNotesListREW2HeaderSortIcon:SetFile("");

  if(DN_Options.Sort == id or DN_Options.Sort == -id ) then
    DN_Options.Sort = -DN_Options.Sort
  else
    DN_Options.Sort = id;
  end

  if DN_Options.Sort>0 then
    getglobal(this:GetName() .. "SortIcon"):SetFile("Interface/chatframe/chatframe-scrollbar-buttondown")
  else
    getglobal(this:GetName() .. "SortIcon"):SetFile("Interface/chatframe/chatframe-scrollbar-buttonup")
  end

  DailyNotes.UpdateList()
end

----------------------------
function DailyNotes.OnShow()

    DailyNotes.item_counts = Nyx.GetBagItemCounts()

    -- set zone
    local zone_text=""
    local zonenum = DN_Char_Options.FilterZone or -3
    if zonenum==-2 then zone_text=DailyNotes.L.ZONE_ALL
    elseif zonenum==-3 then zone_text=DailyNotes.L.ZONE_CUR
    else
        if zonenum == 670 then
            zone_text = DailyNotes.L.ZONE_YLAB
        else
        zone_text=GetZoneLocalName(zonenum)
        end
    end
    UIDropDownMenu_SetSelectedName(DNFFilterZoneDropDown, zone_text)
    DNFFilterZoneDropDownText:SetText(zone_text)

    DailyNotesAutoQuest:SetChecked(DN_Char_Options.autoquest)

    DailyNotes.UpdateAQButtons()
    DailyNotes.UpdateList()
end

function DailyNotes.OnHide()
    DailyNotes.view_lines=nil
    DailyNotes.item_counts=nil
end

----------------------------
function DailyNotes.UpdateListView()

    local index = DailyNotesListScrollBar:GetValue()

    local mlvl = Nyx.GetPlayerLevel()

    local button,QID,qdata,qname

    for i = 1, MAX_LIST_ENTRIES do
        button = getglobal("DailyNotesListItem"..i);


        if DailyNotes.view_lines[index+i] then
            QID = DailyNotes.view_lines[index+i][1]
            qdata = DailyNotes.view_lines[index+i][2]
            qname = TEXT("Sys"..QID.."_name")

            buttonName = button:GetName();

            local _,count, target = DailyNotes.MakeItemCountString(qdata,DailyNotes.view_lines[index+i][5])
            _G[buttonName.."Counter"]:SetText(count)
            _G[buttonName.."Target"]:SetText(target)
            if not count and not target then
                _G[buttonName.."Splitter"]:Hide()
            else
                _G[buttonName.."Splitter"]:Show()
            end

            if DN_Options.showcharlevel then
                getglobal(buttonName.."Level"):SetText(qdata.rlvl)
            else
                getglobal(buttonName.."Level"):SetText(qdata.lvl)
            end

            getglobal(buttonName.."Name"):SetText(qname)
            getglobal(buttonName.."Zone"):SetText(GetZoneLocalName(qdata.zone))
            getglobal(buttonName.."Item"):SetText(DailyNotes.GetQuestItemName(qdata))
            getglobal(buttonName.."REW1"):SetText(qdata.rew[1])
            getglobal(buttonName.."REW2"):SetText(qdata.rew[4] or "")

            -- icon
            if (math.floor(qdata.typ/10)%2)==1 then
                getglobal(buttonName.."IconOnce"):Show()
            else
                getglobal(buttonName.."IconOnce"):Hide()
            end

            local typ = qdata.typ%10
            if     typ==2 then getglobal(buttonName.."Icon"):SetTexCoord(0.25, 0.375,0,1) -- kill
            elseif typ==4 then getglobal(buttonName.."Icon"):SetTexCoord(0.375,0.5,  0,1) -- gather
            elseif typ==6 then getglobal(buttonName.."Icon"):SetTexCoord(0.626,0.76, 0,1) -- epic
            else               getglobal(buttonName.."Icon"):SetTexCoord(0.125,0.25, 0,1) -- normal
            end

            -- QuestStatus
            local cq = CheckQuest(QID)
            local icondone = getglobal(buttonName.."IconDone")
            if cq==1 then
                icondone:Show() -- open
                icondone:SetTexCoord(0.5, 0.5625,0,1)
            elseif cq==2 then
                icondone:Hide() -- done
            else
                icondone:Show() -- not done
                icondone:SetTexCoord(0.5625, 0.625,0,1)
            end

            -- color
            r,g,b=1,1,1
            if DailyNotes.view_lines[index+i][3]>0 then r,g,b=0,1,0 -- FINISHED
            elseif DailyNotes.GetRequiredPreQuest(qdata) then r,g,b=1,0.3,0.3 -- PRE.QUEST
            elseif DN_Options.debug and qdata.typ>20 then r,g,b=1,0,1 -- NEED TEST
            elseif mlvl<qdata.rlvl then r,g,b=0.6,0.6,0.6
            end

            getglobal(buttonName.."Counter"):SetColor(r,g,b)
            getglobal(buttonName.."Target"):SetColor(r,g,b)
            getglobal(buttonName.."Level"):SetColor(r,g,b)
            getglobal(buttonName.."Name"):SetColor(r,g,b)
            getglobal(buttonName.."Zone"):SetColor(r,g,b)
            getglobal(buttonName.."Item"):SetColor(r,g,b)
            getglobal(buttonName.."REW1"):SetColor(r,g,b)
            getglobal(buttonName.."REW2"):SetColor(r,g,b)

            if DN_Char_Options.autoquest then
                getglobal(buttonName.."Check"):Show()
                getglobal(buttonName.."Check"):SetChecked(DailyNotes.SF_IsAnAutoQuest(QID))
            else
                getglobal(buttonName.."Check"):Hide()
            end

            button:Show()
        else
            button:Hide()
        end
    end

    DailyNotes.List_UpdateDoAble()

    if DailyNotes.cur_highlit then
        local c = DailyNotes.cur_highlit
        DailyNotes.List_Item_OnLeave(c)
        DailyNotes.List_Item_OnEnter(c)
    end

end


------------
-- List tooltip
function DailyNotes.List_Item_OnEnter(this)

  if not DN_Options.TT_dialog then return end

  DailyNotes.cur_highlit = this

  local highlightText = getglobal(this:GetName().."Highlight")
  highlightText:SetColor(1, 1, 0)
  highlightText:Show()

  local index = DailyNotesListScrollBar:GetValue() + this:GetID()
  if not DailyNotes.view_lines[index] then return end

  local QID = DailyNotes.view_lines[index][1]
  local qdata = DailyNotes.view_lines[index][2]

  DailyNotes.InDialogTT = true

  -- Show the tooltip
  GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, -16)

    --------------------------------
    -- Quest with Item
    if qdata.items then
        local itemid,_ = next(qdata.items)
        GameTooltip.QID = QID
        GameTooltip:SetHyperLink( Nyx.CreateItemLink( itemid ) )
        GameTooltip:Show()
        GameTooltip.QID = nil

    --------------------------------
    -- Quest with Mobs
    elseif qdata.mobs then

        GameTooltip:SetText("")
        local first=true
        for mobid,mobcount in pairs(qdata.mobs or {}) do
          if first then
            GameTooltip:SetText(DailyNotes.GetNPCInfo(mobid))
            GameTooltip:AddLine("")
            first = nil
          else
            GameTooltip:AddLine("+ " .. DailyNotes.GetNPCInfo(mobid))
          end
          local qtaker = DailyNotes.GetQuestTaker(qdata)
          GameTooltip:AddLine(string.format(DailyNotes.L.KILLCOUNT, mobcount, DailyNotes.GetNPCInfo(qtaker))) -- "10 for taker"
        end

        DailyNotes.AppendQuestName(GameTooltip, QID, qdata)
        DailyNotes.AppendQuestNPC(GameTooltip, qdata)
        DailyNotes.AppendQuestText(GameTooltip, QID)
        DailyNotes.AppendReward(GameTooltip, qdata)
        DailyNotes.AppendPrequest(GameTooltip, qdata)
        DailyNotes.AppendInvolvedMobs(GameTooltip, qdata)

        -- Debug flag
        if DN_Options.debug and qdata.typ>20 then
            GameTooltip:AddLine( "|cffff0000(--UNTESTED-- Plz report)")
        end

        GameTooltip:Show()

    --------------------------------
    -- No mob or item
    else

        GameTooltip:SetText("")
        DailyNotes.AppendQuestName(GameTooltip, QID, qdata)
        DailyNotes.AppendQuestNPC(GameTooltip, qdata)
        DailyNotes.AppendQuestText(GameTooltip, QID)
        DailyNotes.AppendReward(GameTooltip, qdata)
        DailyNotes.AppendPrequest(GameTooltip, qdata)

        GameTooltip:Show()

        -- Debug flag
        if DN_Options.debug and qdata.typ>20 then
            GameTooltip:AddLine( "|cffff0000(--UNTESTED-- Plz report)")
        end
    end

    DailyNotes.InDialogTT = nil
end


function DailyNotes.List_Item_OnLeave(this)
    DailyNotes.cur_highlit = nil
    local highlightText = getglobal(this:GetName().."Highlight")
    highlightText:SetColor(1, 1, 1)
    highlightText:Hide()
    GameTooltip:Hide()
end

------------
-- List Context menu
function DailyNotes.List_Item_OnClick(this, key)
  if( key == "RBUTTON" or  key == "LBUTTON")then
    GameTooltip:Hide()
    DNFrameItemMenu.ItemIndex = DailyNotesListScrollBar:GetValue() + this:GetID()
    local QID = DailyNotes.view_lines[DNFrameItemMenu.ItemIndex][1]
    ToggleDropDownMenu(DNFrameItemMenu, 1,TEXT("Sys"..QID.."_name"),"cursor", 1 ,1 );
  end
end

function DailyNotes.ContextFindNPC( id )
  ShowUIPanel( NpcTrackFrame )
  NpcTrackFrame_InitializeNpcList(id)
  NpcTrackFrame:ResetFrameOrder()
  --NpcTrackFrame_QuickTrackByNpcID(id)
end

function DailyNotes.ShowContextMenu( this )

  local info = {};

  if( UIDROPDOWNMENU_MENU_LEVEL == 1 and this.ItemIndex ) then

    local QID = DailyNotes.view_lines[this.ItemIndex][1]
    local qdata = DailyNotes.view_lines[this.ItemIndex][2]


    -- Start NPC
    local qtaker = DailyNotes.GetQuestTaker(qdata)
    local last_start = nil

    local givers = qdata.giver or {}
    if type(givers)=="number" then givers={givers} end

    for _,value in ipairs(givers) do
      local n_name,n_map,n_posx,n_posy = DailyNotes.GetNPCInfo(value)

      if n_name ~= last_start then

        if value == qtaker then
          qtaker = nil

          info = {}
          info.text   = DailyNotes.L.FIND_NPC..n_name
          info.notCheckable = 1
          info.func   = function() DailyNotes.ContextFindNPC( value ) end
          info.value  = 1
          UIDropDownMenu_AddButton(info)
        else
          info = {}
          info.text   = DailyNotes.L.FIND_START..n_name
          info.notCheckable = 1
          info.func   = function() DailyNotes.ContextFindNPC( value ) end
          info.value  = 1
          UIDropDownMenu_AddButton(info)
        end

        last_start = n_name
      end
    end

    for mobid,val in pairs(qdata.mobs or {}) do
      if mobid and type(mobid)=="number" and ( NpcTrack_SearchNpcByDBID( mobid ) >0 )then
        local _, n_name, _, _, _ = NpcTrack_GetNpc(1)
        info = {}
        info.text   = DailyNotes.L.FIND_MOB..n_name
        info.notCheckable = 1
        info.func   = function() DailyNotes.ContextFindNPC( mobid ) end
        info.value  = 1
        UIDropDownMenu_AddButton(info)
      end
    end

    -- reward npc
    if qtaker then
      local n_name,n_map,n_posx,n_posy = DailyNotes.GetNPCInfo(qtaker)

      info = {}
      info.text   = DailyNotes.L.FIND_END..n_name
      info.notCheckable = 1
      info.func   = function() DailyNotes.ContextFindNPC( qtaker ) end
      info.value  = 1
      UIDropDownMenu_AddButton(info)
    end

    info = {}
    info.text   = TEXT("C_CANCEL")
    info.notCheckable = 1
    info.func   = function() end
    info.value  = 6
    UIDropDownMenu_AddButton(info)

  end
end

------------
-- zone filter
function DailyNotes.FZoneDropDown_OnLoad(this)
  UIDropDownMenu_SetWidth(this, 100)
  UIDropDownMenu_Initialize(this, DailyNotes.FZoneDropDown_Show)
end


local function IsInZone(zone, parent)
    if zone==parent then return true end

    local p = DailyNotes.DB_Zones[zone]
    if not p then return false end
    if p==parent then return true end
    return IsInZone(p, parent)
end

function DailyNotes.FZoneDropDown_Show()
    local info
    local zonenum = DN_Char_Options.FilterZone or -3

    if( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
        info = {}
        info.func = DailyNotes.FilterZoneDropDown_Click
        info.text = DailyNotes.L.ZONE_ALL
        info.value = -2
        info.textR = 1
        info.textG = 1
        info.textB = 0
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.func = DailyNotes.FilterZoneDropDown_Click
        info.text = DailyNotes.L.ZONE_CUR
        info.value = -3
        info.textR = 1
        info.textG = 1
        info.textB = 0
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("ZONE_YGGNO LAND")
        info.hasArrow = 1
        info.value = 9998
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("ZONE_SAVILLEPLAINS")
        info.hasArrow = 1
        info.value = 9997
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("SC_BALANZASAR")
        info.hasArrow = 1
        info.value = 9996
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("SC_GDDR_00")
        info.hasArrow = 1
        info.value = 9995
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("ZONE_KOLYDIA")
        info.hasArrow = 1
        info.value = 9994
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("UI_WORLDMAP_OTHER")
        info.hasArrow = 1
        info.value = 9999
        info.checked = zonenum==info.value
        UIDropDownMenu_AddButton(info)

    elseif( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then

        local p_zone = UIDROPDOWNMENU_MENU_VALUE

        local zones={}
        local zones_in={}
        for _,d in pairs(DailyNotes.DB_Quests) do
            if not zones_in[d.zone] and IsInZone(d.zone, p_zone) then
                zones_in[d.zone]=1
                table.insert(zones,{d.zone,GetZoneLocalName(d.zone) or ""})
            end
        end

        -- ystra-lab
        if p_zone==9998 then
            table.insert(zones,{670,DailyNotes.L.ZONE_YLAB})
        end


        table.sort(zones,function (a,b) return a[2]<b[2] end)

        for _,n in ipairs(zones) do
            info = {}
            info.func = DailyNotes.FilterZoneDropDown_Click
            info.text = n[2]
            info.value= n[1]
            info.checked = zonenum==info.value
            UIDropDownMenu_AddButton(info,2)
        end
    end
end


function DailyNotes.FilterZoneDropDown_Click(button)
    UIDropDownMenu_SetSelectedValue(DNFFilterZoneDropDown, button.value)
    DNFFilterZoneDropDownText:SetText(button:GetText())
    DN_Char_Options.FilterZone = button.value
    DailyNotes.UpdateList()
    CloseDropDownMenus()
end


function DailyNotes.FilterOptionsMenu_OnLoad(this)
    UIDropDownMenu_Initialize( this, DailyNotes.FilterOptionsMenu_OnShow, "MENU")
end

function DailyNotes.FilterOptionsMenu_OnShow(this)

    local function add(value,title,tooltip)
    	local info = {}
        info.value=value
		info.text = title
        info.tooltipText = tooltip
        info.checked = DN_Options.filter[info.value]
        info.func = DailyNotes.FilterOptionsMenu_OnClick
        info.keepShownOnClick = 1
		UIDropDownMenu_AddButton(info, 1)
    end


	if UIDROPDOWNMENU_MENU_LEVEL == 1 then

        local seperator = {}
		seperator.text = '---------------'
		seperator.isTitle = 1

        add("main", DailyNotes.L.F_MAINCHAR, DailyNotes.L.T_LVL1)
        add("sec", DailyNotes.L.F_SECCHAR, DailyNotes.L.T_LVL2)

		UIDropDownMenu_AddButton(seperator, 1)

        add("finished", DailyNotes.L.COUNT_FIN)
        add("started", DailyNotes.L.COUNT_START)

        UIDropDownMenu_AddButton(seperator, 1)

        add("repeatable", DailyNotes.L.REPEATABLE)
        add("epic",  DailyNotes.L.EPIC)
        add("daily", DailyNotes.L.DAILY)
        add("public", DailyNotes.L.PUBLIC)

        UIDropDownMenu_AddButton(seperator, 1)
        add("undone", DailyNotes.L.UNDONE)

        UIDropDownMenu_AddButton(seperator, 1)
        add("energy", DailyNotes.L.FILTER_ENERGY)
        add("xp", DailyNotes.L.FILTER_XP)



        UIDropDownMenu_AddButton(seperator, 1)
        local info = {}
        info.text = DailyNotes.L.FILTER_CLEAR
        info.textR = 1
        info.textG = 1
        info.textB = 0.5
        info.func = function ()
                DN_Options.filter = { repeatable=true, epic=true, daily=true, public=true, energy=true, xp=true}
                DailyNotes.UpdateList()
            end
        UIDropDownMenu_AddButton(info, 1)
	end


end

function DailyNotes.FilterOptionsMenu_Validate(hint)

    local function are_all_disable(group)
        for _,opt in ipairs(group) do
            if DN_Options.filter[opt] then
                return false
            end
        end
        return true
    end


    local groups= {
        {"repeatable","epic","daily","public"},
        --{"energy", "xp"},
        }

    local changed=false
    for _,group in ipairs(groups) do
        if are_all_disable(group) then
            for _,opt in ipairs(group) do
                if opt ~= hint then
                    DN_Options.filter[opt] = true
                    changed = true
                end
            end
        end
    end

    return changed
end


function DailyNotes.FilterOptionsMenu_OnClick(button)
    if button.value then
        DN_Options.filter[button.value] = not DN_Options.filter[button.value]

        if DailyNotes.FilterOptionsMenu_Validate(button.value)then
            button:GetParent():Hide()
        end

        DailyNotes.UpdateList()
    end
end


------------
-- AutoQuest
function DailyNotes.AutoQuest(btn)
  DN_Char_Options.autoquest = DailyNotesAutoQuest:IsChecked()
  DailyNotes.UpdateAQButtons()
  DailyNotes.UpdateListView()
end


function DailyNotes.UpdateAQButtons()
  if DN_Char_Options.autoquest then
    DailyNoteAQClear:Show()
    DailyNoteAQAll:Show()
    DailyNoteAQKill:Show()
    DailyNoteAQGather:Show()
    DailyNoteAQKill:UnlockPushed()
    DailyNoteAQGather:UnlockPushed()

    -- check for 'all kill' and 'all gather'
    DailyNotes.AQ_AllKillMarked=1
    DailyNotes.AQ_AllGatherMarked=1
    if DN_Char_Options.aq_accept then
      for QID,qdata in pairs(DailyNotes.DB_Quests) do
        if (qdata.typ%10)==2 then
          DailyNotes.AQ_AllKillMarked = DN_Char_Options.aq_accept[QID] and DailyNotes.AQ_AllKillMarked
        elseif (qdata.typ%10)==4 then
          DailyNotes.AQ_AllGatherMarked = DN_Char_Options.aq_accept[QID] and DailyNotes.AQ_AllGatherMarked
        end
      end
    else
      DailyNotes.AQ_AllKillMarked=nil
      DailyNotes.AQ_AllGatherMarked=nil
    end

    if DailyNotes.AQ_AllKillMarked   then DailyNoteAQKill:LockPushed() end
    if DailyNotes.AQ_AllGatherMarked then DailyNoteAQGather:LockPushed() end

  else
    DailyNoteAQClear:Hide()
    DailyNoteAQAll:Hide()
    DailyNoteAQKill:Hide()
    DailyNoteAQGather:Hide()
  end
end


function DailyNotes.AutoQuestSetCheck(btn,ischecked)
    local index = DailyNotesListScrollBar:GetValue() + btn:GetID()

    local QID = DailyNotes.view_lines[index][1]
    if QID then
        DN_Char_Options.aq_accept = DN_Char_Options.aq_accept or {}
        if ischecked then
            DN_Char_Options.aq_accept[QID] = 1
        else
            DN_Char_Options.aq_accept[QID] = nil
        end

        DailyNotes.UpdateAQButtons()
    end
end

function DailyNotes.AutoQuestClear()
    DN_Char_Options.aq_accept={}
    DailyNotes.MarkAutoQuests(function() return false end)
end

function DailyNotes.AutoQuestSelectAll()
    DN_Char_Options.aq_accept={}
    DailyNotes.MarkAutoQuests(function() return true end, true)
end

function DailyNotes.AutoQuestSelectKill()
    local m = not DailyNotes.AQ_AllKillMarked
    if not m then m=nil end

    DailyNotes.MarkAutoQuests(function(qdata) return (qdata.typ%10)==2 end, m)
end

function DailyNotes.AutoQuestSelectGather()
    local m = not DailyNotes.AQ_AllGatherMarked
    if not m then m=nil end

    DailyNotes.MarkAutoQuests(function(qdata) return (qdata.typ%10)==4 end, m)
end

function DailyNotes.MarkAutoQuests(filter_fct, mark)
    local accept_list = DN_Char_Options.aq_accept or {}

    for QID,qdata in pairs(DailyNotes.DB_Quests) do
        if filter_fct(qdata) then
            accept_list[QID]= mark
        end
    end

    DN_Char_Options.aq_accept = accept_list

    DailyNotes.UpdateAQButtons()
    DailyNotes.UpdateListView()
end

------------
-- Daily counter
function DailyNotes.QUEST_MSG_DAILYRESET()
  DailyNotes.List_UpdateDoAble()
end

function DailyNotes.QUEST_MSG_DAILY_OVERDONE()
  DailyNotes.List_UpdateDoAble()
end

function DailyNotes.RESET_QUESTTRACK()
  DailyNotes.List_UpdateDoAble()
end


function DailyNotes.List_UpdateDoAble()
  local done , dmax2 = Daily_count()

  if done<DailyNotes.Last_daily_count and done<dmax2 then
    SendSystemMsg(DailyNotes.L.DAILIES_RESET)
    DEFAULT_CHAT_FRAME:AddMessage(DailyNotes.L.DAILIES_RESET, 1,1,0.4)
  end

  DailyNotes.Last_daily_count = done
  DailyNotesDoAble:SetText(done.."/"..dmax2)
end




-----------------------------------------------------------------------
-- Configuration Dialog
-----------------------------------------------------------------------
local function Set_CB(frame, option, text, tooltip)
    local text = (text and DailyNotes.L[text]) or text
    _G[frame:GetName().."Text"]:SetText(text)
    frame.ToolTip = tooltip and DailyNotes.L[tooltip]
    frame.option = option
end

function DailyNotes.Config_OptionOnEnter(this)
    if this.ToolTip then
        GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 4, 0)
        GameTooltip:SetText("")
        GameTooltip:AddLine(this.ToolTip)
        GameTooltip:DelayShow()
    end
end

function DailyNotes.Config_OptionOnLeave()
    GameTooltip:DelayHide()
end

function DailyNotes.Config_OptionOnShow(this)
    this:SetChecked(DN_Options[this.option])
end

function DailyNotes.Config_OptionOnClick(this)
    DN_Options[this.option] = this:IsChecked()
    DailyNotes.Config_Save()
end


function DailyNotes.Config_OnLoad(this)
    _G[this:GetName() .."Title"]:SetText(DailyNotes.L.CFG_TITLE)

    Set_CB(DailyNotesCharLevel,"showcharlevel", "CFG_CHARLVL", "T_CHARLVL")
    Set_CB(DailyNotesTaker,"takefilter", "DN_CFG_TAKER", "T_TAKER")
    Set_CB(DailyNotesVerbose,"verbose", "DN_CFG_VERBOSE", "T_VERBOSE")
    Set_CB(DailyNotesVerboseQuest,"verbose_quest", "DN_CFG_VERBOSE_QUEST", "T_VERBOSE_QUEST")
    Set_CB(DailyNotesCounterDisplay,"itemcount", "DN_CFG_COUNTER", "T_COUNTER")
    Set_CB(DailyNotesCounterDQ,"dqionly", "DN_CFG_DQ_ONLY", "T_DQ_ONLY")
    Set_CB(DailyNotesTT_Mobs,"TT_mobs", "CFG_TT_MOBS", "T_TT_MOBS")
    Set_CB(DailyNotesTT_Items,"TT_items", "CFG_TT_ITEMS", "T_TT_ITEMS")
    Set_CB(DailyNotesTT_Dialog,"TT_dialog", "CFG_TT_DIALOG", "T_TT_DIALOG")
    Set_CB(DailyNotesZbagHook,"ZBag_Hook", "CFG_ZBAGHOOK", "T_ZBAGHOOK")
    Set_CB(DailyNotesUndoneQuests,"mark_undone_quests", "CFG_UNDONEQUEST", "T_UNDONEQUEST")

    Set_CB(DailyNotesDebug,"debug", "Debug-Version")

    UIPanelBackdropFrame_SetTexture( this, "Interface/Common/PanelCommonFrame", 256 , 256 )
end

function DailyNotes.Show_Options()
    DailyNotes.Config_Load()
    ToggleUIFrame(DailyNotesConfigFrame)
end

function DailyNotes.Config_Load()

    DNConfigFrame2Reset:SetText(DailyNotes.L.DN_CFG_RESET)

    if DN_Options.itemcount then
        DailyNotesCounterDQ:Enable()
    else
        DailyNotesCounterDQ:Disable()
    end


    if Nyx.VersionToNumber( ZBAG_VERSION ) > 13000 then
        DailyNotesZbagHook:Show()
    else
        DailyNotesZbagHook:Hide()
    end

    --[===[@debug@
    DailyNotesDebug:Show()
    --@end-debug@]===]
end

function DailyNotes.Config_Save()
    DailyNotes.EnableUnitTooltip(DN_Options.TT_mobs)
    DailyNotes.EnableLootMessage(DN_Options.itemcount)

    if DN_Options.itemcount then
        DailyNotesCounterDQ:Enable()
    else
        DailyNotesCounterDQ:Disable()
    end

    if DailyNotesFrame:IsVisible() then
        DailyNotes.UpdateListView()
    end
end

function DailyNotes.Config_Clear()

    StaticPopupDialogs["DN_CONFIG_CLEAR"] = {
        text   = DailyNotes.L.CONFIG_CLEAR,
        button1  = TEXT("ACCEPT"),
        button2  = TEXT("CANCEL"),
        OnAccept = function ()
                DailyNotes.Config_Reset()
                DailyNotes.Config_Load()

                if DailyNotesFrame:IsVisible() then
                  DailyNotes.OnShow()
                end
              end,
        timeout = 0,
        hideOnEscape  = 1
    }

    StaticPopup_Show( "DN_CONFIG_CLEAR" );
end





