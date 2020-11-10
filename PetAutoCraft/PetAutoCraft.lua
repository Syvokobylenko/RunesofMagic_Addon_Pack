------------------------------------------------------------------------####################
PetAutoCraft = {}--														##Global Variables##
------------------------------------------------------------------------####################
PetAutoCraft.Events = {}												--Table that will contain all the event functions
------------------------------------------------------------------------###################
--																		##Local Variables##
------------------------------------------------------------------------###################
local Version = "v1.4.1"												--Version of Pet Auto Craft
local SkillLvl = {}														--Table of Pet Craft skills. Server updates numbers only after a full % point increase
SkillLvl.MINING = 1														----Mining Skill (1.2345 counts as skill lvl 1 with 23.45% to lvl 2)
SkillLvl.WOOD = 1														----Woodcutting Skill (same)
SkillLvl.HERB = 1														----Herbalism Skill (same)
local Type = nil														--Current type of craft ("MINING", "WOOD", "HERB", nil)
local Index = 0															--Current Craft Option index
local Products = {}														--Table of current products
local Repeats = {}														--Table of all the repeat info
for i,v in pairs(SkillLvl) do											----info per type
Repeats[i] = {Completed = nil, TilLvl = nil, SLvl = nil, CLvl = nil} end----Completed = #completed to calc xp, TilLvl = how many repeats til level, SLvl = Skill Level, CLvl = Craft Level
local ToolTimer = {Timer = nil, Completed = 0, Timestamp = nil}			--Use to determine how long each craft takes
local CastTimer = nil													--Timer of the cast bar
local Delay = nil														--Timer that sets a delay between (buying tools) --> (equipping tools) --> (starting to craft)
local Refine = nil														--Timer that handles the auto refine
local Store = false														--StoreFrame:IsVisible()
local EquipAttempts = 0													--Equip Attempts that failed due to an item alrady being on the cursor
local CraftOptions = {}													--Table all the craft option
for i, v in pairs(SkillLvl) do CraftOptions[i] = {} end					----Sub tables of all the craft types, used for selecting best craft and filling in dropdown menus
local DBfile = "Interface/AddOns/PetAutoCraft/Data.lua"					--Location of DB file
local PetVendors, Tools, Mats = dofile(DBfile)							--Tables for Pet Vendor locations, all the tools, all the mats and their itemIDs
local MatNameToID = {}													--Table for finding a Mats ID number via the name
for i,v in pairs(Mats) do for j,k in pairs(v) do						----Take apart our master Mat table to..
MatNameToID[k.Name] = k.ID end end										----..make our simple table
------------------------------------------------------------------------#######################################
local GlobalDefaults = {}--												##Defaults for Global Saved Variables##
------------------------------------------------------------------------#######################################
GlobalDefaults.PosX = false												--X Position of the PetAutoCraft_Frame
GlobalDefaults.PosY = false												--Y Position of the PetAutoCraft_Frame
GlobalDefaults.CraftOptions = CraftOptions								--Saved copy of CraftOptions
GlobalDefaults.xpPerCraft = {}											--Saved table of the xp per craft per skill level per craft level
------------------------------------------------------------------------##########################################
local CharDefaults = {}--												##Defaults for Character Saved Variables##
------------------------------------------------------------------------##########################################
PetAutoCraftCSave = nil													--Wipe out variable from other toons to prevent errors
CharDefaults.Pet = 0													--Which pet will do the crafting. 1-6
CharDefaults.Running = false											--Continues crafting between sessions
CharDefaults.HarvestAt = 100											--Harvest when common mat is at
for i, v in pairs(SkillLvl) do CharDefaults[i] = "▲" end				--Index of the craft level to do. (1 - 14, 0 = auto)
for i, v in pairs(Tools) do CharDefaults["Use"..v.ID] = true end		--A dropdown list to pick which tools to use and which to ignore, use all tools by default
for i, v in pairs(MatNameToID) do CharDefaults["Sell"..v] = false end	--A dropdown list to pick which mats to autosell to the vendor
CharDefaults["Sell204790"] = true										----Mysterious Item defaults to true
for i, v in pairs(Tools) do if v.Vendor then							--Auto buy stacks of tools at the vendor when out of tools and crafting
CharDefaults["Buy"..v.ID] = 0 end end									----default 0 stacks
------------------------------------------------------------------------##########################################

function PetAutoCraft.OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("PET_SWAPITEM_SUCESS")						--Equiped/Unequiped tools
	this:RegisterEvent("PET_CRAFT_START")							--Start of a set of cycles
	this:RegisterEvent("PET_CRAFTING_START")						--Start of a cycle
	this:RegisterEvent("PET_CRAFTING_FAILED")						--Cycle interrupted
	this:RegisterEvent("PET_CRAFTING_END")							--End of a cycle
	this:RegisterEvent("PET_CRAFT_END")								--End of a set of cycles
	this:RegisterEvent("STORE_OPEN")								--Store Frame Opens
	SLASH_PetAutoCraft1 = "/pac"
	SLASH_PetAutoCraft2 = "/petautocraft"
	SlashCmdList.PetAutoCraft = PetAutoCraft.ToggleFrame
	for i = 1, 3 do getglobal("PetAutoCraft_ProductButton"..i.."Count"):Show() end
	PetAutoCraft_ToolButtonCount:Show()
end

function PetAutoCraft.OnUpdate(update, elapsedTime)
	if Delay then
		Delay = Delay - elapsedTime
		if Delay <= 0 then
			Delay = nil
			PetAutoCraft.EquipTool()
		end
	end
	if ToolTimer.Timer then
		ToolTimer.Timer = ToolTimer.Timer - elapsedTime
		PetAutoCraft_OutOfToolValue:SetText(PetAutoCraft.SecondsToTime(ToolTimer.Timer))
	else
		PetAutoCraft_OutOfToolValue:SetText("Stopped")
	end
	if CastTimer then
		CastTimer = CastTimer - elapsedTime
		if CastTimer >= 0 then
			PetAutoCraft_CastValue:SetText(string.format("%.1f", CastTimer).." sec")
		else
			PetAutoCraft_CastValue:SetText("Processing")
		end
	else
		PetAutoCraft_CastValue:SetText("Stopped")
	end
	if Refine then
		Refine = Refine - elapsedTime
		if Refine <= 0 then
			if CraftQueueFrame.creating == 0 then
				for i = 1, CraftQueueFrame.list.count do
					CraftQueueFrame.list[i].number = 9999
				end
				CraftQueueFrame_OnShow(CraftQueueFrame)
				Lua_CreateQueueItem()
			end
			Refine = 60
		end
	end
end

function PetAutoCraft.Events.VARIABLES_LOADED()
	PetAutoCraft.UpdateSavedVariables()
	PET_CURRENT_ITEM = PetAutoCraftCSave.Pet
	PetAutoCraft.Hooks()
	if PetAutoCraftGSave.PosX then
		local scale = GetUIScale()
		PetAutoCraft_Frame:ClearAllAnchors()
		PetAutoCraft_Frame:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", PetAutoCraftGSave.PosX / scale, PetAutoCraftGSave.PosY / scale)
	end
	if AddonManager then
		local addon = {
			name = "Pet Auto Craft",
			version = Version,
			author = "Mavoc",
			description = "Automates the pet craft feature",
			icon = "Interface/petframe/icons/trainicon",
			category = "Economy", --AM needs a crafting category
			slashCommands = "/pac",
			onClickScript = PetAutoCraft.ToggleFrame,
			configFrame = nil,
			miniButton = nil,
		}
		AddonManager.RegisterAddonTable(addon)
	end
	if KeyBinder then
		KeyBinder.RegisterBinding("PetAutoCraft", "Pet Auto Craft", "PetAutoCraft.ToggleFrame()")
	end
	CraftOptions = PetAutoCraftGSave.CraftOptions
	if PetAutoCraftCSave.Pet > 0 then
		for i, v in pairs(SkillLvl) do PetAutoCraft.UpdateSkillLvl(i) end
		PetAutoCraft.UpdateTools()
		for i = 1, 3 do
			Products[i] = GetPetEquipmentItem(PetAutoCraftCSave.Pet, "product"..i)
		end
		if PetAutoCraftCSave.Running then
			Delay = 0.5
		end
	end
end

function PetAutoCraft.Events.STORE_OPEN()
	local id
	for i = 1, GetStoreSellItems() do
		id = PetAutoCraft.LinkToID(GetStoreSellItemLink(i))
		if id and PetAutoCraftCSave["Buy"..id] then
			PetAutoCraft_StoreButton:Show()
			return
		end
	end
	PetAutoCraft_StoreButton:Hide()
end

function PetAutoCraft.Events.PET_SWAPITEM_SUCESS()
	PetAutoCraft.UpdateTools()
	PetAutoCraft.GetCraftOptions()
end

function PetAutoCraft.Events.PET_CRAFT_START()
	PetAutoCraft_MiniMapFlash:SetColor(0, 1, 0)
	PetAutoCraft_SelectPetButton:Disable()
	PetAutoCraft_StartButton:Hide()
	PetAutoCraft_StopButton:Show()
	local name, icon, count
	for i = 1, 3 do
		name, icon, count = GetPetPossibleProductItemDetail(PetAutoCraftCSave.Pet, Index, i)
		Products[i] = name
		getglobal("PetAutoCraft_ProductButton"..i.."Icon"):SetFile(icon)
	end
end

function PetAutoCraft.Events.PET_CRAFTING_START()
	if Repeats[Type].Clvl ~= CraftOptions[Type][Index]["Level"] or Repeats[Type].Slvl ~= math.floor(SkillLvl[Type]) then
		Repeats[Type].Clvl = CraftOptions[Type][Index]["Level"]
		Repeats[Type].Slvl = math.floor(SkillLvl[Type])
		Repeats[Type].TilLvl = nil
		Repeats[Type].Completed = nil
	end
	if PetAutoCraftCSave[Type] == "▲" then--switch crafting option if needed. Stop doesn't work on PET_CRAFTING_END
		for i = #(CraftOptions[Type]), 1, -1 do
			if CraftOptions[Type][i]["Level"] <= SkillLvl[Type] then
				if i ~= Index then
					PetCraftingStop(PetAutoCraftCSave.Pet)
					return
				end
				break
			end
		end
	elseif PetAutoCraftCSave[Type] ~= CraftOptions[Type][Index]["Level"] then
		PetCraftingStop(PetAutoCraftCSave.Pet)
		return
	end
	if ToolTimer.TimeStamp then
		PetAutoCraft.InitTimer((GetTime() - ToolTimer.TimeStamp) / ToolTimer.Completed)
	else
		PetAutoCraft.InitTimer(11)
		ToolTimer.TimeStamp = GetTime()
		ToolTimer.Completed = 0
	end
	CastTimer = arg2
end

function PetAutoCraft.Events.PET_CRAFTING_FAILED()
	if Repeats[Type].Completed then
		Repeats[Type].Completed = Repeats[Type].Completed - 1
	end
	if Repeats[Type].TilLvl then
		Repeats[Type].TilLvl = Repeats[Type].TilLvl + 1
		getglobal("PetAutoCraft_"..Type.."ToLvlValue"):SetText(Repeats[Type].TilLvl)
	else
		getglobal("PetAutoCraft_"..Type.."ToLvlValue"):SetText("Waiting")
	end
end

function PetAutoCraft.Events.PET_CRAFTING_END()
	local level, name, icon, count
	PetAutoCraft.UpdateTools()
	level = GetPetLifeSkillInfo(PetAutoCraftCSave.Pet, Type)
	if SkillLvl[Type] < level then
		if math.floor(SkillLvl[Type]) == math.floor(level) and Repeats[Type].Completed then
			PetAutoCraftGSave.xpPerCraft[Repeats[Type].Clvl][Repeats[Type].Slvl] = (level - SkillLvl[Type]) / Repeats[Type].Completed
		end
		if PetAutoCraftGSave.xpPerCraft[Repeats[Type].Clvl][math.floor(level)] then
			Repeats[Type].TilLvl = math.ceil((math.ceil(level) - level) / PetAutoCraftGSave.xpPerCraft[Repeats[Type].Clvl][math.floor(level)])
			getglobal("PetAutoCraft_"..Type.."ToLvlValue"):SetText(Repeats[Type].TilLvl)
		else
			getglobal("PetAutoCraft_"..Type.."ToLvlValue"):SetText("Calculating")
		end
		Repeats[Type].Completed = 0
		PetAutoCraft.UpdateSkillLvl(Type, level)
	else
		if Repeats[Type].Completed then
			Repeats[Type].Completed = Repeats[Type].Completed + 1
		end
		if Repeats[Type].TilLvl then
			Repeats[Type].TilLvl = Repeats[Type].TilLvl - 1
			getglobal("PetAutoCraft_"..Type.."ToLvlValue"):SetText(Repeats[Type].TilLvl)
		else
			getglobal("PetAutoCraft_"..Type.."ToLvlValue"):SetText("Waiting")
		end
	end
	local harvest = false
	for i = 1, 3 do
		name, icon, count = GetPetEquipmentItem(PetAutoCraftCSave.Pet, "product"..i)
		if count then
			for v = 1, 3 do
				if name == CraftOptions[Type][Index]["Product"..v] then
					if (v == 1 and count >= 999) or (v == 2 and count >= PetAutoCraftCSave.HarvestAt) then
						harvest = true
					end
					getglobal("PetAutoCraft_ProductButton"..v.."Count"):SetText(count)
					break
				end
			end
		end
	end
	if harvest then
		PetAutoCraft.HarvestItems()
	end
	ToolTimer.Completed = ToolTimer.Completed + 1
end

function PetAutoCraft.Events.PET_CRAFT_END()
	PetAutoCraft_MiniMapFlash:SetColor(1, 0, 0)
	PetAutoCraft_SelectPetButton:Enable()
	PetAutoCraft_StopButton:Hide()
	PetAutoCraft_StartButton:Show()
	Index = 0
	ToolTimer.TimeStamp = nil
	ToolTimer.Completed = 0
	ToolTimer.Timer = nil
	CastTimer = nil
	if PetAutoCraftCSave.Running then
		Delay = 0.5
	end
end

function PetAutoCraft.HarvestItems()
	if not PET_CURRENT_ITEM then --prevents the default interface from erroring
		PET_CURRENT_ITEM = PetAutoCraftCSave.Pet
	end
	if PetAutoCraftCSave.Pet and GetPetEquipmentItem(PetAutoCraftCSave.Pet, "product1") then
		PetCraftHarvest(PetAutoCraftCSave.Pet)
	end
	for i = 1, 3 do
		getglobal("PetAutoCraft_ProductButton"..i.."Count"):SetText("0")
	end
end

function PetAutoCraft.EquipTool()
	if not CursorHasItem() then
		EquipAttempts = 0
		Store = StoreFrame:IsVisible()
		if not GetPetEquipmentItem(PetAutoCraftCSave.Pet, "tools") then
			local id
			for i = 1, 240 do
				id = PetAutoCraft.LinkToID(GetBagItemLink(i))
				if id and PetAutoCraftCSave["Use"..id] then
					PickupBagItem(i)
					ClickPetCraftItem(PetAutoCraftCSave.Pet)
					Delay = 0.5
					return
				elseif Store and id and PetAutoCraftCSave["Sell"..id] then
					UseBagItem(i)
				end
			end
			if Store then
				if PetAutoCraft.BuyTools() then
					Delay = 3
				else
					PetAutoCraftCSave.Running = false
					SendWarningMsg("Not enough gold to buy pet crafting tools")
				end
			else
				PetAutoCraftCSave.Running = false
				SendWarningMsg("Out of pet crafting tools")
			end
		else
			PetAutoCraft.StartCraft()
		end
	else
		EquipAttempts = EquipAttempts + 1
		if EquipAttempts < 100 then
			Delay = 0.1
		else
			ClickPetCraftItem(PetAutoCraftCSave.Pet)
			Delay = 0.5
		end
	end
end

function PetAutoCraft.BuyTools()
	local cost, currency, stacksize
	local buy = false
	local gold = GetPlayerMoney("copper")
	for i = 1, GetStoreSellItems() do
		id = PetAutoCraft.LinkToID(GetStoreSellItemLink(i))
		if id and PetAutoCraftCSave["Use"..id] and PetAutoCraftCSave["Buy"..id] then
			_, _, cost, currency, _, _, stacksize, _, _ = GetStoreSellItemInfo(i)
			if currency == 0 and gold >= cost * stacksize then
				for j = 1, PetAutoCraftCSave["Buy"..id] do
					buy = true
					StoreBuyItem(i, stacksize)
				end
			else
				warning = "Not enough gold to buy pet crafting tools"
			end
		end
	end
	return buy
end

function PetAutoCraft.StartCraft()
	PetAutoCraft.GetCraftOptions()
	PetAutoCraft.UpdateSkillLvl(Type)
	for i = #(CraftOptions[Type]), 1, -1 do
		if (PetAutoCraftCSave[Type] == "▲" and CraftOptions[Type][i]["Level"] <= SkillLvl[Type]) or PetAutoCraftCSave[Type] == CraftOptions[Type][i]["Level"] then
			Index = i
			break
		end
	end
	local found = 0
	for i = 1, 3 do
		if Products[i] then
			for v = 1, 3 do
				if Products[i] == CraftOptions[Type][Index]["Product"..v] then
					found = found + 1
				end
			end
		end
	end
	if found < 3 then
		PetAutoCraft.HarvestItems()
	end
	if PET_CURRENT_ITEM == PetAutoCraftCSave.Pet then
		UIDropDownMenu_SetSelectedID(PetCraftTypeDropDown, Index)
	end
	PET_CRAFT_CHOOSE[PetAutoCraftCSave.Pet] = Index
	PetCraftingStart(PetAutoCraftCSave.Pet, Index)
end

function PetAutoCraft.SelectPetMenu()
	local info = {}
	info.text = "Select Pet"
	info.notCheckable = true
	info.isTitle = true
	UIDropDownMenu_AddButton(info)
	for i = 1, PET_FRAME_NUM_ITEMS do
		if HasPetItem(i) then
			info = {}
			info.text = i..": "..GetPetItemName(i)
			info.value = i
			info.notCheckable = true
			info.func = function(button)
				PetAutoCraftCSave.Pet = button.value
				PetAutoCraft_SelectPetButton:SetText(button.value)
				for i, v in pairs(SkillLvl) do 
					PetAutoCraft.UpdateSkillLvl(i) 
					getglobal("PetAutoCraft_"..i.."ToLvlValue"):SetText("Unknown")
				end
				PetAutoCraft.UpdateTools()
				PetAutoCraft.GetCraftOptions()
			end
			UIDropDownMenu_AddButton(info)
		end
	end
end

function PetAutoCraft.SelectToolsMenu()
	local info = {}
	info.text = "Select Tools to Use"
	info.isTitle = true
	UIDropDownMenu_AddButton(info)
	for i, v in pairs(Tools) do
		info = {}
		info.text = v.Name
		info.value = "Use"..v.ID
		info.checked = PetAutoCraftCSave["Use"..v.ID]
		info.keepShownOnClick = true
		info.func = function(button)
			PetAutoCraftCSave[button.value] = not PetAutoCraftCSave[button.value]
			PetAutoCraft_SelectToolsButton:SetText(PetAutoCraft.CountCheckBoxes("Use"))
		end
		UIDropDownMenu_AddButton(info)
	end
end

function PetAutoCraft.BuyToolsMenu()
	local info = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		info.text = "Select Tools to Buy from Vendor"
		info.isTitle = true
		UIDropDownMenu_AddButton(info, 1)
		for i, v in pairs(Tools) do
			if v.Vendor then
				info = {}
				info.text = v.Name
				info.value = "Buy"..v.ID
				info.hasArrow = 1
				info.checked = PetAutoCraftCSave["Buy"..v.ID] > 0
				info.keepShownOnClick = true
				info.func = function(button)
					if PetAutoCraftCSave[button.value] == 0 then
						PetAutoCraftCSave[button.value] = 1
					else
						PetAutoCraftCSave[button.value] = 0
					end
					PetAutoCraft_BuyToolsButton:SetText(PetAutoCraft.CountCheckBoxes("Buy"))
					DropDownList2.numButtons = 0
					UIDROPDOWNMENU_MENU_LEVEL = 2
					PetAutoCraft.BuyToolsMenu()
				end
				UIDropDownMenu_AddButton(info, 1)
			end
		end
	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for i, v in pairs(Tools) do
			if UIDROPDOWNMENU_MENU_VALUE == "Buy"..v.ID then
				info.text = "# Stacks"
				info.isTitle = true
				UIDropDownMenu_AddButton(info, 2)
				for j = 0, 6 do
					info = {}
					info.text = j
					info.value = j
					info.arg1 = "Buy"..v.ID
					info.checked = PetAutoCraftCSave["Buy"..v.ID] == j
					info.isRadioButton = true
					info.func = function(button)
						PetAutoCraftCSave[button.arg1] = button.value
						PetAutoCraft_BuyToolsButton:SetText(PetAutoCraft.CountCheckBoxes("Buy"))
						DropDownList1.numButtons = 0
						UIDROPDOWNMENU_MENU_LEVEL = 1
						PetAutoCraft.BuyToolsMenu()
					end
					UIDropDownMenu_AddButton(info, 2)
				end
			end
		end
	end
end

function PetAutoCraft.SellMatsMenu()
	local info = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		info.text = "Select Mats to be Vendored"
		info.isTitle = true
		info.notCheckable = true
		UIDropDownMenu_AddButton(info, 1)
		info = {}
		info.text = "Trash"
		info.value = "TRASH"
		info.notCheckable = true
		info.hasArrow = 1
		UIDropDownMenu_AddButton(info, 1)
		info = {}
		info.text = "Herbs"
		info.value = "HERB"
		info.notCheckable = true
		info.hasArrow = 1
		UIDropDownMenu_AddButton(info, 1)
		info = {}
		info.text = "Wood"
		info.value = "WOOD"
		info.notCheckable = true
		info.hasArrow = 1
		UIDropDownMenu_AddButton(info, 1)
		info = {}
		info.text = "Ore"
		info.value = "MINING"
		info.notCheckable = true
		info.hasArrow = 1
		UIDropDownMenu_AddButton(info, 1)
	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
		for i, v in ipairs(Mats[UIDROPDOWNMENU_MENU_VALUE]) do
			info = {}
			info.text = v.Lvl..": "..v.Name
			info.value = "Sell"..v.ID
			info.checked = PetAutoCraftCSave["Sell"..v.ID]
			info.keepShownOnClick = true
			info.func = function(button)
				PetAutoCraftCSave[button.value] = not PetAutoCraftCSave[button.value]
				PetAutoCraft_SellMatsButton:SetText(PetAutoCraft.CountCheckBoxes("Sell"))
			end
			UIDropDownMenu_AddButton(info, 2)
		end
	end
end

function PetAutoCraft.MiningOptionsMenu()
	PetAutoCraft.CraftLevelOptionsMenu("MINING", LIFESKILL_MINE)
end

function PetAutoCraft.WoodOptionsMenu()
	PetAutoCraft.CraftLevelOptionsMenu("WOOD", LIFESKILL_WOOD)
end

function PetAutoCraft.HerbOptionsMenu()
	PetAutoCraft.CraftLevelOptionsMenu("HERB", LIFESKILL_HERB)
end

function PetAutoCraft.CraftLevelOptionsMenu(crafttype, craftname)
	local highest = 1
	local info = {}
	if #(CraftOptions[crafttype]) > 0 then
		info.text = "Select "..craftname.." Crafting Level"
		info.notCheckable = true
		info.isTitle = true
		UIDropDownMenu_AddButton(info)
		for i = 1, #(CraftOptions[crafttype]) do
			info = {}
			info.text = CraftOptions[crafttype][i]["Level"]..": "..CraftOptions[crafttype][i]["Name"]
			info.value = CraftOptions[crafttype][i]["Level"]
			info.arg1 = crafttype
			info.tooltipText = "50% "..CraftOptions[crafttype][i]["Product1"].."\n45% "..CraftOptions[crafttype][i]["Product2"].."\n5% "..CraftOptions[crafttype][i]["Product3"]
			info.notCheckable = true
			if CraftOptions[crafttype][i]["Level"] > SkillLvl[crafttype] then
				info.disabled = true
			end
			info.func = function(button)
				PetAutoCraftCSave[button.arg1] = button.value
				getglobal("PetAutoCraft_"..button.arg1.."OptionsButton"):SetText(button.value)
			end
			UIDropDownMenu_AddButton(info)
		end
		info = {}
		info.text = "▲: Highest Level"
		info.value = "▲"
		info.arg1 = crafttype
		info.notCheckable = true
		info.func = function(button)
			PetAutoCraftCSave[button.arg1] = button.value
			getglobal("PetAutoCraft_"..button.arg1.."OptionsButton"):SetText(button.value)
		end
		UIDropDownMenu_AddButton(info)
	else
		info.text = "Please Equip "..craftname.." Tool to Populate List"
		info.notCheckable = true
		info.isTitle = true
		UIDropDownMenu_AddButton(info)
	end
end

function PetAutoCraft.ProductButton_OnEnter(this)
	GameTooltip:SetOwner(PetAutoCraft_Frame, "ANCHOR_LEFT", 0, 0)
	GameTooltip:SetPetProductItem(PetAutoCraftCSave.Pet, Index, this:GetID())
	if AdvancedAuctionHouse then
		local id
		local name = GetPetPossibleProductItemDetail(PetAutoCraftCSave.Pet, Index, this:GetID())
		if name and MatNameToID[name] then id = MatNameToID[name] end
		if id and IsAltKeyDown() == not AAH_SavedSettings.PriceHistoryAutoshow then
			HistoryForGameTooltipHyperLink = false
			HistoryForGameTooltip = true
			AAHFunc.ToolsShowPriceHistoryTooltip(GameTooltip, id)
		end
	end
end

function PetAutoCraft.ToolButton_OnClick()
	if not HasPetItem(PetAutoCraftCSave.Pet) then
		SendWarningMsg("Current selected pet does not exist.")
	elseif PetAutoCraftCSave.Running then
		SendWarningMsg(TEXT("PET_IN_CREATING"))
	elseif HasPetCraftHarvest(PetAutoCraftCSave.Pet) then
		SendWarningMsg(TEXT("PET_HAS_HARVEST"))
	else
		ClickPetCraftItem(PetAutoCraftCSave.Pet)
	end

end

function PetAutoCraft.UpdateTools()
	local name, icon, count = GetPetEquipmentItem(PetAutoCraftCSave.Pet, "tools")
	if name then
		PetAutoCraft_ToolButtonIcon:SetFile(icon)
		PetAutoCraft_ToolButtonCount:SetText(count)
	else
		PetAutoCraft_ToolButtonIcon:SetFile("Interface\\CharacterFrame\\Equipment-UtensilSlot")
		PetAutoCraft_ToolButtonCount:SetText("")
	end
end

function PetAutoCraft.GetCraftOptions()
	local name, crafttype, craftlvl
	local numOptions = GetPetNumCraftItems(PetAutoCraftCSave.Pet)
	for i = 1, numOptions do
		name, crafttype, craftlvl = GetPetCraftItemInfo(PetAutoCraftCSave.Pet, i)
		CraftOptions[crafttype][i] = {}
		CraftOptions[crafttype][i]["Level"] = craftlvl
		CraftOptions[crafttype][i]["Name"] = name
		if not PetAutoCraftGSave.xpPerCraft[craftlvl] then PetAutoCraftGSave.xpPerCraft[craftlvl] = {} end
		for v = 1, 3 do
			CraftOptions[crafttype][i]["Product"..v] = GetPetPossibleProductItemDetail(PetAutoCraftCSave.Pet, i, v)
		end
	end
	PetAutoCraftGSave.CraftOptions = CraftOptions
	Type = crafttype
end

function PetAutoCraft.InitTimer(diff)
	local count
	local total = 0
	_, _, count = GetPetEquipmentItem(PetAutoCraftCSave.Pet, "tools")
	if count then
		total = count
	end
	for i, v in pairs(Tools) do
		if PetAutoCraftCSave["Use"..v.ID] then
			total = total + GetBagItemCount(v.ID)
		end
	end
	ToolTimer.Timer = total * diff
end

function PetAutoCraft.AutoRefine_OnClick(value)
	Refine = value
end

function PetAutoCraft.CountCheckBoxes(str)
	local count = 0
	if str == "Use" then
		for i, v in pairs(Tools) do
			if PetAutoCraftCSave[str..v.ID] then
				count = count + 1
			end
		end
	elseif str == "Buy" then
		for i, v in pairs(Tools) do
			if v.Vendor and PetAutoCraftCSave[str..v.ID] > 0 then
				count = count + 1
			end
		end
	elseif str == "Sell" then
		for i, v in pairs(MatNameToID) do
			if PetAutoCraftCSave[str..v] then
				count = count + 1
			end
		end
	end
	return count
end

function PetAutoCraft.UpdateSkillLvl(skill, level)
	if not level then
		level = GetPetLifeSkillInfo(PetAutoCraftCSave.Pet, skill)
	end
	SkillLvl[skill] = level
	getglobal("PetAutoCraft_"..skill.."LevelValue"):SetText(math.floor(level)..": "..string.format("%.2f", math.floor((level - math.floor(level)) * 10000) / 100).."%")
end

function PetAutoCraft.LinkToID(link)
	local data
	if link and link ~= "" then
		_, data, _ = ParseHyperlink(link)
		if data then
			return tonumber(string.sub(data, 1, 5), 16)
		end
	end
	return nil
end

function PetAutoCraft.SecondsToTime(temptime)
	local hours, minutes, seconds
	temptime = math.floor(temptime)
	hours = math.floor(temptime / 3600)
	temptime = temptime - (hours * 3600)
	minutes = string.format("%02s", math.floor(temptime / 60))
	seconds = string.format("%02s", temptime - (tonumber(minutes) * 60))
	return hours..":"..minutes..":"..seconds
end

function PetAutoCraft.ToggleFrame()
	if PetAutoCraft_Frame:IsVisible() then
		PetAutoCraft_Frame:Hide()
	else
		if PetAutoCraftCSave.Pet == 0 or not HasPetItem(PetAutoCraftCSave.Pet) then
			for i = 1, PET_FRAME_NUM_ITEMS do
				if HasPetItem(i) then
					PetAutoCraftCSave.Pet = i
				end
			end
		end
		if PetAutoCraftCSave.Pet > 0 then
			PetAutoCraft_Frame:Show()
			PetAutoCraft_SelectPetButton:SetText(PetAutoCraftCSave.Pet)
			PetAutoCraft_SelectToolsButton:SetText(PetAutoCraft.CountCheckBoxes("Use"))
			PetAutoCraft_BuyToolsButton:SetText(PetAutoCraft.CountCheckBoxes("Buy"))
			PetAutoCraft_SellMatsButton:SetText(PetAutoCraft.CountCheckBoxes("Sell"))
			PetAutoCraft_HarvestAtButton:SetText(PetAutoCraftCSave.HarvestAt)
			for i, v in pairs(SkillLvl) do getglobal("PetAutoCraft_"..i.."OptionsButton"):SetText(PetAutoCraftCSave[i]) end
			for i, v in pairs(SkillLvl) do PetAutoCraft.UpdateSkillLvl(i) end
			PetAutoCraft.UpdateTools()
			PetAutoCraft.GetCraftOptions()
		else
			SendWarningMsg("No Pet Eggs Found")
		end
	end
end

function OnMouseDown_PlayerFramePetButton(this, key)--Replacing the Original Function
	if key == "LBUTTON" then
		ToggleUIFrame(PetFrame)
	elseif key == "RBUTTON" then
		if IsShiftKeyDown() then
			UIPanelAnchorFrame_StartMoving(this)
		else
			PetAutoCraft.ToggleFrame()
		end
	end
end

function OnEnter_PlayerFramePetButton(this)--Replacing the Original Function
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT", 4, 0)
	GameTooltip:SetText(PET_FRAME_BUTTON, 1, 1, 1)
	GameTooltip:AddLine(PB_OPEN_TIPS, 0, 0.75, 0.95)
	GameTooltip:AddLine("Right-click to open PetAutoCraft", 0, 0.75, 0.95)
	GameTooltip:AddLine(UIPANELANCHORFRAME_TOOLTIP, 0, 0.75, 0.95)
	GameTooltip:Show()
end

function PetCraftHarvestButton_OnClick(this)--Replacing the Original Function
	PetCraftHarvest(PET_CURRENT_ITEM)
end

function PetAutoCraft.Hooks()--Place for all the hooks to load on VARIABLES_LOADED
	local WorldMapFrame_SetWorldMapID_orig = WorldMapFrame_SetWorldMapID
	function WorldMapFrame_SetWorldMapID(ID)
		if PetVendors[ID] then
			local width = WorldMapViewFrame:GetWidth()
			local height = WorldMapViewFrame:GetHeight()
			PetAutoCraft_VendorMapLocation:ClearAllAnchors()
			PetAutoCraft_VendorMapLocation:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", PetVendors[ID].X * width, PetVendors[ID].Y * height)
			PetAutoCraft_VendorMapLocation:Show()
		else
			PetAutoCraft_VendorMapLocation:Hide()
		end
		WorldMapFrame_SetWorldMapID_orig(ID)
	end

	local PetCraftStartButton_OnClick_orig = PetCraftStartButton_OnClick
	function PetCraftStartButton_OnClick(this)
		PetAutoCraft.HarvestItems()
		if not PetAutoCraftCSave.Running and PET_CRAFT_CHOOSE[PET_CURRENT_ITEM] then
			PetAutoCraftCSave.Pet = PET_CURRENT_ITEM
			PetAutoCraft_SelectPetButton:SetText(PET_CURRENT_ITEM)
			PetAutoCraft.GetCraftOptions()
			PetAutoCraftCSave.Running = true
		end
		PetCraftStartButton_OnClick_orig(this)
	end

	local PetCraftStopButton_OnClick_orig = PetCraftStopButton_OnClick
	function PetCraftStopButton_OnClick(this)
		PetAutoCraftCSave.Running = false
		PetCraftStopButton_OnClick_orig(this)
	end

	local ReloadUI_orig = ReloadUI
	function ReloadUI()
		if PetAutoCraftCSave.Running then
			PetCraftingStop(PetAutoCraftCSave.Pet)
		end
		ReloadUI_orig()
	end
end

function PetAutoCraft.UpdateSavedVariables()--Update the saved variables for changes in usage
	if PetAutoCraftGSave then --Global Variables Housecleaning
		for i, v in pairs(GlobalDefaults) do --Add new options
			if PetAutoCraftGSave[i] == nil then
				PetAutoCraftGSave[i] = v
			end
		end
		for i, v in pairs(PetAutoCraftGSave) do --Remove old options
			if GlobalDefaults[i] == nil then
				PetAutoCraftGSave[i] = nil
			end
		end
	else
		PetAutoCraftGSave = GlobalDefaults --Apply Defaults
	end
	if PetAutoCraftCSave then --Per Character Variables Housecleaning
		for i, v in pairs(CharDefaults) do --Add new options
			if PetAutoCraftCSave[i] == nil then
				PetAutoCraftCSave[i] = v
			end
		end
		for i, v in pairs(PetAutoCraftCSave) do --Remove old options
			if CharDefaults[i] == nil then
				PetAutoCraftCSave[i] = nil
			end
		end
	else
		PetAutoCraftCSave = CharDefaults --Apply Defaults
	end
	for i, v in pairs(SkillLvl) do --v1.1.0
		if PetAutoCraftCSave[i] == "Auto" then
			PetAutoCraftCSave[i] = "^^"
		end
	end
	for i, v in pairs(Tools) do --v1.1.0
		if v.Vendor then
			if PetAutoCraftCSave["Buy"..v.ID] == true then
				PetAutoCraftCSave["Buy"..v.ID] = 1
			elseif PetAutoCraftCSave["Buy"..v.ID] == false then
				PetAutoCraftCSave["Buy"..v.ID] = 0
			end
		end
	end
	for i, v in pairs(SkillLvl) do --v1.4.0
		if PetAutoCraftCSave[i] == "^^" then
			PetAutoCraftCSave[i] = "▲"
		end
	end
	SaveVariables("PetAutoCraftGSave")
	SaveVariablesPerCharacter("PetAutoCraftCSave")
end

--[[ Code snippets for later
]]