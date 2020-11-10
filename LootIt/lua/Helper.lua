-- last changes     by: Tinsus     at: 2016-07-02T09:27:42Z     project-version: v1.9beta1     hash: eafe20edfe4fe4e78f770c249436eecdac101094

local LI = _G.LI

function LI.ApplyOwnLoot()
	if GetLootMethod() ~= LI_Data.Options.ownMethod then
		if LI_Data.Options.ownMethod == "master" then
			if not LI.CheckForMember(LI_Data.Options.ownMember) then
				LI_Data.Options.ownMember = UnitName("player")
			end

			SetLootMethod(LI_Data.Options.ownMethod, LI_Data.Options.ownMember, true)

			LI.LastMaster = LI_Data.Options.ownMember
		else
			SetLootMethod(LI_Data.Options.ownMethod or "alternate", nil, true)

			LI.LastMaster = nil
		end

	elseif GetLootThreshold() ~= LI_Data.Options.ownThreshold then
		SetLootThreshold(LI_Data.Options.ownThreshold or 0, true)

	elseif GetLootMethod() == "master" and LI_Data.Options.ownMember then
		if not LI.CheckForMember(LI_Data.Options.ownMember) then
			LI_Data.Options.ownMember = UnitName("player")
		end

		SetLootAssignMember(LI_Data.Options.ownMember, true)

		LI.LastMaster = LI_Data.Options.ownMember
	end

	if ZZIB and ZZLibrary then
		ZZLibrary.Event.Trigger("LootIt_Update_Event")
	end
end

function LI.SaveOwnLoot(method, threshold, name)
	if LI.IsValidSystem() then
		SendSystemMsg("|cffff0050LootIt!:|r "..LI.Trans("WARNING_DKP_CHANGE"))
	else
		LI_Data.Options.ownThreshold = threshold or GetLootThreshold()
		LI_Data.Options.ownMethod = method or GetLootMethod()
		LI_Data.Options.ownMember = (name or LI_Data.Options.ownMember) or UnitName("player")
	end
end

function LI.CheckForMember(name)
	local num, typ

	if GetNumRaidMembers() ~= 0 then
		num = 36
		typ = "raid"

	elseif GetNumPartyMembers() ~= 0 then
		num = GetNumPartyMembers()
		typ = "party"
	else
		return
	end

	for i = 1, num do
		if UnitName(typ..i) == LI_Data.Options.ownMember then
			return true
		end
	end
end

function LI.AddBagScan(arg1)
	if arg1 and arg1 ~= "" then
		local bool = false

		for _, key in ipairs(LI_BagScan) do
			if key == arg1 then
				bool = true

				break
			end
		end

		if not bool then
			table.insert(LI_BagScan, arg1)
		end
	end
end

function LI.PlaceFrames(options)
	if options then
		for i = 2, 6 do
			getglobal("LootIt_FrameMover_"..i):ClearAllAnchors()
			getglobal("LootIt_FrameMover_"..i):SetAnchor("TOPLEFT", "TOPLEFT", getglobal("LootIt_FrameMover_"..(i - 1)), 0, LootIt_FrameMover_1_Slider:GetValue())
		end
	end

	LI_LootFrame1:ClearAllAnchors()
	LI_LootFrame1:SetAnchor("TOPLEFT", "TOPLEFT", UIParent, LI_Data.Options.RollFrameX, LI_Data.Options.RollFrameY)

	GroupLootFrame1:ClearAllAnchors()
	GroupLootFrame1:SetAnchor("TOPLEFT", "TOPLEFT", UIParent, LI_Data.Options.RollFrameX, LI_Data.Options.RollFrameY)

	for i = 2, 6 do
		getglobal("LI_LootFrame"..i):ClearAllAnchors()
		getglobal("LI_LootFrame"..i):SetAnchor("TOPLEFT", "TOPLEFT", getglobal("LI_LootFrame"..(i - 1)), 0, LI_Data.Options.RollFrameD)

		getglobal("GroupLootFrame"..i):ClearAllAnchors()
		getglobal("GroupLootFrame"..i):SetAnchor("TOPLEFT", "TOPLEFT", getglobal("GroupLootFrame"..(i - 1)), 0, LI_Data.Options.RollFrameD)
	end

	if yBag then
        assert(yBagItem1)
		LootIt_BagButton:ClearAllAnchors()
		LootIt_BagButton:SetAnchor("BOTTOMRIGHT", "TOPLEFT", yBagItem1, 0, 0)

	elseif FlieBag then
        assert(FlieBagFrame)
        assert(FlieBagFrameCloseButton)
		LootIt_BagButton:ClearAllAnchors()
		LootIt_BagButton:SetAnchor("CENTER", "CENTER", FlieBagFrameCloseButton, -60, 1)

		FlieBagTitleText:ClearAllAnchors()
		FlieBagTitleText:SetAnchor("TOP", "TOP", FlieBagFrame, -45, 7)

	elseif CuteBag then
        assert(BagFrameCloseButton)
		LootIt_BagButton:ClearAllAnchors()
		LootIt_BagButton:SetAnchor("CENTER", "CENTER", BagFrameCloseButton, -27, 1)

	elseif zBag then
        assert(zBagBackgroundCloseButton)
		LootIt_BagButton:ClearAllAnchors()
		LootIt_BagButton:SetAnchor("CENTER", "CENTER", zBagBackgroundCloseButton, 30, 0)

	elseif SimpleBagFrame then
        assert(BagFrame)
		LootIt_BagButton:ClearAllAnchors()
		LootIt_BagButton:SetAnchor("TOPLEFT", "TOPLEFT", BagFrame, -2, 2)

	elseif LootIt_BagButton then
        assert(BagFrame)
		LootIt_BagButton:ClearAllAnchors()
		LootIt_BagButton:SetAnchor("TOPRIGHT", "TOPRIGHT", BagFrame, 0, 22)
	end

	LI.OnEvent(nil, "PARTY_MEMBER_CHANGED")
end

function LI.BagCheck(this)
	if yBag then
		if not BagFrame:IsVisible() and not yBag:IsVisible() then
			this:Hide()
		end

	elseif FlieBagFrame then
		if not BagFrame:IsVisible() and not FlieBagFrame:IsVisible() then
			this:Hide()
		end

	elseif zBag then
		if not BagFrame:IsVisible() and not zBag:IsVisible() then
			this:Hide()
		end
	else
		if not BagFrame:IsVisible() then
			this:Hide()
		end
	end
end

function LI.DeleteItem(slot)
	if CursorHasItem() then
		local typ = CursorItemType()

		if typ == "bag" then
			PickupBagItem(GetCursorItemInfo())
		else
			OnDrag_SkillButton(UI_SkillBook_SkillButton_1ItemButton, 1)
		end
	end

	PickupBagItem(slot)

	DeleteCursorItem()
end

LI_StaticKeep = {}

StaticPopupDialogs["LOOTIT_DELETE_ITEMS"] = {
	text = TEXT("DELETE_GARBAGE_ITEM"),
	button1 = TEXT("YES"),
	button2 = TEXT("NO"),
	whileDead = 1,
	exclusive = 1,
	showAlert = 1,
	hideOnEscape = 1,
	timeout = 60,
	OnShow = function(this)
		getglobal(this:GetName().."Text"):SetText(getglobal(this:GetName().."Text"):GetText().."\n\n"..LI.Trash[2].."x "..LI.Trash[1])
		StaticPopup_Resize(this, "LOOTIT_DELETE_ITEMS")

		if LI_StaticKeep[LI.Trash[1]] then
			StaticPopup_Hide("LOOTIT_DELETE_ITEMS")
		end
	end,
	OnHide = function(this)
		this.timeout = 60
		LI.Trash = nil
	end,
	OnCancel = function()
		LI_StaticKeep[LI.Trash[1]] = true
		LI.Trash = nil
	end,
	OnAccept = function()
		LI.DeleteItem(LI.Trash[3])

		LI.Trash = nil
	end,
	OnUpdate = function(this)
		getglobal(this:GetName().."Button1"):SetText(TEXT("YES"))
		getglobal(this:GetName().."Button2"):SetText(TEXT("NO" ).." ("..string.format("%.0f", math.ceil(this.timeleft))..")")
	end,
}

function LI.CheckForQuest(name, link)
	if LI_Data.Options.savequest then
		LI.ResetTooltip()
		LootIt_GameTooltip:SetHyperLink(link)

		local strings = {
			"SYS_UNIQUE",		-- Einzigartiger Gegenstand
			"GIF_ICON_DESC16",	-- Quest-Gegenstand
			"SYS_ITEMTYPE_01",	-- Quest-Gegenstand
			"SYS_ACCOUNT_ITEM",	-- Item-Shop-Gegenstand
			"UI_TITLE_TYPE_2_5",-- Item-Shop-Gegenstände
		}

		for i = 2, 7 do
			for _, typ in ipairs(strings) do
				if string.find(getglobal("LootIt_GameTooltipTextRight"..i):GetText(), TEXT(typ)) then
					if not LI_FilterAll[name] and not LI_FilterChar[name] then
						return true
					else
						return false
					end
				end
			end
		end
	end

	return false
end

function LI.CheckIfAmmo(link)
	LI.ResetTooltip()
	LootIt_GameTooltip:SetHyperLink(link)

	for i = 4, 6 do
		if string.find(getglobal("LootIt_GameTooltipTextRight"..i):GetText(), TEXT("SYS_WEAPON_POS04")) then
			return true
		end
	end

	return false
end

function LI.GetPriceByName(name, link)
	if link then
		LI.ResetTooltip()
		LootIt_GameTooltip:SetHyperLink(link)
	end

	for i = 1, 20 do
		local text = getglobal("LootIt_GameTooltipTextLeft"..i):GetText()
		local _, num = string.find(text, TEXT("SYS_ITEM_COST"))

		if num then
			return tonumber(LI.GetPrice(string.sub(text, num + 1)))
		end
	end
end

function LI.GetPrice(str)
	local val = ""
	local num = string.find(str, "%d")

	while num do
		val = val..string.sub(str, num, num)
		str = string.sub(str, num + 1)
		num = string.find(str, "%d")
	end

	return tonumber(val)
end

function LI.GetFltPrice(str)
	local _, _, val = string.find(str, "(%d+)")

	return val and tonumber(val) or 0
end

function LI.ResetTooltip()
	for n = 1, 20 do
		getglobal("LootIt_GameTooltipTextLeft" ..n):SetText("")
		getglobal("LootIt_GameTooltipTextRight"..n):SetText("")
	end
end

function LI.CheckRollFrame(this)
	if LI.Active() and this.lootIndex ~= nil then
		local name, icon, itemCount, quality = GetLootRollItemInfo(this.lootIndex)

		if name then
			local roll = LI.GetItemLoot(name, this.lootIndex, true, quality)

			if not roll then
				if quality < LI_Data.Options.autopass and quality > LI_Data.Options.autopassmin then
					roll = 2

				elseif quality < LI_Data.Options.autogreed and quality > LI_Data.Options.autogreedmin then
					roll = 3
				end
			end

			if roll then
				local frame = getglobal("LootIt_"..this:GetName().."_Highlight")

				local mode

				frame.lootIndex = this.lootIndex

				frame:ClearAllAnchors()

				if roll == 2 then
					frame:SetAnchor("CENTER", "CENTER", getglobal(this:GetName().."CancelButton"), 0, 0)
					frame:Show()
					mode = "pass"

				elseif roll == 3 then
					frame:SetAnchor("CENTER", "CENTER", getglobal(this:GetName().."GreedButton"), 0, 0)
					frame:Show()
					mode = "greed"

				elseif roll == 4 then
					frame:SetAnchor("CENTER", "CENTER", getglobal(this:GetName().."RollButton"), 0, 0)
					frame:Show()
					mode = "roll"
				else
					frame:Hide()
				end

				frame.roll = mode
			end
		end
	end
end

LI_StatRota = {}

function LI.GetGroupID()
	local con = {}

	if GetNumRaidMembers() ~= 0 then
		for i = 1, 36 do
			local name = UnitName("raid"..i)

			if name ~= nil and name ~= "" then
				table.insert(con, name)
			end
		end

	elseif GetNumPartyMembers() ~= 0 then
		for i = 1, 5 do
			local name = UnitName("party"..i)

			if name ~= nil and name ~= "" then
				table.insert(con, name)
			end
		end

		table.insert(con, UnitName("player"))
	end

	if table.getn(con) >= 2 then
		table.sort(con)

		return table.concat(con)
	end
end

function LI.BuildGroupTable(ID)
	LI_StatRota[ID] = {}

	if GetNumRaidMembers() ~= 0 then
		for i = 1, 36 do
			local name = UnitName("raid"..i)

			if name ~= nil and name ~= "" then
				LI_StatRota[ID][name] = 0
			end
		end

	elseif GetNumPartyMembers() ~= 0 then
		for i = 1, 5 do
			local name = UnitName("party"..i)

			if name ~= nil and name ~= "" then
				LI_StatRota[ID][name] = 0
			end
		end

		LI_StatRota[ID][UnitName("player")] = 0
	end
end

LI_RotaItemCache = {}

function LI.CheckForRotaItem(link)
	if LI_RotaItemCache[link] ~= nil then
		return LI_RotaItemCache[link]
	end

	LI.ResetTooltip()
	LootIt_GameTooltip:SetHyperLink(link)

	local a, b, c = LootIt_GameTooltipTextLeft1:GetColor()

	if tostring(a) == "0.7843137383461" and tostring(b) == "0.019607843831182" and tostring(c) == "0.97254902124405" then -- dosn't work as nubers
		for i = 5, 20 do
			local a, b, c = getglobal("LootIt_GameTooltipTextLeft"..i):GetColor()

			if a == 1 and b == 1 and c == 0 and string.find(getglobal("LootIt_GameTooltipTextLeft"..i):GetText(), "^+") then
				LI_RotaItemCache[link] = true

				return true
			end
		end
	end

	LI_RotaItemCache[link] = false
end

LI_LastRota = ""
LI_HistoryStamp = {}

function LI.History(item, to, result, val)
	local hash = tostring(item)..tostring(to)..tostring(result)..tostring(val)

	if not tonumber(LI_HistoryStamp[hash]) or GetTickCount() - LI_HistoryStamp[hash] >= 1000 then
		LI_HistoryStamp[hash] = GetTickCount()
	else
		local del = {}
		local stamp = GetTickCount()

		for name, value in pairs(LI_HistoryStamp) do
			if stamp - value >=  1000 then
				table.insert(del, name)
			end
		end

		for _, value in ipairs(del) do
			LI_HistoryStamp[value] = nil
		end

		return
	end

	if item and LI.Active() then
		if LI_Data.Options.history then
			if to == 0 then
				LI.ItemRow_AddItem(item)

			elseif result == 0 then
				LI.HistoryAddWinner(item, to)
				LI.PlayerHistory(to, item)
				LI.ItemRow_DelItem(item)
			else
				LI.AddDataItemRow(item, to, result, val)
			end
		end

		local ID = LI.GetGroupID()

		if LI_Data.Options.statrota and ID and LI.CheckForRotaItem(item) then
			if not LI_StatRota[ID] then
				LI.BuildGroupTable(ID)
			end

			if to == 0 and item ~= LI_LastRota then
				local guys = {}

				for name, i in pairs(LI_StatRota[ID]) do
					table.insert(guys, {name = name, number = i})
				end

				local function comp(t1, t2)
					if (t1.number == t2.number and t1.name < t2.name) or t1.number < t2.number then
						return true
					else
						return false
					end
				end

				table.sort(guys, comp)

				local slit = {}

				for _, t in pairs(guys) do
					table.insert(slit, t.name)
				end

				LI.io(string.format(LI.Trans("NEXTSTAT"), "|cffff0050"..slit[1].."|r", table.concat(slit, " - ")))

				LI_LastRota = item

			elseif result == 0 then
				LI_StatRota[ID][to] = LI_StatRota[ID][to] + 1
			end
		end
	end
end

function LI.HistoryAddWinner(link, name)
	for j = 1, 2 do
		for i = 1, 30 do
			if not getglobal("LootIt_History_Item"..i)["result"] then
				break
			end

			local _, _, name2 = ParseHyperlink(getglobal("LootIt_History_Item"..i.."_Name"):GetText())
			local _, _, name3 = ParseHyperlink(link)

			if (getglobal("LootIt_History_Item"..i.."_Name"):GetText() == link) or (j == 2 and name2 == name3) then
				local slot, once = nil, true

				for k, play in ipairs(getglobal("LootIt_History_Item"..i)["result"]) do

					if play.name == name then
						slot = k
					end

					if string.byte(play.name, 1) == 26 then
						once = false
					end
				end

				if slot and once then
					getglobal("LootIt_History_Item"..i)["result"][slot]["name"] = string.char(26)..name

					return
				end
			end
		end
	end
end

function LI.PlayerHistory(name, item)
	if not LI_PlayerHistory then
		LI_PlayerHistory = {}
	end

	if item and name then
		if not LI_PlayerHistory[name] then
			LI_PlayerHistory[name] = {}

			for i = 0, LI.QualityCount do
				LI_PlayerHistory[name][i] = {}
			end
		end

		local quality = LI.GetQuality(item)

		if LI_PlayerHistory[name] and LI_PlayerHistory[name][quality] then
			for _, check in ipairs(LI_PlayerHistory[name][quality]) do
				if check == item then
					return
				end
			end

			table.insert(LI_PlayerHistory[name][quality], 1, item)

			if LI_PlayerHistory[name][quality][33] then
				LI_PlayerHistory[name][quality][33] = nil
			end
		end
	end
end

function LI.ScanFullBag()
	for i = 1, 6 do
		local isLet, letTime = GetBagPageLetTime(i)

		if not letTime or letTime > 0 then
			for j = i * 30 - 29, i * 30 do
				LI.AddBagScan(GetBagItemInfo(j))
			end
		end
	end
end

LI_PriceCache = {}

function LI.RunGoldDigger()
	local used, total = GetBagCount()

	if total - used <= 2 then
		local cheap = {}

		for j = 1, 6 do
			local isLet, letTime = GetBagPageLetTime(j)

			if not letTime or letTime > 0 then
				for i = j * 30 - 29, j * 30 do
					local slot, _, sname, scount = GetBagItemInfo(i)
					local link = GetBagItemLink(slot)
					local quality = LI.GetQuality(link)
					local loot = LI.GetItemLoot(sname, link, nil, quality)

					if sname and sname ~= "" and not loot then
						local price = LI_PriceCache[link]

						if price == nil then
							price = LI.GetPriceByName(sname, link)

							LI_PriceCache[link] = price
						end

						if price and price ~= 0 then
							table.insert(cheap, {sname, slot, scount, price * (scount or 1), link})
							LI.Log("added Item for check"..tostring(sname))
						end
					end
				end
			end
		end

		if #cheap >= 1 then
			local min = cheap[1]

			for _, mirror in ipairs(cheap) do
				if mirror[4] < min[4] then
					min = mirror
					LI.Log("cheapest is "..tostring(min[1]))
				end
			end

			LI.Log("Will be deleted: "..tostring(min[1]))

			if LI_Data.Options.testing then
				LI.io(string.format(LI.Trans("TESTING_DELETION_MESSAGE"), "|cffff0050"..min[1].."|r"))

				return
			end

			if LI.CheckIfAmmo(min[5]) then
				min[3] = min[3] / (LI_Data.Options.countammo or 1)
			end

			if min[3] <= LI_Data.Options.askafter and not LI.CheckForQuest(min[1], min[5]) then
				LI.DeleteItem(min[2])
			else
				LI.Trash = {min[1], min[3], min[2]}

				StaticPopupDialogs.LOOTIT_DELETE_ITEMS.timeout = LI_Data.Options.secuwait
				StaticPopup_Show("LOOTIT_DELETE_ITEMS")
			end
		else
			LI_Data.Options.removelessgold = false

			LI.io("GOLDDIGGER_AUTOINACTIVE")
		end
	end
end

function LI.explode(delimiter, text)
	local pos = 0
	local result = {}

	for a, b in function() return string.find(text, delimiter, pos, true) end do
		table.insert(result, string.sub(text, pos, a - 1))
		pos = b + 1
	end

	table.insert(result, string.sub(text, pos))

	return result
end