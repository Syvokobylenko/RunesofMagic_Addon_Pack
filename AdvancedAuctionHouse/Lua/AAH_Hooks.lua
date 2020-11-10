HistoryForGameTooltipHyperLink = false
HistoryForGameTooltip = false

local GameTooltip_obj = GameTooltip
local GameTooltipHyperLink_obj = GameTooltipHyperLink

local SetHyperLink_orig = GameTooltipHyperLink_obj["SetHyperLink"]
function GameTooltipHyperLink:SetHyperLink(link)
	SetHyperLink_orig(GameTooltipHyperLink_obj, link)
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		local linktype, data, linkname = ParseHyperlink(link)
		if linktype == "item" then
			HistoryForGameTooltipHyperLink = true
			HistoryForGameTooltip = false
			local itemid, itemname = AAH.Tools.ParseLink(link)
			AAH.ToolsShowPriceHistoryTooltip(self, itemid, itemname)
		end
	end
end

local SetGameTooltipHyperLink_orig=GameTooltip_obj["SetHyperLink"]
function GameTooltip:SetHyperLink(link)
	SetGameTooltipHyperLink_orig(GameTooltip_obj, link)
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		local linktype, data, name = ParseHyperlink(link)
		if linktype == "item" then
			HistoryForGameTooltipHyperLink = false
			HistoryForGameTooltip = true
			local itemid, itemname = AAH.Tools.ParseLink(link)
			AAH.ToolsShowPriceHistoryTooltip(self, itemid, itemname)
		end
	end
end

local SetBagItem_orig = GameTooltip_obj["SetBagItem"]
function GameTooltip:SetBagItem(id)
	SetBagItem_orig(GameTooltip_obj, id)
	local link = GetBagItemLink(id)
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local itemid, itemname = AAH.Tools.ParseLink(link)
		AAH.ToolsShowPriceHistoryTooltip(self, itemid, itemname)
	end
end

local SetAuctionBrowseItem_orig = GameTooltip_obj["SetAuctionBrowseItem"]
function GameTooltip:SetAuctionBrowseItem(id)
	SetAuctionBrowseItem_orig(GameTooltip_obj, id)
	local link = GetAuctionBrowseItemLink(id)
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local itemid = AAH.Tools.ParseLink(link)
		AAH.ToolsShowPriceHistoryTooltip(self, itemid)
	end
end

local SetAuctionItem_orig = GameTooltip_obj["SetAuctionItem"]
function GameTooltip:SetAuctionItem(id)
	SetAuctionItem_orig(GameTooltip_obj, id)
	if AAH.HookItemLink and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local itemid = AAH.Tools.ParseLink(AAH.HookItemLink)
		AAH.ToolsShowPriceHistoryTooltip(self, itemid)
	end
end

local SetBankItem_orig = GameTooltip_obj["SetBankItem"]
function GameTooltip:SetBankItem(id)
	SetBankItem_orig(GameTooltip_obj, id)
	local link = GetBankItemLink(id)
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local itemid = AAH.Tools.ParseLink(link)
		AAH.ToolsShowPriceHistoryTooltip(self, itemid)
	end
end

local SetCraftItem_orig = GameTooltip_obj["SetCraftItem"]
function GameTooltip:SetCraftItem(obj, qual)
	SetCraftItem_orig(GameTooltip_obj, obj, qual)
	local link = GetCraftItemLink(obj, 1)
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local itemid = AAH.Tools.ParseLink(link)
		AAH.ToolsShowPriceHistoryTooltip(self, itemid)
	end
end

local SetHouseItem_orig = GameTooltip_obj["SetHouseItem"]
function GameTooltip:SetHouseItem(DBID, id)
	SetHouseItem_orig(GameTooltip_obj, DBID, id)
	if DBID and id then
		local link = Houses_GetItemLink(DBID, id)
		if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
			HistoryForGameTooltipHyperLink = false
			HistoryForGameTooltip = true
			local itemid = AAH.Tools.ParseLink(link)
			AAH.ToolsShowPriceHistoryTooltip(self, itemid)
		end
	end
end

local SetBootyItem_orig = GameTooltip_obj["SetBootyItem"]
function GameTooltip:SetBootyItem(id)
	SetBootyItem_orig(GameTooltip_obj, id)
	local link = GetBootyItemLink(id)
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local itemid = AAH.Tools.ParseLink(link)
		AAH.ToolsShowPriceHistoryTooltip(self, itemid)
	end
end

local SetStoreItem_orig = GameTooltip_obj["SetStoreItem"]
function GameTooltip:SetStoreItem(tab, ButtonId)
	SetStoreItem_orig(GameTooltip_obj, tab, ButtonId)
	local link
	if tab == "SELL" then
		link = GetStoreSellItemLink(ButtonId)
	elseif tab == "BUYBACK" then
		link = GetStoreBuyBackItemLink(ButtonId)
	end
	if link and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local itemid = AAH.Tools.ParseLink(link)
		AAH.ToolsShowPriceHistoryTooltip(self, itemid)
	end
end

--[=[ no access to this items id or link (UNKNOWN)
local SetAccountBagItem_orig = GameTooltip_obj["SetAccountBagItem"]
function GameTooltip:SetAccountBagItem(id)
	SetAccountBagItem_orig(GameTooltip_obj, id)
	if IsAltKeyDown() or AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		AAHDebug("SetAccountBagItem<>"..id)
		AAH.ToolsShowPriceHistoryTooltip(self, nil)
	end
end--]=]

--[=[ no access to this items id or link
local SetInventoryItem_orig = GameTooltip_obj["SetInventoryItem"]
function GameTooltip:SetInventoryItem(unitid, slot)
	SetInventoryItem_orig(GameTooltip_obj, unitid, slot)
	if IsAltKeyDown() or AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		AAH.ToolsShowPriceHistoryTooltip(self, nil)
	end
end--]=]

--[=[ no access to this item's id or link
local SetCraftRequestItem_orig = GameTooltip_obj["SetCraftRequestItem"]
function GameTooltip:SetCraftRequestItem(obj, id)
	SetCraftRequestItem_orig(GameTooltip_obj, obj, id)
	if IsAltKeyDown() or AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local name = GameTooltipTextLeft1:GetText()
		AAH.ToolsShowPriceHistoryTooltip(self, name)
	end
end--]=]

--[=[ no access to this item's id or link
local SetAuctionBidItem_orig = GameTooltip_obj["SetAuctionBidItem"]
function GameTooltip:SetAuctionBidItem(id)
	SetAuctionBidItem_orig(GameTooltip_obj, id)
	if IsAltKeyDown() or AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local name = GameTooltipTextLeft1:GetText()
		local offset = string.find(name, "+")
		if offset then
			name = string.sub(name, 1, offset - 2)
		end
		AAH.ToolsShowPriceHistoryTooltip(self, name)
	end
end--]=]

--[=[ no access to this item's id or link
local SetAuctionSellItem_orig = GameTooltip_obj["SetAuctionSellItem"]
function GameTooltip:SetAuctionSellItem(id)
	SetAuctionSellItem_orig(GameTooltip_obj, id)
	if IsAltKeyDown() or AAH_SavedSettings.PriceHistoryAutoshow then
		HistoryForGameTooltipHyperLink = false
		HistoryForGameTooltip = true
		local name = GameTooltipTextLeft1:GetText()
		local offset = string.find(name, "+")
		if offset then
			name = string.sub(name, 1, offset - 2)
		end
		AAH.ToolsShowPriceHistoryTooltip(self, name)
	end
end--]=]

local ChatEdit_AddItemLink_orig = ChatEdit_AddItemLink
function ChatEdit_AddItemLink(ItemLink, allEditbox)
	if ItemLink and not ITEMLINK_EDITBOX and AAH_AuctionFrame:IsVisible() and AAH_BrowseFrame:IsVisible() then
		local _, _, name = ParseHyperlink(ItemLink)
		AAH_BrowseNameEditBox:SetText(name)
		return true
	end
	return ChatEdit_AddItemLink_orig(ItemLink, allEditbox)
end

local CloseAllWindows_orig = CloseAllWindows
function CloseAllWindows()
	HideUIPanel(AAH_AuctionFrame)
	CloseAllWindows_orig()
end

local SendSystemMsg_orig = SendSystemMsg
function SendSystemMsg(arg1, override)
	if arg1 then
		if not override then
			if arg1 == TEXT("SYS_AC_HISTORY_NONE") then
				return
			end
		end
		SendSystemMsg_orig(arg1, override)
	end
end

local function ItemButton_OnClick(bagindex, itemlink)
	AAH.Sell.ClearItem()
	if not AAH_HistoryList:IsVisible() then
		if itemlink then
			AAH.HookItemLink = itemlink
		elseif bagindex then
			AAH.HookItemLink = GetBagItemLink(bagindex)
		end
	end
end

if zBagItem_OnClick then
	local zBagItem_OnClick_orig = zBagItem_OnClick
	function zBagItem_OnClick(this, button, ignoreShift)
		ItemButton_OnClick(this.index)
		zBagItem_OnClick_orig(this, button, ignoreShift)
	end
end

if yBagItem_OnClick then
	local yBagItem_OnClick_orig = yBagItem_OnClick
	function yBagItem_OnClick(this, button, ignoreShift)
		ItemButton_OnClick(this.index)
		yBagItem_OnClick_orig(this, button, ignoreShift)
	end
end

if FlieBag then
	local FlieBag_ItemButton_OnClick_orig = FlieBag.ItemButton.OnClick
	function FlieBag.ItemButton.OnClick(this, button, ignoreShift)
		ItemButton_OnClick(this.inventoryIndex)
		FlieBag_ItemButton_OnClick_orig(this, button, ignoreShift)
	end
end

if BagItemButton_OnClick then
	local BagItemButton_OnClick_orig = BagItemButton_OnClick
	function BagItemButton_OnClick(this, button, ignoreShift)
		ItemButton_OnClick(this.index)
		BagItemButton_OnClick_orig(this, button, ignoreShift)
	end
end

if GoodsItemButton_OnClick then
	local GoodsItemButton_OnClick_orig = GoodsItemButton_OnClick
	function GoodsItemButton_OnClick(this, button, ignoreShift)
		ItemButton_OnClick(this:GetID())
		GoodsItemButton_OnClick_orig(this, button, ignoreShift)
	end
end

if IVItemButton_OnClick then
	local IVItemButton_OnClick_orig = IVItemButton_OnClick
	function IVItemButton_OnClick(this, button, ignoreShift)
		local itemLink = IVItemButton_GetItemLinkFromTable(this:GetID())
		ItemButton_OnClick(nil, itemLink)
		ChatEdit_AddItemLink(itemLink)
		IVItemButton_OnClick_orig(this, button, ignoreShift)
	end
end

SLASH_AAH_SlashHandler1 = "/aah"
SLASH_AAH_SlashHandler2 = "/auctionhouse"
SlashCmdList["AAH_SlashHandler"] = function(editBox, msg)
	local command = ""
	local param = ""
	if string.find(msg, " ") then
		command = AAH.Tools.StringLower(string.sub(msg, 1, string.find(msg, " ") - 1))
		param = string.sub(msg, string.find(msg, " ") + 1)
	else
		command = msg
	end

	local linkid, linkname = AAH.Tools.ParseLink(param)
	if linkid then
		param = linkid
	end

	if command == "clear" then
        if param == "" then
			DEFAULT_CHAT_FRAME:AddMessage(AAHLocale.Messages.SETTINGS_MISSING_PARAMETER)
		else
		    if AAH.History.RemoveItem(param) then
			    DEFAULT_CHAT_FRAME:AddMessage(AAHLocale.Messages.SETTINGS_CLEAR_SUCCESS .. param)
		    else
			    DEFAULT_CHAT_FRAME:AddMessage(AAHLocale.Messages.TOOLS_ITEM_NOT_FOUND .. param)
            end
		end
	elseif command == "clearall" then
		AAH.History.Reset()
		DEFAULT_CHAT_FRAME:AddMessage(AAHLocale.Messages.SETTINGS_CLEAR_ALL_SUCCESS)

	elseif command == "usewhitevalue" then
		if AAH_SavedSettings.UseMatWhiteValue then
			AAH_SavedSettings.UseMatWhiteValue = false
			--Message
		else
			AAH_SavedSettings.UseMatWhiteValue = true
			--Message
		end
		AAH_SettingsUseWhiteValue:SetChecked(AAH_SavedSettings.UseMatWhiteValue)

	elseif command == "pricehistory" then
		if AAH_SavedSettings.PriceHistoryAutoshow then
			AAH_SavedSettings.PriceHistoryAutoshow = false
			--Message
		else
			AAH_SavedSettings.PriceHistoryAutoshow = true
			--Message
		end
		AAH_SettingsAlwaysShowPriceHistory:SetChecked(AAH_SavedSettings.PriceHistoryAutoshow)
	elseif command == "numhistory" then
		if tonumber(param) then
			param = math.floor(tonumber(param))
            AAH.History.SetMaxDefaultEntries(param)
            AAH_SettingsMaxHistory:SetValue(AAH_SavedSettings.HistoryMaxSavedDefault)
		else
			--Message No Param
		end
	elseif command == "turn" then
		if param == "on" then
			AAH.Main.Toggle(true)
		elseif param == "off" then
			AAH.Main.Toggle(false)
		else
			DEFAULT_CHAT_FRAME:AddMessage(AAHLocale.Messages.TOOLS_UNKNOWN_COMMAND)
		end
	elseif command == "toggle" then
		AAH.Main.Toggle()
	else
		DEFAULT_CHAT_FRAME:AddMessage(AAHLocale.Messages.TOOLS_UNKNOWN_COMMAND)
	end
end