local Pay = {
    AuctionType = {
        Browse = 0,
        Bid = 1,
    },
    Current = {},
}
AAH.Pay = Pay

function Pay.InitPopups()
    StaticPopupDialogs["AAH_BID_NORMAL"] = {
        text = TEXT("BUYOUT_CONFIRMATION"),
        button1 = TEXT("AUCTION_BID"),
        button2 = TEXT("CANCEL"),
        OnShow = function(this)
            local money = Pay.Current.Bid
            MoneyFrame_Update(this:GetName().."MoneyFrame", money, Pay.Current.Currency)
        end,
        OnAccept = function(this)
            Pay.BidItem(Pay.Current.Type, Pay.Current.Item.auctionid, Pay.Current.Bid)
        end,
	    hasMoneyFrame = 1,
        hideOnEscape = 1,
    }
    StaticPopupDialogs["AAH_BID_PASSWORD"] = {
        text = TEXT("BID_PASSWORD"),
        button1 = TEXT("ACCEPT"),
        button2 = TEXT("CANCEL"),
        OnAccept = function(this)
            local Pass = getglobal(this:GetName().."EditBox")
            Pay.BidItem(Pay.Current.Type, Pay.Current.Item.auctionid, Pay.Current.Bid, Pass:GetText())
            Pass:SetText("")
        end,
        OnHide = function(this)
		    getglobal(this:GetName().."EditBox"):SetText("")
	    end,
        hasEditBox = 1,
        passwordMode = 1,
        hideOnEscape = 1,
    }
    StaticPopupDialogs["AAH_BUYOUT_NORMAL"] = {
        text = TEXT("BUYOUT_CONFIRMATION"),
        button1 = TEXT("ACCEPT"),
        button2 = TEXT("CANCEL"),
        OnShow = function(this)
            MoneyFrame_Update(this:GetName().."MoneyFrame", Pay.Current.Buy, Pay.Current.Currency)
        end,
        OnAccept = function(this)
            Pay.BuyItem(Pay.Current.Type, Pay.Current.Item.auctionid)
        end,
        hasMoneyFrame = 1,
        hideOnEscape = 1,
    }
    StaticPopupDialogs["AAH_BUYOUT_PASSWORD"] = {
        text = TEXT("BUYOUT_CONFIRMATION_PASSWORD"),
        button1 = TEXT("ACCEPT"),
        button2 = TEXT("CANCEL"),
        OnShow = function(this)
            MoneyFrame_Update(this:GetName().."MoneyFrame", Pay.Current.Buy, Pay.Current.Currency)
        end,
        OnAccept = function(this)
            local Pass = getglobal(this:GetName().."EditBox");
            Pay.BuyItem(Pay.Current.Type, Pay.Current.Item.auctionid, Pass:GetText())
            Pass:SetText("")
        end,
        OnHide = function(this)
		    getglobal(this:GetName().."EditBox"):SetText("")
	    end,
        hasEditBox = 1,
        passwordMode = 1,
        hasMoneyFrame = 1,
        hideOnEscape = 1,
    }
end

function Pay.PayAuction(item, moneyBid, moneyIsBuyout, typeAuction)
    if item == nil or moneyBid == nil or moneyIsBuyout == nil or typeAuction == nil then return end

    Pay.Current = {
        Item = item,
        Type = typeAuction,
        Bid = moneyBid,
        Buy = item.buyoutPrice,
        Currency = item.moneyMode,
    }

    if moneyIsBuyout then
        if item.buyoutPrice > GetPlayerMoney(item.moneyMode) then
            StaticPopup_Show("BUYOUT_ALERT")
        else
            if item.moneyMode == "account" then
                StaticPopup_Show("AAH_BUYOUT_PASSWORD", item.name)
            else
                StaticPopup_Show("AAH_BUYOUT_NORMAL", item.name)
            end
        end
    else
        if moneyBid > GetPlayerMoney(item.moneyMode) then
            StaticPopup_Show("BUYOUT_ALERT")
        else
            if item.moneyMode == "account" then
                StaticPopup_Show("AAH_BID_PASSWORD", item.name);
            else
                if moneyBid >= AAH_SavedSettings.BidAlertLimit then
                    StaticPopup_Show("AAH_BID_NORMAL", item.name)
                else
                    Pay.BidItem(typeAuction, item.auctionid, moneyBid)
                end
            end
        end
    end
end

function Pay.BidItem(typeAuction, auctionID, moneyBid, pass)
    if typeAuction == Pay.AuctionType.Browse then
        AuctionBrowseBuyItem(auctionID, moneyBid, pass)
    elseif typeAuction == Pay.AuctionType.Bid then
        AuctionBidBuyItem(auctionID, moneyBid, pass)
    end
end

function Pay.BuyItem(typeAuction, auctionID, pass)
    if typeAuction == Pay.AuctionType.Browse then
        AAH.Browse.BuyoutEvent = true
        AuctionBrowseBuyItem(auctionID, nil, pass)
    elseif typeAuction == Pay.AuctionType.Bid then
        AuctionBidBuyItem(auctionID, nil, pass)
    end
end

Pay.InitPopups()