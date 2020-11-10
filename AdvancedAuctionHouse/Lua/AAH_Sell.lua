local Sell={
    AUTOFILLSTATES = {
        AAHLocale.Messages.SELL_NONE,
        AAHLocale.Messages.SELL_LAST,
        AAHLocale.Messages.GENERAL_AVERAGE,
        AAHLocale.Messages.SELL_FORMULA,
    },
    DURATION_TIMES= {
        TEXT("AUCTION_TIME_4"),
        TEXT("AUCTION_TIME_3"),
        TEXT("AUCTION_TIME_2"),
        TEXT("AUCTION_TIME_1"),
    },

    MAXITEMS = 6,
    SortMode = 0,
    internal_money_update = nil,

	MoneyType = 1,
	MoneyAuction = false,
	SellMoneyMode = "copper",
	PayMoneyMode = "copper",
	SellMoneyType = 1,
	PayMoneyType = 1,
	ItemTexture = "",
}
AAH.Sell=Sell

function Sell.OnLoad(this)
--@non-alpha@
	AAH_SellItemBrowse:Hide()
--@end-non-alpha@
	AAH_SellMoneyAuctionLabel:SetText(TEXT("AUCTION_SELL_MONEY_TAB"))
	Sell.ChangeAuctionType(false)

	AAH_SellAutoPriceLabel:SetText(AAHLocale.Messages.SELL_AUTO_PRICE_HEADER)
	AAH_SellAutoFillPercentBidLabel:SetText(AAHLocale.Messages.SELL_PERCENT)
	AAH_SellAutoFillPercentBuyoutLabel:SetText(AAHLocale.Messages.SELL_PERCENT)
	AAH_SellPriceBidLabel:SetText(TEXT("AUCTION_FIRST_PRICE_COLON"))
	AAH_SellPriceBidPPULabel:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER..":")
	AAH_SellPriceBuyoutLabel:SetText(TEXT("AUCTION_BUYOUT_PRICE_COLON")..":")
	AAH_SellPriceBuyoutPPULabel:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER..":")

	UIDropDownMenu_SetWidth(AAH_SellAutoFillBidDropDown, 70)
	UIDropDownMenu_SetWidth(AAH_SellAutoFillBuyoutDropDown, 70)
	UIDropDownMenu_SetWidth(AAH_SellDurationDropDown, 80)

	UIDropDownMenu_Initialize(AAH_SellDurationDropDown, Sell.DurationDropDown_Show)
	UIDropDownMenu_Initialize(AAH_SellAutoFillBidDropDown, Sell.AutoFillBidDropDown_Show)
	UIDropDownMenu_Initialize(AAH_SellAutoFillBuyoutDropDown, Sell.AutoFillBuyoutDropDown_Show)

    AAH.MoneyFrame.SetFocusOrder(AAH_SellMoneyAmount, AAH_SellPriceBid, AAH_SellPriceBuyoutPPU)
    AAH.MoneyFrame.SetFocusOrder(AAH_SellPriceBid, AAH_SellPriceBidPPU, AAH_SellMoneyAmount)
    AAH.MoneyFrame.SetFocusOrder(AAH_SellPriceBidPPU, AAH_SellPriceBuyout, AAH_SellPriceBid)
    AAH.MoneyFrame.SetFocusOrder(AAH_SellPriceBuyout, AAH_SellPriceBuyoutPPU, AAH_SellPriceBidPPU)
    AAH.MoneyFrame.SetFocusOrder(AAH_SellPriceBuyoutPPU, AAH_SellMoneyAmount, AAH_SellPriceBuyout)

    MoneyInputFrame_SetOnvalueChangedFunc(AAH_SellMoneyAmount, Sell.OnOfferChange)
    MoneyInputFrame_SetOnvalueChangedFunc(AAH_SellPriceBid, Sell.OnOfferChange1)
    MoneyInputFrame_SetOnvalueChangedFunc(AAH_SellPriceBidPPU, Sell.OnOfferChange2)
    MoneyInputFrame_SetOnvalueChangedFunc(AAH_SellPriceBuyout, Sell.OnOfferChange3)
    MoneyInputFrame_SetOnvalueChangedFunc(AAH_SellPriceBuyoutPPU, Sell.OnOfferChange4)
end

function Sell.OnShow()
	Sell.List_Update()
	Sell.Item_Update()
	Sell.AutoFillBidEditBox_CheckVisibility()
	Sell.AutoFillBuyoutEditBox_CheckVisibility()

	SetSellMoneyType(Sell.SellMoneyType)
    Sell.Item_Update()
end

function Sell.OnHide()
	SetSellMoneyType(0)
end

function Sell.OnInit()
	AAH.Tools.SetDropDown(AAH_SellDurationDropDown, AAH_SavedSettings.SellDurationSelected, Sell.DURATION_TIMES[AAH_SavedSettings.SellDurationSelected])
	AAH.Tools.SetDropDown(AAH_SellAutoFillBidDropDown, AAH_SavedSettings.AutoFillBidSelected, Sell.AUTOFILLSTATES[AAH_SavedSettings.AutoFillBidSelected])
	AAH.Tools.SetDropDown(AAH_SellAutoFillBuyoutDropDown, AAH_SavedSettings.AutoFillBuyoutSelected, Sell.AUTOFILLSTATES[AAH_SavedSettings.AutoFillBuyoutSelected])
	AAH_SellAutoFillPercentBid:SetText(AAH_SavedSettings.SellAutoFillPercentBidValue)
	AAH_SellAutoFillFormulaBid:SetText(AAH_SavedSettings.FormulaBid)
	AAH_SellAutoFillPercentBuyout:SetText(AAH_SavedSettings.SellAutoFillPercentBuyoutValue)
	AAH_SellAutoFillFormulaBuyoutout:SetText(AAH_SavedSettings.FormulaBuyout)

    Sell.AutoFillBuyoutEditBox_CheckVisibility()
    Sell.AutoFillBidEditBox_CheckVisibility()
end

function Sell.Resize(num, value)
	Sell.MAXITEMS = 6 + num
	AAH_SellList:SetSize(628, 295 + value)
	AAH_SellItemBrowse:SetSize(178, 295 + value)

	for i = Sell.MAXITEMS + 1, 11 do
		getglobal("AAH_SellListItem"..i):Hide()
	end
	for i = (Sell.MAXITEMS * 2) + 1, 22 do
		getglobal("AAH_SellItemBrowseItem"..i):Hide()
	end
	Sell.List_Update()
end

function Sell.ChangeAuctionType(state)

	AAH_SellMoneyAuction:SetChecked(state)
	Sell.MoneyAuction = state

	if state then
		AAH_SellPlaceItemButton:Disable()
		AAH_SellPayMoneyModeButton1:Disable()
		AAH_SellPayMoneyModeButton2:Disable()
		AAH_SellPlaceItemButtonName:Hide()
		AAH_SellPlaceItemButtonCount:Hide()
		AAH_SellMoneyModeButton1:Enable()
		AAH_SellMoneyModeButton2:Enable()
		AAH_SellMoneyAmount:Show()

		Sell.AuctionMoneyTypeChanged()
	else
		AAH_SellPlaceItemButton:Enable()
		AAH_SellPayMoneyModeButton1:Enable()
		AAH_SellPayMoneyModeButton2:Enable()
		AAH_SellPlaceItemButtonName:Show()
		AAH_SellPlaceItemButtonCount:Show()
		AAH_SellMoneyModeButton1:Disable()
		AAH_SellMoneyModeButton2:Disable()
		AAH_SellMoneyAmount:Hide()
		AAH_SellPriceBidPPULabel:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER..": ")
		AAH_SellPriceBuyoutPPULabel:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER..": ")

		Sell.AuctionPayMoneyTypeChanged()
	end
end

function Sell.AuctionMoneyTypeChanged()
	Sell.MoneyType = MoneyModeFrame_GetSelected(AAH_SellMoneyMode)
    local PPULabel
	if Sell.MoneyType == 1 then --"copper"
		Sell.SellMoneyMode = "copper"
		Sell.PayMoneyMode = "account"
		Sell.SellMoneyType = 1
		Sell.PayMoneyType = 2
		Sell.ItemTexture = "Interface/Icons/coin_03.dds"
        PPULabel = AAHLocale.Messages.GENERAL_UNITS_PER_PRICE_HEADER..": "
	else --"account"
		Sell.SellMoneyMode = "account"
		Sell.PayMoneyMode = "copper"
		Sell.SellMoneyType = 2
		Sell.PayMoneyType = 1
		Sell.ItemTexture = "Interface/Icons/crystal_01.dds"
        PPULabel = AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER..": "
	end

	AAH.MoneyFrame.SetMode(AAH_SellPriceBid, Sell.PayMoneyMode)
	AAH.MoneyFrame.SetMode(AAH_SellPriceBuyout, Sell.PayMoneyMode)
	AAH.MoneyFrame.SetMode(AAH_SellPriceBidPPU, "copper")
	AAH.MoneyFrame.SetMode(AAH_SellPriceBuyoutPPU, "copper")
	AAH.MoneyFrame.SetMode(AAH_SellMoneyAmount, Sell.SellMoneyMode)
	MoneyFrameTemplate_SetMode(AAH_SellFeeFrame, Sell.PayMoneyMode)
	MoneyFrameTemplate_SetMode(AAH_SellProfitBuyoutFrame, Sell.PayMoneyMode)
    AAH_SellPriceBidPPULabel:SetText(PPULabel)
    AAH_SellPriceBuyoutPPULabel:SetText(PPULabel)
	AAH_SellPlaceItemButtonTexture:SetFile(Sell.ItemTexture)

	SetSellMoneyType(Sell.SellMoneyType)
	Sell.Item_Update()
end

function Sell.AuctionPayMoneyTypeChanged()
	Sell.MoneyType = MoneyModeFrame_GetSelected(AAH_SellPayMoneyMode)
	if Sell.MoneyType == 1 then --"copper"
		Sell.SellMoneyMode = "copper"
		Sell.PayMoneyMode = "copper"
		Sell.SellMoneyType = 1
		Sell.PayMoneyType = 1
	else --"account"
		Sell.SellMoneyMode = "account"
		Sell.PayMoneyMode = "account"
		Sell.SellMoneyType = 2
		Sell.PayMoneyType = 2
	end
	Sell.ItemTexture = ""

	AAH.MoneyFrame.SetMode(AAH_SellPriceBid, Sell.PayMoneyMode)
	AAH.MoneyFrame.SetMode(AAH_SellPriceBidPPU, Sell.PayMoneyMode)
	AAH.MoneyFrame.SetMode(AAH_SellPriceBuyout, Sell.PayMoneyMode)
	AAH.MoneyFrame.SetMode(AAH_SellPriceBuyoutPPU, Sell.PayMoneyMode)
	MoneyFrameTemplate_SetMode(AAH_SellFeeFrame, "copper") -- don't know about fees of diamond auctions on inofficial servers, left as is
	MoneyFrameTemplate_SetMode(AAH_SellProfitBuyoutFrame, "copper")

	SetSellMoneyType(0)
	Sell.Item_Update()
end

function Sell.ClearItem()
	if GetAuctionItem() then
		ClickAuctionItemButton()
		PickupBagItem(GetCursorItemInfo())
	end
end

function Sell.GetAuctionItem()
    local name, itemTexture, stackCount, itemPrice = GetAuctionItem()
	local moneyMode
	if Sell.MoneyAuction then
		if Sell.MoneyType == 1 then --"copper"
			moneyMode = "copper"
			name = TEXT("Sys200000_name_plural")
			itemTexture = "Interface/Icons/coin_03.dds"
		else --"account"
			moneyMode = "account"
			name = TEXT("Sys200003_name")
			itemTexture = "Interface/Icons/crystal_01.dds"
		end
		stackCount = AAH.MoneyFrame.GetMoney(AAH_SellMoneyAmount, moneyMode)
	end

    return name, itemTexture, stackCount, itemPrice, moneyMode
end

function Sell.ListHeader_OnClick(this)
	local id = this:GetID()

	AAH_SellHeaderNameSortIcon:SetFile("")
	AAH_SellHeaderLevelSortIcon:SetFile("")
	AAH_SellHeaderLeftTimeSortIcon:SetFile("")
	AAH_SellHeaderBuyerSortIcon:SetFile("")
	AAH_SellHeaderPriceSortIcon:SetFile("")


	if AuctionSellList.sortIndex == id or AuctionSellList.sortIndex == -id then
		Sell.SortMode = (Sell.SortMode + 1) % 4
	else
		Sell.SortMode = 0
	end
	if id == 6 then
        AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], Sell.SortMode)
	else
		if AuctionSellList.sortIndex == id then
			id = -id
            AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], 1)
		else
            AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], 0)
		end
	end
	Sell.List_Sort(id)
end

function Sell.List_Sort(index)
	AuctionSellList.sortIndex = index
	if math.abs(index) == 6 then
		if Sell.SortMode == 0 then
			table.sort(AuctionSellList.list, AAH.Tools.SortBidLess)
		elseif Sell.SortMode == 1 then
			table.sort(AuctionSellList.list, AAH.Tools.SortBidMore)
		elseif Sell.SortMode == 2 then
			table.sort(AuctionSellList.list, AAH.Tools.SortBuyoutLess)
		elseif Sell.SortMode == 3 then
			table.sort(AuctionSellList.list, AAH.Tools.SortBuyoutMore)
		end
	else
		if index == 1 or index == -1 then
			AAH.Tools.CurrentSortItem = "name"
		elseif index == 2 or index == -2 then
			AAH.Tools.CurrentSortItem = "level"
		elseif index == 3 or index == -3 then
			AAH.Tools.CurrentSortItem = "leftTime"
		elseif index == 4 or index == -4 then
			AAH.Tools.CurrentSortItem = "bidder"
		elseif index == 5 or index == -5 then
			AAH.Tools.CurrentSortItem = "status"
		end
		if AuctionSellList.sortIndex > 0 then
			table.sort(AuctionSellList.list, AAH.Tools.SortLess)
		else
			table.sort(AuctionSellList.list, AAH.Tools.SortMore)
		end
	end
	Sell.List_UpdateItems()
end

function Sell.AutoFillBidDropDown_Show()
	local buttonInfo
	for i = 1, 4 do
		buttonInfo = {}
		buttonInfo.text = Sell.AUTOFILLSTATES[i]
		buttonInfo.func = Sell.AutoFillBidDropDown_Click
		UIDropDownMenu_AddButton(buttonInfo)
	end
end

function Sell.AutoFillBidDropDown_Click(button)
	AAH.Tools.SetDropDown(AAH_SellAutoFillBidDropDown, button:GetID(), button:GetText())
	AAH_SavedSettings.AutoFillBidSelected = button:GetID()
	Sell.AutoFillBidEditBox_CheckVisibility()
	Sell.AutoFillPriceFields()
end

function Sell.AutoFillBidEditBox_CheckVisibility()
    AAH_SellAutoFillPercentBid:Hide()
    AAH_SellAutoFillFormulaBid:Hide()

	if UIDropDownMenu_GetSelectedID(AAH_SellAutoFillBidDropDown) == 3 then
		AAH_SellAutoFillPercentBid:Show()
	elseif UIDropDownMenu_GetSelectedID(AAH_SellAutoFillBidDropDown) == 4 then
		AAH_SellAutoFillFormulaBid:Show()
	end
end

function Sell.AutoFillBuyoutDropDown_Show()
	local buttonInfo
	for i = 1, 4 do
		buttonInfo = {}
		buttonInfo.text = Sell.AUTOFILLSTATES[i]
		buttonInfo.func = Sell.AutoFillBuyoutDropDown_Click
		UIDropDownMenu_AddButton(buttonInfo)
	end
end

function Sell.AutoFillBuyoutDropDown_Click(button)
	AAH.Tools.SetDropDown(AAH_SellAutoFillBuyoutDropDown, button:GetID(), button:GetText())
	AAH_SavedSettings.AutoFillBuyoutSelected = button:GetID()
	Sell.AutoFillBuyoutEditBox_CheckVisibility()
	Sell.AutoFillPriceFields()
end

function Sell.AutoFillBuyoutEditBox_CheckVisibility()
    AAH_SellAutoFillPercentBuyout:Hide()
    AAH_SellAutoFillFormulaBuyoutout:Hide()

	if UIDropDownMenu_GetSelectedID(AAH_SellAutoFillBuyoutDropDown) == 3 then
		AAH_SellAutoFillPercentBuyout:Show()
	elseif UIDropDownMenu_GetSelectedID(AAH_SellAutoFillBuyoutDropDown) == 4 then
		AAH_SellAutoFillFormulaBuyoutout:Show()
	end
end


function AAH.Events.AUCTION_AUCTION_INFO_UPDATE(this)
    Sell.CurrentItem = AAH.Tools.ParseLink(AAH.HookItemLink)
	Sell.Item_Update()
end

function Sell.OnDroppedItem()
	ClickAuctionItemButton()
end

function Sell.Item_Update()
	if Sell.MoneyAuction then
		if Sell.MoneyType == 1 then
			itemTexture = "Interface/Icons/coin_03.dds"
            AAH.History.UpdateSellItemHistory(200000)
		else
			itemTexture = "Interface/Icons/crystal_01.dds"
            AAH.History.UpdateSellItemHistory(200003)
		end

		AAH_SellHistoryButton:Enable()

		AAH_SellPlaceItemButtonTexture:SetTexture(itemTexture)
		AAH_SellPlaceItemButtonName:SetText("")
		AAH_SellPlaceItemButtonCount:SetText("")
		AAH.MoneyFrame.ResetMoney(AAH_SellMoneyAmount)
		AAH.MoneyFrame.ResetMoney(AAH_SellPriceBid)
		AAH.MoneyFrame.ResetMoney(AAH_SellPriceBuyout)
	else
		local name, itemTexture, stackCount, itemPrice = GetAuctionItem()

		if stackCount and stackCount <= 1 then
			stackCount = ""
		end
		AAH_SellPlaceItemButtonName:SetText(name)
		AAH_SellPlaceItemButtonTexture:SetTexture(itemTexture)
		AAH_SellPlaceItemButtonCount:SetText(stackCount)
		AAH.MoneyFrame.ResetMoney(AAH_SellPriceBid)
		AAH.MoneyFrame.ResetMoney(AAH_SellPriceBuyout)
		if name then
            AAH.History.UpdateSellItemHistory(Sell.CurrentItem)
			AAH_SellHistoryButton:Enable()
		else
			AAH_SellHistoryButton:Disable()
		end


	end

    Sell.FeeFrame_Update()
	Sell.TestIsAuctionValid()
end

function Sell.FeeFrame_Update()
    local _, _, stackCount, price, _ = Sell.GetAuctionItem()
	MoneyFrame_Update("AAH_SellFeeFrame", Sell.GetAuctionFee(price,stackCount) )
end

function Sell.GetAuctionFee(price,stackCount)
    if not price or not stackCount then return 0 end

    local times={12,24,48,72}
	local duration = times[AAH_SavedSettings.SellDurationSelected] or 0
	return math.floor((duration / 4) * (price * stackCount * 0.006))
end

function Sell.TestIsAuctionValid()
	local bid = AAH.MoneyFrame.GetMoney(AAH_SellPriceBid, Sell.PayMoneyMode or "copper")
	local buyout = AAH.MoneyFrame.GetMoney(AAH_SellPriceBuyout, Sell.PayMoneyMode or "copper")
	if (GetAuctionItem() or Sell.MoneyAuction) and bid > 0 and (buyout <= 0 or buyout >= bid) then
		AAH_SellConfirmButton:Enable()
	else
		AAH_SellConfirmButton:Disable()
	end
end

function Sell.ConfirmButton_OnClick(this, key)

    local _, _, count, itemPrice, moneyMode = Sell.GetAuctionItem()

	local bid = AAH.MoneyFrame.GetMoney(AAH_SellPriceBid, Sell.PayMoneyMode)
	local buyout = AAH.MoneyFrame.GetMoney(AAH_SellPriceBuyout, Sell.PayMoneyMode)

    local item = Sell.CurrentItem

	if Sell.MoneyAuction then
		if count > GetPlayerMoney(moneyMode) then
			StaticPopup_Show("AUCTIONCREATE_ALERT")
			return
		end
		if Sell.MoneyType == 2 then
            item=200003
			if ( not CheckPasswordState(Sell.ConfirmButton_OnClick) ) then
				return
			end
        else
            item=200000
		end
		CreateAuctionMoney(AAH_SavedSettings.SellDurationSelected, Sell.MoneyType, count, bid, Sell.PayMoneyType,  buyout)
	else
		if Sell.GetAuctionFee(itemPrice,count) > GetPlayerMoney("copper") then
			StaticPopup_Show("AUCTIONCREATE_ALERT")
			return
		end
		CreateAuctionItem(AAH_SavedSettings.SellDurationSelected, bid, Sell.PayMoneyType, buyout)
	end


    assert(count and count>0)
	local bidppu = bid / count
	local buyoutppu = buyout / count
    if item==200000 then
    	bidppu = AAH.MoneyFrame.GetMoney(AAH_SellPriceBidPPU)
	    buyoutppu = AAH.MoneyFrame.GetMoney(AAH_SellPriceBuyoutPPU)
    end

    Sell.UpdateLastPrice(item, bidppu, buyoutppu)
	Sell.List_Update()
end

function Sell.RequestHistory()
    local id = Sell.CurrentItem
    if Sell.MoneyAuction then
        id = (Sell.MoneyType==1) and 200000 or 200003
    end

    AAH.History.RequestHistoryPopup(nil,id)
end

function AAH.Events.AUCTION_SELL_UPDATE(this)
	Sell.List_Update()
end

function Sell.List_Update()
	local name, count, rarity, texture, level, leftTime, bidder, moneyMode, bidPrice, buyoutPrice
	AuctionSellList.maxNums = GetAuctionNumSellItems()
	AuctionSellList.list = {}
	for i = 1, AuctionSellList.maxNums do
		name, count, rarity, texture, level, leftTime, bidder, moneyMode, bidPrice, buyoutPrice = GetAuctionSellItemInfo(i)
		AuctionSellList.list[i] = {}
		AuctionSellList.list[i].auctionid = i
		AuctionSellList.list[i].name = name
		AuctionSellList.list[i].count = count
		AuctionSellList.list[i].rarity = rarity
		AuctionSellList.list[i].texture = texture
		AuctionSellList.list[i].level = level
		AuctionSellList.list[i].leftTime = leftTime
		AuctionSellList.list[i].bidder = bidder
		AuctionSellList.list[i].moneyMode = moneyMode
		AuctionSellList.list[i].bidPrice = bidPrice
		AuctionSellList.list[i].buyoutPrice = buyoutPrice
	end
	if AuctionSellList.sortIndex then
		Sell.List_Sort(AuctionSellList.sortIndex)
	end
	-- Update ScrollBar
	local maxValue = AuctionSellList.maxNums - Sell.MAXITEMS
	if maxValue > 0 then
		AAH_SellListScrollBar:SetMinMaxValues(0, maxValue)
		AAH_SellListScrollBar:Show()
	else
		AAH_SellListScrollBar:SetMinMaxValues(0, 0)
		AAH_SellListScrollBar:Hide()
	end
	Sell.List_UpdateItems()
end

function Sell.List_UpdateItems()
	local index = AAH_SellListScrollBar:GetValue() + 1
	local button, buttonName
	local info, r, g, b
	for i = 1, Sell.MAXITEMS do
		button = getglobal("AAH_SellListItem"..i)
		info = AuctionSellList.list[index]
		if info then
			button.index = index
			buttonName = button:GetName()
			r, g, b = GetItemQualityColor(info.rarity)
			getglobal(buttonName.."Name"):SetText(info.name)
			getglobal(buttonName.."Name"):SetColor(r, g, b)
			getglobal(buttonName.."Level"):SetText(info.level)
			getglobal(buttonName.."LeftTime"):SetText(AAH.Tools.LocalTimeString(info.leftTime))
			getglobal(buttonName.."Bidder"):SetText(info.bidder)
			SetItemButtonCount(getglobal(buttonName.."Icon"), info.count)
			SetItemButtonTexture(getglobal(buttonName.."Icon"), info.texture)
			MoneyFrame_Update(buttonName.."BidMoney", info.bidPrice, info.moneyMode or "copper")
			if info.buyoutPrice > 0 then
				MoneyFrame_Update(buttonName.."BuyoutMoney", info.buyoutPrice, info.moneyMode or "copper")
				getglobal(buttonName.."BuyoutMoney"):Show()
			else
				getglobal(buttonName.."BuyoutMoney"):Hide()
			end
			button:Show()
		else
			button:Hide()
		end
		index = index + 1
	end
	AAH_SellNumberLabel:SetText(AAHLocale.Messages.SELL_NUM_AUCTION)
	AAH_SellNumber:SetText(GetAuctionNumSellItems() .. "/30")
	Sell.List_SetSelected(AuctionSellList.selected)
end

function Sell.List_IconClick(this,key)
    if IsShiftKeyDown() and key == "LBUTTON" then
        GameTooltip:SetAuctionSellItem(AuctionSellList.list[this:GetParent().index].auctionid)
        local item = AAH.ItemLink.GetItemDataFromTooltip()
        if item then
            local itemLink = AAH.ItemLink.GenerateLink(item)
            AAH.Tools.ChatEdit_AddItemLink(itemLink)
        end
    end

    Sell.List_SetSelected(this:GetParent():GetID())
end


function Sell.List_SetSelected(auctionid)
	AAH_SellListCancelButton:Disable()
	AuctionSellList.selected = auctionid
	local button, info
	for i = 1, Sell.MAXITEMS do
		button = getglobal("AAH_SellListItem"..i)
		info = AuctionSellList.list[button.index]
		if info and button.index == auctionid then
			AAH_SellListCancelButton:Enable()
			button:LockHighlight()
		else
			button:UnlockHighlight()
		end
	end
end

function Sell.DurationDropDown_Show()
	local info
	for _,v in ipairs(Sell.DURATION_TIMES) do
		info = {}
		info.text = v
		info.func = function(button)
			AAH.Tools.SetDropDown(AAH_SellDurationDropDown, button:GetID(), button:GetText())
			AAH_SavedSettings.SellDurationSelected = button:GetID()
			Sell.FeeFrame_Update()
		end
		UIDropDownMenu_AddButton(info)
	end
end

function Sell.UpdateLastPrice(itemid, bid, buyout)
	if not AAH_LastSellPrice[itemid] then
		AAH_LastSellPrice[itemid] = {}
	end
	AAH_LastSellPrice[itemid].bid = bid
	AAH_LastSellPrice[itemid].buyout = buyout
end

function Sell.AutoFillPriceFields()
	local linkid, linkname = AAH.Tools.ParseLink(AAH.HookItemLink)
    local name, _, _, _, moneyMode = Sell.GetAuctionItem()
	if moneyMode=="copper" then
		linkid = 200000
		linkname = name
	elseif moneyMode=="account" then
        linkid = 200003
        linkname = name
    end

	if not name or name == "" or linkname ~= name then
		AAH_SellHistoryButton:Disable()
		return
	end
	AAH_SellHistoryButton:Enable()

    local white = AAH.Tools.GetWhiteValue(linkid)

    local ppu = Sell.AutoCalcPPU("bid", UIDropDownMenu_GetSelectedID(AAH_SellAutoFillBidDropDown), linkid, white,  AAH_SellAutoFillPercentBid:GetText(), AAH_SellAutoFillFormulaBid:GetText() )
    AAH.MoneyFrame.SetMoney(AAH_SellPriceBidPPU, ppu)

    local ppu = Sell.AutoCalcPPU("buyout", UIDropDownMenu_GetSelectedID(AAH_SellAutoFillBuyoutDropDown), linkid, white,  AAH_SellAutoFillPercentBuyout:GetText(), AAH_SellAutoFillFormulaBuyoutout:GetText() )
    AAH.MoneyFrame.SetMoney(AAH_SellPriceBuyoutPPU, ppu)
end

function Sell.AutoCalcPPU(field, method, linkid, white, percent, formula)

    -- none
    if method ==1 then
        return nil
    -- last
    elseif method ==2 then
        if AAH_LastSellPrice[linkid] and AAH_LastSellPrice[linkid][field] then
			return AAH_LastSellPrice[linkid][field] / white
        elseif AAH_SavedSettings.AvgSuggest then
            avg = AAH.History.GetAveragePrice(linkid)
    		if avg then
	    		return (avg / white)
		    end
        end
    -- percent
    elseif method ==3 then
		if tonumber(percent)==nil then
			percent = 100
		end
		percent=percent/100
        local avg = AAH.History.GetAveragePrice(linkid)
		if avg then
			return (avg / white) * percent
		end
    --formula
	elseif method == 4 then
    	formula = string.lower(formula)
	    AAH_SavedSettings["Formula"..field] = formula
        local avg,min,max,median = AAH.History.GetPriceStatistic(linkid)
        if avg then
			formula = string.gsub(formula, "avg", avg / white)
			formula = string.gsub(formula, "min", min / white)
			formula = string.gsub(formula, "max", max / white)
			formula = string.gsub(formula, "median", median / white)
		end
		local value = tonumber(AAH.Tools.EvaluateString(formula))
		if value then
			return value
		end
    end
end

function Sell.UpdateProfit()
    if Sell.MoneyAuction then
	    MoneyFrame_Update("AAH_SellProfitBuyoutFrame",0)
    else
        local money= math.max(AAH.MoneyFrame.GetMoney(AAH_SellPriceBuyout),AAH.MoneyFrame.GetMoney(AAH_SellPriceBid))
        local tax = math.floor(money*0.06)+1
	    MoneyFrame_Update("AAH_SellProfitBuyoutFrame", tax)
    end
end

function Sell.OnOfferChange(this)
    Sell.PriceInput_OnTextChange(AAH_SellPriceBidPPU, AAH_SellPriceBid, true)
    Sell.PriceInput_OnTextChange(AAH_SellPriceBuyoutPPU, AAH_SellPriceBuyout, true)
    Sell.TestIsAuctionValid()
end

function Sell.OnOfferChange1(this)
    Sell.PriceInput_OnTextChange(AAH_SellPriceBidPPU, AAH_SellPriceBid, false)
    Sell.TestIsAuctionValid()
end

function Sell.OnOfferChange2(this)
    Sell.PriceInput_OnTextChange(AAH_SellPriceBidPPU, AAH_SellPriceBid, true)
    Sell.TestIsAuctionValid()
end

function Sell.OnOfferChange3(this)
    Sell.PriceInput_OnTextChange(AAH_SellPriceBuyoutPPU, AAH_SellPriceBuyout, false)
    Sell.TestIsAuctionValid()
end

function Sell.OnOfferChange4(this)
    Sell.PriceInput_OnTextChange(AAH_SellPriceBuyoutPPU, AAH_SellPriceBuyout, true)
    Sell.TestIsAuctionValid()
end

function Sell.PriceInput_OnTextChange(money_ppu, money_total, ppuToFull)
    if Sell.internal_money_update then
        return
    end

    local _, _, stackCount = Sell.GetAuctionItem()
	local white = AAH.Tools.GetWhiteValue(Sell.CurrentItem)
	if not stackCount or stackCount < 1 then
		stackCount = 1
	end

    local inverse
    if Sell.PayMoneyMode == "account" then
        inverse = true
    end

    Sell.internal_money_update = true
	if ppuToFull then
        local ppu = AAH.MoneyFrame.GetMoney(money_ppu)
        if inverse and ppu~=0 then ppu=1/ppu end
        AAH.MoneyFrame.SetMoney(money_total, math.ceil(ppu * stackCount * white))
	else
        local total = AAH.MoneyFrame.GetMoney(money_total)
        local ppu = total / (stackCount * white)
        if inverse and ppu~=0 then ppu=1/ppu end

        AAH.MoneyFrame.SetMoney(money_ppu, math.ceil(ppu))
	end

    Sell.UpdateProfit()
    Sell.internal_money_update = nil
end


