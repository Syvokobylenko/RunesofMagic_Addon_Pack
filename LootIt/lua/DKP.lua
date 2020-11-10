-- last changes     by: Tinsus     at: 2016-07-02T09:27:42Z     project-version: v1.9beta1     hash: eafe20edfe4fe4e78f770c249436eecdac101094

local LI = _G.LI

-- missing -> bossindent, posting dkps
--> reduce LI_DKP_own on bid and read it later...

LI.CurrentItems = {}
LI.CurrentDice = {}
LI.SendCache = {}
LI.NeedAssignment = {}

function LI.CountingDownDices()
	for name, value in ipairs(LI.NeedAssignment) do
		if LI.NeedAssignment[name]["timeout"] ~= nil then
			LI.NeedAssignment[name]["timeout"] = LI.NeedAssignment[name]["timeout"] - 1

			if LI.NeedAssignment[name]["timeout"] < 0 then
				LI.DiceResult(value.link)
			end
		end
	end
end

function LI.GroupItem(item)
	if LI.IsValidSystem() then
		local _, data = ParseHyperlink(item)
		local hexID, Adura, stat12, stat34, stat56 = string.match(data, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")

		local short = LI.BuildShortLink(hexID, Adura, stat12, stat34, stat56, item)

		if IsAssigner() then
			table.insert(LI.NeedAssignment, {link = item, count = GetNumPartyMembers() or GetNumRaidMembers(), timeout = 9})
			table.insert(LI.CheckForDicer, {item, short})
		end
	end
end

LI.CheckForDicer = {}

function LI.GroupAskItem(shortitem)
	if LI.IsValidSystem() then
		for i = 1, 6 do
			if not getglobal("LI_LootFrame"..i.."_Show"):IsVisible() then
				getglobal("LI_LootFrame"..i).link = LI.ShortLinks[shortitem]
				getglobal("LI_LootFrame"..i):Show()

				return
			end
		end

		table.insert(LI.CurrentItems, shortitem)
	end
end

function LI.CheckForDicers(item, short)
	local lootID, name
	local _, nameing = ParseHyperlink(item)

	nameing = TEXT("Sys"..LI.HexToDec(string.match(nameing, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")).."_name")

	local luckys, b = {"900"..short.."~"}, 0

	for i = 1, GetLootAssignItemSize() do
		lootID, name = GetLootAssignItemInfo(i)

		if name == nameing then
			b = b + 1
		end
	end

	if b > 1 then -- skipping items with the same name (already dicing)
		for key, value in ipairs(LI.NeedAssignment) do
			if value.link == item and LI.NeedAssignment[key]["dicetype"] ~= nil then

				return table.insert(LI.CheckForDicer, {item, short})
			end
		end
	end

	LI.ResetTooltip()
	LootIt_GameTooltip:SetHyperLink(item)

	if yaCIt then
		yaCIt.ShowTooltipBySelf(LootIt_GameTooltip)
	end

	local quality = LI.GetQuality(item)
	local result = LI_MasterFilterChar[name]

	if LI.Filterchecker("!"..TEXT("ITEM_QUALITY3_DESC").."&|$"..TEXT("SYS_WEAPON_POS04").."&|"..TEXT("Sys203606_name"), {false, true}, name, true, 3, quality) then
		LI.SendToWeb(6, nil, item)
	end

	if not result then
		for star = 1, 3 do
			for filtername, value in pairs(LI_MasterFilterCharSpezial) do
				result = LI.Filterchecker(filtername, {false, value}, name, true, star, quality)

				if result then
					break
				end
			end

			if result then
				break
			end
		end
	end

	if not result then
		if quality <= LI_Data.Options.automaster then
			result = 10
		end
	end

	if result == 10 or result == 11 then
		for i = 1, 36 do
			local allowed = GetLootAssignMember(lootID, i)
			local done = false

			for j = 1, 36 do
				if UnitName("raid"..j) == allowed then
					done = true

					if result == 11 then
						table.insert(luckys, 9)
					else
						table.insert(luckys, math.random(1, 8))
					end

					break
				end
			end

			if not done then
				table.insert(luckys, 0)
			end
		end

		LI.Send(table.concat(luckys))

		for key, value in ipairs(LI.NeedAssignment) do
			if value.link == item then
				LI.NeedAssignment[key]["dicetype"] = result

				break
			end
		end
	end
end

function LI.GroupItemGot(link, name)
	if LI.IsValidSystem() then
		local _, nameing = ParseHyperlink(link)
		local hexID, Adura, stat12, stat34, stat56 = string.match(nameing, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")
		local indent = hexID..string.sub(Adura, string.len(Adura) - 2, string.len(Adura))..stat12..stat34..stat56

		local found = false

		for i = 1, 6 do
			if getglobal("LI_LootFrame"..i.."_Show"):IsVisible() then
				if getglobal("LI_LootFrame"..i).link == link then
					found = i

					break
				else
					local _, nameing = ParseHyperlink(getglobal("LI_LootFrame"..i).link)
					local hexID, Adura, stat12, stat34, stat56 = string.match(nameing, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")

					if indent == hexID..string.sub(Adura, string.len(Adura) - 2, string.len(Adura))..stat12..stat34..stat56 then
						found = i

						break
					end
				end
			end
		end

		if found then
			getglobal("LI_LootFrame"..found):Hide()
		end
	end
end

function LI.LootFrame_OnHide(this)
	this.timeout = 300

	getglobal(this:GetName().."_Show").timeout = 0.5
end

function LI.ReShow_OnUpdate(this, elapsedTime)
	if this.timeout and elapsedTime then
		this.timeout = this.timeout - elapsedTime

		if this.timeout <= 0 then
			this:Hide()
		end
	end
end

function LI.ReShow_OnHide(this)
	this.timeout = nil

	if string.find(this:GetName(), "DKP") then
		if #LI.CurrentDKPItems ~= 0 then
			LI.GroupAskDKPItem()
		end
	else
		if #LI.CurrentItems ~= 0 then
			LI.GroupAskItem(table.remove(LI.CurrentItems))
		end
	end
end

function LI.LootFrame_OnUpdate(this, elapsedTime)
	this.timeout = this.timeout - elapsedTime

	if this.timeout <= 0 then
		LI.RollLoot(this, "pass", true)
	end
end

function LI.ManageDices(name, value)
	if name == UnitName("player") and #LI.CurrentDice > 0 then
		local val = table.remove(LI.CurrentDice)

		if val[2] == 3 then
			value = LI.CurrentDKPBid[val[1]]

			LI.CurrentDKPBid[val[1]] = nil
		end

		value = tostring(string.format("%x", value))

		if string.len(value) == 1 then
			value = "0"..value
		end

		if val[2] == 3 then
			value = value.."--"
		end

		value = val[2]..value..val[1]

		LI.Send(value)
	end
end

function LI.UseChat()
	if #LI.SendCache ~= 0 then
		local msg = ""

		repeat
			local val = table.remove(LI.SendCache)

			if (string.len(msg) + string.len(val) + 4) < 230 then
				msg = msg.."~"..val
			else
				table.insert(LI.SendCache, 1, val)

				break
			end
		until #LI.SendCache == 0

		LI.SendMsg(msg)
	end
end

function LI.Send(msg)
	if msg == "NoMoreValid" and not LI_invalid then
		LI_invalid = true

	elseif msg == "NoMoreValid" and LI_invalid then
		return
	end

	table.insert(LI.SendCache, msg)
end

function LI.SendMsg(msg)
	local key

	repeat
		key = math.random(0, 94)
	until key + 32 ~= 37 and key + 32 ~= 92 and key + 32 ~= 124 and LI.Decrypt(LI.Encrypt(msg, key), key) == msg

	if DC and DC.Hooked_SendChatMessage then
		DC.Hooked_SendChatMessage(LI.AddCheckSum(string.char(key + 32)..LI.Encrypt(msg, key)), "PARTY")
	else
		SendChatMessage(LI.AddCheckSum(string.char(key + 32)..LI.Encrypt(msg, key)), "PARTY")
	end
end

function LI.DetectDiceShout(msg, name)
	if not LI.IsValidShoud(msg) then
		return true

	elseif msg == LI.lastDetect then
		return false
	else
		LI.lastDetect = msg
	end

	msg = LI.Decrypt(string.sub(msg, 4), string.byte(msg, 3) - 32)

	repeat
-- Splitting
		if string.find(msg, "~") then
			msg = string.sub(msg, 2)
		end

		local start, data = string.find(msg, "~")

		if start then
			data = string.sub(msg, 1, start - 1)
			msg = string.sub(msg, start)
		else
			data = msg
			msg = ""
		end

		if not LI.DetectSysMsges(data, name) then
			if name ~= UnitName("player") then
				LI.SelfValid()
			end

			local typ = tonumber(string.sub(data, 1, 1))
			local dice = LI.HexToDec(string.sub(data, 2, 3))
			local link = LI.ShortLinks[string.sub(data, 4)]

			local _, bidend = string.find(data, "%x+%-%-")

			if bidend then
				dice = LI.HexToDec(string.sub(data, 2, bidend - 2))
				link = LI.ShortLinks[string.sub(data, bidend + 1)]
			end

			if IsAssigner() and typ == 4 and LI_DKP[LI_DKP_web.system]["user"][name] ~= nil and LI_DKP[LI_DKP_web.system]["user"][name] > dice then
				dice = LI_DKP[LI_DKP_web.system]["user"][name]
			end

	-- Splitting
	-- Allowed to dice on the item?
			if typ == 9 then
				link = string.sub(data, 4)
				start = string.find(msg, "~")

				for i = 1, 36 do
					if UnitName("raid"..i) == UnitName("player") then
						if string.byte(msg, i + 1) ~= 48 then
							if string.byte(msg, i + 1) == 57 then
								LI.GroupAskDKPItem(link)
							else
								LI.GroupAskItem(link)
							end
						end

						break
					end
				end
	-- Allowed to dice on the item?
	-- Chat-Message with dice-result
			elseif data and data ~= "" and not (string.len(data) == 36 and tonumber(data)) then
				local typ2 = dice

				if typ == 0 then
					typ2 = ""
				end

				if not link then
					return
				end

				local types = {TEXT("SYS_GIVE_UP"), LI.GROUPLOOT_GREED, LI.GROUPLOOT_ROLL, LI.Trans("DKP")}

				LI.History(link, name, types[(tonumber(typ) or 0) + 1], typ2)

				local quality = LI.GetQuality(link)

				local info   = ChatTypeInfo["SYSTEM"]

				if LI_Data.Options["result"..quality..(typ + 1)] then
					if LI_DKP_Mode == nil or LI_DKP_Mode ~= 1 or (LI_DKP_Mode == 1 and typ == 4) then
						if LI_Data.Options.otherstyle then
							local colors = {
								{info.r * 0.75,				info.g * 0.75,				info.b * 0.75			},
								{info.r,					info.g		,				info.b					},
								{1 - (1 - info.r) * 0.75,	1 - (1 - info.g) * 0.75,	1 - (1 - info.b) * 0.75	},
								{1 - (1 - info.r) * 0.75,	1 - (1 - info.g) * 0.75,	1 - (1 - info.b) * 0.75	},
							}

							DEFAULT_CHAT_FRAME:AddMessage(link.." - |Hplayer:"..name.."|h["..name.."]|h "..types[(tonumber(typ) or 0) + 1].." "..typ2, colors[(tonumber(typ) or 0) + 1][1], colors[(tonumber(typ) or 0) + 1][2], colors[(tonumber(typ) or 0) + 1][3])

						else
							DEFAULT_CHAT_FRAME:AddMessage(typ2.."|Hplayer:"..name.."|h["..name.."]|h "..types[(tonumber(typ) or 0) + 1].." "..link, info.r, info.g, info.b)
						end
					end
				end
	-- Chat-Message with dice-result
	-- Storing results for Assignment
				if IsAssigner() then
					if typ == 0 then
						dice = 0
					else
						dice = (typ - 1) * 100 + dice
					end

					for key, value in ipairs(LI.NeedAssignment) do
						if value.link == link then
							if LI.NeedAssignment[key] ~= nil and LI.NeedAssignment[key]["count"] ~= nil then
								LI.NeedAssignment[key]["count"] = LI.NeedAssignment[key]["count"] - 1
								LI.NeedAssignment[key][name] = dice

								if LI.NeedAssignment[key]["count"] <= 0 then
									LI.DiceResult(link)
								end
							end

							break
						end
					end
				end
			end
		end
	until string.len(msg) <= 0
end

StaticPopupDialogs["LOOTIT_VALIDSYSTEM"] = {
	button1 = TEXT("YES"),
	button2 = TEXT("NO"),
	whileDead = 1,
	exclusive = 1,
	showAlert = 1,
	timeout = 60,
	OnCancel = function()
		if not LI_Data.Options.autodkp then
			LI.Send("NotOkey")
		end
	end,
	OnAccept = function()
		LI.Send("Okey")
	end,
	OnShow = function()
		if LI_Data.Options.autodkp then
			LI.SendMsg("Okey")
		end
	end,
}

StaticPopupDialogs["LOOTIT_NOSYSTEM"] = {
	button1 = TEXT("OK"),
	whileDead = 1,
	exclusive = 1,
	showAlert = 1,
	hideOnEscape = 1,
	timeout = 10,
}

StaticPopupDialogs["LOOTIT_BROKENSYSTEM"] = {
	button1 = TEXT("OK"),
	whileDead = 1,
	exclusive = 1,
	showAlert = 1,
	hideOnEscape = 1,
	timeout = 10,
}

StaticPopupDialogs["LOOTIT_DONESYSTEM"] = {
	button1 = TEXT("OK"),
	whileDead = 1,
	exclusive = 1,
	hideOnEscape = 1,
	timeout = 5,
}

function LI.DetectSysMsges(msg, name)
	if string.find(msg, "ItsMe#.+") and not LI.IsValidSystem() then
		LI.ValidThreshold = GetLootThreshold()

		LI.ValidMember = string.match(msg, "#.+")
		LI.ValidMember = string.sub(LI.ValidMember, 2)
		LI.ValidMember = string.sub(LI.ValidMember, 1)

		LI.LastMaster = LI.ValidMember
		LI.MakeValid = true
		LI_invalid = nil

		StaticPopupDialogs["LOOTIT_DONESYSTEM"]["text"] = LI.Trans("MESSAGE_DKP_DONE")
		StaticPopup_Show("LOOTIT_DONESYSTEM")

		return true

	elseif string.find(msg, "HowIsIt") and IsAssigner() then
		LI.Send("ItsMe#"..LI.ValidMember)

		if not LI_DKP[LI_DKP_web.system]["user"][name] then
			LI_DKP[LI_DKP_web.system]["user"][name] = 0
		end

		LI.Send("IniDKP#"..tostring(name).."#"..tostring(LI_DKP[LI_DKP_web.system]["user"][name]))

		return true

	elseif string.find(msg, "SetDKP#.+##") then
		if IsPartyLeader("player") or UnitIsRaidLeader("player") then
			LI.SaveOwnLoot("alternate")
		end

		LI.CountOkeys = {}

		for i = 1, 36 do
			if UnitName("raid"..i) then
				LI.CountOkeys[UnitName("raid"..i)] = true
			end
		end

		StaticPopupDialogs["LOOTIT_VALIDSYSTEM"]["text"] = LI.Trans("MESSAGE_DKP_SET")

		local text1 = string.match(msg, "#.+#")
		text1 = string.sub(text1, 2)

		text1 = string.sub(text1, 1, string.len(text1) - 2)

		local text2 = string.match(msg, "##.+")
		text2 = string.sub(text2, 3)

		StaticPopup_Show("LOOTIT_VALIDSYSTEM", text1, text2)

		LI.ValidMember = text1
		LI.ValidThreshold = tonumber(text2)

		return true

	elseif msg == "Okey" then
		LI.CountOkeys[name] = nil

		local i = 0

		for _ in pairs(LI.CountOkeys) do
			i = i + 1
		end

		if i == 0 and (IsPartyLeader("player") or UnitIsRaidLeader("player") or tostring(LI.ValidMember) == UnitName("player")) then
			LI.MakeValid = false

			LI.SaveOwnLoot("master", LI.ValidThreshold, LI.ValidMember)
		end

		return true

	elseif msg == "NotOkey" then
		StaticPopup_Hide("LOOTIT_VALIDSYSTEM")

		StaticPopupDialogs["LOOTIT_NOSYSTEM"]["text"] = LI.Trans("MESSAGE_DKP_FAIL")

		StaticPopup_Show("LOOTIT_NOSYSTEM")

		LI.MakeValid = nil

		return true

	elseif msg == "NoMoreValid" then
		StaticPopupDialogs["LOOTIT_BROKENSYSTEM"]["text"] = LI.Trans("MESSAGE_DKP_BROKEN")

		if LI.IsValidSystem() then
			StaticPopup_Show("LOOTIT_BROKENSYSTEM")
		end

		LI.MakeValid = nil
		LI.ValidThreshold = nil
		LI.LastMaster = nil
		LI.ValidMember = nil
		LI_invalid = nil
		LI_DKP_own = nil

		if IsPartyLeader("player") or UnitIsRaidLeader("player") then
			LI.SaveOwnLoot("alternate")
		end

		return true

	elseif msg == "ValidSystemSetUp" then
		StaticPopupDialogs["LOOTIT_DONESYSTEM"]["text"] = LI.Trans("MESSAGE_DKP_DONE")
		StaticPopup_Show("LOOTIT_DONESYSTEM")

		LI.DKP_SendData()

		LI_invalid = nil
		LI.MakeValid = true

		return true

	elseif string.find(msg, "^Method") then
		LI_DKP_Mode = string.gfind(msg, "%d+")

		LI_DKP_Mode = LI_DKP_Mode()
		LI_DKP_Mode = tonumber(LI_DKP_Mode)

		return true

	elseif string.find(msg, "IniDKP#") then
		LI.SelfValid()

		local start, ende = string.find(msg, "#"..tostring(UnitName("player")).."#")

		if start then
			LI_DKP_own = tonumber(string.sub(msg, ende + 1))
		end

		return true

	elseif string.find(msg, "DKPPlus#") then
		LI.SelfValid()

		local start, ende = string.find(msg, "#")

		if start then
			LI_DKP_own = LI_DKP_own + tonumber(string.sub(msg, ende + 1))
		end

		return true

	elseif string.find(msg, "DKPEdit#") then
		LI.SelfValid()

		local start, ende = string.find(msg, "#"..tostring(UnitName("player")).."#")

		if start then
			LI_DKP_own = LI_DKP_own + tonumber(string.sub(msg, ende + 1))
		end

		return true
	end
end

function LI.SelfValid()
	if not LI.IsValidSystem() then
		if IsAssigner() then
			LI.Send("NoMoreValid")
		else
			LI.Send("HowIsIt")
		end
	end
end

LI_DKP_Mode = 0

LI_DKP_own = nil

LI.ItemsToSpend = {}
LI.Pass = 0

function LI.DiceResult(link)
	table.insert(LI.ItemsToSpend, link)
end

function LI.SpendItems(link)
	local lucky = UnitName("player")
	local luckyvalue, lootID, key, name = 0

	if IsAssigner() and GetLootAssignItemSize() ~= 0 then
		for name2, value in ipairs(LI.NeedAssignment) do
			if value.link == link then
				key = name2

				break
			end
		end

		if not key then
			return
		end

		local _, nameing = ParseHyperlink(link)

		nameing = TEXT("Sys"..LI.HexToDec(string.match(nameing, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")).."_name")

		for i = 1, GetLootAssignItemSize() do
			lootID, name = GetLootAssignItemInfo(i)

			if name == nameing then
				break
			end
		end

		local pass = false

		LI.NeedAssignment[key]["count"] = -1
		LI.NeedAssignment[key]["timeout"] = -1

		for _ = 1, 40 do
			if not pass then
				for name3, value in pairs(LI.NeedAssignment[key]) do
					if tonumber(value) and value > luckyvalue then
						luckyvalue = value
						lucky = name3
					end
				end
			end

			if pass or luckyvalue == 0 then
				pass = true

				repeat
					LI.Pass = LI.Pass + 1

					lucky = UnitName("raid"..LI.Pass)

					if LI.Pass >= 36 then
						LI.Pass = 0
					end
				until lucky ~= nil
			end

			for i = 1, 36 do
				local name4 = GetLootAssignMember(lootID, i)

				if name4 and name4 == lucky then
					AssignOnLoot(lootID, name4)

					if LI.NeedAssignment[key][name4] ~= nil and LI.NeedAssignment[key][name4] >= 200 then
						LI.SendToWeb(4, LI.NeedAssignment[key][name4] - 200, link, name4)
						LI.DKP_SendData((LI.NeedAssignment[key][name4] - 200) * -1, name4)
					end

					table.remove(LI.NeedAssignment, key)

					return
				end
			end

			LI.NeedAssignment[key][lucky] = nil
		end
	end
end

function LI.IsValidSystem()
	if LI.MakeValid then
		if LI.ValidThreshold == GetLootThreshold() and GetLootMethod() == "master" then
			return true
		end
	end
end

function LI.IsValidShoud(msg)
	if not tonumber(string.sub(msg, 1, 1)) or string.sub(msg, 1, 1) ~= string.sub(msg, 2, 2) then
		return false
	end

	local check = tonumber(string.sub(msg, 2, 2)) or -1

	local msg = string.sub(msg, 3)

	local sum = 0

	for i = 1, string.len(msg) do
		sum = string.byte(msg, i) + sum
	end

	return check == (sum % 10)
end

function LI.AddCheckSum(msg)
	local sum, before = 0, msg

	for i = 1, string.len(before) do
		sum = string.byte(before, i) + sum
	end

	return tostring(sum % 10)..tostring(sum % 10)..before
end

function LI.Encrypt(msg, key)
	local chiffre = ""

	for i = 1, string.len(msg) do
		local letter = string.byte(msg, i)

		letter = letter + key

		if letter > 126 then
			letter = letter - 95
		end

		if letter == 37 then -- 37 % 92 \ 124 |
			letter = "#1#"

		elseif letter == 92 then
			letter = "#2#"

		elseif letter == 124 then
			letter = "#3#"
		else
			letter = string.char(letter)
		end

		chiffre = chiffre..letter
	end

	return chiffre
end

function LI.Decrypt(msg, key)
	local chiffre = ""

	repeat
		local letter = string.byte(msg, 1)

		local check = string.match(msg, "^#%d#")

		if check then
			check = tonumber(string.sub(check, 2, 2))

			if check > 3 or check < 1 then
				check = nil
			end
		end

		if check then -- 37 % 92 \ 124 |
			if check == 1 then
				letter = 37

			elseif check == 2 then
				letter = 92

			elseif check == 3 then
				letter = 124
			end

			msg = string.sub(msg, 4)
		else
			msg = string.sub(msg, 2)
		end

		letter = letter - key

		if letter < 32 then
			letter = letter + 95
		end

		chiffre = chiffre..string.char(letter)
	until string.len(msg) <= 0

	return chiffre
end

function LI.PaintFrame(this)
	getglobal(this:GetName().."_Show"):Show()

	this.timeout = 300

	if not this.link then
		this:Hide()

		return
	end

	local _, data = ParseHyperlink(this.link)

	local quality = LI.GetQuality(this.link)

	local count

	this.quality = quality

	local hexID, Adura, stat12, stat34, stat56 = string.match(data, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")

	this.indent = LI.BuildShortLink(hexID, Adura, stat12, stat34, stat56, this.link)

	local ID = LI.HexToDec(hexID)

	local name = TEXT("Sys"..ID.."_name")
	local texture = LI.GetTextureById(ID)

	if name == "Sys"..ID.."_name" then
		LootIt_GameTooltip:SetHyperLink(this.link)

		if yaCIt then
			yaCIt.ShowTooltipBySelf(LootIt_GameTooltip)
		end

		name = LootIt_GameTooltipTextLeft1:GetText()
	end

	this.name = name

	local prefix = this:GetName()
	local r, g, b = GetItemQualityColor(quality)

	if count and ( count > 1 ) then
		getglobal(prefix .. "_IconFrame_Count"):SetText(count)
		getglobal(prefix .. "_IconFrame_Count"):Show()
	else
		getglobal(prefix .. "_IconFrame_Count"):Hide()
	end

	getglobal(prefix .. "_IconFrame_Icon"):SetFile(texture)
	getglobal(prefix .. "_Name"):SetText(name)
	getglobal(prefix .. "_Name"):SetColor(r, g, b)

	if not LI.IsValidSystem() then
		LI.RollLoot(this, "pass", true)
	end
end

LI.CurrentDKPBid = {}

function LI.RollLoot(this, typ, auto)
	local roll = 0

	if typ == "roll" then
		roll = 2

	elseif typ == "greed" then
		roll = 1

	elseif typ == "DKP" then
		roll = 3

		LI.CurrentDKPBid[this.indent] = getglobal(this:GetName().."_Bidding"):GetText()
	end

	table.insert(LI.CurrentDice, {this.indent, roll})

	LI.Roll = LI.Roll + 1

	if roll ~= 3 and IsShiftKeyDown() and not auto then
		local _, name = ParseHyperlink(this.link)
		name = string.match(name, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")
		name = TEXT("Sys"..LI.HexToDec(name).."_name")

		LI.AddData(name, nil, roll + 2, IsCtrlKeyDown())
	end

	this:Hide()
end

function LI.GetTextureById(ID)
	local itemID_imgID = dofile("interface/addons/lootit/databases/itemID_imgID.lua")
	local imgID_file = dofile("interface/addons/lootit/databases/imgID_file.lua")

	if not imgID_file or not itemID_imgID then
		LI.io("The image-databases are brocken. Please download the lastet LootIt!-Version on Curse.com!|r")

		return "interface/icons/test_icons_07"
	end

	if ID > 550000 and ID < 560000 then
		return "interface/icons/"..imgID_file[571316]

	elseif ID > 770000 and ID < 780000 then
		return "interface/icons/"..imgID_file[572779]
	end

	return (itemID_imgID[ID] and imgID_file[itemID_imgID[ID]]) and "interface/icons/"..tostring(imgID_file[itemID_imgID[ID]]) or "interface/icons/test_icons_01"
end

LI.ShortLinks = {}

function LI.BuildShortLink(hexID, Adura, stat12, stat34, stat56, link)
	local short = LI.DecToAscii(LI.HexToDec(hexID..string.sub(Adura, string.len(Adura) - 2, string.len(Adura))..stat12..stat34..stat56))

	LI.ShortLinks[short] = link

	return short
end

function LI.HexToDec(hexID)
	local hex, ID = string.lower(hexID), 0

	for i = 1, string.len(hex) do
		local a = string.sub(hex, 1, 1)

		local value = tonumber(a) or string.byte(a) - 87

		ID = ID + (16 ^ (string.len(hex) - 1)) * value

		if string.len(hex) > 1 then
			hex = string.sub(hex, 2)
		end
	end

	return ID
end

function LI.DecToHex(dec, force2)
	dec = tonumber(dec)

	local K, hex, i, d = "0123456789ABCDEF", "", 0

	while dec > 0 do
		i = i + 1
		dec, d = math.floor(dec / 16), math.fmod(dec, 16) + 1
		hex = string.sub("0123456789ABCDEF", d, d)..hex
	end

	if not force2 then
		return string.lower(hex)
	else
		hex = string.lower(hex)

		if string.len(hex) == 0 then
			return "00"
		elseif string.len(hex) == 1 then
			return "0"..hex
		else
			return hex
		end
	end
end

function LI.DecToAscii(dec)
	local long = ""

	while math.floor(dec) ~= 0 do
		local char = math.floor((dec / 92 - math.floor(dec / 92)) * 92 + 32)

		if char >= 92 then
			char = char + 1
		end

		long = string.char(char)..long
		dec = math.floor(dec / 92)
	end

	return long
end

function LI.AcsiiToDec(ascii)
	local ID = 0

	for i = 1, string.len(ascii) do
		local a = string.sub(ascii, 1, 1)

		local value = string.byte(a) - 32

		if value >= 93 - 32 then
			char = char - 1
		end

		ID = ID + (92 ^ (string.len(ascii) - 1)) * value

		if string.len(ascii) > 1 then
			ascii = string.sub(ascii, 2)
		end
	end

	return ID
end

function LI.CheckOwnRollFrame(this)
	if LI.Active() then
		local roll = LI.GetItemLoot(this.name, this.link, true, this.quality)

		if not roll and this.quality then
			if this.quality < LI_Data.Options.autopass and this.quality > LI_Data.Options.autopassmin then
				roll = 2

			elseif this.quality < LI_Data.Options.autogreed and this.quality > LI_Data.Options.autogreedmin then
				roll = 3
			end
		end

		if roll then
			local frame, mode = getglobal("LootIt_LootFrame"..this:GetID().."_Highlight")

			frame:ClearAllAnchors()

			if roll == 2 then
				frame:SetAnchor("CENTER", "CENTER", getglobal(this:GetName().."_CancelButton"), 0, 0)
				frame:Show()
				mode = "pass"

			elseif roll == 3 then
				frame:SetAnchor("CENTER", "CENTER", getglobal(this:GetName().."_GreedButton"), 0, 0)
				frame:Show()
				mode = "greed"

			elseif roll == 4 then
				frame:SetAnchor("CENTER", "CENTER", getglobal(this:GetName().."_RollButton"), 0, 0)
				frame:Show()
				mode = "roll"
			else
				frame:Hide()
			end

			frame.roll = mode
		end
	end
end

function LI.HighlightUpdate2(this, elapsedTime)
	this.updater = this.updater + elapsedTime

	if this.updater >= 0.1 then
		elapsedTime = this.updater

		this.updater = 0
	else
		return
	end

	this.timer = this.timer - elapsedTime

	if this.timer <= 0 then
		LI.RollLoot(this:GetParent(), this.roll, true)
		this:Hide()
	end

	local red, green, blue = LI.TrafficColor(this.timer)

	getglobal(this:GetName().."_Color"):SetColor(red, green, blue)
end

LI.AllowDice = {}

function LI.SendAllowdDices(dkpbool)
	local lootID, name, link

	for i = 1, GetLootAssignItemSize() do
		lootID, name = GetLootAssignItemInfo(i)

		if lootID == LI.CurrendItem then
			break
		end
	end

	if not tonumber(lootID) then
		return
	end

	local hexID, Adura, stat12, stat34, stat56, key

	for i, val in ipairs(LI.NeedAssignment) do
		local _, nameing = ParseHyperlink(val.link)

		hexID, Adura, stat12, stat34, stat56 = string.match(nameing, "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")

		nameing = TEXT("Sys"..LI.HexToDec(hexID).."_name")

		if nameing == name then
			link = val.link
			key = i

			break
		end
	end

	if not link then
		return
	end

	local luckys = {"900"..LI.BuildShortLink(hexID, Adura, stat12, stat34, stat56, link).."~"}

	for i = 1, 36 do
		local done

		for j = 1, 36 do
			if UnitName("raid"..i) == GetLootAssignMember(LI.CurrendItem, j) then
				done = true

				if LI.AllowDice[UnitName("raid"..i)] then
					if dkpbool then
						table.insert(luckys, 9)
					else
						table.insert(luckys, math.random(1, 8))
					end
				else
					table.insert(luckys, 0)
				end

				break
			end
		end
	end

	LI.Send(table.concat(luckys))

	local _, num = string.gsub(luckys[1], "0", "")
	local _, num2 = string.gsub(table.concat(luckys), "0", "")

	LI.NeedAssignment[key]["count"] = 36 - (num2 - num)

	if dkpbool then
		LI.NeedAssignment[key]["dicetype"] = 11
	else
		LI.NeedAssignment[key]["dicetype"] = 10
	end

	LI.AllowDice = {}
end

function LI.MiniConfigGenerateMasterloot(this)
	local classes = {}

	for i = 1, 36 do
		if UnitName("raid"..i) then
			local pri = UnitClass("raid"..i)

			if pri then
				if not classes[pri] then
					classes[pri] = {}
				end

				classes[pri][UnitName("raid"..i)] = true
			end
		end
	end

	if not UIDROPDOWNMENU_MENU_LEVEL or UIDROPDOWNMENU_MENU_LEVEL == 1 then
		UIDropDownMenu_AddButton({
			text = "LootIt! "..LI.version,
			isTitle = 1,
			notCheckable = 1,
		})

		UIDropDownMenu_AddButton({
			text = LI.Trans("ALLOW_DICE"),
			notCheckable = 1,
		})

		local i = 0

		for class, val in pairs(classes) do
			i = i + 1

			UIDropDownMenu_AddButton({
				text = class,
				hasArrow = 1,
				value = class,
				arg1 = val,
				func = function(this)
					for name in pairs(this.arg1) do
						LI.AllowDice[name] = not LI.AllowDice[name]
					end
				end,
			})
		end

		UIDropDownMenu_AddButton({
			text = TEXT("STR_CHAT_SEND"),
			notCheckable = 1,
			func = function()
				LI.SendAllowdDices(false)
			end,
		})

		UIDropDownMenu_AddButton({
			text = TEXT("STR_CHAT_SEND").."("..LI.Trans("DKP")..")",
			notCheckable = 1,
			func = function()
				LI.SendAllowdDices(true)
			end,
		})

	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for name in pairs(classes[UIDROPDOWNMENU_MENU_VALUE]) do
			UIDropDownMenu_AddButton({
				text = name,
				arg1 = name,
				checked = LI.AllowDice[name] == true,
				func = function(this)
					LI.AllowDice[this.arg1] = not LI.AllowDice[this.arg1]
				end,
			}, 2)
		end
	end
end

function LI.MiniConfigGenerateMasterlootAuto(this)
	if LI_Data and LI_Data.Options ~= nil then
		if not UIDROPDOWNMENU_MENU_LEVEL or UIDROPDOWNMENU_MENU_LEVEL == 1 then
			UIDropDownMenu_AddButton({
				text = "LootIt! "..LI.version,
				isTitle = 1,
				notCheckable = 1,
			})

			UIDropDownMenu_AddButton({
				text = LI.Trans("AUTOMASTER")..": "..LI.GetQualityString(LI_Data.Options.automaster),
				notCheckable = true,
				hasArrow = 1,
				value = 1,
			})

			UIDropDownMenu_AddButton({
				text = LI.Trans("ITEMFILTER"),
				notCheckable = true,
				func = function(this)
					LootIt_MasterItemFilter:Show()

					CloseDropDownMenus()
				end,
			})

		elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
			if UIDROPDOWNMENU_MENU_VALUE == 1 then
				for i = -1, LI.QualityCount do
					info = {
						text = LI.GetQualityString(i),
						func = function(this)
							LI_Data.Options.automaster = tonumber(this.arg1)
							CloseDropDownMenus()
						end,
						arg1 = i,
					}

					info.checked = i == LI_Data.Options.automaster

					UIDropDownMenu_AddButton(info, 2)
				end
			end
		end
	end
end

function LI.PaintMasterFilterFrame(filter)
	if LI_MasterFilterCache == nil or filter then
		LI_MasterFilterCache = {}

		for name, value in pairs(LI_MasterFilterChar) do
			table.insert(LI_MasterFilterCache, {name, value})
		end

		for name, value in pairs(LI_MasterFilterCharSpezial) do
			table.insert(LI_MasterFilterCache, {name, value})
		end

		if filter and filter ~= "" and table.getn(LI_MasterFilterCache) ~= 0 then
			local chache = LI_MasterFilterCache

			LI_MasterFilterCache = {}

			for _, val in ipairs(chache) do
				if string.find(val[1], filter) then
					table.insert(LI_MasterFilterCache, val)
				end
			end
		end

		local function comp(t1, t2)
			if string.lower(t1[1]) < string.lower(t2[1]) then
				return true
			else
				return false
			end
		end

   		table.sort(LI_MasterFilterCache, comp)

		local num = table.getn(LI_MasterFilterCache) - LI.NumVisbileFilters(LootIt_MasterItemFilter_ScrollBar)

		if num <= 1 then
			num = 1
		end

		LootIt_MasterItemFilter_ScrollBar:SetMinMaxValues(1, num)
	end

	for i = 1, 10 do
		local num = LootIt_MasterItemFilter_ScrollBar:GetValue() + i - 1

		if LI_MasterFilterCache[num] ~= nil and not (i >= LI.NumVisbileFilters(LootIt_MasterItemFilter_ScrollBar)) then
			local name = LI_MasterFilterCache[num][1]

			getglobal("LootIt_MasterItemFilter_Filterlist_Item"..i):Show()
			getglobal("LootIt_MasterItemFilter_Filterlist_Item"..i.."_Name"):SetText(name)
			getglobal("LootIt_MasterItemFilter_Filterlist_Item"..i.."_Roll"):SetText(LI.ConvertIDToString(LI_MasterFilterCache[num][2], true))
		else
			getglobal("LootIt_MasterItemFilter_Filterlist_Item"..i):Hide()
		end
	end
end

function LI.AddMasterButton(this, itemname, roll)
	if itemname == nil then
		itemname = getglobal(this:GetParent():GetName().."_Itemname"):GetText()
	end

	if roll == nil then
		roll = UIDropDownMenu_GetText(getglobal(this:GetParent():GetName().."_Rolling"))
	end

	roll = LI.ConvertStringToID(tostring(roll), true)

	LI_MasterFilterChar[itemname] = nil
	LI_MasterFilterCharSpezial[itemname] = nil

	if LI.CheckForNormal(itemname) then
		LI_MasterFilterChar[itemname] = roll
	else
		LI_MasterFilterCharSpezial[itemname] = roll
	end

	LI_MasterFilterCache = nil

	LI.PaintMasterFilterFrame()

	getglobal(this:GetParent():GetName().."_Itemname"):SetText("")
	UIDropDownMenu_SetText(getglobal(this:GetParent():GetName().."_Rolling"), LI.Trans("ROLL"))
end

function LI.DelMasterButton(this)
	local itemname = getglobal(this:GetParent():GetName().."_Itemname"):GetText()

	LI_MasterFilterChar[itemname] = nil
	LI_MasterFilterCharSpezial[itemname] = nil

	LI_MasterFilterCache = nil

	LI.PaintMasterFilterFrame()

	getglobal(this:GetParent():GetName().."_Itemname"):SetText("")
	UIDropDownMenu_SetText(getglobal(this:GetParent():GetName().."_Rolling"), LI.Trans("ROLL"))
end

function LI.LoadMasterRollingDropDown(this)
	UIDropDownMenu_Initialize(this, LI.LoadMasterRollingDropDownGenerate)
end

function LI.LoadMasterRollingDropDownGenerate(this)
	if LI_Data and LI_Data.Options ~= nil then
		if not UIDROPDOWNMENU_MENU_LEVEL or UIDROPDOWNMENU_MENU_LEVEL == 1 then
			UIDropDownMenu_AddButton({
				text = LI.ConvertIDToString(1, true),
				notCheckable = true,
				func = function()
					UIDropDownMenu_SetText(this, LI.ConvertIDToString(1, true))
				end,
			})

			UIDropDownMenu_AddButton({
				text = LI.ConvertIDToString(10, true),
				notCheckable = true,
				func = function()
					UIDropDownMenu_SetText(this, LI.ConvertIDToString(10, true))
				end,
			})

			UIDropDownMenu_AddButton({
				text = LI.ConvertIDToString(11, true),
				notCheckable = true,
				func = function()
					UIDropDownMenu_SetText(this, LI.ConvertIDToString(11, true))
				end,
			})
		end
	end
end

function LI.SelectMasterFilterRow(this)
	getglobal(this:GetParent():GetParent():GetName().."_Itemname"):SetText(getglobal(this:GetName().."_Name"):GetText())

	UIDropDownMenu_SetText(getglobal(this:GetParent():GetParent():GetName().."_Rolling"), getglobal(this:GetName().."_Roll"):GetText())

	LI.PaintMasterFilterFrame()
end

function LI.DKP_SendData(value, name)
	if LI_System and tostring(LI.ValidMember) == UnitName("player") then
		LI.Send("Method#"..(LI_System.setting["methods"]))

		for name, value in pairs(LI_DKP[LI_DKP_web.system]["user"]) do
			LI.Send("IniDKP#"..tostring(name).."#"..tostring(value))
		end
	end

	if name ~= nil then
		LI_DKP[LI_DKP_web.system]["user"][name] = LI_DKP[LI_DKP_web.system]["user"][name] + value

		LI.Send("DKPEdit#"..tostring(name).."#"..tostring(value))

	elseif value ~= nil then
		for name, _ in pairs(LI_DKP[LI_DKP_web.system]["user"]) do
			LI_DKP[LI_DKP_web.system]["user"][name] = LI_DKP[LI_DKP_web.system]["user"][name] + value
		end

		LI.Send("DKPPlus#"..tostring(value))
	end
end

function LI.DKP_Log_OnUpdate(this, elapsedTime)
	if not this.Time then
		this.Time = 1
	else
		this.Time = this.Time - elapsedTime

		if this.Time <= 0 then
			this.Time = nil

			LI.DKP_Log()
		end
	end
end

function LI.DKP_StartStop(this)
	if LI_RaidRunning then
		LI.SendToWeb(2)

		this:SetText(LI.Trans("START"))
	else
		LI.SendToWeb(1)

		this:SetText(LI.Trans("STOP"))
	end
end

function LI.DKP_Box_Check(this)
	if this:GetID() == 1 then
		LI_System = nil

		if tonumber(this:GetText()) == nil then
			this:SetText(0)
		end

		LI_DKP_web.system = math.floor(this:GetText())

		local _, fun = pcall(dofile ,"Interface/DKP/"..(LI_DKP_web.system)..".lua")

		if fun and type(fun) == "function" then
			fun()
		end

		if LI_System ~= nil then
			LI.io("DKP_FILE_LOADED")

			if not LI_DKP[LI_DKP_web.system] or LI_System.timestamp > LI_DKP[LI_DKP_web.system]["timestamp"] then
				LI_DKP[LI_DKP_web.system] = LI_System
			end

			local tmp = LI_Bosses

			LI_Bosses = {}

			for _, indent in ipairs(tmp) do
				local a, b = string.find(indent, "^%d*")
				local c, d = string.find(indent, "%d*$")

				if not LI_Bosses[tonumber(string.sub(indent, a, b))] then
					LI_Bosses[tonumber(string.sub(indent, a, b))] = {}
				end

				LI_Bosses[tonumber(string.sub(indent, a, b))][TEXT("Sys"..tonumber(string.sub(indent, c, d)).."_name")] = tonumber(string.sub(indent, c, d))
			end
		else
			LI.io("DKP_FILE_ERROR")

			LI_DKP_web.system = 0
		end

		this:SetText(LI_DKP_web.system)

	elseif this:GetID() == 2 then
		if string.len(tostring(this:GetText())) ~= 4 then
			this:SetText("****")
		end

		LI_DKP_web.spin = this:GetText()
	else
		if this:GetText() == nil or this:GetText() == "" then
			this:SetText(UnitName("player"))
		end

		if not LI_RaidRunning then
			LI_DKP_web.name = this:GetText()
		end
	end
end

function LI.DKP_Box_Show(this)
	if this:GetID() == 1 then
		if LI_DKP_web.system then
			this:SetText(LI_DKP_web.system)
		else
			this:SetText(0)
		end

	elseif this:GetID() == 2 then
		if LI_DKP_web.spin then
			this:SetText(LI_DKP_web.spin)
		else
			this:SetText("****")
		end
	else
		if this:GetText() == nil or this:GetText() == "" then
			this:SetText(tostring(GetZoneName()))
		end
	end
end

function LI.DKPPaintFrame(this)
	LI.PaintFrame(this)

	this.timeout = 60
end

LI.CurrentDKPItems = {}

function LI.DKPLootFrame_OnHide(this)
	this.timeout = 60

	LootIt_DKPBiddingFrame_Show.timeout = 5
end

function LI.GroupAskDKPItem(shortitem)
	if LI.IsValidSystem() then
		if not LootIt_DKPBiddingFrame_Show:IsVisible() then
			if not shortitem and #LI.CurrentDKPItems ~= 0 then
				shortitem = table.remove(LI.CurrentDKPItems)
			end

			LootIt_DKPBiddingFrame.link = LI.ShortLinks[shortitem]
			LootIt_DKPBiddingFrame:Show()

		elseif shortitem then
			table.insert(LI.CurrentDKPItems, shortitem)
		end
	end
end

function LI.CheckBidding(this, reset)
	local bid = this:GetText()

	if not tonumber(bid) then
		bid = string.match(bid, "%d+")
	end

	if bid == nil or reset then
		bid = 0

		getglobal(this:GetParent():GetName().."_RollButton"):Hide()
		getglobal(this:GetParent():GetName().."_CancelButton"):Show()

		if reset then
			this:SetText("")

			return
		end
	else
		getglobal(this:GetParent():GetName().."_RollButton"):Show()
		getglobal(this:GetParent():GetName().."_CancelButton"):Hide()
	end

	bid = math.floor(math.abs(bid))

	if tonumber(LI_DKP_own) < 0 then --## error nil!
		bid = 0

	elseif tonumber(bid) > tonumber(LI_DKP_own) then
		bid = math.floor(math.abs(LI_DKP_own))
	end

	if tostring(bid) ~= tostring(this:GetText()) then
		this:SetText(bid)
	else
		if tostring(this:GetText()) == "0" then
			LI.RollLoot(this:GetParent(), "greed")
		else
			LI.RollLoot(this:GetParent(), "DKP")
		end

		this:GetParent():Hide()
	end
end

function LI.url_encode(str)
	if str then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
			function (c)
				return string.format ("%%%02X", string.byte(c))
			end
		)
		str = string.gsub (str, " ", "+")
	else
		return ""
	end

	return tostring(str)
end

LI_RaidRunning = false

LI_DKP_Logging = {}

LI_DKP_host = "http://lootit.org/"

if LI.debugmode and false then
	LI_DKP_host = "http://localhost/lootitdkp/"
end

function LI.SendToWeb(typ, text, item, char)
	if typ == 0 then
		GC_OpenWebRadio(LI_DKP_host)

		return
	end

	if not IsAssigner() then
		return
	end

	if typ == 2 then
		if LI_System and LI_System.setting and LI_System.setting.raid then
			LI.Send("DKPPlus#"..(LI_System.setting.raid))

			LI_DKP_Timer = nil
		end
	end

	if not LI_RaidRunning and (typ == 3 or typ == 4) then
		LI.SendToWeb(1)
	end

	if typ == 3 then
		local send = nil

		if string.find(text, "%d+-%d+") == nil then
			if LI_Bosses[GetZoneID()] ~= nil then
				if LI_Bosses[GetZoneID()][text] ~= nil then
					text = GetZoneID().."-"..LI_Bosses[GetZoneID()][text]

					if LI_System.setting[text] then
						send = LI_System.setting[text]
					end

				else
					LI.Log("Bossname "..text.." unknown in zone "..GetZoneID().."!")
				end
			else
				LI.Log("ZoneID "..GetZoneID().." unknown!")
			end

			if not string.find(text, "%d+-%d+") == nil then
				LI.io("This boss is not known to the system. Please report it to Tinsus at http://www.lootit.org/ Reporting allows to set and gain specific DKP later. Needed informations: ZoneID: "..GetZoneID().." Bossname: "..text.." Loca: "..GetLanguage())
			end
		end

		if send then
			LI.Send("DKPPlus#"..send)

		elseif LI_System and LI_System.setting and LI_System.setting.bossdefault then
			LI.Send("DKPPlus#"..LI_System.setting.bossdefault)
		end
	end

	if text == nil then
		text = LI_DKP_web.name
	end

	if text == nil then
		StaticPopupDialogs["LOOTIT_ENTER_TEXT"] = {
			text = LI.Trans("ENTER_TEXT"),
			button1 = TEXT("ACCEPT"),
			button2 = TEXT("CANCEL"),
			OnShow = function(this)
				if LI_DKP_web.name ~= nil then
					getglobal(this:GetName().."EditBox"):SetText(LI_DKP_web.name)
				else
					getglobal(this:GetName().."EditBox"):SetText(tostring(GetZoneName()))
				end
			end,
			OnAccept = function(this)
				LI.SendToWeb(LI_SaveBin.typ, tostring(getglobal(this:GetName().."EditBox"):GetText()), LI_SaveBin.item, LI_SaveBin.char)
			end,
			hasEditBox = 1,
			timeout = 0,
			whileDead = 1,
			exclusive = 1,
			hideOnEscape = 1,
		};

		LI_SaveBin = {typ = typ, item = item, char = char},

		StaticPopup_Show("LOOTIT_ENTER_TEXT")

		return
	else
		LI_DKP_web.name = text
	end

	if char == nil then
		local names = {}

		for i = 1, 36 do
			if UnitName("raid"..i) then
				table.insert(names, UnitName("raid"..i))
			end
		end

		table.sort(names)
		char = table.concat(names, ",")
	end

	if typ == 1 then
		LI_RaidRunning = true

	elseif typ == 2 then
		LI_RaidRunning = false
	end

	if not (typ == 3 and LI_DKP_Logging[#LI_DKP_Logging]["text"] == text) then
		table.insert(LI_DKP_Logging, {time = LI.Time(), typ = typ, text = text, char = char, item = item})
	end

	LI.DKP_Log()
end

function LI.DKP_Ready()
	if LI_DKP_web == nil
	or LI_System == nil
	or LI_DKP_web.spin == nil
	or string.len(LI_DKP_web.spin) > 4
	or LI_DKP_web.system == nil
	or tostring(LI_DKP_web.system) == "0"
	or tostring(LI_DKP_web.system) ~= tostring(LI_System.id)
	or tostring(LI_DKP_web.name) == "" then
		return false
	end

	return true
end

function LI.DKP_Log(onshow)
	local text = ""

	if #LI_DKP_Logging == 0 then
		text = LI.Trans("EMPTY")

		LootIt_DKP_Info_SendButton:Hide()
	else
		LootIt_DKP_Info_SendButton:Show()

		local scroll = LootIt_DKP_Info_ScrollBar:GetValue() + 1

		for i = scroll, scroll + 6 do
			if LI_DKP_Logging[i] ~= nil then
				local time = (LI_DKP_Logging[i]["time"] - LI_DKP_Logging[1]["time"])

				local sec, min, hour = math.floor(time % 60), math.floor((time / 60) % 60),  math.floor(time / 60 / 60)

				if sec <= 9 then
					sec = "0"..tostring(sec)
				end

				if min <= 9 then
					min = "0"..tostring(min)
				end

				if hour <= 9 then
					hour = "0"..tostring(hour)
				end

				text = text.."["..hour..":"..min..":"..sec.."] "

				if LI_DKP_Logging[i]["typ"] == 1 then -- start
					text = text..LI.Trans("RAID_START").."\n"

				elseif LI_DKP_Logging[i]["typ"] == 2 then -- ende
					text = text..LI.Trans("RAID_END").."\n"

				elseif LI_DKP_Logging[i]["typ"] == 3 then -- kill
					local boss = LI_DKP_Logging[i]["text"]
					local _, minus = string.find(boss, "-")

					if minus then
						local zone = tonumber(string.sub(boss, 1, minus - 1))
						local sysid = tonumber(string.sub(boss, minus + 1))

						if sysid then
							boss = TEXT("Sys"..sysid.."_name")
						end
					end

					text = text..boss.."\n"

				elseif LI_DKP_Logging[i]["typ"] == 4 then -- kauf
					text = text..LI_DKP_Logging[i]["char"].." - "..LI_DKP_Logging[i]["item"].."\n"

				elseif LI_DKP_Logging[i]["typ"] == 6 then -- drop //5 Korrektur (website)
					text = text..LI_DKP_Logging[i]["item"].."\n"
				end
			end
		end
	end

	LootIt_DKP_Info_Log:SetText(text)

	local scroll = #LI_DKP_Logging - 7

	if scroll < 0 then
		scroll = 0
	end

	LootIt_DKP_Info_ScrollBar:SetMinMaxValues(0, scroll)

	if onshow then
		LootIt_DKP_Info_ScrollBar:SetValue(scroll)
	end

	if LI.DKP_Ready() and LI.IsValidSystem() then
		LootIt_DKP_Info_StartStopButton:Show()
	else
		LootIt_DKP_Info_StartStopButton:Hide()
	end
end

function LI.SendToBrowser()
	if #LI_DKP_Logging ~= 0 then
		repeat
			local url = LI_DKP_host.."import.php?spin="..LI.url_encode(LI_DKP_web.spin).."&sys="..LI.url_encode(LI_DKP_web.system)

			for i = 1, #LI_DKP_Logging do
				if #LI_DKP_Logging >= 1 then
					local part = LI_DKP_Logging[1]

					part = "&a"..i.."="..LI.url_encode(LI_DKP_Logging[1]["typ"]).."&b"..i.."="..LI.url_encode(LI_DKP_Logging[1]["text"]).."&c"..i.."="..LI.url_encode(LI_DKP_Logging[1]["char"]).."&d"..i.."="..LI.url_encode(LI_DKP_Logging[1]["item"]).."&e"..i.."="..LI.url_encode(LI_DKP_Logging[1]["time"] - LI.Time())

					if string.len(url) + string.len(part) <= 1000 then
						url = url..part

						table.remove(LI_DKP_Logging, 1)
					else
						break
					end
				else
					break
				end
			end

			GC_OpenWebRadio(url)
		until #LI_DKP_Logging >= 0
	else
		LI.SendToWeb(0)
	end
end

function LI.UpdateMasterLoot()
	if LI.IsValidSystem() then
		LootIt_MasterLootButton:Show()
		LootIt_MasterLootDiceNow:Show()

		LootFrameTitleText:SetText(LI.Trans("DKP"))
	else
		LootIt_MasterLootButton:Hide()
		LootIt_MasterLootDiceNow:Hide()

		LootFrameTitleText:SetText(TEXT("RK_LOOT_APPOINT"))
	end
end

function LI.UpdateMasterLabel()
	if LootFrame:IsVisible() then
		for i = 1, 6 do
			local item = (LootFrame.pageNum - 1) * 6 + i

			if item <= GetLootAssignItemSize() then
				_, name = GetLootAssignItemInfo(item)

				for key, value in ipairs(LI.NeedAssignment) do
					if name == TEXT("Sys"..LI.HexToDec(string.match(LI.NeedAssignment[key]["link"], "(%x+) %x+ (%x+) (%x+) (%x+) (%x+) .*")).."_name") then
						result = LI.NeedAssignment[key]["dicetype"]

						if result == 10 then
							getglobal("LootFrameItem"..i.."Name"):SetText(LI.Trans("AUTOMASTER"))
						elseif result == 11 then
							getglobal("LootFrameItem"..i.."Name"):SetText(LI.Trans("DKP"))
						else
							getglobal("LootFrameItem"..i.."Name"):SetText(TEXT("CRAFTQUEUE_LIST"))
						end

						break
					end
				end
			end
		end
	end
end
