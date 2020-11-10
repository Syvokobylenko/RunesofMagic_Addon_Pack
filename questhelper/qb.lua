------------------------------------------------------
-- QuestHelper
--
-- file: QB
-- desc: our Questbook copy
--      * converts questbook into QID + GID's instead of texts
--      * tracks quest changes (incl. new/removed quest)
--      * (also triggers DB.AddNewQuestPos on quest process)
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2020-03-29T14:20:06Z
------------------------------------------------------

local QB = {
    DoingNameSearch = nil
}

local QuestBook = {}
-- Fomat:
--  [qid]={        Quest-ID
--    book_id      id in quest book
--    catalog_id
--    finished     true if finished
--    last_update  timestamp of last update
--    daily
--    rew_npc_id   reward npc..can be nil
--    goals= { [gid]= {finished,name,gcount,tcount} }

local stamp = 1 -- update counter

_G.QH.QB = QB

local COL_NPC = "|cffffff00"

local Nyx = LibStub("Nyx")

-- compare Goal name
local function CompareGoalName(kgName, id)
    local name = TEXT(string.format("Sys%i_name", id))
    if kgName == name then
        return true
    end

    if id > 200000 then
        if kgName == TEXT("Q_REQUEST_ITEMSTR_01") .. name or kgName == TEXT("Q_REQUEST_ITEMSTR_02") .. name then
            return true
        end
        -- BUG: RoM-Bug additional spaces in string
        local n1 = string.format("%s %s", TEXT("Q_REQUEST_ITEMSTR_01"), name)
        local n2 = string.format("%s %s", TEXT("Q_REQUEST_ITEMSTR_02"), name)
        if kgName == n1 or kgName == n2 then
            return true
        end
    elseif id > 100000 then
        if kgName == TEXT("Q_REQUEST_KILLSTR_01") .. name or kgName == TEXT("Q_REQUEST_KILLSTR_02") .. name then
            return true
        end
        -- BUG: RoM-Bug additional spaces in string
        local n1 = string.format("%s %s", TEXT("Q_REQUEST_KILLSTR_01"), name)
        local n2 = string.format("%s %s", TEXT("Q_REQUEST_KILLSTR_02"), name)
        if kgName == n1 or kgName == n2 then
            return true
        end
    end

    name = TEXT("Sys" .. id .. "_name_plural")
    if kgName == name then
        return true
    end

    if id > 200000 then
        if kgName == TEXT("Q_REQUEST_ITEMSTR_01") .. name or kgName == TEXT("Q_REQUEST_ITEMSTR_02") .. name then
            return true
        end
        -- BUG: RoM-Bug additional spaces in string
        local n1 = string.format("%s %s", TEXT("Q_REQUEST_ITEMSTR_01"), name)
        local n2 = string.format("%s %s", TEXT("Q_REQUEST_ITEMSTR_02"), name)
        if kgName == n1 or kgName == n2 then
            return true
        end
    elseif id > 100000 then
        if kgName == TEXT("Q_REQUEST_KILLSTR_01") .. name or kgName == TEXT("Q_REQUEST_KILLSTR_02") .. name then
            return true
        end
        -- BUG: RoM-Bug additional spaces in string
        local n1 = string.format("%s %s", TEXT("Q_REQUEST_KILLSTR_01"), name)
        local n2 = string.format("%s %s", TEXT("Q_REQUEST_KILLSTR_02"), name)
        if kgName == n1 or kgName == n2 then
            return true
        end
    end
end

----------------------------------------
local function ParseGoals(i, QID)
    local GOALS = {}

    local numGoals = GetQuestRequest(i, -1)
    for j = 1, numGoals do
        repeat
            local _goalName, _isFinished = GetQuestRequest(i, j)
            if not _goalName then
                break
            end
            if _isFinished == 0 then
                _isFinished = nil
            end

            -- remove "complete" text
            local kgName = string.gsub(_goalName, QH.L.SYS_COMPLETE, "")

            -- replace counter
            local goal_count, target_count = string.match(kgName, "%s(%d+)/(%d+)%s*$")
            if goal_count then
                kgName = string.gsub(kgName, "%s%d+/%d+%s*$", "")
            end

            -- trim
            kgName = string.match(kgName, "^%s*(.-)%s*$")
            _goalName = string.match(_goalName, "^%s*(.-)%s*$")

            local GID = nil
            local allGIDs = QH.DB.GetGoals(QID)
            for _, GD in ipairs(allGIDs) do
                if CompareGoalName(kgName, GD) then
                    GID = GD
                    break
                end
            end

            if not GID then
                if #allGIDs == 1 then
                    GID = allGIDs[1]
                    QH.API.Debug(
                        "Quest-Goal unknown: '" .. kgName .. "' using: " .. GID .. "/" .. TEXT("Sys" .. GID .. "_name")
                    )
                else
                    -- last chance: full search
                    if kgName ~= "" and QB.SearchUnkownGoal(QID, kgName) then
                        QH.API.Print(
                            "|cffffff00QH: Quest-Goal unknown: '" .. kgName .. "' Quest=" .. QID .. " (search started)"
                        )
                    end
                    return nil
                end
            end

            GOALS[GID] = {name = _goalName, finished = _isFinished, gcount = goal_count, tcount = target_count}
        until true
    end

    return GOALS
end

local function OnQuestFinished(QID)
    QH.QT.OnGoalAdded(QID)
end

local function OnNewQuest(i, QID)
    local _, _CatalogID, _QuestName, _, _QuestLV, _Daily, _, _, QID, _, Qgroup = GetQuestInfo(i)
    QH.API.Debug("Quest added: " .. _QuestName .. "(" .. QID .. ")")

    ViewQuest_QuestBook(i) -- since this only happens after npc-dialg it should be safe here
    local _npcID = QuestDetail_GetRequestQuestNPC()
    local _exp = GetQuestExp_QuestDetail()
    local _tp = GetQuestTP_QuestDetail()
    local _money = GetQuestMoney_QuestDetail()

    QH.DB.StoreStartNPC(QID, QuestDetail_GetQuestNPC())

    if Qgroup == 3 then
        _Daily = 3
    end

    QuestBook[QID] = {
        book_id = i,
        level = _QuestLV,
        daily = _Daily,
        catalog_id = _CatalogID,
        rew_npc_id = _npcID,
        reward_exp = _exp,
        reward_tp = _tp,
        reward_gold = _money,
        goals = {}
    }

    QH.QT.UpdateTrackerTitle()
end

local function OnNewGoal(QID, GID, gdata)
    QH.API.Debug("Quest goal added: " .. gdata.name)
    QuestBook[QID].goals[GID] = gdata
    if not gdata.finished then
        QH.QT.OnGoalAdded(QID, GID)
    end
end

local function OnGoalFinished(QID, GID, gdata)
    QH.API.Debug("Quest-Goal finished: " .. gdata.name)
    QuestBook[QID].goals[GID].finished = gdata.finished
    if gdata.finished then
        QH.QT.OnGoalRemoved(QID, GID)
    else
        QH.QT.OnGoalAdded(QID, GID)
    end
end

local function OnGoalChanged(QID, GID, gdata)
    local curQ = QuestBook[QID]

    QH.API.Debug(
        "Quest-Goal changed: " ..
            gdata.name .. " (count was=" .. tostring(curQ.goals[GID].gcount) .. " new=" .. tostring(gdata.gcount) .. ")"
    )

    -- add to DB (only if count is increased)
    if not curQ.goals[GID].gcount or not gdata.gcount or gdata.gcount > curQ.goals[GID].gcount then
        -- test/store new found target data
        if QH.DB.AddNewQuestPos(QID, GID) then
            QH.API.Debug("new data added")
        end
    end

    curQ.goals[GID].name = gdata.name
    curQ.goals[GID].gcount = gdata.gcount

    QH.QT.OnGoalUpdate(QID, GID)
end

local function OnQuestRemoved(QID)
    QH.API.Debug("Quest remove: " .. (QB.GetQuestTitle(QID)))

    local id, name
    if QuestBook[QID].rew_npc_id then
        id, name = QH.Map.GetNPCInfo(QuestBook[QID].rew_npc_id)
    end

    if not id then
        if CheckQuest(QID) > 0 then
            local id = QB.GetRewardNPC(QID)
            if not id then
                QH.API.Debug("Reward position stored")
                QH.DB.StoredRewardNPCCurPos(QID)
            end
        end
    end

    QH.QT.OnQuestRemoved(QID)

    QuestBook[QID] = nil
end

local function AddFakeQuests()
    local fake_quests = {}
    for _, QID in ipairs(QH.DB.GetQIDs()) do
        local goals = QH.DB.GetGoals(QID)
        for GID, gdata in pairs(goals) do
            if QH.DB.GetMaps(GID)[27] then
                table.insert(fake_quests, QID)
                break
            end
        end
    end

    for _, QID in ipairs(fake_quests) do
        if not QuestBook[QID] then
            QuestBook[QID] = {
                book_id = 1,
                level = 1,
                daily = true,
                catalog_id = 1,
                rew_npc_id = nil,
                reward_exp = 0,
                reward_tp = 0,
                reward_gold = 0,
                goals = {}
            }
        end

        local curQ = QuestBook[QID]
        curQ.book_id = QID
        curQ.last_update = stamp

        for _GID in pairs(QH.DB.GetGoals(QID)) do
            GOALS[GID] = {name = "_" .. GID, finished = false, gcount = 0, tcount = 10}
        end

        for GID, gdata in pairs(GOALS) do
            if not curQ.goals[GID] then
                OnNewGoal(QID, GID, gdata)
            end
        end
    end
end

-- Scan quest
-- ( call everytime when quest book changed )
--  * copy to internal struct
--  * add new data
function QB.RefreshQuestBook()
    stamp = stamp + 1

    local numQuests = GetNumQuestBookButton_QuestBook()
    for i = 1, numQuests do
        repeat -- just a 'continue' wrapper
            local _, _CatalogID, _QuestName, _, _QuestLV, _Daily, _, _, QID, _Finished = GetQuestInfo(i)

            --------------------------------------------
            local GOALS = ParseGoals(i, QID)
            if not GOALS then
                break
            end

            ------------------
            -- is new quest?
            if not QuestBook[QID] then
                OnNewQuest(i, QID)
            end

            local curQ = QuestBook[QID]
            curQ.book_id = i
            curQ.last_update = stamp

            ------------------
            -- GOALS
            for GID, gdata in pairs(GOALS) do
                if not curQ.goals[GID] then
                    OnNewGoal(QID, GID, gdata)
                end

                if curQ.goals[GID].name ~= gdata.name then
                    OnGoalChanged(QID, GID, gdata)
                end

                if curQ.goals[GID].finished ~= gdata.finished then
                    OnGoalFinished(QID, GID, gdata)
                end
            end -- for numGoals

            -- is finished?
            if curQ.finished ~= _Finished then
                curQ.finished = _Finished
                if _Finished then
                    OnQuestFinished(QID)
                end
            end
        until true
    end -- for numQuests

    -- Quest Fake:
    --AddFakeQuests()

    -- delete removed quests
    for k, v in pairs(QuestBook) do
        if v.last_update ~= stamp then
            OnQuestRemoved(k)
        end
    end
end

----------------------------------------
function QB.SearchUnkownGoal(QID, GOAL)
    QB.GoalSearch = QB.GoalSearch or {}
    for _, v in ipairs(QB.GoalSearch) do
        if v.QID == QID and v.GOAL == GOAL then
            return
        end
    end
    table.insert(QB.GoalSearch, {QID = QID, GOAL = GOAL})
    QB.DoingNameSearch = true
    return true
end

function QB.ContinueNameSearch(elapsedTime)
    if not QB.GoalSearch or #QB.GoalSearch < 1 then
        QB.GoalSearch = nil
        QB.DoingNameSearch = nil
        return
    end

    local entry = QB.GoalSearch[1]
    entry.id = entry.id or 100000

    -- search deep depends on performance
    local updatecount = 1000 * (1 - elapsedTime / 0.4)
    if updatecount < 10 then
        updatecount = 10
    end
    --QH.API.Debug("|cffffff00Searching: "..updatecount)
    for i = 1, updatecount do
        if CompareGoalName(entry.GOAL, entry.id) then
            QH.API.Debug("|cffffff00found GID by full search: " .. entry.GOAL .. "=" .. entry.id)
            QH.DB.QuestFound(entry.QID, entry.id)
            table.remove(QB.GoalSearch, 1)
            QB.RefreshQuestBook()
            return
        end

        entry.id = entry.id + 1
        if entry.id == 400000 then
            entry.id = 500000
        end -- 4xxxxx are questnames

        if entry.id > 799999 then
            QH.API.Print("|cffff0000QH-Error: can't find goal: " .. entry.GOAL .. " (" .. entry.QID .. ")")
            table.remove(QB.GoalSearch, 1)
            return
        end
    end
end

----------------------------------------
-- Test if quest/goal is in quest-book
-- param GID is optional
function QB.IsIn(QID, GID)
    if not QID or not QuestBook[QID] then
        return
    end
    return not GID or QuestBook[QID].goals[GID]
end

function QB.IsFinished(QID)
    if QuestBook[QID] then
        return QuestBook[QID].finished
    else
        if not QID then
            QH.API.Print("|cffff0000QH: NO QID IN IsFinished")
        end

        return (CheckQuest(QID) == 2)
    end
end

function QB.IsDaily(QID)
    return QuestBook[QID] and QuestBook[QID].daily
end

function QB.IsPublic(QID)
    return QuestBook[QID] and QuestBook[QID].daily == 3
end

----------------------------------------
function QB.GetGoalState(QID, GID)
    if not QID or not QuestBook[QID] then
        return nil, 0
    end
    local g = QuestBook[QID].goals[GID]
    if not g then
        return nil, 0
    end

    return (g.finished) and true or false, g.gcount or 0
end
----------------------------------------
-- Get Reward NPC info
-- param map is optional (used when NPC is not unique)
-- return id,name,map,x,y
-- if map==nil -> no valid position found
-- if id ==nil -> npc not found, returning a guess-position
function QB.GetRewardNPC(QID)
    local id, name, n_map, n_x, n_y

    if QuestBook[QID].rew_npc_id then
        id, name, n_map, n_x, n_y = QH.Map.GetNPCInfo(QuestBook[QID].rew_npc_id)
    end

    if not id then
        if QuestBook[QID].rew_npc_id then
            name = name or TEXT("Sys" .. QuestBook[QID].rew_npc_id .. "_name")
        else
            name = name or "unknown"
        end

        n_map, n_x, n_y = QH.DB.GetStoredRewardNPC(QID)
        if n_map then
            id = QuestBook[QID].rew_npc_id
        else
            n_map, n_x, n_y = QH.Map.GetSubZonePos(QuestBook[QID].catalog_id)
        end
    end

    return id, name, n_map, n_x, n_y
end

----------------------------------------
-- Get Quest catalog position
--  usually used if nothing is found in DB
-- return map,x,y
function QB.GetCatalogPos(QID)
    local id = QuestBook[QID].catalog_id
    local m, x, y = QH.Map.GetSubZonePos(id)

    return m, x, y
end

----------------------------------------
-- Return text for Goal display
-- return quest_title, quest_lvl, goal_txt, goal_count
-- NOTE 1: if GID==nil goaltext will be reward-npc
-- NOTE 2: title and txt is always valid, lvl and count maybe nil
function QB.GetGoalText(QID, GID)
    if not QID or not QuestBook[QID] then
        return "|cffff0000ERROR (quest not in QB)", 0, "|cffff0000ERROR (goal not in QB)"
    end

    local q = QuestBook[QID]

    --
    if GID then
        local G = q.goals[GID]
        if G then
            return G.name, q.level, G.gcount, G.tcount
        end

        return "|cffff0000ERROR (goal not in QB)", q.level
    end

    -- reward NPC
    local _, name = QB.GetRewardNPC(QID)
    name = COL_NPC .. name .. "|r"
    return string.format(QH.L.Goal_TalkToNPC, name), q.level
end

----------------------------------------
-- Return quest title
function QB.GetQuestTitle(QID)
    return TEXT("Sys" .. QID .. "_name")
end

----------------------------------------
-- Return xp,fin_xp,tp,fin_tp,gold,fin_gold
-- (fin=already finished)
function QB.GetRewardSum()
    local xp = 0
    local fin_xp = 0
    local tp = 0
    local fin_tp = 0
    local gold = 0
    local fin_gold = 0

    for qid, data in pairs(QuestBook) do
        xp = xp + data.reward_exp
        tp = tp + data.reward_tp
        gold = gold + data.reward_gold

        if data.finished then
            fin_xp = fin_xp + data.reward_exp
            fin_tp = fin_tp + data.reward_tp
            fin_gold = fin_gold + data.reward_gold
        end
    end

    return xp, fin_xp, tp, fin_tp, gold, fin_gold
end

----------------------------------------
-- the function fct is called for every unfinished GOAL and
-- for any finished Quest (GID==nil)
-- param: fct(QID,GID,new_qid)
--  ->new_qid is true QID ~= last QID
function QB.ForEachGoal(fct)
    for qid, data in pairs(QuestBook) do
        if data.finished then
            fct(qid, nil)
        else
            for GID, gdata in pairs(data.goals) do
                if not gdata.finished and GID ~= 0 then
                    fct(qid, GID)
                end
            end
        end
    end
end

----------------------------------------
-- the function fct is called for every finished GOAL of given quest
-- param: fct(GID)
function QB.ForEachFinishedGoal(QID, fct)
    if QID and QuestBook[QID] then
        for GID, gdata in pairs(QuestBook[QID].goals or {}) do
            if gdata.finished then
                fct(GID)
            end
        end
    end
end

----------------------------------------
function QB.ShowInQuestBook(QID)
    QH.DetailDialog.ShowQuest(QID)
end

function QB.GetQuestLink(QID)
    assert(QID)
    if QuestBook[QID] and QuestBook[QID].book_id then
        return QuestBook_GetQuestHyperLink(QuestBook[QID].book_id)
    else
        return string.format("|Hquest:%x|h|cffa0a020[%s]|r|h", QID, TEXT("Sys" .. QID .. "_name"))
    end
end

function QB.CancelQuest(QID)
    if QID and QuestBook[QID] and QuestBook[QID].book_id then
        local name = QB.GetQuestTitle(QID)
        StaticPopupDialogs["QUEST_DELETE"] = {}
        StaticPopupDialogs["QUEST_DELETE"].text = string.format(QH.L.Dialog_DeleteQuest, name)
        StaticPopupDialogs["QUEST_DELETE"].button1 = TEXT("YES")
        StaticPopupDialogs["QUEST_DELETE"].button2 = TEXT("NO")
        StaticPopupDialogs["QUEST_DELETE"].hideOnEscape = 1
        StaticPopupDialogs["QUEST_DELETE"].OnAccept = function(this)
            QH.QB.CancelQuestDirect(QID)
        end
        StaticPopup_Show("QUEST_DELETE")
    end
end

function QB.CancelQuestDirect(QID)
    if QID and QuestBook[QID] and QuestBook[QID].book_id then
        ViewQuest_QuestBook(QuestBook[QID].book_id)
        DeleteQuest()
    end
end

----------------------------------------
-- Toggle Quest-Tracker Flag for this Quest
-- NOTE: this will show/hide this quest in tracker-GUI
function QB.ToggleQuestTrack(QID)
    if QID and QuestBook[QID] and QuestBook[QID].book_id then
        return SetQuestTrack(QuestBook[QID].book_id)
    end
end

---------------------------------------
-- Show Quest Tooltip
-- NOTE: caller has to set position
function QB.ShowToolTip(QID)
    local qdata = QuestBook[QID]
    if not qdata then
        return
    end

    local qname = QB.GetQuestTitle(QID)
    GameTooltip:SetText("[" .. qdata.level .. "] " .. qname, 1.0, 1.0, 1.0)
    GameTooltip:AddLine(GetQuestCatalogInfo(qdata.catalog_id), 1.0, 1.0, 1.0)

    local rew_npc_map = ""
    local _, rew_npc_name, rew_map = QB.GetRewardNPC(QID)
    if rew_map then
        rew_npc_map = "(" .. tostring(GetZoneLocalName(rew_map)) .. ")"
    end

    if rew_npc_name then
        GameTooltip:AddLine("Quest-NPC: |cffa0a0ff" .. rew_npc_name .. "|r " .. rew_npc_map)
    end

    GameTooltip:AddLine("\n")

    -- goals
    for g, gdata in pairs(qdata.goals) do
        if gdata.finished then
            GameTooltip:AddLine("- " .. gdata.name, 0.3, 1.0, 0, 3)
        else
            GameTooltip:AddLine("- " .. gdata.name, 1.0, 1.0, 0.6)
        end
    end

    if next(qdata.goals) then
        GameTooltip:AddLine("\n")
    end

    GameTooltip:AddLine(Nyx.GetQuestBookText(QID))
    GameTooltip:Show()
end
