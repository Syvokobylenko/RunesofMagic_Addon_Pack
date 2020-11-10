-- last changes     by: Tinsus     at: 2016-05-03T21:34:07Z     project-version: v1.9beta1     hash: a4e935ec7027abd89cc14f35834ad4300003e980

local LI = _G.LI

function LI.ScrollBar(this, delta)
	if delta > 0 then
		this:SetValue(this:GetValue() + 1)
	else
		this:SetValue(this:GetValue() - 1)
	end
end

function LI.ScrollBarEnter(this)
	if this then
		local option = LI.Trans("OPTION_TOOLTIP_"..string.upper(LI_ScrollTable[this:GetID()]))

		LI.GameTooltip(this, "ANCHOR_BOTTOMRIGHT", 4, 0, option)
	end
end

LI_ScrollTable = {
	[1] = "delay",
	[2] = "askafter",
	[3] = "countammo",
	[4] = "secuwait",
	[5] = "historynum",
}

LI_DisplayTable = {
	"active",
	"minimap",
	"cursor",
	"close",
	"otherstyle",
	"range",
	"addmessage",
	"improvetooltips",
	"history",
	"testing",
	"nofilter",
	"removelessgold",
	"savequest",
	"statrota",
	"noscantip",
	"autodkp",
	"bagbutton",
	"readonly",
}

function LI.ScrollBarShow(this)
	if this and LI_Data and LI_Data.Options ~= nil then
		this:SetValueStepMode("INT")

		local store = LI_Data["Options"][LI_ScrollTable[this:GetID()]]

		if this:GetID() == 1 then
			this:SetMinMaxValues(0, 10)

		elseif this:GetID() == 2 then
			this:SetMinMaxValues(1, 60)

		elseif this:GetID() == 3 then
			this:SetMinMaxValues(1, 100)

		elseif this:GetID() == 4 then
			this:SetMinMaxValues(0, 30)

		elseif this:GetID() == 5 then
			this:SetMinMaxValues(5, 30)
		end

		this:SetValue(store)

		getglobal(this:GetName().."_Text"):SetText(string.format(LI.Trans("OPTION_HEADLINE_"..string.upper(LI_ScrollTable[this:GetID()])), LI_Data["Options"][LI_ScrollTable[this:GetID()]]))
	end
end

function LI.ScrollBarSwapBar(this)
	if LI_Data and LI_Data.Options then
		LI_Data["Options"][LI_ScrollTable[this:GetID()]] = this:GetValue()

		getglobal(this:GetName().."_Text"):SetText(string.format(LI.Trans("OPTION_HEADLINE_"..string.upper(LI_ScrollTable[this:GetID()])), LI_Data["Options"][LI_ScrollTable[this:GetID()]]))
	end
end

function LI.MiniTooltipShow(this)
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT", 9, 0)
	GameTooltip:SetText("LootIt! "..LI.version, 1, 1, 1)
	GameTooltip:AddLine("")
	GameTooltip:AddLine(LI.Trans("ADDONMANAGER_DESCRIPTION"))
	GameTooltip:AddLine("")
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95)
	GameTooltip:Show()
end

function LI.GetQualityString(quality)
	if quality == 0 then
		return "|cff".."ffffff"..TEXT("GENERAL").."|r"

	elseif LI.QualityColors[quality] ~= nil then
		return "|cff"..LI.QualityColors[quality]..TEXT("ITEM_QUALITY"..quality.."_DESC").."|r"
	end

	return "|cff".."aaaaaa"..LI.Trans("NEVER").."|r"
end

function LI.GetQuality(link)
	for i, v in pairs(LI.QualityColors) do
		if string.find(tostring(link), v) then
			return i - 1
		end
	end

	return -1
end

function LI.OptionsOnShow(this)
	LI.IntData()

	for i = 1, 22 do
		local that = getglobal(this:GetParent():GetName().."_CheckButton"..i)

		if that then
			that:Hide()

			if tonumber(that:GetID()) <= #LI_DisplayTable then
				that:Show()
			end
		end
	end

	for i = 1, 5 do
		local that = getglobal(this:GetParent():GetName().."_Slider"..i)

		if that then
			that:Hide()

			if tonumber(that:GetID()) <= table.getn(LI_ScrollTable) then
				that:Show()
			end
		end
	end
end

function LI.OptionButtonShow(this)
	if LI_Data and LI_Data.Options ~= nil then
		if LI_DisplayTable[this:GetID()] then
			local name = LI.Trans("OPTION_HEADLINE_"..string.upper(LI_DisplayTable[this:GetID()]))

			getglobal(this:GetName().."_Text"):SetText(name)

			local bool = LI_Data["Options"][LI_DisplayTable[this:GetID()]]

			this:SetChecked(bool or false)
		else
			this:Hide()
		end
	end
end

function LI.OptionButtonClick(this)
	if LI_DisplayTable[this:GetID()] then
		LI_Data["Options"][LI_DisplayTable[this:GetID()]] = not LI_Data["Options"][LI_DisplayTable[this:GetID()]]
	end

	LI.IntData()
	LI.Hook_Tooltips()

	LI.OnEvent(nil, "PARTY_MEMBER_CHANGED")
end

function LI.OptionButtonEnter(this)
	if LI_DisplayTable[this:GetID()] then
		LI.GameTooltip(this, "ANCHOR_BOTTOMRIGHT", 4, 0, "OPTION_TOOLTIP_"..string.upper(LI_DisplayTable[this:GetID()]))
	end
end

function LI.GameTooltip(this, anchor, x, y, text, r, g, b)
	GameTooltip:SetOwner(this, anchor or "ANCHOR_BOTTOMRIGHT", x or 4, y or 0)
	GameTooltip:SetText(LI.Trans(text), r, g, b)

	GameTooltip:Show()
end

function LI.DropTab_Receive(this)
	if this:GetParent().itemname ~= nil then
		local x = string.gsub(this:GetName(), "^.*_", "")
		local loot = tonumber(string.sub(x, 1, 1))
		local roll = tonumber(string.sub(x, 2))

		if loot == 0 and roll == 0 then
			LI.DelData(this:GetParent().itemname)
			this:GetParent():Hide()

			return
		end

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

		if loot == 0 then
			loot = nil
		else
			loot = loo[loot]
		end

		if roll == 0 then
			roll = nil
		else
			roll = rol[roll]
		end

		LI.AddData(this:GetParent().itemname, loot, roll, IsCtrlKeyDown())

		this:GetParent():Hide()
	end
end

function LI.DropTab_Display(this)
	local parent = this:GetParent():GetName()
	local x = string.gsub(this:GetName(), "^.*_","")
	local loot = tonumber(string.sub(x, 1, 1))
	local roll = tonumber(string.sub(x, 2))

	local RollTextures = {
		[1] = "Interface/Addons/LootIt/Textures/roll-pass",
		[2] = "Interface/Addons/LootIt/Textures/roll-greed",
		[3] = "Interface/Addons/LootIt/Textures/roll-need",
		[4] = "Interface/Addons/LootIt/Textures/roll-manual",
	}

	local LootTextures = {
		[1] = "Interface/Addons/LootIt/Textures/loot-dontloot",
		[2] = "Interface/Addons/LootIt/Textures/loot-loot",
		[3] = "Interface/Addons/LootIt/Textures/loot-drop",
	}

	if roll == 0 then
		getglobal(parent.."_RollIcon"):Hide()
		getglobal(parent.."_RollText"):Hide()
	else
		getglobal(parent.."_RollIcon"):Show()
		getglobal(parent.."_RollText"):Show()
		getglobal(parent.."_RollIcon"):SetFile(RollTextures[roll])

		local text

		if roll == 1 then
			text = TEXT("SYS_GIVE_UP")

		elseif roll == 2 then
			text = LI.GROUPLOOT_GREED

		elseif roll == 3 then
			text = LI.GROUPLOOT_ROLL

		elseif roll == 4 then
			text = LI.Trans("MANUAL")
		end

		getglobal(parent.."_RollText"):SetText(text)
	end

	if loot == 0 then
		getglobal(parent.."_LootIcon"):Hide()
		getglobal(parent.."_LootText"):Hide()
	else
		getglobal(parent.."_LootIcon"):Show()
		getglobal(parent.."_LootText"):Show()
		getglobal(parent.."_LootIcon"):SetFile(LootTextures[loot])

		local text

		if loot == 1 then
			text = LI.Trans("MANUAL")

		elseif loot == 2 then
			text = LI.Trans("COLLECT")

		elseif loot == 3 then
			text = LI.Trans("DISCARD")
		end

		getglobal(parent.."_LootText"):SetText(text)
	end

	if roll == 0 and loot == 0 then
		getglobal(parent.."_LootMarker"):Hide()
		getglobal(parent.."_RollMarker"):Hide()
		getglobal(parent.."_Remove"):Show()
	else
		getglobal(parent.."_Remove"):Hide()
		getglobal(parent.."_LootMarker"):Show()
		getglobal(parent.."_LootMarker"):ClearAllAnchors()
		getglobal(parent.."_LootMarker"):SetAnchor("LEFT", "LEFT", getglobal(parent.."_"..loot.."0"), -1, 0)
		getglobal(parent.."_RollMarker"):Show()
		getglobal(parent.."_RollMarker"):ClearAllAnchors()
		getglobal(parent.."_RollMarker"):SetAnchor("TOP", "TOP", getglobal(parent.."_0"..roll..""), 0, -1)
	end

	getglobal(parent.."_Itemname"):SetText(this:GetParent().itemname)
end

function LI.DropTab_OnShow(this)
	local scale = GetUIScale() or 1
	local x, y = GetCursorPos()

	x = x / scale
	y = y / scale

	if x <= 164 then
		x = 164

	elseif x >= GetScreenWidth() - 164 then
		x = GetScreenWidth() - 164
	end

	if y <= 172 then
		y = 172

	elseif y >= GetScreenHeight() - 172 then
		y = GetScreenHeight() - 172
	end

	this:ClearAllAnchors()
	this:SetAnchor("BOTTOMLEFT", "TOPLEFT", UIParent, x, y)

	getglobal(this:GetName().."_LootText"):SetText(LI.Trans("LOOT"))
	getglobal(this:GetName().."_RollText"):SetText(LI.Trans("ROLL"))
	getglobal(this:GetName().."_Remove"):SetText(TEXT("C_CHANNEL_KICK"))

	if not this.itemname then
		this.itemname = LI.AddCursorItem()
	end

	getglobal(this:GetName().."_Itemname"):SetText(this.itemname)

	getglobal(this:GetName().."_LootIcon"):Hide()
	getglobal(this:GetName().."_LootText"):Hide()
	getglobal(this:GetName().."_RollIcon"):Hide()
	getglobal(this:GetName().."_RollText"):Hide()
	getglobal(this:GetName().."_LootMarker"):Hide()
	getglobal(this:GetName().."_RollMarker"):Hide()
end

function LI.DropTab_OnUpdate(this, elapsedTime)
	if not this.timer then
		this.timer = 0
	else
		this.timer = this.timer + elapsedTime

		if this.timer <= 0.1 then
			elapsedTime = this.timer
			this.timer = nil
		else
			return
		end
	end

	local x, y = this:GetPos()
	local a, b = this:GetRealSize()
	local u, v = GetCursorPos()

	if not (x < u and u < x + a and y < v and v < y + b) then
		if not this.inside then
			this.inside = 1.5

		else
			this.inside = this.inside - elapsedTime

			if this.inside <= 0 then
				this:Hide()
			end
		end
	end
end

function LI.ShowLootChat()
	local text

	if GetLootMethod() == "alternate" then
		text = TEXT("PB_ASSIGN_BY_DICE")..": "..LI.GetQualityString(GetLootThreshold())

	elseif GetLootMethod() == "master" then
		text = "|cffff8000"..TEXT("LOOT_MASTER_LOOTER")..": |r"..LI.GetQualityString(GetLootThreshold())

	elseif GetLootMethod() == "freeforall" then
		text = "|cffff0000"..TEXT("LOOT_FREE_FOR_ALL").."|r"
	end

	LI.io(text)

	if ZZIB and ZZLibrary then
		ZZLibrary.Timer.Add({0.2,0},function() ZZLibrary.Event.Trigger("LootIt_Update_Event") end,"LootIt_ZZIB_Update")
	end
end

function LI.RollResultButtonClick(this)
	LI_Data.Options["result"..string.sub(this:GetName(), string.len(this:GetName()) - 1)] = not LI_Data.Options["result"..string.sub(this:GetName(), string.len(this:GetName()) - 1)]
end

function LI.RollResultButtonShow(this)
	if LI_Data and LI_Data.Options ~= nil then
		this:SetChecked(LI_Data.Options["result"..string.sub(this:GetName(), string.len(this:GetName()) - 1)])
	end
end

function LI.Hook_Tooltips()
	if LI_Data.Options.improvetooltips then
		GROUPLOOT_ROLL   = "|cffd2c85e"..LI.GROUPLOOT_ROLL  .."|r\n\n|cff80ffff[LootIt!]:|r "..LI.Trans("TOOLTIP_SAVE_ON_ROLL")
		GROUPLOOT_GREED  = "|cffd2c85e"..LI.GROUPLOOT_GREED .."|r\n\n|cff80ffff[LootIt!]:|r "..LI.Trans("TOOLTIP_SAVE_ON_ROLL")
		GROUPLOOT_CANCEL = "|cffd2c85e"..LI.GROUPLOOT_CANCEL.."|r\n\n|cff80ffff[LootIt!]:|r "..LI.Trans("TOOLTIP_SAVE_ON_ROLL")
	else
		GROUPLOOT_ROLL   = LI.GROUPLOOT_ROLL
		GROUPLOOT_GREED  = LI.GROUPLOOT_GREED
		GROUPLOOT_CANCEL = LI.GROUPLOOT_CANCEL
	end
end

function LI.EnterItemRow(this)
	local data = this.result

	local types = {}

	types[TEXT("SYS_GIVE_UP")] = 1
	types[LI.GROUPLOOT_GREED] = 2
	types[LI.GROUPLOOT_ROLL] = 3
	types[LI.Trans("DKP")] = 4

	local function comp(t1, t2)
		local types = {}

		types[TEXT("SYS_GIVE_UP")] = 1
		types[LI.GROUPLOOT_GREED] = 2
		types[LI.GROUPLOOT_ROLL] = 3
		types[LI.Trans("DKP")] = 4

		if t1.typ == t2.typ then
			if tonumber(t1.result) and tonumber(t1.result) > tonumber(t2.result) then
				return true
			else
				if t1.result == t2.result and t1.name < t2.name then
					return true
				end

				return false
			end
		else
			if types[t1.typ] > types[t2.typ] then
				return true
			else
				return false
			end
		end
	end

   	table.sort(data, comp)

	local function rstring(tab)
		return tab.typ.." "..tab.result.." "..tab.name
	end

	if #data >= 1 then
		GameTooltip:SetOwner(this, "ANCHOR_LEFT", -2, 0)

		local info   = ChatTypeInfo["SYSTEM"]
		local colors = {
			{info.r * 0.75,				info.g * 0.75,				info.b * 0.75			},
			{info.r,					info.g		,				info.b					},
			{1 - (1 - info.r) * 0.75,	1 - (1 - info.g) * 0.75,	1 - (1 - info.b) * 0.75	},
			{1 - (1 - info.r) * 0.75,	1 - (1 - info.g) * 0.75,	1 - (1 - info.b) * 0.75	},
		}

		for i, tab in ipairs(data) do
			if LI_DKP_Mode == nil or LI_DKP_Mode ~= 1 or (LI_DKP_Mode == 1 and (#data == GetNumPartyMembers() or #data == GetNumRaidMembers())) then
				if i == 1 then
					GameTooltip:SetText(rstring(tab), colors[types[tab["typ"]]][1], colors[types[tab["typ"]]][2], colors[types[tab["typ"]]][3])
				else
					GameTooltip:AddLine(rstring(tab), colors[types[tab["typ"]]][1], colors[types[tab["typ"]]][2], colors[types[tab["typ"]]][3])
				end
			end
		end
	end
end

function LI.AddDataItemRow(link, name, typ, result)
	for j = 1, 2 do
		local _, data3, name3 = ParseHyperlink(link)

		for i = 1, LI_Data.Options.historynum do
			local _, data2, name2 = ParseHyperlink(getglobal("LootIt_History_Item"..i.."_Name"):GetText())

			if (getglobal("LootIt_History_Item"..i.."_Name"):GetText() == link) or (j == 2 and name3 == name2) then
				local bool = false

				for _, play in ipairs(getglobal("LootIt_History_Item"..i)["result"]) do
					if play.name == name then
						bool = true

						break
					end
				end

				if not bool then
					table.insert(getglobal("LootIt_History_Item"..i)["result"], {name = name, typ = typ, result = result})

					return
				end
			end
		end
	end
end

function LI.ClickItemRow(this)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT", -2, 0)
	GameTooltip:SetHyperLink(getglobal(this:GetName().."_Name"):GetText())
end

function LI.UpdateItemRow(this, elapsedTime)
	if this.downtime then
		this.downtime = this.downtime - elapsedTime

		if this.downtime <= 0 then
			LI.ItemRow_DelItem(getglobal(this:GetName().."_Name"):GetText(), true)
		end
	end
end

function LI.ItemRow_AddItem(itemname, last)
	local autoremove = false

	local quality = LI.GetQuality(itemname)

	if not LI_Data.Options["result"..quality.."5"] then
		return
	end

	if LI_Data.Options["result"..quality.."6"] or (LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] and LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] <= 0) then
		autoremove = true
	end

	for i = 1, LI_Data.Options.historynum do
		if not getglobal("LootIt_History_Item"..i):IsVisible() then
			getglobal("LootIt_History_Item"..i.."_Name"):SetText(itemname)
			getglobal("LootIt_History_Item"..i)["result"] = {}
			getglobal("LootIt_History_Item"..i):Show()

			if autoremove then
				getglobal("LootIt_History_Item"..i)["downtime"] = 300
			end

			return
		end
	end

	if not last then
		LI.ItemRow_DelItem(LootIt_History_Item1_Name:GetText(), true)

		LI.ItemRow_AddItem(itemname, true)
	end
end

LI_ItemRow_Blacklist = {}

function LI.RemoveHash(link)
	return string.gsub(link, "(%x+ %x+) (%x+) (%x+ %x+ %x+ %x+ %x+ %x+ %x+ %x+) (%x+)", "%1 0 %3 0")
end

function LI.ItemRow_DelItem(itemname, manual, blacklist)
	if not manual then
		local quality = LI.GetQuality(itemname)

		if not LI_Data.Options["result"..quality.."6"] then
			if not LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] or (LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] and LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] > 0) then
				return
			end
		end
	end

	if blacklist then
		if not LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] then
			LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] = 0

			LI.io("BLACKLIST_ADDED")
		else
			LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] = LI_ItemRow_Blacklist[LI.RemoveHash(itemname)] - 1
		end
	end

	for k = 1, 2 do
		local _, _, name = ParseHyperlink(itemname)

		for i = 1, LI_Data.Options.historynum do
			local _, _, name2 = ParseHyperlink(getglobal("LootIt_History_Item"..i.."_Name"):GetText())

			if (getglobal("LootIt_History_Item"..i.."_Name"):GetText() == itemname) or (k == 2 and name == name2) then
				if i >= LI_Data.Options.historynum then
					getglobal("LootIt_History_Item"..LI_Data.Options.historynum.."_Name"):SetText("")
					_G["LootIt_History_Item"..LI_Data.Options.historynum]["result"] = nil
					_G["LootIt_History_Item"..LI_Data.Options.historynum]["downtime"] = nil
					getglobal("LootIt_History_Item"..LI_Data.Options.historynum):Hide()
				else
					for j = i, LI_Data.Options.historynum - 1 do
						if getglobal("LootIt_History_Item"..(j + 1)):IsVisible() then
							getglobal("LootIt_History_Item"..j.."_Name"):SetText(getglobal("LootIt_History_Item"..(j + 1).."_Name"):GetText())
							getglobal("LootIt_History_Item"..j)["result"] = getglobal("LootIt_History_Item"..(j + 1))["result"]
							getglobal("LootIt_History_Item"..j)["downtime"] = getglobal("LootIt_History_Item"..(j + 1))["downtime"]

							if j >= LI_Data.Options.historynum - 1 then
								getglobal("LootIt_History_Item"..LI_Data.Options.historynum.."_Name"):SetText("")
								_G["LootIt_History_Item"..LI_Data.Options.historynum]["result"] = nil
								_G["LootIt_History_Item"..LI_Data.Options.historynum]["downtime"] = nil
								getglobal("LootIt_History_Item"..LI_Data.Options.historynum):Hide()
							end
						else
							getglobal("LootIt_History_Item"..j.."_Name"):SetText("")
							getglobal("LootIt_History_Item"..j)["result"] = nil
							getglobal("LootIt_History_Item"..j)["downtime"] = nil
							getglobal("LootIt_History_Item"..j):Hide()

							return
						end
					end
				end
			end
		end
	end
end

function LI.AddCursorItem(bool)
	if CursorHasItem() and CursorItemType() == "bag" then
		local id = GetCursorItemInfo()
		local _, name = GetGoodsItemInfo(id)

		if bool ~= true then
			PickupBagItem(id)

			if bool ~= nil then
				name = GetBagItemLink(id)
			end
		end

		return name
	end
end
