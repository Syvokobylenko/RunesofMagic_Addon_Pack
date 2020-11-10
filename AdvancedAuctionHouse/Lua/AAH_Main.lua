local function LoadLocales()
    local locale = string.sub(GetLanguage(), 1, 2)
    local func, err = loadfile("Interface/AddOns/AdvancedAuctionHouse/Locales/"..locale..".lua")
    if err then
        dofile("Interface/AddOns/AdvancedAuctionHouse/Locales/EN.lua")
    else
        func()
    end

    -- this stuff is only important for development stage when locales other than german are not filled with content
    if not AAHLocale.Messages then
	    dofile("Interface/AddOns/AdvancedAuctionHouse/Locales/DE.lua")
    end
    if not AAHLocale.Messages then
	    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Advanced AuctionHouse faced a critical error:\n|rTHERE WERE PROBLEMS LOADING THE LOCALIZATION! ABORTING...")
	    return
    end
end
LoadLocales()


local VERSION = string.match("v7.4.5", "v[%d+.]+....$") or DEV_VERSION or "Alpha r2013-09-15T06:01:15Z"
local DEFAULT_SETTINGS = { -- NB: all settings without default value will be deleted!
	HistoryMaxSavedDefault = 100,
	HistoryMaxSaved = {},
	PriceHistoryAutoshow = false,
	Resize = 0,
	SellDurationSelected = 4,
	AutoFillBidSelected = 1,
	AutoFillBuyoutSelected = 1,
	SellAutoFillPercentBidValue = 100,
	FormulaBid = "",
	SellAutoFillPercentBuyoutValue = 100,
	FormulaBuyout = "",
	UseMatWhiteValue = false,
	FilterSpeed = 6,
    AvgSuggest=false,
    BidAlertLimit=100000,
}

AdvancedAuctionHouse = true
AAH = {
	Manifest = {
		Name = "Advanced AuctionHouse (History)",
		Author = "Mavoc, TellTod, Noguai, Graves, Achandos",
		Source = "http://rom.curseforge.com/addons/advancedauctionhouse/",
		Root = "Interface/Addons/AdvancedAuctionHouse",
		Licence = "GNU General Public License version 3 (GPLv3)",
		Build = tonumber("20130915060115") or DEV_BUILD,
		Version = VERSION,
	},
	Data = {
		MatWhiteValue = dofile("Interface/AddOns/AdvancedAuctionHouse/Data/MatWhiteValue.lua"),
		PetEggs = dofile("Interface/AddOns/AdvancedAuctionHouse/Data/PetEggs.lua"),
		Recipes = dofile("Interface/AddOns/AdvancedAuctionHouse/Data/Recipes.lua"),
		StatValues = dofile("Interface/AddOns/AdvancedAuctionHouse/Data/StatsToAttributes.lua"),
	},
	Settings = {
		HistoryMin = 10,
		HistoryMax = 1000,
		FilterSpeedMin = 1,
		FilterSpeedMax = 50,
		MinWarningPriceMin = 0,
		MinWarningPriceMax = 25000000,
	},
	Events = {},
	Updated = false;
}
AAHFunc = AAH -- required for 3rd Party Addons (example: DailyNotes, yaCit)

local Main = {
	Active = true,
	FoundUpdate = false,
	CurrentTab = 1,
	FrameEvents = {
		"AUCTION_AUCTION_INFO_UPDATE",
		"AUCTION_AUCTION_MONEY_UPDATE",
		"AUCTION_BUY_UPDATE",
		"AUCTION_SELL_UPDATE",
		"AUCTION_BROWSE_UPDATE",
		"AUCTION_SEARCH_RESULT",
		"AUCTION_HISTORY_SHOW",
		"AUCTION_HISTORY_HIDE",
		"AUCTION_OPEN",
		"AUCTION_CLOSE",
		"AUCTION_BORWSE_PRICE_UPDATE",
	},
}
AAH.Main = Main

function Main.OnLoad(this)
	for _, event in pairs(Main.FrameEvents) do
		AuctionFrame:UnregisterEvent(event)
		AAH_AuctionFrame:RegisterEvent(event)
	end
	AAH_AuctionFrame:RegisterEvent("VARIABLES_LOADED")
end

function Main.Toggle(mode)
	Main.Active = ((mode ~= nil) and mode) or (not Main.Active)

	if Main.Active then
		for _, event in pairs(Main.FrameEvents) do
			AuctionFrame:UnregisterEvent(event)
			AAH_AuctionFrame:RegisterEvent(event)
		end
	else
		for _, event in pairs(Main.FrameEvents) do
			AuctionFrame:RegisterEvent(event)
			AAH_AuctionFrame:UnregisterEvent(event)
		end
		AUCTION_HEADER_SORT_ITEM = "name"
	end

    DEFAULT_CHAT_FRAME:AddMessage("AdvancedAuctionHouse toggled. State is now: "..(Main.Active and "|cff00ff00ON" or "|cffff0000OFF").."|r")
end


function AAH.Events.AUCTION_AUCTION_MONEY_UPDATE(this)
end


function AAH.Events.AUCTION_CLOSE(this)
	HideUIPanel(this)
end

function AAH.Events.AUCTION_OPEN(this)
	ShowUIPanel(this)
	PlaySoundByPath("Sound\\Interface\\shop_open.mp3")
end

function AAH.Events.VARIABLES_LOADED(this)
	dofile("Interface/AddOns/AdvancedAuctionHouse/Lua/AAH_Hooks.lua")
    Main.InitSaveVariables()
    AAH.History.Init()
    Main.InitGUI(this)

    -- 3rd party stuff
	if AddonManager and AddonManager.RegisterAddonTable then
		local addon = {
			name = AAH.Manifest.Name,
			version = AAH.Manifest.Version,
			author = AAH.Manifest.Author,
			description = AAHLocale.Messages.ADDON_MANAGER_DESCRIPTION,
			icon = "Interface/Addons/AdvancedAuctionHouse/Textures/AAHIcon",
			category = "Economy",
			miniButton = AAHMiniButton,
			onClickScript = function() Main.Toggle() end,
		}
        AddonManager.RegisterAddonTable(addon)
    else
    	DEFAULT_CHAT_FRAME:AddMessage(string.gsub(string.gsub(AAHLocale.Messages.AUCTION_LOADED_MESSAGE, "<AUTHOR>", AAH.Manifest.Author), "<VERSION>", AAH.Manifest.Version),0,255,255)
	end

	if Luna then
		Luna.RegisterAddon("AdvancedAuctionHouse", AAH.Tools.LunaReceive)
--@non-alpha@
		Luna.QueueMessage("AdvancedAuctionHouse", "Build: "..AAH.Manifest.Build)
--@end-non-alpha@
	end
end

function Main.InitSaveVariables()
    AAH_SavedSearch = AAH_SavedSearch or {}
	SaveVariables("AAH_SavedSearch")

    AAH_LastSellPrice = AAH_LastSellPrice or {}
	if not AAH_LastSellPrice._TABLEBUILD or AAH_LastSellPrice._TABLEBUILD < 89 then
		AAH_LastSellPrice._TABLEBUILD = AAH.Manifest.Build
	end
	SaveVariables("AAH_LastSellPrice")

    AAH_SavedSettings = AAH_SavedSettings or {}
	if type(AAH_SavedSettings.HistoryMaxSaved) ~= "table" then AAH_SavedSettings.HistoryMaxSaved = nil end
    for i, v in pairs(DEFAULT_SETTINGS) do
        if AAH_SavedSettings[i] == nil then
            AAH_SavedSettings[i] = v
        end
    end
    for i, v in pairs(AAH_SavedSettings) do
        if DEFAULT_SETTINGS[i] == nil then
            AAH_SavedSettings[i] = nil
        end
    end
	SaveVariables("AAH_SavedSettings")	
end


function Main.InitGUI(this)
	PanelTemplates_SetNumTabs(this, 4)

	AAH_AuctionTitleText:SetText(string.gsub(string.gsub(AAHLocale.Messages.AUCTION_FRAME_TITLE, "<AUTHOR>", AAH.Manifest.Author), "<VERSION>", AAH.Manifest.Version))
	AAH_AuctionForumsButton:SetText(AAHLocale.Messages.AUCTION_FORUMS_BUTTON)

    AAH.Sell.OnInit()

	Main.ResizeFrame(AAH_SavedSettings.Resize)
	AAH_SettingsUseWhiteValue:SetChecked(AAH_SavedSettings.UseMatWhiteValue)
	AAH_SettingsAvgDefaultLastPrice:SetChecked(AAH_SavedSettings.AvgSuggest)
	AAH_SettingsAlwaysShowPriceHistory:SetChecked(AAH_SavedSettings.PriceHistoryAutoshow)
	AAH_SettingsMaxHistory:SetValue(AAH_SavedSettings.HistoryMaxSavedDefault)
	AAH_SettingsFilterSpeed:SetValue(AAH_SavedSettings.FilterSpeed)
	AAH_SettingsMinWarningPrice:SetValue(AAH_SavedSettings.BidAlertLimit)
end

function Main.OnShow(this)
	Main.ClickTab(1)
	AAH.Tools.SetDropDown(AAH_BrowseRarityDropDown, 1, AAH.Browse.RarityInfo[1], {1, 1, 1})
	AAH.Tools.SetDropDown(AAH_BrowseRuneDropDown, 1, AAH.Browse.RuneInfo[1])
	AAH.Browse.Results.pageNum = 1
	AAH.Browse.SelectedCategory = {}
	AAH.SavedSearch.Expand = {}
	AAH.MoneyFrame.ResetMoney(AAH_BrowseBidMoneyInput)
	AAH.Browse.CategoryScrollBar_Update()
	AAH.SavedSearch.ScrollBar_Update()
	AAH.Browse.List_Update()
	AAH.Bid.ReadList()
	AAH_BrowseSearchButton:Enable()
end

function Main.OnHide(this)
	AAH_HistoryList:Hide()
	AAH_BrowseInfoLabel:SetText("")
	AAH_BrowseProgressLabel:SetText("")
	AAH.SavedSearch.MinimizeButton_OnClick()

    AAH.Browse.Frame_StopUpdates()
	AAH.History.ClearQueue()

	SetSellMoneyType(0)

    AuctionClose()
end

function Main.ClickTab(tab)
	PanelTemplates_SetTab(AAH_AuctionFrame, tab)
	AAH_BrowseFrame:Hide()
	AAH_BidFrame:Hide()
	AAH_SellFrame:Hide()
	AAH_SettingsFrame:Hide()
	if tab == 1 then
		AAH.Main.CurrentTab = "BROWSE"
		AAH_BrowseFrame:Show()
	elseif tab == 2 then
		AAH.Main.CurrentTab = "BUY"
		AAH_BidFrame:Show()
	elseif tab == 3 then
		AAH.Main.CurrentTab = "SELL"
		AAH_SellFrame:Show()
	elseif tab == 4 then
		AAH.Main.CurrentTab = "SETTINGS"
		AAH_SettingsFrame:Show()
	end
end

function Main.ResizeFrame(num)
	local value = 44 * num
	if num == 0 then
		AAH_AuctionEnlargeButton:Enable()
		AAH_AuctionReduceButton:Disable()
	elseif num == 5 then
		AAH_AuctionEnlargeButton:Disable()
		AAH_AuctionReduceButton:Enable()
	else
		AAH_AuctionEnlargeButton:Enable()
		AAH_AuctionReduceButton:Enable()
	end
	AAH_AuctionFrame:SetSize(846, 489 + value)
	AAH_AuctionFrameBottomLeft:SetSize(256, 233 + value)
	AAH_AuctionFrameBottomCenter:SetSize(334, 233 + value)
	AAH_AuctionFrameBottomRight:SetSize(256, 233 + value)

	AAH.Browse.Resize(num, value)
	AAH.Bid.Resize(num, value)
    AAH.Sell.Resize(num, value)
end