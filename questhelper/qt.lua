------------------------------------------------------
-- QuestHelper
--
-- file: QT
-- desc: Quest-To-do list
--      * Handle goal list
--      * Priority system
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2020-01-19T8:48:21Z
------------------------------------------------------

local QT = {
    goal_search_id = 1, -- goal id counter (just a unique id per run)
    goal_list = {} -- format: [index] = { QID,GID,distance,position }
}
_G.QH.QT = QT

local TOO_FAR_AWAY = 20000000
local COL_NOT_ON_MAP = "|cffc0c0c0"
local COL_PATH_ERROR = "|cffff0000"
local COL_PATH_GUESS = "|cffa0a0b0"
local PRIORITY_HIDE = 100
local PRIORITY_TOP = 0
local PRIORITY_SHOW = 1
local PRIORITY_LATE = 10
local PRIORITY_FLAGS = {PRIORITY_SHOW, PRIORITY_HIDE, PRIORITY_TOP, PRIORITY_LATE}

QH_Priorities = {}

function QT.Init()
    SaveVariablesPerCharacter("QH_Priorities")
end

function QT.Save()
    QH_Priorities = {}
    for i, g in ipairs(QT.goal_list) do
        if g.priority_user ~= PRIORITY_SHOW then
            QH_Priorities[g.QID] = QH_Priorities[g.QID] or {}
            QH_Priorities[g.QID][g.GID or 0] = g.priority_user
        end
    end
end

--------------------------------
-- Calculate distance for to-do-entry
-- (result is stored in to-do-entry)
function QT.FindPath(src_pos, gl_data)
    local pos, err = QT.GetGoalPositions(gl_data, src_pos.m)
    gl_data.distance_error = err

    if pos then
        gl_data.distance, gl_data.target_map = QH.Map.CalculateDistance(src_pos, pos)

        if gl_data.target_map == nil and gl_data.distance == TOO_FAR_AWAY and gl_data.distance_error == nil then
            gl_data.distance_error = 3
        end
    else
        gl_data.distance_error = 1
        gl_data.distance = TOO_FAR_AWAY
        gl_data.target_map = nil
    end
end

function QT.GetGoalPositions(gl_data, map_hint)
    -- TODO map unused?

    if not QH.QB.IsIn(gl_data.QID) then
        QH.API.DebugErr("illegal QID(=" .. tostring(gl_data.QID) .. ") in FindPath")
        return
    end

    if gl_data.GID then
        -- standard goal
        if QH.QB.IsIn(gl_data.QID, gl_data.GID) then
            if QH.DB.HasData(gl_data.GID) then
                return QH.DB.GetMaps(gl_data.GID)
            end

            local id, _, _m, _x, _y = QH.Map.GetNPCInfo(gl_data.GID)
            if not id then
                _m, _x, _y = QH.QB.GetCatalogPos(gl_data.QID)
            end

            if _m then
                QH.Map.MakeSureMapExists(_m)
                return {[_m] = {{_x, _y}}}, 2
            end
        end
    else
        -- find end npc
        local _id, _, n_map, n_x, n_y = QH.QB.GetRewardNPC(gl_data.QID)

        if n_map then
            QH.Map.MakeSureMapExists(n_map)
            local err = ((not _id) and 2)
            return {[n_map] = {{n_x, n_y}}}, err
        end
    end
end

------------------------------------------
local function FindEntry(QID, GID)
    for i, g in ipairs(QT.goal_list) do
        if g.QID == QID and g.GID == GID then
            return i, g
        end
    end
end

local function FindEntryByID(id)
    for i, g in ipairs(QT.goal_list) do
        if g.id == id then
            return i, g
        end
    end
end

function QT.OnGoalAdded(QID, GID)
    local new_data = {
        QID = QID,
        GID = GID,
        distance_error = nil,
        distance = TOO_FAR_AWAY,
        target_map = nil,
        priority_user = PRIORITY_SHOW,
        id = QH.Tracker.EntryAdd()
    }
    table.insert(QT.goal_list, new_data)

    if QH_Priorities[QID] and QH_Priorities[QID][GID or 0] then
        new_data.priority_user = QH_Priorities[QID][GID or 0]
    end

    local prio_fct = QH.DB.GetGoalFunction(GID)
    if prio_fct then
        QT.SetPriorityFunction(QID, GID, prio_fct)
    end

    QT.OnGoalUpdate(QID, GID)
end

function QT.OnGoalRemoved(QID, GID)
    local id, data = FindEntry(QID, GID)
    if id then
        QH.Tracker.EntryRemove(data.id)
        table.remove(QT.goal_list, id)
    end
end

function QT.OnQuestRemoved(QID)
    local goal_list = QH.QT.goal_list

    local i = 1
    while i <= #goal_list do
        if goal_list[i].QID == QID then
            QH.Tracker.EntryRemove(goal_list[i].id)
            table.remove(goal_list, i)
        else
            i = i + 1
        end
    end

    QT.UpdateTrackerTitle()
end

local function IsGoalInMap(gdata, pmap)
    return gdata.target_map == pmap
end

function QT.UpdateAllGoals()
    for i, g in ipairs(QT.goal_list) do
        QT.OnGoalUpdate(g.QID, g.GID)
    end
end

function QT.OnGoalUpdate(QID, GID)
    local _, data = FindEntry(QID, GID)
    if not data then
        return
    end

    local goal_txt, quest_lvl = QH.QB.GetGoalText(QID, GID)

    -- not on this map -> gray
    local pmap = QH.Map.GetCurrentWorldMapID()
    if not IsGoalInMap(data, pmap) then
        goal_txt = COL_NOT_ON_MAP .. goal_txt
    end

    -- problems in path finding
    local err = data.distance_error
    if err then
        if err == 2 then
            goal_txt = COL_PATH_GUESS .. QH.L.Goal_ErrorGuess .. "|r" .. goal_txt
        elseif err == 1 then
            goal_txt = COL_PATH_ERROR .. QH.L.Goal_ErrorUnknown .. "|r" .. goal_txt
        else
            goal_txt = COL_PATH_ERROR .. QH.L.Goal_ErrorPathProblem .. "|r" .. goal_txt
        end
    end

    local text = string.format("[%i] %s", quest_lvl, goal_txt)

    QH.Tracker.EntryText(data.id, text)
end

-----------------------------------
function QT.ShowGoalTooltip(this, id)
    local _, data = FindEntryByID(id)
    if not data or not data.QID then
        return
    end

    GameTooltip:SetOwner(this, "ANCHOR_LEFT")
    QH.QB.ShowToolTip(data.QID)
end

function QT.OnGoalLeftClicked(this, id)
    local _, data = FindEntryByID(id)
    if not data or not data.QID then
        return
    end

    if IsShiftKeyDown() then
        local itemLink = QH.QB.GetQuestLink(data.QID)
        ChatEdit_AddItemLink(itemLink)
    elseif IsCtrlKeyDown() then
        local itemLink = QH.QB.GetQuestLink(data.QID)
        local goalText = QB.GetGoalText(data.QID, data.GID)
        local map, x, y = QB.DB.GetBestPosition(data, GID)
        local goalPos = ""
        if map then
            goalPos = string.format("%s %g/%g", GetZoneLocalName(map), x, y)
        end
        ChatEdit_AddItemLink(string.format("%s %s %s", itemLink, goalText.goalPos))
    else
        QH.QB.ShowInQuestBook(data.QID)
    end
end

function QT.OnContextMenuShow(this)
    local index, data = FindEntryByID(this:GetID())
    if not data then
        return
    end

    local info = {}
    if UIDROPDOWNMENU_MENU_LEVEL == 1 then
        -- change order
        info = {}
        info.text = QH.L.MENU_later
        info.isTitle = 1
        info.value = "later"
        info.hasArrow = 1
        info.owner = DropDownframe
        UIDropDownMenu_AddButton(info, 1)

        -- go to
        if not data.GID then
            local NpcID, name = QH.QB.GetRewardNPC(data.QID)

            if NpcID then
                info = {}
                info.text = string.format(QH.L.MENU_find, name)
                info.func = function()
                    NpcTrackFrame_QuickTrackByNpcID(NpcID)
                end
                UIDropDownMenu_AddButton(info, 1)

                info = {}
                info.text = string.format(QH.L.MENU_goto, name)
                info.func = function()
                    WorldMap_AutoMoveByNpcID(NpcID)
                end
                UIDropDownMenu_AddButton(info, 1)
            end
        else
            local x, y = QT.FindFirstPathPos(index, QH.Map.GetCurrentWorldMapID())
            if x and y then
                info = {}
                info.text =
                    string.format(
                    QH.L.MENU_goto,
                    string.format("%g/%g", math.floor(x * 1000) / 10, math.floor(y * 1000) / 10)
                )
                info.func = function()
                    WorldMap_AutoMove(QH.Map.GetCurrentWorldMapID(), x, y)
                end
                UIDropDownMenu_AddButton(info, 1)
            end
        end

        -- quest book
        info = {}
        info.text = QH.L.MENU_showbook
        info.func = function()
            QH.QB.ShowInQuestBook(data.QID)
        end
        UIDropDownMenu_AddButton(info, 1)

        -- cancel quest
        info = {}
        info.text = QH.L.MENU_cancelquest
        info.func = function()
            QH.QB.CancelQuest(data.QID)
        end
        UIDropDownMenu_AddButton(info, 1)

        -- track quest
        info = {}
        info.text = QH.L.MENU_track
        QH.QB.ToggleQuestTrack(data.QID)
        info.checked = (QH.QB.ToggleQuestTrack(data.QID) == 1)
        info.keepShownOnClick = 1
        info.func = function()
            QH.QB.ToggleQuestTrack(data.QID)
        end
        UIDropDownMenu_AddButton(info, 1)

        -- edit menu
        if QH_Options.editor then
            info = {}
            info.text = QH.L.MENU_edit
            info.isTitle = 1
            info.value = "edit"
            info.hasArrow = 1
            info.owner = DropDownframe
            UIDropDownMenu_AddButton(info, 1)
        end
    elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
        if UIDROPDOWNMENU_MENU_VALUE == "later" then
            local pri = QH.QT.GetPriority(data.QID, data.GID)
            if pri ~= 0 and index > 1 then
                info = {}
                info.text = QH.L.MENU_doNow
                info.func = function()
                    QH.QT.SetPriority(data.QID, data.GID, PRIORITY_TOP)
                    CloseDropDownMenus()
                end
                UIDropDownMenu_AddButton(info, 2)
            end

            if pri ~= 1 then
                info = {}
                info.text = QH.L.MENU_reorder
                info.func = function()
                    QH.QT.SetPriority(data.QID, data.GID, PRIORITY_SHOW)
                    CloseDropDownMenus()
                end
                UIDropDownMenu_AddButton(info, 2)
            end

            info = {}
            info.text = QH.L.MENU_doLater
            info.func = function()
                QH.QT.SetPriority(data.QID, data.GID, PRIORITY_LATE)
                CloseDropDownMenus()
            end
            UIDropDownMenu_AddButton(info, 2)

            info = {}
            info.text = QH.L.MENU_hide
            info.func = function()
                QH.QT.SetPriority(data.QID, data.GID, PRIORITY_HIDE)
                CloseDropDownMenus()
            end
            UIDropDownMenu_AddButton(info, 2)

            info = {}
            info.text = QH.L.MENU_byLevel
            info.func = function()
                local lvl = UnitLevel("player")
                if lvl then
                    QH.QT.SetPriorityFunction(data.QID, data.GID, "HideWhile( PlayerLevel()==" .. lvl .. ")")
                end
                CloseDropDownMenus()
            end
            UIDropDownMenu_AddButton(info, 2)

            info = {}
            info.text = QH.L.MENU_byClass
            info.func = function()
                local mclass = UnitClass("player")
                if mclass then
                    QH.QT.SetPriorityFunction(data.QID, data.GID, "HideWhile( PlayerClass()=='" .. mclass .. "')")
                end
                CloseDropDownMenus()
            end
            UIDropDownMenu_AddButton(info, 2)

            info = {}
            info.text = QH.L.MENU_reorderall
            info.func = function()
                QH.QT.ResetPriorities()
                CloseDropDownMenus()
            end
            UIDropDownMenu_AddButton(info, 2)
        elseif UIDROPDOWNMENU_MENU_VALUE == "edit" then
            info = {}
            info.text = QH.L.MENU_editRemove
            info.func = function()
                QT.RemoveCurrentPos(data.QID, data.GID)
            end
            UIDropDownMenu_AddButton(info, 2)

            info = {}
            info.text = QH.L.MENU_editGlobal
            info.func = function()
                QH.DB.MarkGoalAsGlobal(data.QID, data.GID)
            end
            UIDropDownMenu_AddButton(info, 2)

        --~             info = {}
        --~             info.text 	= QH.L.MENU_editSpecial
        --~             --info.func = function ()  Tracker.RemoveCurrentPos(this.QID, this.GID) end
        --~             UIDropDownMenu_AddButton( info, 2 )
        end
    end
end

function QT.RemoveCurrentPos(QID, GID)
    local map, x, y = QH.Map.GetPlayerPos()

    local found = QH.DB.RemovePositionNear(QID, GID, map, x, y)
    if found then
        QH.API.Print(QH.L.EDIT_PosRemoved)
    else
        QH.API.Print(QH.L.EDIT_PosNotFound)
    end
end

-----------------------------------
function QT.DoDistanceCheck()
    QH.Tracker.RecheckTimer = QH.Tracker.RecheckInterval

    local src = {}
    src.m, src.x, src.y = QH.Map.GetPlayerPos()
    if not src.m then
        src = {x = 0.5, y = 0.5, m = 10000}
    end

    QH.Map.BuildDistances(src.m, src.x, src.y)

    for i, g in ipairs(QT.goal_list) do
        QT.FindPath(src, g)
    end

    QT.SortList()

    if search_pending then
        QT.UpdateTrackerTitle()
    end
end

function QT.UpdateTrackerTitle()
    -- Titlebar
    local search_pending = QH.QB.GoalSearch and #QH.QB.GoalSearch
    if search_pending then
        search_pending = "(" .. search_pending .. ")"
    else
        search_pending = ""
    end

    local dailycount, dailymax = Daily_count()
    QH.Tracker.SetTitle(string.format("%i%s/30  %i/%i", (g_NumTotalQuest or 0), search_pending, dailycount, dailymax))
end

function QT.SortList()
    QT.RecalcPriority()

    -- sort
    table.sort(
        QT.goal_list,
        function(a, b)
            local diff = a.priority - b.priority
            if diff ~= 0 then
                return diff < 0
            end
            diff = a.distance - b.distance
            if diff ~= 0 then
                return diff < 0
            end
            diff = (tonumber(a.GID) or 0) - (tonumber(b.GID) or 0)
            if diff ~= 0 then
                return diff < 0
            end
            return a.QID < b.QID
        end
    )

    -- update tracker
    local pmap = QH.Map.GetCurrentWorldMapID()
    local all_goales = not QH_Options.tracker_zone_only
    for pos, g in ipairs(QT.goal_list) do
        if
            g.priority < PRIORITY_HIDE and
                (all_goales or (IsGoalInMap(g, pmap) or g.distance_error == 1 or g.distance == 0))
         then
            --end
            QH.Tracker.EntryPosition(g.id, pos)

            -- TODO: requires a 'Tracker->Need Text for ID..' Function
            --if Tracker.IsEntryVisible(g.id) then
            QT.OnGoalUpdate(g.QID, g.GID)
        else
            QH.Tracker.EntryPosition(g.id, nil)
        end
    end

    if QH_Options.navi then
        QH.Navi.UpdateTarget()
    end
end

----------------------------
-- Get QID and GID for an index
-- return QID,GID (or nil)
function QT.GetGoal(index)
    if QT.goal_list[index] then
        return QT.goal_list[index].QID, QT.goal_list[index].GID
    end
end

----------------------------
-- return total number of goals in to-do list
function QT.Count()
    return #QT.goal_list
end

----------------------------
--- Priority system
----------------------------
local cur_goal
local prio_changed
local function setCurGoalPrio(val)
    if cur_goal.priority ~= val then
        if not val then
            QH.API.DebugErr("setCurGoalPrio: priority=nil")
            return
        end
        cur_goal.priority = val
        prio_changed = true
    end
end

local function setCurGoalDist(val)
    if val and cur_goal.distance ~= val then
        cur_goal.distance = val
        prio_changed = true
    end
end

local function getGoalDist(QID, GID)
    local _, v = FindEntry(QID, GID)
    if v then
        return v.distance
    end
    return 0
end

local function getQuestMaxDist(QID)
    local max = -1
    for i, g in ipairs(QT.goal_list) do
        if g.QID == QID then
            if g.distance > max then
                max = g.distance
            end
        end
    end

    if max < 0 then
        return TOO_FAR_AWAY
    end

    return max
end

local function clearPriorityFct()
    cur_goal.priority_fct = nil
end

QT.PriorityEnv = {
    PlayerLevel = function()
        return (UnitLevel("player") or 0)
    end,
    PlayerClass = function()
        return (UnitClass("player") or "")
    end,
    IsActive = function(QID)
        return QH.QB.IsIn(QID)
    end,
    HideIf = function(bool)
        if bool then
            setCurGoalPrio(PRIORITY_HIDE)
        end
    end,
    TopIf = function(bool)
        if bool then
            setCurGoalPrio(PRIORITY_TOP)
        end
    end,
    HideWhile = function(bool)
        if bool then
            setCurGoalPrio(PRIORITY_HIDE)
        else
            clearPriorityFct()
        end
    end,
    AfterGoal = function(GID)
        if not QH.DB.IsQuestGoal(cur_goal.QID, GID) then
            API.DebugErr("AfterGoal: goal " .. GID .. " is not in quest " .. QID)
            return
        end
        setCurGoalDist(getGoalDist(cur_goal.QID, GID) + 1)
        setCurGoalPrio(QH.QT.GetPriority(cur_goal.QID, GID) or PRIORITY_SHOW)
    end,
    AfterQuest = function(QID)
            if (CheckQuest(QID)~=2) then
                setCurGoalDist( getQuestMaxDist(QID)+1)
                local qf = QH.QT.GetQuestPriorityFlag(QID)
                setCurGoalPrio( PRIORITY_FLAGS[qf+1] )
            end
        end,

    print = function(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end,
}

function QT.RecalcPriority()
    prio_changed = false
    for recalc_round = 1, 10 do
        for _, g in ipairs(QT.goal_list) do
            g.priority = g.priority_user
            if g.priority_fct then
                cur_goal = g
                g.priority_fct()
            end
        end
        if not prio_changed then
            break
        end
    end
end

function QT.GetPriority(QID, GID)
    local _, v = FindEntry(QID, GID)
    return v and v.priority_user
end

function QT.SetPriority(QID, GID, pri)
    assert(pri)
    local _, v = FindEntry(QID, GID)
    if v then
        v.priority_user = pri

        QH_Priorities[QID] = QH_Priorities[QID] or {}
        QH_Priorities[QID][GID or 0] = pri

        QT.SortList()
    end
end

function QT.GetQuestPriorityFlag(QID)
    for i, g in ipairs(QT.goal_list) do
        if g.QID == QID then
            if g.priority_user == PRIORITY_HIDE then
                return 1
            elseif g.priority_user == PRIORITY_LATE then
                return 3
            elseif g.priority_user == PRIORITY_TOP then
                return 2
            end
        end
    end

    return 0
end

function QT.SetQuestPriorityFlag(QID, pri_flag)
    local pri = PRIORITY_FLAGS[pri_flag + 1]
    assert(pri)
    for i, g in ipairs(QT.goal_list) do
        if g.QID == QID then
            g.priority_user = pri
        end
    end

    QT.SortList()
end

function QT.ResetPriorities()
    for i, v in ipairs(QT.goal_list) do
        v.priority_user = PRIORITY_SHOW
    end

    QT.SortList()
end

function QT.SetPriorityFunction(QID, GID, pri_func_txt)
    local _, v = FindEntry(QID, GID)
    if v then
        local pri_func, err = loadstring(pri_func_txt)
        if not pri_func then
            QH.API.DebugErr("PriFct: " .. err)
            return
        end

        setfenv(pri_func, QT.PriorityEnv)
        v.priority_fct = pri_func
    end
end

----------------------------
-- Test if a to-do entry is in current map
function QT.IsGoalInMap(index, pmap)
    return IsGoalInMap(QT.goal_list[index], pmap)
end

----------------------------
-- return when there is a problem in pathfinding (no path found, path only to CAT,...)
function QT.GetPathError(index)
    return QT.goal_list[index].distance_error
end

function QT.GetPathToGoal(goal_data)
    local src = {}
    src.m, src.x, src.y = QH.Map.GetPlayerPos()
    if not src.m then
        return
    end

    local pos, err = QT.GetGoalPositions(goal_data, src.m)
    if err then
        return
    end
    return QH.Map.CalculatePath(src, pos)
end

----------------------------
-- test path for first apearing on specified map
function QT.FindFirstPathPos(index, pmap)
    if not QT.HasTarget(index) then
        return
    end

    local res_path = QT.GetPathToGoal(QT.goal_list[index])
    if not res_path then
        return
    end

    local x, y, msg, porttext = QH.Map.GetPathInfoForMap(res_path.path, pmap)
    if x then
        return x, y, msg, porttext
    end

    -- direct way?
    if res_path.target.m == pmap then
        return res_path.target.x / 100, res_path.target.y / 100
    end
end

----------------------------
-- return true if goal is valid and has a target
function QT.HasTarget(index)
    return QT.goal_list[index] and QT.goal_list[index].target_map
end
