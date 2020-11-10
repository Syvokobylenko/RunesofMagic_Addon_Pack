-----------------------------------------------------------------------------
--  DailyNotes - Tooltips
-----------------------------------------------------------------------------

local Nyx = LibStub("Nyx")
local DailyNotes = _G.DailyNotes

DailyNotes.orig_GameTooltipHyperLinkSetHyperLink = GameTooltipHyperLink["SetHyperLink"]
DailyNotes.orig_GameTooltipSetHyperLink = GameTooltip["SetHyperLink"]
DailyNotes.orig_GameTooltipSetBagItem = GameTooltip["SetBagItem"]
DailyNotes.orig_GameTooltipSetBankItem = GameTooltip["SetBankItem"]
DailyNotes.orig_GameTooltipSetAuctionBrowseItem = GameTooltip["SetAuctionBrowseItem"]
DailyNotes.orig_GameTooltipSetBootyItem = GameTooltip["SetBootyItem"]
DailyNotes.orig_GameTooltipSetActionItem=GameTooltip["SetActionItem"]
DailyNotes.orig_GameTooltipSetHouseItem= GameTooltip["SetHouseItem"]

-- hooks
function GameTooltip:SetBankItem( BankId )
    DailyNotes.orig_GameTooltipSetBankItem( self, BankId )
    DailyNotes.AppendTooltipText( self, GetBankItemLink( BankId ) )
end

function GameTooltip:SetBagItem( BankId )
    DailyNotes.orig_GameTooltipSetBagItem( self, BankId )
    DailyNotes.AppendTooltipText( self, GetBagItemLink( BankId ) )
end

function GameTooltip:SetHouseItem( ParentDBID, ButtonId )
    DailyNotes.orig_GameTooltipSetHouseItem( self, ParentDBID, ButtonId );

    if ( ParentDBID ) then
        DailyNotes.AppendTooltipText( self, Houses_GetItemLink( ParentDBID, ButtonId ) )
    end
end

function GameTooltip:SetHyperLink( itemLink )
    DailyNotes.orig_GameTooltipSetHyperLink( self, itemLink )
    DailyNotes.AppendTooltipText( self, itemLink )
end

function GameTooltipHyperLink:SetHyperLink( itemLink )
    DailyNotes.orig_GameTooltipHyperLinkSetHyperLink( self, itemLink )
    DailyNotes.AppendTooltipText( self, itemLink )
end

function GameTooltip:SetAuctionBrowseItem(id)
    DailyNotes.orig_GameTooltipSetAuctionBrowseItem(self, id)
    DailyNotes.AppendTooltipText( self, GetAuctionBrowseItemLink(id) )
end

function GameTooltip:SetBootyItem(id)
    DailyNotes.orig_GameTooltipSetBootyItem(self, id)
    DailyNotes.AppendTooltipText( self, GetBootyItemLink(id) )
end

-- main
function DailyNotes.AppendTooltipText(tooltip, itemLink )

    if not itemLink then return  end

    if not DN_Options.TT_items and not DailyNotes.InDialogTT then return end


    local itemid = Nyx.GetItemID(itemLink)
    local QID,quest
    if tooltip.QID then
        QID = tooltip.QID
        quest = DailyNotes.DB_Quests[QID]
    else
        QID,quest = DailyNotes.FindQuestForItem(itemid)
    end

    if QID then

        DailyNotes.AppendItemCount(tooltip, itemid, quest )
        DailyNotes.AppendQuestName(tooltip, QID, quest )
        DailyNotes.AppendQuestNPC(tooltip, quest)
        DailyNotes.AppendQuestText(tooltip, QID)
        DailyNotes.AppendReward(tooltip, quest)
        DailyNotes.AppendPrequest(tooltip, quest)
        DailyNotes.AppendInvolvedMobs(tooltip, quest)

        -- Debug flag
        if DN_Options.debug and quest.typ>20 then
          tooltip:AddLine( "|cffff0000(--UNTESTED-- Plz report)")
        end

    else
        if DN_Options.debug then
            tooltip:AddLine( "\n|cff909090ItemID: " .. Nyx.GetItemID(itemLink));
        end
    end
end

function DailyNotes.GetQuestTaker(qdata)
    local taker = qdata.taker or qdata.giver
    if type(taker)=="table" then
        return taker[1]
    end
    return taker
end

function DailyNotes.AppendItemCount(tooltip, itemid, quest )
    local max_completed, itemcounts = DailyNotes.GetQuestItems(quest)

    local taker = DailyNotes.GetQuestTaker(quest)
    tooltip:AddLine( "\n|cffFCCF00".. string.format(DailyNotes.L.COUNT, itemcounts[itemid], quest.items[itemid], DailyNotes.GetNPCInfo(taker))) -- "8/10 for questname"

    if (max_completed>0) then
        tooltip:AddLine( string.format(DailyNotes.L.FIN, max_completed)) -- "Enough for: %i times"
    else
        local needs = quest.items[itemid]-itemcounts[itemid]
        if needs<0 then
            tooltip:AddLine( string.format(DailyNotes.L.NEEDSOTHER)) -- "Needs other item"
        else
            tooltip:AddLine( string.format(DailyNotes.L.NEED, needs)) -- "Needs: %i"
        end
    end

    for id,count in pairs(itemcounts) do
        if id~=itemid then
            tooltip:AddLine( "|cffFCCF60+ ".. string.format("%i/%i %s", count, quest.items[id], TEXT("Sys"..id.."_name"))) -- "+8/10 Item"
        end
    end

end

function DailyNotes.AppendQuestName(tooltip, QID, quest)
    local color = ""
    local mlvl, slvl = Nyx.GetPlayerLevel()
    if (quest.lvl > mlvl) then
        color = "|cffff0000"
        if (quest.lvl <= slvl) then
            color = "|cffff8080"
        end
    end
    tooltip:AddLine( color .. TEXT("Sys"..QID.."_name") .. " (Lvl " .. quest.lvl .. ")");
end

function DailyNotes.AppendQuestNPC(tooltip, quest)

    -- Where to get it
    local qtaker = DailyNotes.GetQuestTaker(quest)
    local last_start = nil

    local givers = quest.giver or {}
    if type(givers)=="number" then givers={givers} end

    for _,value in ipairs(givers) do
      local n_name,n_map,n_posx,n_posy,n_altname = DailyNotes.GetNPCInfo(value)

      if n_name ~= last_start then

        if value == qtaker then
          tooltip:AddLine( string.format(DailyNotes.L.QSTARTEND, n_name)) -- Start: %s
          qtaker = nil
        else
          tooltip:AddLine( string.format(DailyNotes.L.QSTART, n_name)) -- Start: %s
        end

        if DN_Options.verbose or DailyNotes.InDialogTT then
          n_altname = n_altname or GetZoneLocalName(n_map)
          tooltip:AddLine( string.format(DailyNotes.L.QPOS, n_altname,n_posx,n_posy)) -- (%s: %g/%g)
        end
        last_start = n_name
      end
    end

    -- reward npc
    if qtaker and (DN_Options.verbose or DailyNotes.InDialogTT) then
      local n_name,n_map,n_posx,n_posy,n_sub = DailyNotes.GetNPCInfo(qtaker)

      tooltip:AddLine( string.format(DailyNotes.L.QEND, n_name)) -- Start: %s
      if DN_Options.verbose or DailyNotes.InDialogTT then
        n_altname = n_altname or GetZoneLocalName(n_map)
        tooltip:AddLine( string.format(DailyNotes.L.QPOS, n_altname,n_posx,n_posy)) -- (%s: %g/%g)
      end
    end
end

function DailyNotes.AppendQuestText(tooltip, QID)
    if DailyNotes.InDialogTT and DN_Options.verbose_quest then
        local text = Nyx.GetQuestBookText(QID)
        if text then
            tooltip:AddLine("\n")
            tooltip:AddLine(text)
            tooltip:AddLine("\n")
        end
    end
end

function DailyNotes.AppendReward(tooltip, quest)
    -- XP/Gold/Token (Note: TPs=floor(XP/10))
    tooltip:AddLine( string.format(DailyNotes.L.XP, quest.rew[1],quest.rew[2],quest.rew[3])) -- XP: %i   Gold/Token: %i/%i
    if quest.rew[4] and quest.rew[4]>0 then
        tooltip:AddLine( string.format(DailyNotes.L.ENERGY, quest.rew[4])) -- Energy: %i
    end
end

function DailyNotes.AppendInvolvedMobs(tooltip, quest)

    if not DN_Options.debug or not quest.mobs then
        return
    end

    local mobs={}
    for mobid,val in pairs(quest.mobs) do
        if mobid and type(mobid)=="number" and ( NpcTrack_SearchNpcByDBID( mobid ) >0 )then
            local _, n_name, _, _, _ = NpcTrack_GetNpc(1)
            if n_name then
                table.insert(mobs,n_name)
            end
        end
    end

    if #mobs>0 then
        tooltip:AddLine("\nInvolved NPCs:")
        for _,n in pairs(mobs) do
            tooltip:AddLine("  "..n)
        end
    end
end

function DailyNotes.AppendPrequest(tooltip, quest)

    local preq = DailyNotes.GetRequiredPreQuest(quest)
    if not preq then return end

    for _,qid in ipairs(preq) do
        if CheckQuest(qid)~=2 then
            tooltip:AddLine( DailyNotes.L.PREQUEST .. TEXT("Sys"..qid.."_name"),1,0,0)
        else
            tooltip:AddLine( DailyNotes.L.PREQUEST .. TEXT("Sys"..qid.."_name"),0.6,0.6,0.6)
        end
    end
end

function DailyNotes.GetRequiredPreQuest(quest)

    local preq = quest.preq
    if not preq then return end

    if type(preq)=="number" then preq={preq} end

    local res = {}
    for _,qid in ipairs(preq) do
        if CheckQuest(qid)~=2 or DailyNotes.DB_Quests[qid] then
            table.insert(res,qid)
        end
    end

    if table.getn(res)>0 then
        return res
    end
end


function GameTooltip:SetActionItem(m_ButtonId)
    local result=DailyNotes.orig_GameTooltipSetActionItem (self,m_ButtonId)
    local icon_path = GetActionInfo(m_ButtonId)
    if icon_path then
      local itemname = _G[GameTooltip:GetName() .. "TextLeft1"]:GetText()
      if itemname then
        local iidx=Nyx.FindBagIndex(itemname,icon_path)
        if iidx then
            DailyNotes.AppendTooltipText( self, GetBagItemLink( iidx ) )
        end
      end
    end
    return result;
end
----------------------------------------
function DailyNotes.EnableUnitTooltip(enable)

    enable = enable or false
    if (DailyNotes.UnitToolTipIsEnabled or false) == (enable or false) then return end

    if enable then
        DailyNotes.UnitTooltipActivate()
    else
        DailyNotes.UnitTooltipDeactivate()
    end

    DailyNotes.UnitToolTipIsEnabled = enable
end

function DailyNotes.UnitTooltipActivate()

    if pbInfo and pbInfo.Tooltip and pbInfo.Tooltip.Scripts and pbInfo.Tooltip.Scripts.OnUpdate and  -- PBInfo Installed
      pbInfoSettings and pbInfoSettings["ENABLE"] -- PBInfo enabled
      and pbInfoSettings["MODIFYTOOLTIP"]         -- PBInfo tooltip enabled
      then
        DailyNotes.PBinfoHook = pbInfo.Tooltip.Scripts.OnUpdate
        pbInfo.Tooltip.Scripts.OnUpdate = DailyNotes.UPDATE_MOUSEOVER_UNIT
    else
      DailyNotesFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    end

    DailyNotes.DB_Mobs = {}
    for QID,quest in pairs(DailyNotes.DB_Quests) do
      for mobid,val in pairs(quest.mobs or {}) do
        if mobid and (quest.typ%10)~=2 then -- has mob info and is not kill-quest
          local n_name=TEXT("Sys"..mobid.."_name")
            DailyNotes.DB_Mobs[n_name] = DailyNotes.DB_Mobs[n_name] or {}

            if val==0 and quest.items then
                val = next(quest.items)
            end
            DailyNotes.DB_Mobs[n_name][QID]=val
        end
      end
    end
end

function DailyNotes.UnitTooltipDeactivate()
    if DailyNotes.UnitToolTipIsEnabled then
        if DailyNotes.PBinfoHook then
            pbInfo.Tooltip.Scripts.OnUpdate = DailyNotes.PBinfoHook
        else
            DailyNotesFrame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
        end
    end

    DailyNotes.DB_Mobs = nil
end

function DailyNotes.UPDATE_MOUSEOVER_UNIT()

    if DailyNotes.PBinfoHook then
        DailyNotes.PBinfoHook()
    end

    if (not UnitCanAttack("player", "mouseover") or UnitIsPlayer("mouseover")) then
        return
    end

  local Qlist = DailyNotes.DB_Mobs and DailyNotes.DB_Mobs[UnitName("mouseover")]
  if Qlist then

    GameTooltip:AddLine("\n")

    for QID, item_id in pairs(Qlist) do
        local qdata = DailyNotes.DB_Quests[QID]

        -- skip gather quests
        if (qdata.typ%10)~=4 then

            if item_id>1000 then

                local item_count = GetBagItemCount(item_id)
                local item_target_count = qdata.items and qdata.items[item_id]

                GameTooltip:AddLine( string.format(DailyNotes.L.DROPSITEM,TEXT("Sys"..item_id.."_name")) ..
                                 " ("..tostring(item_count) .."/"..tostring(item_target_count)..")")

            else
                GameTooltip:AddLine( string.format(DailyNotes.L.INVOLVED,TEXT("Sys"..QID.."_name")) )
            end
        end
    end
  end

end




