--[[
-- QuestHelper
--
-- Author: McBen
-- (based on QuestWiz by Luivatra)
-- file: QuestHelper
-- desc: main file
--      * init (locales,db,options)
--      * event handling
--      * debug slash commands
--
-- ver:  v7.4.5
-- date: 2020-01-19T8:48:21Z
--
------------------------------------------------------
-- Notes
--
-- Memory usage: (v6.0.8)
 - Quest-DB   = 2.8mb -> only in memory when Quest-List/Detail-Dialog is visible
 - Quest-POS  = 3.9mb -> was 5.8mb before position grouping
 - QID/GID-DB = 2.7mb -> new DB, will replace Quest-POS
]]
local Nyx = LibStub("Nyx")
local WaitTimer = LibStub("WaitTimer")

QH = {
    --[===[@debug@
    VERSION = "v7.5.dev"
    --@end-debug@]===]
    --@non-debug@
  VERSION        = "v7.4.5",
--@end-non-debug@
}

QH_Options = {} -- SaveVar - options

function QH.OnLoad(this)
    QH.L = Nyx.LoadLocalesAuto("Interface/Addons/QuestHelper/Locales/", "en")
    QH.L.SYS_COMPLETE = string.gsub(TEXT("QUEST_MSG_REQUEST_COMPLETE"), "[%(%)%-]", "%%%1")

    QH.Map.Init() -- need early init for unittest

    this:RegisterEvent("VARIABLES_LOADED")
    this:RegisterEvent("SAVE_VARIABLES")
    this:RegisterEvent("LOADING_END")
    -- QUESTS-Events will be registered later to prevent early update calls
end

function QH.RESET_QUESTTRACK()
    QH.QB.RefreshQuestBook()
end

function QH.RESET_QUESTBOOK()
    QH.QB.RefreshQuestBook()
end

function QH.QUEST_COMPLETE()
    -- DailyCount update is delayed
    WaitTimer.Delay(0.5, QH.QT.UpdateTrackerTitle)
end

function QH.OnEvent(event)
    if QH[event] then
        QH[event](QH, arg1)
    end
end

function QH.LOADING_END()
    -- no debug output on load 'cause all quests are "new"
    local td = QH_Options.debug
    QH_Options.debug = false
    QH.QB.RefreshQuestBook()
    QH_Options.debug = td

    QH.QT.UpdateAllGoals()
end

local function OptionVersionUpdate()
    local version = QH_Options.version or 0

    if version < 10000 then
        QH_Options.editor = nil
        QH_Options.navi = true
        QH_Options.tracker = true
        QH_Options.map_all_points = false
        QH_Options.map_full_info = false
        QH_Options.tracker_title = true

        --[===[@debug@
        QH_Options.editor = true
        QH_Options.debug = true
    --@end-debug@]===]
    end

    if version < 50003 then
        QH_Options.tracker_body = true
        QH_Options.tracker_zone_only = nil
    end

    if version < 60006.03 then
        QH_Options.layericons = true
    end

    QH_Options.text_size = QH_Options.text_size or 12
    QH_Options.LineCount = QH_Options.LineCount or 10

    QH_Options.version = Nyx.VersionToNumber(QH.VERSION)
end

local function OnAddonManagerClick(_, key)
    if key == "RBUTTON" then
        ToggleUIFrame(QH_OptionFrame)
    else
        ToggleUIFrame(QHQuestList)
    end
end

local function Register3rdParty()
    -- register in AddonManager
    if AddonManager then
        local addon = {
            name = "QuestHelper",
            version = QH.VERSION,
            description = QH.L.ADDON_DESC,
            author = "McBen",
            icon = "interface/AddOns/questhelper/textures/icon",
            category = "Quest",
            mini_icon = "Interface/Addons/questhelper/textures/icon_mini",
            mini_icon_pushed = "Interface/Addons/questhelper/textures/icon_mini_push",
            mini_onClickScript = OnAddonManagerClick
        }

        AddonManager.RegisterAddonTable(addon)
    else
        QH.API.Print(string.format(QH.L.ADDON_LOADED, QH.VERSION))
    end
end

local function InitOptions()
    SaveVariables("QH_Options")
    OptionVersionUpdate()

    QH.Options.Apply()

    if QH_Options.debug then
        QH.DB.Test()
        QH.Map.Test()
    end
end

function QH.VARIABLES_LOADED()
    QH.DB.Init()
    QH.QT.Init()
    QH.Tracker.Init()
    QH.ListDialog.Init()
    QH.DetailDialog.Init()

    local data_worth = QH.DB.MergeDynData()
    if data_worth > 50 + math.random(100) then
        DEFAULT_CHAT_FRAME:AddMessage(QH.L.YOUVE_NEW_DATA, 0.5, 0.5, 1)
    end

    InitOptions()

    Register3rdParty()

    -- Quest Hyperlinks
    QH.ori_Hyperlink_Assign = Hyperlink_Assign
    Hyperlink_Assign = QH.Hooked_Hyperlink_Assign

    -- Register Quest-Book events
    QuestHelperFrame:RegisterEvent("RESET_QUESTTRACK")
    QuestHelperFrame:RegisterEvent("RESET_QUESTBOOK")
    QuestHelperFrame:RegisterEvent("QUEST_COMPLETE")


    --[===[@debug@
    QH.API.Print("|cffc0c0ffQuestHelper-Debug (use '/qh')")
    --@end-debug@]===]
end

function QH.SAVE_VARIABLES()
    QH.QT.Save()
end

function QH.Hooked_Hyperlink_Assign(link, key)
    QH.ori_Hyperlink_Assign(link, key)
    if key ~= "LBUTTON" then
        return
    end

    local _type, _data = ParseHyperlink(link)
    local QID = tonumber(_data or "", 16)
    if _type ~= "quest" or not QID then
        return
    end

    local txt = {}

    local GIDs = QH.DB.GetGoals(QID)
    for _, GID in ipairs(GIDs) do
        local goalText = TEXT("Sys" .. GID .. "_name")
        local map, x, y = QH.DB.GetBestPosition(GID)
        if map then
            goalText = string.format("%s - %s %g/%g", goalText, GetZoneLocalName(map), x * 100, y * 100)
        end

        table.insert(txt, goalText)
    end

    if IsShiftKeyDown() then
        if ITEMLINK_EDITBOX then
            ITEMLINK_EDITBOX:InsertText("=> " .. table.concat(txt, "\n"))
        end
    else
        GameTooltipHyperLink:AddLine("\n")
        for _, t in ipairs(txt) do
            GameTooltipHyperLink:AddLine(t)
        end
    end
end

function QH.ResizeSpeakFrame(newheight)
    newheight = newheight or 480
    SpeakFrame:SetHeight(newheight)
    SpeakFrameDetailScrollFrame:SetHeight(newheight - 80)
    SpeakFrameDetailScrollFrame_ScrollFrame:SetHeight(newheight - 80)
    SpeakFrameTexture:SetHeight(newheight - 30)
    SpeakFrameDetailScrollFrame:UpdateScrollChildRect()
end

function QH.GetSpeakFrameSize()
    local _, top = SpeakFrameDetailScrollFrame:GetPos()
    local _, bottom = SpeakFrame_Option1:GetPos()
    for i = 1, DF_MAX_SPEAKOPTION do
        local f = _G["SpeakFrame_Option" .. i]
        if f:IsVisible() then
            _, bottom = f:GetPos()
            local _, sy = f:GetSize()
            bottom = bottom + sy
        end
    end

    return (bottom - top + 80) / GetUIScale()
end

local ori_SpeakFrame_Show = SpeakFrame_Show
function SpeakFrame_Show()
    ori_SpeakFrame_Show()

    if QH_Options.speakframe and SpeakFrame:IsVisible() then
        local newsize = QH.GetSpeakFrameSize()
        if newsize < 400 then
            newsize = 400
        end

        local maxheight = GetScreenHeight() / GetUIScale()
        if newsize > maxheight * 0.9 then
            newsize = maxheight * 0.9
        end

        local x, y = SpeakFrame:GetAnchorOffset()
        if y + newsize > maxheight then
            SpeakFrame:ClearAllAnchors()
            SpeakFrame:SetAnchor("TOPLEFT", "TOPLEFT", UIParent, x, maxheight - newsize)
        end

        QH.ResizeSpeakFrame(newsize)
    end
end

------------------------------------------------------
-- Slash Commands

--[===[@debug@
SLASH_QuestHelperDebug1 = "/qh"
SlashCmdList["QuestHelperDebug"] = function(_, msg)
    local cmd, param = string.match(msg, "(%S)%S*%s*(.*)")

    if not cmd then
        QH.API.Print("(use '/qh ?' for additional option)")
        cmd = "l"
        param = nil
    end

    if tonumber(cmd) then
        param = cmd
        cmd = "l"
    end

    cmd = cmd:lower()

    if cmd == "l" then
        local num = tonumber(param)
        if num then
            QH.DumpGoalPath(num)
        else
            QH.DumpGoalList()
        end
        return
    elseif cmd == "g" then
        QH.Map.DumpDistanceNodes()
        return
    elseif cmd == "n" then
        QH.Map.DumpNodes()
        return
    elseif cmd == "d" then
        QH.ToggleDebug()
        return
    elseif cmd == "q" then
        QH.DumpQuests()
        return
    end

    QH.API.Print("------- /Qh Commands ------------")
    QH.API.Print("D          -> toggle debug msg on/off (cur: " .. (QH_Options.debug and "ON" or "OFF") .. ")")
    QH.API.Print("L          -> list goals ")
    QH.API.Print("L <number> -> show path to goal")
    QH.API.Print("G          -> show cur. node distances on Map")
    QH.API.Print("N          -> show node on Map")
    QH.API.Print("Q          -> show quest list")
end

function QH.DumpGoalPath(num)
    QH.API.Print("------- Goal Path ------------")

    local g = QH.QT.goal_list[num or 1]
    if not g then
        return
    end

    local qtxt = QH.QB.GetQuestTitle(g.QID)
    local gtxt = QH.QB.GetGoalText(g.QID, g.GID)
    QH.API.Print(string.format("%i: %s/%s d=%s", num, qtxt, gtxt, tostring(g.distance)))

    local res_path = QH.QT.GetPathToGoal(g)
    if g.distance ~= res_path.distance then
        QH.API.Print(string.format("!! DISTANCE DIFF: path-dist=%s", tostring(res_path.distance)))
    end

    for i, link in ipairs(res_path.path or {}) do
        local tzone, tport = QH.Map.GetPathStepTarget(link)
        local zone = GetZoneLocalName(tzone)
        local x, y, dist = QH.Map.GetPorterPos(tzone, tport)
        QH.API.Print(string.format("  %i: %s (%.2f/%.2f) dist=%g", i, zone, x, y, dist))
    end
    QH.API.Print(
        string.format(
            "  n: %s (%.2f/%.2f)",
            GetZoneLocalName(res_path.target.m or 1),
            res_path.target.x or 0,
            res_path.target.y or 0
        )
    )
end

function QH.DumpGoalList()
    QH.API.Print("------- Goal List ------------")

    for i = 1, QH.QT.Count() do
        local QID, GID = QH.QT.GetGoal(i)
        local qtxt = QH.QB.GetQuestTitle(QID)
        local gtxt = QH.QB.GetGoalText(QID, GID)
        local g = QH.QT.goal_list[i]
        QH.API.Print(string.format("%i: %s/%s d=%s", i, qtxt, gtxt, tostring(g.distance)))
    end
end

function QH.ToggleDebug()
    QH_Options.debug = not QH_Options.debug
    QH.API.Print("|cffffffffQW: debug mode is now: " .. (QH_Options.debug and "ON" or "OFF"))
end

function QH.DumpQuests()
    QH.API.Print("------- Quest-List ------------")

    local pmap, px, py = QH.Map.GetPlayerPos()
    if not pmap then
        QH.API.Print(" no player pos = no dist calc")
        return
    end

    local nr = 0
    local last_QID = nil

    QH.QB.ForEachGoal(
        function(QID, GID)
            if QID ~= last_QID then
                last_QID = QID
                nr = nr + 1
            end

            -- finished quest
            if not GID then
                local _npcID, npc_name, npc_mapID, n_x, n_y = QH.QB.GetRewardNPC(QID)
                if _npcID then
                    local src = {x = px, y = py, m = pmap}
                    local res_path = QH.Map.CalculatePath(src, {[npc_mapID] = {{n_x, n_y}}})

                    QH.API.Print(
                        string.format(
                            "%i: %s/%i -> FINISHED - reward at %s Dist=%s",
                            nr,
                            QH.QB.GetQuestTitle(QID),
                            QID,
                            npc_name,
                            tostring(res_path and res_path.distance)
                        )
                    )
                else
                    QH.API.Print(string.format("%i: %s/%i -> FINISHED - !NO NPC!", nr, QH.QB.GetQuestTitle(QID), QID))
                end
            else
                -- Quest goals
                if new_quest then
                    local _npcID, npc_name = QH.QB.GetRewardNPC(QID)

                    QH.API.Print(
                        string.format(
                            "%i: %s/%i: (rew_npc=%s-%s)",
                            nr,
                            QH.QB.GetQuestTitle(QID),
                            QID,
                            tostring(_npcID),
                            tostring(npc_name)
                        )
                    )

                    QH.QB.ForEachFinishedGoal(
                        QID,
                        function(GID)
                            local gtxt = QH.QB.GetGoalText(QID, GID)
                            QH.API.Print("|cffffff40 " .. GID .. "/" .. gtxt .. " (finished)")
                        end
                    )
                end

                local src = {x = px, y = py, m = pmap}
                local gtxt, _, gcount = QH.QB.GetGoalText(QID, GID)

                if QH.DB.HasData(GID) then
                    local distance = QH.Map.CalculateDistance(src, QH.DB.GetMaps(GID))
                    QH.API.Print(
                        "|cffffff40 " ..
                            GID .. "/" .. gtxt .. "=" .. tostring(gcount) .. "/n Dist=" .. tostring(distance)
                    )
                else
                    local _m, n_x, n_y = QH.QB.GetCatalogPos(QID)
                    if _m then
                        local distance = QH.Map.CalculateDistance(src, {[_m] = {{n_x, n_y}}})
                        QH.API.Print(
                            "|cffffff40 " ..
                                GID ..
                                    "/" ..
                                        gtxt ..
                                            "=" ..
                                                tostring(gcount) ..
                                                    "/n Dist=" .. tostring(distance) .. "(map suggestion)"
                        )
                    else
                        QH.API.Print("|cffff0000 no known goal and unknown cat")
                    end
                end
            end
        end
    ) -- for each Goal
end

--@end-debug@]===]

