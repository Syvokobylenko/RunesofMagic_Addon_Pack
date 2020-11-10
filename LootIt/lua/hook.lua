-- last changes     by: Tinsus     at: 2016-06-08T17:41:44Z     project-version: v1.9beta1     hash: 581130a7e029023b0f14f27b36f8e4a18ab725b6

local LI = _G.LI

LI.Hook_functions = {
	"SendWarningMsg",
	"UIParent_OnEvent",
	"GroupLootFrame_OnShow",
	"RollOnLoot",
	"Hyperlink_Assign",
	"ChatFrame_OnEvent",
	"BagFrame_OnShow",
	"BagItemButton_OnClick",
	"UnitPopop_ShowMenu",
	"SetLootMethod",
	"SetLootThreshold",
	"SetLootAssignMember",
	"LootFrameItem_OnClick",
}

function LI.SetHooks()
	if not LI.hooked then
		if Sol then
			for _, name in ipairs(LI.Hook_functions) do
				if not LI["Hooked_"..name] then
					Sol.hooks.Hook("LootIt", name, LI[name])
					LI["Hooked_"..name] = Sol.hooks.GetOriginalFn("LootIt", name)
				end
			end
		else
			for _, name in ipairs(LI.Hook_functions) do
				LI["Hooked_"..name] = _G[name]
				_G[name] = LI[name]
			end
		end

		if not LI.GROUPLOOT_ROLL then
			LI.GROUPLOOT_ROLL = GROUPLOOT_ROLL
			LI.GROUPLOOT_GREED = GROUPLOOT_GREED
			LI.GROUPLOOT_CANCEL = GROUPLOOT_CANCEL
		end

		LI.hooked = true
	end
end

function LI.SendWarningMsg(text)
	if LI.MoveGuildInfo and text == TEXT("MSG_GUILDCONTRIBUTION_SUCCESS") then
		LI.MoveGuildInfo = nil

		return LI.io(text)
	else
		return LI.Hooked_SendWarningMsg(text)
	end
end

function LI.UIParent_OnEvent(this, event)
	if event == "DELETE_QUESETITEM_CONFIRM" then
		StaticPopup_Show("DELETE_ITEM", arg1)
	else
		return LI.Hooked_UIParent_OnEvent(this, event)
	end
end

function LI.GroupLootFrame_OnShow(this)
	LI.Hooked_GroupLootFrame_OnShow(this)

	LI.CheckRollFrame(this)
end

function LI.RollOnLoot(frame, mode, bool)
	LI.Hooked_RollOnLoot(frame, mode)

	local name = GetLootRollItemInfo(frame)

	if name and not bool and IsShiftKeyDown() then
		local roll

		if mode == "roll" then
			roll = 4

		elseif mode == "greed" then
			roll = 3

		else
			roll = 2
		end

		LI.AddData(name, nil, roll, IsCtrlKeyDown())
	end
end

function LI.Hyperlink_Assign(link, key)
	LI.Hooked_Hyperlink_Assign(link, key)

	local type, data, name = ParseHyperlink(link)

	if key == "RBUTTON" then
		if type == "item" then
			local info = {
				notCheckable = 1,
				text = "|cff80ffff[LootIt!]:|r "..LI.Trans("ADD_LINK"),
				arg1 = link,
				func = function(this)
					LootIt_GameTooltip:SetHyperLink(this.arg1)

					if yaCIt then
						yaCIt.ShowTooltipBySelf(LootIt_GameTooltip)
					end

					LootIt_ChatDrop.itemname = LootIt_GameTooltipTextLeft1:GetText()

					LootIt_ChatDrop:Show()
				end,
			}

			UIDropDownMenu_AddButton(info, 1)
			UIDropDownMenu_Refresh(ChatFrameDropDown)

			if LootIt_FilterHelp:IsVisible() then
				local info = {
					notCheckable = 1,
					text = "|cff80ffff[LootIt!]:|r "..LI.Trans("ADD_LINK_HELP"),
					arg1 = link,
					func = function(this)
						LootIt_FilterHelp_Itemname_Text:SetText(this.arg1)
					end,
				}

				UIDropDownMenu_AddButton(info, 1)
				UIDropDownMenu_Refresh(ChatFrameDropDown)
			end

			local info = {
				notCheckable = 1,
				text = "|cff80ffff[LootIt!]:|r "..LI.Trans("CHECK_DATABASE"),
				arg1 = link,
				func = function(this)
					local a = string.gsub(data, "%%2520", " ")

					GC_OpenWebRadio("http://rom-welten.de/database/sec/database/view.php?link="..a)
				end,
			}

			UIDropDownMenu_AddButton(info, 1)
			UIDropDownMenu_Refresh(ChatFrameDropDown)

		elseif type == "npc" then
			local info = {
				notCheckable = 1,
				text = "|cff80ffff[LootIt!]:|r "..LI.Trans("CHECK_DATABASE"),
				arg1 = link,
				func = function(this)
					GC_OpenWebRadio("http://rom-welten.de/database/sec/database/view.php?id="..data)
				end,
			}

			UIDropDownMenu_AddButton(info, 1)
			UIDropDownMenu_Refresh(ChatFrameDropDown)

		elseif type == "quest" then
			LootIt_Dropdown_Quest.link = link
			LootIt_Dropdown_Quest.data = data
			LootIt_Dropdown_Quest.name = name

			local x, y = GetCursorPos()

			UIDropDownMenu_SetAnchor(LootIt_Dropdown_Quest, x / (GetUIScale() or 1), y / (GetUIScale() or 1), "TOPLEFT", "TOPLEFT", UIParent)
			UIDropDownMenu_SetWidth(LootIt_Dropdown_Quest, 10)
			UIDropDownMenu_Initialize(LootIt_Dropdown_Quest, LI.MiniConfigGenerate_Quest)
			ToggleDropDownMenu(LootIt_Dropdown_Quest)

		elseif type == "skill" then
			LootIt_Dropdown_Quest.link = link
			LootIt_Dropdown_Quest.data = data
			LootIt_Dropdown_Quest.name = name

			local x, y = GetCursorPos()

			UIDropDownMenu_SetAnchor(LootIt_Dropdown_Skill, x / (GetUIScale() or 1), y / (GetUIScale() or 1), "TOPLEFT", "TOPLEFT", UIParent)
			UIDropDownMenu_SetWidth(LootIt_Dropdown_Skill, 10)
			UIDropDownMenu_Initialize(LootIt_Dropdown_Skill, LI.MiniConfigGenerate_Skill)
			ToggleDropDownMenu(LootIt_Dropdown_Skill)
		end
	end
end

function LI.ChatFrame_OnEvent(this, event)
	if event == "CHAT_MSG_SYSTEM" and arg1 then
		local block = {
			"^"..TEXT("SYS_LOOT_ALTERNATE").."$",
			"^"..TEXT("SYS_LOOT_FREEFORALL").."$",
			"^"..string.gsub(TEXT("SYS_LOOT_MASTER_LOOTER"), "%[%%s%]", ""),
		}

		for _, str in ipairs(block) do
			if string.match(arg1, str) then
				return
			end
		end

		if string.find(arg1, "^%[[^%]]*%] : ") then
			local itemstring = string.gsub(arg1, "^.*(|H.*|h).*$", "%1")

			local roll, typ
			local types = {TEXT("SYS_GIVE_UP"), LI.GROUPLOOT_GREED, LI.GROUPLOOT_ROLL, LI.Trans("DKP")}

			for i = 1, 4 do
				typ = types[i]
				roll = i

				if string.find(arg1, typ) then
					break
				end
			end

			if roll == 4 then
				roll = 2
			end

			local player = string.gsub(arg1, "^%[([^%]]*)%].*$", "%1")
			local result = string.gsub(arg1, "^.*|h *", "")

			LI.History(itemstring, player, types[roll], result)

			local quality = LI.GetQuality(itemstring)

			if LI_Data.Options["result"..quality..roll] then
				if LI_Data.Options.otherstyle then
					local info   = ChatTypeInfo["SYSTEM"]
					local colors = {
						{info.r * 0.75,				info.g * 0.75,				info.b * 0.75			},
						{info.r,					info.g		,				info.b					},
						{1 - (1 - info.r) * 0.75,	1 - (1 - info.g) * 0.75,	1 - (1 - info.b) * 0.75	},
					}

					this:AddMessage(itemstring.." - |Hplayer:"..player.."|h["..player.."]|h "..types[roll].." "..result, colors[roll][1], colors[roll][2], colors[roll][3])

					return
				end
			else
				return
			end

		elseif string.find(arg1, TEXT("SYS_PARTY_TREASURE")) then
			local begin = string.len(TEXT("SYS_PARTY_TREASURE"))
			local item = string.sub(arg1, begin + 2)

			LI.History(item, 0)

			LI.GroupItem(item)

			local quality = LI.GetQuality(item)

			if not LI_Data.Options["result"..quality.."4"] then
				return
			end
		else
			local name = string.find(TEXT("SYS_PARTY_GET_ITEM"), "%%s")
			local link = string.find(TEXT("SYS_PARTY_GET_ITEM"), "%%s", name + 1)
			local trash = string.sub(TEXT("SYS_PARTY_GET_ITEM"), name + 2, link - 1)
			local trash, ending = string.find(arg1, trash)

			if trash then
				local name = string.sub(arg1, name, trash - 1)
				local link = string.sub(arg1, ending + 1)

				LI.History(link, name, 0)
				LI.GroupItemGot(link, name)

				local quality = LI.GetQuality(link)

				if not LI_Data.Options["result"..quality.."4"] then
					return
				end
			end
		end

	elseif event == "CHAT_MSG_SYSTEM_VALUE" and arg1 and string.find(arg1, string.gsub(string.gsub(TEXT("SYS_ROLL_POINT"), "[%%d%%s]", "%.*"), "[%-%(%)]", "%.")) then
		local name, nameending = string.find(TEXT("SYS_ROLL_POINT"), "%%s")
		local number, numberending = string.find(TEXT("SYS_ROLL_POINT"), "%%d")
		local trash, trashending = string.find(arg1, string.sub(TEXT("SYS_ROLL_POINT"), nameending + 1, number - 1))

		name = string.sub(arg1, name, trash - 1)

		number = string.sub(arg1, trashending + 1)
		number = string.sub(number, 1, string.find(number, " ") - 1)
		number = string.gfind(number, "%d+")
		number = number()

		LI.ManageDices(name, number)

		if LI.IsValidSystem() then
			return
		end
	end

	if event == "CHAT_MSG_PARTY" and arg1 and arg4 then
		if not LI.DetectDiceShout(arg1, arg4) then
			return
		end
	end

	return LI.Hooked_ChatFrame_OnEvent(this, event)
end

function LI.BagFrame_OnShow(this)
	if LI_Data.Options.bagbutton then
		LootIt_BagButton:Show()
	else
		LootIt_BagButton:Hide()
	end

	return LI.Hooked_BagFrame_OnShow(this)
end

function LI.BagItemButton_OnClick(frame, button, ignoreShift)
	if button == "LBUTTON" and IsShiftKeyDown() and LootIt_ItemFilter:IsVisible() then
		local _, _, name = GetBagItemInfo(frame:GetID())

		if name then
			LootIt_ItemFilter_Itemname:SetText(name)
		end
	else
		return LI.Hooked_BagItemButton_OnClick(frame, button, ignoreShift)
	end
end

function LI.UnitPopop_ShowMenu(dropdownMenu, which, unit, name, userData)
	local bool = LI_Data and LI_Data.Options ~= nil and LI_Data.Options.history
	local bool2 = which == "SELF" or which == "PARTY" or which == "RAID"

	local target = dropdownMenu:GetName()

	if UIDROPDOWNMENU_MENU_VALUE == "LOOT_THRESHOLD" then
		local info = {
			func = function(this)
				LI.SaveOwnLoot(nil, this.arg1)
			end,
		}

		for i = 0, LI.QualityCount do
			info.text = LI.GetQualityString(i)
			info.arg1 = i
			info.checked = GetLootThreshold() == i

			UIDropDownMenu_AddButton(info, 2)
		end

		return

	elseif target == "PlayerFrameDropDown" then
		target = UnitName("player")

	elseif string.match(target, "party%d") then
		target = UnitName("party"..string.match(target, "%d"))

	elseif string.find(target, "RaidPartyFrame%dUnitFrame%d") then
		local temp = string.match(target, "RaidPartyFrame%d")
		local num = string.match(temp, "%d") * 6 - 6

		temp = string.match(target, "UnitFrame%d")
		num = num + string.match(temp, "%d")

		target = UnitName("raid"..num)
	end

	if bool and bool2 and UIDROPDOWNMENU_MENU_LEVEL == 1 then
		info = {
			text = "|cff80ffff[LootIt!]:|r "..LI.Trans("OPTION_HEADLINE_HISTORY"),
			value = "LOOTIT_HISTORY",
			owner = which,
			notCheckable = 1,
			hasArrow = 1,
		}

		if LI_PlayerHistory and LI_PlayerHistory[target] then
			UIDropDownMenu_AddButton(info, 1)
		end

	elseif bool and bool2 and UIDROPDOWNMENU_MENU_LEVEL == 2 and UIDROPDOWNMENU_MENU_VALUE == "LOOTIT_HISTORY" then
		local info = {
			hasArrow = 1,
			notCheckable = 1,
		}

		LI.PlayerHistoryUnit = target

		for i = 0, LI.QualityCount do
			info.text = LI.GetQualityString(i)
			info.value = "LOOTIT_HISTORY"..i

			if LI_PlayerHistory and LI_PlayerHistory[target] and LI_PlayerHistory[target][i][1] then
				UIDropDownMenu_AddButton(info, 2)
			end
		end

		return

	elseif bool and bool2 and UIDROPDOWNMENU_MENU_LEVEL == 3 and UIDROPDOWNMENU_MENU_VALUE and string.find(UIDROPDOWNMENU_MENU_VALUE, "LOOTIT_HISTORY") then
		local info = {
			notCheckable = 1,
			func = function(this)
				CloseDropDownMenus()

				LI.io(this.arg1)
			end,
		}

		local target = LI_PlayerHistory[LI.PlayerHistoryUnit][tonumber(string.match(UIDROPDOWNMENU_MENU_VALUE, "%d"))]

		for _, link in ipairs(target) do
			info.text = link
			info.arg1 = link

			UIDropDownMenu_AddButton(info, 3)
		end

		return
	end

	return LI.Hooked_UnitPopop_ShowMenu(dropdownMenu, which, unit, name, userData)
end

function LI.SetLootMethod(arg1, arg2, bool)
	LI.UpdateZZButton = 1

	if LI.IsValidSystem() then
		SendSystemMsg("|cffff0050LootIt!:|r "..LI.Trans("WARNING_DKP_CHANGE"))
	else
		if bool then
			return LI.Hooked_SetLootMethod(arg1, arg2)
		else
			LI.SaveOwnLoot(arg1, nil, arg2)
		end
	end
end

function LI.SetLootThreshold(arg1, bool)
	LI.UpdateZZButton = 1

	if LI.IsValidSystem() then
		SendSystemMsg("|cffff0050LootIt!:|r "..LI.Trans("WARNING_DKP_CHANGE"))
	else
		if bool then
			return LI.Hooked_SetLootThreshold(arg1)
		else
			LI.SaveOwnLoot(nil, arg1)
		end
	end
end

function LI.SetLootAssignMember(arg1, bool)
	LI.UpdateZZButton = 1

	if LI.IsValidSystem() then
		SendSystemMsg("|cffff0050LootIt!:|r "..LI.Trans("WARNING_DKP_CHANGE"))
	else
		if bool then
			return LI.Hooked_SetLootAssignMember(arg1)
		else
			LI.SaveOwnLoot(nil, nil, arg1)
		end
	end
end

function LI.LootFrameItem_OnClick(this, key)
	if LI.IsValidSystem() then
		LI.CurrendItem = this.id
		UIDropDownMenu_SetWidth(LootIt_MasterlootDropdown, 10)
		UIDropDownMenu_Initialize(LootIt_MasterlootDropdown, LI.MiniConfigGenerateMasterloot)
		UIDropDownMenu_SetAnchor(LootIt_MasterlootDropdown, 10, -2, "TOPLEFT", "TOPRIGHT", this:GetName())
		ToggleDropDownMenu(LootIt_MasterlootDropdown)
	else
		return LI.Hooked_LootFrameItem_OnClick(this, key)
	end
end
