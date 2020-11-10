local Sol = LibStub("Sol")

Streamline.ConfigStrings = {}

Streamline.DefaultSettings = {
    -- Mail
    OpenMail                = true,
    TakeMail                = true,
    DeleteMail              = true,
    
    -- Stores
    OpenStores              = true,
    Repair                  = true,
    DontCloseRecipeWindow   = true,
    
    -- Quests
    AcceptQuests            = true,
    DontAcceptDailies       = false,
    CompleteQuests          = false,
    ReDisplayQuestDialog    = false,
    DontResetQuestBook      = false,
    AddMinQuestListButton   = true,
    
    -- House
    ChangeClass             = true,
    LeaveHouseAfterChange   = false,
    CloseBank               = true,
    OpenBank                = true,
    OpenBankKey             = 2,
    EnterHouse              = true,
    EnterHouseKey           = 3,
    ChangeClassAtMaid       = false,
    ChangeClassAtMaidKey    = 4,
    
    -- Skills
    ShowMaxSkillButton      = true,
    ShowCorrectCraftDialog  = true,
    ShowCraftLevelInDialog  = true,
    HideHotkeys             = true,
    
    -- Pay items
    AcceptTeleport          = false,
    Accept15MinHorse        = false,
    Accept2HourHorse        = false,
    
    -- General
    StopMovingOnClick       = true,
    AddExtraMinimapZooms    = false,
    AllowMultipleOpenFrames = true,
    
    -- Bag
    ClickSendAttachment     = false,
    ClickSendAttachmentKey  = 3,
    SwitchBagsOnClick       = true,
    SwitchBagsOnClickKey    = 3,
    ContributeToGuild       = false,
    ContributeToGuildKey    = 3,
    AuctionOnClick          = false,
    AuctionOnClickKey       = 3,
    
    Language                = 1,
}

Streamline.MetaKeys = {
    "Any",
    "Control",
    "Alt",
    "Shift",
}

Streamline.Languages = {
    {code = "EN", name = "English"},
    {code = "DE", name = "German"},
    {code = "PL", name = "Polish"},
    {code = "IT", name = "Italiano"},
}

Streamline.Hooks = {
    [{fn="Show", frame="OpenMailFrame"}]  = {"TakeMail", "DeleteMail"},
    [{fn="SitOrStand"}]                   = {"StopMovingOnClick"},
    [{fn="ToggleUIFrame"}]                = {"AllowMultipleOpenFrames"},
    [{fn="SpeakFrame_SpeakOption"}]       = {"CloseBank"},
    [{fn="BagItemButton_OnClick"}]        = {"ClickSendAttachment", "SwitchBagsOnClick"},
}

-- Show the Streamline configuration window and set all the fields to their correct values,
-- based on Streamline_Settings
Streamline.LoadConfig = function()
    Sol.config.LoadConfig(Streamline.Strings.AddonName, StreamlineConfigFrameTabsFrameGeneralTab)
    
    Streamline.CheckDropdownVisible("ChangeClassAtMaid")
    Streamline.CheckDropdownVisible("EnterHouse")
    Streamline.CheckDropdownVisible("OpenBank")
end

-- Hide the Streamline config window, set all values of Streamline_Settings based on the
-- values of the fields in the config window, do whatever needs to be done to make sure
-- the settings take effect
Streamline.Save = function()
    Sol.config.SaveConfig(Streamline.Strings.AddonName)
    Streamline.SetLanguage(Streamline_Settings.Language)
    Streamline.RecheckSettings()
end

Streamline.LoadConfigStrings = function()
    for frameName, text in pairs(Streamline.ConfigStrings) do
        local frame = _G[frameName]
        if frame then
            frame:SetText(text)
        end
    end
end

Streamline.CreateDisabledSettings = function()
    local retVal = Sol.table.DeepCopy(Streamline.DefaultSettings)
    for k, v in pairs(retVal) do
        if type(v) == "boolean" then 
            retVal[k] = false
        end
    end
    return retVal
end

Streamline.CheckDropdownVisible = function(settingName)
    local chkBox = _G["StreamlineConfig_Toggle" .. settingName]
    local dd = _G["StreamlineConfig_Dropdown" .. settingName .. "Key"]
    
    if not dd or not chkBox then return end
    
    Sol.util.SetVisible(dd, chkBox:IsChecked())
end

Streamline.DisabledSettings = Streamline.CreateDisabledSettings()