------------------------------------------------------
-- QuestHelper
--
-- file: ui_questlist
-- desc: quest list dialog
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2020-01-19T8:48:21Z
------------------------------------------------------

local ListDialog = {}
_G.QH.ListDialog = ListDialog

local QDB = QH.QDB

local Nyx = LibStub("Nyx")
local WaitTimer = LibStub("WaitTimer")
local CPColor = LibStub("CPColor")

local MAX_LINES = 20
local INDENT = 14
local MAX_DISP_DEEP = 9

SLASH_QuestList1 = "/questlist"
SLASH_QuestList2 = "/ql"
SlashCmdList["QuestList"] = function(editBox, msg)
    ToggleUIFrame(QHQuestList)
end

function ListDialog.OnShow(this)
    QH.QDB.Load()

    QH.DB.cleanupDynDataStarter()

    ListDialog.total_count = QH.QDB.GetQuestCount()
    ListDialog.sort_order = ListDialog.sort_order or 0

    ListDialog.RebuildItemList()
    this:RegisterEvent("RESET_QUESTTRACK")
    this:RegisterEvent("RESET_QUESTBOOK")
    this:RegisterEvent("UNIT_LEVEL")

    if QHQuestDetails:IsVisible() then
        ListDialog.Item_SelectQID(QH.DetailDialog.GetCurrentQID())
        QHQuestDetails:Hide()
        QHQuestDetails:Show()
    end

    QH.ListDialog.ReplaceOriginalBook(QH_Options.hook_book)
end

function ListDialog.OnHide(this)
    this:UnregisterEvent("RESET_QUESTTRACK")
    this:UnregisterEvent("RESET_QUESTBOOK")
    this:UnregisterEvent("UNIT_LEVEL")

    QHQuestDetails:Hide()

    QH.QDB.Release()
    ListDialog.items = nil
    ListDialog.search_result = nil
end

function ListDialog.OnEvent(event)
    if event == "RESET_QUESTTRACK" then
        QH.DetailDialog.DoUpdate()
    elseif event == "RESET_QUESTBOOK" or (event == "UNIT_LEVEL" and arg1 == "player") then
        if ListDialog.FilterTab == 1 then
            local old_QID = ListDialog.GetSelectedQID()
            ListDialog.RebuildItemList()

            local details_were_hidden = not QHQuestDetails:IsVisible()
            ListDialog.Item_SelectQID(old_QID)
            if details_were_hidden then
                QHQuestDetails:Hide()
            end
        else
            ListDialog.UpdateList()
        end
    end
end

function ListDialog.OnQuestGiveUp()
    local QID = ListDialog.GetSelectedQID()

    if QID then
        QH.QB.CancelQuestDirect(QID)
        QHQuestDetails:Hide()
    end
end

function ListDialog.OnShowQuestLog()
    ListDialog.ReplaceOriginalBook(false)
    ToggleUIFrame(UI_QuestBook)
    QHQuestList:Hide()
end

local function SetHeaderText(this, text)
    this:SetText(text)
    this:SetWidth(this:GetTextWidth() + 8)
end

function ListDialog.Init()
    ListDialog.InitLabels()

    ListDialog.OnTabClick(QHQuestListTab1, true)
end

function ListDialog.ReplaceOriginalBook(replace)
    if replace then
        if not ListDialog.ori_OnShow_QuestBook then
            ListDialog.ori_OnShow_QuestBook = OnShow_QuestBook
            OnShow_QuestBook = function(this)
                this:Hide()
                ToggleUIFrame(QHQuestList)
            end
        end
        QHQuestListQuestLog:Show()
    else
        if ListDialog.ori_OnShow_QuestBook then
            OnShow_QuestBook = ListDialog.ori_OnShow_QuestBook
            ListDialog.ori_OnShow_QuestBook = nil
        end
        QHQuestListQuestLog:Hide()
    end
end

function ListDialog.InitLabels()
    QHQuestListTitle:SetText(string.format(QH.L.HeadTooltip_Header, QH.VERSION))
    QHQuestListFilterZoneText:SetText(QH.L.LIST_Zone_All)

    QHQuestListTab1:SetText(QH.L.LIST_Tab_Active)
    QHQuestListTab2:SetText(QH.L.LIST_Tab_Available)
    QHQuestListTab3:SetText(QH.L.LIST_Tab_All)

    QHQuestListFilterLoopedLabel:SetText(QH.L.LIST_Hide_Repeatables)
    QHQuestListFilterFinishedLabel:SetText(QH.L.LIST_Hide_Finished)

    QHQuestListFilterLowLevelLabel:SetText(QH.L.LIST_Hide_LowLevel)
    QHQuestListFilterHighLevelLabel:SetText(QH.L.LIST_Hide_HighLevel)
    QHQuestListFilterLowLevel2Label:SetText(QH.L.LIST_Show_LowLevel)
    QHQuestListFilterUnavailableLabel:SetText(QH.L.LIST_Show_Unavailable)

    QHQuestNameLabel:SetText(QH.L.LIST_Name_Search)

    SetHeaderText(QHQuestListItemsHeadName, QH.L.LIST_Head_Name)
    SetHeaderText(QHQuestListItemsHeadLevel, QH.L.LIST_Head_Level)
    SetHeaderText(QHQuestListItemsHeadZone, QH.L.LIST_Head_Zone)
end

function ListDialog.OnTabClick(this, no_item_search)
    QHQuestListTab1Active:Hide()
    QHQuestListTab2Active:Hide()
    QHQuestListTab3Active:Hide()
    QHQuestListTab1Inactive:Show()
    QHQuestListTab2Inactive:Show()
    QHQuestListTab3Inactive:Show()

    _G[this:GetName() .. "Active"]:Show()
    _G[this:GetName() .. "Inactive"]:Hide()

    QHQuestListFilterLowLevel:Hide()
    QHQuestListFilterHighLevel:Hide()
    QHQuestListFilterLooped:Hide()
    QHQuestListFilterLowLevel2:Hide()
    QHQuestListFilterUnavailable:Hide()
    QHQuestListFilterFinished:Hide()

    ListDialog.FilterTab = this:GetID()

    if this:GetID() == 1 then
        QHQuestListFilterLooped:Show()
        QHQuestListFilterFinished:Show()
    elseif this:GetID() == 2 then
        QHQuestListFilterLowLevel2:Show()
        QHQuestListFilterLooped:Show()
        QHQuestListFilterUnavailable:Show()
        QHQuestListFilterFinished:Show()
    else
        QHQuestListFilterLowLevel:Show()
        QHQuestListFilterHighLevel:Show()
        QHQuestListFilterUnavailable:Show()
    end

    if not no_item_search then
        ListDialog.RebuildItemList()
    end
end

function ListDialog.RebuildItemList()
    ListDialog.search_result = nil
    ListDialog.selection = nil
    QHQuestListAbortQuest:Disable()

    ListDialog.FindItems()
    ListDialog.SortItems()
    ListDialog.UpdateList()
end

function ListDialog.List_Header_OnClick(this)
    local id = this:GetID()

    QHQuestListItemsHeadNameSortIcon:Hide()
    QHQuestListItemsHeadLevelSortIcon:Hide()
    QHQuestListItemsHeadZoneSortIcon:Hide()

    if math.abs(ListDialog.sort_order) == math.abs(id) then
        ListDialog.sort_order = -ListDialog.sort_order
    else
        ListDialog.sort_order = id
    end

    if ListDialog.sort_order > 0 then
        _G[this:GetName() .. "SortIcon"]:SetFile("Interface/chatframe/chatframe-scrollbar-buttondown")
    else
        _G[this:GetName() .. "SortIcon"]:SetFile("Interface/chatframe/chatframe-scrollbar-buttonup")
    end
    _G[this:GetName() .. "SortIcon"]:Show()

    ListDialog.RebuildItemList()
end

local function BuildFilter()
    local code = {"return function (QID,qdata, isfinished)"}
    --table.insert(code, 'if not qdata then return false end')

    table.insert(code, "local QDB = QH.QDB")

    -- Active Quests
    if ListDialog.FilterTab == 1 then
        -- Available
        if QHQuestListFilterLooped:IsChecked() then
            table.insert(code, "if QDB.IsLoopable(qdata) then return false end")
        end

        if QHQuestListFilterFinished:IsChecked() then
            table.insert(code, "if isfinished then return false end")
        end
    elseif ListDialog.FilterTab == 2 then
        -- All
        local level = UnitLevel("player")
        table.insert(code, "local _,lmin,lmax = QDB.GetLevel(qdata)")

        if not QHQuestListFilterLowLevel2:IsChecked() then
            table.insert(code, "if lmax<" .. level .. " then return false end")
        end
        table.insert(code, "if lmin>" .. level .. " then return false end")

        if QHQuestListFilterLooped:IsChecked() then
            table.insert(code, "if QDB.IsLoopable(qdata) then return false end")
        end

        if not QHQuestListFilterUnavailable:IsChecked() then
            table.insert(code, "if CheckQuest(QID)==0 and not QDB.AreAllFlagsValid(qdata) then return false end")
        end

        if QHQuestListFilterFinished:IsChecked() then
            table.insert(code, "if CheckQuest(QID)==2 then return false end")
        end

        table.insert(code, "if CheckQuest(QID)==2 and not QDB.IsLoopable(qdata) then return false end")
        table.insert(code, "if CheckQuest(QID)==0 and QDB.HasMissingPrequest(qdata) then return false end")
    else
        local check_min, check_max = QHQuestListFilterLowLevel:IsChecked(), QHQuestListFilterHighLevel:IsChecked()
        if check_min or check_max then
            table.insert(code, "local _,lmin,lmax = QDB.GetLevel(qdata)")

            local level = UnitLevel("player")
            if check_max then
                table.insert(code, "if lmin>" .. level .. " then return false end")
            end

            if check_min then
                table.insert(code, "if lmax<" .. level .. " then return false end")
            end
        end

        if not QHQuestListFilterUnavailable:IsChecked() then
            table.insert(code, "if not QDB.AreAllFlagsValid(qdata) then return false end")
        end
    end

    --~     if not QHQuestListFilterFinished:IsChecked() then
    --~         table.insert(code, 'if CheckQuest(QID)==2 and not QDB.IsLoopable(qdata) then return false end')
    --~     end

    --~     if not QHQuestListFilterMissingPrequest:IsChecked() then
    --~         table.insert(code, 'if CheckQuest(QID)==0 and QDB.HasMissingPrequest(qdata) then return false end')
    --~     end

    if ListDialog.FilterZone and ListDialog.FilterZone ~= -2 then
        local zone = ListDialog.FilterZone
        if zone == -3 then
            zone = GetCurrentWorldMapID()
        end

        table.insert(code, "if not QDB.IsInZone(qdata," .. zone .. ") then return false end")
    end

    table.insert(code, "return true end")

    local code_text = table.concat(code, " ")
    local fct, err = loadstring(code_text)
    assert(fct, tostring(err) .. "\n" .. code_text)
    return fct()
end

function ListDialog.FindItems()
    local list = {}

    local filter = BuildFilter()

    if ListDialog.FilterTab == 1 then
        local numQuests = GetNumQuestBookButton_QuestBook()
        for i = 1, numQuests do
            local _, _, _, _, _, _, _, _, QID, finished = GetQuestInfo(i)
            if filter(QID, QH.QDB.GetQuest(QID), finished) then
                table.insert(list, {QID, 0})
            end
        end
    else
        local DB = QH.QDB.GetDB()
        for QID, qdata in pairs(DB) do
            if filter(QID, qdata) then
                table.insert(list, {QID, 0})
            end
        end
    end

    ListDialog.items = list

    ListDialog.search_result = nil
    ListDialog.UpdateItemCount()
end

function ListDialog.UpdateItemCount(flash)
    QHQuestListItemsSB:SetValueStepMode("INT")
    if #ListDialog.items > MAX_LINES then
        QHQuestListItemsSB:Show()
        QHQuestListItemsSB:SetMinMaxValues(0, #ListDialog.items - MAX_LINES)
    else
        QHQuestListItemsSB:Hide()
        QHQuestListItemsSB:SetMinMaxValues(0, 0)
    end

    local search_txt = ""
    if ListDialog.search_result then
        search_txt = string.format("(%i) ", #ListDialog.search_result)
    else
        local name = QHQuestListName:GetText()
        if name and name ~= "" then
            search_txt = "(?)"
        end
    end

    local text = string.format("%i %s/ %i", #ListDialog.items, search_txt, ListDialog.total_count)
    QHQuestListCounts:SetText(text)
    if flash then
        QHQuestListCounts:SetColor(1, 1, 0)
        WaitTimer.Delay(
            1,
            function()
                QHQuestListCounts:SetColor(1, 1, 1)
            end,
            "QHL_FLASH"
        )
    else
        QHQuestListCounts:SetColor(1, 1, 1)
    end

    ListDialog.UpdateNameButtons()
end

function ListDialog.SortItems()
    local function stext(id)
        local txt = TEXT(string.format("Sys%06i_name", id))
        txt = string.gsub(txt, "%p", "")
        txt =
            string.gsub(
            txt,
            "\195.",
            function(x)
                if x == "\195\164" or x == "\195\132" then
                    return "a"
                end
                if x == "\195\182" or x == "\195\150" then
                    return "o"
                end
                if x == "\195\188" or x == "\195\156" then
                    return "u"
                end
                if x == "\195\159" then
                    return "s"
                end
                return x
            end
        )

        return string.lower(txt)
    end

    local sort_routines = {
        [1] = function(a, b)
            return stext(a[1]) < stext(b[1])
        end,
        [2] = function(a, b)
            local qa, qb = QDB.GetQuest(a[1]), QDB.GetQuest(b[1])
            return QDB.GetLevel(qa) < QDB.GetLevel(qb)
        end,
        [3] = function(a, b)
            local qa, qb = QDB.GetQuest(a[1]), QDB.GetQuest(b[1])
            return QDB.GetCatalogName(qa) < QDB.GetCatalogName(qb)
        end
    }

    local sort_fct = sort_routines[math.abs(ListDialog.sort_order)]
    if not sort_fct then
        return
    end
    if ListDialog.sort_order < 0 then
        sort_fct = function(a, b)
            return sort_routines[math.abs(ListDialog.sort_order)](b, a)
        end
    end

    table.sort(ListDialog.items, sort_fct)
end

function ListDialog.UpdateNameButtons()
    if not ListDialog.search_result or #ListDialog.search_result < 1 then
        QHQuestListNamePrev:Disable()

        local name = QHQuestListName:GetText()
        if name and name ~= "" then
            QHQuestListNameNext:Enable()
        else
            QHQuestListNameNext:Disable()
        end
    else
        QHQuestListNamePrev:Enable()
        QHQuestListNameNext:Enable()
    end
end

local function doNameSearch()
    local name = QHQuestListName:GetText()
    if not name or name == "" then
        ListDialog.search_result = nil
        ListDialog.UpdateItemCount()
        return true
    end

    name = string.lower(name)

    local res = {}
    local is_in = {}
    for _, idata in pairs(ListDialog.items) do
        local qname = string.lower(TEXT("Sys" .. idata[1] .. "_name"))
        if string.find(qname, name, 1, true) then
            table.insert(res, idata[1])
            is_in[idata[1]] = 1
        end
    end

    local DB = QH.QDB.GetDB()
    for QID, qdata in pairs(DB) do
        local qname = string.lower(TEXT("Sys" .. QID .. "_name"))
        if string.find(qname, name, 1, true) then
            if not is_in[QID] then
                table.insert(res, QID)
            end
        end
    end

    ListDialog.search_result = res
    ListDialog.UpdateItemCount()
end

function ListDialog.OnNameSearchChange()
    ListDialog.search_result = nil
    ListDialog.UpdateNameButtons()
    WaitTimer.Delay(1, ListDialog.OnNameSearchDo, "qh_name_search")
end

function ListDialog.OnNameSearchDo()
    if IsShiftKeyDown() then
        ListDialog.OnNameSearchPrev()
    else
        ListDialog.OnNameSearchNext()
    end
end

local function hasSearchResults()
    if not ListDialog.search_result then
        doNameSearch()
    end

    if ListDialog.search_result then
        if #ListDialog.search_result > 0 then
            return true
        else
            QH.API.Print("nothing found")
        end
    end

    return false
end

function ListDialog.OnNameSearchNext()
    ListDialog.OnNameSearch(1)
end

function ListDialog.OnNameSearchPrev()
    ListDialog.OnNameSearch(-1)
end

function ListDialog.OnNameSearch(dir)
    WaitTimer.Stop("qh_name_search")

    if not hasSearchResults() then
        return
    end

    ListDialog.search_index = (ListDialog.search_index or 0) + dir
    if ListDialog.search_index <= 0 then
        ListDialog.search_index = #ListDialog.search_result
    end
    if ListDialog.search_index > #ListDialog.search_result then
        ListDialog.search_index = 1
    end

    local QID = ListDialog.search_result[ListDialog.search_index]

    if not ListDialog.Item_SelectQIDFind(QID) then
        table.remove(ListDialog.search_result, ListDialog.search_index)

        if dir > 0 then
            ListDialog.search_index = ListDialog.search_index - 1
        end

        WaitTimer.Delay(0.1, ListDialog.OnNameSearch, "QHL_NEXTSEARCH", dir)
        ListDialog.UpdateItemCount(true)
    end
end

function ListDialog.UpdateList()
    local topindex = QHQuestListItemsSB:GetValue()
    local selection = (ListDialog.selection or 0) - topindex
    for i = 1, MAX_LINES do
        local basename = "QHQuestListItems" .. i

        local entry_data = ListDialog.items[i + topindex]
        if entry_data then
            ListDialog.UpdateListItem(basename, i + topindex, entry_data)
            _G[basename]:Show()

            local hilit = _G[basename .. "Highlight"]
            if selection == i then
                hilit:Show()
            else
                hilit:Hide()
            end
        else
            _G[basename]:Hide()
        end
    end
end

local function calcIndent(index)
    local cur_state = ListDialog.items[index][2]
    local min_state = cur_state
    while index > 1 and ListDialog.items[index][2] > 0 do
        index = index - 1
        min_state = math.min(ListDialog.items[index][2], min_state)
    end

    index = index - 1

    while index > 0 and ListDialog.items[index][2] < 0 do
        min_state = math.min(ListDialog.items[index][2], min_state)
        index = index - 1
    end
    index = index + 1

    return cur_state - min_state
end

function ListDialog.UpdateListItem(basename, index, entry_data)
    local QID = entry_data[1]
    local state = entry_data[2]
    local qdata = QDB.GetQuest(QID)

    local indent = math.min(calcIndent(index), MAX_DISP_DEEP) * INDENT

    -- prio_button
    local btn_prio = _G[basename .. "BtnPrio"]
    if QH.QB.IsIn(QID) then
        btn_prio:Show()

        local pri = QH.QT.GetQuestPriorityFlag(QID)
        local texture = btn_prio:GetNormalTexture()
        texture:SetTexCoord(1 / 4 * pri, 1 / 4 * (pri + 1), 0, 1)
    else
        btn_prio:Hide()
    end

    -- Button
    local btn_back = _G[basename .. "BtnBack"]
    local btn_for = _G[basename .. "BtnFor"]

    local pre_index = ListDialog.items[index - 1]
    local pre_state = pre_index and pre_index[2]
    if pre_state and state <= 0 and pre_state >= 0 then
        pre_state = nil
    end

    local post_index = ListDialog.items[index + 1]
    local hasPostExpanded = post_index and state < (post_index[2] or 0)
    local hasPreExpanded = pre_state and state > pre_state
    local preIsOnSameLevel = pre_state and state <= pre_state

    if state > 0 or (QDB.HasPreQuest(qdata) and not hasPreExpanded) then
        if not (state > 0 and preIsOnSameLevel) then
            btn_back:Show()
        else
            btn_back:Hide()
        end
    else
        btn_back:Hide()
    end

    if state < 0 or (QDB.HasPostQuest(qdata) and not hasPostExpanded) then
        if not (state < 0 and preIsOnSameLevel) then
            btn_for:Show()
        else
            btn_for:Hide()
        end
    else
        btn_for:Hide()
    end

    -- indent
    btn_back:ClearAllAnchors()
    btn_back:SetAnchor("LEFT", "LEFT", _G[basename], 16 + indent, 0)

    -- Name
    local name_field = _G[basename .. "Name"]
    name_field:ClearAllAnchors()
    name_field:SetAnchor("LEFT", "LEFT", _G[basename], 40 + indent, 0)
    name_field:SetSize(220 - indent, 14)

    name_field:SetText(QDB.GetName(QID))

    if QH.QDB.IsLoopable(qdata) then
        _G[basename .. "Repeat"]:Show()
    else
        _G[basename .. "Repeat"]:Hide()
    end

    _G[basename .. "Level"]:SetText(QDB.GetLevel(qdata))
    _G[basename .. "Zone"]:SetText(QDB.GetCatalogName(qdata))

    if not QID then
        QH.API.Print("|cffff0000QH: NO QID IN UpdateListItem")
    end

    local color = "WHITE" -- std/available quest
    if QDB.HasMissingPrequest(qdata) then
        color = "PINK" -- missing pre quest
    elseif QH.QB.IsIn(QID) then
        if QH.QB.IsFinished(QID) then
            color = "ORANGE" -- active-finished quest
        else
            color = "YELLOW" -- active quest
        end
    elseif CheckQuest(QID) == 2 then
        color = "GREY" -- done quest
    elseif not QDB.AreAllFlagsValid(qdata) then
        color = "RED" -- missing flag
    end

    ListDialog.ColorListItem(basename, CPColor.Color(color))
end

function ListDialog.ColorListItem(basename, r, g, b)
    _G[basename .. "Name"]:SetColor(r, g, b)
    _G[basename .. "Level"]:SetColor(r, g, b)
    _G[basename .. "Zone"]:SetColor(r, g, b)
end

function ListDialog.FilterZone_OnLoad(this)
    UIDropDownMenu_SetWidth(this, 100)
    UIDropDownMenu_Initialize(this, ListDialog.FilterZone_OnShow)
end

function ListDialog.FilterZone_OnShow()
    local info
    local zonenum = ListDialog.FilterZone or -2

    if (UIDROPDOWNMENU_MENU_LEVEL == 1) then
        info = {}
        info.func = ListDialog.FilterZone_OnClick
        info.text = QH.L.LIST_Zone_All
        info.value = -2
        info.textR = 1
        info.textG = 1
        info.textB = 0
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.func = ListDialog.FilterZone_OnClick
        info.text = QH.L.LIST_Zone_Current
        info.value = -3
        info.textR = 1
        info.textG = 1
        info.textB = 0
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("ZONE_YGGNO LAND")
        info.hasArrow = 1
        info.value = 9998
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("ZONE_SAVILLEPLAINS")
        info.hasArrow = 1
        info.value = 9997
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("SC_BALANZASAR")
        info.hasArrow = 1
        info.value = 9996
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("SC_GDDR_00")
        info.hasArrow = 1
        info.value = 9995
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("ZONE_KOLYDIA")
        info.hasArrow = 1
        info.value = 9994
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)

        info = {}
        info.text = TEXT("UI_WORLDMAP_OTHER")
        info.hasArrow = 1
        info.value = 9999
        info.checked = zonenum == info.value
        UIDropDownMenu_AddButton(info)
    elseif (UIDROPDOWNMENU_MENU_LEVEL == 2) then
        local p_zone = UIDROPDOWNMENU_MENU_VALUE

        local zones = {}
        local zones_in = {}
        local DB = QDB.GetDB()
        for _, d in pairs(DB) do
            local zone = QDB.GetZone(d)
            if not zones_in[zone] and QH.Map.IsInZone(zone, p_zone) then
                zones_in[zone] = 1
                table.insert(zones, {zone, GetZoneLocalName(zone) or ""})
            end
        end

        --~         local zones={}
        --~         local zones_in={}
        --~         for _,d in pairs(ListDialog.items) do
        --~             local zone = QDB.GetZone(QDB.GetQuest(d[1]))
        --~             if not zones_in[zone] and QH.Map.IsInZone(zone, p_zone) then
        --~                 zones_in[zone]=1
        --~                 table.insert(zones,{zone,GetZoneLocalName(zone) or ""})
        --~             end
        --~         end

        table.sort(
            zones,
            function(a, b)
                return a[2] < b[2]
            end
        )

        for _, n in ipairs(zones) do
            info = {}
            info.func = ListDialog.FilterZone_OnClick
            info.text = n[2]
            info.value = n[1]
            info.checked = zonenum == info.value
            UIDropDownMenu_AddButton(info, 2)
        end
    end
end

function ListDialog.FilterZone_OnClick(button)
    UIDropDownMenu_SetSelectedValue(QHQuestListFilterZone, button.value)
    QHQuestListFilterZoneText:SetText(button:GetText())
    CloseDropDownMenus()

    ListDialog.FilterZone = button.value
    ListDialog.RebuildItemList()
end

function ListDialog.Item_OnClick(this)
    local cur_index = QHQuestListItemsSB:GetValue() + this:GetID()

    if IsShiftKeyDown() then
        local qdata = ListDialog.items[cur_index]
        if qdata then
            local itemLink = QH.QB.GetQuestLink(qdata[1])
            ChatEdit_AddItemLink(itemLink)
        end
        return
    end

    if cur_index == ListDialog.selection then
        cur_index = nil
    end
    ListDialog.Item_Select(cur_index)
end

local function item_RemoveChildren(index)
    local state = ListDialog.items[index][2]

    assert(state > 0)

    local post_index = ListDialog.items[index + 1]
    local hasPostExpanded = post_index and state < (post_index[2] or 0)
    if hasPostExpanded then
        index = index + 1
        state = ListDialog.items[index][2]
    end

    local removed = 1
    while ListDialog.items[index] and ListDialog.items[index][2] >= state do
        table.remove(ListDialog.items, index)
        removed = removed + 1
    end

    if ListDialog.selection and ListDialog.selection >= index then
        assert(index - removed >= 0)
        ListDialog.Item_Select(ListDialog.selection - removed + 1)
    end

    return hasPostExpanded
end

local function item_AddParent(index)
    local state = ListDialog.items[index][2]

    assert(state <= 0)
    local qdata = QDB.GetQuest(ListDialog.items[index][1])
    local preq = QDB.GetPreQuest(qdata)
    assert(preq and #preq > 0)

    local start_index = index
    for _, QID in ipairs(preq) do
        table.insert(ListDialog.items, index, {QID, state - 1})
        index = index + 1
    end

    if ListDialog.selection and ListDialog.selection >= start_index then
        ListDialog.Item_Select(ListDialog.selection + index - start_index)
    end
    return start_index
end

local function item_AddAllParents(index)
    local n = item_AddParent(index)
    for idx = n, index do
        local qdata = QDB.GetQuest(ListDialog.items[idx][1])
        local preq = QDB.GetPreQuest(qdata)
        if preq and #preq > 0 then
            item_AddAllParents(idx)
            return
        end
    end
end

local function item_RemoveParent(index)
    local state = ListDialog.items[index][2]

    assert(state < 0)
    local pre_index = ListDialog.items[index - 1]
    local hasPreExpanded = pre_index and state > (pre_index[2] or 0)
    if hasPreExpanded then
        state = pre_index[2]
        while hasPreExpanded do
            local prestate = pre_index[2]
            repeat
                index = index - 1
                pre_index = ListDialog.items[index - 1]
            until not pre_index or prestate ~= (pre_index[2] or 0)
            hasPreExpanded = pre_index and prestate > (pre_index[2] or 0)
        end
    end

    local removed = 1
    while ListDialog.items[index] and ListDialog.items[index][2] <= state do
        table.remove(ListDialog.items, index)
        removed = removed + 1
    end

    if ListDialog.selection and ListDialog.selection > index then
        ListDialog.Item_Select(ListDialog.selection - removed + 1)
    end

    return hasPreExpanded
end

local function item_AddChildren(index)
    local state = ListDialog.items[index][2]

    assert(state >= 0)
    local qdata = QDB.GetQuest(ListDialog.items[index][1])
    local postq = QDB.GetPostQuest(qdata)
    assert(postq and #postq > 0)

    local start_index = index
    for _, QID in ipairs(postq) do
        index = index + 1
        table.insert(ListDialog.items, index, {QID, state + 1})
    end

    if ListDialog.selection and ListDialog.selection > start_index then
        ListDialog.Item_Select(ListDialog.selection + index - start_index)
    end

    return start_index + 1
end

local function item_AddAllChildren(index)
    local n = item_AddChildren(index)

    for idx = index + 1, n do
        local qdata = QDB.GetQuest(ListDialog.items[idx][1])
        local postq = QDB.GetPostQuest(qdata)
        if postq and #postq > 0 then
            item_AddAllChildren(idx)
        end
    end
end

function ListDialog.Item_OnBtnBack(this)
    if IsShiftKeyDown() then
        ListDialog.Item_OnBtnBackDbl(this)
        return
    end

    local index = QHQuestListItemsSB:GetValue() + this:GetID()
    local state = ListDialog.items[index][2]

    if state > 0 then
        item_RemoveChildren(index)
    else
        item_AddParent(index)
    end

    ListDialog.UpdateItemCount()
    ListDialog.UpdateList()
end

function ListDialog.Item_OnBtnFor(this)
    if IsShiftKeyDown() then
        ListDialog.Item_OnBtnForDbl(this)
        return
    end

    local index = QHQuestListItemsSB:GetValue() + this:GetID()
    local state = ListDialog.items[index][2]

    if state < 0 then
        item_RemoveParent(index)
    else
        item_AddChildren(index)
    end

    ListDialog.UpdateItemCount()
    ListDialog.UpdateList()
end

function ListDialog.Item_OnBtnBackDbl(this)
    local index = QHQuestListItemsSB:GetValue() + this:GetID()
    local state = ListDialog.items[index][2]

    if state > 0 then
        if item_RemoveChildren(index) then
            item_RemoveChildren(index)
        end
    else
        item_AddAllParents(index)
    end

    ListDialog.UpdateItemCount()
    ListDialog.UpdateList()
end

function ListDialog.Item_OnBtnForDbl(this)
    local index = QHQuestListItemsSB:GetValue() + this:GetID()
    local state = ListDialog.items[index][2]

    if state < 0 then
        if item_RemoveParent(index) then
            item_RemoveParent(index)
        end
    else
        item_AddAllChildren(index)
    end

    ListDialog.UpdateItemCount()
    ListDialog.UpdateList()
end

function ListDialog.Item_OnBtnPrio(this)
    local index = QHQuestListItemsSB:GetValue() + this:GetID()
    local qdata = ListDialog.items[index]

    local pri = QH.QT.GetQuestPriorityFlag(qdata[1])
    pri = (pri + 1) % 4
    QH.QT.SetQuestPriorityFlag(qdata[1], pri)

    local btn = _G[this:GetName() .. "BtnPrio"]
    local texture = btn:GetNormalTexture()
    texture:SetTexCoord(1 / 4 * pri, 1 / 4 * (pri + 1), 0, 1)
end

local function findQuestDeepFct(is_in, listfct, qdata)
    for _, QID in pairs(listfct(qdata)) do
        if is_in[QID] then
            return is_in[QID], {}
        end

        local qdata = QDB.GetQuest(QID)
        if qdata then
            local q_idx, childs = findQuestDeepFct(is_in, listfct, qdata)
            if q_idx then
                table.insert(childs, QID)
                return q_idx, childs
            end
        end
    end
end

local function findQuestDeep(is_in, QID)
    local qdata = QDB.GetQuest(QID)
    local idx, childs = findQuestDeepFct(is_in, QDB.GetPostQuest, qdata)
    if idx then
        return idx, childs, false
    end

    local idx, childs = findQuestDeepFct(is_in, QDB.GetPreQuest, qdata)
    return idx, childs, true
end

function ListDialog.GetSelectedQID()
    local qdata = ListDialog.selection and ListDialog.items[ListDialog.selection]
    return (qdata and qdata[1])
end

function ListDialog.Item_SelectQID(QID)
    for index, pdata in ipairs(ListDialog.items) do
        if pdata[1] == QID then
            ListDialog.Item_Select(index)
            return true
        end
    end
end

function ListDialog.Item_SelectQIDFind(QID)
    local is_in = {}
    for index, pdata in ipairs(ListDialog.items) do
        is_in[pdata[1]] = index
        if pdata[1] == QID then
            ListDialog.Item_Select(index)
            return true
        end
    end

    -- search prev/post
    local index, childs, dir = findQuestDeep(is_in, QID)
    if index then
        table.insert(childs, QID)
        for _, child_QID in ipairs(childs) do
            if dir then
                index = item_AddChildren(index)
            else
                index = item_AddParent(index)
            end

            while index < #ListDialog.items and ListDialog.items[index][1] ~= child_QID do
                index = index + 1
            end
        end

        ListDialog.Item_Select(index, true)
        ListDialog.UpdateItemCount()
        return true
    end
end

function ListDialog.Item_Select(index, do_full_repaint)
    ListDialog.selection = index

    local top = QHQuestListItemsSB:GetValue()
    QHQuestListAbortQuest:Disable()

    if index then
        local QID = ListDialog.items[index][1]
        QH.DetailDialog.ShowQuestDetails(QID)

        if QH.QB.IsIn(QID) then
            QHQuestListAbortQuest:Enable()
        end

        if index <= top then
            top = math.max(0, index - (1 + MAX_LINES / 2))
            do_full_repaint = true
            QHQuestListItemsSB:SetValue(top)
        elseif index > top + MAX_LINES then
            top = math.max(0, index - MAX_LINES / 2)
            do_full_repaint = true
            QHQuestListItemsSB:SetValue(top)
        end
    else
        QHQuestDetails:Hide()
    end

    if do_full_repaint then
        ListDialog.UpdateList()
    else
        local sel_index = (index or 0) - top
        for i = 1, MAX_LINES do
            local hilit = _G["QHQuestListItems" .. i .. "Highlight"]
            if sel_index == i then
                hilit:Show()
            else
                hilit:Hide()
            end
        end
    end
end
