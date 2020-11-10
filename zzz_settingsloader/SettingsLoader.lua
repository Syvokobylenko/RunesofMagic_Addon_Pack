local SettingsLoader = {}

_G.SettingsLoader = SettingsLoader

function SettingsLoader.ButtonOnClick(this,key)
	if not IsShiftKeyDown() then
		DEFAULT_CHAT_FRAME:AddMessage("Loading data from file: Interface/AddOns/zzz_settingsloader/SaveVariables.lua");
		dofile("Interface/AddOns/zzz_settingsloader/SaveVariables.lua")
		DEFAULT_CHAT_FRAME:AddMessage("Loading Successful, please restart the game!");
	end
end

function SettingsLoader.ButtonOnEnter(this)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT", 4, 0)
	GameTooltip:SetText("Settings Loader - Click to Load from Interface/AddOns/zzz_settingsloader/SaveVariables.lua", 1, 1, 1)
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95)
	GameTooltip:Show()
end

function SettingsLoader.ButtonOnLeave(this)
	GameTooltip:Hide()
end