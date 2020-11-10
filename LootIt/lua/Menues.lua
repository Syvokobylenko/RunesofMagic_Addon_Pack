-- last changes     by: Tinsus     at: 2016-05-05T15:34:03Z     project-version: v1.9beta1     hash: b7d926547cd47d1359c71ba18732a9cd1c30fb63

-- register enter on editbox

local LI = _G.LI

function LI.MiniConfigShow(this)
	local x, y = GetCursorPos()

	UIDropDownMenu_SetAnchor(LootIt_Dropdown, x / (GetUIScale() or 1), y / (GetUIScale() or 1), "TOPLEFT", "TOPLEFT", UIParent)
	UIDropDownMenu_SetWidth(LootIt_Dropdown, 10)
	UIDropDownMenu_Initialize(LootIt_Dropdown, LI.MiniConfigGenerate)

	if this then
		ToggleDropDownMenu(LootIt_Dropdown)
	end
end

function LI.MiniConfigGenerate_Quest(this)
	if LI_Data and LI_Data.Options ~= nil then
		UIDropDownMenu_AddButton({
			text = LootIt_Dropdown_Quest.name,
			isTitle = 1,
			notCheckable = 1,
		})

		UIDropDownMenu_AddButton({
			text = C_CANCEL,
			notCheckable = 1,
			func = function(this)
				CloseDropDownMenus()
			end,
		})

		UIDropDownMenu_AddButton({
			notCheckable = 1,
			text = "|cff80ffff[LootIt!]:|r "..LI.Trans("CHECK_DATABASE"),
			arg1 = LootIt_Dropdown_Quest.link,
			func = function(this)
				GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?link="..LootIt_Dropdown_Quest.data)
			end,
		})
	end
end

function LI.MiniConfigGenerate_Skill(this)
	if LI_Data and LI_Data.Options ~= nil then
		UIDropDownMenu_AddButton({
			text = LootIt_Dropdown_Quest.name,
			isTitle = 1,
			notCheckable = 1,
		})

		UIDropDownMenu_AddButton({
			text = C_CANCEL,
			notCheckable = 1,
			func = function(this)
				CloseDropDownMenus()
			end,
		})

		UIDropDownMenu_AddButton({
			notCheckable = 1,
			text = "|cff80ffff[LootIt!]:|r "..LI.Trans("CHECK_DATABASE"),
			arg1 = LootIt_Dropdown_Quest.link,
			func = function(this)
				local temp = LI.explode(" ", LootIt_Dropdown_Quest.data)
				local link = {}

				for _, value in ipairs(temp) do
					table.insert(link, LI.DecToHex(value))
				end

				GC_OpenWebRadio("http://www.rom-welten.de/database/view.php?link="..table.concat(link, "+"))
			end,
		})
	end
end

function LI.MiniConfigGenerate(this)
	if LI_Data and LI_Data.Options ~= nil then
		if not UIDROPDOWNMENU_MENU_LEVEL or UIDROPDOWNMENU_MENU_LEVEL == 1 then
			UIDropDownMenu_AddButton({
				text = "LootIt! "..LI.version,
				isTitle = 1,
				notCheckable = 1,
			})

			local text

			if LI.Active() then
				text = LI.Trans("|cff00ff00#ACTIVE#|r")
			else
				text = LI.Trans("|cffff0000#INACTIVE#|r")
			end

			UIDropDownMenu_AddButton({
				text = text,
				checked = LI.Active(),
				func = function()
					LI_Data.Options.active = not LI_Data.Options.active
				end,
			})

			local info = {}

			if IsPartyLeader("player") or UnitIsRaidLeader("player") then
				info.hasArrow = 1
				info.value = 1
			end

			info.notCheckable = true

			if LI.IsValidSystem() then
				info.text = LI.ValidMember..": "..LI.GetQualityString(GetLootThreshold())

			elseif GetLootMethod() == "alternate" then
				info.text = TEXT("PB_ASSIGN_BY_DICE")..": "..LI.GetQualityString(GetLootThreshold())

			elseif GetLootMethod() == "master" then
				info.text = "|cffff8000"..TEXT("LOOT_MASTER_LOOTER")..": |r"..LI.GetQualityString(GetLootThreshold())

			elseif GetLootMethod() == "freeforall" then
				info.text = "|cffff0000"..TEXT("LOOT_FREE_FOR_ALL").."|r"
			end

			UIDropDownMenu_AddButton(info)

			info = {
				func = function()
					if (IsPartyLeader("player") or UnitIsRaidLeader("player")) and not LI.IsValidSystem() and LI.DKP_Ready() then
						LI.Send("SetDKP#"..UnitName("player").."##"..GetLootThreshold())
					else
						if LootIt_DKP_Info:IsVisible() then
							LI.SendToWeb(0)
						else
							LootIt_DKP_Info:Show()
						end
					end

					CloseDropDownMenus()
				end,
			}

			if tonumber(LI_DKP_own) ~= nil then
				info.text = LI.Trans("DKP").." ("..LI_DKP_own..")"
			else
				info.text = LI.Trans("DKP")
			end

			if (IsPartyLeader("player") or UnitIsRaidLeader("player")) then
				info.hasArrow = 1
				info.value = 6
				info.notCheckable = 1
			else
				info.checked = LI.IsValidSystem()
			end

			--UIDropDownMenu_AddButton(info)

			UIDropDownMenu_AddButton({
				text = LI.Trans("AUTOLOOT")..": "..LI.GetQualityString(LI_Data.Options.autoloot),
				notCheckable = true,
				hasArrow = 1,
				value = 2,
			})

			UIDropDownMenu_AddButton({
				text = LI.Trans("AUTOPASS")..": "..LI.GetQualityString(LI_Data.Options.autopass),
				notCheckable = true,
				hasArrow = 1,
				value = 3,
			})

			UIDropDownMenu_AddButton({
				text = LI.Trans("AUTOGREED")..": "..LI.GetQualityString(LI_Data.Options.autogreed),
				notCheckable = true,
				hasArrow = 1,
				value = 4,
			})

			UIDropDownMenu_AddButton({
				text = LI.Trans("ITEMFILTER"),
				notCheckable = true,
				func = function()
					LootIt_ItemFilter:Show()
				end,
			})

			UIDropDownMenu_AddButton({
				text = TEXT("FOCUSFRAME_OPTION"),
				notCheckable = true,
				hasArrow = 1,
				value = 5,
				func = function()
					LootIt_Optionen:Show()
				end,
			})

		elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
			if UIDROPDOWNMENU_MENU_VALUE == 1 then
				UIDropDownMenu_AddButton({
					text = "|cffff0000"..TEXT("LOOT_FREE_FOR_ALL").."|r",
					notCheckable = true,
					func = function()
						local mode

						if GetLootMethod() ~= "freeforall" then
							mode = "freeforall"
						else
							mode = "alternate"
						end

						LI.SaveOwnLoot(mode)
						CloseDropDownMenus()
					end,
				}, 2)

				UIDropDownMenu_AddButton({
					text = "",
					isTitle = true,
				}, 2)

				for i = 0, LI.QualityCount do
					UIDropDownMenu_AddButton({
						text = LI.GetQualityString(i),
						notCheckable = true,
						func = function(this)
							local mode

							if GetLootMethod() == "freeforall" then
								mode = "alternate"
							end

							LI.SaveOwnLoot(mode, this.arg1)

							CloseDropDownMenus()
						end,
						arg1 = i,
					}, 2)
				end

				UIDropDownMenu_AddButton({
					text = "",
					isTitle = true,
				}, 2)

				UIDropDownMenu_AddButton({
					text = "|cffff8000"..TEXT("LOOT_MASTER_LOOTER").."|r",
					checked = GetLootMethod() == "master" and not LI.IsValidSystem(),
					hasArrow = 1,
					value = 1,
					func = function()
						local mode

						if GetLootMethod() ~= "master" then
							mode = "master"
						else
							mode = "alternate"
						end

						LI.SaveOwnLoot(mode)
						CloseDropDownMenus()
					end,
				}, 2)

			elseif UIDROPDOWNMENU_MENU_VALUE == 2 then
				for i = -1, LI.QualityCount do
					info = {
						text = LI.GetQualityString(i),
						func = function(this)
							local val = tonumber(this.arg1)

							if not LI_Data.Options.range then
								LI_Data.Options.autolootmin = -2
								LI_Data.Options.autoloot = val
							else
								if LI_Data.Options.autolootmin == val then
									LI_Data.Options.autolootmin = -2

								elseif LI_Data.Options.autoloot == val and LI_Data.Options.autolootmin ~= -2 then
									LI_Data.Options.autoloot = LI_Data.Options.autolootmin
									LI_Data.Options.autolootmin = -2

								elseif val < LI_Data.Options.autoloot then
									LI_Data.Options.autolootmin = val

								elseif val > LI_Data.Options.autoloot then
									LI_Data.Options.autoloot = val
								end
							end

							CloseDropDownMenus()
						end,
						arg1 = i,
					}

					info.checked = i == LI_Data.Options.autoloot or i == LI_Data.Options.autolootmin

					UIDropDownMenu_AddButton(info, 2)
				end

				UIDropDownMenu_AddButton({
					text = "",
					isTitle = true,
				}, 2)

				UIDropDownMenu_AddButton({
					text = LI.Trans("NO_BOSSES"),
					checked = LI_Data.Options.nobosses,
					func = function()
						LI_Data.Options.nobosses = not LI_Data.Options.nobosses

						CloseDropDownMenus()
					end,
				}, 2)

			elseif UIDROPDOWNMENU_MENU_VALUE == 3 then
				for i = -1, LI.QualityCount do
					info = {
						text = LI.GetQualityString(i),
						func = function(this)
							local val = tonumber(this.arg1)

							if not LI_Data.Options.range then
								LI_Data.Options.autopassmin = -2
								LI_Data.Options.autopass = val
							else
								if LI_Data.Options.autopassmin == val then
									LI_Data.Options.autopassmin = -2

								elseif LI_Data.Options.autopass == val and LI_Data.Options.autopassmin ~= -2 then
									LI_Data.Options.autopass = LI_Data.Options.autopassmin
									LI_Data.Options.autopassmin = -2

								elseif val < LI_Data.Options.autopass then
									LI_Data.Options.autopassmin = val

								elseif val > LI_Data.Options.autopass then
									LI_Data.Options.autopass = val
								end
							end

							CloseDropDownMenus()
						end,
						arg1 = i,
					}

					info.checked = i == LI_Data.Options.autopass or i == LI_Data.Options.autopassmin

					UIDropDownMenu_AddButton(info, 2)
				end

			elseif UIDROPDOWNMENU_MENU_VALUE == 4 then
				for i = -1, LI.QualityCount do
					info = {
						text = LI.GetQualityString(i),
						func = function(this)
							local val = tonumber(this.arg1)

							if not LI_Data.Options.range then
								LI_Data.Options.autogreedmin = -2
								LI_Data.Options.autogreed = val
							else
								if LI_Data.Options.autogreedmin == val then
									LI_Data.Options.autogreedmin = LI_Data.Options.autogreed

								elseif LI_Data.Options.autogreed == val and LI_Data.Options.autogreedmin ~= LI_Data.Options.autogreed then
									LI_Data.Options.autogreed = LI_Data.Options.autogreedmin
									LI_Data.Options.autogreedmin = -1

								elseif val < LI_Data.Options.autogreed then
									LI_Data.Options.autogreedmin = val

								elseif val > LI_Data.Options.autogreed then
									LI_Data.Options.autogreed = val
								end
							end

							CloseDropDownMenus()
						end,
						arg1 = i,
					}

					info.checked = i == LI_Data.Options.autogreed or i == LI_Data.Options.autogreedmin

					UIDropDownMenu_AddButton(info, 2)
				end

			elseif UIDROPDOWNMENU_MENU_VALUE == 5 then
				for _, option in ipairs(LI_DisplayTable) do
					UIDropDownMenu_AddButton({
						text = LI.Trans("OPTION_HEADLINE_"..string.upper(option)),
						tooltipText = LI.Trans("OPTION_TOOLTIP_"..string.upper(option)),
						checked = LI_Data.Options[option],
						arg1 = option,
						func = function(this)
							LI_Data.Options[this.arg1] = not LI_Data.Options[this.arg1]

							CloseDropDownMenus()
						end,
					}, 2)
				end

			elseif UIDROPDOWNMENU_MENU_VALUE == 6 then
				if (IsPartyLeader("player") or UnitIsRaidLeader("player")) then
					if LI.DKP_Ready() then
						UIDropDownMenu_AddButton({
							text = TEXT("CRAFTQUEUE_START"),
							checked = LI.IsValidSystem(),
							func = function()
								LI.Send("SetDKP#"..UnitName("player").."##"..GetLootThreshold())

								CloseDropDownMenus()
							end,
						}, 2)
					end

					UIDropDownMenu_AddButton({
						text = TEXT("FOCUSFRAME_OPTION"),
						notCheckable = true,
						func = function()
							LootIt_DKP_Info:Show()

							CloseDropDownMenus()
						end,
					}, 2)
				end
			end

		elseif UIDROPDOWNMENU_MENU_LEVEL == 3 then
			if UIDROPDOWNMENU_MENU_VALUE == 1 then
				local names = {}

				for i = 1, 36 do
					if UnitName("raid"..i) then
						table.insert(names, UnitName("raid"..i))
					end
				end

				table.sort(names)

				for i = 1, #names do
					UIDropDownMenu_AddButton({
						text = names[i],
						arg1 = names[i],
						notCheckable = true,
						func = function(this)
							LI.SaveOwnLoot("master", GetLootThreshold(), this.arg1)

							CloseDropDownMenus()
						end,
					}, 3)
				end
			end
		end
	end
end

function LI.LoadRollingDropDown(this)
	UIDropDownMenu_Initialize(this, LI.LoadRollingDropDownGenerate)
end

function LI.LoadRollingDropDownGenerate(this)
	if LI_Data and LI_Data.Options ~= nil then
		if not UIDROPDOWNMENU_MENU_LEVEL or UIDROPDOWNMENU_MENU_LEVEL == 1 then
			for i = 1, 4 do
				UIDropDownMenu_AddButton({
					text = LI.ConvertIDToString(i, true),
					notCheckable = true,
					func = function()
						UIDropDownMenu_SetText(this, LI.ConvertIDToString(i, true))
					end,
				})
			end
		end
	end
end

function LI.LoadLootingDropDown(this)
	UIDropDownMenu_Initialize(this, LI.LoadLootingDropDownGenerate)
end

function LI.LoadLootingDropDownGenerate(this)
	if LI_Data and LI_Data.Options ~= nil then
		if not UIDROPDOWNMENU_MENU_LEVEL or UIDROPDOWNMENU_MENU_LEVEL == 1 then
			for i = 1, 4 do
				UIDropDownMenu_AddButton({
					text = LI.ConvertIDToString(i, false),
					notCheckable = true,
					func = function()
						UIDropDownMenu_SetText(this, LI.ConvertIDToString(i, false))
					end,
				})
			end
		end
	end
end

function LI.ItemFrameDropDown()
	if LI.Clicktransfer then
		if not UIDROPDOWNMENU_MENU_LEVEL or UIDROPDOWNMENU_MENU_LEVEL == 1 then
			UIDropDownMenu_AddButton({
				text = LI.Trans("TICK_CHARSPECIFIC"),
				checked = (LI_FilterChar[LI.RemoveSpezial(LI.Clicktransfer)] ~= nil or LI_FilterCharSpezial[LI.RemoveSpezial(LI.Clicktransfer)] ~= nil),
				func = function()
					local itemname = LI.RemoveSpezial(LI.Clicktransfer)
					local loot = getglobal(LI.Clicktransfer:GetName().."_Loot"):GetText()
					local roll = getglobal(LI.Clicktransfer:GetName().."_Roll"):GetText()

					if not tostring(loot) or loot == LI.Trans("MANUAL") then
						loot = 1

					elseif loot == LI.Trans("DISCARD") then
						loot = 2

					elseif loot == LI.Trans("COLLECT") then
						loot = 3
					end

					if not tostring(roll) or roll == LI.Trans("MANUAL") then
						roll = 1

					elseif roll == TEXT("SYS_GIVE_UP") then
						roll = 2

					elseif roll == LI.GROUPLOOT_GREED then
						roll = 3

					elseif roll == LI.GROUPLOOT_ROLL then
						roll = 4
					end

					LI.AddData(itemname, loot, roll, (LI_FilterChar[LI.RemoveSpezial(LI.Clicktransfer)] ~= nil or LI_FilterCharSpezial[LI.RemoveSpezial(LI.Clicktransfer)] ~= nil))

					LI.Clicktransfer = nil
				end,
			})

			UIDropDownMenu_AddButton({
				text = LI.Trans("REMOVE_STACK"),
				notCheckable = true,
				hasArrow = true,
				value = 1,
			})

			UIDropDownMenu_AddButton({
				text = TEXT("C_DEL"),
				notCheckable = true,
				func = function()
					LI.DelData(LI.RemoveSpezial(LI.Clicktransfer), true)
					LI.PaintFilterFrame()

					LI.Clicktransfer = nil
				end,
			})

		elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
			if UIDROPDOWNMENU_MENU_VALUE == 1 then
				UIDropDownMenu_AddButton({
					text = TEXT("C_DEL"),
					tooltipText = LI.Trans("REMOVE_STACK_TOOLTIP"),
					notCheckable = true,
					arg1 = 0,
					func = function(this)
						LI.AddData(LI.RemoveSpezial(LI.Clicktransfer), loot, roll, allchars, true, this.arg1)

						CloseDropDownMenus()
					end,
				}, 2)

				for i = 1, 20 do
					UIDropDownMenu_AddButton({
						text = i,
						tooltipText = LI.Trans("REMOVE_STACK_TOOLTIP"),
						notCheckable = true,
						arg1 = i,
						func = function(this)
							LI.AddData(LI.RemoveSpezial(LI.Clicktransfer), loot, roll, allchars, true, this.arg1)

							CloseDropDownMenus()
						end,
					}, 2)
				end
			end
		end
	end
end
