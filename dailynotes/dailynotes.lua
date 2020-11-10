-----------------------------------------------------------------------------
--  DailyNotes is an Addon for Runes of Magic
--  It will show you additional information in tooltips and on bulleting boards.
--  feedback to: viertelvor12@gmx.net
--
--  License: MIT/X
-----------------------------------------------------------------------------

------------------------------
--- another ROM-Bug workaround
------------------------------
local myGetZoneLocalName = GetZoneLocalName
function GetZoneLocalName(id)
 if id and id==-1 then return TEXT("GUILD_TEXT_ZONE_UNKOWN") end
 return myGetZoneLocalName(id or -1)
end
------------------------------
local Nyx = LibStub("Nyx")
------------------------------

local DailyNotes = {
  VERSION = "v7.4",

  -- runtime vars:
  Quest_count = 0,    -- total count of quests in DB
  DB_Mobs = nil,      -- map: mob names to quest ids
  DB_Items = nil,     -- map: items to quest ids
  Last_daily_count= 0,-- how much quest has been done
}
_G.DailyNotes = DailyNotes


-------------------------------------
function DailyNotes.Config_Reset()

    DN_Options={
        version = DailyNotes.VERSION,

        -- DEFAULT OPTIONS:
        showcharlevel = true,   -- Show required level instead of quest level
        takefilter = false,     -- Only auto-take quest if items are in inventory
        verbose = false,        -- no additional infos
        verbose_quest = true,   -- no quest infos
        itemcount = true,       -- show item count in loot
         dqionly = true,        -- ^ but only for DQ items
        mark_undone_quests = false,--

        TT_mobs  = true,        -- tool tip on mobs
        TT_items = true,        -- tool tip on items
        TT_dialog= true,        -- tool tip in dialog
        ZBag_Hook= true,        -- apply bag highlights in ZBag
        filter={ repeatable=true, epic=true, daily=true, public=true,energy=true,xp=true},
    }

    local realm = Nyx.GetCurrentRealm()
    if realm~="" then
        DN_Options_Of_Char[realm]={}
        DN_Char_Options = DN_Options_Of_Char[realm]
    end
end

-- init Options
DN_Options={}
DN_Options_Of_Char={}
DN_Char_Options={} -- TODO: make it private again
DailyNotes.Config_Reset()

DailyNotes.L = Nyx.LoadLocalesAuto("Interface/Addons/dailynotes/Locales/","en")

local function BuildItemList()
    local DB={}
    for QID,e in pairs(DailyNotes.DB_Quests) do
        for item,_ in pairs(e.items or {}) do
            if not DB[item] then
                DB[item]=QID
            elseif type(DB[item])=="number" then
                DB[item] = {DB[item],QID}
            else
                table.insert(DB[item],QID)
            end
        end
    end

    return DB
end

function DailyNotes.FindQuestForItem(itemID)
    if not DailyNotes.DB_Items then
        DailyNotes.DB_Items = BuildItemList()
    end

    local res = DailyNotes.DB_Items[itemID]
    if not res then
        return
    elseif type(res)=="number" then
        return res, DailyNotes.DB_Quests[res]
    end

    for _,QID in ipairs(res) do
        if CheckQuest(QID)==1 then
            return QID,DailyNotes.DB_Quests[QID]
        end
    end
    return res[1],DailyNotes.DB_Quests[res[1]]
end

function DailyNotes.GetListOfQuestGivers()
    local h_daily={}
    local h_public={}

    for _,e in pairs(DailyNotes.DB_Quests) do

        if type(e.giver)=="number" then

            if DailyNotes.IsPublicQuest(e) then
                h_public[e.giver]=true
            else
                h_daily[e.giver]=true
            end
        elseif type(e.giver)=="table" then
            for _,nid in ipairs(e.giver) do
                if DailyNotes.IsPublicQuest(e) then
                    h_public[nid]=true
                else
                    h_daily[nid]=true
                end
            end
        end
    end

    local daily={}
    for k,_ in pairs(h_daily) do table.insert(daily,k) end
    table.sort(daily)

    local public={}
    for k,_ in pairs(h_public) do table.insert(public,k) end
    table.sort(public)

    return daily, public
end

-- deprecated .. obsolete with WoWMap 5.0.3.1+
function DailyNotes.IsQuestGiver(NPCid)

    for _,e in pairs(DailyNotes.DB_Quests) do

        if type(e.giver)=="number" then
            if e.giver==NPCid then
                return (DailyNotes.IsPublicQuest(e) and 2 or 1)
            end
        elseif type(e.giver)=="table" then
            for _,nid in ipairs(e.giver) do
                if nid==NPCid then
                    return (DailyNotes.IsPublicQuest(e) and 2 or 1)
                end
            end
        end
    end
end

function DailyNotes.IsPublicQuest(quest_data)
    return quest_data.rew[4] and quest_data.rew[4]>0
end

local EXTRA_TEXT1 = " ["..UI_QUEST_MSG_DAILY.."]"
local EXTRA_TEXT2 = " ["..UI_QUEST_MSG_PUBLIC.."]"

local function IsNpcQuestGiverOrTaker(npc_name, qdata)
    if type(qdata.giver)=="number" then
        if npc_name==TEXT("Sys"..qdata.giver.."_name") then return true end
    elseif type(qdata.giver)=="table" then
        for _,nid in ipairs(qdata.giver) do
            if npc_name==TEXT("Sys"..nid.."_name") then return true end
        end
    else
        return true
    end

    if npc_name==TEXT("Sys112550_name") then -- "Tagesquest-Verwalter"
        return true
    end

    if qdata.taker and npc_name==TEXT("Sys"..qdata.taker.."_name") then
        return true
    end
end

function DailyNotes.FindQuestByName(qname, npc)

    local found_quest
    for QID,e in pairs(DailyNotes.DB_Quests) do
        local basename = TEXT("Sys"..QID.."_name")

        local pub = DailyNotes.IsPublicQuest(e)
        if (pub and basename..EXTRA_TEXT2==qname) or
           ( (not pub) and basename..EXTRA_TEXT1==qname) or
           basename==qname then
                if not npc or IsNpcQuestGiverOrTaker(npc,e) then
                    return QID,e
                end

            found_quest = QID
        end
    end

    if found_quest and DN_Options.debug then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000DN: Quest "..found_quest.." not for found for NPC "..npc)
    end
end

function DailyNotes.GetQuestItems(qudata)

  if not qudata then return end
  if not qudata.items then return 0,{},0 end

  local itemcounts = {}
  local max_completed=nil
  local finish_able
  local total=0
  for iid,count in pairs(qudata.items) do
    itemcounts[iid] = GetBagItemCount(iid)
    finish_able = math.floor(itemcounts[iid]/count)
    total = total + itemcounts[iid]
    if not max_completed or finish_able<max_completed then
      max_completed = finish_able
    end
  end

  return max_completed,itemcounts,total
end

------------------------------
-- return: Name,map,pos_x,pos_y,alt_map_name
-- (alt_map_name is a map name replacement for ystra-lab)
function DailyNotes.GetNPCInfo(npc_id)

    local n_name,n_map,n_posx,n_posy,n_map_name,n_altname

    if npc_id then

      if DailyNotes.DB_NPC[npc_id] then
        n_name = DailyNotes.DB_NPC[npc_id].name
        n_map  = DailyNotes.DB_NPC[npc_id].map
        n_posx = DailyNotes.DB_NPC[npc_id].x
        n_posy = DailyNotes.DB_NPC[npc_id].y
        n_map_name = DailyNotes.DB_NPC[npc_id].map_name

        if n_name then
          if n_map_name then n_altname  = TEXT(n_map_name) end
          return n_name,n_map,n_posx,n_posy,n_altname
        end
      else
        n_name = TEXT("Sys"..npc_id.."_name")
        n_map  = 10000
        n_posx = 50
        n_posy = 50
      end


      if type(npc_id)=="number" and ( NpcTrack_SearchNpcByDBID( npc_id ) >0 )then
        _, n_name, n_map, n_posx, n_posy = NpcTrack_GetNpc(1)
        n_posx = math.floor(n_posx*1000)/10
        n_posy = math.floor(n_posy*1000)/10

        DailyNotes.DB_NPC[npc_id] = {map=n_map,name=n_name,x=n_posx,y=n_posy,map_name=n_map_name}
      end
    end

  if not n_name then
    n_name = "???"
    n_map  = 10000
    n_posx = 50
    n_posy = 50
  end

  if n_map_name then n_altname  = TEXT(n_map_name) end
  return n_name,n_map,n_posx,n_posy,n_altname
end


------------------------------
function DailyNotes.MakeItemCountString(qudata,icounts)

  local pre=nil
  local post=nil

  if (qudata.typ%10)~=2 then
    -- normal
    for iid,count in pairs(qudata.items or {}) do
      if pre then
        pre = pre..",".. (icounts[iid] or 0)
        post = post..","..count
      else
        pre = (icounts[iid] or 0)
        post = count
      end
    end
  else
    -- kill quest
    for iid,count in pairs(qudata.mobs or {}) do
      if pre then
        pre = pre..",".. (icounts[iid] or 0)
        post = post..","..count
      else
        pre = (icounts[iid] or 0)
        post = count
      end
    end
  end

  if not pre then return "??" end
  return pre.."/"..post,pre,post
end

------------------------------
function DailyNotes.EnableLootMessage(enable)
  if enable then
    for i=1,10 do
      local ch=getglobal("ChatFrame"..i)
      if ch and not ch.orig_addmessage then
        ch.orig_addmessage = ch.AddMessage
        ch.AddMessage = HookedAddMessage
      end
    end
    DailyNotes.get_message = string.gsub("^"..TEXT('SYS_GIVE_ITEM'),"<ITEM>",".*(|Hitem.*|r|h).*")
  else
    for i=1,10 do
      local ch=getglobal("ChatFrame"..i)
      if ch and ch.orig_addmessage then
        ch.AddMessage = ch.orig_addmessage
        ch.orig_addmessage = nil
      end
    end
  end
end


function HookedAddMessage(self,msg,r,g,b)

  if msg and DN_Options and DN_Options.itemcount then

    -- get item
    local ilink=string.match(msg,DailyNotes.get_message)
    if ilink then
      local itemid = Nyx.GetItemID(ilink)

      -- check if DQ item
      local _,quest = DailyNotes.FindQuestForItem(itemid)
      local target = quest and quest.items and quest.items[itemid]

      if target then
        local count = GetBagItemCount(itemid)
        msg = msg .." |cffffff00("..count .."/"..target..")"
      else
        if not DN_Options.dqionly then
          local count = GetBagItemCount(itemid)
          if count>1 then
            msg = msg .." |cffffff00("..count..")"
          end
        end
      end
    end
  end

  self.orig_addmessage(self, msg,r,g,b)
end


-----------------------------------------------------------------------
--  Bulletin Board / Quest givers
-----------------------------------------------------------------------
DailyNotes.orig_SpeakFrame_LoadQuest = SpeakFrame_LoadQuest
DailyNotes.orig_SpeakFrame_LoadQuestDetail = SpeakFrame_LoadQuestDetail

function SpeakFrame_LoadQuest()
    DailyNotes.orig_SpeakFrame_LoadQuest()
    DailyNotes.ChangeSpeakFrame()
end

function SpeakFrame_LoadQuestDetail( Quitmode )
    DailyNotes.orig_SpeakFrame_LoadQuestDetail( Quitmode )

    if DailyNotes.execute_quest_type then
        if DailyNotes.execute_quest_type==DF_IconType_NewQuest then
            AcceptQuest()
        else
            CompleteQuest()
        end
        SpeakFrame_Hide()
        DailyNotes.execute_quest_type=nil
        return
    end

    DailyNotes.ChangeSpeakFrame(1)
end


function DailyNotes.ChangeSpeakFrame(is_in_detail_view)

    local auto_do_quest = nil

    local counter_new_quests = 0
    local counter_finished_quests = 0

    for i= 1,g_SpeakFrameData.count do

        local option_entry = g_SpeakFrameData.option[i]

        -- NEW Quests
        if option_entry.type==DF_IconType_NewQuest then

            counter_new_quests = counter_new_quests +1

            local QID, qdata = DailyNotes.SF_TestNewQuest(option_entry, is_in_detail_view)
            if QID then

                local count, itemcounts = DailyNotes.GetQuestItems(qdata)
                DailyNotes.SF_ColorNewQuest(option_entry, is_in_detail_view, QID, qdata, count, itemcounts)

                if DailyNotes.SF_IsAutoAcceptNewQuest(QID, count, qdata) then
                    if not auto_do_quest or
                        ( not qdata.rew[4] and qdata.rew[1] > auto_do_quest.xp) or
                        ( qdata.rew[4] and qdata.rew[4] > auto_do_quest.eng)
                    then
                        auto_do_quest = { index = counter_new_quests, type = DF_IconType_NewQuest, xp = qdata.rew[1], eng=qdata.rew[4] or 0 }
                    end
                end
            end

        -- Unfinished Quests
        elseif option_entry.type==DF_IconType_UnfinishQuest then

            local QID, qdata = DailyNotes.SF_TestNewQuest(option_entry, is_in_detail_view)
            if QID then
                local count, itemcounts = DailyNotes.GetQuestItems(qdata)
                DailyNotes.SF_ColorNewQuest(option_entry, is_in_detail_view, QID, qdata, count, itemcounts)
            end

        -- Finished Quest
        elseif option_entry.type==DF_IconType_FinishedQuest then

            counter_finished_quests = counter_finished_quests +1

            local QID, qdata = DailyNotes.SF_TestFinishedQuest(option_entry, is_in_detail_view)
            if QID then

                DailyNotes.SF_ColorFinishedQuest(option_entry, is_in_detail_view, QID, qdata)

                if DailyNotes.SF_IsAnAutoQuest(QID) then
                    if not auto_do_quest or auto_do_quest.type==DF_IconType_NewQuest or
                        ( not qdata.rew[4] and qdata.rew[1] > auto_do_quest.xp) or
                        ( qdata.rew[4] and qdata.rew[4] > auto_do_quest.eng)
                    then
                        auto_do_quest = { index = counter_finished_quests, type = DF_IconType_FinishedQuest, xp = qdata.rew[1], eng=qdata.rew[4] or 0 }
                    end
                end
            end
        end
    end

    -- 'repaint'
    SpeakFrame_Show()

    DailyNotes.SF_AutoProcessQuest(is_in_detail_view, auto_do_quest)
end

function DailyNotes.SF_TestNewQuest(option_entry, detail)

    local name = option_entry.title
    if detail and name:find("^"..SPEAKFRAME_QUEST_ACCEPT)  then
        name = name:sub(SPEAKFRAME_QUEST_ACCEPT:len()+1)
    end

    return DailyNotes.FindQuestByName(name, GetSpeakObjName())
end

function DailyNotes.SF_TestFinishedQuest(option_entry, detail)

    local name = option_entry.title
    if detail and name:find("^"..SPEAKFRAME_QUEST_COMPLETE) then
        name = name:sub(SPEAKFRAME_QUEST_COMPLETE:len()+1)
    end

    return DailyNotes.FindQuestByName(name, GetSpeakObjName())
end


function DailyNotes.SF_ColorNewQuest(option_entry, detail, QID, qdata, count, itemcounts)

    if DN_Options.mark_undone_quests and CheckQuest(QID)==0 then
        option_entry.iconid = DF_IconType_NewQuest
        option_entry.title = TEXT("Sys"..QID.."_name")
        return
    end

    local kind = qdata.typ%10

    local color = ""
    if count>0 then
        color="|cff40ff40"
    elseif kind==2 then -- kill quest
        color = "|cffb0b0ff"
    end

    if option_entry.iconid ~= DF_IconType_GrayQuest then
        if DailyNotes.IsPublicQuest(qdata) then
            option_entry.iconid = 70
        else
            option_entry.iconid = DF_IconType_RepeatQuest
        end
    end

    option_entry.title = color.."["..qdata.lvl.."] "..TEXT("Sys"..QID.."_name").." ("..DailyNotes.MakeItemCountString(qdata,itemcounts)..")"

    if qdata.typ>20 and DN_Options.debug then
        option_entry.title= "|cffffffff"..option_entry.title
    end

end

function DailyNotes.SF_ColorFinishedQuest(option_entry, detail, QID, qdata)
    local count, itemcounts = DailyNotes.GetQuestItems(qdata)

    if DailyNotes.IsPublicQuest(qdata) then
        option_entry.iconid = 71
    else
        option_entry.iconid = DF_IconType_RepeatQuestDone
    end
    option_entry.title= "|cff40ff40"..TEXT("Sys"..QID.."_name")

    kind = qdata.typ%10
    if kind ~= 2 and count>0 then
        option_entry.title= option_entry.title.." ("..DailyNotes.MakeItemCountString(qdata,itemcounts)..")"
    end
end

function DailyNotes.SF_IsAnAutoQuest(QID)
    local options = DN_Char_Options

    return options.autoquest       -- auto quest enabled
       and options.aq_accept
       and options.aq_accept[QID]  -- quest marked for autoquest
end

function DailyNotes.SF_IsAutoAcceptNewQuest(QID, count, qdata)

    if DailyNotes.SF_IsAnAutoQuest(QID) then

        -- enough material
        local kind = qdata.typ%10
        if kind==1 and count<1 and DN_Options.takefilter then
            return false
        end

        return true
    end
end



function DailyNotes.SF_AutoProcessQuest(in_detail_view, do_quest)

  if not do_quest then return end

  -- catch: 30 quest open
  if do_quest.type==DF_IconType_NewQuest and (g_NumTotalQuest or 0) >=30 then
    DEFAULT_CHAT_FRAME:AddMessage(DailyNotes.L.ERR_QUESTS,1,0,0)
    return
  end

  -- catch: phase
  if do_quest.type==DF_IconType_FinishedQuest and do_quest.eng > 0 then
    local pef1 = PEFs_Item1_Info_PH_Text and PEFs_Item1_Info_PH_Text:GetText()
    if pef1==TEXT("SC_ZONE_PE_Z21_PHNAME01") then
      DEFAULT_CHAT_FRAME:AddMessage(TEXT("SC_ZONE_PE_Z21_PHNAME01"),1,0,0)
      return
    end
  end

  if in_detail_view then
      if do_quest.type==DF_IconType_NewQuest then
          AcceptQuest()
      else
          CompleteQuest()
      end
      SpeakFrame_Hide()
  else
      -- request detail view
      DailyNotes.execute_quest_type=do_quest.type
      OnClick_QuestListButton(do_quest.type, do_quest.index)
  end
end



-----------------------------------------------------------------------
-- interactions
-----------------------------------------------------------------------

function DailyNotes.OnLoad(this)
    DailyNotes.InitDialog()

    this:RegisterEvent("VARIABLES_LOADED")
end

function DailyNotes.OnEvent(event)
  if DailyNotes[event] then DailyNotes[event](arg1) end
end

function DailyNotes.VARIABLES_LOADED()

    DailyNotes.Quest_count = Nyx.TableSize(DailyNotes.DB_Quests)

    SaveVariables("DN_Options")
    SaveVariablesPerCharacter("DN_Options_Of_Char")

    DailyNotes.UpdateOptionsOfOldVersions()

    DailyNotes.RegisterIn3rdPary()

    -- check quest zones (if not european server)
    for id,d in pairs(DailyNotes.DB_Quests) do
        if not GetZoneLocalName(d.zone) then
            DailyNotes.DB_Quests[id]=nil
        end
    end

    -- Register Events
    DailyNotesFrame:RegisterEvent("BAG_ITEM_UPDATE")
    DailyNotesFrame:RegisterEvent("LOADING_END")
    -- these are for tracking the dailies-done-counter
    DailyNotesFrame:RegisterEvent("QUEST_MSG_DAILYRESET")     -- never tested if this event is really fired
    DailyNotesFrame:RegisterEvent("QUEST_MSG_DAILY_OVERDONE") -- never tested if this event is really fired
    DailyNotesFrame:RegisterEvent("RESET_QUESTTRACK") -- it's triggered for everything

    -- enable/disable mob tooltip
    DailyNotes.EnableUnitTooltip(DN_Options.TT_mobs)
    DailyNotes.EnableLootMessage(DN_Options.itemcount)
end

function DailyNotes.RegisterIn3rdPary()
    DailyNotes.RegisterInAddonManager()
    DailyNotes.RegisterInAdvancedAuctionHouse()
    DailyNotes.RegisterInZBag()
end

function DailyNotes.RegisterInAddonManager()

    if AddonManager then
        local addon = {
            name         = "DailyNotes",
            description  = "Detailed information for daily-quest items.",
            author       = "McBen, rv55",
            icon         = "interface/AddOns/dailynotes/icon.dds",
            category     = "Inventory",
            slashCommand = "/dn",
            version      = DailyNotes.VERSION,
            configFrame  = DailyNotesFrame,
            miniButton   = DailyNotesMiniButton,
        }
        AddonManager.RegisterAddonTable(addon)
    end

end

function DailyNotes.RegisterInAdvancedAuctionHouse()
    local fct

    -- v3
    if AAH and AAH.FiltersRegister then
        fct = AAH.FiltersRegister
    -- pre v3
    elseif AAHFunc and AAHFunc.FiltersRegister then
        fct = AAHFunc.FiltersRegister
    end

    if fct then fct({coms = "$dn,$daily", func = DailyNotes.AAH_Filter, desc=DailyNotes.L.AAHFILTER}) end
end

function DailyNotes.AAH_Filter(param, auction_entry)
    if not auction_entry or not auction_entry.itemid then return true end

    local _,quest_data = DailyNotes.FindQuestForItem(auction_entry.itemid)
    if not quest_data or quest_data.type==3 then return false end

    local min_xp =param[2] and tonumber(string.match(param[2], "%d+"))
    local max_lvl=param[3] and tonumber(string.match(param[3], "%d+"))

    if min_xp and quest_data.rew[1] < min_xp then return false end
    if max_lvl and quest_data.rlvl >= max_lvl then return false end

    return true
end

function DailyNotes.RegisterInZBag()

    if ZBag_IsDailyItem then

        local ori_fct = ZBag_IsDailyItem
        ZBag_IsDailyItem = function (index)

            if not DN_Options.ZBag_Hook then   return ori_fct(index)  end

            if ori_fct(index) then return true  end

            return DailyNotes.FindQuestForItem( Nyx.GetBagItem(index) or -1 )
        end
    end

end


function DailyNotes.UpdateOptionsOfOldVersions()

  local version= Nyx.VersionToNumber( DN_Options.version )

  -- pre 1.7.0
  if version<10700 then
    -- delete old quest
    for name,data in pairs(DN_Options) do
      if type(data)=="table" then
        if string.find(name,".*%s+(%w*):(%w*)$") then
          DN_Options[name]=nil
        end
      end
    end

    -- convert names to ID
    for n,data in pairs(DN_Options) do
      if type(data)=="table" and data.aq_accept then

        data.FilterZoneName=nil
        local new_data={}
        for name,val in pairs(data.aq_accept) do
          local QID = DailyNotes.FindQuestByName(name)
          if val and QID then
            new_data[QID]=1
          end
        end
        data.aq_accept=new_data
      end
    end
  end

  if version<10806 then
    DN_Options.disabled = nil  -- removed in 1.8.6
  end

  if version<10900 then
    DN_Options.QuestsText = nil     -- removed in 1.9
    DN_Options.verbose_quest = true -- reset to true
    DN_Options.TT_mobs  = true   -- new
    DN_Options.TT_items = true   -- new
    DN_Options.TT_dialog= true   -- new
  end

  if version<10903 then
    DN_Options.itemcount = not DN_Options.noitemcount   -- renamed
    DN_Options.noitemcount = nil
  end

  if version<40001 then
    DN_Options.ZBag_Hook = true -- new
  end

  if not DN_Options.filter then
    -- new filters
    DN_Options.filter = { repeatable=true, epic=true, daily=true, public=true }
  end

  if version<60002 then
    -- new filters
    DN_Options.filter.energy=true
    DN_Options.filter.xp=true
  end

  DailyNotes.FilterOptionsMenu_Validate(hint)

  DN_Options.version = DailyNotes.VERSION
end


function DailyNotes.LOADING_END()

    -- Copy old data into per_char options
    local realm = Nyx.GetCurrentRealm()
    if not DN_Options_Of_Char[realm] or Nyx.TableSize(DN_Options_Of_Char[realm])==0 then
        local charname = Nyx.GetUniqueCharname()
        DN_Options_Of_Char[realm] = DN_Options[charname] or {}
        DN_Options[charname] = nil
    end
    DN_Char_Options = DN_Options_Of_Char[realm]

    --[===[@debug@
    if DailyNotes.TestDB and DN_Options.debug then
        DailyNotes.TestDB()
        DailyNotes.TestDB=nil
    end
    --@end-debug@]===]
end


function DailyNotes.BAG_ITEM_UPDATE()
  if DailyNotesFrame:IsVisible() then
    local WaitTimer = LibStub("WaitTimer")
    WaitTimer.Delay(0.5, DailyNotes.UpdateList)
  end
end

function DailyNotes.sw_out(name,value)
  o = "disabled"
  if value then o="enabled" end
  DEFAULT_CHAT_FRAME:AddMessage("DailyNotes "..name..": ".. o)
end



SLASH_DailyNotes1 = "/dailynotes"
SLASH_DailyNotes2 = "/dn"
SlashCmdList["DailyNotes"] = function (editBox, msg)

    -- No command means show the UI
    if ( not msg or msg == "" ) then
        ToggleUIFrame(DailyNotesFrame)
        return;
    end

    local cmds={}
    for cm in string.gmatch(string.lower(msg), "%a+") do table.insert(cmds,cm) end

    local help = nil
    for i = 1,table.getn(cmds) do
        fl = string.sub(cmds[i],1,1)
        if fl == 'd' then
            DN_Options.debug = not DN_Options.debug
            DailyNotes.sw_out("DEBUG",DN_Options.debug)

        elseif fl == 'a' then
            DN_Char_Options.autoquest = not DN_Char_Options.autoquest
            DailyNotes.sw_out("Auto-Quest-Taker",DN_Char_Options.autoquest)

        elseif fl == 'v' then
            DN_Options.verbose = not DN_Options.verbose
            DailyNotes.sw_out("VERBOSE",DN_Options.verbose)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Unknown switch "..cmds[i])
            help = true
         end
    end

    if help then
        DEFAULT_CHAT_FRAME:AddMessage("|cffa0a0ffDailyNotes |cffe0e0e0"..DailyNotes.VERSION)
        DEFAULT_CHAT_FRAME:AddMessage("switches are:")
        DEFAULT_CHAT_FRAME:AddMessage(" d for debug")
        DEFAULT_CHAT_FRAME:AddMessage(" a for auto-quest-taker")
        DEFAULT_CHAT_FRAME:AddMessage(" v for more information")
    end

end







