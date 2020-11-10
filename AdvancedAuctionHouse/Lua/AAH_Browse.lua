local Browse = {
	DisplayedItems = 7,
	SortMode = 0,
	CustomSortItem1 = "level",
	CustomSortItem2 = "tier",
	CurrentCustomHeaderID = 0,
	Cache = {},
	Results = {},
	LastSearch = {},
	LastCached = 0,
	MaxPageItems = 50,
	CurrentCachePage = 1,
	CurrentFilterPage = 0,
	CurrentFilterItem = 0,
	MaxPages = 0,
	BuyoutEvent = false,
	FilteringActive = false,
    selected_auctionid=nil,
	SelectedCategory = {},
    CategoryButtonNums = 0,
    CategoryScrollValue = 0,
	RarityInfo = {
		TEXT("C_ALL"),
		TEXT("ITEM_QUALITY1_DESC"),
		TEXT("ITEM_QUALITY2_DESC"),
		TEXT("ITEM_QUALITY3_DESC"),
		TEXT("ITEM_QUALITY4_DESC"),
		TEXT("ITEM_QUALITY5_DESC"),
		TEXT("UNUSUAL_LV6"),
		TEXT("UNUSUAL_LV7"),
		TEXT("ACCOUNT_SHOP"),
		TEXT("UNUSUAL_LV9"),
		TEXT("UNUSUAL_LV10"),
	},
	RuneInfo = {
		"0+",
		"1+",
		"2+",
		"3+",
		"4+",
	},
}
AAH.Browse = Browse

local FILTER_DELAY = 2
local ABORT_DELAY = 6
local SEARCH_DELAY_START = 6
local SEARCH_DELAY_RETRY = 1
local SEARCH_DELAY_NEXTPAGE = 6

local SearchRequested
local FilterChanged
local AwaitingData
local CachingActive

local SearchDelay = ABORT_DELAY
local FilterDelay = FILTER_DELAY
local TimeRemaining = SEARCH_DELAY_START

local HeaderList = {
    -- Menu text, colum header text, internal value, category
    --General
    {C_LEVEL, C_LEVEL, "level", "GENERAL"},
    {AAHLocale.Messages.GENERAL_TIER_HEADER, AAHLocale.Messages.GENERAL_TIER_HEADER, "tier", "GENERAL"},
    {AAHLocale.Messages.GENERAL_PLUS_HEADER, AAHLocale.Messages.GENERAL_PLUS_HEADER, "plus", "GENERAL"},
    {AAHLocale.Messages.GENERAL_WORTH_HEADER, AAHLocale.Messages.GENERAL_WORTH_HEADER, "worth", "GENERAL"},
    {TEXT("SYS_ITEM_DURABLE"),    AAHLocale.Messages.GENERAL_DURA_HEADER, "dura", "GENERAL"},
    {TEXT("SYS_WEAPON_MDMG"),     AAHLocale.Messages.GENERAL_MDAM_HEADER, "mdam", "GENERAL"},
    {TEXT("SYS_WEAPON_DMG"),      AAHLocale.Messages.GENERAL_PDAM_HEADER, "pdam", "GENERAL"},
    {TEXT("SYS_WEAPON_ATKSPEED"), AAHLocale.Messages.GENERAL_SPEED_HEADER, "speed", "GENERAL"},
    {AAHLocale.Messages.GENERAL_DPS_HEADER, AAHLocale.Messages.GENERAL_DPS_HEADER, "dps", "GENERAL"},
    --Stats
    {TEXT("SYS_WEAREQTYPE_3"), AAHLocale.Messages.GENERAL_STAM_HEADER, "sta", "STATS"},
    {TEXT("SYS_WEAREQTYPE_2"), AAHLocale.Messages.GENERAL_STR_HEADER,  "str", "STATS"},
    {TEXT("SYS_WEAREQTYPE_6"), AAHLocale.Messages.GENERAL_DEX_HEADER,  "dex", "STATS"},
    {TEXT("SYS_WEAREQTYPE_5"), AAHLocale.Messages.GENERAL_WIS_HEADER,  "wis", "STATS"},
    {TEXT("SYS_WEAREQTYPE_4"), AAHLocale.Messages.GENERAL_INTEL_HEADER,"int", "STATS"},
    {TEXT("SYS_WEAREQTYPE_8"), AAHLocale.Messages.GENERAL_HP_HEADER,   "hp",  "STATS"},
    {TEXT("SYS_WEAREQTYPE_9"), AAHLocale.Messages.GENERAL_MP_HEADER,   "mp",  "STATS"},
    {TEXT("SYS_WEAREQTYPE_12"),AAHLocale.Messages.GENERAL_PATT_HEADER, "patt","STATS"},
    {TEXT("SYS_WEAREQTYPE_15"),AAHLocale.Messages.GENERAL_MATT_HEADER, "matt","STATS"},
    {TEXT("SYS_ARMOR_DEF"),    AAHLocale.Messages.GENERAL_PDEF_HEADER, "pdef","STATS"},
    {TEXT("SYS_ARMOR_MDEF"),   AAHLocale.Messages.GENERAL_MDEF_HEADER, "mdef","STATS"},
    --Attributes
    {TEXT("SYS_WEAREQTYPE_18"), AAHLocale.Messages.GENERAL_PCRIT_HEADER, "pcrit","ATTRIBUTES"},
    {TEXT("SYS_WEAREQTYPE_20"), AAHLocale.Messages.GENERAL_MCRIT_HEADER, "mcrit","ATTRIBUTES"},
    {TEXT("SYS_WEAREQTYPE_16"), AAHLocale.Messages.GENERAL_PACC_HEADER,  "pacc", "ATTRIBUTES"},
    {TEXT("SYS_WEAREQTYPE_195"),AAHLocale.Messages.GENERAL_MACC_HEADER,  "macc", "ATTRIBUTES"},
    {TEXT("SYS_WEAREQTYPE_17"), AAHLocale.Messages.GENERAL_PDOD_HEADER,  "pdod", "ATTRIBUTES"},
    {TEXT("SYS_WEAREQTYPE_22"), AAHLocale.Messages.GENERAL_PARRY_HEADER, "parry","ATTRIBUTES"},
    {TEXT("SYS_WEAREQTYPE_150"),AAHLocale.Messages.GENERAL_HEAL_HEADER,  "heal", "ATTRIBUTES"},
    --Other
}
local HeaderFrames = {
	"AAH_BrowseHeaderName",
	"AAH_BrowseHeaderCustom1",
	"AAH_BrowseHeaderCustom2",
	"AAH_BrowseHeaderLeftTime",
	"AAH_BrowseHeaderSeller",
	"AAH_BrowseHeaderPPU",
	"AAH_BrowseHeaderPrice",
}

local function ToNum(str)
	local n = tonumber(string.match(str, "[%d%.]+"))
	if not n then
		n = tonumber(string.match(str, "%d+%.%d+"))
	end
	return n or 0
end

local function Trim(str)
	return string.match(str, "^%s*(.-)%s*$")
end

Browse.KeyFinderTable = { -- resolve strings in tooltips to their types
	[Trim(TEXT("PET_LEVEL"))] = "level",
	[string.gsub(TEXT("SYS_TOOLTIP_RUNE_LEVEL"), " %%.", "")] = "tier", -- fix the " %d" pattern placement in this loca string
	[Trim(TEXT("SYS_ITEM_COST"))] = "worth",
	[Trim(TEXT("SYS_WEAPON_DMG"))] = "pdam",
	[Trim(TEXT("SYS_WEAPON_MDMG"))] = "mdam",
	[Trim(TEXT("SYS_ARMOR_DEF"))] = "pdef",
	[Trim(TEXT("SYS_ARMOR_MDEF"))] = "mdef",
	[Trim(TEXT("SYS_WEAREQTYPE_3"))] = "sta",
	[Trim(TEXT("SYS_WEAREQTYPE_2"))] = "str",
	[Trim(TEXT("SYS_WEAREQTYPE_6"))] = "dex",
	[Trim(TEXT("SYS_WEAREQTYPE_5"))] = "wis",
	[Trim(TEXT("SYS_WEAREQTYPE_4"))] = "int",
	[Trim(TEXT("SYS_WEAREQTYPE_13"))] = "pdef",
	[Trim(TEXT("SYS_WEAREQTYPE_14"))] = "mdef",
	[Trim(TEXT("SYS_WEAREQTYPE_12"))] = "patt",
	[Trim(TEXT("SYS_WEAREQTYPE_15"))] = "matt",
	[Trim(TEXT("SYS_WEAREQTYPE_8"))] = "hp",
	[Trim(TEXT("SYS_WEAREQTYPE_9"))] = "mp",
	[Trim(TEXT("SYS_WEAREQTYPE_18"))] = "pcrit",
	[Trim(TEXT("SYS_WEAREQTYPE_20"))] = "mcrit",
	[Trim(TEXT("SYS_WEAREQTYPE_16"))] = "pacc",
	[Trim(TEXT("SYS_WEAREQTYPE_195"))] = "macc",
	[Trim(TEXT("SYS_WEAREQTYPE_17"))] = "pdod",
	[Trim(TEXT("SYS_WEAREQTYPE_150"))] = "heal",
	[Trim(TEXT("SYS_WEAREQTYPE_22"))] = "parry",
	[Trim(TEXT("SYS_WEAREQTYPE_25"))] = "pdam",
	[Trim(TEXT("SYS_WEAREQTYPE_191"))] = "mdam",
	[Trim(TEXT("SYS_WEAPON_ATKSPEED"))] = "speed",
	[Trim(TEXT("SYS_ITEM_DURABLE"))] = "dura",
}

function Browse.Resize(num, value)
	AAH_BrowseList:SetSize(666, 340 + value)
	AAH_BrowseCategory:SetSize(142, 340 + value)
	Browse.DisplayedItems = 7 + num
	for i = Browse.DisplayedItems + 1, 12 do
		getglobal("AAH_BrowseListItem"..i):Hide()
	end
	for i = (Browse.DisplayedItems * 2) + 1, 24 do
		getglobal("AAH_BrowseCategoryButton"..i):Hide()
	end
	for i = (Browse.DisplayedItems * 2) + 7, 30 do
		getglobal("AAH_BrowseSavedSearchButton"..i):Hide()
	end

	Browse.List_Update()
	Browse.CategoryScrollBar_Update()
	AAH.SavedSearch.ScrollBar_Update()
end

function Browse.Frame_OnLoad(this)
	AAH_BrowseHeaderPPU:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER)
	AAH_BrowseHeaderCustom2:SetText(AAHLocale.Messages.GENERAL_TIER_HEADER)

	for _, Header in pairs(HeaderFrames) do
		_G[Header]:SetWidth(_G[Header]:GetTextWidth() + 12)
	end

	AAH_BrowseHeaderCustom1:SetTextColor(0.6,0.8,1)
	AAH_BrowseHeaderCustom2:SetTextColor(0.6,0.8,1)
	UIDropDownMenu_Initialize(AAH_BrowseHeaderCustom1Menu, Browse.HeaderCustomMenu, "MENU")
	UIDropDownMenu_Initialize(AAH_BrowseHeaderCustom2Menu, Browse.HeaderCustomMenu, "MENU")

	AAH_BrowseUsableButtonLabel:SetText(AAHLocale.Messages.BROWSE_USABLE)
	AAH_BrowseResetButton:SetText(AAHLocale.Messages.BROWSE_CLEAR_BUTTON)
	AAH_BrowseFilterPPUButtonLabel:SetText(AAHLocale.Messages.BROWSE_PPU)
	AAH_BrowseFilterMinPriceEditBoxLabel:SetText(AAHLocale.Messages.BROWSE_MIN)
	AAH_BrowseFilterMaxPriceButtonLabel:SetText(AAHLocale.Messages.BROWSE_MAX)
	AAH_BrowseFilter1EditBoxLabel:SetText(AAHLocale.Messages.BROWSE_FILTER)
	AAH_BrowseFilter2OrButtonLabel:SetText(AAHLocale.Messages.BROWSE_OR)
	AAH_BrowseFilter3OrButtonLabel:SetText(AAHLocale.Messages.BROWSE_OR)
	AAH_BrowseSearchLabel:SetText(AAHLocale.Messages.BROWSE_SEARCH_PARAMETERS)

    UIDropDownMenu_SetWidth(AAH_BrowseRuneDropDown, 60)
    UIDropDownMenu_Initialize(AAH_BrowseRuneDropDown, Browse.RuneDropDown_Show)
    UIDropDownMenu_SetWidth(AAH_BrowseRarityDropDown, 80)
    UIDropDownMenu_Initialize(AAH_BrowseRarityDropDown, Browse.RarityDropDown_Show)

	Browse.PrepareCachedSearch()
end

function Browse.Frame_OnUpdate(this, elapsedTime)

	if SearchRequested then
		SearchDelay = SearchDelay - elapsedTime
        if SearchDelay <= 0 then
            SearchRequested = false
            Browse.ExecuteSearch()
        end
	end

	if AAH.History.Processing then
		AAH.History.Queue_Process()
	end

	if Browse.FilteringActive then
        Browse.DoFilteringStep()
	end

	if FilterChanged then
		FilterDelay = FilterDelay - elapsedTime
        if FilterDelay <=0 then
            FilterChanged = false
            Browse.List_Update()
			if AAH_HistoryList:IsVisible() and not AAH.History.Processing and AAH.History.PriceHistoryProcessed then
				AAH.History.List_FilterItems()
				AAH.History.List_UpdateItems()
			end
        end
	end

	if CachingActive then
		TimeRemaining = TimeRemaining - elapsedTime

        if TimeRemaining <= 0 then
            if Browse.CurrentCachePage <= Browse.MaxPages then
                if Browse.CurrentCachePage == 1 then
                    Browse.CachePage(true)
                elseif AwaitingData then
                    Browse.CachePage(false)
                elseif AuctionBrowseNextPage(Browse.CurrentCachePage) then
                    Browse.CachePage(false)
                else
                    TimeRemaining = SEARCH_DELAY_RETRY
                end
            else
                CachingActive = nil
            end
        end
	end
end

function AAH.Events.AUCTION_BROWSE_UPDATE(this)
	if Browse.BuyoutEvent == true then
		Browse.BuyoutEvent = false
        Browse.Event_OnBuyout()
	end

	if Browse.CurrentCachePage == 1 and Browse.Cache.PAGEREADY[1] == false and CachingActive then
		Browse.MaxPages = GetAuctionBrowseMaxPages()
		if GetAuctionBrowseMaxItems() == 0 then
			CachingActive = nil
			AAH_BrowseProgressLabel:SetText(AAHLocale.Messages.BROWSE_NO_RESULTS)
		else
			TimeRemaining = 0
		end
	end
end

function Browse.Event_OnBuyout()
    local idx, info = Browse.List_GetSelected()
    assert(idx)
    local auctionid = info.auctionid
    table.remove(Browse.Results.list, idx)
    Browse.Cache_ClearAuction(auctionid)

    if idx>#Browse.Results.list then idx=idx-1 end
    Browse.List_SetSelected(Browse.Results.list[idx] and Browse.Results.list[idx].auctionid)

    Browse.List_UpdateItems()
end

function AAH.Events.AUCTION_SEARCH_RESULT()
	TimeRemaining = 0
	AAH_BrowseSearchButton:Enable()
end

function AAH.Events.AUCTION_BORWSE_PRICE_UPDATE(this)
    Browse.AUCTION_BORWSE_PRICE_UPDATE(arg1,arg2,arg3)
end

function Browse.AUCTION_BORWSE_PRICE_UPDATE(auctionid,bidprice,buyer)
    local cache = Browse.Cache_FindAuction(auctionid)
    if cache then
        cache.bidPrice = bidprice
        cache.isBuyer = buyer
        Browse.Cache_CalculatePPU(cache)
    end
    Browse.List_UpdateItems()
end

function Browse.DoFilteringStep()

    local old_count = #Browse.Results.list
    local old_sel_index = Browse.List_GetSelected()

    for i = 1, AAH_SavedSettings.FilterSpeed do
        while (not(Browse.Cache.PAGEREADY and Browse.Cache.PAGEREADY[Browse.CurrentFilterPage] == true and
	        Browse.Cache.CACHEDDATA[Browse.CurrentFilterPage][Browse.CurrentFilterItem] and
	        Browse.Cache.CACHEDDATA[Browse.CurrentFilterPage][Browse.CurrentFilterItem].auctionid
	        or (Browse.CurrentFilterPage > Browse.MaxPages)))
        do
            Browse.CurrentFilterItem = Browse.CurrentFilterItem + 1
            if Browse.CurrentFilterItem > Browse.MaxPageItems then
                Browse.CurrentFilterItem = 1
                Browse.CurrentFilterPage = Browse.CurrentFilterPage + 1
            end
        end
        if Browse.CurrentFilterPage > Browse.MaxPages then
            Browse.FilteringActive = false
            break
        else
            Browse.AddItemToList(Browse.CurrentFilterPage, Browse.CurrentFilterItem)

            Browse.CurrentFilterItem = Browse.CurrentFilterItem + 1
            if Browse.CurrentFilterItem > Browse.MaxPageItems then
                Browse.CurrentFilterItem = 1
                Browse.CurrentFilterPage = Browse.CurrentFilterPage + 1
            end
        end
    end


    Browse.InfoLabelUpdate()

    if old_count ~= #Browse.Results.list then

        if Browse.Results.sortIndex then
            Browse.List_Sort(Browse.Results.sortIndex)
        end

        local maxValue = #(Browse.Results.list) - Browse.DisplayedItems
        if maxValue > 0 or (Browse.Results.pageNum > 1 and maxValue == 0) then
            AAH_BrowseListScrollBar:SetMinMaxValues(0, maxValue)
            AAH_BrowseListScrollBar:Show()
        else
            AAH_BrowseListScrollBar:SetMinMaxValues(0, 0)
            AAH_BrowseListScrollBar:Hide()
        end

        local new_sel_index = Browse.List_GetSelected()
        if old_sel_index and new_sel_index then
            local first_index = AAH_BrowseListScrollBar:GetValue()

            if old_sel_index>=first_index and old_sel_index < first_index + Browse.DisplayedItems then
                AAH_BrowseListScrollBar:SetValue(first_index+new_sel_index-old_sel_index)
            end
        end

        Browse.List_UpdateItems()
    end
end

function Browse.Frame_StopUpdates()
    CachingActive = nil
	FilterChanged = false
	SearchRequested = false
	Browse.FilteringActive = false

	Browse.PrepareCachedSearch()
end

function Browse.Header_OnClick(this, key)
	local id = this:GetID()
	if key == "LBUTTON" then
		Browse.ClearSortIcons()
		if Browse.Results.sortIndex == id or Browse.Results.sortIndex == -id then
			Browse.SortMode = (Browse.SortMode + 1) % 4
		else
			Browse.SortMode = 0
		end
		if id == 7 or id == 6 then
            AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], Browse.SortMode)
		else
			if Browse.Results.sortIndex == id then
				id = -id
                AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], 1)
			else
                AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], 0)
			end
		end
		Browse.List_Sort(id)
	elseif key == "RBUTTON" then
		if id == 2 then
			Browse.CurrentCustomHeaderID = 1
			ToggleDropDownMenu(AAH_BrowseHeaderCustom1Menu)
		elseif id == 3 then
			Browse.CurrentCustomHeaderID = 2
			ToggleDropDownMenu(AAH_BrowseHeaderCustom2Menu)
		end
	end
end

local SortFunc = {
	["70"] = "SortBidLess",
	["71"] = "SortBidMore",
	["72"] = "SortBuyoutLess",
	["73"] = "SortBuyoutMore",
	["60"] = "SortBidPPULess",
	["61"] = "SortBidPPUMore",
	["62"] = "SortBuyoutPPULess",
	["63"] = "SortBuyoutPPUMore",
}

function Browse.ClearSortIcons()
	for _, name in ipairs({"Name", "Custom1", "Custom2", "LeftTime", "Seller", "PPU", "Price"}) do
		_G["AAH_BrowseHeader"..name.."SortIcon"]:SetFile("")
	end
end

function Browse.List_Sort(index)
	Browse.Results.sortIndex = index
	local i = math.abs(index)
	if i == 7 or i == 6 then
		table.sort(Browse.Results.list, AAH.Tools[SortFunc[i..Browse.SortMode]])
	else
		if i == 1 then
			AAH.Tools.CurrentSortItem = "name"
		elseif i == 2 then
			AAH.Tools.CurrentSortItem = Browse.CustomSortItem1
		elseif i == 3 then
			AAH.Tools.CurrentSortItem = Browse.CustomSortItem2
		elseif i == 4 then
			AAH.Tools.CurrentSortItem = "leftTime"
		elseif i == 5 then
			AAH.Tools.CurrentSortItem = "seller"
		end
		if Browse.Results.sortIndex > 0 then
			table.sort(Browse.Results.list, AAH.Tools.SortLess)
		else
			table.sort(Browse.Results.list, AAH.Tools.SortMore)
		end
	end
	Browse.List_UpdateItems()
end

function Browse.HeaderCustomMenu()
	local info = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		info.text = AAHLocale.Messages.BROWSE_HEADER_CUSTOM_TITLE
		info.isTitle = true
		info.notCheckable = true
		UIDropDownMenu_AddButton(info, 1)
		info = {}
		info.text = AAHLocale.Messages.GENERAL_GENERAL
		info.value = "GENERAL"
		info.notCheckable = true
		info.hasArrow = true
		UIDropDownMenu_AddButton(info, 1)
		info = {}
		info.text = AAHLocale.Messages.GENERAL_STATS
		info.value = "STATS"
		info.notCheckable = true
		info.hasArrow = true
		UIDropDownMenu_AddButton(info, 1)
		info = {}
		info.text = AAHLocale.Messages.GENERAL_ATTRIBUTES
		info.value = "ATTRIBUTES"
		info.notCheckable = true
		info.hasArrow = true
		UIDropDownMenu_AddButton(info, 1)
--		info = {}
--		info.text = AAHLocale.Messages.GENERAL_OTHER
--		info.value = "OTHER"
--		info.notCheckable = true
--		info.hasArrow = true
--		UIDropDownMenu_AddButton(info, 1)
	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for i = 1, #(HeaderList) do
			if HeaderList[i][4] == UIDROPDOWNMENU_MENU_VALUE then
				info = {}
				info.text = HeaderList[i][1]
				info.arg1 = HeaderList[i][2]
				info.value = HeaderList[i][3]
				info.arg2 = Browse.CurrentCustomHeaderID
				info.notCheckable = true
				info.func = function(button)
					Browse["CustomSortItem"..button.arg2] = button.value
					local header = getglobal("AAH_BrowseHeaderCustom"..button.arg2)
					header:SetText(button.arg1)
					header:SetWidth(header:GetTextWidth() + 12)
					if Browse.Results.sortIndex == button.arg2 + 1 or Browse.Results.sortIndex == -(button.arg2 + 1) then
						Browse.ClearSortIcons()
					end
					CloseDropDownMenus()
					Browse.List_UpdateItems()
				end
				UIDropDownMenu_AddButton(info, 2)
			end
		end
	end
end

function Browse.BidButton_OnClick(this)
	local money = AAH.MoneyFrame.GetMoney(AAH_BrowseBidMoneyInput)

    local idx, entry = Browse.List_GetSelected()
	if idx then
        AAH.Pay.PayAuction(entry, money, false, AAH.Pay.AuctionType.Browse)
	end
end

function Browse.HistoryButton_OnClick(this)
    local idx, entry = Browse.List_GetSelected()
    if idx then
        AAH.History.RequestHistoryPopup(entry.auctionid,entry.itemid)
    end
end

function Browse.BuyoutButton_OnClick(this)
    local idx, entry = Browse.List_GetSelected()
	if idx then
		AAH.Pay.PayAuction(entry, 0, true, AAH.Pay.AuctionType.Browse)
	end
end

function Browse.CategoryScrollBar_Update()
	local maxValue = GetAuctionBrowseFilterMaxItems(Browse.SelectedCategory[1], Browse.SelectedCategory[2]) - (Browse.DisplayedItems * 2)
	if maxValue > 0 then
		AAH_BrowseCategoryScrollBar:Show()
		AAH_BrowseCategoryScrollBar:SetMinMaxValues(0, maxValue)
	else
		AAH_BrowseCategoryScrollBar:Hide()
		AAH_BrowseCategoryScrollBar:SetMinMaxValues(0, 0)
	end
	Browse.Category_UpdateList()
end

function Browse.Category_UpdateList()
	Browse.CategoryButtonNums = 0
	Browse.CategoryScrollValue = AAH_BrowseCategoryScrollBar:GetValue()
	Browse.Category_SetItemInfo(1, GetAuctionBrowseFilterList())
	for i = Browse.CategoryButtonNums + 1, Browse.DisplayedItems * 2 do
		_G["AAH_BrowseCategoryButton"..i]:Hide()
	end
end

function Browse.Category_SetItemInfo(layer, ...)
	for i = 1, arg.n do
		if Browse.CategoryButtonNums >= Browse.DisplayedItems * 2 then
			return
		end
		if Browse.CategoryScrollValue > 0 then
			Browse.CategoryScrollValue = Browse.CategoryScrollValue - 1
		else
			local count = Browse.CategoryButtonNums + 1
            local bname = "AAH_BrowseCategoryButton"..count
			local button = _G[bname]
			local normalText = _G[bname.."NormalText"]
			local highlightText = _G[bname.."HighlightText"]
			local lineTexture = _G[bname.."Line"]
			local backgoundTexture = _G[bname.."Backgound"]

			local width = 116
			button.layer = layer
			button.index = i
			if layer == 1 then
				backgoundTexture:Show()
				backgoundTexture:SetAlpha(1.0)
				lineTexture:Hide()
				normalText:ClearAllAnchors()
				normalText:SetAnchor("LEFT", "LEFT", button:GetName(), 10, 0)
				normalText:SetWidth(width - 20)
				normalText:SetColor(1, 1, 0)
				highlightText:ClearAllAnchors()
				highlightText:SetAnchor("LEFT", "LEFT", button:GetName(), 10, 0)
				highlightText:SetWidth(width - 20)
				highlightText:SetColor(1, 1, 0)
			elseif layer == 2 then
				backgoundTexture:Show()
				backgoundTexture:SetAlpha(0.5)
				lineTexture:Hide()
				normalText:ClearAllAnchors()
				normalText:SetAnchor("LEFT", "LEFT", button:GetName(), 15, 0)
				normalText:SetWidth(width - 25)
				normalText:SetColor(1, 1, 1)
				highlightText:ClearAllAnchors()
				highlightText:SetAnchor("LEFT", "LEFT", button:GetName(), 15, 0)
				highlightText:SetWidth(width - 25)
				highlightText:SetColor(1, 1, 1)
			else
				backgoundTexture:Hide()
				lineTexture:Show()
				if i == arg.n then
					lineTexture:SetTexCoord(0, 1, 0.5, 0.8125)
				else
					lineTexture:SetTexCoord(0, 1, 0, 0.3125)
				end
				normalText:ClearAllAnchors()
				normalText:SetAnchor("LEFT", "LEFT", button:GetName(), 20, 0)
				normalText:SetWidth(width - 30)
				normalText:SetColor(1, 1, 1)
				highlightText:ClearAllAnchors()
				highlightText:SetAnchor("LEFT", "LEFT", button:GetName(), 20, 0)
				highlightText:SetWidth(width - 30)
				highlightText:SetColor(1, 1, 1)
			end
			button:SetText(arg[i])
			if Browse.SelectedCategory[layer] == i then
				button:LockHighlight()
			else
				button:UnlockHighlight()
			end
			button:Show()
			Browse.CategoryButtonNums = count
		end
		if layer == 1 then
			if Browse.SelectedCategory[1] == i then
				Browse.Category_SetItemInfo(layer + 1, GetAuctionBrowseFilterList(i))
			end
		elseif layer == 2 then
			if Browse.SelectedCategory[2] == i then
				Browse.Category_SetItemInfo(layer + 1, GetAuctionBrowseFilterList(Browse.SelectedCategory[1], i))
			end
		end
	end
end

function Browse.CategoryButton_OnClick(this, key)
	for index, value in pairs(Browse.SelectedCategory) do
		if index > this.layer then
			Browse.SelectedCategory[index] = nil
		end
	end
	if Browse.SelectedCategory[this.layer] == this.index then
		Browse.SelectedCategory[this.layer] = nil
	else
		Browse.SelectedCategory[this.layer] = this.index
	end
	Browse.CategoryScrollBar_Update()
end

function Browse.RuneDropDown_Show()
	for i = 1, 5 do
		info= {}
		info.text = Browse.RuneInfo[i]
		info.func = function(button)
			AAH.Tools.SetDropDown(AAH_BrowseRuneDropDown, button:GetID(), button:GetText())
		end
		UIDropDownMenu_AddButton(info)
	end
end

function Browse.RarityDropDown_Show()
	local info
	for i = 1, 11 do
		info = {}
		info.text = Browse.RarityInfo[i]
		info.textR, info.textG, info.textB = GetItemQualityColor(i - 1)
		info.func = function(button)
			AAH.Tools.SetDropDown(AAH_BrowseRarityDropDown, button:GetID(), button:GetText(), {GetItemQualityColor(button:GetID() - 1)})
		end
		UIDropDownMenu_AddButton(info)
	end
end

function Browse.ResetButton_OnClick()
	AAH_BrowseNameEditBox:SetText("")
	AAH_BrowseMinLvlEditBox:SetText("")
	AAH_BrowseMaxLvlEditBox:SetText("")
	AAH.Tools.SetDropDown(AAH_BrowseRarityDropDown, 1, Browse.RarityInfo[1], {1, 1, 1})
	AAH.Tools.SetDropDown(AAH_BrowseRuneDropDown, 1, Browse.RuneInfo[1])
	AAH_BrowseUsableButton:SetChecked(false)
	Browse.SelectedCategory = {}
	Browse.CategoryScrollBar_Update()
	AAH_BrowseFilter1EditBox:SetText("")
	AAH_BrowseFilter2EditBox:SetText("")
	AAH_BrowseFilter3EditBox:SetText("")
	AAH_BrowseFilter2OrButton:SetChecked(false)
	AAH_BrowseFilter3OrButton:SetChecked(false)
	AAH_BrowseFilterPPUButton:SetChecked(false)
	AAH_BrowseFilterBidButton:SetChecked(false)
	AAH_BrowseFilterMinPriceEditBox:SetText("")
	AAH_BrowseFilterMaxPriceEditBox:SetText("")
end

function Browse.SearchButton_OnClick()

	Browse.PrepareCachedSearch()
	Browse.List_Update()

	if not CachingActive then
		Browse.ExecuteSearch()
	else
		AAH_BrowseSearchButton:Disable()
		CachingActive = nil
		SearchRequested = true
		SearchDelay = ABORT_DELAY
		AAH_BrowseProgressLabel:SetText(AAHLocale.Messages.BROWSE_CANCELLING)
		AAH_BrowseInfoLabel:SetText("")
	end
end

function Browse.ExecuteSearch()
	local name = AAH_BrowseNameEditBox:GetText()
	local minlvl = AAH_BrowseMinLvlEditBox:GetNumber()
	local maxlvl = AAH_BrowseMaxLvlEditBox:GetNumber()
	local rarity = UIDropDownMenu_GetSelectedID(AAH_BrowseRarityDropDown)
	local rune = UIDropDownMenu_GetSelectedID(AAH_BrowseRuneDropDown)
	local usable = AAH_BrowseUsableButton:IsChecked()
    local cat1=Browse.SelectedCategory[1]
    local cat2=Browse.SelectedCategory[2]
    local cat3=Browse.SelectedCategory[3]

	Browse.DoSearch(name, minlvl, maxlvl, rarity, rune, usable, cat1,cat2,cat3)
end

function Browse.DoSearch(name, minlvl, maxlvl, rarity, rune, usable, cat1, cat2, cat3)

	name = string.gsub(name, "'", "%%") -- see: http://forum.runesofmagic.com/showthread.php?t=490924&p=4405930#post4405930

	if Browse.LastSearch.name ~= name or
		Browse.LastSearch.minlvl ~= minlvl or
		Browse.LastSearch.maxlvl ~= maxlvl or
		Browse.LastSearch.rarity ~= rarity or
		Browse.LastSearch.rune ~= rune or
		Browse.LastSearch.usable ~= usable or
		Browse.LastSearch.cat1 ~= cat1 or
		Browse.LastSearch.cat2 ~= cat2 or
		Browse.LastSearch.cat3 ~= cat3
	then
		Browse.Results.sortIndex = nil
		Browse.SortMode = 0
		Browse.ClearSortIcons()
	end
	Browse.LastSearch = {
		name = name,
		minlvl = minlvl,
		maxlvl = maxlvl,
		rarity = rarity,
		rune = rune,
		usable = usable,
		cat1 = cat1,
		cat2 = cat2,
		cat3 = cat3,
	}

	AAH_BrowseProgressLabel:SetText(AAHLocale.Messages.BROWSE_SEARCHING)
	AAH_BrowseInfoLabel:SetText("")
    if (cat1 == 13 and cat2 == 1) then
        AAH_BrowseHeaderPPU:SetText(AAHLocale.Messages.GENERAL_UNITS_PER_PRICE_HEADER)
    else
        AAH_BrowseHeaderPPU:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER)
    end

	AAH.History.ClearQueue()

	Browse.Results.pageNum = 1
	Browse.PrepareCachedSearch()
	Browse.List_Update()

    TimeRemaining = SEARCH_DELAY_START
	CachingActive = true
	AuctionBrowseSearchItem(name, minlvl, maxlvl, rarity, 1, rune, usable, cat1,cat2,cat3)

	AAH_BrowseSearchButton:Disable()
end

function Browse.PrepareCachedSearch()
	Browse.Cache.PAGEREADY = {}
	Browse.Cache.CACHEDDATA = {}
	for i = 1, 10 do
		Browse.Cache.PAGEREADY[i] = false
		Browse.Cache.CACHEDDATA[i] = {}
	end
	Browse.CurrentCachePage = 1
end

function Browse.Filter_TooltipDisplay(this, num)
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT", 0, -50)
	GameTooltip:SetText(AAHLocale.Messages.BROWSE_FILTER_TOOLTIP_HEADER .. num, 1, 1, 1)
	for _, filter in ipairs(AAH.Filters.List) do
		if filter.coms == "-" then
			GameTooltip:AddSeparator()
		else
			GameTooltip:AddDoubleLine(filter.coms, filter.desc, 1, 0.82, 0, 0, 0.75, 0.95)
		end
	end

	GameTooltip:AddLine(AAHLocale.Messages.BROWSE_FILTER_TOOLTIP_TEXT1, 0, 0.75, 0.95) --Do not edit before generation. This would wrap lines to early.
	GameTooltip:Show()
end

function Browse.FilterChange()
	FilterChanged = true
	FilterDelay = FILTER_DELAY
end

function Browse.CachePage(firstPage)

	local link, itemid, itemname
	local j, max
	-- check if all items are loaded
	if (Browse.CurrentCachePage < Browse.MaxPages) then -- not on last page
		j = Browse.MaxPageItems
	else -- last page
		max=GetAuctionBrowseMaxItems()
		j = max - (Browse.MaxPages-1)*Browse.MaxPageItems
	end

	local auctionid, name, count, rarity, texture, level, leftTime, seller, isBuyer, moneyMode, bidPrice, buyoutPrice = GetAuctionBrowseItemInfo(Browse.CurrentCachePage, j)
	if not auctionid then -- not loaded
		if Browse.CurrentCachePage <= Browse.MaxPages then
			TimeRemaining = SEARCH_DELAY_RETRY
			AwaitingData = true
		else -- end of result
			CachingActive = nil -- stop loading
			AwaitingData = nil
		end
		return
	end

	AwaitingData = nil
	for i = 1, Browse.MaxPageItems do
		auctionid, name, count, rarity, texture, level, leftTime, seller, isBuyer, moneyMode, bidPrice, buyoutPrice = GetAuctionBrowseItemInfo(Browse.CurrentCachePage, i)
		if auctionid then
			link = GetAuctionBrowseItemLink(auctionid)
			itemid, itemname = AAH.Tools.ParseLink(link)
		end

		Browse.Cache.CACHEDDATA[Browse.CurrentCachePage][i] = {
			auctionid = auctionid,
			itemid = itemid,
			link = link,
			name = name,
			count = count,
			rarity = rarity,
			texture = texture,
			level = level,
			levelcolor = NORMAL_FONT_COLOR_CODE,
			leftTime = leftTime,
			seller = seller,
			isBuyer = isBuyer,
			moneyMode = moneyMode,
			bidPrice = bidPrice,
			buyoutPrice = buyoutPrice,
		}

        AAH.History.Queue_Insertitem(auctionid, name, link, itemid)
	end

	Browse.Cache.PAGEREADY[Browse.CurrentCachePage] = true
	Browse.LastCached = Browse.CurrentCachePage
	Browse.InfoLabelUpdate()
	Browse.CurrentCachePage = Browse.CurrentCachePage + 1
	if firstPage then
		Browse.List_Update()
	else
		Browse.List_Update_AddPage(Browse.LastCached)
	end
	TimeRemaining = SEARCH_DELAY_NEXTPAGE
end

function Browse.List_Update()
	Browse.Results.nextPage = nil
    Browse.Results.maxNums = GetAuctionBrowseMaxItems()
    Browse.Results.list = {}
    if Browse.Results.maxNums > 0 then
        Browse.CurrentFilterPage = 1
        Browse.CurrentFilterItem = 1
        Browse.FilteringActive = true
        AAH_BrowseProgressLabel:SetText("")
        if Browse.Results.sortIndex then
            Browse.List_Sort(Browse.Results.sortIndex)
        end
    end
    Browse.List_UpdateItems()
end

function Browse.List_Update_AddPage(addPage)
	Browse.Results.nextPage = nil
    if Browse.FilteringActive == false then
        Browse.CurrentFilterPage = addPage
        Browse.CurrentFilterItem = 1
        Browse.FilteringActive = true
    end
    Browse.InfoLabelUpdate()
end

function Browse.Cache_FindAuction(auctionid)
    for j = 1, Browse.MaxPages do
		for i = 1, Browse.MaxPageItems do
			local item = Browse.Cache.CACHEDDATA[j][i]
			if item and item.auctionid == auctionid then
				return item
			end
		end
	end
end

function Browse.Cache_ClearAuction(auctionid)
    for j = 1, Browse.MaxPages do
        for i = 1, Browse.MaxPageItems do
			local item = Browse.Cache.CACHEDDATA[j][i]
	        if item and item.auctionid == auctionid then
                Browse.Cache.CACHEDDATA[j][i] = {}
                return true
            end
        end
    end
end

function Browse.Cache_CalculatePPU(item)
    local white = AAH.Tools.GetWhiteValue(item.itemid)
    if item.buyoutPrice > 0 then
        if item.itemid == 200000 then
            item.buyppu = item.count / item.buyoutPrice
        else
            item.buyppu = (item.buyoutPrice / item.count) / white
        end
    else
        item.buyppu = -1
    end
    if item.itemid == 200000 then
        item.bidppu = item.count / item.bidPrice
    else
        item.bidppu = (item.bidPrice / item.count) / white
    end
end

local function ResetAttributes(listing)
	listing.tier = 0		--Tier
	listing.plus = 0		--Plus
	listing.dura = 0		--Max Durability
	listing.worth = 0		--Vendor Value
	listing.mdam = 0		--Magical Damage
	listing.pdam = 0		--Physical Damage
	listing.speed = 0		--Attack Speed
	listing.dps = 0			--DPS
	listing.sta = 0			--Stamina
	listing.str = 0			--Strength
	listing.dex = 0			--Dexterity
	listing.wis = 0			--Wisdom
	listing.int = 0			--Intelligence
	listing.hp = 0			--Maximum HP
	listing.mp = 0			--Maximum MP
	listing.patt = 0		--Physical Attack
	listing.matt = 0		--Magical Attack
	listing.pdef = 0		--Physical Defense
	listing.mdef = 0		--Magical Defense
	listing.pcrit = 0		--Physical Crit Rate
	listing.mcrit = 0		--Magical Crit Rate
	listing.pacc = 0		--Physical Accuracy
	listing.macc = 0		--Magical Accuracy
	listing.pdod = 0		--Physical Dodge Rate
	listing.parry = 0		--Parry Rate
	listing.heal = 0		--Healing Bonus
end
local function ParseLine(listing, line)
	line = string.gsub(line, "|c%x%x%x%x%x%x%x%x", "")
	line = string.gsub(line, "|r", "")
	local prefix, value, suffix = string.match(line, "^%s*(.-)%s*([%d%.]+)%s*(.-)%s*$")

	local key1 = Browse.KeyFinderTable[prefix]
	local key2 = Browse.KeyFinderTable[suffix]
	if key1 then
		if key1 == "worth" then --additional code for price
			value = string.gsub(value, "%"..COMMA, "") --added "%" to comma because in german this is a point instead of comma!
			listing["worth"] =  ToNum(value)
		elseif key1 == "level" then --additional code for pet eggs
			if AAH.Data.PetEggs[listing.itemid] then
				listing.levelcolor = GREEN_FONT_COLOR_CODE
				listing["level"] = ToNum(value)
			end
		elseif key1 == "dura" then --use suffix on dura to get max dura
			listing[key1] = (listing[key1] or 0) + ToNum(string.gsub(suffix, "/", ""))
		else
			listing[key1] = (listing[key1] or 0) + ToNum(value)
		end
	elseif key2 then
		listing[key2] = (listing[key2] or 0) + ToNum(value)
	end
end

local function ParseToolTip(listing)
    Browse.KeyFinderTable[listing.name.." +"] = "plus"
    ResetAttributes(listing)
    AAH_Tooltip:SetHyperLink(listing.link)
    AAH_Tooltip:Hide() 
	GameTooltip1:Hide()
	GameTooltip2:Hide()

    local left, leftVis, right, rightVis

    for i = 1, 40 do
        leftVis = getglobal("AAH_TooltipTextLeft"..i):IsVisible()
        rightVis = getglobal("AAH_TooltipTextRight"..i):IsVisible()
        if not leftVis and not rightVis then
            break
        end

        left = getglobal("AAH_TooltipTextLeft"..i):GetText()
        if left and left ~= "" and leftVis then
	        ParseLine(listing, left)
        end
        right = getglobal("AAH_TooltipTextRight"..i):GetText()
        if right and right ~= "" and rightVis then
	        ParseLine(listing, right)
        end
    end
    if listing.mdam > 0 then
        listing.heal = listing.heal + (listing.mdam * 0.5)
    end
    if listing.speed > 0 and listing.pdam > 0 then
        listing.dps = listing.pdam / listing.speed
    end
end

function Browse.AddItemToList(pageNumber, itemIndex)
	if Browse.Cache.PAGEREADY and Browse.Cache.PAGEREADY[pageNumber] == true then
		local listing = Browse.Cache.CACHEDDATA[pageNumber][itemIndex]
		if not listing.auctionid then return end

        if listing.itemid == 200000 or listing.itemid == 200003 then -- Get Count from "itemname" for gold and diamonds
            listing.count = tonumber(string.match(string.gsub(listing.name, "%"..COMMA, ""), "%d*") or "1") or 1
        end

        Browse.Cache_CalculatePPU(listing)
        ParseToolTip(listing)

        if AAH.Data.Recipes[listing.itemid] then
            listing.levelcolor = GREEN_FONT_COLOR_CODE
            listing.level = AAH.Data.Recipes[listing.itemid]
        end

        local class = UnitClass("player")
        if AAH.Data.StatValues[class] then
            for stat, t in pairs(AAH.Data.StatValues[class]) do
                for attribute, value in pairs(t) do
                    listing[attribute] = listing[attribute] + (listing[stat] * value)
                end
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("ERROR: please report your language and class to the AAH Forums")
        end

        if AAH.Filters.CheckFilter(listing) then
            table.insert(Browse.Results.list, listing)
        end
	end
end

function Browse.InfoLabelUpdate()

    local pages = Browse.MaxPages
    if not pages or pages==0 then
        pages = 1
    end

	local filterPercentPerPage = 100 / pages
	local filterPercentPerItem = filterPercentPerPage / 50

    local status={}
    status.SCANPERCENT = math.ceil(100 / pages * Browse.LastCached)
    status.MAXITEMS = GetAuctionBrowseMaxItems()
    status.FILTEREDITEMS = #Browse.Results.list
    status.FILTERPERCENT = math.ceil((filterPercentPerPage * (Browse.CurrentFilterPage - 1)) + (filterPercentPerItem * Browse.CurrentFilterItem))

	if status.FILTERPERCENT > status.SCANPERCENT then
		status.FILTERPERCENT = status.SCANPERCENT
	end

	local labeltext = AAHLocale.Messages.BROWSE_INFO_LABEL
	labeltext = labeltext:gsub("<(%w+)>", status)
	AAH_BrowseInfoLabel:SetText(labeltext)
end

function Browse.List_UpdateItems()
	local first_index = AAH_BrowseListScrollBar:GetValue()

	for i = 1, Browse.DisplayedItems do
		local button = getglobal("AAH_BrowseListItem"..i)
		local info = Browse.Results.list[first_index+i]
		if info then
			button.auctionid = info.auctionid
			local buttonName = button:GetName()

			getglobal(buttonName.."Name"):SetText(info.name)
			getglobal(buttonName.."Name"):SetColor( GetItemQualityColor(info.rarity) )

			local inversecoloring = false
            local count = info.count
            if info.itemid == 200000 then
				inversecoloring = true
			    count = 0
			elseif info.itemid == 200003 then
				count = 0
            end
            SetItemButtonCount(getglobal(buttonName.."Icon"), count)

			SetItemButtonTexture(getglobal(buttonName.."Icon"), info.texture)
			for k = 1, 2 do
				if not info[Browse["CustomSortItem"..k]] or info[Browse["CustomSortItem"..k]] == 0 or info[Browse["CustomSortItem"..k]] == "" then
					getglobal(buttonName.."Custom"..k):SetText("")
				elseif Browse["CustomSortItem"..k] == "level" then
					getglobal(buttonName.."Custom"..k):SetText(info.levelcolor..info.level.."|r")
				else
					getglobal(buttonName.."Custom"..k):SetText(tonumber(string.format("%.2f", info[Browse["CustomSortItem"..k]])))
				end
			end
			getglobal(buttonName.."LeftTime"):SetText(AAH.Tools.LocalTimeString(info.leftTime))
			getglobal(buttonName.."Seller"):SetText(info.seller)

			getglobal(buttonName.."PPUBid"):SetText("")
			getglobal(buttonName.."PPUBuy"):SetText("")
			white = AAH.Tools.GetWhiteValue(info.itemid)

			if info.count > 0 and info.bidPrice > 0 then
				getglobal(buttonName.."PPUBid"):SetText(AAH.Tools.FormatThousands(math.floor(info.bidppu)))
				if info.buyoutPrice > 0 then
					getglobal(buttonName.."PPUBuy"):SetText(AAH.Tools.FormatThousands(math.floor(info.buyppu)))
				end
			end
			getglobal(buttonName.."PPUBid"):SetColor(1,1,1)
			getglobal(buttonName.."PPUBuy"):SetColor(1,1,1)

            local avg = AAH.History.GetAveragePrice(info.itemid)
			if avg then
				AAH.Tools.GetAvgPriceColor(info.bidppu, avg, buttonName.."PPUBid", inversecoloring)
				AAH.Tools.GetAvgPriceColor(info.buyppu, avg, buttonName.."PPUBuy", inversecoloring)
			end

			MoneyFrame_Update(buttonName.."BidMoney", info.bidPrice, info.moneyMode or "copper")
			if info.isBuyer then
				getglobal(buttonName.."BidMoneyText"):SetText(TEXT("AUCTION_SELF_BID"))
			else
				getglobal(buttonName.."BidMoneyText"):SetText("")
			end
			if info.buyoutPrice > 0 then
				getglobal(buttonName.."BuyoutMoney"):Show()
				MoneyFrame_Update(buttonName.."BuyoutMoney", info.buyoutPrice, info.moneyMode or "copper")
			else
				getglobal(buttonName.."BuyoutMoney"):Hide()
			end
			button:Show()
		else
			button:Hide()
		end
	end

	Browse.List_SetSelected(Browse.selected_auctionid)
end

function Browse.List_ItemIcon_OnClick(this,key)
	local itemLink = GetAuctionBrowseItemLink(this:GetParent().auctionid)
    if IsShiftKeyDown() and key == "LBUTTON" then
        AAH.Tools.ChatEdit_AddItemLink(itemLink,true)
    elseif IsCtrlKeyDown() and key == "LBUTTON" then
        ItemPreviewFrame_SetItemLink(ItemPreviewFrame, itemLink)
    end
end

function Browse.List_FindAuctionIndex(auctionid)
    for i,entry in ipairs(Browse.Results.list) do
        if entry.auctionid == auctionid then
            return i,entry
        end
    end
end

function Browse.List_GetSelected()
    local idx,entry = Browse.List_FindAuctionIndex(Browse.selected_auctionid)
    return idx,entry
end

function Browse.List_SetSelected(auctionid)
	AAH_BrowseBidButton:Disable()
	AAH_BrowseBuyoutButton:Disable()
	AAH_BrowseHistoryButton:Disable()

	for i = 1, Browse.DisplayedItems do
        local button = getglobal("AAH_BrowseListItem"..i)
    	button:UnlockHighlight()
	end

    Browse.selected_auctionid = auctionid
    local index = Browse.List_FindAuctionIndex(auctionid)
    if not index then
        Browse.selected_auctionid = nil
        return
    end

    local first_index = AAH_BrowseListScrollBar:GetValue()
    local but_idx = index-first_index
    local button = _G["AAH_BrowseListItem"..but_idx]
    if not button or but_idx>Browse.DisplayedItems then return end

    local _,info = Browse.List_GetSelected()
    AAH.MoneyFrame.SetMode(AAH_BrowseBidMoneyInput, info.moneyMode)
    AAH.MoneyFrame.SetMoney(AAH_BrowseBidMoneyInput, AAH.Tools.CalcBidPrice(info.bidPrice))
    if not info.isBuyer then
        AAH_BrowseBidButton:Enable()
    end
    if info.buyoutPrice > 0 then
        AAH_BrowseBuyoutButton:Enable()
    end
    AAH_BrowseHistoryButton:Enable()
    button:LockHighlight()
end


