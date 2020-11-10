-- last changes     by: Tinsus     at: 2013-12-28T14:17:17Z     project-version: v1.9beta1     hash: 3a0f1412468574148feaa9da20da36246a9d113c

local LI = _G.LI

function LI.RegisterAddonManager()
	if AddonManager then
		local addon = {
			name = "LootIt!",
			description = LI.Trans("ADDONMANAGER_DESCRIPTION"),
			icon = "Interface/mainmenuframe/mainmenu-bagbutton-normal.tga",
			category = "Economy",
			configFrame = LootIt_Optionen,
			slashCommands = "/li",
			miniButton = LootIt_AddonManagerButton,
			version = LI.version,
			author = "Tinsus",
			enableScript = function() LI_Data.Options.active = true end,
			disableScript = function() LI_Data.Options.active = false end,
			onClickScript = function() LootIt_Optionen:Show() end,
		}

		if AddonManager.RegisterAddonTable then
			AddonManager.RegisterAddonTable(addon)
		else
			AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript, addon.version, addon.author, addon.disableScript, addon.enableScript)
		end
	else
		LI.io("#LOADED#, |cffff0000#VERSION#: "..(LI.version).."|r (#LOADING_MESSAGE#)", 0.5, 0.7, 0.1)
	end

	if XBARVERSION and XBARVERSION >= 1.51 then
		XAddon_Register(
			{
				popup = {
					{
						icon = "Interface/mainmenuframe/mainmenu-bagbutton-normal.tga",
						GetText = function()
							return "LootIt!"
						end,
						GetTooltip = function()
							return "LootIt! "..LI.version.."\n\n/li\n\nTinsus"
						end,
						OnClick = function(this, key)
							LI.MiniConfigShow(this)
						end
					}
				}
			}
		)
	end
end

if not LI.GROUPLOOT_ROLL then
	LI.GROUPLOOT_ROLL = GROUPLOOT_ROLL
	LI.GROUPLOOT_GREED = GROUPLOOT_GREED
	LI.GROUPLOOT_CANCEL = GROUPLOOT_CANCEL
end

local comp, err = loadfile(string.format("%s/language/%s.lua", LI.Path, LI.Language))

if err then
	dofile(LI.Path .. "language/default.lua")
else
	comp()
end
