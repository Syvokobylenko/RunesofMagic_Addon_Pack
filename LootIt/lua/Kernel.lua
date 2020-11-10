-- last changes     by: Tinsus     at: 2016-07-02T09:27:42Z     project-version: v1.9beta1     hash: eafe20edfe4fe4e78f770c249436eecdac101094

local LI = _G.LI

LI.ChatCooldown = 10
LI.Roll = 0
LI.DiceTimeout = 60
LI.CountTime = 0
LI.UpdateMastersLabel = 0

LI.QualityCount = 3

function LI.GetQualityCount()
	if GetCurrentRealm() == "Paradise" then
		LI.QualityCount = 8
	else
		for i = 1, 9 do
			if TEXT("ITEM_QUALITY"..i.."_DESC") ~= "ITEM_QUALITY"..i.."_DESC" then
				LI.QualityCount = i
			end
		end
	end
end

LI.GetQualityCount()

function LI.OnUpdate(this, elapsedTime)
	if LI.Active() then
		if not this.checkRoll or this.checkRoll <= 0 then
			LI.RunOnUpdate(this, (this.checkRoll or -0.1) + 0.1)

			this.checkRoll = 0.1
		else
			this.checkRoll = this.checkRoll - elapsedTime
		end

		if LI_Data.Options.removelessgold and not StaticPopup_FindVisible("LOOTIT_DELETE_ITEMS") then
			if not this.checkGD or this.checkGD <= 0 then
				LI.RunGoldDigger()

				this.checkGD = 1
			else
				this.checkGD = this.checkGD - elapsedTime
			end
		end
	end

	if LI.OK() and LI.IsValidSystem() then
		if LI.Roll > 0 or #LI.ItemsToSpend > 0 then
			if not this.Roll or this.Roll <= 0 then
				if #LI.ItemsToSpend > 0 then
					LI.SpendItems(table.remove(LI.ItemsToSpend, 1))
				end

				if LI.Roll > 0 then
					Roll()

					LI.Roll = LI.Roll - 1
				end

				this.Roll = 0.2
			else
				this.Roll = this.Roll - elapsedTime
			end
		end

		if #LI.CheckForDicer > 0 then
			if not this.dicer or this.dicer <= 0 then
				this.dicer = 0.2

				local val = table.remove(LI.CheckForDicer)

				LI.CheckForDicers(val[1], val[2])
			else
				this.dicer = this.dicer - elapsedTime
			end
		end

		if IsAssigner() then
			if LI.DiceTimeout <= 0 then
				LI.CountingDownDices()

				LI.DiceTimeout = 60
			else
				LI.DiceTimeout = LI.DiceTimeout - elapsedTime
			end
		end

		if LI_RaidRunning and LI_System and LI_System.setting and LI_System.setting.time then
			if not LI_DKP_Timer then
				LI_DKP_Timer = 60 * 5
			end

			LI_DKP_Timer = LI_DKP_Timer - elapsedTime

			if LI_DKP_Timer <= 0 then
				LI_DKP_Timer = nil

				LI.Send("DKPPlus#"..(math.floor(LI_System.setting.time / 60 / 60 * 60 * 5)))
			end
		end

		if LI.UpdateMastersLabel <= 0 then
			LI.UpdateMasterLabel()

			LI.UpdateMastersLabel = 1

		elseif elapsedTime then
			LI.UpdateMastersLabel = LI.UpdateMastersLabel - elapsedTime
		end
	end

	if LI.UpdateZZButton ~= nil then
		if LI.UpdateZZButton <= 0 then
			if LI.ZZIBPlugin ~= nil then
				if LI.ZZIBPlugin.Core ~= nil then
					if LI.ZZIBPlugin.Core.UpdateLabel ~= nil then
						if LI.ZZIBPlugin.Core.UpdateLabel.LootMode ~= nil then
							LI.ZZIBPlugin.Core.UpdateLabel.LootMode(true)
						end
					end
				end
			end

			LI.UpdateZZButton = nil

		elseif elapsedTime then
			LI.UpdateZZButton = LI.UpdateZZButton - elapsedTime
		end
	end

	LI.CountTime = LI.CountTime + elapsedTime
end

function LI.Time()
	return math.floor(LI.CountTime)
end

function LI.Active()
	if not LI_Data or LI_Data.Options == nil or not LI_Data.Options.active then
		return false
	else
		return true
	end
end

LI_BagScan = {}

function LI.OK()
	return GetFramerate() > 10
end

function LI.OnEvent(this, event, arg1, arg2, arg3, arg4)
	if event == "LOADING_END" then
		LI.IntData()

	elseif event == "VARIABLES_LOADED" then
		LI.RegisterAddonManager()

	elseif event == "BOOTY_SHOW" and LI.Active() and not IsShiftKeyDown() then
		if LI_Data.Options.cursor then
			local x, y = GetCursorPos()

			BootyFrame:ClearAllAnchors()
			BootyFrame:SetAnchor("TOPLEFT", "TOPLEFT", UIParent, x / (GetUIScale() or 1) - 40, y / (GetUIScale() or 1) - 56)
		end

		LI.CheckBootyFrame()

	elseif event == "BAG_ITEM_UPDATE" and LI.Active() then
		LI.AddBagScan(arg1)

	elseif event == "PARTY_MEMBER_CHANGED" then
		if LI.Active() and LI_Data.Options.history and (GetNumPartyMembers() ~= 0 or GetNumRaidMembers() ~= 0) then
			LootIt_History:Show()
		else
			LootIt_History:Hide()
		end

	elseif event == "UNIT_TARGET_CHANGED" then
		if LI.IsValidSystem() then
			if UnitSex(arg1.."target") >= 3 and UnitHealth(arg1.."target") == 0 then
				local LastBoss = UnitName(arg1.."target")

				if LastBoss ~= nil then
					LI.SendToWeb(3, LastBoss)
				end
			end
		end

	elseif event == "UPDATE_LOOT_ASSIGN" then
		LI.UpdateMasterLoot()
	end
end

function LI.SavePopup()
	StaticPopupDialogs["LOOTIT_OTHER_FILTERS"] = {
		text = LI.Trans("OTHER_FILTERS"),
		button1 = TEXT("FOCUSFRAME_OPTION"),
		button2 = TEXT("CANCEL"),
		whileDead = 1,
		showAlert = 1,
		hideOnEscape = 1,
		timeout = 60,
		OnAccept = function()
			LootIt_Optionen:Show()
			LootIt_ItemFilter:Show()
		end,
	}
end

LI.Data_once = false

function LI.IntData(force)
	if LI.Data_once and not force then
		return
	end

	if not LI_Data then
		LI_Data = {}
	end

	LI.SetHooks()
	LI.GenQualityColor()
	LI.UpdateData()
	LI.Hook_Tooltips()
	LI.ConvertLootomaticData()

	if LI_Data.Options.minimap then
		LootIt_MinimapButton:Show()
	else
		LootIt_MinimapButton:Hide()
	end

	LI.PlaceFrames()

	if not LI_Data.version or LI_Data.version ~= LI.version then
		if not LI_Data.version then
			LootIt_History_Move:ClearAllAnchors()
			LootIt_History_Move:SetAnchor("CENTER", "CENTER", UIParent, 0, 0)

			-- Default settings
			LI.AddData(TEXT("SYS_CARD_TITLE").."*"	, 3, 1, false, true, 0)	-- Karte - *
			LI.AddData("$"..TEXT("SYS_WEAPON_POS04"), 1, 1, false, true, 0)	-- $Munition
			LI.AddData("$"..TEXT("SYS_ITEM_RUNE")	, 1, 1, false, true, 0)	-- $Runen
			LI.AddData(TEXT("Sys206879_name")		, 3, 1, false, true, 0)	-- Altes Memento

			LI.SavePopup()

			StaticPopup_Show("LOOTIT_OTHER_FILTERS")
		end

		if #LI_MasterFilterChar == 0 and #LI_MasterFilterCharSpezial == 0 then
			LI.AddMasterButton(LootIt_MasterItemFilter_Add, "!"..TEXT("ITEM_QUALITY3_DESC").."&|$"..TEXT("SYS_WEAPON_POS04").."&|"..TEXT("Sys203606_name"), LI.ConvertIDToString(11)) --auto-dkp !Selten&|$Munition&|Amulett des Lichts
			LI.AddMasterButton(LootIt_MasterItemFilter_Add, "!"..TEXT("ITEM_QUALITY4_DESC"), LI.ConvertIDToString(11))
			LI.AddMasterButton(LootIt_MasterItemFilter_Add, "!"..TEXT("ITEM_QUALITY5_DESC"), LI.ConvertIDToString(11))
		end

		LI_Data.version = LI.version

		LI.io("UPDATE_MESSAGE")

		for itemname, value in pairs(LI_FilterAll) do
			LI.AddData(itemname, value[1], value[2], true, true, value[3] or 0)
		end

		for itemname, value in pairs(LI_FilterAllSpezial) do
			LI.AddData(itemname, value[1], value[2], true, true, value[3] or 0)
		end

		for itemname, value in pairs(LI_FilterChar) do
			LI.AddData(itemname, value[1], value[2], false, true, value[3] or 0)
		end

		for itemname, value in pairs(LI_FilterCharSpezial) do
			LI.AddData(itemname, value[1], value[2], false, true, value[3] or 0)
		end

		for itemname, value in pairs(LI_MasterFilterChar) do
			LI.AddMasterButton(this, itemname, ConvertIDToString(value))
		end

		for itemname, value in pairs(LI_MasterFilterCharSpezial) do
			LI.AddMasterButton(this, itemname, ConvertIDToString(value))
		end
	end

	LI.intrunning = true

	LI.ScanFullBag()

	LI.Data_once = true
end

function LI.UpdateData()
	if not LI_Data.Options then
		LI_Data.Options = {}
	end

	local defaults = {
		active			= true,
		minimap			= true,
		cursor			= true,
		close			= false,
		delay			= 3,
		askafter		= 5,
		countammo		= 20,
		secuwait		= 10,
		historynum		= 20,
		autoloot		= -1,
		autolootmin		= -2,
		autopass		= -1,
		autopassmin		= -2,
		autogreed		= -1,
		autogreedmin	= -2,
		automaster		= 5,
		nobosses		= false,
		RollFrameX		= GetScreenWidth() * 0.5 - 115,
		RollFrameY		= GetScreenHeight() * 0.8,
		RollFrameD		= -70,
		otherstyle		= true,
		range			= false,
		addmessage		= true,
		improvetooltips = true,
		history			= true,
		testing			= false,
		nofilter		= false,
		removelessgold	= false,
		savequest		= true,
		statrota		= true,
		noscantip		= false,
		autodkp			= false,
		bagbutton		= true,
		readonly		= false,

		result01		= true,
		result02		= true,
		result03		= true,
		result04		= true,
		result05		= true,
		result06		= true,

		result11		= true,
		result12		= true,
		result13		= true,
		result14		= true,
		result15		= true,
		result16		= true,

		result21		= true,
		result22		= true,
		result23		= true,
		result24		= true,
		result25		= true,
		result26		= true,
		hashtag			= "hashtag",
	}

	for i = 3, LI.QualityCount do
		for j = 1, 5 do
			defaults["result"..i..j] = true
		end

		defaults["result"..i.."6"] = false
	end

	for name, value in pairs(defaults) do
		if LI_Data.Options[name] == nil then
			LI_Data.Options[name] = value
		end
	end
end

function LI.CheckBootyFrame()
	if not (UnitSex("target") >= 3 and LI_Data.Options.nobosses) then
		local used, total = GetBagCount()

		for i = 1, 20 do
			local loot = false
			local texture, name, count, quality = GetBootyItemInfo(i)

			if name and quality then
				loot = not LI_Data.Options.nofilter and LI.GetItemLoot(name, GetBootyItemLink(i), nil, quality)

				if not loot and quality < LI_Data.Options.autoloot and quality > LI_Data.Options.autolootmin then
					loot = true
				end

				if loot and (type(loot) == "boolean" or (tonumber(loot) and loot ~= 1)) then
					ClickBootyItem(i)

					used = used + 1

					if used >= total then
						LI.RecheckBootyFrame = true
					end
				end
			end
		end

		GameTooltip1:Hide()
		GameTooltip2:Hide()

 		if LI_Data.Options.close and not LI.RecheckBootyFrame then
			BootyFrame:Hide()
		end
	end
end

function LI.ScanBag(id)
	if id and LI_Data and LI_Data.Options ~= nil then
		local name, count, invalid, bool

		for j = 1, 6 do
			local isLet, letTime = GetBagPageLetTime(j)

			if not letTime or letTime > 0 then
				for i = j * 30 - 29, j * 30 do
					check, _, name, count, invalid = GetBagItemInfo(i)

					if check == id then
						bool = true

						break
					end
				end
			end

			if bool then
				break
			end
		end

		local link = GetBagItemLink(id)

		if not bool or invalid or not name or name == "" or not link or LI.DetectPimpedItem(link) then
			return true
		end

		if not LI.intrunning then
			LI.History(link, UnitName("player"), 0)
			LI.GroupItemGot(link, UnitName("player"))
		end

		local quality = LI.GetQuality(link)

		local remove, stacksize = LI.GetItemLoot(name, link, nil, quality)

		if remove == 4 then
			if GetGuildInfo() ~= nil and GetCurrentWorldMapID() ~= 402 then
				LI.MoveGuildInfo = true

				PickupBagItem(id)
				GC_ItemButton_OnClick(GCB_Item1Button, "LBUTTON")
				GCB_OnOK()

				if CursorHasItem() and CursorItemType() == "bag" then
					local id = GetCursorItemInfo()
					local _, name = GetGoodsItemInfo(id)

					LI.AddData(name, 3, nil, false, true)

					PickupBagItem(id)
				end
			end

			return false

		elseif stacksize and stacksize ~= 0 then
			local numstack, slimstack, slimstackid = 0, count, id

			for j = 1, 6 do
				local isLet, letTime = GetBagPageLetTime(j)

				if not letTime or letTime > 0 then
					for i = j * 30 - 29, j * 30 do
						local slot, _, sname, scount = GetBagItemInfo(i)

						if name == sname then
							numstack = numstack + 1

							if scount < slimstack then
								slimstack = scount
								slimstackid = slot
							end
						end
					end
				end
			end

			if numstack > stacksize then
				LI.Trash = {name, slimstack, slimstackid}

				count = slimstack

				if LI.CheckIfAmmo(link) then
					count = count / (LI_Data.Options.countammo or 1)
				end
			else
				return false
			end

		elseif remove == 2 then
			LI.Trash = {name, count, id}

			if LI.CheckIfAmmo(link) then
				count = count / (LI_Data.Options.countammo or 1)
			end
		else
			return false
		end

		if LI_Data.Options.testing then
			LI.io(string.format(LI.Trans("TESTING_DELETION_MESSAGE"), "|cffff0050"..LI.Trash[1].."|r"))

			LI.Trash = nil

			return false
		end

		if count <= LI_Data.Options.askafter and not LI.CheckForQuest(name, link) then
			LI.DeleteItem(LI.Trash[3])

			LI.Trash = nil
		else
			StaticPopupDialogs.LOOTIT_DELETE_ITEMS.timeout = LI_Data.Options.secuwait
			StaticPopup_Show("LOOTIT_DELETE_ITEMS")
		end
	else
		LI.AddBagScan(id)
	end
end

function LI.DetectPimpedItem(link)
	LI.ResetTooltip()
	LootIt_GameTooltip:SetHyperLink(link)

	if string.find(LootIt_GameTooltipTextLeft1:GetText(), "+ %d+") then
		return true
	end

	for n = 2, 5 do
		local left = getglobal("LootIt_GameTooltipTextLeft" ..n):GetText()

		if left and string.find(left, "^"..TEXT("SYS_TOOLTIP_RUNE_LEVEL").."+") then
			local r, g, b = getglobal("LootIt_GameTooltipTextLeft" ..n):GetColor()

			if r == 0 and g == 1 and b == 0 then
				return true
			end
		end
	end

	return false
end

function LI.GetItemLoot(name, link, roll, quality)
	local value = LI_FilterAll[name] or LI_FilterChar[name]

	if value then
		if not roll then
			return value[1], value[3]
		else
			return value[2]
		end
	end

	if LI_ResultCache == nil or type(LI_ResultCache) ~= "table" or #LI_ResultCache >= 10000 then
		LI_ResultCache = {}

	elseif LI_ResultCache[link] ~= nil then
		if LI_ResultCache[link] == 0 then
			return nil, nil
		else
			return LI_ResultCache[link][1], LI_ResultCache[link][2]
		end
	end

	if type(link) == "string" then
		LI.ResetTooltip()
		LootIt_GameTooltip:SetHyperLink(link)

		if yaCIt then
			yaCIt.ShowTooltipBySelf(LootIt_GameTooltip)
		end

	elseif type(link) == "number" then
		LI.ResetTooltip()
		LootIt_GameTooltip:SetLootItem(link)

		if yaCIt then
			yaCIt.ShowTooltipBySelf(LootIt_GameTooltip)
		end
	end

	for star = 1, 4 do
		for filtername, value in pairs(LI_FilterCharSpezial) do
			local result, stacksize = LI.Filterchecker(filtername, value, name, roll, star, quality)

			if result then
				LI_ResultCache[link] = {result, stacksize}

				return result, stacksize
			end
		end

		for filtername, value in pairs(LI_FilterAllSpezial) do
			local result, stacksize = LI.Filterchecker(filtername, value, name, roll, star, quality)

			if result then
				LI_ResultCache[link] = {result, stacksize}

				return result, stacksize
			end
		end
	end

	if link then
		LI_ResultCache[link] = 0
	end
end

function LI.CheckTutorial(link, filter)
	local bool, name = false

	if link and link ~= "" then
		LootIt_GameTooltip:SetHyperLink(link)

		if yaCIt then
			yaCIt.ShowTooltipBySelf(LootIt_GameTooltip)
		end

		name = LootIt_GameTooltipTextLeft1:GetText()

		local quality = LI.GetQuality(link)

		for star = 1, 4 do
			bool = LI.Filterchecker(filter, {true, true, true}, name, true, star, quality)

			if bool then
				break
			end
		end
	end

	if string.len(filter) <= 3 then
		return LI.Trans("TUTORIAL_TOO_SHORT")

	elseif bool or filter == name then
		return "|cff00ff00"..LI.Trans("TUTORIAL_FOUND").."|r"
	else
		return "|cffff0000"..LI.Trans("TUTORIAL_NOT_FOUND").."|r"
	end
end

function LI.TutorialTipp(filter, firstline)
	local help = ""

	if string.find(filter, "*") then
		if firstline then
			help = LI.Trans("TUTORIAL_WILDCARD")
		else
			local name = LootIt_GameTooltip2TextLeft1:GetText()

			if string.find(name, " ") then
				help = help..string.sub(name, 1, string.find(name, " ") - 1).."*"
				help = help.."\n*"..string.sub(name, string.find(name, " ") + 1)
			end

			if string.len(name) > 5 then
				help = help.."\n"..string.sub(name, 1, 5).."*"
				help = help.."\n*"..string.sub(name, string.len(name) - 5)
			end
		end
	end

	if string.find(filter, "^%$") then
		if not string.find(filter, "%%") and not string.find(filter, "%[") then
			filter = string.gsub(filter, "%-", "%%-")
			filter = string.gsub(filter, ":", ".")
		end

		filter = string.gsub(filter, "*", "%.+")

		if firstline then
			help = LI.Trans("TUTORIAL_DOLLER")
		else
			local long, longer = {}, {}

			for i = 1, 20 do
				table.insert(long, getglobal("LootIt_GameTooltip2TextLeft"..i):GetText())
				table.insert(long, getglobal("LootIt_GameTooltip2TextRight"..i):GetText())
			end

			for _, word in ipairs(long) do
				if word ~= "" then
					table.insert(longer, word)
				end
			end

			local i, j = 4, #longer

			if string.len(filter) > 2 then
				while j > 1 do
					if string.find(longer[j], string.sub(filter, 2)) then
						help = help.."$"..table.remove(longer, j).."\n"

						i = i - 1

						if longer[j] then
							j = j + 1
						end
					end

					j = j - 1

					if i < 1 then
						break
					end
				end
			end

			if i > 0 then
				for j = 1, i do
					if #longer ~= 0 then
						help = help.."$"..table.remove(longer, math.random(1, #longer)).."\n"
					end
				end
			end
		end
	end

	if string.find(filter, "^!") or string.find(filter, "^§") then
		if firstline then
			help = LI.Trans("TUTORIAL_COMMUNITY")
		else
			local filtertable, i = LI.GenerateCommunityHelp(true), 4

			if string.len(filter) > 2 then
				for _, text in pairs(filtertable) do
					if text ~= "Separator" then
						local filters = ""

						if string.find(filter, "§") then
							filters = string.sub(text, 3)
						else
							filters = string.sub(text, 2)
						end

						if string.find(text, filter) then
							i = i - 1

							help = help..text.."\n"

							if i < 1 then
								break
							end
						end
					end
				end
			end

			j = #filtertable - i

			while i > 1 do
				i = i - 1
				help = help..table.remove(filtertable, math.random(1, j)).."\n"
			end
		end
	end

	if help == "" then
		if firstline then
			help = LI.Trans("TUTORIAL_ALL1")
		else
			help = string.format(LI.Trans("TUTORIAL_ALL2"), "|cffff0050*|r", "|cffff0050$|r", "|cffff0050!|r |cffff0050§|r", "|cffff0050&|r")
		end
	end

	return help
end

function LI.ConvertLootomaticData()
	local temp = LI_Data.Options.addmessage
	LI_Data.Options.addmessage = false

	if Lootomatic_Settings and not LI.convertedonce then
		if Lootomatic_Settings.ItemFilter ~= nil then
			local loo = {
				[1] = 1,
				[2] = 3,
				[3] = 2,
			}

			local rol = {
				[1] = 2,
				[2] = 3,
				[3] = 4,
				[4] = 1,
			}

			for _, data in ipairs(Lootomatic_Settings.ItemFilter) do
				if not string.find(data.Name, "%$") then
					LI.AddData(data.Name, loo[data.Loot - 1], rol[data.Roll - 1], data.Char == nil or data.Char == UnitName("player"))
				end
			end
		end

		LI.io("LOOTOMATIC_CONVERTED")
		LI.convertedonce = true
	end

	LI_Data.Options.addmessage = temp
end

LI.LastMaster = ""

function LI.RunOnUpdate(this, elapsedTime)
	if not LI.OK() then
		return
	end

	if GetNumPartyMembers() ~= 0 or GetNumRaidMembers() ~= 0 then
		if LI.ChatCooldown and elapsedTime then
			LI.ChatCooldown = LI.ChatCooldown - elapsedTime

			if LI.ChatCooldown <= 0 then
				LI.UseChat()

				LI.ChatCooldown = 5
			end
		end

		if IsPartyLeader("player") or UnitIsRaidLeader("player") then
			if LI.MakeValid ~= nil then
				if LI.MakeValid == false and LI.ValidMember == LI.LastMaster and LI.ValidThreshold == GetLootThreshold() and GetLootMethod() == "master" then
					LI.MakeValid = true

					LI.SendMsg("ValidSystemSetUp")

				elseif LI.IsValidSystem() and LI.LastMaster ~= LI.ValidMember then
					LI.Send("NoMoreValid")
				end
			end

			if GetLootMethod() ~= LI_Data.Options.ownMethod or (GetLootMethod() ~= "freeforall" and GetLootThreshold() ~= LI_Data.Options.ownThreshold) or (GetLootMethod() == "master" and LI.LastMaster ~= LI_Data.Options.ownMember) then
				LI.ApplyOwnLoot()
			end
		else
			if not this.loot or this.loot ~= GetLootMethod() then
				this.loot = GetLootMethod()

				LI.ShowLootChat()

			elseif not this.threshold or this.threshold ~= GetLootThreshold() then
				this.threshold = GetLootThreshold()

				LI.ShowLootChat()
			end

			LI.LastMaster = nil
		end
	else
		LI.MakeValid = nil
	end

	if #LI_BagScan ~= 0 and not LI.Trash and not StaticPopup_FindVisible("LOOTIT_DELETE_ITEMS") then
		local run = true

		while run do
			run = LI.ScanBag(table.remove(LI_BagScan))
		end

		if #LI_BagScan == 0 then
			LI.intrunning = nil
		end
	end

	local used, total = GetBagCount()

	if LI.RecheckBootyFrame and (used ~= total) and not LI.Trash then
		LI.RecheckBootyFrame = nil

		LI.CheckBootyFrame()
	end
end
