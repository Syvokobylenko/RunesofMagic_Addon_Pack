local Bid = {
	DisplayedItems = 8,
	SortMode = 0,
	SortItem = {
		[1] = "name",
		[2] = "level",
		[3] = "leftTime",
		[4] = "seller",
		[5] = "status",
	},
	SortFunc = {
		["60"] = "SortBidLess",
		["61"] = "SortBidMore",
		["62"] = "SortBuyoutLess",
		["63"] = "SortBuyoutMore",
		["70"] = "SortBidPPULess",
		["71"] = "SortBidPPUMore",
		["72"] = "SortBuyoutPPULess",
		["73"] = "SortBuyoutPPUMore",
	},
	List = {},
}
AAH.Bid = Bid

function Bid.OnLoad(this)
	AAH_BidHeaderPPU:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER)
    AAH.MoneyFrame.ResetMoney(AAH_BidListBidMoneyInput)
end

function Bid.Resize(num)
	AAH_BidList:SetSize(803, 380 + 44 * num)
	Bid.DisplayedItems = 8 + num
	for i = Bid.DisplayedItems + 1, 13 do
		getglobal("AAH_BidListItem"..i):Hide()
	end
	Bid.ReadList()
end

function Bid.ChangeSortMode(this)
	local id = this:GetID()
	Bid.ClearSortIcons()
	if Bid.List.sortIndex == id or Bid.List.sortIndex == -id then
		Bid.SortMode = (Bid.SortMode + 1) % 4
	else
		Bid.SortMode = 0
	end
	if id == 6 or id == 7 then
        AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], Bid.SortMode)
	else
		if Bid.List.sortIndex == id then
			id = -id
            AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], 1)
		else
            AAH.Tools.SetSortIcon(_G[this:GetName().."SortIcon"], 0)
		end
	end
	Bid.SortList(id)
end

function Bid.ClearSortIcons()
	for _, name in ipairs({"Name", "Level", "LeftTime", "Seller", "Status", "PPU", "Price"}) do
		getglobal("AAH_BidHeader"..name.."SortIcon"):SetFile("")
	end
end

function Bid.SortList(index)
	Bid.List.sortIndex = index
	local i = math.abs(index)
	if i == 6 or i == 7 then
		table.sort(Bid.List.Items, AAH.Tools[Bid.SortFunc[i..Bid.SortMode]])
	else
		AAH.Tools.CurrentSortItem = Bid.SortItem[i]

		if index > 0 then
			table.sort(Bid.List.Items, AAH.Tools.SortLess)
		else
			table.sort(Bid.List.Items, AAH.Tools.SortMore)
		end
	end
	Bid.DrawList()
end

function Bid.BidSelection(this)
	if Bid.Selection then
		AAH.Pay.PayAuction(Bid.List.Items[Bid.Selection], AAH.MoneyFrame.GetMoney(AAH_BidListBidMoneyInput), false, AAH.Pay.AuctionType.Bid)
	end
end

function Bid.BuySelection(this)
	if Bid.Selection then
		AAH.Pay.PayAuction(Bid.List.Items[Bid.Selection], 0, true, AAH.Pay.AuctionType.Bid)
	end
end

function AAH.Events.AUCTION_BUY_UPDATE(this)
	AAH.Bid.ReadList()
end

function Bid.ReadList()
	Bid.List.maxNums = GetAuctionNumBidItems()
	Bid.List.Items = {}
	for i = 1, Bid.List.maxNums do
		local name, count, rarity, texture, level, leftTime, seller, status, moneyMode, bidPrice, buyoutPrice = GetAuctionBidItemInfo(i)
		local itemid
		for _, id in pairs({200000, 200003}) do
			local moneycount = name:gsub("%"..COMMA, ""):match("(%d*) "..TEXT("Sys"..id.."_name_plural").."$")
			if moneycount then
				count = tonumber(moneycount)
				itemid = id
			end
		end

		Bid.List.Items[i] = {
			auctionid = i,
			name = name,
			rarity = rarity,
			count = count,
			texture = texture,
			level = level,
			leftTime = leftTime,
			seller = seller,
			status = status,
			moneyMode = moneyMode,
			bidPrice = bidPrice,
			buyoutPrice = buyoutPrice,
		}

		if itemid == 200000 then
			Bid.List.Items[i].bidppu = (count / bidPrice)
			Bid.List.Items[i].buyppu = (count / buyoutPrice)
		else
			local white = AAH.Tools.GetWhiteValue(itemid)
			Bid.List.Items[i].bidppu = (bidPrice / count) / white
			Bid.List.Items[i].buyppu = (buyoutPrice / count) / white
		end
	end
	if Bid.List.sortIndex then
		Bid.SortList(Bid.List.sortIndex)
	end
	local maxValue = Bid.List.maxNums - Bid.DisplayedItems
	if maxValue > 0 then
		AAH_BidListScrollBar:SetMinMaxValues(0, maxValue)
		AAH_BidListScrollBar:Show()
	else
		AAH_BidListScrollBar:SetMinMaxValues(0, 0)
		AAH_BidListScrollBar:Hide()
	end
	Bid.DrawList()
end

function Bid.DrawList()
	local value = AAH_BidListScrollBar:GetValue()
	local button, buttonName, info

	for i = 1, Bid.DisplayedItems do
		button = getglobal("AAH_BidListItem"..i)
		info = Bid.List.Items[value + i]
		if info then
			button.index = value + i
			buttonName = button:GetName()

			local inversecoloring = false
			local count = info.count
			if info.name:gsub("%"..COMMA, ""):match("%d* "..TEXT("Sys200000_name_plural").."$") then
				inversecoloring = true
				count = 0
			elseif info.name:gsub("%"..COMMA, ""):match("%d* "..TEXT("Sys200003_name_plural").."$") then
				count = 0
			end

			getglobal(buttonName.."Name"):SetText(info.name)
			getglobal(buttonName.."Name"):SetColor(GetItemQualityColor(info.rarity))
			SetItemButtonCount(getglobal(buttonName.."Icon"), count)
			SetItemButtonTexture(getglobal(buttonName.."Icon"), info.texture)

			getglobal(buttonName.."Level"):SetText(info.level)
			getglobal(buttonName.."LeftTime"):SetText(AAH.Tools.LocalTimeString(info.leftTime))
			getglobal(buttonName.."Seller"):SetText(info.seller)

			if info.count > 0 and info.bidPrice > 0 then
				getglobal(buttonName.."PPUBid"):SetText(AAH.Tools.FormatThousands(math.floor(info.bidppu)), 1, 1, 1)
				if info.buyoutPrice > 0 then
					getglobal(buttonName.."PPUBuy"):SetText(AAH.Tools.FormatThousands(math.floor(info.buyppu)), 1, 1, 1)
				else
					getglobal(buttonName.."PPUBuy"):SetText("", 1, 1, 1)
				end
			end

            -- TODO: fix it
--~             local fixedName=info.name
--~ 			if AAH_SavedHistoryTable[fixedName] and AAH_SavedHistoryTable[fixedName].avg then
--~ 				AAH.Tools.GetAvgPriceColor(info.bidPrice / info.count, AAH_SavedHistoryTable[fixedName].avg, buttonName.."PPUBid", inversecoloring)
--~ 				AAH.Tools.GetAvgPriceColor(info.buyoutPrice / info.count, AAH_SavedHistoryTable[fixedName].avg, buttonName.."PPUBuy", inversecoloring)
--~ 			end

			if info.status then
				getglobal(buttonName.."Status"):SetText(AUCTION_HIGHEST_PRICE, 0, 1, 0)
			else
				getglobal(buttonName.."Status"):SetText(AUCTION_BID_EXCEED, 1, 0, 0)
			end

			MoneyFrame_Update(buttonName.."BidMoney", info.bidPrice, info.moneyMode or "copper")
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
	Bid.Select(Bid.Selection)
end

function Bid.List_IconClick(this,key)
    if IsShiftKeyDown() and key == "LBUTTON" then
        GameTooltip:SetAuctionBidItem(Bid.List.Items[this:GetParent().index].auctionid)
        local item = AAH.ItemLink.GetItemDataFromTooltip()
        if item then
            local itemLink = AAH.ItemLink.GenerateLink(item)
            AAH.Tools.ChatEdit_AddItemLink(itemLink)
        end
    end

    Bid.Select(this:GetParent():GetID())
end

function Bid.Select(auctionid)
	AAH_BidListBidButton:Disable()
	AAH_BidListBuyoutButton:Disable()
	AAH_BidListHistoryButton:Disable()
	Bid.Selection = auctionid

	for i = 1, Bid.DisplayedItems do
		getglobal("AAH_BidListItem"..i):UnlockHighlight()
	end

	if auctionid then
		local button = getglobal("AAH_BidListItem"..auctionid)
		local info = Bid.List.Items[button.index]

		if info then
			AAH.MoneyFrame.SetMode(AAH_BidListBidMoneyInput, info.moneyMode)
			AAH.MoneyFrame.SetMoney(AAH_BidListBidMoneyInput, AAH.Tools.CalcBidPrice(info.bidPrice))

			if not info.status then
				AAH_BidListBidButton:Enable()
			end
			if info.buyoutPrice > 0 then
				AAH_BidListBuyoutButton:Enable()
			end
			AAH_BidListHistoryButton:Enable()
			button:LockHighlight()
		end
	end
end

