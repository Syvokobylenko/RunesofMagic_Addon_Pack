-- last changes     by: Tinsus     at: 2016-05-05T15:19:32Z     project-version: v1.9beta1     hash: 044d6c52c6f2b490ddc02d6190c7453ca05d5ddc

------------------------------------------------------------
-- INITIALIZATION ------------------------------------------
------------------------------------------------------------
LI_ZZIBPlugin_Config = LI_ZZIBPlugin_Config or {}
SaveVariables("LI_ZZIBPlugin_Config")

if not (ZZIB and ZZIB.GetBuildNumber) or ZZIB.GetBuildNumber() < 20130717194500 then
	return
end

LI.ZZIBPlugin = {
	Settings = {
		{
			Name = "LootMode",
			Default = true,
			Type = "CheckButton",
		},
	},
	Config = {
		Apply = {},
	},
	Core = {
		UpdateTooltip = {},
		UpdateLabel = {},
	},
}
-- inject translation for setting "LootMode"
LI_Transtext["LOOTMODE"] = TEXT("PB_ASSIGN_BY_DICE")

------------------------------------------------------------
-- NAMESPACE DEFINITIONS -----------------------------------
------------------------------------------------------------
local Plugin = LI.ZZIBPlugin
local Settings = Plugin.Settings
local Config = Plugin.Config
local ApplyFn = Config.Apply
local Core = Plugin.Core
local UpdateTooltip = Core.UpdateTooltip
local UpdateLabel = Core.UpdateLabel

local ZZLibrary = ZZLibrary
local zzTable, zzMath, zzString, zzClasses, zzHash, zzColors, zzStory, zzEvent, zzTimer, zzWidget, zzConfig = ZZLibrary.GetLibraries()

local LI = LI
local ZZIB = ZZIB

------------------------------------------------------------
-- PERFORMANCE LOCALS --------------------------------------
------------------------------------------------------------
local pairs = pairs
local tostring = tostring
local tonumber = tonumber
local TEXT = TEXT

------------------------------------------------------------
-- CONSTANTS -----------------------------------------------
------------------------------------------------------------
local BTN_LOOTMODE = "LI_LootMode"
local BUTTONS = {}

------------------------------------------------------------
-- CODE ----------------------------------------------------
------------------------------------------------------------
local function GetLootMethodString()
	local method = GetLootMethod()
	local theshold = GetLootThreshold()

	if LI.IsValidSystem() then
		return LI.ValidMember..": "..LI.GetQualityString(theshold)
	elseif method == "alternate" then
		return TEXT("PB_ASSIGN_BY_DICE")..": "..LI.GetQualityString(theshold)
	elseif method == "master" then
		return "|cffff8000"..TEXT("LOOT_MASTER_LOOTER")..": |r"..LI.GetQualityString(theshold)
	elseif method == "freeforall" then
		return "|cffff0000"..TEXT("LOOT_FREE_FOR_ALL").."|r"
	end

	return "-???-"
end

function Core.Init()
	ZZIB.Tools.CheckConfig("LI_ZZIBPlugin_Config", Settings)
	Core.InitButtons()
	Config.ApplyAll()

	ZZIB.Plugins.Add(
		"LootIt!",
		LI.Path.."/textures/minimapbutton-normal.tga",
		function() awsmDropdown.BuildConfig(Settings, LI_Transtext, LI_ZZIBPlugin_Config, ApplyFn, true) end,
		{
			LI.Trans("PLUGIN_DESC"),
		}
	)
end

function Core.InitButtons()
	BUTTONS = {
		LootMode = {
			Name = BTN_LOOTMODE,
			Icon = LI.Path.."/textures/dices.tga",
			Tooltip = {
				Title = LI.Trans("PLUGIN_NAME").." "..tostring(LI.version),
				Content = {
					LI.Trans("PLUGIN_USER"),
				},
			},
			Events = {
				["LootIt_Update_Event"] = UpdateLabel.LootMode,
			},
			ScriptClick = function() LI.MiniConfigShow(UIParent) end,
			ActivateCall = UpdateLabel.LootMode,
		},
	}

	for name, template in pairs(BUTTONS) do
		ApplyFn[name] = function()
			ZZIB.Tools.ApplyButtonActive(name, template, LI_ZZIBPlugin_Config)
		end
	end
end

function Core.UpdateAllLabel()
	for _, fn in pairs(UpdateLabel) do
		fn(true)
	end
end

function Config.ApplyAll()
	for _, fn in pairs(ApplyFn) do
		fn()
	end
end

function UpdateLabel.LootMode(forceUpdate)
	local Button = ZZIB.Buttons.List[BTN_LOOTMODE]
	if not Button then return end

	local methodString = GetLootMethodString()
	if Button.Value ~= methodString or forceUpdate == true then
		Button.Value = methodString

		ZZIB.Buttons.UpdateText(BTN_LOOTMODE, methodString, true)
	end
end

zzEvent.Register("ZZIB_INITDONE", Core.Init, "LI_ZZIBPlugin_Init")
zzEvent.Register("ZZIB_NEEDREDRAW", Core.UpdateAllLabel, "LI_ZZIBPlugin_UpdateAllLabel")
