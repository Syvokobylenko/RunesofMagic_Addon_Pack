--[[ Filter Creation Help --
	Filter function will have 2 tables for parameters.
	First table is param and it is a table of what was entered into the filterbox.
		example filter: $bob/hello/13//46///en
		param = {
			[1] = "bob",
			[2] = "hello",
			[3] = "13",
			[4] = "",
			[5] = "46",
			[6] = "",
			[7] = "",
			[8] = "en",
		}
		only param[1] is needed, all others are optional for the filter
	Second Table is a table of info for that auction entry
		listing.name = string,				--name of the item
		listing.itemid = number,			--itemID number
		listing.count = number,				--stack size
		listing.rarity = number,			--rarity level (0=white, 1=green, etc.)
		listing.level = number,				--item level as listed in the level column
		listing.levelcolor = string,		--color hex code for the level, yellow if using game value, green if overriden with different value
		listing.leftTime = number,			--time left in minutes, not exact number, seems to round up by the tens slot (1234 will be 1240)
		listing.bidPrice = number,			--the estimated price to bid on the item
		listing.bidppu = number,			--bidPrice / count
		listing.buyoutPrice = number,		--the price to buyout the auction
		listing.buyppu = number,			--buyoutPrice / count
		listing.seller = string,			--name of the seller
		listing.isBuyer = boolean,			--true if you are the current highest bidder
		listing.texture = string,			--location of the item's icon texture file
		listing.auctionid = number,			--ID number used to buy the auction
		listing.tier = number				--Tier
		listing.plus = number				--Plus
		listing.dura = number				--Max Durability
		listing.worth = number				--Vendor Value
		listing.mdam = number				--Magical Damage
		listing.pdam = number				--Physical Damage
		listing.speed = number				--Attack Speed
		listing.dps = number				--DPS
		listing.sta = number				--Stamina
		listing.str = number				--Strength
		listing.dex = number				--Dexterity
		listing.wis = number				--Wisdom
		listing.int = number				--Intelligence
		listing.hp = number					--Maximum HP
		listing.mp = number					--Maximum MP
		listing.patt = number				--Physical Attack
		listing.matt = number				--Magical Attack
		listing.pdef = number				--Physical Defense
		listing.mdef = number				--Magical Defense
		listing.pcrit = number				--Physical Crit Rate
		listing.mcrit = number				--Magical Crit Rate
		listing.pacc = number				--Physical Accuracy
		listing.macc = number				--Magical Accuracy
		listing.pdod = number				--Physical Dodge Rate
		listing.parry = number				--Parry Rate
		listing.heal = number				--Healing Bonus
	Your function will look something like ...
		function FilterForBob(param, listing)
			--test for true
			return true
			--else
			return false
		end
	To register your filter use 1 of the 2 following methods in your VARIABLES_LOADED event
		AAH.Filters.Register({coms = <comma seperated string of commands>, func = <your function name without the (param, listing)>, desc = <your filter description string; optional>, })
	OR
		local filter = {
			coms = <comma seperated string of commands>,
			func = <your function name without the (param, listing)>,
			desc = <your filter description string; optional>,
		}
		AAH.Filters.Register(filter)
	Examples
		if AdvancedAuctionHouse then
			AAH.Filters.Register({coms = "$bob,$bobby,$robert", func = FilterForBob, desc = "This is a test filter"})
		end
	OR
		if AdvancedAuctionHouse then
			local filter = {
				coms = "$bob,$bobby,$robert",
				func = FilterForBob,
				desc = "Just another test",
			}
			AAH.Filters.Register(filter)
		end
]]

local Filters = {
	Registered = {},
	List = {},
	Tooltip = "AAH_Tooltip",
}
AAH.Filters = Filters


function Filters.Empty() return true end

function Filters.Register(entry)
	if type(entry) == "table" and type(entry.func) == "function" and type(entry.coms) == "string" then
		table.insert(Filters.List, { coms = entry.coms, desc = entry.desc or "---" })
		if entry.coms ~= "-" then
			entry.coms = entry.coms..","
			for com in string.gmatch(entry.coms, "\$(.-),") do
				Filters.Registered[com] = entry.func
				--AAHDebug("$"..com.." initialized")
	        end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("Invalid Filter setup")
    end
end
-- 3rd Party interaction (old)
AAH.FiltersRegister = Filters.Register

function Filters.Zero(param, listing)--Search for items with a 0 Stats
	return Filters.Count(param, listing, 0)
end
Filters.Register({coms = AAHLocale.Commands.ZERO, func = Filters.Zero, desc = AAHLocale.Messages.COMMAND_ZERO_DESCRIPTION})

function Filters.One(param, listing)--Search for items with a 1 Stat
	return Filters.Count(param, listing, 1)
end
Filters.Register({coms = AAHLocale.Commands.ONE, func = Filters.One, desc = AAHLocale.Messages.COMMAND_ONE_DESCRIPTION})

function Filters.Two(param, listing)--Search for items with a 2 Stats
	return Filters.Count(param, listing, 2)
end
Filters.Register({coms = AAHLocale.Commands.TWO, func = Filters.Two, desc = AAHLocale.Messages.COMMAND_TWO_DESCRIPTION})

function Filters.Three(param, listing)--Search for items with a 3 Stats
	return Filters.Count(param, listing, 3)
end
Filters.Register({coms = AAHLocale.Commands.THREE, func = Filters.Three, desc = AAHLocale.Messages.COMMAND_THREE_DESCRIPTION})

function Filters.Four(param, listing)--Search for items with a 4 Stats
	return Filters.Count(param, listing, 4)
end
Filters.Register({coms = AAHLocale.Commands.FOUR, func = Filters.Four, desc = AAHLocale.Messages.COMMAND_FOUR_DESCRIPTION})

function Filters.Five(param, listing)--Search for items with a 5 Stats
	return Filters.Count(param, listing, 5)
end
Filters.Register({coms = AAHLocale.Commands.FIVE, func = Filters.Five, desc = AAHLocale.Messages.COMMAND_FIVE_DESCRIPTION})

function Filters.Six(param, listing)--Search for items with a 6 Stats
	return Filters.Count(param, listing, 6)
end
Filters.Register({coms = AAHLocale.Commands.SIX, func = Filters.Six, desc = AAHLocale.Messages.COMMAND_SIX_DESCRIPTION})

Filters.Register({coms = "-", func = Filters.Empty})

function Filters.Green(param, listing, color)
	if color then
		return "green"
	else
		return Filters.Color(param, listing, "green")
	end
end
Filters.Register({coms = AAHLocale.Commands.GREEN, func = Filters.Green, desc = AAHLocale.Messages.COMMAND_GREEN_DESCRIPTION})

function Filters.Yellow(param, listing, color)
	if color then
		return "yellow"
	else
		return Filters.Color(param, listing, "yellow")
	end
end
Filters.Register({coms = AAHLocale.Commands.YELLOW, func = Filters.Yellow, desc = AAHLocale.Messages.COMMAND_YELLOW_DESCRIPTION})

function Filters.Orange(param, listing, color)
	if color then
		return "orange"
	else
		return Filters.Color(param, listing, "orange")
	end
end
Filters.Register({coms = AAHLocale.Commands.ORANGE, func = Filters.Orange, desc = AAHLocale.Messages.COMMAND_ORANGE_DESCRIPTION})

Filters.Register({coms = "-", func = Filters.Empty})

function Filters.Color(param, listing, color)--Search for green, yellow, or orange stats
	local left, right, found
	for i = 3, 40 do
		if getglobal(Filters.Tooltip.."TextLeft"..i):IsVisible() and getglobal(Filters.Tooltip.."TextRight"..i):IsVisible() then
			left = getglobal(Filters.Tooltip.."TextLeft"..i):GetText()
			right = getglobal(Filters.Tooltip.."TextRight"..i):GetText()
			if left and left ~= "" and right and right ~= "" then
				found = AAH.Tools.FindColorType(getglobal(Filters.Tooltip.."TextLeft"..i):GetColor())
				if found == color then
					return true
				elseif AAH.Tools.FindColorType(r, g, b) == "rune" then
					return false
				end
			end
		end
	end
	return false
end

function Filters.Count(param, listing, count)-- Search for # of colored stats
	local statCount = 0
	local colorinverse = false
	local color = nil
	if param[2] then
		if string.sub(param[2],1,1) == "!" then
			param[2] = string.sub(param[2],2)
			colorinverse = true
		end
		if string.sub(param[2],1,1) == "$" then
			param[2] = string.sub(param[2],2)
		end
		if Filters.Registered[param[2]] then
			color = Filters.Registered[param[2]](param, listing, true)
			if color ~= "green" and color ~= "yellow" and color ~= "orange" then
				color = nil
			end
		end
	end
	local left, right, found
	for i = 3, 40 do
		if getglobal(Filters.Tooltip.."TextLeft"..i):IsVisible() and getglobal(Filters.Tooltip.."TextRight"..i):IsVisible() then
			left = getglobal(Filters.Tooltip.."TextLeft"..i):GetText()
			right = getglobal(Filters.Tooltip.."TextRight"..i):GetText()
			if left and left ~= "" and right and right ~= "" and not string.match(left, TEXT("SYS_TOOLTIP_RUNE_LEVEL")) then
				found = AAH.Tools.FindColorType(getglobal(Filters.Tooltip.."TextLeft"..i):GetColor())
				if found == "rune" then
					break
				elseif found ~= "green" and found ~= "yellow" and found ~= "orange" then
					--ignore
				elseif color then
					if colorinverse then
						if found ~= color then
							statCount = statCount + 1
						elseif found == color then
							statCount = -1
							break
						end
					else
						if found == color then
							statCount = statCount + 1
						elseif found ~= color then
							statCount = -1
							break
						end
					end
				else
					statCount = statCount + 1
				end
			end
		end
	end
	if count == statCount and listing.name ~= "" then
		return true
	end
	return false
end

function Filters.Tier(param, listing)--Search for items with a minimum tier
	local value = 1
	if param[2] then
		value = tonumber(string.match(param[2], "%d+")) or 1
	end
	if listing.tier >= value then
		return true
	end
	return false
end
Filters.Register({coms = AAHLocale.Commands.TIER, func = Filters.Tier, desc = AAHLocale.Messages.COMMAND_TIER_DESCRIPTION})

function Filters.Plus(param, listing)--Search for items with a minimum plus
	local value = 1
	if param[2] then
		value = tonumber(string.match(param[2], "%d+")) or 1
	end
	if listing.plus >= value then
		return true
	end
	return false
end
Filters.Register({coms = AAHLocale.Commands.PLUS, func = Filters.Plus, desc = AAHLocale.Messages.COMMAND_PLUS_DESCRIPTION})

function Filters.Dura(param, listing)--Search for items with durability >= 101 (high dura)
	local value = 101
	if param[2] then
		value = tonumber(string.match(param[2], "%d+")) or 101
	end
	if listing.dura >= value then
		return true
	end
	return false
end
Filters.Register({coms = AAHLocale.Commands.DURA, func = Filters.Dura, desc = AAHLocale.Messages.COMMAND_DURA_DESCRIPTION})

Filters.Register({coms = "-", func = Filters.Empty})

function Filters.EggLevel(param, listing)--Search for Pet Eggs with a minimum Level
	if AAH.Data.PetEggs[listing.itemid] then
		local value = 1
		if param[2] then
			value = tonumber(string.match(param[2], "%d+")) or 1
		end
		if listing.level >= value then
			return true
		end
	end
	return false
end
Filters.Register({coms = AAHLocale.Commands.EGGLEVEL, func = Filters.EggLevel, desc = AAHLocale.Messages.COMMAND_EGGLEVEL_DESCRIPTION})

function Filters.EggAptitude(param, listing)--Search for Pet Eggs with a minimum Aptitude
	local left
	local value = 1
	if param[2] then
		value = tonumber(string.match(param[2], "%d+")) or 1
	end
	if AAH.Data.PetEggs[listing.itemid] then
		for i = 3, 40 do
			left = getglobal(Filters.Tooltip.."TextLeft"..i):GetText()
			if left ~= nil and getglobal(Filters.Tooltip.."TextLeft"..i):IsVisible() then
				if string.find(left, TEXT("PET_TOOLTIP_TALENT").."%d+") then
					if tonumber(string.match(left, "%d+")) >= value then
						return true
					end
				end
			end
		end
	end
	return false
end
Filters.Register({coms = AAHLocale.Commands.EGGAPTITUDE, func = Filters.EggAptitude, desc = AAHLocale.Messages.COMMAND_EGGAPTITUDE_DESCRIPTION})

Filters.Register({coms = "-", func = Filters.Empty})

function Filters.Vendor(param, listing)--Search for items that can be vendored for a profit
	if listing.isBuyer or listing.worth == 0 then
		return false
	end
	local minprofit = 1
	if param[2] then
		minprofit = tonumber(string.match(param[2], "%d+")) or 1
	end
	local maxtime = 4320
	if param[3] then
		maxtime = tonumber(string.match(param[3], "%d+")) or 4320
	end
	if listing.worth > listing.buyppu and listing.buyppu > 0 then
		return true
	elseif listing.worth - listing.bidppu >= minprofit and listing.leftTime <= maxtime then
		return true
	end
	return false
end
Filters.Register({coms = AAHLocale.Commands.VENDOR, func = Filters.Vendor, desc = AAHLocale.Messages.COMMAND_VENDOR_DESCRIPTION})

function Filters.Bargain(param, listing)--Search for items that can be reauctioned for a profit
    if listing.isBuyer then return false end

    local avgcost = AAH.History.GetAveragePrice(listing.itemid)
	if not avgcost then return false end

	local percent = .7
	if param[2] then
		percent = 1 - (tonumber(string.match(param[2], "%d+")) / 100) or .7
	end
	local maxtime = 4320
	if param[3] then
		maxtime = tonumber(string.match(param[3], "%d+")) or 4320
	end
	if avgcost * percent >= listing.bidppu and maxtime >= listing.leftTime then
		return true
	elseif avgcost * percent >= listing.buyppu and listing.buyppu > 0 then
		return true
	end
	return false
end
Filters.Register({coms = AAHLocale.Commands.BARGAIN, func = Filters.Bargain, desc = AAHLocale.Messages.COMMAND_BARGAIN_DESCRIPTION})

Filters.Register({coms = "-", func = Filters.Empty})

function Filters.CheckFilter(listing)
	local filter1 = false
	local filter2 = false
	local filter3 = false
	local filtertrue = false
	local filter1Phrase = AAH_BrowseFilter1EditBox:GetText()
	local filter2Phrase = AAH_BrowseFilter2EditBox:GetText()
	local filter3Phrase = AAH_BrowseFilter3EditBox:GetText()
	local or2 = AAH_BrowseFilter2OrButton:IsChecked()
	local or3 = AAH_BrowseFilter3OrButton:IsChecked()
	local filterminprice = AAH_BrowseFilterMinPriceEditBox:GetNumber()
	local filtermaxprice = AAH_BrowseFilterMaxPriceEditBox:GetNumber()
	local filterppu = AAH_BrowseFilterPPUButton:IsChecked()
	local filterbid = AAH_BrowseFilterBidButton:IsChecked()
	_G[Filters.Tooltip]:SetHyperLink(listing.link)
	_G[Filters.Tooltip]:Hide()
	GameTooltip1:Hide()
	GameTooltip2:Hide()
	if filter1Phrase ~= "" then
		if string.sub(filter1Phrase, 1, 1) == "!" then
			if string.len(filter1Phrase) > 1 then
				filter1 = not(Filters.SearchInTooltip(string.sub(filter1Phrase, 2), listing))
			else
				filter1 = true
			end
		else
			filter1 = Filters.SearchInTooltip(filter1Phrase, listing)
		end
	else
		filter1 = true
	end
	if filter2Phrase ~= "" then
		if string.sub(filter2Phrase, 1, 1) == "!" then
			if string.len(filter2Phrase) > 1 then
				filter2 = not(Filters.SearchInTooltip(string.sub(filter2Phrase, 2), listing))
			else
				filter2 = true
			end
		else
			filter2 = Filters.SearchInTooltip(filter2Phrase, listing)
		end
	else
		filter2 = true
	end
	if filter3Phrase ~= "" then
		if string.sub(filter3Phrase, 1, 1) == "!" then
			if string.len(filter3Phrase) > 1 then
				filter3 = not(Filters.SearchInTooltip(string.sub(filter3Phrase, 2), listing))
			else
				filter3 = true
			end
		else
			filter3 = Filters.SearchInTooltip(filter3Phrase, listing)
		end
	else
		filter3 = true
	end
	if or2 and or3 then
		filtertrue = (filter1 or filter2 or filter3)
	elseif or2 and (not or3) then
		filtertrue = ((filter1 or filter2) and filter3)
	elseif (not or2) and or3 then
		filtertrue = ((filter1 and filter2) or filter3)
	else
		filtertrue = (filter1 and filter2 and filter3)
	end
	if not filtertrue then
		return false
	end
	if filterminprice and filterminprice > 0 then
		if filterppu and filterbid and listing.bidppu < filterminprice then
			return false
		elseif filterppu and not filterbid and listing.buyppu < filterminprice then
			return false
		elseif not filterppu and filterbid and listing.bidPrice < filterminprice then
			return false
		elseif not filterppu and not filterbid and listing.buyoutPrice < filterminprice then
			return false
		end
	end
	if filtermaxprice and filtermaxprice > 0 then
		if filterppu and filterbid and listing.bidppu > filtermaxprice and listing.bidppu > 0 then
			return false
		elseif filterppu and not filterbid and listing.buyppu > filtermaxprice and listing.buyppu > 0 then
			return false
		elseif not filterppu and filterbid and listing.bidPrice > filtermaxprice and listing.bidPrice > 0 then
			return false
		elseif not filterppu and not filterbid and listing.buyoutPrice > filtermaxprice and listing.buyoutPrice > 0 then
			return false
		end
	end
	return true
end

function Filters.SearchInTooltip(searchString, listing)
	local lowerString = AAH.Tools.StringLower(string.gsub(searchString, "-", "%%-"))
	local text
	if string.sub(lowerString, 1, 1) == "$" then
		lowerString = lowerString.."/"
		local strlen = string.len(lowerString)
		local param = {}
		local loc1, loc2 = 2, 0
		repeat
			loc2 = string.find(lowerString, "/", loc1)
			table.insert(param, string.sub(lowerString, loc1, loc2 - 1))
			loc1 = loc2 + 1
		until loc1 > strlen
		if Filters.Registered[param[1]] then
			return Filters.Registered[param[1]](param, listing)
		end
	else
		for i = 1, 40 do
			--Search for text in left sides
			text = getglobal(Filters.Tooltip.."TextLeft"..i):GetText()
			if text ~= nil and getglobal(Filters.Tooltip.."TextLeft"..i):IsVisible() then
				if string.find(AAH.Tools.StringLower(text), lowerString) then
					return true
				end
			end
			--Search for text in right sides
			text = getglobal(Filters.Tooltip.."TextRight"..i):GetText()
			if text ~= nil and getglobal(Filters.Tooltip.."TextRight"..i):IsVisible() then
				if string.find(AAH.Tools.StringLower(text), lowerString) then
					return true
				end
			end
		end
	end
	return false
end

AAH.FiltersSearchInTooltip=Filters.SearchInTooltip -- 3rd party interaction (yacit)
