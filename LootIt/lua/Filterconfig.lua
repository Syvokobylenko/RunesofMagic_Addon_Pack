-- last changes     by: Tinsus     at: 2016-05-14T21:07:19Z     project-version: v1.9beta1     hash: d2d6114d2a6a120e5fa0b078751b054961b81628

local LI = _G.LI

LI.LastResult = "false"

function LI.Filterchecker(filtername, value, name, roll, star, quality)
	filtername = string.gsub(filtername, "&", "µ&µ")
	filtername = string.gsub(filtername, "%[", "µ%(µ")
	filtername = string.gsub(filtername, "%]", "µ%)µ")
	filtername = string.gsub(filtername, "%%", "µ%%µ")

	filtername = string.gsub(filtername, "<", "µ<µ")
	filtername = string.gsub(filtername, ">", "µ>µ")
	filtername = string.gsub(filtername, "=", "µ=µ")
	filtername = string.gsub(filtername, "~", "µ~µ")

	filtername = string.gsub(filtername, "=µµ=", "==")
	filtername = string.gsub(filtername, "~µµ=", "~=")
	filtername = string.gsub(filtername, "<µµ=", "<=")
	filtername = string.gsub(filtername, ">µµ=", ">=")
	filtername = string.gsub(filtername, "=µµ<", "<=")
	filtername = string.gsub(filtername, "=µµ>", ">=")
	filtername = string.gsub(filtername, "µ=µ", "µ==µ")
	filtername = string.gsub(filtername, "µ ", "µ")
	filtername = string.gsub(filtername, " µ", "µ")

	local filters = LI.explode("µ", filtername)

	local results = {}
	local pattern = {"*", "^%$", "^!", "^§"}

	for i, filter in ipairs(filters) do
		local result = nil

		if filter == "&" then
			result = "and"

		elseif filter == "%" then
			result = "or"

		elseif filter == "(" or filter == ")" or filter == "" or filter == "~=" or filter == "<" or filter == ">" or filter == "==" or filter == "<=" or filter == ">=" or string.find(filter, "^%d+") then
			result = filter
		else
			if string.find(filter, "^|") then
				table.insert(results, "not")

				filter = string.sub(filter, 2)
			end

			local nopat = true

			for j, pat in ipairs(pattern) do
				if string.find(filter, pat) then
					nopat = false

					result = LI["Filterchecker"..j](filter, value, name, roll, quality)

					if result then
						break
					end
				end
			end

			if nopat then
				result = filter == name
			end
		end

		table.insert(results, tostring(result))
	end

	LI.LastResult = table.concat(results, " ")

	if string.find(LI.LastResult, "nil") then
		return LI.Log(LI.LastResult)
	else
		results = loadstring("return "..LI.LastResult)
	end

	if not results or not results() then
		return
	end

	if not roll then
		return value[1], value[3]
	else
		return value[2]
	end
end

function LI.Filterchecker1(filtername, value, name, roll, quality)
	local allok = false

	if not string.find(filtername, "%%") and not string.find(filtername, "%[") then
		filtername = string.gsub(filtername, "%-", "%%-")
		filtername = string.gsub(filtername, ":", ".")
	end

	if string.find(filtername, "^%$") then
		if not LI.Filterchecker2(filtername, value, name, roll, quality) then
			return
		end

	elseif string.find(filtername, "^!") then
		if not LI.Filterchecker3(filtername, value, name, roll, quality) then
			return
		end
	else
		allok = true

		if not string.find(filtername, "%%") and not string.find(filtername, "%[") then
			filtername = string.gsub(filtername, "%-", "%%-")
			filtername = string.gsub(filtername, ":", ".")
		end

		filtername = string.gsub(filtername, "*", "%.+")


		if not string.find(name or "", "^"..filtername.."$") then
			allok = false
		end
	end

	return allok
end

function LI.Filterchecker2(filtername, value, name, roll, quality)
	filtername = string.sub(filtername, 2)
	filtername = string.gsub(filtername, "*", "%.+")

	local allok = false
	local long = {}

	for i = 1, 20 do
		table.insert(long, getglobal("LootIt_GameTooltipTextLeft"..i):GetText())
		table.insert(long, getglobal("LootIt_GameTooltipTextRight"..i):GetText())
	end

	if string.find(filtername, "^%$") then
		filtername = string.sub(filtername, 2)
	end

	if string.find(filtername, "^!") then
		if not LI.Filterchecker3(filtername, value, name, roll, quality) then
			return
		end
	else
		if not string.find(filtername, "%%") and not string.find(filtername, "%[") then
			filtername = string.gsub(filtername, "%-", "%%-")
			filtername = string.gsub(filtername, ":", ".")
		end

		for _, fil in ipairs(long) do
			fil = string.gsub(fil, "|r", "")
			fil = string.gsub(fil, "|c........", "")

			if string.find(fil, "^"..filtername.."$") then
				allok = true
			end
		end
	end

	return allok
end

LI.MasterPara = {
	["dura"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["gold"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["charlevel"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["itemlevel"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = true,
	},
	["stacks"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = true,
	},
	["bstacks"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = true,
	},
	["bbstacks"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = true,
	},
	["count"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = true,
	},
	["bcount"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = true,
	},
	["bbcount"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = true,
	},
	["stats"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["quality"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["usedslots"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["usedbslots"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["usedbbslots"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["freeslots"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["freebslots"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
	["freebbslots"] = {
		["min"] = true,
		["max"] = true,
		["para"] = true,
		["name"] = false,
	},
}

function LI.Filterchecker3(filtername, value, name, roll, quality)
	filtername = string.sub(filtername, 2)
	quality = quality or 0

	if string.find(filtername, "^!") then
		filtername = string.sub(filtername, 2)
	end

	local allok = false

	if string.find(filtername, "^guild") then
		if GetGuildInfo() ~= nil and string.find(filtername, tostring(GetGuildInfo())) then
			allok = true
		end

	elseif string.find(filtername, "^zone") then
		if string.len(filtername) >= 8 and string.find(string.lower(GetZoneLocalName(GetCurrentWorldMapID()) or TEXT("ZONE_DEFAULT")), string.lower(string.sub(filtername, 6) or "")) then
			allok = true
		end

	elseif string.find(filtername, "^#") then
		for _, check in ipairs(LI.explode(";", tostring(LI_Data.Options.hashtag))) do
			if check == string.sub(filtername, 2) then
				allok = true

				break
			end
		end

	elseif filtername == TEXT("ITEM_QUALITY"..quality.."_DESC") then
		allok = true

	elseif filtername == TEXT("GENERAL") and quality == 0 then
		allok = true

	elseif filtername == UnitClass("player") then
		allok = true

	elseif string.find(filtername, "^%$") then
		if LI.Filterchecker2(filtername, value, name, roll, quality) then
			allok = true
		end

	else
		for lname, lvalue in pairs(LI.MasterPara) do
			if string.find(filtername, "^..."..lname) then
				local dname = ""

				if lvalue.name then
					dname, numend = string.find(filtername, "%d+")

					if numend then
						dname = " "..string.sub(filtername, numend + 2)
					else
						dname = " nil"
					end
				end


				local converted = LI.Filterchecker4("§"..lname..dname, value, name, roll, quality)

				if not converted then
					return false
				end

				if string.find(filtername, "min") then
					converted = converted..">="
				else
					converted = converted.."<"
				end

				allok = converted..tostring(tonumber(string.match(filtername, "%d+")))

				break
			end
		end
	end

	return allok
end

function LI.Filterchecker4(filtername, value, name, roll, quality)
	quality = quality or 0
	filtername = string.sub(filtername, 3)

	local allok = false

	if string.find(filtername, "^dura") then
		for i = 1, 20 do
			local text = getglobal("LootIt_GameTooltipTextRight"..i):GetText()

			if string.find(text, TEXT("SYS_ITEM_DURABLE")) then
				allok = tonumber(string.match(text, "%d+"))

				break
			end
		end

	elseif string.find(filtername, "^gold") then
		allok = LI.GetPriceByName(name)

		if not allok then
			allok = 0
		end

	elseif string.find(filtername, "^charlevel") then
		allok = UnitLevel("player")

	elseif string.find(filtername, "^itemlevel") then
		for i = 1, 20 do
			local text = getglobal("LootIt_GameTooltipTextLeft"..i):GetText()

			if string.find(text, string.gsub(TEXT("TOOLTIP_LIMIT_TEXT"), ":", ".")) and string.find(text, TEXT("TOOLTIPS_LIMIT_LEVEL")) then
				local item = tonumber(string.match(text, "%d+"))

				if item then
					allok = item

					break
				end
			end
		end

		if not allok then
			allok = 0
		end

	elseif string.find(filtername, "^stacks") then
		local name, numend = string.find(filtername, " ")

		if numend then
			name = string.sub(filtername, numend + 1)
		else
			name = nil
		end

		if name then
			allok = 0

			for j = 1, BAG_MAX_ITEMS_PAGE do
				local isLet, letTime = GetBagPageLetTime(j)

				if not letTime or letTime > 0 then
					for i = (j - 1) * BAG_MAX_ITEMS + 1, j * BAG_MAX_ITEMS do
						local _, _, sname = GetBagItemInfo(i)

						if string.lower(name) == string.lower(sname) then
							allok = allok + 1
						end
					end
				end
			end
		end

	elseif string.find(filtername, "^bstacks") then
		local name, numend = string.find(filtername, " ")

		if numend then
			name = string.sub(filtername, numend + 1)
		else
			name = nil
		end

		if name then
			allok = 0

			for i = 1, BANK_MAX_LINE_ITEMS do
				local isLet = TimeLet_GetLetTime("BankBag"..(i))

				if not letTime or letTime > 0 then
					for j = 1, BANK_MAX_DISPLAY_ITEMS do
						local _, sname = GetBankItemInfo((j - 1) + (i - 1) * BANK_MAX_DISPLAY_ITEMS)

						if sname and string.lower(name) == string.lower(sname) then
							allok = allok + 1
						end
					end
				end
			end
		end

	elseif string.find(filtername, "^bbstacks") then
		local name, numend = string.find(filtername, " ")

		if numend then
			name = string.sub(filtername, numend + 1)
		else
			name = nil
		end

		if name then
			allok = 0

			for j = 1, BAG_MAX_ITEMS_PAGE do
				local isLet, letTime = GetBagPageLetTime(j)

				if not letTime or letTime > 0 then
					for i = (j - 1) * BAG_MAX_ITEMS + 1, j * BAG_MAX_ITEMS do
						local _, _, sname = GetBagItemInfo(i)

						if string.lower(name) == string.lower(sname) then
							allok = allok + 1
						end
					end
				end
			end

			for i = 1, BANK_MAX_LINE_ITEMS do
				local isLet = TimeLet_GetLetTime("BankBag"..(i))

				if not letTime or letTime > 0 then
					for j = 1, BANK_MAX_DISPLAY_ITEMS do
						local _, sname = GetBankItemInfo((j - 1) + (i - 1) * BANK_MAX_DISPLAY_ITEMS)

						if sname and string.lower(name) == string.lower(sname) then
							allok = allok + 1
						end
					end
				end
			end
		end

	elseif string.find(filtername, "^count") then
		local name, numend = string.find(filtername, " ")

		if numend then
			name = string.sub(filtername, numend + 1)
		else
			name = nil
		end

		if name then
			allok = GetCountInBagByName(name)
		end

	elseif string.find(filtername, "^bcount") then
		local name, numend = string.find(filtername, " ")

		if numend then
			name = string.sub(filtername, numend + 1)
		else
			name = nil
		end

		if name then
			allok = GetCountInBankByName(name)
		end

	elseif string.find(filtername, "^bbcount") then
		local name, numend = string.find(filtername, " ")

		if numend then
			name = string.sub(filtername, numend + 1)
		else
			name = nil
		end

		if name then
			allok = GetCountInBankByName(name) + GetCountInBagByName(name)
		end

	elseif string.find(filtername, "^stats") then
		local numstats = nil

		for i = 2, 30 do
			local textl = getglobal("LootIt_GameTooltipTextLeft"..i):GetText()
			local textr = getglobal("LootIt_GameTooltipTextRight"..i):GetText()

			if numstats == nil then
				if string.find(textl, string.gsub(TEXT("SYS_ITEM_COST"), ":", ".")) then
					numstats = 0
				end
			else
				if textr ~= nil and textr ~= "" then
					numstats = numstats + 1

				elseif string.find(textl, "%(%d+/%d+%)") then
					break
				end
			end
		end

		allok = numstats or 0

	elseif string.find(filtername, "^quality") then
		allok = quality

	elseif string.find(filtername, "^usedslots") then
		allok = GetBagCount()

	elseif string.find(filtername, "^freeslots") then
		local a, b = GetBagCount()

		allok = b - a

	elseif string.find(filtername, "^usedbslots") then
		allok = 0

		for i = 1, BANK_MAX_LINE_ITEMS * BANK_MAX_DISPLAY_ITEMS do
			local _, _, _, locked = GetBankItemInfo(i)

			if locked ~= nil then
				allok = allok + 1
			end
		end

	elseif string.find(filtername, "^freebslots") then
		allok = 0

		for i = 1, BANK_MAX_LINE_ITEMS * BANK_MAX_DISPLAY_ITEMS do
			local _, _, _, locked = GetBankItemInfo(i)

			if locked == nil then
				allok = allok + 1
			end
		end

		for i = 1, BANK_MAX_LINE_ITEMS do
			local isLet = TimeLet_GetLetTime("BankBag"..(i))

			if isLet and isLet == -1 then
				allok = allok - BANK_MAX_DISPLAY_ITEMS
			end
		end

	elseif string.find(filtername, "^usedbbslots") then
		allok = GetBagCount()

		for i = 1, BANK_MAX_LINE_ITEMS * BANK_MAX_DISPLAY_ITEMS do
			local _, _, _, locked = GetBankItemInfo(i)

			if locked ~= nil then
				allok = allok + 1
			end
		end

	elseif string.find(filtername, "^freebbslots") then
		local a, b = GetBagCount()

		allok = b - a

		for i = 1, BANK_MAX_LINE_ITEMS * BANK_MAX_DISPLAY_ITEMS do
			local _, _, _, locked = GetBankItemInfo(i)

			if locked == nil then
				allok = allok + 1
			end
		end

		for i = 1, BANK_MAX_LINE_ITEMS do
			local isLet = TimeLet_GetLetTime("BankBag"..(i))

			if isLet and isLet == -1 then
				allok = allok - BANK_MAX_DISPLAY_ITEMS
			end
		end
	end

	return allok
end
