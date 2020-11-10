--[[
Streamline by Alleris

Streamlines the RoM UI by removing unnecessary clicks and generally tries to make things easier on you.

Use /sl, /streamline, or the AddonManager addon to access the config screen.

Currently supported options
---------------------------
Mail:
* Open mailbox automatically when talking to a mailbox
* Take mail item on click and deletes the mail if there's no body text
Stores:
* Open store automatically when talking to a store NPC
* Automatically repair when you open a store
* Don't close recipe window after purchasing one
Quests:
* Accept a quest automatically (when it's clicked on, if the NPC has more than one)
  Enabled by default as the quest dialog will be in your quest list anyway.
  * Option to not auto-accept billboard quests
* Complete a quest automatically (when it's clicked on, if the NPC has more than one). 
  Disabled by default as you can miss bits of story because of it.
* Show the NPC quest dialog upon acception/completion of a quest.
Skills:
* Add a "Max" button to the skill upgrade dialog (looks like '>>')
* One-click class swapping 
* When you click on one of your crafting skills, that skill will show up even if you had 
  another crafting skill open. The is different from the default, which only closes the
  one you have open.
Messages:
* Remove all orange (mainly system) messages from all windows but the combat log
* Remove the XP and TP messages from all windows but the combat log
* Remove skill levelup messages from all windows but the combat log
* Remove LFP, LFG, LFM messages from the general chat window
* Remove WTB, WTS, WTT messages from the general chat window
Banners:
* Hide the message scroller (text still shows up in the chat frame)
* Hide the red warning message when a skill is unusable and optionally redirect output to the combat log
* Hide the bug message popups and redirect output to general chat 
* Hide the scroll banner and redirect output to general chat
* Hide the zone changed banner and redirect output to general chat
Paid Items:
* Auto-accept teleport from the teleport NPCs (uses money!)
* Auto-accept 15min horse rental (uses money!)
Other:
* Stop auto-move when you start talking to an NPC or gathering
* Hide your skill hotkeys on the action bars (especially usefull when your hotkeys use
  Shift, Control, or Alt, as all you see is "SHIF...")
* Adds a button to the quest book that lets you minimize and restore the list of quests 
* Show craft skill level in the crafting frame

Released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/

Thanks for code samples to:
- Anahel of HudBars2
- vEEcEE of ClassSwap
- novayuna of pbInfo

--]]

local Sol = LibStub("Sol")

local STREAMLINE_MINIMAP_ZOOMS = { 1, 1.25, 1.5, 1.75, 2, 2.5, 3, 3.5, 4, 4.5, 5 }
local DEFAULT_MINIMAP_ZOOMS = { 2, 2.5, 3, 3.5, 4 }

Streamline = {}

Streamline.Strings = {}
Streamline.Strings.AddonName = "Streamline"
Streamline.Strings.IconPath = "Interface/Addons/Streamline/Textures/streamlineIcon.tga"
Streamline.Strings.Author = "Alleris"
Streamline.Strings.Version = "v1.51"

-- Init --
Streamline.OnLoad = function(frame)
    frame:RegisterEvent("VARIABLES_LOADED")
    
    frame:RegisterEvent("CASTING_START")
    frame:RegisterEvent("CHAT_MSG_SYSTEM")
    frame:RegisterEvent("EXCHANGECLASS_SHOW")
    frame:RegisterEvent("HOUSES_MAID_SPEAK")
    frame:RegisterEvent("MAIL_INBOX_UPDATE")
    frame:RegisterEvent("PLAYER_LIFESKILL_CHANGED")
    frame:RegisterEvent("SHOW_QUESTDETAIL_FROM_BOOK")
    frame:RegisterEvent("SHOW_QUESTDETAIL_FROM_NPC")
    frame:RegisterEvent("SHOW_QUESTLIST")
    frame:RegisterEvent("SHOW_REQUEST_DIALOG")
    frame:RegisterEvent("STORE_OPEN")
    frame:RegisterEvent("USE_CRAFTFRAME_SKILL")
end

Streamline.OnEvent = function(frame, _event, _arg1)
    -- Check for events firing before Streamline_Settings has loaded
    if not Streamline_Settings and _event ~= "VARIABLES_LOADED" then
        return
    end
    if Streamline[_event] then
        Streamline[_event](_arg1)
    end
end

-- Setup config screen, and make settings take effect
Streamline.VARIABLES_LOADED = function()
    if Streamline_SavedSettings then
        Streamline_Settings = Streamline_SavedSettings
    end
    Sol.config.CheckSettings("Streamline", Streamline.DefaultSettings, nil, true)
    
    Streamline.SetLanguage(Streamline_Settings.Language)
    Streamline.LoadConfigStrings()
    Sol.config.CreateSlashToHandleConfig(Streamline.Strings.AddonName, StreamlineConfigFrame, "sl")
    
    Sol.config.SetupDropdown(StreamlineConfig_DropdownLanguage, Streamline.Languages, Streamline_Settings.Language)
    Sol.config.SetupDropdown(StreamlineConfig_DropdownOpenBankKey, Streamline.MetaKeys, Streamline_Settings.OpenBankKey)
    Sol.config.SetupDropdown(StreamlineConfig_DropdownEnterHouseKey, Streamline.MetaKeys, Streamline_Settings.EnterHouseKey)
    Sol.config.SetupDropdown(StreamlineConfig_DropdownChangeClassAtMaidKey, Streamline.MetaKeys, Streamline_Settings.ChangeClassAtMaidKey)
        
    Streamline.RegisterWithAddonManager()
    
    StreamlineMinimizeQuestListButton:SetText("<")
    
    Streamline.RecheckSettings()
end

Streamline.RegisterWithAddonManager = function()
    if AddonManager then
        local addon = {
            name = Streamline.Strings.AddonName, 
            description = Streamline.Strings.AddonDesc, 
            icon = Streamline.Strings.IconPath, 
            category = "Interface",
            configFrame = StreamlineConfigFrame, 
            slashCommands = "/sl", 
            miniButton = StreamlineMiniButton,
            version = Streamline.Strings.Version,
            author = Streamline.Strings.Author,
            disableScript = Streamline.Disable,
            enableScript = Streamline.Enable
        }
        if AddonManager.RegisterAddonTable then
            AddonManager.RegisterAddonTable(addon)
        else
            AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category, 
                addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript)
        end
    else
        Sol.io.Print("Streamline loaded: /sl")
    end
end

Streamline.SetLanguage = function(langIndex)
    Sol.util.LoadFile("Streamline/Locale/Streamline.loc." .. Streamline.Languages[langIndex].code .. ".lua")
end

Streamline.Disable = function()
    Streamline_SavedSettings = Streamline_Settings
    SaveVariables("Streamline_SavedSettings")
    Streamline.RecheckSettings()
end

Streamline.Enable = function()
    Streamline_Settings = Streamline_SavedSettings
    Streamline_SavedSettings = nil
    Streamline.RecheckSettings()
end

-- Do whatever is needed to make all Streamline settings take effect
Streamline.RecheckSettings = function()
    Streamline.SetLanguage(Streamline_Settings.Language)
    Streamline.LoadConfigStrings()
    
    if Streamline_Settings.ShowMaxSkillButton then
        Streamline.ShowSkill()
    else
        Streamline.HideSkill()
    end
    
    Sol.util.SetVisible(StreamlineMinimizeQuestListButton, Streamline_Settings.AddMinQuestListButton)
    Sol.util.SetVisible(StreamlineCraftSkillLabel, Streamline_Settings.ShowCraftLevelInDialog)
    
    Streamline.CheckHooks()
    Streamline.SetHotkeysVisible(not Streamline_Settings.HideHotkeys)
    
    if Streamline_Settings.AddExtraMinimapZooms then
        g_minimapZooms = STREAMLINE_MINIMAP_ZOOMS
    else
        g_minimapZooms = DEFAULT_MINIMAP_ZOOMS
    end
end

-- Hook any functions that need to be hooked, based on Streamline settings
Streamline.CheckHooks = function() 
    for hook, hookDependencies in pairs(Streamline.Hooks) do
        local found = false
        for i, dependency in ipairs(hookDependencies) do
           if Streamline_Settings[dependency] then
                local origFn = hook.fn
                local newFn = Sol.util.TernaryOp(hook.frame, 
                    Streamline[tostring(hook.frame) .. "_" .. hook.fn], 
                    Streamline[hook.fn])
                local frame = hook.frame and _G[hook.frame]
                
                -- harmless if already hooked
                Sol.hooks.Hook(Streamline.Strings.AddonName, origFn, newFn, frame)
                
                found = true
                break
            end
        end
        if not found then
            Sol.hooks.UnHook(Streamline.Strings.AddonName, hook.fn, hook.frame)
        end
    end
end
-- End Init --





-- [[ General ]] --

-- Allows opening of more than 2 windows at a time
Streamline.ToggleUIFrame = function(frame)
    if ( not frame ) then
		return
	end
    if frame:IsVisible() then
        frame:Hide()
    else
        frame:Show()
    end
end

Streamline.SitOrStand = function()
    if Streamline_Settings.StopMovingOnClick then
        MoveForwardStop()
    end
    Sol.hooks.GetOriginalFn(Streamline.Strings.AddonName, "SitOrStand")()
end

-- The only time you're moving when this event's fired is when you begin gathering
Streamline.CASTING_START = function()
    if Streamline_Settings.StopMovingOnClick then
        MoveForwardStop()
    end
end

-- [[ End General ]] --




-- [[ Quests ]] --

-- Targeted NPC Name is needed for the "Accept quests except bulletin board" option
-- Sometimes bulletin boards aren't selected so we can't use UnitName("target")
Streamline.NPCName = nil
-- Event is fired when talking to an NPC, except when the NPC has only a single available quest 
Streamline.SHOW_QUESTLIST = function(npcName)
    Streamline.NPCName = npcName
    
    if Streamline_Settings.StopMovingOnClick then
        MoveForwardStop()
    end
    
    -- Speak options are the list of options you're presented when talking to an NPC
    -- We don't want to chose an option if the NPC has any quests, though
    if GetNumSpeakOption() > 0 and GetNumQuest(1) == 0 and GetNumQuest(2) == 0 and GetNumQuest(3) == 0 then
        if (Streamline_Settings.OpenStores and GetSpeakOption(1) == Streamline.Strings.StoreText) or
            (Streamline_Settings.OpenMail and GetSpeakOption(1) == Streamline.Strings.MailText) or
            (GetSpeakOption(1) == Streamline.Strings.GuildDefenceText) or 
            (GetSpeakOption(1) == Streamline.Strings.GuildAttackText) or 
            (GetSpeakOption(1) == Streamline.Strings.GuildLuckText) or 
            (GetSpeakOption(1) == Streamline.Strings.GuildTPText) or 
            (GetSpeakOption(1) == Streamline.Strings.GuildXPText) or 
            (GetSpeakOption(1) == Streamline.Strings.GuildHPText) then
            -- Second parameter is which option you want to pick. First doesn't matter.
            SpeakFrame_SpeakOption(1, 1)
        elseif GetSpeakOption(1) == Streamline.Strings.GuildRideText then
            SpeakFrame_SpeakOption(1, GetNumSpeakOption())
        elseif Streamline_Settings.EnterHouse 
            and GetSpeakOption(1) == Streamline.Strings.EnterHouseText 
            and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.EnterHouseKey]) then
            -- Enter house
            SpeakFrame_SpeakOption(1, 1)
        
        elseif Streamline_Settings.OpenBank 
            and not BankFrame:IsVisible() 
            and GetSpeakOption(4) == Streamline.Strings.BankText 
            and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.OpenBankKey]) then
            -- Open bank box
            SpeakFrame_SpeakOption(1, 4)
        end
    end
end

Streamline.HOUSES_MAID_SPEAK = function()
    if Streamline_Settings.ChangeClassAtMaid 
        and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.ChangeClassAtMaidKey]) then
        -- Change class
        SpeakFrame_ListDialogOption(1, 5)
        
    elseif Streamline_Settings.EnterHouse 
        and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.EnterHouseKey]) then
        -- Enter house
        SpeakFrame_ListDialogOption(1, 6)

    elseif Streamline_Settings.OpenBank 
        and not BankFrame:IsVisible() 
        and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.OpenBankKey]) then
        -- Open bank box
        SpeakFrame_ListDialogOption(1, 4)
    end
end

-- Event's fired when a specific quest is displayed at an NPC
Streamline.SHOW_QUESTDETAIL_FROM_NPC = function(npcName)
    if Streamline_Settings.StopMovingOnClick then
        MoveForwardStop()
    end
    
    if npcName and type(npcName) == "string" then
        Streamline.NPCName = npcName
    end
    if Streamline_Settings.CompleteQuests then
        CompleteQuest()
    end
    
    if Streamline_Settings.AcceptQuests and 
        (not Streamline_Settings.DontAcceptDailies or 
            (Streamline.NPCName and type(npcName) == "string" and 
                not Streamline.NPCName:find(Streamline.Strings.BulletinBoard))) then
        AcceptQuest()
    end
end

local isLikelyQuestbookFullResetEvent = false
local questBookSelectedIndex = 1
local questBookPrevSelectedIndex = 1
Streamline.SHOW_QUESTDETAIL_FROM_BOOK = function(index)
    if not Streamline_Settings.DontResetQuestBook or not UI_QuestBook:IsVisible() then
        return
    end
    
    -- When a new items goes in the bag, this event is triggered for each
    -- quest in the quest book. So if we see all quests in a row triggered,
    -- we know this is the cause. On the last one, switch back to whatever
    -- was selected before they triggered.
    if index == 1 then
        questBookPrevSelectedIndex = questBookSelectedIndex
        isLikelyQuestbookFullResetEvent = true
    elseif isLikelyQuestbookFullResetEvent and index == GetNumQuestBookButton_QuestBook() then
        if isLikelyQuestbookFullResetEvent then
            isLikelyQuestbookFullResetEvent = false
            ViewQuest_QuestBook(questBookPrevSelectedIndex)
        end
    else
        if index ~= questBookSelectedIndex + 1 then
            isLikelyQuestbookFullResetEvent = false
        end
    end
    questBookSelectedIndex = index
end

Streamline.ToggleQuestList = function()
    if UI_QuestBook_QuestList:IsVisible() then
        UI_QuestBook_QuestList:Hide()
        UI_QuestBookQuestNPCTrackButton:Hide()
        UI_QuestBook:SetWidth(500)
        StreamlineMinimizeQuestListButton:SetText(">")
    else
        UI_QuestBook_QuestList:Show()
        UI_QuestBookQuestNPCTrackButton:Show()
        UI_QuestBook:SetWidth(780)
        StreamlineMinimizeQuestListButton:SetText("<")
    end
end

-- [[ End Quests ]] --




-- [[ Stores ]] --

Streamline.STORE_OPEN = function()
    if Streamline_Settings.Repair then
        ClickRepairAllButton()
    end
end

-- [[ End Stores ]] --




-- [[ House ]] --

Streamline.SpeakFrame_SpeakOption = function(unknown, index)
    BankFrame:Hide()
    MailFrame:Hide()
    Sol.hooks.GetOriginalFn(Streamline.Strings.AddonName, "SpeakFrame_SpeakOption")(unknown, index)
end

-- One-click class swap. Event is fired when Class change window is shown.
Streamline.EXCHANGECLASS_SHOW = function()
    if Streamline_Settings.ChangeClass then
        -- Taken from ClassSwap. Hey, if it works... This requires on less click, though.
        -- Thanks go to vEEcEE 
        ExchangeClass(EXCHANGECLASS_SUBCLASS, EXCHANGECLASS_MAINCLASS)
        
        if Streamline_Settings.LeaveHouseAfterChange then
            SpeakFrame_Show()
            SpeakFrame_LoadListDialog()
            for i = 1, GetNumSpeakOption() do
                local name, id = GetSpeakOption(i)
                if name == Streamline.Strings.LeaveHouse then
                    SpeakFrame_ListDialogOption(id, i)
                end
            end
        end
    end
end

-- [[ End House ]] --




-- [[ Mail ]] --

-- Called when a bag item is clicked on
Streamline.BagItemButton_OnClick = function(frame, button, ignoreShift)
    -- Add item to mail and send it if a name's entered
    if Streamline_Settings.ClickSendAttachment 
        and MailFrame:IsVisible() 
        and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.ClickSendAttachmentKey])
    then
        PickupBagItem(frame.index)
        ClickSendMailItemButton()
        if SendMailNameEditBox:GetText() and SendMailNameEditBox:GetText() ~= "" then
            SendMailFrame_SendMail()
        end
        
        return
    end
    
    -- Send item as guild contribution
    if Streamline_Settings.ContributeToGuild 
        and GuildFrame:IsVisible() 
        and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.ContributeToGuildKey])
    then
        PickupBagItem(frame.index)
        GCB_GetContributionItem(1)
        GCB_OnOK()
        
        return
    end
    
    -- Sell items on AH
    if Streamline_Settings.AuctionOnClick
        and (AuctionFrame:IsVisible() or (AA_AuctionFrame and AA_AuctionFrame:IsVisible()))
        and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.AuctionOnClickKey])
    then
        PickupBagItem(frame.index)
        
        ClickAuctionItemButton()
        local callback = function() AuctionSellCreateButton_OnClick() end
        Sol.timers.ScheduleTimer(Streamline.Strings.AddonName, 0.5, callback)
            
        return
    end
    
    -- Move item to the other free bag
    if Streamline_Settings.SwitchBagsOnClick 
        and Sol.util.IsMetaKeyDown(Streamline.MetaKeys[Streamline_Settings.SwitchBagsOnClickKey])
    then
        local bagIndex = Sol.util.TernaryOp(frame.index <= 90, 1, 0)
        local slot = Sol.data.items.FindEmptyBagSlot(bagIndex)
        if slot then
            PickupBagItem(frame.index)
            PickupBagItem(slot)
        end
        
        return
    end
        
    Sol.hooks.GetOriginalFn(Streamline.Strings.AddonName, "BagItemButton_OnClick")(frame, button, ignoreShift)
end

-- Event's fired when you read a message or get new mail
Streamline.MAIL_INBOX_UPDATE = function()
    -- To make sure we don't delete mail other than the one we just took
    -- an item from, check how long it's been since you took an item
    local MAIL_UPDATE_TIME = 2
    if Streamline.itemTakenAt and Streamline_Settings.DeleteMail and 
            os.difftime(os.time(), Streamline.itemTakenAt) <= MAIL_UPDATE_TIME then
        OpenMail_Delete()
    end
end

-- When you take an item from a msg in your mailbox or open the mbox
Streamline.OpenMailFrame_Show = function(...)
    local _, _, _, COD, _, moneyAmt, _, _, items = GetInboxHeaderInfo(InboxFrame.openMailIndex)

    Sol.hooks.GetOriginalFn(Streamline.Strings.AddonName, "Show", OpenMailFrame)(...)
    
    Streamline.itemTakenAt = nil
    
    if not COD and ((items and items > 0) or (moneyAmt and moneyAmt > 0)) then
        if Streamline_Settings.TakeMail then
            TakeInboxItem(InboxFrame.openMailIndex)
        end
        
        if GetInboxText(InboxFrame.openMailIndex) == "" then
            Streamline.itemTakenAt = os.time()
        end
    end
end

-- [[ End Mail ]] --




-- [[ Pay items ]] --

-- Event's fired pretty much anytime orange text appears in the chat frame
Streamline.CHAT_MSG_SYSTEM = function(msg)
    if not msg or not Streamline.Strings or not Streamline.Strings.AcceptedQuest then
        return
    end
    
    local accepted = Sol.string.StartsWith(msg, Streamline.Strings.AcceptedQuest)
    local completed = Sol.string.StartsWith(msg, Streamline.Strings.CompletedQuest)
    local learnedRecipe = string.match(msg, Streamline.Strings.LearnedRecipe)
    
    if completed then 
        SpeakFrame_CompleteQuest() 
    end
    if accepted then
        SpeakFrame_AcceptQuest() 
    end
        
    -- Reopens the recipe purchase window. The recipes don't get updated until
    -- the user clicks on the npc again, so we use other ways to show which 
    -- recipe was bought. 
    -- TODO: Hook FSF_Update, I guess, to do this better; also, refactor
    if learnedRecipe and Streamline_Settings.DontCloseRecipeWindow then
        FSF_OnEvent(FormulaStoreFrame, "FSF_OPEN")
        for i = 1, MAX_FORMULA_ITEM do	
            local item = _G["FSF_List_Item" .. i]
            local nameWidget = _G["FSF_List_Item" .. i .."Name"]
            local name = nameWidget:GetText()
            
            if name == learnedRecipe then
                nameWidget:SetText(Streamline.Strings.Purchased)
            end
        end
    end
    
    -- We can show the NPC window after accepting a quest,
    if Streamline_Settings.ReDisplayQuestDialog and accepted and
            (GetNumQuest(1) + GetNumQuest(3) > 1) then  -- Only redisplay if a quest is left*
        SpeakFrame_Show()
        SpeakFrame_Clear()
        SpeakFrame_LoadQuest()
        
        -- Remove any quests that are in the quest log now (if we only removed the one
        -- that we just got, then on next click it would be back)
        for i = #g_SpeakFrameData.option, 1, -1 do
            local opt = g_SpeakFrameData.option[i]
            for q = 1, GetNumQuestBookButton_QuestBook() do
                local _, _, questName = GetQuestInfo(q)
                -- Some names will have " (Complete)" attached
                local completeIndex = questName:find(Streamline.Strings.Complete)
                if completeIndex then 
                    questName = questName:sub(1, completeIndex - 3)  -- take into account " ("
                end
                if opt.title == questName then
                    table.remove(g_SpeakFrameData.option, i)
                    break
                end
            end
        end
        
        SpeakOption_UpdateItems()
        
    end
end

Streamline.SHOW_REQUEST_DIALOG = function(msg)
    if (Streamline_Settings.AcceptTeleport and msg:find(Streamline.Strings.Teleport)) or
        (Streamline_Settings.Accept15MinHorse and msg:find(Streamline.Strings.Horse15Min)) or
        (Streamline_Settings.Accept2HourHorse and msg:find(Streamline.Strings.Horse2Hour)) then
        if StaticPopup1:IsVisible() then
            StaticPopup_EnterPressed(StaticPopup1)
            StaticPopup1:Hide()
        end
    end
end

-- [[ Pay items ]] --




-- [[ Skills ]] --

-- Set visibilty of all 80 action bar hotkeys
Streamline.SetHotkeysVisible = function(visible)
    local actionBarFrames = {
        "MainActionBarFrame",
        "BottomActionBarFrame",
        "RightActionBarFrame",
        "LeftActionBarFrame",
    }
    for _, barName in ipairs(actionBarFrames) do
        for i = 1, 20 do
            local hotkeyName = barName .. "Button" .. i .. "Hotkey"
            Sol.util.SetVisible(_G[hotkeyName], visible)
        end
    end
end

Streamline.ShowSkill = function()
    defaultSkillupWidth = SkillLevelUpFrame:GetWidth()
    SkillLevelUpFrame:SetWidth(305)
    
    StreamlineMaxSkillFrame:Show()
end

Streamline.HideSkill = function()
    SkillLevelUpFrame:SetWidth(250)
    
    StreamlineMaxSkillFrame:Hide()
end

-- Event's fired when you use on of your craft skills to open the crafting window
Streamline.USE_CRAFTFRAME_SKILL = function(index)
    if Streamline_Settings.ShowCorrectCraftDialog and not UI_CraftFrame:IsVisible() then
        ToggleUIFrame(UI_CraftFrame)
    end
    if UI_CraftFrame:IsVisible() then
        Streamline.UpdateCraftSkillLabel()
    end
end

Streamline.PLAYER_LIFESKILL_CHANGED = function()
    if UI_CraftFrame:IsVisible() then
        Streamline.UpdateCraftSkillLabel()
    end
end

Streamline.UpdateCraftSkillLabel = function()
    local CraftTypeID, CraftTypeName = GetCraftItemType(UI_CraftFrame.SelectCraftType)
    local shortName = nil
    for _, group in ipairs(Crafting_Groups) do
        for _, craft in ipairs(group.Items) do
            if craft.Name == CraftTypeName then
                shortName = craft.ID
            end
        end
    end
    if shortName then
        local skillLevel = Sol.math.Round(GetPlayerCurrentSkillValue(shortName), 2)
        StreamlineCraftSkillLabel:SetText(skillLevel)
    end
end

-- [[ End Skills ]] --





Streamline_OnUpdate = function(frame, elapsedTime)
    -- Used for timing
end