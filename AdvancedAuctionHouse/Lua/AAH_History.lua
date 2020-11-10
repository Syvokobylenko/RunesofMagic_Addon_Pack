local History = {
    PriceHistoryQueue={},

	TooltipHeight = 0,
	TooltipWidth = 0,
	Processing = true,

    ItemMaxDisplay = 10,
    AutoPriceHistoryTrigger=false,

    BrowseItemLink = nil,
    BrowseHistoryTrigger = false,
    PriceHistoryProcessed = true,
	
	FilterPassed = {},
	FilterAVG = nil,
}
AAH.History = History

AAH_SavedHistoryTable = {}

local function Trim(str)
	return string.match(str, "^%s*(.-)%s*$")
end

local function ToNum(str)
	local n = tonumber(string.match(str, "[%d%.]+"))
	if not n then
		n = tonumber(string.match(str, "%d+%.%d+"))
	end
	return n or 0
end

History.KeyFinderTable = { -- resolve strings in tooltips to their types
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

local function DontSaveHistory(itemid)
	if not AAH_SavedSettings.HistoryMaxSaved[itemid] then return false end
    return (AAH_SavedSettings.HistoryMaxSaved[itemid] <= 10)
end

function History.Init()

    local build = (AAH_SavedHistoryTable._TABLEBUILD or 0)

    -- for people switching from release to alpha
    if build > 500 and build < 20121119130745 then
        History.MinimizeHistory()
		build = AAH.Manifest.Build
	end

    local build = (AAH_SavedHistoryTable._TABLEBUILD or 0)
	if build < 20121120211541 then
		build = AAH.Manifest.Build
	end

    AAH_SavedHistoryTable._TABLEBUILD = build
	SaveVariables("AAH_SavedHistoryTable")

    History.SetMaxDefaultEntries(AAH_SavedSettings.HistoryMaxSavedDefault)
end

function History.SetMaxDefaultEntries(max)
	if max < AAH.Settings.HistoryMin then max = AAH.Settings.HistoryMin end
    if max > AAH.Settings.HistoryMax then max = AAH.Settings.HistoryMax end

	AAH_SavedSettings.HistoryMaxSavedDefault = max
end

function History.SetMaxEntries(max)
	if max < AAH.Settings.HistoryMin then max = AAH.Settings.HistoryMin end
    if max > AAH.Settings.HistoryMax then max = AAH.Settings.HistoryMax end
	AAH_SavedSettings.HistoryMaxSaved[History.curItem] = max
	AAH.History.UpdateHistoryEntries()
	if not AAH_HistoryList:IsVisible() then return end
	AAH_HistoryMaxNumHistoryEditBox:SetText(max)
	History.List_Show()
end

function History.Reset()
    AAH_SavedHistoryTable = {}
end

function History.RemoveItem(itemid)
    if AAH_SavedHistoryTable[itemid] then
		AAH_SavedHistoryTable[itemid] = nil
        return true
    end
end

function History.RequestHistoryPopup(auctionid,itemid)
    History.Processing = false
    History.curItem = itemid
    if auctionid then
        AuctionBrowseHistoryRequest(auctionid)
    else
        AuctionItemHistoryRequest()
    end
end

function History.UpdateSellItemHistory(itemid)
    History.AutoPriceHistoryTrigger = true
    History.curItem = itemid
    AuctionItemHistoryRequest()
end

function AAH.Events.AUCTION_HISTORY_SHOW()
    if History.AutoPriceHistoryTrigger == true then
		History.AutoPriceHistoryTrigger = false
		History.Queue_AddHistory(History.curItem)
		AAH.Sell.AutoFillPriceFields()
		return
	elseif History.BrowseHistoryTrigger == true then
		History.BrowseHistoryTrigger = false
		History.Queue_AddHistory(History.curBrowseItem)
		History.PriceHistoryProcessed = true
		return
	else
		History.Queue_AddHistory(History.curItem)
		History.List_Show()
	end
end

function AAH.Events.AUCTION_HISTORY_HIDE()
	History.PriceHistoryProcessed = true
	if not History.Processing then
		SendSystemMsg(AAHLocale.Messages.HISTORY_NO_DATA, true)
	end
end

----------------------------------
function History.ClearQueue()
	History.BrowseHistoryTrigger = false
	History.PriceHistoryProcessed = true
	History.Processing = true
	History.AutoPriceHistoryTrigger = false
    History.PriceHistoryQueue={}
end

function History.Queue_Insertitem(auctionid,name,link,itemid)
    if auctionid and name then

        for _, v in ipairs(History.PriceHistoryQueue) do
            if v.itemid == itemid then
                return
            end
        end

        local queueItem = {}
        queueItem.name = name
        queueItem.auctionid = auctionid
        queueItem.link = link
        queueItem.itemid = itemid
        table.insert(History.PriceHistoryQueue, queueItem)
    end
end

function History.Queue_Process()
    if #(History.PriceHistoryQueue) > 0 then
		if History.PriceHistoryProcessed then
			local queueItem = table.remove(History.PriceHistoryQueue)
			if queueItem and queueItem.auctionid ~= nil and queueItem.link ~= nil then
				History.PriceHistoryProcessed = false
				History.BrowseHistoryTrigger = true
                History.curBrowseItem = queueItem.itemid
				AuctionBrowseHistoryRequest(queueItem.auctionid)
			end
		end
	end
end

local function recalcSummary(itemid)
    local history = AAH_SavedHistoryTable[itemid]

    local totalcost = 0
    local totalcount = 0
    history.avg = 0
    history.median = 0
    history.min=0
    history.max=0
    if #history.history<=0 then
        return
    end

    local ppu = history.history[1].price / (history.history[1].count or 1)
    history.min = ppu
    history.max = ppu

    local all_ppu = {}
    for _,dat in ipairs(history.history) do
        local ppu = dat.price / (dat.count or 1)
        if history.min > ppu then
            history.min = ppu
        end
        if history.max < ppu then
            history.max = ppu
        end
        table.insert(all_ppu, ppu)
        totalcost = totalcost + dat.price
        totalcount = totalcount + (dat.count or 1)
    end

    table.sort(all_ppu)
    local mid = #(all_ppu) / 2 + 0.5
    history.median = (all_ppu[math.floor(mid)] + all_ppu[math.ceil(mid)]) / 2
    history.avg = totalcost / totalcount

    if itemid==200000 then
        history.avg = 1/history.avg
        history.min = 1/history.min
        history.max = 1/history.max
        history.median = 1/history.median
    end
end

local function GetHistoryFilterSummary(itemid)
    local history = AAH_SavedHistoryTable[itemid]

    local totalcost = 0
    local totalcount = 0
    if not history or not history.history or #history.history<=0 then
        return
    end

    local Minima = nil
    local Maxima = nil

    local all_ppu = {}
    for i,dat in ipairs(history.history) do
		if History.FilterPassed[i] then
			local ppu = dat.price / (dat.count or 1)
			if Minima == nil or Minima > ppu then
				Minima = ppu
			end
			if Maxima == nil or Maxima < ppu then
				Maxima = ppu
			end
			table.insert(all_ppu, ppu)
			totalcost = totalcost + dat.price
			totalcount = totalcount + (dat.count or 1)
		end
	end
	
	if not next(all_ppu) or not Minima or not Maxima then return 0,0,0,0 end
	
    table.sort(all_ppu)
    local mid = #(all_ppu) / 2 + 0.5
    local Median = (all_ppu[math.floor(mid)] + all_ppu[math.ceil(mid)]) / 2
    local AVG = totalcost / totalcount

    if itemid==200000 then
        AVG = 1/history.avg
        Minima = 1/history.min
        Maxima = 1/history.max
        Median = 1/history.median
    end
	return Minima,Maxima,Median,AVG
end

local function getAuctionHistoryInfo(itemid, index)
    local e={}
    local month,day,hour,minute
    e.name, e.count, e.rarity, e.icon, e.seller, e.buyer, _, e.price, month,day,hour,minute = GetAuctionHistoryItemInfo(index)

    if itemid==200000 or itemid==200003 then
        e.count = tonumber(string.match(string.gsub(e.name, "%"..COMMA, ""), "%d*") or "1") or 1
        e.name = TEXT("Sys"..itemid.."_name")
    end

    local hash = ""
    hash = hash.. month
    hash = hash.. day
    hash = hash.. hour
    hash = hash.. minute
    hash = hash.. e.count
    hash = hash.. e.seller
    hash = hash.. e.buyer
    hash = hash.. e.price

    e.date = string.format("%02d/%02d %02d:%02d", month,day,hour,minute)
    e.ppu = e.price / e.count
    if itemid==200000 then e.ppu = 1/e.ppu end

    return e, hash
end

local function getAuctionHistoryFromHistory(itemid, index)

    local base = AAH_SavedHistoryTable[itemid]

    local e={}

    for k,v in pairs(base.history[index]) do e[k]=v end
    e.count = e.count or 1
    e.rarity = e.rarity or base.rarity
    e.icon = e.icon or base.icon

    e.ppu = e.price / e.count
    if itemid==200000 then e.ppu = 1/e.ppu end

    return e
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

	local key1 = History.KeyFinderTable[prefix]
	local key2 = History.KeyFinderTable[suffix]
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
    History.KeyFinderTable[listing.name.." +"] = "plus"
    ResetAttributes(listing)
    AAH_HistoryFilterTooltip:Hide()
	GameTooltip1:Hide()
	GameTooltip2:Hide()

    local left, leftVis, right, rightVis

    for i = 1, 40 do
        leftVis = getglobal("AAH_HistoryFilterTooltipTextLeft"..i):IsVisible()
        rightVis = getglobal("AAH_HistoryFilterTooltipTextRight"..i):IsVisible()
        if not leftVis and not rightVis then
            break
        end

        left = getglobal("AAH_HistoryFilterTooltipTextLeft"..i):GetText()
        if left and left ~= "" and leftVis then
	        ParseLine(listing, left)
        end
        right = getglobal("AAH_HistoryFilterTooltipTextRight"..i):GetText()
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

function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

function History.Queue_AddHistory(itemid)
	if not History.PriceHistoryProcessed and itemid ~= History.curBrowseItem then return end
	local maxnums = GetAuctionHistoryItemNums()

	local startplace = 1
    if AAH_SavedHistoryTable[itemid] then
        for i = maxnums, 1, -1 do
            local _, hash = getAuctionHistoryInfo(itemid, i)
            if hash == AAH_SavedHistoryTable[itemid].hash then
                startplace = i + 1
                break
            end
        end
    else
        AAH_SavedHistoryTable[itemid] = {}
        _,_,AAH_SavedHistoryTable[itemid].rarity,
            AAH_SavedHistoryTable[itemid].icon = GetAuctionHistoryItemInfo(1)
        AAH_SavedHistoryTable[itemid].avg = 0
        AAH_SavedHistoryTable[itemid].history = {}
    end

    AAH_SavedHistoryTable[itemid].history = AAH_SavedHistoryTable[itemid].history or {}
    local history = AAH_SavedHistoryTable[itemid].history
    for i = startplace, maxnums do
        local entry,hash = getAuctionHistoryInfo(itemid, i)
		AAH_HistoryTooltip:SetHistoryItem(i)
		entry.lineleft = {}
		entry.lineright = {}
		entry.colorleftR = {}
		entry.colorleftG = {}
		entry.colorleftB = {}
		entry.colorrightR = {}
		entry.colorrightG = {}
		entry.colorrightB = {}
		for s = 1,40 do
			local LeftVis = _G["AAH_HistoryTooltipTextLeft"..s]:IsVisible()
			local RightVis = _G["AAH_HistoryTooltipTextRight"..s]:IsVisible()
			if not LeftVis and not RightVis then break end
			local LineLeft = _G["AAH_HistoryTooltipTextLeft"..s]:GetText()
			local LineRight = _G["AAH_HistoryTooltipTextRight"..s]:GetText()
			local ColorLeftR,ColorLeftG,ColorLeftB = nil,nil,nil
			local ColorRightR,ColorRightG,ColorRightB = nil,nil,nil
			if LeftVis and LineLeft and LineLeft ~= "" then 
				ColorLeftR,ColorLeftG,ColorLeftB = _G["AAH_HistoryTooltipTextLeft"..s]:GetColor() 
				entry.lineleft[s] = LineLeft
				entry.colorleftR[s] = ColorLeftR
				entry.colorleftG[s] = ColorLeftG
				entry.colorleftB[s] = ColorLeftB
			end
			if RightVis and LineRight and LineRight ~= "" then 
				ColorRightR,ColorRightG,ColorRightB = _G["AAH_HistoryTooltipTextRight"..s]:GetColor() 
				entry.lineright[s] = LineRight
				entry.colorrightR[s] = ColorRightR
				entry.colorrightG[s]= ColorRightG
				entry.colorrightB[s] = ColorRightB
			end
		end
        -- clean up
        entry.name=nil
        entry.ppu=nil
        if entry.count==1 then entry.count = nil end
        if entry.rarity==AAH_SavedHistoryTable[itemid].rarity then entry.rarity = nil end
        if entry.icon==AAH_SavedHistoryTable[itemid].icon then entry.icon = nil end

		if not AAH_SavedSettings.HistoryMaxSaved[itemid] and itemid == 202845 then AAH_SavedSettings.HistoryMaxSaved[itemid] = 1000 end
		AAH_SavedSettings.HistoryMaxSaved[itemid] = AAH_SavedSettings.HistoryMaxSaved[itemid] or AAH_SavedSettings.HistoryMaxSavedDefault or 10
        while #history > AAH_SavedSettings.HistoryMaxSaved[itemid] do
            table.remove(history, #history)
        end
        table.insert(history, 1, entry)
        AAH_SavedHistoryTable[itemid].hash = hash
    end

	AAH_HistoryTooltip:Hide()
	GameTooltip1:Hide()
	GameTooltip2:Hide()

    recalcSummary(itemid)

    if DontSaveHistory(itemid) then
        AAH_SavedHistoryTable[itemid].hash = nil
        if #history<10 then
            AAH_SavedHistoryTable[itemid].history_count = #history
        else
            AAH_SavedHistoryTable[itemid].history_count = nil
        end
        AAH_SavedHistoryTable[itemid].history = nil
    end
end
----------------------------------
function History.MinimizeHistory()

    local base={["history"]=1,["hash"]=1,["max"]=1,["min"]=1,["median"]=1,["avg"]=1,["rarity"]=1,["icon"]=1}
    local sub={["count"]=1,["date"]=1,["price"]=1,["buyer"]=1,["seller"]=1,["rarity"]=1,["icon"]=1,["count"]=1}


    for id, h in pairs(AAH_SavedHistoryTable) do
        if id~="_TABLEBUILD" then
            h.hash = string.gsub(h.hash,"^"..h.name,"")
            h.totalcount=nil
            h.totalcost=nil
            h.name=nil

            local found=true
            while found do
                found=false
                for k,v in pairs(h) do
                    if type(k)=="number" then
                        h[k]=nil
                        found = true
                    end
                end
            end


            for _, ent in ipairs(h.history) do
                ent.name=nil
                ent.realname=nil
                ent.moneymode=nil
                ent.ppu=nil
                if ent.count==1 then ent.count = nil end

                if not h.rarity then h.rarity = ent.rarity end
                if not h.icon then h.icon = ent.icon end
                if ent.rarity==h.rarity then ent.rarity = nil end
                if ent.icon==h.icon then ent.icon = nil end

                for k,v in pairs(ent) do
                    if not sub[k] then
                        AAHDebug("OBSOLETE-SUB?: "..k)
                        sub[k]=1
                    end
                end
            end

            for k,v in pairs(h) do
                if not base[k] then
                    AAHDebug("OBSOLETE-BASE?: "..k)
                    base[k]=1
                end
            end
        end
    end
end

function History.UpdateHistoryEntries()

    if DontSaveHistory(History.curItem) then
        for id, h in pairs(AAH_SavedHistoryTable) do
            if id~="_TABLEBUILD" then
                h.hash = nil
                h.history_count = nil
                if h.history and #h.history<10 then
                    h.history_count = #h.history
                end
                h.history = nil
            end
        end
    else
        for id, h in pairs(AAH_SavedHistoryTable) do
            if id~="_TABLEBUILD" then
                while h.history and #h.history > AAH_SavedSettings.HistoryMaxSaved[History.curItem] do
                    table.remove(h.history, #h.history)
                end
            end
        end
    end

end

----------------------------------
function History.List_Show()

    local itemid = History.curItem
	local white = AAH.Tools.GetWhiteValue(itemid)

    if (itemid == 200000) then
        AAH_HistoryHeaderPPU:SetText(AAHLocale.Messages.GENERAL_UNITS_PER_PRICE_HEADER)
    else
        AAH_HistoryHeaderPPU:SetText(AAHLocale.Messages.GENERAL_PRICE_PER_UNIT_HEADER)
    end

    local base = AAH_SavedHistoryTable[itemid]

    local numhistory = base.history and #(base.history) or GetAuctionHistoryItemNums()
    if numhistory == 0 then
        SendSystemMsg("no history available") -- TODO: localize
        AAH_HistoryList:Hide()
        return
    end


    local summary = AAHLocale.Messages.HISTORY_SUMMARY_MINMAX
    summary = string.gsub(summary, "<MINIMUM>", "|cffffd200"..AAH.Tools.FormatNumber(base.min / white).."|r")
    summary = string.gsub(summary, "<MAXIMUM>", "|cffffd200"..AAH.Tools.FormatNumber(base.max / white).."|r")
    AAH_HistoryMinMaxLabel:SetText(summary)

    local summary = AAHLocale.Messages.HISTORY_SUMMARY_AVERAGE
    summary = string.gsub(summary, "<MEDIAN>", "|cffffd200"..AAH.Tools.FormatNumber(base.median / white).."|r")
    summary = string.gsub(summary, "<AVERAGE>", "|cffffd200"..AAH.Tools.FormatNumber(base.avg / white).."|r")
    AAH_HistoryAverageLabel:SetText(summary)

    local summary = AAHLocale.Messages.HISTORY_SUMMARY_NUMHISTORY
    summary = string.gsub(summary, "<NUMHISTORY>", numhistory)
    AAH_HistoryNumHistoryLabel:SetText(summary)

    local maxvalue = numhistory - History.ItemMaxDisplay
    if maxvalue > 0 then
        AAH_HistoryListScrollBar:SetMinMaxValues(0, maxvalue)
        AAH_HistoryListScrollBar:Show()
    else
        AAH_HistoryListScrollBar:SetMinMaxValues(0, 0)
        AAH_HistoryListScrollBar:Hide()
    end
	History.List_FilterItems()
    History.List_UpdateItems()
    AAH_HistoryList:Show()
end

function History.List_FilterItems()
	History.FilterPassed = {}
	History.FilterAVG = nil
	
	local itemid = History.curItem
	local base = AAH_SavedHistoryTable[itemid]
	if not base or not base.history or #(base.history) <= 0 then return end
	local numhistory = base.history and #(base.history) or GetAuctionHistoryItemNums()
	local white = AAH.Tools.GetWhiteValue(itemid)
	
	local PassedCounter = 0
	for index = 1, numhistory do
		AAH_HistoryFilterTooltip:ClearLines()
		for s = 1,40 do
			_G["AAH_HistoryFilterTooltipTextLeft"..s]:SetText()
			_G["AAH_HistoryFilterTooltipTextRight"..s]:SetText()
		end
		local name = ""
		local level = 0
		for s = 1,40 do
			local LineLeft,LineRight = nil,nil
			if AAH_SavedHistoryTable[itemid] and AAH_SavedHistoryTable[itemid].history 
					and AAH_SavedHistoryTable[itemid].history[index] 
					and AAH_SavedHistoryTable[itemid].history[index].lineleft 
					and AAH_SavedHistoryTable[itemid].history[index].lineleft[s] then
				LineLeft = AAH_SavedHistoryTable[itemid].history[index].lineleft[s]
				if s == 1 then name = LineLeft end
				if string.find(LineLeft, TEXT("PET_LEVEL").."%d+") then level = tonumber(string.match(LineLeft, "%d+")) end
			end
			if AAH_SavedHistoryTable[itemid] and AAH_SavedHistoryTable[itemid].history 
					and AAH_SavedHistoryTable[itemid].history[index] 
					and AAH_SavedHistoryTable[itemid].history[index].lineright 
					and AAH_SavedHistoryTable[itemid].history[index].lineright[s] then
				LineRight = AAH_SavedHistoryTable[itemid].history[index].lineright[s]
			end
			if LineLeft or LineRight then 
				local ColorLeftR,ColorLeftG,ColorLeftB = nil,nil,nil
				local ColorRightR,ColorRightG,ColorRightB = nil,nil,nil
				if LineLeft then
					ColorLeftR = AAH_SavedHistoryTable[itemid].history[index].colorleftR[s]
					ColorLeftG = AAH_SavedHistoryTable[itemid].history[index].colorleftG[s]
					ColorLeftB = AAH_SavedHistoryTable[itemid].history[index].colorleftB[s]	
				end
				if LineRight then
					ColorRightR = AAH_SavedHistoryTable[itemid].history[index].colorrightR[s]
					ColorRightG = AAH_SavedHistoryTable[itemid].history[index].colorrightG[s]
					ColorRightB = AAH_SavedHistoryTable[itemid].history[index].colorrightB[s]
				end
				AAH_HistoryFilterTooltip:AddDoubleLine(LineLeft,LineRight,ColorLeftR,ColorLeftG,ColorLeftB,ColorRightR,ColorRightG,ColorRightB)
				AAH_HistoryFilterTooltip:Show()
			end
		end
		local count
		local rarity
		local texture
		local buyoutPrice
		if AAH_SavedHistoryTable[itemid] then
			if AAH_SavedHistoryTable[itemid].history and AAH_SavedHistoryTable[itemid].history[index] then
				count = AAH_SavedHistoryTable[itemid].history[index].count or 1
				buyoutPrice = AAH_SavedHistoryTable[itemid].history[index].price or 0
			end
			rarity = AAH_SavedHistoryTable[itemid].rarity or 0
			texture = AAH_SavedHistoryTable[itemid].icon or nil
		end
		if index <= GetAuctionHistoryItemNums() then
			e = getAuctionHistoryInfo(itemid, 1+GetAuctionHistoryItemNums()-index)
        else
			e = getAuctionHistoryFromHistory(itemid, index)
        end
		local listing = {
			auctionid = nil,
			itemid = itemid,
			link = nil,
			name = name,
			count = count,
			rarity = rarity,
			texture = texture,
			level = level,
			levelcolor = NORMAL_FONT_COLOR_CODE,
			leftTime = nil,
			seller = nil,
			isBuyer = true,
			moneyMode = nil,
			bidPrice = buyoutPrice,
			buyoutPrice = buyoutPrice,
			buyppu = e.ppu / white,
		}
		AAH.Filters.Tooltip = "AAH_HistoryFilterTooltip"
		ParseToolTip(listing)
		if AAH.Filters.CheckFilter(listing) then 
			PassedCounter = PassedCounter + 1
			History.FilterPassed[index] = true
		end
		AAH.Filters.Tooltip = "AAH_Tooltip"
	end
	
	local NewNumHistory = PassedCounter
	if not next(History.FilterPassed) then 
		History.FilterPassed[0] = true
		NewNumHistory = 0
	end
	local maxvalue = NewNumHistory - History.ItemMaxDisplay
	if maxvalue > 0 then
        AAH_HistoryListScrollBar:SetMinMaxValues(0, maxvalue)
        AAH_HistoryListScrollBar:Show()
    else
        AAH_HistoryListScrollBar:SetMinMaxValues(0, 0)
        AAH_HistoryListScrollBar:Hide()
    end
	
	local Minima,Maxima,Median,AVG = GetHistoryFilterSummary(itemid)
	History.FilterAVG = AVG
	
	local summary = AAHLocale.Messages.HISTORY_SUMMARY_MINMAX
    summary = string.gsub(summary, "<MINIMUM>", "|cffffd200"..AAH.Tools.FormatNumber(Minima / white).."|r")
    summary = string.gsub(summary, "<MAXIMUM>", "|cffffd200"..AAH.Tools.FormatNumber(Maxima / white).."|r")
    AAH_HistoryMinMaxLabel:SetText(summary)

    local summary = AAHLocale.Messages.HISTORY_SUMMARY_AVERAGE
    summary = string.gsub(summary, "<MEDIAN>", "|cffffd200"..AAH.Tools.FormatNumber(Median / white).."|r")
    summary = string.gsub(summary, "<AVERAGE>", "|cffffd200"..AAH.Tools.FormatNumber(AVG / white).."|r")
    AAH_HistoryAverageLabel:SetText(summary)

    local summary = AAHLocale.Messages.HISTORY_SUMMARY_NUMHISTORY
    summary = string.gsub(summary, "<NUMHISTORY>", NewNumHistory)
    AAH_HistoryNumHistoryLabel:SetText(summary)
end

function History.List_UpdateItems()

    local itemid = History.curItem
	local name,_,_,_,_,_,moneymode = GetAuctionHistoryItemInfo(1)
	local white = AAH.Tools.GetWhiteValue(itemid)

	local hidecount = false
	local inversecoloring = false

    if itemid==200000 or itemid==200003 then
        name =TEXT("Sys"..itemid.."_name")
        hidecount = true
	    inversecoloring = (itemid==200000)
    end

    local base = AAH_SavedHistoryTable[itemid]
    local numhistory = base.history and #(base.history) or GetAuctionHistoryItemNums()
    local first_line = AAH_HistoryListScrollBar:GetValue()
	local FilterFound = {}
	local NewIndex = nil

    for i = 1, History.ItemMaxDisplay do
        local index = NewIndex or (first_line+i)
        local frame_name = "AAH_HistoryListItem"..i
        if index <= numhistory then

            local e
			if next(History.FilterPassed) then
				while not History.FilterPassed[index] do
					if index == numhistory then
						for h = 1, History.ItemMaxDisplay do
							if not FilterFound[h] then _G["AAH_HistoryListItem"..h]:Hide() end
						end
						return 
					end
					index = index + 1
				end
				FilterFound[i] = true
				NewIndex = index + 1
			end
            if index <= GetAuctionHistoryItemNums() then
                e = getAuctionHistoryInfo(itemid, 1+GetAuctionHistoryItemNums()-index)
            else
                e = getAuctionHistoryFromHistory(itemid, index)
            end

            local button = _G[frame_name.."Icon"]
            button.index = index
            SetItemButtonTexture(button, e.icon)

            local item_name = name or "???"
            if hidecount then
                item_name = string.format("%s %s",AAH.Tools.FormatNumber(e.count),name)
                SetItemButtonCount(button, 0)
            else
                SetItemButtonCount(button, e.count)
            end

            if index <= GetAuctionHistoryItemNums() or (AAH_SavedHistoryTable[itemid] and AAH_SavedHistoryTable[itemid].history 
					and AAH_SavedHistoryTable[itemid].history[index] and AAH_SavedHistoryTable[itemid].history[index].lineleft) then
                _G[button:GetName().."Red"]:Hide()
            else
                _G[button:GetName().."Red"]:Show()
            end

            local r, g, b = GetItemQualityColor(e.rarity)
            _G[frame_name.."Name"]:SetText(item_name)
            _G[frame_name.."Name"]:SetColor(r, g, b)
            _G[frame_name.."DateText"]:SetText(e.date)
            _G[frame_name.."SellerText"]:SetText(e.seller)
            _G[frame_name.."BuyerText"]:SetText(e.buyer)
            _G[frame_name.."PPU"]:SetText(AAH.Tools.FormatNumber(e.ppu / white))
            _G[frame_name.."PPU"]:SetColor(1,1,1)
			local AVG = History.FilterAVG or base.avg
            AAH.Tools.GetAvgPriceColor(e.ppu, AVG, frame_name.."PPU", inversecoloring)
            MoneyFrame_Update(frame_name.."Price", e.price, moneymode)

            _G[frame_name]:Show()
        else
            _G[frame_name]:Hide()
        end
    end
end

function History.List_OnClose()
    History.BrowseItemLink = nil
    History.Processing = true
end


----------------------------------
function History.GetAveragePrice(itemid)
    return AAH_SavedHistoryTable[itemid] and AAH_SavedHistoryTable[itemid].avg
end

function History.GetPriceStatistic(itemid)
    local data = AAH_SavedHistoryTable[itemid]
    if not data then return end

    return data.avg, data.min, data.max, data.median
end

function AAH.ToolsShowPriceHistoryTooltip(tooltip, itemid)
	local tempString = ""
	local white = AAH.Tools.GetWhiteValue(itemid)
	AAH_PriceHistoryTooltip:SetText(AAHLocale.Messages.TOOLS_PRICE_HISTORY, 0, 0.75, 0.95)
	AAH_PriceHistoryTooltip:AddDoubleLine(AAHLocale.Messages.TOOLS_POWERED_BY, "", 0, 0.75, 0.95)

    local history = AAH_SavedHistoryTable[itemid]

	if history then
		local numhistory = history.history and #(history.history) or (history.history_count or 10)
		if numhistory > 0 then
			AAH_PriceHistoryTooltip:AddLine(" ")
			tempString = "|cffffd200"..AAH.Tools.FormatNumber(history.avg / white).."|r"
			AAH_PriceHistoryTooltip:AddDoubleLine(AAHLocale.Messages.GENERAL_AVERAGE_PRICE_PER_UNIT, tempString)
			tempString = "|cffffd200"..AAH.Tools.FormatNumber(history.median / white).."|r"
			AAH_PriceHistoryTooltip:AddDoubleLine(AAHLocale.Messages.GENERAL_MEDIAN_PRICE_PER_UNIT, tempString)
			tempString = string.gsub(AAHLocale.Messages.TOOLS_GOLD_BASED, "<SCANNED>", numhistory)
			AAH_PriceHistoryTooltip:AddDoubleLine(tempString)
		end
	else
		AAH_PriceHistoryTooltip:AddLine(" ")
		AAH_PriceHistoryTooltip:AddLine(AAHLocale.Messages.TOOLS_NO_HISTORY_DATA)
	end

	History.TooltipWidth = AAH_PriceHistoryTooltip:GetWidth()
	History.TooltipHeight = AAH_PriceHistoryTooltip:GetHeight()
	AAH_PriceHistoryTooltip:Show()
end

function AAH.ToolsPriceHistoryTooltip_OnUpdate(tooltip, elapsedTime)
	if ((not GameTooltip:IsVisible()) and HistoryForGameTooltip) or
        ((not GameTooltipHyperLink:IsVisible()) and HistoryForGameTooltipHyperLink) or
        ((not GameTooltip:IsVisible()) and (not GameTooltipHyperLink:IsVisible())) then
		tooltip:Hide()
	else
		if HistoryForGameTooltip then
			tooltip:ClearAllAnchors()
			tooltip:SetAnchor("TOPLEFT", "BOTTOMLEFT", GameTooltip, 0, 0)
		elseif HistoryForGameTooltipHyperLink then
			tooltip:ClearAllAnchors()
			tooltip:SetAnchor("TOPLEFT", "BOTTOMLEFT", GameTooltipHyperLink, 0, 0)
		end
		tooltip:SetWidth(History.TooltipWidth)
		tooltip:SetHeight(History.TooltipHeight)
	end
end

