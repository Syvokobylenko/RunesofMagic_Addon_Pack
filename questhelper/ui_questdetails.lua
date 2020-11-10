------------------------------------------------------
-- QuestHelper
--
-- file: ui_questdetails
-- desc: - quest list dialog
--       - quest detail database
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2020-01-19T8:48:21Z
------------------------------------------------------

local DetailDialog = {}
_G.QH.DetailDialog = DetailDialog
local QDB = QH.QDB

local Nyx = LibStub("Nyx")

local function Frame_Show(frame, state)
    if state then
        frame:Show()
        if frame.baseheight then
            frame:SetHeight(frame.baseheight)
        end
    else
        if not frame.baseheight then
            if frame:GetHeight() > 0 then
                frame.baseheight = frame:GetHeight()
            end
        end

        frame:SetHeight(0)
        frame:Hide()
    end
end

local function Frame_SetHeight(frame, height)
    frame.baseheight = height
    if frame:IsVisible() then
        frame:SetHeight(height)
    end
end

local function SetTitle(frame, title, subframe)
    local tf = _G[frame:GetName() .. "Text"]

    tf:SetText(title)
    tf:SetWidth(tf:GetDisplayWidth())
    frame.subframe = subframe
    if subframe then
        Frame_SetHeight(subframe, subframe:GetHeight())
    end
end

function DetailDialog.OnLoad(this)
    UIPanelBackdropFrame_SetTexture(this, "Interface/Common/PanelCommonFrame", 256, 256)

    this:RegisterEvent("RESET_QUESTTRACK")
end

function DetailDialog.Init()
    DetailDialog.InitLabels()

    DetailDialog.OnTitleClick(QHQuestDetailsFullTitle, false)
    DetailDialog.OnTitleClick(QHPositionstTitle, false)
end

function DetailDialog.InitLabels()
    SetTitle(QHQuestDetailsShortTitle, QH.L.DETAILS_Title_Short, QHQuestDetailsShort)
    SetTitle(QHPrerequisitTitle, QH.L.DETAILS_Title_Prerequisit, QHPrerequisit)
    SetTitle(QHPositionstTitle, QH.L.DETAILS_Title_Positions, QHPositions)
    SetTitle(QHQuestDetailsFullTitle, QH.L.DETAILS_Title_FullText, QHQuestDetailsFullDesc)
    SetTitle(QHRewardlTitle, QH.L.DETAILS_Title_Reward, QHReward)

    QHQuestDetailsShortHint:SetText(QH.L.DETAILS_Hint)
    QHRewardXPName:SetText(QH.L.DETAILS_Reward_XP)
    QHRewardMoneyName:SetText(QH.L.DETAILS_Reward_Money)

    QHRewardChoiceItemsTitle:SetText(QH.L.DETAILS_Choice)
    QHRewardItemsTitle:SetText(QH.L.DETAILS_Items)
end

function DetailDialog.OnShow(this)
    QDB.Load()

    this:ClearAllAnchors()
    if QHQuestList:IsVisible() then
        this:SetAnchor("TOPLEFT", "TOPRIGHT", QHQuestList, 0, 0)
        QHQuestDetailsQuestList:Hide()
        QHQuestDetailsAbortQuest:Hide()
    else
        local pos = {QHQuestList:GetAnchor()}
        this:SetAnchor(unpack(pos))
        QHQuestDetailsQuestList:Show()
        QHQuestDetailsAbortQuest:Show()
    end
end

function DetailDialog.OnHide(this)
    QDB.Release()
end

function QH.DetailDialog.OnEvent()
    if QHQuestDetails:IsVisible() then
        DetailDialog.ShowQuestDetails(DetailDialog.cur_QID)
    end
end

function DetailDialog.OnTitleClick(this, force_state)
    if this.subframe then
        local state = force_state or not this.subframe:IsVisible()

        Frame_Show(this.subframe, state)
        if state then
            this:SetHeight(20)
            _G[this:GetName() .. "Indicator"]:SetRotate(0)
        else
            this:SetHeight(16)
            _G[this:GetName() .. "Indicator"]:SetRotate(3.14 * 1.5)
        end

        QHQuestDetailsScrollFrame:UpdateScrollChildRect()
    end
end

local function SetNPC(frame_name, npc_id, pos)
    local npcID, name, map, x, y

    if npc_id then
        npcID, name, map, x, y = QH.Map.GetNPCInfo(npc_id)

        if not npcID then
            name = nil
            map = nil
            x = nil
            y = nil
        end
    end

    if pos then
        map = pos.m or map
        x = pos.x or x
        y = pos.y or y
    end

    _G[frame_name].npc_id = npcID
    _G[frame_name].map = map
    _G[frame_name].map_x = x
    _G[frame_name].map_y = y

    if not name and npc_id then
        name = TEXT("Sys" .. npc_id .. "_name")
        if name == "Sys" .. npc_id .. "_name" then
            name = nil
        end
    end

    _G[frame_name .. "TextName"]:SetText(name)

    if map then
        local zone = GetZoneLocalName(map) or ""
        local pos = ""
        if x and y then
            pos = string.format(" %.1f/%.1f", x * 100, y * 100)
        end

        _G[frame_name .. "TextPos"]:SetText(zone .. pos)
        _G[frame_name .. "Search"]:Show()
    else
        _G[frame_name .. "TextPos"]:SetText()

        if name then
            _G[frame_name .. "Search"]:Show()
        else
            _G[frame_name .. "Search"]:Hide()
        end
    end

    if npcID then
        _G[frame_name .. "Search"]:Enable()
    else
        _G[frame_name .. "Search"]:Disable()
    end

    return (map and name and name ~= "")
end

function DetailDialog.OnNPCClicked(this)
    if this.npc_id then
        local npcID, name = QH.Map.GetNPCInfo(this.npc_id)

        ChatFrameDropDown.hyperlinkType = "npc"
        ChatFrameDropDown.npcID = npcID
        ChatFrameDropDown.npcName = name
        ToggleDropDownMenu(ChatFrameDropDown, 1, nil, "cursor", 0, 0)
    end
end

function DetailDialog.OnNPCEnter(this)
    if this.npc_id then
        SetHyperlinkCursor(true)
    end
end

function DetailDialog.OnNPCLeave()
    SetHyperlinkCursor(false)
end

function DetailDialog.OnNPCSearch(this)
    if this.npc_id then
        NpcTrackFrame:Show()
        NpcTrackFrame_InitializeNpcList(this.npc_id)
        NpcTrackFrame:ResetFrameOrder()
    end
end

--- SECTION: Short
local function ShortText(QID)
    local text = Nyx.GetQuestBookTextWithLinks(QID)
    QHQuestDetailsShortDesc:ClearText()
    QHQuestDetailsShortDesc:AddMessage(text)
    QHQuestDetailsShortDescTemp:SetText(text)
    local Height = QHQuestDetailsShortDescTemp:GetHeight()
    Frame_SetHeight(QHQuestDetailsShortDesc, Height + 1)
end

local function QuestGoals(QID, qdata)
    local GIDs, counts, prefixs = QH.QDB.GetQuestGoals(qdata)

    local name = "QHQuestDetailsShortItem"
    for i = 1, 15 do
        _G[name .. i]:Hide()
        _G[name .. i]:SetHeight(0)
    end

    local height = 0
    for i, GID in ipairs(GIDs) do
        local frame = _G[name .. i]

        local isfin, cur_count = QH.QB.GetGoalState(QID, GID)

        local pre = prefixs[i]
        local text = TEXT("Sys" .. GID .. "_name")

        if counts[i] > 0 then
            assert(counts[i])
            text = string.format("%s %i/%i", text, cur_count or 0, counts[i])
        end

        if (pre % 16) > 1 then
            if pre < 16 then
                text = TEXT(string.format("Q_REQUEST_ITEMSTR_%02i", pre)) .. text
            else
                text = TEXT(string.format("Q_REQUEST_KILLSTR_%02i", pre - 16)) .. text
            end
        end

        if isfin then
            text = text .. TEXT("QUEST_MSG_REQUEST_COMPLETE")
        end

        frame:SetText(text)
        local lines = math.ceil(frame:GetDisplayWidth() / 380)
        frame:SetHeight(lines * 14)

        frame:Show()
        height = height + lines * 14
        if i > 1 then
            height = height + 4
        end
    end

    Frame_SetHeight(_G[name], height)
end

local function SectionShort(QID, qdata)
    ShortText(QID)
    QuestGoals(QID, qdata)

    local height = 8 + QHQuestDetailsShortDesc:GetHeight() + QHQuestDetailsShortItem:GetHeight()

    if #QDB.GetRelatedItems(qdata) > 0 or #QDB.GetRelatedMobs(qdata) > 0 then
        height = height + 12
        QHQuestDetailsShortHint:Show()
    else
        QHQuestDetailsShortHint:Hide()
    end

    Frame_SetHeight(QHQuestDetailsShort, 8 + height)
end

local function addRelatedItems(qdata)
    local related = QDB.GetRelatedItems(qdata)
    if #related == 0 then
        return ""
    end

    local t = ""
    for _, entry in ipairs(related) do
        local c = ""
        if entry.count > 1 then
            c = entry.count .. "x"
        end
        local x =
            string.gsub(
            QH.L.DETAILS_HintUse,
            "<(.-)>",
            {
                USE = "|cff3050ff[" .. TEXT("Sys" .. entry.use .. "_name") .. "]|r",
                ITEM = c .. TEXT("SYS_COLOR_ITEM") .. "[" .. TEXT("Sys" .. entry.item .. "_name") .. "]|r",
                PERCENT = entry.percent
            }
        )

        GameTooltip:AddLine(x .. "\n")
    end

    return t
end

local function addRelatedMobs(qdata)
    local related = QDB.GetRelatedMobs(qdata)
    if #related == 0 then
        return ""
    end

    local t = ""
    for _, entry in ipairs(related) do
        local c = ""
        if entry.count > 1 then
            c = entry.count .. "x"
        end
        local x =
            string.gsub(
            QH.L.DETAILS_HintKill,
            "<(.-)>",
            {
                MOB = "|cff3050ff[" .. TEXT("Sys" .. entry.use .. "_name") .. "]|r",
                ITEM = c .. TEXT("SYS_COLOR_ITEM") .. "[" .. TEXT("Sys" .. entry.item .. "_name") .. "]|r",
                PERCENT = entry.percent
            }
        )

        GameTooltip:AddLine(x .. "\n")
    end

    return t
end

function QH.QDB.ShowHint(this)
    if GameTooltip:IsVisible() then
        GameTooltip:Hide()
        return
    end

    local qdata = QDB.GetQuest(DetailDialog.cur_QID)

    GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -5, 0)
    GameTooltip:SetText(TEXT("Sys" .. DetailDialog.cur_QID .. "_name"))
    addRelatedItems(qdata)
    addRelatedMobs(qdata)
end

--- SECTION: Perequisit
local function QuestWarning(QID, qdata)
    local text

    -- min. level
    local _, minlvl, _ = QDB.GetLevel(qdata)
    if UnitLevel("player") < minlvl then
        text = string.format(QH.L.DETAILS_WarnLevel, minlvl)
    end

    -- already done
    if CheckQuest(QID)==2 then
        if QDB.IsLoopable(qdata) then
            text = "|cff500000" .. QH.L.DETAILS_WarnDoneButLoop
        else
            text = QH.L.DETAILS_WarnDone
        end
    end

    QHPrerequisitWarning:SetText(text)
    Frame_Show(QHPrerequisitWarning, text)

    return QHPrerequisitWarning:GetHeight()
end

local function StartNPC(QID, qdata)
    for i = 1, 5 do
        Frame_Show(_G["QHPrerequisitNPC" .. i], false)
    end

    local height = 0
    for i, npc in ipairs(QDB.GetStartNPC(qdata)) do
        assert(i < 6)

        local fname = "QHPrerequisitNPC" .. i
        local valid = SetNPC(fname, npc)

        if valid then
            Frame_Show(_G[fname], true)
            height = height + _G[fname]:GetHeight()
        end
    end

    Frame_SetHeight(QHPrerequisitNPC, height)
    return height
end

local function Prerequisit(QID, qdata)
    local pre_quest, pre_flags = QDB.GetPrerequisits(qdata)
    if #pre_quest == 0 and #pre_flags == 0 then
        QHPrerequisitText:Hide()
        return 0
    end

    local text = QH.L.DETAILS_Precondition .. ":\n"

    for _, q in ipairs(pre_quest) do
        local name = string.format("%s: %s", QH.L.DETAILS_Precondition_Quest, TEXT("Sys" .. q .. "_name"))
        if QH_Options.debug then
            name = name .. string.format(" (%i)", q)
        end

        if CheckQuest(q)~=2 then
            name = "|cffff0000"..name.."|r"
        end
        text = text .. name .. "\n"
    end

    for _, f in ipairs(pre_flags) do
        local sid = "Sys" .. f .. "_name"
        local name = TEXT(sid)
        if name == sid then
            -- maybe queststate can help?
            if (QuestState and QuestState.util and QuestState.util.TEXT) then
                name = QuestState.util.TEXT(f)
            else
                name = QH.L.DETAILS_Precondition_Flag .. ": " .. f
            end
        end

        if CheckFlag(f) ~= 1 then
            name = "|cffff0000" .. name .. "|r"
        end
        text = text .. name .. "\n"
    end

    QHPrerequisitText:ClearAllAnchors()
    QHPrerequisitText:SetAnchor("TOPLEFT", "BOTTOMLEFT", QHPrerequisitNPC, 0, 4)

    QHPrerequisitText:SetText(text)
    QHPrerequisitText:Show()
    return QHPrerequisitText:GetHeight() + 4
end

local function SectionPrerequisit(QID, qdata)
    local height = QuestWarning(QID, qdata)
    height = height + StartNPC(QID, qdata)
    height = height + Prerequisit(QID, qdata)

    Frame_SetHeight(QHPrerequisit, height + 1)
end

--- SECTION Positions
local function SetMapFrame(frame, QID, GID, MAP)
    local map_pos = QH.DB.GetMaps(GID)
    local pos = map_pos[MAP]

    frame.quest = {QID, GID, MAP}
    local frame_title = _G[frame:GetName() .. "TextName"]
    local frame_pos = _G[frame:GetName() .. "TextPos"]
    local frame_btn = _G[frame:GetName() .. "Map"]

    frame_title:SetText(GetZoneLocalName(MAP))

    if pos then
        local collect = {}
        for _, p in ipairs(pos) do
            table.insert(collect, string.format("%2.1f/%2.1f", p[1] * 100, p[2] * 100))
        end
        frame_pos:SetText(table.concat(collect, ", "))
        frame_pos:Show()
        frame_btn:Enable()
    else
        frame_pos:Hide()
        frame_btn:Disable()
    end
end

function DetailDialog.OnShowMap(this)
    assert(this.quest)
    QH.UI_map.HighlightQuest(this.quest[1], this.quest[2])
    WorldMapFrame:Show()
    WorldMapFrame_SetWorldMapID(this.quest[3])
end

local function SectionPositions(QID)
    local y = 0
    local goal = 1
    local map = 1

    local GIDs = QH.DB.GetGoals(QID)
    for _, GID in ipairs(GIDs) do
        local map_pos = QH.DB.GetMaps(GID)

        if map_pos and not (map_pos[0] and map_pos[0].g) then
            local frame = _G["QHPositionsTitle" .. goal]
            goal = goal + 1
            if not frame then
                QH.API.DebugErr("Too much goals")
                break
            end

            frame:SetText(TEXT("Sys" .. GID .. "_name"))
            frame:ClearAllAnchors()
            frame:SetAnchor("TOPLEFT", "TOPLEFT", QHPositions, 0, y)
            frame:Show()
            y = y + frame:GetHeight()

            for MAP, _ in pairs(map_pos) do
                local frame = _G["QHPositionsPos" .. map]
                map = map + 1

                if not frame then
                    QH.API.DebugErr("Too much maps")
                    break
                end

                SetMapFrame(frame, QID, GID, MAP)
                frame:ClearAllAnchors()
                frame:SetAnchor("TOPLEFT", "TOPLEFT", QHPositions, 0, y)
                frame:Show()
                y = y + frame:GetHeight()
            end
        end
    end

    while _G["QHPositionsTitle" .. goal] do
        _G["QHPositionsTitle" .. goal]:Hide()
        goal = goal + 1
    end
    while _G["QHPositionsPos" .. map] do
        _G["QHPositionsPos" .. map]:Hide()
        map = map + 1
    end

    Frame_SetHeight(QHPositions, y + 1 + 4)
end

--- SECTION Full-Description
local function SectionDescription(QID)
    local text = Nyx.GetFullQuestBookTextWithLinks(QID)
    QHQuestDetailsFullDesc:ClearText()
    QHQuestDetailsFullDesc:AddMessage(text)
    QHQuestDetailsFullDescTemp:SetText(text)
    local Height = QHQuestDetailsFullDescTemp:GetHeight()
    Frame_SetHeight(QHQuestDetailsFullDesc, Height + 1 + 4)
end

--- SECTION Reward
local function FormatNumber(number)
    local left, num, right = string.match(tostring(number), "^([^%d]*%d)(%d*)(.-)$")
    num = num:reverse():gsub("(%d%d%d)", "%1" .. COMMA)
    return left .. (num:reverse())
end

local function SetRewarditems(qdata, chooseabel, frame)
    local count = QDB.GetRewardItemsCount(qdata, chooseabel)
    for i = 1, count do
        local id, count, texture = QDB.GetRewardItem(qdata, chooseabel, i)

        local btn_name = frame .. "_Item" .. i
        _G[btn_name .. "_Texture"]:SetTexture(texture)
        if count > 1 then
            _G[btn_name .. "_Count"]:SetText(count)
            _G[btn_name .. "_Count"]:Show()
        else
            _G[btn_name .. "_Count"]:Hide()
        end

        _G[btn_name].ItemID = id
        _G[btn_name]:Show()
    end

    for i = count + 1, 4 do
        local btn_name = frame .. "_Item" .. i
        _G[btn_name]:Hide()
    end

    if count == 0 then
        _G[frame .. "Title"]:Hide()
    else
        _G[frame .. "Title"]:Show()
    end
end

function DetailDialog.OnEnter_QuestRewardButton(this)
    GameTooltip:ClearAllAnchors()
    local x, y = GetCursorPos()
    GameTooltip:ClearAllAnchors()
    GameTooltip:SetAnchor("TOPLEFT", "TOPLEFT", UIParent, x, y)
    local link = Nyx.CreateItemLink(this.ItemID)
    GameTooltip:SetHyperLink(link)
end

function DetailDialog.OnLeave_QuestRewardButton(this)
    GameTooltip:Hide()
end

function DetailDialog.OnClick_QuestRewardButton(this)
    local link = Nyx.CreateItemLink(this.ItemID)
    ItemPreviewFrame_SetItemLink(ItemPreviewFrame, link)
end

local function SectionReward(QID, qdata)
    local xp, tp, gold = QH.QDB.GetReward(qdata)
    QHRewardXP:SetText(FormatNumber(xp) .. " / " .. FormatNumber(tp))
    MoneyFrame_Update("QHRewardMoney", gold)

    local p = {}
    p.m, p.x, p.y = QH.DB.GetStoredRewardNPC(QID)
    local npcid = QH.QDB.GetRewardNPC(qdata)
    SetNPC("QHRewardNPC", npcid, p)

    SetRewarditems(qdata, true, "QHRewardChoiceItems")
    SetRewarditems(qdata, false, "QHRewardItems")
end

function DetailDialog.ShowQuestDetails(QID)
    QHQuestDetails:Show()

    local qdata = QH.QDB.GetQuest(QID)
    if not qdata then
        QHQuestDetails:Hide()
        return
    end

    DetailDialog.cur_QID = QID

    if QH_Options.debug then
        QHQuestDetailsTitle:SetText(string.format("%s (%i)", TEXT("Sys" .. QID .. "_name"), QID))
    else
        QHQuestDetailsTitle:SetText(TEXT("Sys" .. QID .. "_name"))
    end

    SectionShort(QID, qdata)
    SectionPrerequisit(QID, qdata)
    SectionPositions(QID)
    SectionDescription(QID)
    SectionReward(QID, qdata)

    QHQuestDetailsScrollFrame:UpdateScrollChildRect()
end

function DetailDialog.ShowQuest(QID)
    if QHQuestDetails:IsVisible() and QID == DetailDialog.cur_QID then
        QHQuestDetails:Hide()
    else
        if QHQuestList:IsVisible() then
            QH.ListDialog.Item_SelectQID(QID)
        end

        DetailDialog.ShowQuestDetails(QID)
    end
end

function DetailDialog.OnQuestGiveUp()
    QH.QB.CancelQuestDirect(DetailDialog.cur_QID)
    QHQuestDetails:Hide()
end

function DetailDialog.OnQuestList()
    QHQuestList:Show()
end

function DetailDialog.GetCurrentQID()
    return DetailDialog.cur_QID
end

function DetailDialog.DoUpdate()
    if QHQuestDetails:IsVisible() then
        local QID = DetailDialog.cur_QID
        local qdata = QH.QDB.GetQuest(QID)
        SectionShort(QID, qdata)
    end
end
