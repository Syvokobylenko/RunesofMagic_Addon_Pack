WheresMyHome_Settings = WheresMyHome_Settings or {}
SaveVariablesPerCharacter("WheresMyHome_Settings")

local VERSION = string.match("2.8", "^v?[%d+.]+....$") or DEV_BUILD or "Build: 2017-09-30T0:28:56Z"
local BUILD = tonumber("20170930002856") or 99999999999999
local ROOT = "Interface/Addons/WheresMyHome"

local Locales, GetLocale = ZZLibrary.LoadLocales(ROOT.."/Locales", "BASE")

local Addon = {
	Manifest = {
		Name = "WheresMyHome",
		Author = "Noguai and Amurilon",
		Version = VERSION,
		Build = BUILD,
		Path = ROOT,
		Icon = ROOT.."/Graphics/Icon.png",
	},
	Settings = {
		{
			Name = "Location",
			Default = GetLocale("UNKNOWNTARGET"),
			Type = "EditBox",
			UpdateMode = "OnValueChange",
		},
		{
			Name = "TransportbookSort",
			Default = false,
			Type = "CheckButton",
		},
		{
			Name = "TransportMode",
			Default = 1,
			Type = "DropDown",
			Items = {
					GetLocale("TRANSPORTACTION1"),
					GetLocale("TRANSPORTACTION2"),
					GetLocale("TRANSPORTACTION3"),
			},
		},
		{
			Name = "ReverseCodex",
			Default = false,
			Type = "CheckButton",
		},
		{
			Name = "Button",
			Default = true,
			Type = "CheckButton",
		},
	},
	Locales = Locales,
	Vars = {
		ButtonLoaded = false,
		FrameLoaded = false,
		NeedUpdate = true,
		ScaleValue = 1,
		CodexList = {},
	},
	Core = {
		Dropdown = {},
		Transportbook = {},
	},
	ApplyFn = {},
}
_G.WheresMyHome = Addon

local zzLibrary = ZZLibrary
local zzTable, zzMath, zzString, zzClasses, zzHash, zzColors, zzStory, zzEvent, zzTimer, zzWidget, zzConfig = zzLibrary.GetLibraries()
local ZZIB = ZZIB
local Config = WheresMyHome_Settings
local Manifest = Addon.Manifest
local Vars = Addon.Vars
local Core = Addon.Core
local Dropdown = Core.Dropdown
local Transportbook = Core.Transportbook
local ApplyFn = Addon.ApplyFn

local locMsgList = {
	TEXT("ST_TRANSFER_1"),
	TEXT("ST_TRANSFER_10"),
	TEXT("ST_TRANSFER_11"),
	TEXT("ST_TRANSFER_12"),
	TEXT("ST_TRANSFER_13"),
	TEXT("ST_TRANSFER_14"),
	TEXT("ST_TRANSFER_15"),
	TEXT("ST_TRANSFER_16"),
	TEXT("ST_TRANSFER_17"),
	TEXT("ST_TRANSFER_18"),
	TEXT("ST_TRANSFER_2"),
	TEXT("ST_TRANSFER_3"),
	TEXT("ST_TRANSFER_4"),
	TEXT("ST_TRANSFER_5"),
	TEXT("ST_TRANSFER_6"),
	TEXT("ST_TRANSFER_7"),
	TEXT("ST_TRANSFER_8"),
	TEXT("ST_TRANSFER_9"),
	TEXT("SC_SETRECORDPOINT"),
	TEXT("SC_TRANSFER_SAVEHOME_MEG"),
}
for i, locMsg in ipairs(locMsgList) do
	locMsgList[i] = locMsg:gsub("%b<>", "%%s"):gsub("%b[]", "%%s"):gsub("%%.", ".*")
end

Vars.ButtonTemplate = {
	Name = Manifest.Name.."_RecallLocation",
	Icon = Manifest.Icon,
	Tooltip = {
		Title = GetLocale("RECALLPOINT"),
		Content = {
			GetLocale("LEFT_MOUSEBUTTON")..": "..GetLocale("TRANSPORTBOOK"),
			GetLocale("RIGHT_MOUSEBUTTON")..": "..TEXT("Sys494531_name"),
			GetLocale("CTRL_LEFT_MOUSEBUTTON")..": "..GetLocale("RECALLSKILL"),
		},
	},
	Click = {
		LBUTTON = function()
			if IsCtrlKeyDown() then
				CastSpellByName(GetLocale("RECALLSKILL"))
			else
				if Config.TransportMode == 1 then
					ToggleUIFrame(TeleportBook)
				elseif awsmDropdown:IsVisible() then
					awsmDropdown.Close()
				elseif Config.TransportMode == 2 then
					Dropdown.UpdateTransportbook()
				else
					if not(Vars.FrameLoaded) then Transportbook.CreateFrame(true) return end
					if Transportbook.Frame:IsVisible() then
						Transportbook.Close()
					else
						Transportbook.Open()
					end
				end
			end
		end,
		RBUTTON = function()
			if awsmDropdown:IsVisible() then
				awsmDropdown.Close()
			else
				Dropdown.UpdateTransportmagic()
			end
		end
	},
	ActivateCall = function() ApplyFn.Location() end,
}

function Core.Init()
	Config = zzConfig.GetConfig("WheresMyHome_Settings", Addon.Settings, true)
	Core.SetupHooks()
	Core.RegisterAddonManager()
	printf("|cffff0000%s (v %s):|r "..GetLocale("ADDON_LOADED"), Manifest.Name, Manifest.Version)
end

function Core.RegisterAddonManager()
	if AddonManager then
		AddonManager.RegisterAddonTable({
			name = Manifest.Name,
			description = GetLocale("ADDON_DESCRIPTION"),
			icon = Manifest.Icon,
			category = "Other",
			version = Manifest.Version,
			author = Manifest.Author,
		})
	end
end

function Core.RegisterZZIB()
	if ZZIB and ZZIB.GetBuildNumber() >= 20140409164507 then
		ZZIB.Plugins.Add({
			Name = Manifest.Name,
			Icon = Manifest.Icon,
			Version = Manifest.Version,
			Click = function() awsmDropdown.BuildConfig(Addon.Settings, Locales, Config, ApplyFn, true) end,
			Tooltip = {
				GetLocale("ADDON_DESCRIPTION"),
				"|cffaaaaaa"..GetLocale("WRITTEN_BY")..": "..Manifest.Author.."|r",
			}
		})
	end
end

function ApplyFn.Button()
	if ZZIB and ZZIB.GetBuildNumber() >= 20130513194517 then
		ZZIB.Tools.ApplyButtonActive("Button", Vars.ButtonTemplate, Config, GetLocale)
	end
end

function ApplyFn.Location()
	if ZZIB and ZZIB.Buttons.List[Vars.ButtonTemplate.Name] then
		ZZIB.Buttons.UpdateText(Vars.ButtonTemplate.Name, Config.Location or GetLocale("UNKNOWNTARGET"), true)
	end
end

function Core.SetupHooks()
	local org_OnEnter_SkillItemButton = OnEnter_SkillItemButton
	function OnEnter_SkillItemButton(frame, button)
		org_OnEnter_SkillItemButton(frame, button)

		if Core.IsRecallSpell() then
			Core.AddRecallLocation()
		end
	end

	local org_OnEnter_SkillButton = OnEnter_SkillButton
	function OnEnter_SkillButton(frame, button)
		org_OnEnter_SkillButton(frame, button)

		if Core.IsRecallSpell() then
			Core.AddRecallLocation()
		end
	end

	local function ActionButton_OnEnter(button)
		GameTooltip:SetOwner(button, "ANCHOR_TOPLEFT", -5, 0);
		GameTooltip:SetActionItem(ActionButton_GetButtonID(button));

		if Core.IsRecallSpell() then
			Core.AddRecallLocation()
		end
	end

	local barPosition = {"Main", "Bottom", "Right", "Left"}
	for _, pos in ipairs(barPosition) do
		for i = 1, ACTIONBAR_NUM_BUTTONS do
			local button = getglobal(pos.."ActionBarFrameButton"..i)
			button.__uiLuaOnMouseEnter__ = ActionButton_OnEnter
		end
	end

	local org_SpeakFrame_AddOption = SpeakFrame_AddOption
	function SpeakFrame_AddOption( string, script, type, iconid, id, highlight )
		local Text = string or ""
		local AddRecall = function(t,i)
							script(t,i)
							Config.Location = GetZoneName() or GetLocale("UNKNOWNTARGET")
							ApplyFn.Location()
							end
		if string.find(Text,TEXT("SC_111256_S")) or string.find(Text,TEXT("SO_110561_5")) then
			org_SpeakFrame_AddOption( string, AddRecall, type, iconid, id, highlight )
		else
			org_SpeakFrame_AddOption( string, script, type, iconid, id, highlight )
		end
	end

end

function Core.CheckForRecallPoint(event, msg)
	local location = Core.GetRecallLocation(msg)

	if location then
		Config.Location = location
		ApplyFn.Location()
	end
end

function Core.IsRecallSpell()
	local tooltipTitle = GameTooltipTextLeft1:GetText()
	return string.find(tooltipTitle, GetLocale("RECALLSKILL")) ~= nil
end

function Core.GetRecallLocation(msg)
	for i, locMsg in ipairs(locMsgList) do
		if string.find(msg, locMsg) ~= nil then
			return GetZoneName() or GetLocale("UNKNOWNTARGET")
		end
	end
end

function Core.AddRecallLocation()
	GameTooltip:AddLine(GetLocale("RECALLPOINT")..": "..(Config.Location or GetLocale("UNKNOWNTARGET")))
end

-------------------
-- dropdown  v2 ---
-------------------

function Dropdown.Transportbook()
	local Dropdown = {}

	for i=1,TB_MAX_BOOKMARK do
		local IconType,Note,ZoneID,X,Y,Z,Name,file=TB_GetTeleportInfo(i)
		if IconType > 0 then

			table.insert(Dropdown, {
				Title = Note,
				Click = function(frame, key, button)
					if key == "LBUTTON" then
						if IsCtrlKeyDown() then
							if GetBagItemCount(202904) > 0 then
								TB_Teleport(1,i)
								awsmDropdown.Close()
							else
								SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
							end
						else
							if GetBagItemCount(202903) > 0 then
								TB_Teleport(0,i)
								awsmDropdown.Close()
							else
								SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
							end
						end
					else
						if IsCtrlKeyDown() then
							if GetBagItemCount(202905) > 0 then
								TB_Teleport(2,i)
								awsmDropdown.Close()
							else
								SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
							end
						else
							StaticPopupDialogs["TELEPORT_EDITNOTE"].note = Note
							StaticPopupDialogs["TELEPORT_EDITNOTE"].select = i
							StaticPopup_Show("TELEPORT_EDITNOTE")
						end
					end
				end,
				Icon = file,
				Tooltip = {
					Title = Note,
					Name,
					"",
					{TEXT("Sys202903_name_plural"),GetBagItemCount(202903)},
					{TEXT("Sys202904_name_plural"),GetBagItemCount(202904)},
					{TEXT("Sys202905_name_plural"),GetBagItemCount(202905)},
					true,
					GetLocale("LEFT_MOUSEBUTTON")..": "..TEXT("_glossary_00796"),
					GetLocale("CTRL_LEFT_MOUSEBUTTON")..": "..TEXT("_glossary_00801"),
					GetLocale("CTRL_RIGHT_MOUSEBUTTON")..": "..TEXT("_glossary_00800"),
					GetLocale("RIGHT_MOUSEBUTTON")..": "..TEXT("TB_EDITNOTE_TIP"),
				},
			})

		end
	end

	if Config.TransportbookSort then
		table.sort(Dropdown,function(a,b) return a.Title < b.Title end)
	end

--[[
	table.insert(Dropdown,1, {
		Title = GetLocale("TRANSPORTBOOK_LIST"),
		Icon = "interface/mainmenuframe/mainpopupbutton-icon-sortboard.tga",
		Type = "Label",
		Separator = true,
	})
]]
	table.insert(Dropdown,1, {
		Title = GetLocale("TRANSPORTBOOK_ADD_ENTRY"),
		Icon = "interface/TransportBook/TB_RecodePos-normal",
		Separator = true,
		Click = function(frame, key, button)
			if key == "LBUTTON" then
				for i=1,TB_MAX_BOOKMARK do
					if TB_GetTeleportInfo(i) == 0 then
						TB_SetBookMark(i)
						return
					end
				end
				SendWarningMsg(GetLocale("TRANSPORTBOOK_FULL"))
			end
		end,
		Tooltip = {
			Title = TEXT("Sys202435_name"),
			{TEXT("Sys202902_name"),GetBagItemCount(202902)},
			true,
			GetLocale("LEFT_MOUSEBUTTON")..": "..TEXT("TB_RECODE_TIP"):gsub("%%s",TEXT("Sys202902_name")),
		},
	})

	return Dropdown
end

function Dropdown.UpdateTransportbook()
	ZZIB.Buttons.UpdateDropdown(Vars.ButtonTemplate.Name, Dropdown.Transportbook())
	ZZIB.Buttons.ToggleDropdown(Vars.ButtonTemplate.Name, true)
	awsmDropdown.KeepInScreen()
end

function Dropdown.Transportmagic()
	local Dropdown = {}


	for i=1,GetNumSkill(1) do
		local name, _, icon = GetSkillDetail(1,i)
		local cooldown, remaining = GetSkillCooldown(1,i)
		remaining = math.floor(remaining)
		if name == TEXT("Sys540190_name") or name == TEXT("Sys540191_name") or name == TEXT("Sys540192_name") or name == TEXT("Sys540193_name") or name == TEXT("Sys540195_name") then
			table.insert(Dropdown, {
				Title = string.format("%s|r",remaining > 0  and "|cffff0000"..name or name),
				Click = function()
					if remaining == 0 then
						UseSkill(1,i)
						awsmDropdown.Close()
					else
						SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
					end
				end,
				Icon = icon,
				Tooltip = {
					Title = name,
					(name ~= TEXT("Sys497418_name") and TEXT("TOOLTIPS_COOLDOWN"):gsub("%%d",remaining)),
				},
			})
		elseif name == TEXT("Sys497418_name") then
			table.insert(Dropdown, {
				Title = string.format("%s|r",GetBagItemCount(202903) == 0  and "|cffff0000"..name or name),
				Icon = icon,
				Tooltip = {
					Title = name,
					(name ~= TEXT("Sys497418_name") and TEXT("TOOLTIPS_COOLDOWN"):gsub("%%d",remaining)),
				},
				Items = Core.Dropdown.CodexList(i),
			})
		end
	end

	table.sort(Dropdown,function(a,b) return a.Title < b.Title end)

	-- marriage ring
	if GetBagItemCount(202817) > 0 then
		local remaining = 0
		for i=1,180 do
			local index,_,name = GetBagItemInfo(i)
			if name == TEXT("Sys202817_name") then
				local _,cooldown = GetBagItemCooldown(index)
				remaining = math.floor(cooldown)
			break
			end
		end
		table.insert(Dropdown,1, {
			Title = string.format("%s|r",remaining > 0  and "|cffff0000"..TEXT("Sys202817_name") or TEXT("Sys202817_name")),
			Icon = "interface/icons/eq_finger- 22_1",
			Click = function()
						if remaining == 0 then
							UseItemByName(TEXT("Sys202817_name"))
							awsmDropdown.Close()
						else
							SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
						end
			end,
			Tooltip = {
				Title = TEXT("Sys202817_name"),
				TEXT("TOOLTIPS_COOLDOWN"):gsub("%%d",remaining),
				true,
				GetReplaceSystemKeyword(TEXT("Sys202817_shortnote")),
			},
		})
	end

	if GetBagItemCount(202818) > 0 then
		local remaining = 0
		for i=1,180 do
			local index,_,name = GetBagItemInfo(i)
			if name == TEXT("Sys202818_name") then
				local _,cooldown = GetBagItemCooldown(index)
				remaining = math.floor(cooldown)
			break
			end
		end
		table.insert(Dropdown,1, {
			Title = string.format("%s|r",remaining > 0  and "|cffff0000"..TEXT("Sys202818_name") or TEXT("Sys202818_name")),
			Icon = "interface/icons/eq_finger- 22_1",
			Click = function()
						if remaining == 0 then
							UseItemByName(TEXT("Sys202818_name"))
							awsmDropdown.Close()
						else
							SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
						end
			end,
			Tooltip = {
				Title = TEXT("Sys202818_name"),
				TEXT("TOOLTIPS_COOLDOWN"):gsub("%%d",remaining),
				true,
				GetReplaceSystemKeyword(TEXT("Sys202818_shortnote")),
			},
		})
	end

	if GetBagItemCount(202543) > 0 then
		local remaining = 0
		for i=1,180 do
			local index,_,name = GetBagItemInfo(i)
			if name == TEXT("Sys202543_name") then
				local _,cooldown = GetBagItemCooldown(index)
				remaining = math.floor(cooldown)
			break
			end
		end
		table.insert(Dropdown,1, {
			Title = string.format("%s|r",remaining > 0  and "|cffff0000"..TEXT("Sys202543_name") or TEXT("Sys202543_name")),
			Icon = "interface/icons/eq_finger-012",
			Click = function()
						if remaining == 0 and GetBagItemCount(202545) > 0 then
							UseItemByName(TEXT("Sys202543_name"))
							awsmDropdown.Close()
						else
							SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
						end
			end,
			Tooltip = {
				Title = TEXT("Sys202543_name"),
				{TEXT("Sys202545_name_plural"),GetBagItemCount(202545)},
				TEXT("TOOLTIPS_COOLDOWN"):gsub("%%d",remaining),
				true,
				GetReplaceSystemKeyword(TEXT("Sys202543_shortnote")),
			},
		})
	end

	if GetBagItemCount(202544) > 0 then
		local remaining = 0
		for i=1,180 do
			local index,_,name = GetBagItemInfo(i)
			if name == TEXT("Sys202544_name") then
				local _,cooldown = GetBagItemCooldown(index)
				remaining = math.floor(cooldown)
			break
			end
		end
		table.insert(Dropdown,1, {
			Title = string.format("%s|r",remaining > 0  and "|cffff0000"..TEXT("Sys202544_name") or TEXT("Sys202544_name")),
			Icon = "interface/icons/eq_finger-012",
			Click = function()
						if remaining == 0 and GetBagItemCount(202545) > 0 then
							UseItemByName(TEXT("Sys202544_name"))
							awsmDropdown.Close()
						else
							SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
						end
			end,
			Tooltip = {
				Title = TEXT("Sys202544_name"),
				{TEXT("Sys202545_name_plural"),GetBagItemCount(202545)},
				TEXT("TOOLTIPS_COOLDOWN"):gsub("%%d",remaining),
				true,
				GetReplaceSystemKeyword(TEXT("Sys202544_shortnote")),
			},
		})
	end

	-- guildhouse transport
	table.insert(Dropdown,1, {
		Title = string.format("%s|r",(GetBagItemCount(208783) > 0 or GetBagItemCount(208784) > 0 or GetBagItemCount(208785) > 0 or GetBagItemCount(202435) > 0) and TEXT("Sys202435_name") or "|cffff0000"..TEXT("Sys202435_name")),
		Icon = "interface/icons/run_tel_013",
		Click = function()
			if GetBagItemCount(208783) > 0 then
				UseItemByName(TEXT("Sys208783_name"))
			elseif GetBagItemCount(208784) > 0 then
				UseItemByName(TEXT("Sys208784_name"))
			elseif GetBagItemCount(208785) > 0 then
				UseItemByName(TEXT("Sys208785_name"))
			elseif GetBagItemCount(202435) > 0 then
				UseItemByName(TEXT("Sys202435_name"))
			else
				SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
				return
			end
			awsmDropdown.Close()
		end,
		Tooltip = {
			Title = TEXT("Sys202435_name"),
			{TEXT("Sys202435_name_plural"),GetBagItemCount(202435)},
			{TEXT("Sys208785_name_plural"),GetBagItemCount(208785)},
			{TEXT("Sys208784_name_plural"),GetBagItemCount(208784)},
			{TEXT("Sys208783_name_plural"),GetBagItemCount(208783)},
			true,
			TEXT("Sys202435_shortnote"),
		},
	})

	-- house transport
	table.insert(Dropdown,1, {
		Title = string.format("%s|r",(GetBagItemCount(208786) > 0 or GetBagItemCount(208787) > 0 or GetBagItemCount(208788) > 0 or GetBagItemCount(203784) > 0) and TEXT("Sys203784_name") or "|cffff0000"..TEXT("Sys203784_name")),
		Icon = "interface/icons/run_tel_006",
		Click = function()
			if GetBagItemCount(208786) > 0 then
				UseItemByName(TEXT("Sys208786_name"))
			elseif GetBagItemCount(208787) > 0 then
				UseItemByName(TEXT("Sys208787_name"))
			elseif GetBagItemCount(208788) > 0 then
				UseItemByName(TEXT("Sys208788_name"))
			elseif GetBagItemCount(203784) > 0 then
				UseItemByName(TEXT("Sys203784_name"))
			else
				SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
				return
			end
			awsmDropdown.Close()
		end,
		Tooltip = {
			Title = TEXT("Sys203784_name"),
			{TEXT("Sys203784_name_plural"),GetBagItemCount(203784)},
			{TEXT("Sys208788_name_plural"),GetBagItemCount(208788)},
			{TEXT("Sys208787_name_plural"),GetBagItemCount(208787)},
			{TEXT("Sys208786_name_plural"),GetBagItemCount(208786)},
			true,
			TEXT("Sys203784_shortnote"),
		},
	})


	local cooldown, remaining = GetSkillCooldown(1,2)
	remaining = math.floor(remaining)
	table.insert(Dropdown,1, {
		Title = string.format("%s|r",remaining > 0  and "|cffff0000"..TEXT("Sys490508_name").." - "..Config.Location or TEXT("Sys490508_name").." - "..Config.Location),
		Icon = "interface/icons/sys_transfer.dds",
		Click = function()
					if remaining == 0 then
						UseSkill(1,2)
						awsmDropdown.Close()
					else
						SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
					end
		end,
		Tooltip = {
			Title = TEXT("Sys490508_name"),
			Config.Location,
			TEXT("TOOLTIPS_COOLDOWN"):gsub("%%d",remaining),
			true,
			TEXT("Sys490508_shortnote"),
		},
	})

	return Dropdown
end

function Dropdown.UpdateTransportmagic()
	ZZIB.Buttons.UpdateDropdown(Vars.ButtonTemplate.Name, Dropdown.Transportmagic())
	ZZIB.Buttons.ToggleDropdown(Vars.ButtonTemplate.Name, true)
	awsmDropdown.KeepInScreen()
end

-------------------------
-- transportbookframe ---
-------------------------
Vars.TransportbookSeperator = {
		_type = "Texture",
		_name = "$parent_Sep",
		_layer = 1,
		_key = "Sep",
		Texture = ROOT.."/Graphics/verticalline",
		Anchors = {
			{ AnchorPoint = "TOPLEFT", RelativePoint = "TOPRIGHT", OffsetX = -2},
			{ AnchorPoint = "BOTTOMRIGHT", RelativePoint = "BOTTOMRIGHT", OffsetX = 2, OffsetY = 184},
		},
	}

Vars.TransportbookEntry = function(_ID)
	local template = {}

	template = {
		_type = "Button",
		_name = "$parentEntry".._ID,
		_key = "Entry".._ID,
		ID = _ID,
		Clicks = {"LeftButton","RightButton"},
		Anchors = {
			{ AnchorPoint = "TOPLEFT", RelativePoint = "TOPLEFT",OffsetY= 26*(_ID-1)},
			{ AnchorPoint = "BOTTOMRIGHT", RelativePoint = "TOPRIGHT",OffsetY= 26*_ID},
		},
		Scripts = {
			OnEnter = [[
				this.Highlight:Show()
				ZZLibrary.Tooltip(this:GetParent(),this.Tooltip.Title,this.Tooltip.Content)
				WheresMyHome.Core.Transportbook.TimeOutRemove()
				]],
			OnLeave = [[
				this.Highlight:Hide()
				ZZLibrary.TooltipHide()
				WheresMyHome.Core.Transportbook.TimeOut()
				]],
			OnClick = [[ WheresMyHome.Core.Transportbook.OnClick(this,key)]],
			OnShow = [[ WheresMyHome.Core.Transportbook.UpdateFrame()]],
		},
		Layers = {
			{
				_type = "Texture",
				_name = "$parent_Highlight",
				_layer = 1,
				_key = "Highlight",
				Hidden = true,
				Texture = "interface/buttons/listitemhighlight.tga",
				AlphaMode = "ADD",
				Anchors = {
					{ AnchorPoint = "TOPLEFT", RelativePoint = "TOPLEFT"},
					{ AnchorPoint = "BOTTOMRIGHT", RelativePoint = "BOTTOMRIGHT",OffsetX = -4},
				},
			},
			{
				_type = "Texture",
				_name = "$parent_Icon",
				_layer = 3,
				_key = "Icon",
				Anchors = {
					{ AnchorPoint = "CENTER", RelativePoint = "LEFT",OffsetX = 14},
				},
				Size = {
					Height = 22,
					Width = 22,
				},
			},
			{
				_type = "FontString",
				_name = "$parent_Name",
				_layer = 3,
				_key = "Name",
				Text =" test ",
				JustifyH = "LEFT",
				Color = {R=1,G=1,B=1},
				Font = {
					Size = 10,
				},
				Anchors = {
					{ AnchorPoint = "LEFT", RelativePoint = "RIGHT", RelativeTo = "$parent_Icon", OffsetX = 4},
					{ AnchorPoint = "RIGHT", RelativePoint = "RIGHT",OffsetX = -4},
				},
			},
		},
	}
	return template
end

Vars.TransportbookPage = function(_ID)
	local template = {}

	template = {
		_type = "Frame",
		_name = "$parentPage".._ID,
		_key = "Page".._ID,
		ID = _ID,
		Size = {
			Height = 0,
			Width = 150,
		},
		Anchors = {
			{ AnchorPoint = "TOPLEFT", RelativePoint = "TOPLEFT", OffsetX=4+(_ID-1)*150,OffsetY=4},
		},
		Layers = {
			[1] = Vars.TransportbookSeperator,
		},
		Frames = {
			[1] = Vars.TransportbookEntry(1),
			[2] = Vars.TransportbookEntry(2),
			[3] = Vars.TransportbookEntry(3),
			[4] = Vars.TransportbookEntry(4),
			[5] = Vars.TransportbookEntry(5),
			[6] = Vars.TransportbookEntry(6),
			[7] = Vars.TransportbookEntry(7),
		},
	}
	return template
end

Vars.Transportbook ={
	_type = "Frame",
	_name = "WMH_Transportbook",
	Hidden = true,
	FrameStrata = "HIGH",
	MouseEnable = true,
	Scripts = {
		OnLoad = [[ this["Page7"].Sep:Hide() ]],
		OnShow = [[ --WheresMyHome.Core.Transportbook.UpdateFrame() ]],
		OnEnter = [[ WheresMyHome.Core.Transportbook.TimeOutRemove() ]],
		OnLeave = [[ WheresMyHome.Core.Transportbook.TimeOut() ]],
	},
	Anchors = {
		{ AnchorPoint = "CENTER", RelativePoint = "CENTER"},
	},
	Size = {
		Height = 190,
		Width = 1058,
	},
	Backdrop = {
        edgeFile = "Interface/Tooltips/Tooltip-border",
        bgFile = "Interface/Tooltips/Tooltip-background",
        BackgroundInsets = { top = 4, left = 4, bottom = 4, right = 4 },
        EdgeSize = 16,
        TileSize = 16,
    },
	Frames = {
		[1] = Vars.TransportbookPage(1),
		[2] = Vars.TransportbookPage(2),
		[3] = Vars.TransportbookPage(3),
		[4] = Vars.TransportbookPage(4),
		[5] = Vars.TransportbookPage(5),
		[6] = Vars.TransportbookPage(6),
		[7] = Vars.TransportbookPage(7),
		[8] = {
			_type = "Button",
			_name = "$parentMarker",
			_key = "Marker",
			Anchors = {
				{ AnchorPoint = "BOTTOMLEFT", RelativePoint = "TOPLEFT"},
			},
			Size = {
				Height = 36,
				Width = 158,
			},
			Backdrop = {
				edgeFile = "Interface/Tooltips/Tooltip-border",
				bgFile = "Interface/Tooltips/Tooltip-background",
				BackgroundInsets = { top = 4, left = 4, bottom = 4, right = 4 },
				EdgeSize = 16,
				TileSize = 16,
			},
			Scripts = {
				OnEnter = [[
					this.Highlight:Show()
					ZZLibrary.Tooltip(this,this.Tooltip.Title,this.Tooltip.Content)
					WheresMyHome.Core.Transportbook.TimeOutRemove()
					]],
				OnLeave = [[
					this.Highlight:Hide()
					ZZLibrary.TooltipHide()
					WheresMyHome.Core.Transportbook.TimeOut()
					]],
				OnClick = [[
					WheresMyHome.Core.Transportbook.OnClickMarker(this,key)
					]],
			},
			Layers = {
				{
					_type = "Texture",
					_name = "$parent_Highlight",
					_layer = 1,
					_key = "Highlight",
					Hidden = true,
					Texture = "interface/buttons/listitemhighlight.tga",
					AlphaMode = "ADD",
					Anchors = {
						{ AnchorPoint = "TOPLEFT", RelativePoint = "TOPLEFT", OffsetX=4, OffsetY = 4},
						{ AnchorPoint = "BOTTOMRIGHT", RelativePoint = "BOTTOMRIGHT", OffsetX=-4, OffsetY = -4},
					},
				},
				{
					_type = "Texture",
					_name = "$parent_Icon",
					_layer = 3,
					_key = "Icon",
					Texture = "interface/TransportBook/TB_RecodePos-normal",
					Anchors = {
						{ AnchorPoint = "CENTER", RelativePoint = "LEFT",OffsetX = 18},
					},
					Size = {
						Height = 22,
						Width = 22,
					},
				},
				{
					_type = "FontString",
					_name = "$parent_Name",
					_layer = 3,
					_key = "Name",
					Text = GetLocale("TRANSPORTBOOK_ADD_ENTRY"),
					JustifyH = "LEFT",
					Color = {R=1,G=1,B=1},
					Font = {
						Size = 10,
					},
					Anchors = {
						{ AnchorPoint = "LEFT", RelativePoint = "RIGHT", RelativeTo = "$parent_Icon", OffsetX = 2},
						{ AnchorPoint = "RIGHT", RelativePoint = "RIGHT"},
					},
				},
			},
		},
	},
}

function Transportbook.CreateFrame(OpenFrame)
	if Config.TransportMode ~= 3 then return end

	Transportbook.Frame = ZZLibrary.Widget.Create(Vars.Transportbook)

	Vars.FrameLoaded = true

	Transportbook.UpdateAnchor()
	Transportbook.SetScaleValue()
	if OpenFrame then
		zzTimer.Add({1, 0}, function()
		Transportbook.Open()
		end, Manifest.Name.."_DelayedOpening")
	end
end

function Transportbook.UpdateAnchor()
	Transportbook.Frame:ClearAllAnchors()
	Transportbook.Frame.Marker:ClearAllAnchors()
	local Xoffset = 16 * (ZZIB_Config["Bar_Rows"] + 1)
	if ZZIB_Config["Bar_LowerEdge"] then
		Transportbook.Frame.Marker:SetAnchor("BOTTOMLEFT", "TOPLEFT", Transportbook.Frame)
		Transportbook.Frame:SetAnchor("BOTTOM", "BOTTOM", "UIParent", 0, -Xoffset)
	else
		Transportbook.Frame.Marker:SetAnchor("TOPLEFT", "BOTTOMLEFT", Transportbook.Frame)
		Transportbook.Frame:SetAnchor("TOP", "TOP", "UIParent", 0, Xoffset)
	end
end

function Transportbook.SetScaleValue()
	if not(Vars.FrameLoaded) then return end
	local screenWidth = GetScreenWidth()
	local frameWidth = Transportbook.Frame:GetWidth()

	Vars.ScaleValue = (screenWidth*0.9)/frameWidth
end

function Transportbook.Open()

		zzStory.New("WMH_Transportbook", {
			{
				_Frame = Transportbook.Frame,
				_Start = function()
					Transportbook.Frame:Show()
					PlaySoundByPath("sound/interface/ui_dropdown_open.mp3")
				end,
				_End = function()
					Transportbook.UpdateFrame()
				end,
				_Time = 0.125,
				SetAlpha = {
					From = {0},
					To = {1}
				},
				SetScale = {
					From = {Vars.ScaleValue-0.2},
					To = {Vars.ScaleValue}
				},
			},
		}, 60)

end

function Transportbook.Close()

		zzStory.New("WMH_Transportbook", {
			{
				_Frame = Transportbook.Frame,
				_End = function()
					Transportbook.Frame:Hide()
				end,
				_Time = 0.1,
				SetAlpha = {
					From = {1},
					To = {0}
				},
				SetScale = {
					From = {Vars.ScaleValue},
					To = {Vars.ScaleValue-0.2}
				},
			},
		}, 60)
end

function Transportbook.TimeOut()
	zzTimer.Add({2, 0}, function()
		Transportbook.Close()
	end, Manifest.Name.."_Timeout")
end

function Transportbook.TimeOutRemove()
	zzTimer.Remove("WheresMyHome_Timeout")
end

function Transportbook.UpdateFrame()
	if not(Vars.NeedUpdate) then return end
	local Transportpoints = {[1]={},[2]={},[3]={},[4]={},[5]={},[6]={},[7]={}}
	Vars.NeedUpdate = false

	Transportbook.Frame.Marker.Tooltip = {
			Title = TEXT("Sys202435_name"),
			Content = {
				{TEXT("Sys202902_name"),GetBagItemCount(202902)},
				true,
				GetLocale("LEFT_MOUSEBUTTON")..": "..TEXT("TB_RECODE_TIP"):gsub("%%s",TEXT("Sys202902_name")),
			},
		}

	for i=1,TB_MAX_BOOKMARK do
		local IconType,Note,ZoneID,X,Y,Z,Name,file=TB_GetTeleportInfo(i)
		if IconType > 0 then
			Transportpoints[math.floor((i-1)/7+1)][(i-1)%7] = {i,Note,Name,file}
		end
	end

	for i=1,7 do
		for k=1,7 do
			Transportbook.Frame["Page"..i]["Entry"..k]:Hide()
		end
	end

	for i=1,7 do
		for k,v in pairs(Transportpoints[i]) do
			local Entry = Transportbook.Frame["Page"..i]["Entry"..k+1]
			Entry:Show()
			Entry.Tooltip = {
					Title = v[2],
					Content = {
						v[3],
						"",
						{TEXT("Sys202903_name_plural"),GetBagItemCount(202903)},
						{TEXT("Sys202904_name_plural"),GetBagItemCount(202904)},
						{TEXT("Sys202905_name_plural"),GetBagItemCount(202905)},
						true,
						GetLocale("LEFT_MOUSEBUTTON")..": "..TEXT("_glossary_00796"),
						GetLocale("CTRL_LEFT_MOUSEBUTTON")..": "..TEXT("_glossary_00801"),
						GetLocale("CTRL_RIGHT_MOUSEBUTTON")..": "..TEXT("_glossary_00800"),
						GetLocale("RIGHT_MOUSEBUTTON")..": "..TEXT("TB_EDITNOTE_TIP"),
					},
				}
			Entry.Icon:SetFile(v[4])
			Entry.Name:SetText(v[2])
			Entry:SetID(v[1])
		end
	end
end

function Transportbook.OnClick(this,key)
	local ID = this:GetID()
	if key == "LBUTTON" then
		if IsCtrlKeyDown() then
			if GetBagItemCount(202904) > 0 then
				TB_Teleport(1,ID)
				this:GetParent():GetParent():Hide()
			else
				SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
			end
		else
			if GetBagItemCount(202903) > 0 then
				TB_Teleport(0,ID)
				this:GetParent():GetParent():Hide()
			else
				SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
			end
		end
	else
		if IsCtrlKeyDown() then
			if GetBagItemCount(202905) > 0 then
				TB_Teleport(2,ID)
				this:GetParent():GetParent():Hide()
			else
				SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
			end
		else
			StaticPopupDialogs["TELEPORT_EDITNOTE"].note = Note
			StaticPopupDialogs["TELEPORT_EDITNOTE"].select = ID
			StaticPopup_Show("TELEPORT_EDITNOTE")
		end
	end
end

function Transportbook.OnClickMarker(this,key)
	if key == "LBUTTON" then
		if GetBagItemCount(202902) > 0 then
			for i=1,TB_MAX_BOOKMARK do
				if TB_GetTeleportInfo(i) == 0 then
					TB_SetBookMark(i)
					this:GetParent():Hide()
					return
				end
			end
			SendWarningMsg(GetLocale("TRANSPORTBOOK_FULL"))
		else
			SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_102"))
		end
	end
end

-------------------------
-- transportmagic of black codex ---
-------------------------
Vars.CodexList = {
	{name = TEXT("SC_DUNGEONS_DIALOG_1_1"):gsub("%[$VAR1%]","8")	,clicklist={0,0}	,icon = "interface/icons/map_zone1"},
	{name = TEXT("SC_DUNGEONS_DIALOG_1_2"):gsub("%[$VAR1%]","13")	,clicklist={0,1}	,icon = "interface/icons/map_zone10"},
	{name = TEXT("SC_DUNGEONS_DIALOG_1_3"):gsub("%[$VAR1%]","14")	,clicklist={0,2}	,icon = "interface/icons/map_zone1"},
	{name = TEXT("SC_DUNGEONS_DIALOG_1_4"):gsub("%[$VAR1%]","22")	,clicklist={0,3}	,icon = "interface/icons/map_zone2"},
	{name = TEXT("SC_DUNGEONS_DIALOG_1_5"):gsub("%[$VAR1%]","30")	,clicklist={0,4}	,icon = "interface/icons/map_zone4"},
	{name = TEXT("SC_DUNGEONS_DIALOG_1_6"):gsub("%[$VAR1%]","35")	,clicklist={0,5}	,icon = "interface/icons/map_zone11"},
	{name = TEXT("SC_DUNGEONS_DIALOG_1_7"):gsub("%[$VAR1%]","38")	,clicklist={0,6}	,icon = "interface/icons/map_zone5"},
	{name = TEXT("SC_DUNGEONS_DIALOG_1_8"):gsub("%[$VAR1%]","45")	,clicklist={0,7,0}	,icon = "interface/icons/map_zone10"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_1"):gsub("%[$VAR1%]","50")	,clicklist={1,0}	,icon = "interface/icons/map_zone11"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_2"):gsub("%[$VAR1%]","50")	,clicklist={1,1}	,icon = "interface/icons/map_zone6"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_3"):gsub("%[$VAR1%]","50")	,clicklist={1,2}	,icon = "interface/icons/map_zone11"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_4"):gsub("%[$VAR1%]","50")	,clicklist={1,3}	,icon = "interface/icons/map_zone3"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_5"):gsub("%[$VAR1%]","52")	,clicklist={1,4}	,icon = "interface/icons/map_zone7"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_6"):gsub("%[$VAR1%]","55")	,clicklist={1,5}	,icon = "interface/icons/map_zone4"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_7"):gsub("%[$VAR1%]","55")	,clicklist={1,6}	,icon = "interface/icons/map_zone1"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_8"):gsub("%[$VAR1%]","55")	,clicklist={1,7,0}	,icon = "interface/icons/map_zone9"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_9"):gsub("%[$VAR1%]","55")	,clicklist={1,7,1}	,icon = "interface/icons/map_zone2"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_10"):gsub("%[$VAR1%]","55")	,clicklist={1,7,2}	,icon = "interface/icons/map_zone9"},
	{name = TEXT("SC_DUNGEONS_DIALOG_2_11"):gsub("%[$VAR1%]","55")	,clicklist={1,7,3}	,icon = "interface/icons/map_zone9"},
	{name = TEXT("SC_DUNGEONS_DIALOG_3_1"):gsub("%[$VAR1%]","57")	,clicklist={2,0}	,icon = "interface/icons/map_zone15"},
	{name = TEXT("SC_DUNGEONS_DIALOG_3_2"):gsub("%[$VAR1%]","58")	,clicklist={2,1}	,icon = "interface/icons/map_zone16"},
	{name = TEXT("SC_DUNGEONS_DIALOG_3_3"):gsub("%[$VAR1%]","60")	,clicklist={2,2}	,icon = "interface/icons/map_zone17"},
	{name = TEXT("SC_DUNGEONS_DIALOG_3_4"):gsub("%[$VAR1%]","62")	,clicklist={2,3}	,icon = "interface/icons/map_zone18"},
	{name = TEXT("SC_DUNGEONS_DIALOG_3_5"):gsub("%[$VAR1%]","65")	,clicklist={2,4}	,icon = "interface/icons/map_zone19"},
	{name = TEXT("SC_DUNGEONS_DIALOG_3_6"):gsub("%[$VAR1%]","67")	,clicklist={2,5}	,icon = "interface/icons/map_zone20"},
	{name = TEXT("SC_DUNGEONS_DIALOG_3_7"):gsub("%[$VAR1%]","70")	,clicklist={2,6}	,icon = "interface/icons/map_zone15"},
	{name = TEXT("SC_DUNGEONS_DIALOG_4_1"):gsub("%[$VAR1%]","72")	,clicklist={3,0}	,icon = "interface/icons/map_zone22"},
	{name = TEXT("SC_DUNGEONS_DIALOG_4_2"):gsub("%[$VAR1%]","75")	,clicklist={3,1}	,icon = "interface/icons/map_zone23"},
	{name = TEXT("SC_DUNGEONS_DIALOG_4_3"):gsub("%[$VAR1%]","77")	,clicklist={3,2}	,icon = "interface/icons/map_zone24"},
	{name = TEXT("SC_DUNGEONS_DIALOG_4_4"):gsub("%[$VAR1%]","80")	,clicklist={3,3}	,icon = "interface/icons/map_zone25"},
	{name = TEXT("SC_DUNGEONS_DIALOG_4_5"):gsub("%[$VAR1%]","82")	,clicklist={3,4}	,icon = "interface/icons/map_zone26"},
	{name = TEXT("SC_DUNGEONS_DIALOG_5_1"):gsub("%[$VAR1%]","85")	,clicklist={4,0}	,icon = "interface/icons/map_zone27"},
	{name = TEXT("SC_DUNGEONS_DIALOG_5_2"):gsub("%[$VAR1%]","87")	,clicklist={4,1}	,icon = "interface/icons/map_zone28"},
	{name = TEXT("SC_DUNGEONS_DIALOG_5_3"):gsub("%[$VAR1%]","90")	,clicklist={4,2}	,icon = "interface/icons/map_zone29"},
	{name = TEXT("SC_DUNGEONS_DIALOG_5_4"):gsub("%[$VAR1%]","92")	,clicklist={4,3}	,icon = "interface/icons/map_zone30"},
	{name = TEXT("SC_DUNGEONS_DIALOG_6_1"):gsub("%[$VAR1%]","95")	,clicklist={5,0}	,icon = "interface/icons/map_zone32"},
	{name = TEXT("SC_DUNGEONS_DIALOG_6_2"):gsub("%[$VAR1%]","97")	,clicklist={5,1}	,icon = "interface/icons/map_zone33"},
	{name = TEXT("SC_DUNGEONS_DIALOG_6_3"):gsub("%[$VAR1%]","97")	,clicklist={5,2}	,icon = "interface/icons/map_zone33"},
	{name = TEXT("SC_DUNGEONS_DIALOG_6_4"):gsub("%[$VAR1%]","98")	,clicklist={5,3}	,icon = "interface/icons/map_zone34"},
	{name = TEXT("SC_DUNGEONS_DIALOG_6_5"):gsub("%[$VAR1%]"," 99 ")	,clicklist={5,4}	,icon = "interface/icons/map_zone35"},
	{name = TEXT("SC_DUNGEONS_DIALOG_6_6"):gsub("%[$VAR1%]"," 100 ")	,clicklist={5,5}	,icon = "interface/icons/map_zone36"},
}

function Dropdown.CodexList(skillid)
	if GetBagItemCount(202903) == 0 then return nil end

	local Dropdown = {}
	local MaxEntry = #Vars.CodexList

	for k,v in ipairs(Vars.CodexList) do
		local list = zzTable.Merge({},v.clicklist)
		local Entry = {
			Title = v.name,
			Icon = v.icon,
			Click = function()
				UseSkill(1,skillid)
				awsmDropdown.Close()
				zzTimer.Add({3.5, 0}, function()
					Core.Dropdown.CodexAction(list)
				end, Manifest.Name.."_KodexTimer")

			end,
		}
		if Config.ReverseCodex then
			Dropdown[MaxEntry]=Entry
			MaxEntry = MaxEntry-1
		else
			table.insert(Dropdown,Entry)
		end
	end
	return Dropdown
end

function Dropdown.CodexAction(clicklist)
	if not(SpeakFrame:IsVisible()) then return end
	ChoiceListDialogOption(clicklist[1])
	if #clicklist > 1 then
		table.remove(clicklist,1)
		zzTimer.Add({1, 0}, function()
			Dropdown.CodexAction(clicklist)
		end, Manifest.Name.."_KodexTimer")
	end
end

zzEvent.Register("VARIABLES_LOADED", Core.Init, Manifest.Name.."_Init")
zzEvent.Register("CHAT_MSG_SYSTEM", Core.CheckForRecallPoint, Manifest.Name.."_CheckChat")
zzEvent.Register("ZZIB_INITDONE", function() Core.RegisterZZIB() ApplyFn.Button() Transportbook.CreateFrame() end, Manifest.Name.."_InitZZIB")
zzEvent.Register("ZZIB_NEEDREDRAW", ApplyFn.Location, Manifest.Name.."_UpdateAllLabel")
zzEvent.Register("ADD_DROPDOWN_OPENING", function() if Vars.FrameLoaded and Transportbook.Frame:IsVisible() then Transportbook.Close() end end, Manifest.Name.."_CloseTransportframe")
zzEvent.Register("TB_UPDATE",function() Vars.NeedUpdate = true end, Manifest.Name.."_UpdateTransportframe")
zzEvent.Register("SCREEN_RESIZE",Transportbook.SetScaleValue, Manifest.Name.."_RescaleFrame")

--zzEvent.Register("SHOW_REQUESTLIST_DIALOG",print, Manifest.Name.."_test3")

