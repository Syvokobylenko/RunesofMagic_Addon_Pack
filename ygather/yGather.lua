
----------------------------------------------------------------------------------------      
--
-- yGather
--
-- Last Update
-- 2019-12-19T17:08:35Z
--
-- Last Version
-- v7.4.0
--
-- Author
--   Omnibrain
--
-- AddonManager 
--	 C3Y
--
-- Former Authors
--   adisadicul, skite2001, 
--
-- released under the GNU General Public License
--  http://rom.curseforge.com/licenses/7-gnu-general-public-license-version-3-gplv3/
--
-- Get the current version at
--   http://www.curse.com/addons/rom/yGather
--
---------------------------------------------------------------------------------------


yGather.minimapZoom = 1;

local Sol = LibStub("Sol");

yGather.Addonname = "yGather"
yGather.Version = "v7.4.0"

	if yGather.Version == "@".."project-version".."@" then
		yGather.Version = "Development"
	end
--- Intercept RoM function SetMiniMapZoomValue() to track minimap zoom
local yGather_oldSetMiniMapZoomValue = SetMiniMapZoomValue;
SetMiniMapZoomValue = function(zoom)
    yGather_oldSetMiniMapZoomValue(zoom);
    yGather.minimapZoom = zoom;
    yGather.logger.debug("set mini zoom: " .. zoom);
end

function yGather_OnLoad(this)
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("SAVE_VARIABLES");
end

function yGather.registerWithAddonManager()
    local addon = {
        name = yGather.Addonname,
        version = yGather.Version,
        author = "Omnibrain, adisadicul, skite2001, C3Y",
        description = yGather.translate("addonManager/description"),
		miniButton    = yGatherMiniButton,
        icon = "Interface/AddOns/ygather/minimap/Icon",
        category = "Economy",
        configFrame = yGather.config.configDialog, 
        slashCommand = nil,
        miniButton = nil,
    }
    if AddonManager.RegisterAddonTable then
        AddonManager.RegisterAddonTable(addon)
    else
        AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, 
            addon.configFrame, addon.slashCommand, addon.miniButton, addon.version, addon.author);
    end
end

local function WorldMapFrame_SetWorldMapID_Hook(...)
    local origFn = Sol.hooks.GetOriginalFn("yGather", "WorldMapFrame_SetWorldMapID", _G);
    if (origFn) then
        origFn(...);
    end;
    yGather.worldmap:UpdateIcons();
end

function yGather_OnEvent(this,event,arg1,arg2)
    if (event == "VARIABLES_LOADED") then
        yGather.settings.HandleVariablesLoaded();
        yGather.i18n.Initialize(yGather.settings.GetValue("misc/uilanguage"));
        yGather.matdb.LoadDB();
        yGather.database.HandleVariablesLoaded();

        if AddonManager then
            yGather.registerWithAddonManager();
        else
            yGather.logger.user("|cffFFFF00" .. yGather.translate("userMessage/AddonLoaded") .. ": |cff00FF00yGather " .. yGather.Version);
        end
        
        Sol.hooks.Hook("yGather", "WorldMapFrame_SetWorldMapID", WorldMapFrame_SetWorldMapID_Hook);

    elseif (event == "SAVE_VARIABLES") then
        yGather.settings.HandleSaveVariables();
        yGather.database.HandleSaveVariables();
    end
end

function yGather_OnUpdate(this)
end
