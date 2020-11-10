--[[
AddonManager by Alleris.
Maintained by McBen

AddonManager helps you keep track of your addons and provides easy ways to access them.

For users:
- Type /addons to see all your registered addons
- Alternatively, click on the AddonManager button in the "Mini Addons" bar


For addon developers:
- Add a call to AddonManager.RegisterAddonTable in your VARIABLES_LOADED event
- I recommend not printing out that your addon has loaded if you use addon manager,
  since the user will be able to see it in the addon manager list.


- The only things you should change here are the Button's name and the two textures.
- Note that you can't have a MiniButton if your addon is passive (because what should happen
  when the user clicks on it?). A passive addon is one that has no config frame and no
  custom onClickScript.

--]]


local Sol = LibStub("Sol")
local Nyx = LibStub("Nyx")
local WaitTimer = LibStub("WaitTimer")

local DEFAULT_ICON = "interface/icons/reci_car_001"
local TAB_ICON_PATH = "Interface/Addons/AddonManager/Textures/"

local AddonManager = {}
_G.AddonManager = AddonManager

AddonManager.Addons = {}
AddonManager.VERSION = "v6.0.7"


AddonManager.L = Nyx.LoadLocalesAuto("interface/addons/AddonManager/locales/","en")

AddonManager.Categories = {
    "Development",
    "Economy",
    "Information",
    "Interface",
    "Inventory",
    "Leveling",
    "Map",
    "PvP",
    "Social",
    "Crafting",
    "Other"
}

local DefaultSettings = {
    MovePassiveToBack = true,
    ShowMiniBar = true,
    ShowOnlyNamesInMiniBar = true,
    ShowSlashCmdInsteadOfCat = false,
    ShowMiniBarBorder = true,
    ShowMinimapButton = true,
    AutoHideMiniBar = true,
    LockMiniBar = true,
    CharBasedEnable = true,
}

AddonManager_UncheckedAddons = {}
AddonManager_DisabledAddons = {}
AddonManager_MinimapButtons = {
	["MinimapFrameBulletinButton"] = false,
	["MinimapFrameQuestTrackButton"] = false,
}

local AddonManager_Loaded = false
local current_tab = nil

local function FindAddon(name)
    for _, v in ipairs(AddonManager.Addons) do
        if v.name==name then
            return v
        end
    end
end

local function GetKeyName()
    local realm =  Nyx.GetCurrentRealm()
    local mainClass, secondClass = "",""
    if AddonManager_Settings.CharBasedEnable then
        mainClass, secondClass = UnitClass("player")
    end
    return string.format("%s:%s:%s",tostring(realm),tostring(mainClass),tostring(secondClass))
end

local function SetAddonEnabled(name, enabled)
    local key = GetKeyName()
    if enabled then
        if AddonManager_DisabledAddons[key] then
            AddonManager_DisabledAddons[key][name] = nil
            if next(AddonManager_DisabledAddons[key])==nil then
                AddonManager_DisabledAddons[key]=nil
            end
        end
    else
        AddonManager_DisabledAddons[key] = AddonManager_DisabledAddons[key] or {}
        AddonManager_DisabledAddons[key][name] =  true
    end
end

local function CheckDisabledState()
    local key = GetKeyName()
    local isdisabled = AddonManager_DisabledAddons[key] or {}

    for _, addon in pairs(AddonManager.Addons) do

        if isdisabled[name] then
            if addon.disableScript and not addon.isdisabled then
                addon.isdisabled=true
                addon.disableScript()
            end
        else
            if addon.enableScript and addon.isdisabled then
                addon.isdisabled=nil
                addon.enableScript()
            end
        end
    end
end


--[[
 !! OBSOLETE: use AddonManager.RegisterAddonTable instead !!
--]]
AddonManager.RegisterAddon = function(name, description, icon, category, configFrame, slashCommands,
    miniButton, onClickScript, version, author, disableScript, enableScript)

    local addon = {
        name = name,
        description = description,
        icon = icon,
        category = category,
        configFrame = configFrame,
        slashCommands = slashCommands,
        miniButton = miniButton,
        onClickScript = onClickScript,
        version = version,
        author = author,
        disableScript,
        enableScript,
    }

    AddonManager.RegisterAddonTable(addon)
end


--[[
Registers an addon with AddonManager. Adds the addon to the addons list and potentially also to the mini-addons-frame.

Parameters:
+ addon - A table of key-value pairs, with the keys being the parameters to AddonManager.RegisterAddonTable
          Except "name" all parameters are optional!

Example:
    if AddonManager and AddonManager.RegisterAddonTable then
        local addon = {
            -- Information
            name = "MyAddonName",
            icon = "Interface/Addons/MyAddon/myAddon32.tga",
            version = "v0.01",
            author = "Me",
            translators = "Guy",
            description = "My addon makes you awesome",
            category = "Other",
            slashCommand = "/myaddon",

            -- Config-Frames
            configFrame = MyAddonConfigFrame,
            disableScript = MyAddon_Disable,
            enableScript = MyAddon_Enable,
            onClickScript= MyAddon_Config,

            -- Mini Button
            mini_icon = "Interface/Addons/MyAddon/myAddon32.tga",
            mini_icon_pushed = "Interface/Addons/MyAddon/myAddon32.tga",
            mini_onClickScript= MyAddon_Action,
            -- miniButton = MyAddonMiniButton, ! OBSOLETE !
        }
        AddonManager.RegisterAddonTable(addon)
    end


Description:
+ name          - Your addon's name.
+ description   - A brief (one or two sentence) description of your addon. Something that fits in a tooltip.
+ icon          - Path to a 32x32 image icon (e.g., "Interface/Addons/AddonManager/Textures/addonManagerIcon32.tga").
                  If no icon is specified, will use default "recipe" icon.
+ category      - One of AddonManager.Categories; will be used for filtering the addons list. Default is "Other".
+ configFrame   - If your addon has a config frame or other frame you want to show when your addon is clicked, use this.
+ slashCommands - Specify any slash commands you've registered so that the user doesn't have to remember them.
+ miniButton    - If you want to display a minimap-style button on the AddonManager "Mini Addons" frame, specify it here.
                  Note that you must have a valid minimap button created in your xml and your addon must not be passive
                  for this to work. See above for details.
+ onClickScript - If you need to special handling when your addon's button is clicked, you can specify a script for it.
                  If this parameter is specified, configFrame is ignored.
                  Function call is  "MyAddon_Config(frame,key)"
+ version       - Your addon's version. To be displayed in the tooltip.
+ author        - Who made this addon.
+ disableScript - A script that can be used to disable your addon. Adds the disable option in the AddonManager list if
                  both disableScript and enableScript are specified
+ enableScript  - A script that can be used to re-enable your addon

--]]
function AddonManager.RegisterAddonTable(addon)

    if type(addon) ~= "table" then
        error("AddonManager: table expected got "..tostring(addon),2)
    end

    if not addon.name then
        local errtxt = "AddonManager: addon.name required"
        DEFAULT_CHAT_FRAME:AddMessage(errtxt)
        error(errtxt,2)
    end

    if FindAddon(addon.name) then
        local errtxt = "AddonManager: addon "..addon.name.." already exists"
        DEFAULT_CHAT_FRAME:AddMessage(errtxt)
        error(errtxt,2)
    end

    if not addon.category or not Nyx.TableIndexOf(AddonManager.Categories, addon.category) then
        addon.category = "Other"
    end

    if type(addon.onClickScript)~="function" then
        addon.onClickScript=nil
    end

    if type(addon.mini_onClickScript)~="function" then
        addon.mini_onClickScript=nil
    end

    if type(addon.disableScript)~="function" then
        addon.disableScript=nil
    end

    if type(addon.enableScript)~="function" then
        addon.enableScript=nil
    end

    local inserted = false
    for i, v in ipairs(AddonManager.Addons) do
        if AddonManager.AddonSortFn(addon, v) then
            inserted = true
            table.insert(AddonManager.Addons, i, addon)
            break
        end
    end
    if not inserted then
        table.insert(AddonManager.Addons, addon)
    end

    if AddonManager_Loaded then

        if AddonManagerFrame:IsVisible() then
            AddonManager.Update()
        end

        if AddonManager.HasMiniButton(addon) then
            AddonManager.Mini.AddIcon(addon)
        end

        if AddonManager.IsAddonDisabled(addon.name) and addon.disableScript then
            addon.isdisabled=true
            addon.disableScript()
        end
    end
end

local function LocalizeSettingPage()
    AddonManagerFramePageSettingsMainCategoryLabel:SetText(AddonManager.L["SETTING_MainCategory"])
    AddonManagerFramePageSettingsMiniCategoryLabel:SetText(AddonManager.L["SETTING_MiniCategory"])
    AddonManagerConfig_ToggleMovePassiveToBackLabel:SetText(AddonManager.L["SETTING_MovePassiveToBack"])
    AddonManagerConfig_ToggleShowSlashCmdInsteadOfCatLabel:SetText(AddonManager.L["SETTING_ShowSlashCmdInsteadOfCat"])
    AddonManagerConfig_ToggleShowMinimapButtonLabel:SetText(AddonManager.L["SETTING_ShowMinimapButton"])
    AddonManagerConfig_ToggleClassBasedEnableLabel:SetText(AddonManager.L["SETTING_CharBasedEnable"])

    AddonManagerConfig_ToggleShowMiniBarLabel:SetText(AddonManager.L["SETTING_ShowMiniBar"])
    AddonManagerConfig_ToggleShowOnlyNamesInMiniBarLabel:SetText(AddonManager.L["SETTING_ShowOnlyNamesInMiniBar"])
    AddonManagerConfig_ToggleShowMiniBarBorderLabel:SetText(AddonManager.L["SETTING_ShowMiniBarBorder"])
    AddonManagerConfig_ToggleAutoHideMiniBarLabel:SetText(AddonManager.L["SETTING_AutoHideMiniBar"])
    AddonManagerConfig_ToggleLockMiniBarLabel:SetText(AddonManager.L["SETTING_LockMiniBar"])
end

function AddonManager.OnLoad(frame)
	frame:RegisterEvent("VARIABLES_LOADED")
	frame:RegisterEvent("LOADING_END")
    frame:RegisterEvent("UNIT_CLASS_CHANGED")
    LocalizeSettingPage()
end


local function RegisterMySelf()
    local addonMgr = {
        name = "AddonManager",
        version = AddonManager.VERSION,
        author = "McBen, Alleris",
        description = AddonManager.L.description,
        icon = TAB_ICON_PATH .. "addonManagerIcon32",
        category = "Information",
        configFrame = AddonManagerFrame,
        slashCommands = "/addons",
        mini_icon ="Interface/AddOns/AddonManager/Textures/addonManagerMiniIcon",
        mini_icon_pushed ="Interface/AddOns/AddonManager/Textures/addonManagerMiniIconInv",
    }
    AddonManager.RegisterAddonTable(addonMgr)
end

function AddonManager.OnEvent(_, event)
    AddonManager[event]()
end

function AddonManager.VARIABLES_LOADED()

    AddonManager_Settings = Nyx.TableMerge(AddonManager_Settings, DefaultSettings)
    SaveVariables("AddonManager_Settings")
    SaveVariables("AddonManager_UncheckedAddons")
    SaveVariables("AddonManager_MinimapButtons")
    SaveVariablesPerCharacter("AddonManager_DisabledAddons")


    local categories = {C_ALL}
    for _,cat in ipairs(AddonManager.Categories) do
        table.insert(categories, AddonManager.L.CAT[cat])
    end

    -- Setup main dialog
    Sol.config.SetupDropdown(AddonManagerCategoryFilter, categories, 1, 110, AddonManager.Update)

    PanelTemplates_IconTabInit(AddonManagerFrameTabAddons, TAB_ICON_PATH .. "addonsTab2", AddonManager.L.TAB_Addons)
    PanelTemplates_IconTabInit(AddonManagerFrameTabMapButtons, TAB_ICON_PATH .. "minimaptab", "Minimap-Buttons")
    PanelTemplates_IconTabInit(AddonManagerFrameTabSettings, TAB_ICON_PATH .. "settingsTab", AddonManager.L.TAB_Setup)
    SkillTab_SetActiveState(AddonManagerFrameTabAddons, true)
    SkillTab_SetActiveState(AddonManagerFrameTabMapButtons, false)
    SkillTab_SetActiveState(AddonManagerFrameTabSettings, false)

    AddonManagerFrame.tab = AddonManagerFrameTabAddons
    AddonManager.SelectTab(AddonManagerFrameTabAddons)

    -- Hey, this is an addon, too =D
    RegisterMySelf()

    AddonManager_Loaded = true

    -- Add mini buttons now
    for _, addon in pairs(AddonManager.Addons) do
        if AddonManager.HasMiniButton(addon) then
            AddonManager.Mini.AddIcon(addon)
        end
    end

    AddonManager.RecheckSettings()

    CheckDisabledState()

    AddonManager.SetMinimapButtons()
end

function AddonManager.LOADING_END()
    WaitTimer.Delay(0.1, AddonManager.SetMinimapButtons)
end

local ori_OnClick_SetMinimapVisible = OnClick_SetMinimapVisible
function OnClick_SetMinimapVisible(this)
    ori_OnClick_SetMinimapVisible( this )
    AddonManager.SetMinimapButtons()
end

function AddonManager.UNIT_CLASS_CHANGED()
    CheckDisabledState()
end


SLASH_AddonManager1="/addonmanager"
SLASH_AddonManager2="/addons"
function SlashCmdList.AddonManager(cmd)
    ToggleUIFrame(AddonManagerFrame)
end


function AddonManager.SaveSettings(frame)
    Sol.config.SaveConfig("AddonManager")

    CheckDisabledState()
    table.sort(AddonManager.Addons, AddonManager.AddonSortFn)
    AddonManager.RecheckSettings()

    AddonManager.OnShow()
end

function AddonManager.RecheckSettings()
    AddonManager.Mini.Show(AddonManager_Settings.ShowMiniBar)

    Nyx.SetVisible(AddonManagerMinimapButton, AddonManager_Settings.ShowMinimapButton)
end

function AddonManager.MinimapButton_OnClick(this)
	ToggleUIFrame(AddonManagerFrame)
end

function AddonManager.ButtonTemplateLoad(this)
    _G[this:GetName().."EnabledCheckLabel"]:SetText(AddonManager.L.But_Enable)
    _G[this:GetName().."MiniCheckLabel"]:SetText(AddonManager.L.But_Show)
end

-- If addonA should come before addonB in the addons list, returns true; else false
function AddonManager.AddonSortFn(addonA, addonB)
    if AddonManager_Settings and not AddonManager_Settings.MovePassiveToBack then
        return addonA.name:lower() < addonB.name:lower()
    else
        local aIsActive = AddonManager.IsActive(addonA)
        local bIsActive = AddonManager.IsActive(addonB)

        if aIsActive and not bIsActive then
            -- addonA > addonB
            return true
        elseif not aIsActive and bIsActive then
            -- addonA < addonB
            return false
        else
            return addonA.name:lower() < addonB.name:lower()
        end
    end
end

function AddonManager.IsAddonDisabled(name)
    local key = GetKeyName()
    return AddonManager_DisabledAddons[key] and AddonManager_DisabledAddons[key][name]
end

function AddonManager.IsActive(addon)
    return addon.mini_onClickScript or addon.configFrame or addon.onClickScript
end
function AddonManager.HasMiniButton(addon)
    return (addon.miniButton or addon.mini_icon or addon.mini_onClickScript) and AddonManager.IsActive(addon)
end


function AddonManager.ShowTooltipOfAddon(btn,addon)

    GameTooltip:ClearAllAnchors()
	GameTooltip:SetOwner(btn, "ANCHOR_RIGHT", 10, 0)

    local name = addon.name
    if addon.version then
        name = name .. " |cffaaaaaa"..addon.version.."|r"
    end
	GameTooltip:SetText(name)
    GameTooltip:AddLine(AddonManager.L.CAT[addon.category], 0.5, 0.5, 0.5)
    if addon.description then
        GameTooltip:AddLine(addon.description,0,0.66,1)
    end
    if addon.slashCommands or addon.author then
        GameTooltip:AddLine(" ")
        if addon.slashCommands then
            GameTooltip:AddLine(AddonManager.L.TIP_CMD.."|cff00ff00"..addon.slashCommands.."|r",0,0.66,1)
        end
        if addon.author then
            GameTooltip:AddLine(AddonManager.L.TIP_DEVS..addon.author, 0.5, 0.5, 0.5)
        end
        if addon.translators then
            GameTooltip:AddLine(AddonManager.L.TIP_TRANSLATOR..addon.translators, 0.5, 0.4, 0.5)
        end
    end
end

function AddonManager.ShowAddonInMini(addon_name)
    for i,name in ipairs(AddonManager_UncheckedAddons) do
        if name==addon_name then
            return false
        end
    end
    return true
end

function AddonManager.SetMinimapButtons()
    local to_remove={}
    for framename,newstate in pairs(AddonManager_MinimapButtons) do
        local frame = _G[framename]
        local framestate = frame and frame:IsVisible()
        if frame then
            Nyx.SetVisible(frame, newstate)
        else
            table.insert(to_remove,framename)
        end
    end

    for _,n in ipairs(to_remove) do
--        DEFAULT_CHAT_FRAME:AddMessage("AM: REMOVE: "..n)
        AddonManager_MinimapButtons[n]=nil
    end
end

------------------- Config Stuff -----------------
function AddonManager.OnShow()
    assert(current_tab)
    current_tab.OnShow()
end

function AddonManager.SelectTab(tab)
    SkillTab_SetActiveState(AddonManagerFrame.tab, false)
    SkillTab_SetActiveState(tab, true)
    AddonManagerFrame.tab = tab
    AddonManagerFrame.page = 1

    current_tab = AddonManager.tabs[ tab:GetID() ]
end

function AddonManager.OnTabClicked(tab)
    current_tab.OnHide()

    AddonManager.SelectTab(tab)

    current_tab.OnShow()
end

function AddonManager.UpdateButtons()
    local count = current_tab.GetCount()
    Nyx.SetVisible(AddonManagerFramePageAddonsPagingBar,  count > 1)

    for i = 1, DF_MAXPAGESKILL_SKILLBOOK do
        local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + i
        local basename = "AddonManagerAddonButton"..i

        if index <= count then
            current_tab.ShowButton(index, basename)
            _G[basename]:Show()
        else
            _G[basename]:Hide()
        end
    end
end

function AddonManager.SetButtons(basename, name, catname, icon, icontexture, minibutton, enablebutton, active)
    local categoryFrame = _G[basename.. "_AddonInfo_Category"]
    categoryFrame:SetText(catname)

    local iconFrame = _G[basename.. "ItemButton"]
    if icontexture then
        local iconFrameTexture = _G[basename.. "ItemButtonIcon"]
        iconFrameTexture:SetTexture(icontexture)
    else
        SetItemButtonTexture(iconFrame, icon)
    end

    local nameFrame = _G[basename.. "_AddonInfo_Name"]
    nameFrame:SetText(name)

    local miniButtonCheck = _G[basename.. "MiniCheck"]
    local enabledCheck = _G[basename.. "EnabledCheck"]
    enabledCheck:ClearAllAnchors()

    if minibutton~=nil then
        miniButtonCheck:Show()
        miniButtonCheck:SetChecked(minibutton)
        enabledCheck:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", _G[basename], -35, 6)
    else
        miniButtonCheck:Hide()
        enabledCheck:SetAnchor("BOTTOMLEFT", "BOTTOMLEFT", _G[basename], -3, 6)
    end

    if active then
        iconFrame:Enable()
        nameFrame:SetColor(1,1,1)
    else
        iconFrame:Disable()
        nameFrame:SetColor(0.64,0.5,0.32)
    end

    if enablebutton~=nil then
        enabledCheck:Show()
        enabledCheck:SetChecked(enablebutton)
    else
        enabledCheck:Hide()
    end
end


function AddonManager.TurnPageBack(btn)
    AddonManagerFrame.page = AddonManagerFrame.page - 1
    if AddonManagerFrame.page == 1 then
        btn:Hide()
    end
    AddonManagerFramePageAddonsPagingBarRightPage:Show()
    AddonManager.UpdateButtons()
end

function AddonManager.TurnPageForward(btn)
    AddonManagerFrame.page = AddonManagerFrame.page + 1
    local maxpage = math.ceil(current_tab.GetCount() / DF_MAXPAGESKILL_SKILLBOOK)
    if AddonManagerFrame.page >= maxpage then
        AddonManagerFrame.page = maxpage
        btn:Hide()
    end
    AddonManagerFramePageAddonsPagingBarLeftPage:Show()
    AddonManager.UpdateButtons()
end

function AddonManager.OnAddonClicked(btn, id)
    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnAddonClicked(index)
end

function AddonManager.OnAddonEntered(btn, id)
    _G[btn:GetName() .. "Highlight"]:Show()

    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnAddonEntered(btn, index)
end

function AddonManager.OnAddonLeave(btn)
    _G[btn:GetName() .. "Highlight"]:Hide()
    GameTooltip:Hide()

    if AddonManager.onitemleave then
        AddonManager.onitemleave(btn)
        AddonManager.onitemleave = nil
    end
end

function AddonManager.OnAddonMiniChecked(checkBox, id)
    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnCheckMiniBtn(index, checkBox:IsChecked())
end

function AddonManager.OnAddonEnabledChecked(checkBox, id)
    local index = (AddonManagerFrame.page - 1) * DF_MAXPAGESKILL_SKILLBOOK + id
    current_tab.OnCheckEnableBtn(index, checkBox:IsChecked())
end
