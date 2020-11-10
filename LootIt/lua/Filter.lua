-- last changes     by: Tinsus     at: 2016-05-14T21:30:14Z     project-version: v1.9beta1     hash: f30a38f389cb5b3b884202c11ccc3bf2437ff751

local LI = _G.LI

function LI.ResetCache()
	LI_FilterCache = nil
	LI_ResultCache = nil
end

function LI.AddButton(this)
	local itemname = getglobal(this:GetParent():GetName().."_Itemname"):GetText()
	local loot = UIDropDownMenu_GetText(getglobal(this:GetParent():GetName().."_Looting"))
	local roll = UIDropDownMenu_GetText(getglobal(this:GetParent():GetName().."_Rolling"))
	local allchars = IsCtrlKeyDown()

	loot = LI.ConvertStringToID(tostring(loot) or LI.Trans("MANUAL"), false)
	roll = LI.ConvertStringToID(tostring(roll) or LI.Trans("MANUAL"), true)

	LI.AddData(itemname, loot, roll, allchars)

	getglobal(this:GetParent():GetName().."_Itemname"):SetText("")
	UIDropDownMenu_SetText(getglobal(this:GetParent():GetName().."_Looting"), LI.Trans("LOOT"))
	UIDropDownMenu_SetText(getglobal(this:GetParent():GetName().."_Rolling"), LI.Trans("ROLL"))
end

function LI.DelButton(this)
	local itemname = getglobal(this:GetParent():GetName().."_Itemname"):GetText()

	LI.DelData(itemname)

	getglobal(this:GetParent():GetName().."_Itemname"):SetText("")
	UIDropDownMenu_SetText(getglobal(this:GetParent():GetName().."_Looting"), LI.Trans("LOOT"))
	UIDropDownMenu_SetText(getglobal(this:GetParent():GetName().."_Rolling"), LI.Trans("ROLL"))
end

function LI.AddData(itemname, loot, roll, allchars, silent, stack)
	if LI_Data.Options.readonly then
		LI.io("READONLY_WARNING")

		return
	end

	if tostring(itemname) == nil or string.len(itemname) <= 3 or string.find(itemname, "^!") then
		if string.find(itemname, "^!") then
			local bool = true
			local old = string.match(itemname, ".+ ")

			if old then
				old = string.sub(old, 1, string.len(old))

				for name in pairs(LI_FilterCharSpezial) do
					if string.match(name, old) and math.abs(string.len(name) - string.len(old)) < 2 then
						LI.DelData(name, true)

						bool = false

						break
					end
				end

				if bool then
					for name in pairs(LI_FilterAllSpezial) do
						if string.match(name, old) and math.abs(string.len(name) - string.len(old)) < 2 then
							LI.DelData(name, true)

							break
						end
					end
				end
			end
		else
			LI.DelData(itemname, true)

			return
		end
	end

	while string.find(itemname, " $") do
		itemname = string.sub(itemname, 1, string.len(itemname) - 1)
	end

	local old = LI_FilterAll[itemname] or LI_FilterChar[itemname] or LI_FilterAllSpezial[itemname] or LI_FilterCharSpezial[itemname]

	if old then
		loot = tonumber(loot) or old[1]
		roll = tonumber(roll) or old[2]
		stack = tonumber(stack) or old[3]
	else
		loot = tonumber(loot) or 3
		roll = tonumber(roll) or 1
		stack = tonumber(stack) or 0
	end

	LI.DelData(itemname, true)

	if LI.CheckForNormal(itemname) then
		if allchars then
			LI_FilterAll[itemname] = {loot, roll, stack}
		else
			LI_FilterChar[itemname] = {loot, roll, stack}
		end
	else
		if allchars then
			LI_FilterAllSpezial[itemname] = {loot, roll, stack}
		else
			LI_FilterCharSpezial[itemname] = {loot, roll, stack}
		end
	end

	LI.ResetCache()

	if LootIt_ItemFilter:IsVisible() then
		LI.PaintFilterFrame()
	end

	LI.intrunning = true

	LI.ScanFullBag()

	if silent then
		return
	end

	if LI_Data.Options.addmessage then
		local lootstring, rollstring

		lootstring = LI.ConvertIDToString(loot, false)
		rollstring = LI.ConvertIDToString(roll, true)

		LI.io(string.format(LI.Trans("ADDMESSAGE_ADD"), "|cffff0050"..itemname.."|r |cffffffff("..lootstring.." & "..rollstring..")|r"))
	end
end

function LI.DelData(itemname, silent)
	if LI_Data.Options.readonly then
		LI.io("READONLY_WARNING")

		return
	end

	if tostring(itemname) == nil then
		return
	end

	LI_FilterAll[itemname] = nil
	LI_FilterAllSpezial[itemname] = nil
	LI_FilterChar[itemname] = nil
	LI_FilterCharSpezial[itemname] = nil

	LI.ResetCache()

	if LootIt_ItemFilter:IsVisible() then
		LI.PaintFilterFrame()
	end

	if silent then
		return
	end

	if LI_Data.Options.addmessage then
		LI.io(string.format(LI.Trans("ADDMESSAGE_REMOVE"), "|cffff0050"..itemname.."|r"))
	end
end

function LI.CheckForNormal(filter)
	if string.find(filter, "*") or string.find(filter, "^%$") or string.find(filter, "^!") or string.find(filter, "^ยง") then
		return false
	end

	return true
end

function LI.PaintFilterFrame(filter)
	if LI_FilterCache == nil or filter then
		LI_FilterCache = {}

		for name, value in pairs(LI_FilterAll) do
			table.insert(LI_FilterCache, {name, value[1], value[2], value[3]})
		end

		for name, value in pairs(LI_FilterAllSpezial) do
			table.insert(LI_FilterCache, {name, value[1], value[2], value[3]})
		end

		for name, value in pairs(LI_FilterChar) do
			table.insert(LI_FilterCache, {name, value[1], value[2], value[3]})
		end

		for name, value in pairs(LI_FilterCharSpezial) do
			table.insert(LI_FilterCache, {name, value[1], value[2], value[3]})
		end

		local num = table.getn(LI_FilterCache)

		if filter and filter ~= "" and table.getn(LI_FilterCache) ~= 0 then
			local cache = LI_FilterCache

			LI_FilterCache = {}

			for _, val in ipairs(cache) do
				if string.find(val[1], filter) then
					table.insert(LI_FilterCache, val)
				end
			end

			num = table.getn(LI_FilterCache) - LI.NumVisbileFilters() + 1
		end

		local function comp(t1, t2)
			if string.lower(t1[1]) < string.lower(t2[1]) then
				return true
			else
				return false
			end
		end

   		table.sort(LI_FilterCache, comp)

		if num < 1 then
			num = 1
		end

		LootIt_ItemFilter_ScrollBar:SetMinMaxValues(1, num)
	end

	for i = 1, 34 do
		local num = LootIt_ItemFilter_ScrollBar:GetValue() + i - 1

		if LI_FilterCache[num] ~= nil and not (i > LI.NumVisbileFilters()) then
			local name = LI_FilterCache[num][1]

			if LI_FilterCache[num][4] and LI_FilterCache[num][4] ~= 0 then
				name = "{"..LI_FilterCache[num][4].."} "..name
			end

			getglobal("LootIt_ItemFilter_Filterlist_Item"..i):Show()
			getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Name"):SetText(name)
			getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Loot"):SetText(LI.ConvertIDToString(LI_FilterCache[num][2], false))
			getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Roll"):SetText(LI.ConvertIDToString(LI_FilterCache[num][3], true))

			if LI_FilterAll[LI_FilterCache[num][1]] or LI_FilterAllSpezial[LI_FilterCache[num][1]] then
				getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Name"):SetColor(0.5, 0.5, 0.5)
				getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Loot"):SetColor(0.5, 0.5, 0.5)
				getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Roll"):SetColor(0.5, 0.5, 0.5)
			else
				getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Name"):SetColor(1, 1, 1)
				getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Loot"):SetColor(1, 1, 1)
				getglobal("LootIt_ItemFilter_Filterlist_Item"..i.."_Roll"):SetColor(1, 1, 1)
			end
		else
			getglobal("LootIt_ItemFilter_Filterlist_Item"..i):Hide()
		end
	end
end

function LI.Search(this)
	if this:GetText() ~= "" then
		LI.PaintFilterFrame(this:GetText())
	else
		LI.PaintFilterFrame()
	end
end

function LI.FilterExplain(this)
	LI.GameTooltip(this, "ANCHOR_BOTTOMRIGHT", 4, 0, "EXPLAIN_FILTER1")

	GameTooltip:AddLine(LI.Trans("#EXPLAIN_FILTER2#\n|cffff0050"..TEXT("Sys203880_name").."|r\n#EXPLAIN_FILTER3#"))
	GameTooltip:AddLine(LI.Trans("\n#EXPLAIN_FILTER4#\n|cffff0050"..TEXT("LOGIN_DWARF").."*|r\n#EXPLAIN_FILTER5#"))
	GameTooltip:AddLine(LI.Trans("\n#EXPLAIN_FILTER6#\n|cffff0050$"..TEXT("Sys120157_name_plural").."|r\n#EXPLAIN_FILTER7#"))
	GameTooltip:AddLine(LI.Trans("\n#EXPLAIN_FILTER8#\n|cffff0050$"..string.format(TEXT("SYS_TOOLTIP_RUNE_LEVEL"), "2").."&$"..TEXT("Sys120157_name_plural").."|r\n#EXPLAIN_FILTER9#"))
	GameTooltip:AddLine(LI.Trans("#EXPLAIN_FILTER26#\n#EXPLAIN_FILTER27#"))

	GameTooltip2:SetOwner(GameTooltip, "ANCHOR_RIGHT", 0, 0)
	GameTooltip2:SetText("")

	GameTooltip2:AddLine(LI.Trans("EXPLAIN_FILTER10"))

	local filters = LI.GenerateCommunityHelp()

	for _, line in ipairs(filters) do
		if line == "Separator" then
			GameTooltip2:AddSeparator()
		elseif line == "SECTIONSIGN" then
			GameTooltip2:AddLine(string.format(LI.Trans("EXPLAIN_FILTER_PARALINE"), "!mincount 9 "..TEXT("Sys203880_name"), "§count "..TEXT("Sys203880_name").." <= 9"))
		else
			GameTooltip2:AddLine("|cffff0050"..line.."|r")
		end
	end

	GameTooltip:AddSeparator()

	GameTooltip2:AddLine(LI.Trans("\n#EXPLAIN_FILTER12#\n\n#EXPLAIN_5PLUS4#"))
	GameTooltip:AddLine(LI.Trans("EXPLAIN_PIPE").."\n|cff00ff00||r|cffff0050$"..TEXT("Sys120157_name_plural").."|r"..LI.Trans("\n#EXPLAIN_FILTER19#\n\n|cffff0000#EXPLAIN_FILTERWARNING#"))

	GameTooltip2:Show()
end

function LI.GenerateCommunityHelp(search)
	local filters = {}

	table.insert(filters, "!guild "..tostring(GetGuildInfo() or TEXT("UI_GUILDLISTBOARD_NAME")).." - "..TEXT("UI_GUILDLISTBOARD_NAME"))
	table.insert(filters, "!zone "..tostring(GetZoneLocalName(GetCurrentWorldMapID()) or TEXT("ZONE_DEFAULT")).." - "..LI.Trans("ZONENAME"))
	table.insert(filters, "!#"..tostring(LI_Data.Options.hashtag).." - "..LI.Trans("EXPLAIN_FILTER21"))

	table.insert(filters, "Separator")

	for i = 1, LI.QualityCount do
		table.insert(filters, "!"..LI.Trans(TEXT("ITEM_QUALITY"..i.."_DESC").." - "..string.format(LI.Trans("EXPLAIN_QUALITY"), LI.GetQualityString(i))))
	end

	table.insert(filters, "!"..LI.Trans(TEXT("GENERAL").." - "..string.format(LI.Trans("EXPLAIN_QUALITY"), LI.GetQualityString(0))))

	table.insert(filters, "Separator")

	for i = 1, 10 do
		table.insert(filters, "!"..TEXT("SUITSKILL_JOB"..i).." - "..LI.Trans("EXPLAIN_CLASS"))
	end

	table.insert(filters, "Separator")
	table.insert(filters, "SECTIONSIGN")

	if not search then
		for name, value in pairs(LI.MasterPara) do
			local str = ""

			if value.min then
				str = str.."|cffff00ff!min|r"

				if value.max or value.para then
					str = str.."|cffffffff/|r"
				end
			end

			if value.max then
				str = str.."|cffff00ff!max|r"

				if value.para then
					str = str.."|cffffffff/|r"
				end
			end

			if value.para then
				str = str.."|cffff00ff§|r"
			end

			str = str.."|cffff0050"..name

			if value.name then
				str = str.." "..LI.Trans("EXPLAIN_FILTER_NAME")
			end

			str = str.."|r|cffffffff - |r"
			str = str..LI.Trans("EXPLAIN_FILTER_"..string.upper(name))

			table.insert(filters, str)
		end
	else
		for name, value in pairs(LI.MasterPara) do
			if value.min then
				local str = " "..LI.Trans("EXPLAIN_FILTER_"..string.upper(name))

				str = " - "..LI.Trans("EXPLAIN_FILTER_MIN")..str

				if value.name then
					str = LI.Trans("EXPLAIN_FILTER_NAME")..str
				end

				table.insert(filters, "!min"..name.." X "..str)
			end

			if value.max then
				local str = " "..LI.Trans("EXPLAIN_FILTER_"..string.upper(name))

				str = " - "..LI.Trans("EXPLAIN_FILTER_MAX")..str

				if value.name then
					str = LI.Trans("EXPLAIN_FILTER_NAME")..str
				end

				table.insert(filters, "!max"..name.." X "..str)
			end

			if value.para then
				local str = " "..LI.Trans("EXPLAIN_FILTER_"..string.upper(name))

				str = " - "..LI.Trans("EXPLAIN_FILTER_PARA")..str

				if value.name then
					str = LI.Trans("EXPLAIN_FILTER_NAME")..str
				end

				table.insert(filters, "§"..name.." "..str)
			end
		end
	end

--	table.insert(filters, LI.Trans("#EXPLAIN_FILTER11#\n#EXPLAIN_FILTER13#\n#EXPLAIN_FILTER15#\n#EXPLAIN_FILTER16#\n#EXPLAIN_FILTER20#"))
--	table.insert(filters, LI.Trans("#EXPLAIN_FILTER17#\n#EXPLAIN_FILTER22#\n#EXPLAIN_FILTER23#"))
--	table.insert(filters, LI.Trans("#EXPLAIN_FILTER18#\n#EXPLAIN_FILTER24#\n#EXPLAIN_FILTER25#"))

	table.insert(filters, "Separator")

	table.insert(filters, LI.Trans("#EXPLAIN_FILTER14#"))

	return filters
end

function LI.NumVisbileFilters(this)
	local _, y = (this or LootIt_ItemFilter_ScrollBar):GetSize()

	return math.floor((y + 25) / 20) + 1
end

function LI.ConvertIDToString(ID, roll)
	local tab = {
		["true"] = {
			[1] = LI.Trans("MANUAL"),
			[2] = TEXT("SYS_GIVE_UP"),
			[3] = LI.GROUPLOOT_GREED,
			[4] = LI.GROUPLOOT_ROLL,
			[10]= LI.Trans("AUTOMASTER"),
			[11]= LI.Trans("DKP"),
		},
		["false"] = {
			[1] = LI.Trans("MANUAL"),
			[2] = LI.Trans("DISCARD"),
			[3] = LI.Trans("COLLECT"),
			[4] = LI.Trans("SPENDGUILD"),
		},
	}

	return tab[tostring(roll == true)][ID]
end

function LI.ConvertStringToID(String, roll)
	local tab = {
		["true"] = {
			[LI.Trans("MANUAL")] = 1,
			[TEXT("SYS_GIVE_UP")] = 2,
			[LI.GROUPLOOT_GREED] = 3,
			[LI.GROUPLOOT_ROLL] = 4,
			[LI.Trans("AUTOMASTER")] = 10,
			[LI.Trans("DKP")] = 11,
		},
		["false"] = {
			[LI.Trans("MANUAL")] = 1,
			[LI.Trans("DISCARD")] = 2,
			[LI.Trans("COLLECT")] = 3,
			[LI.Trans("SPENDGUILD")] = 4,
		},
	}

	return tab[tostring(roll == true)][String]
end

function LI.SelectFilterRow(this)
	getglobal(this:GetParent():GetParent():GetName().."_Itemname"):SetText(LI.RemoveSpezial(this))

	UIDropDownMenu_SetText(getglobal(this:GetParent():GetParent():GetName().."_Rolling"), getglobal(this:GetName().."_Roll"):GetText())
	UIDropDownMenu_SetText(getglobal(this:GetParent():GetParent():GetName().."_Looting"), getglobal(this:GetName().."_Loot"):GetText())

	LI.PaintFilterFrame()
end

function LI.RemoveSpezial(this)
	local name = getglobal(this:GetName().."_Name"):GetText()

	if string.find(name, "{") then
		local _, last = string.find(name, "}")

		name = string.sub(name, last + 2)
	end

	return name
end

function LI.HighlightShow(this)
	if this then
		this.timer = LI_Data.Options.delay
		this.updater = 0
	end
end

function LI.HighlightUpdate(this, elapsedTime)
	this.updater = this.updater + elapsedTime

	if this.updater >= 0.1 then
		elapsedTime = this.updater

		this.updater = 0
	else
		return
	end

	this.timer = this.timer - elapsedTime

	if this.timer <= 0 then
		RollOnLoot(this.lootIndex, this.roll, true)
		this:Hide()
	end

	local red, green, blue = LI.TrafficColor(this.timer)

	getglobal(this:GetName().."_Color"):SetColor(red, green, blue)
end

function LI.TrafficColor(time)
	local time, total = tonumber(time) or 1, LI_Data.Options.delay or 1
	local red, green, blue = 0, 0, 0

	green = time / total * 510

	red = 510 - green

	if green > 255 then
		green = 255
	end

	if red < 0 then
		red = 0
	end

	return red / 255, green / 255, blue / 255
end
