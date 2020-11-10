-- 
-- Inventory Viewer by The Gooch.  All Rights Reserved.
-- 

-- modifiable variables
local g_IVStatus                = {};                           -- Never save this info anywhere, it's session specific
local g_CharTabOrder            = {};
local g_AccountsOnThisRealm     = {};                           -- Account info related to this Realm (not saved, recalculated during init)
local g_AccountName             = GetAccountName();             -- Should be safe to call this early in the load
local g_ViewAccountName         = g_AccountName;                -- Which Account is being viewed in the Inventory Viewer
local g_Realm                   = "";
local g_CurrentPlayerName       = "";
local g_MoveSrcCharId           = 0;
local g_PreviousVersion         = 0;
local g_IVSelectedCharTabName   = "";
local g_IVSelectedCharTabID     = 0;
local g_MoniesTooltipText       = {};

-- Can't rename this anymore as it's used in the SaveVariables.lua file
g_InventoryViewerTable                    = {};        -- Save backpack/bank/furniture info to file
g_InventoryViewerTable[g_AccountName]     = {};

-- const defines
local PLUGIN_NAME               = "Inventory Viewer"
local PLUGIN_VERSION            = 1.9;
local PLUGIN_CREDIT             = "The Gooch";
local PLUGIN_TITLE              = PLUGIN_NAME .. string.format(" v%.1f" , PLUGIN_VERSION); --.. " (by " ..PLUGIN_CREDIT .. ")";
local INTERNAL_SETTINGS_TABLE   = "InternalSettings";
local IV_MAX_CHARS_PER_REALM    = 9; -- 8 characters +1 temporary to handle deletion of RoM character and creation of new character before IV runs and notices the deletion


-- Function hooks
local IV_Orig_EquipItemButton_Update = EquipItemButton_Update;
local IV_Orig_CloseBank = CloseBank;
local IV_Orig_HideUIPanel = HideUIPanel;
local IV_Orig_CloseAllWindows = CloseAllWindows;
local IV_Orig_GoodsFrame_OnShow = GoodsFrame_OnShow; -- There isn't a GoodsFrame_OnHide(), hooking HideUIPanel() instead.
local IV_Orig_GameTooltipHyperLinkSetHyperLink = GameTooltipHyperLink["SetHyperLink"];
local IV_Orig_GameTooltipSetHyperLink = GameTooltip["SetHyperLink"];
local IV_Orig_GameTooltipSetBagItem = GameTooltip["SetBagItem"];
local IV_Orig_GameTooltipSetBankItem = GameTooltip["SetBankItem"];
local IV_Orig_GameTooltipSetAuctionBrowseItem = GameTooltip["SetAuctionBrowseItem"];
local IV_Orig_GameTooltipSetBootyItem = GameTooltip["SetBootyItem"];
local IV_Orig_GameTooltipSetHouseItem = GameTooltip["SetHouseItem"];
local IV_Orig_GameTooltipSetStoreItem = GameTooltip["SetStoreItem"];
local IV_Orig_GameTooltipSetCraftRequestItem = GameTooltip["SetCraftRequestItem"];
local IV_Orig_GameTooltipSetCraftItem = GameTooltip["SetCraftItem"];

function IV_RemoveFunctionHooks()

    --IV_Log( "IV_RemoveFunctionHooks" );

    EquipItemButton_Update = IV_Orig_EquipItemButton_Update;
    CloseBank = IV_Orig_CloseBank;
    HideUIPanel = IV_Orig_HideUIPanel;
    CloseAllWindows = IV_Orig_CloseAllWindows;
    GoodsFrame_OnShow = IV_Orig_GoodsFrame_OnShow; -- There isn't a GoodsFrame_OnHide(), hooking HideUIPanel() instead.
    GameTooltipHyperLink["SetHyperLink"] = IV_Orig_GameTooltipHyperLinkSetHyperLink;
    GameTooltip["SetHyperLink"] = IV_Orig_GameTooltipSetHyperLink;
    GameTooltip["SetBagItem"] = IV_Orig_GameTooltipSetBagItem;
    GameTooltip["SetBankItem"] = IV_Orig_GameTooltipSetBankItem;
    GameTooltip["SetAuctionBrowseItem"] = IV_Orig_GameTooltipSetAuctionBrowseItem;
    GameTooltip["SetBootyItem"] = IV_Orig_GameTooltipSetBootyItem;
    GameTooltip["SetHouseItem"] = IV_Orig_GameTooltipSetHouseItem;
    GameTooltip["SetStoreItem"] = IV_Orig_GameTooltipSetStoreItem;
	GameTooltip["SetCraftRequestItem"] = IV_Orig_GameTooltipSetCraftRequestItem;
	GameTooltip["SetCraftItem"] = IV_Orig_GameTooltipSetCraftItem;
end

-- Default
local ASK_DELETE_INVENTORY_VIEWER_DATA   = "Are you sure you want to delete all Inventory Viewer data for account:";
local IV_WARNING_TOO_MANY_CHARS          = "INVENTORY VIEWER WARNING: There are more than 8 characters. Please delete your old character from Inventory Viewer by right clicking its tab.";
local IV_CLICK_TO_SAVE_EQUIPPED_ITEMS    = "Click to save equipped items into Inventory Viewer (AddOn).\n\nNote: this will un-equip/re-equip your items.  If an item doesn't get re-equipped, you will need to find it in your Arcane Transmutor or Backpack and re-equip it yourself." -- Click to save equipped items into Inventory Viewer.
local IV_PROCESSING_EQUIPPED_ITEM        = "Processing equipped item: %d/20."                    -- Processing equipped item: %d/20.
local OPTIONTEXT_ENHANCED_TOOLTIPS       = "Enhanced Tooltips";                                  -- Enhanced Tooltips
local OPTIONTEXT_SHOW_MINIMAP_ICON       = "Show Minimap Icon";                                  -- Show Minimap icon
local OPTIONTEXT_ITEM_BORDER_COLOR       = "Enable Border Colors";                               -- Enable Border Colors
local OPTIONTEXT_ITEM_BORDER_COLOR_WHITE = "Show White border colors";                           -- Show White border colors
local APOSTRAPHE_S                       = "'s";                                                 -- Tooltip text
local IV_ACCOUNT_SHOP                    = ACCOUNT_SHOP;                                         -- Used in place of real ACCOUNT_SHOP because french version is too long

-- German
if ( GetLanguage() == "DE" ) then
    ASK_DELETE_INVENTORY_VIEWER_DATA     = "Sind sie sicher, dass sie alle Inventory Viewer Daten für folgendes Konto löschen möchten:";
    IV_WARNING_TOO_MANY_CHARS            = "INVENTORY VIEWER WARNUNG: Es sind mehr als 8 Charaktere vorhanden. Bitte löschen sie alte Charaktere mit einem Rechtsklick auf den entsprechenden Reiter.";
    IV_CLICK_TO_SAVE_EQUIPPED_ITEMS      = "Klicken um angezogene Gegenstände im Inventory Viewer (AddOn) einzulesen.\n\nHinweis: Es wird nacheinander jeder Ausrüstungsgegenstand aus- und wieder angezogen. Falls etwas nicht wieder angezogen wird, so ist es im Arkanen Umwandler oder dem Rucksack wiederzufinden." -- Click to save equipped items into Inventory Viewer.
    IV_PROCESSING_EQUIPPED_ITEM          = "Verarbeitung des ausgerüsteten Einzelteils: %d/20."  -- Processing equipped item: %d/20.
    OPTIONTEXT_ENHANCED_TOOLTIPS         = "Erweiterte Tooltips";                                -- Enhanced Tooltips
    OPTIONTEXT_SHOW_MINIMAP_ICON         = "Minikarten-Icon anzeigen";                           -- Show Minimap icon
    OPTIONTEXT_ITEM_BORDER_COLOR         = "Farbige Ränder";                                     -- Enable Border Colors
    OPTIONTEXT_ITEM_BORDER_COLOR_WHITE   = "Weiße Ränder anzeigen";                              -- Show White border colors
    APOSTRAPHE_S                         = "s";                                                  -- Tooltip text (no apostraphe for German client)

-- French (Translation by SnoopyCurse)
elseif ( GetLanguage() == "FR" ) then
    ASK_DELETE_INVENTORY_VIEWER_DATA     = "Êtes vous sure que vous voulez supprimer toutes les données d'inventory viewer pour le compte:";
    IV_WARNING_TOO_MANY_CHARS            = "AVERTISSEMENT INVENTORY VIEWER : Il y a plus de 8 personages. Veuillez effacer vos ancients personages dans Inventory Viewer, par un clic droit sur leurs onglets.";
    IV_CLICK_TO_SAVE_EQUIPPED_ITEMS      = "Cliquez sur pour enregistrer l'équipement actuel dans Inventory Viewer.\n\nNote: ceci un-equip/re-equip vos articles. Si un article ne reçoit pas ré-équipés, vous devrez le trouver dans votre Transmutor Arcane ou sac à dos et ré-équiper vous-même." -- Click to save equipped items into Inventory Viewer.
    IV_PROCESSING_EQUIPPED_ITEM          = "Enregistrement de l'article équipé : %d/20."        -- Processing equipped item: %d/20.
    OPTIONTEXT_ENHANCED_TOOLTIPS         = "Améliorer les info-bulles";                         -- Enhanced Tooltips
    OPTIONTEXT_SHOW_MINIMAP_ICON         = "Afficher l'icône Minimap";                          -- Show Minimap icon
    OPTIONTEXT_ITEM_BORDER_COLOR         = "Afficher les bordures en couleur";                  -- Enable Border Colors
    OPTIONTEXT_ITEM_BORDER_COLOR_WHITE   = "Montrez les couleurs de bordure blanches";          -- Show White border colors
    APOSTRAPHE_S                         = "s";                                                 -- Tooltip text (no apostraphe for French client)
    IV_ACCOUNT_SHOP                      = "Boutique"; -- Work around for the's Item shop's name being too long (Boutique d'objet), and not fitting in the Tab.

--Japanese
elseif ( GetLanguage() == "JP" ) then
    ASK_DELETE_INVENTORY_VIEWER_DATA     = "このアカウントのデータをすべて消去してもよろしいのですか:";
    IV_WARNING_TOO_MANY_CHARS            = "警告: キャラクタが8人以上います。タブを右クリックして古いキャラクタを削除してください。";
    IV_CLICK_TO_SAVE_EQUIPPED_ITEMS      = "装備中のアイテムをInventory Viewerに記録する\n\n注：記録のために一時的にアイテムを外して再装備します。エラーなどで再装備できなかった場合は、鞄やマジカルボックスの中を探して下さい。"                -- Click to save equipped items into Inventory Viewer.
    IV_PROCESSING_EQUIPPED_ITEM          = "装備中のアイテムの記録処理: %d/20個終了"                         -- Processing equipped item: %d/20.
    OPTIONTEXT_ENHANCED_TOOLTIPS         = "ツールチップ機能拡張";                                     -- Enhanced Tooltips
    OPTIONTEXT_SHOW_MINIMAP_ICON         = "ミニマップ枠にアイコンを表示する";                              -- Show Minimap icon
    OPTIONTEXT_ITEM_BORDER_COLOR         = "アイテム枠をレア度で着色する";                                -- Item border color
    OPTIONTEXT_ITEM_BORDER_COLOR_WHITE   = "白文字アイテムに白色枠を表示する";                            -- Show White border colors
    APOSTRAPHE_S                         = " の";                                                -- Tooltip text
    
-- Taiwan
elseif ( GetLanguage() == "TW" ) then
    ASK_DELETE_INVENTORY_VIEWER_DATA     = "你確定要刪除這個角色的所有存檔：";
    IV_WARNING_TOO_MANY_CHARS            = "警告：目前已有超過八個角色的存檔，請在標籤上點擊右鍵刪除舊角色的資料。";
    IV_CLICK_TO_SAVE_EQUIPPED_ITEMS      = "點擊可儲存裝備資訊到 Inventory Viewer。\n\n註：這會重新裝備你的物品，如果有一個裝備沒有裝回去的話，你必須去魔幻寶盒或背包裡尋找並裝回去。" -- Click to save equipped items into Inventory Viewer." 
    IV_PROCESSING_EQUIPPED_ITEM          = "裝備儲存進度：%d/20"                                     -- Processing equipped item: %d/20.
    OPTIONTEXT_ENHANCED_TOOLTIPS         = "在浮動提示上顯示數量";                                   -- Enhanced Tooltips
    OPTIONTEXT_SHOW_MINIMAP_ICON         = "顯示小地圖按鈕";                                       -- Show Minimap icon
    OPTIONTEXT_ITEM_BORDER_COLOR         = "顯示邊框顏色";                                         -- Enable Border Colors
    OPTIONTEXT_ITEM_BORDER_COLOR_WHITE   = "顯示白色邊框";                                         -- Show White border colors
    APOSTRAPHE_S                         = "的";                                                 -- Tooltip text 
end


function IV_RegisterForEvents( this )

    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("UNIT_PORTRAIT_UPDATE");         -- Used to initialize this AddOn (it gets hit a few times, and on one of them we'll be able to get the player name
    this:RegisterEvent("PLAYER_BAG_CHANGED");           -- item in bag was used, added, removed, moved (this seems to be called twice sometimes), 
    this:RegisterEvent("HOUSES_STORAGE_SHOW" );         -- 1 when opening furniture
    this:RegisterEvent("HOUSES_STORAGE_CHANGED" );      -- 1 when adding or removing item from furniture, 2 when moving an item between slots within the furniture
    this:RegisterEvent("BANK_OPEN");                    -- This is called when you open your bank window
    this:RegisterEvent("HOUSES_HANGER_SHOW");           -- This is called when you open your clothes rack
    this:RegisterEvent("HOUSES_HANGER_CHANGED");        -- This is called when you change items on your clothes rack
    this:RegisterEvent("PLAYER_MONEY");                 -- Gold, Diamonds, Rubies, Phirius tokens have changed
    this:RegisterEvent("PLAYER_BOXENERGY_CHANGED");     -- Transmutor Charge changed
    this:RegisterEvent("CHAT_MSG_SYSTEM_VALUE");        -- out of combat (GetPlayerCombatState() do detect when I'm in combat)
    this:RegisterEvent("ZONE_CHANGED");                 -- Character changed zones, currently used to nag user to delete IV characters if they have too many.
    this:RegisterEvent("PLAYER_LEVEL_UP");              -- Player gained a level, save Class/Level
    this:RegisterEvent("EXCHANGECLASS_SUCCESS");        -- Player swapped classes, save Class/Level
    this:RegisterEvent("SAVE_VARIABLES");               -- Remove our function hooks during logout or ReloadUI()
	this:RegisterEvent("HOUSES_SERVANT_INFO_SHOW");		-- User opened the House Servant UI and chose "check Housekeeper's Attributes" (which has a 2nd tab containing storage slots)
	this:RegisterEvent("HOUSES_SERVANT_ITEM_CHANGED");  -- User added/removed an item from a House Servant
end




function IV_Log(msg, r,g,b)
    if (DEFAULT_CHAT_FRAME) then
        DEFAULT_CHAT_FRAME:AddMessage( tostring(msg), r,g,b);
    end
end

function IV_LogSearchResults(tbl)

	if ( not tbl ) then
		IV_Log( "nil is not a table." );
		return;
	end
	
	if( type(tbl) == "table" ) then

		for k,v in pairs(tbl) do
		
			-- "In Herbie's Backpack" (this is a table)
			IV_Log( " " .. tostring(k) .. ":" );
			
			-- The value is also a table, which has a .count and .itemLink value
			if( type(v) == "table" ) then
			
				for k2,v2 in pairs(v) do
					IV_Log( "  " .. tostring(v2.itemLink) .. " x "..tostring(MoneyNormalization(v2.count)));
				end
			end
		end
    end
end

--
-- This function will strip all colors from the passed in text
--
function IV_StripColor( TextToStrip )

    local stripped = TextToStrip;

    while ( string.find( stripped, "|c" ) ~= nil ) do
        stripped = string.gsub( stripped, "|c%x%x%x%x%x%x%x%x", "" );
        stripped = string.gsub( stripped, "|r", "" );
    end

    return stripped;
end


function IV_IsInitialized()

    if ( g_IVStatus.Initialized == true ) then
        return true;
    end

    return false;
end


function IV_SetInitialized()

    g_IVStatus.Initialized = true;
    --IV_Log( "g_InventoryViewer initialized." );
end


function IV_HandleUpgrade()

    IV_Log( "Handling Inventory Viewer data upgrade from v" ..tostring(g_PreviousVersion).. " to v" ..tostring(PLUGIN_VERSION) );

    if ( g_PreviousVersion > PLUGIN_VERSION ) then

        IV_Log( "Inventory Viewer data on disk is newer than this version of Inventory Viewer.  This may cause unpredictable behavior.", 1,0,0 );

    -- Version 1.6 wiped everyones data, if user went from an olderthat-1.6 version right to this one, wipe their data
    elseif ( g_PreviousVersion < 1.6 ) then

        -- wipe out all old data as it is no longer compatible
        IV_Log( "Wiping out all old Inventory Viewer data as it is no longer compatible. (Sorry)", 1,0,0 );
        g_InventoryViewerTable = {};

        -- Return 1 to let the caller know we wiped out the database
        return 1;

    else -- other build?

    end

    -- The database was not wiped out
    return 0;
end


function IV_IsTabOrderNumTaken( orderNum )

    -- Cycle through known chars on this realm to see if they have this order number yet
    for CharName,junk in pairs(g_InventoryViewerTable[g_ViewAccountName][g_Realm]) do

        if ( CharName ) then

            if ( g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].DisplayOrder ) then

                if ( orderNum == g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].DisplayOrder ) then
                    -- This number is taken
                    return true;
                end
            end
        end
    end

    -- this number is available
    return false;
end


function IV_GetNumCharsOnAccountRealm( Account, Realm )

    local numFound = 0;

    if ( g_InventoryViewerTable[Account][Realm] ) then

        for CharName,junk in pairs( g_InventoryViewerTable[Account][Realm] ) do

            if ( CharName ) then
                numFound = numFound + 1;
                --IV_Log( "IV_GetNumCharsOnAccountRealm: " .. numFound .. ": " .. CharName );
            end
        end
    end

    --IV_Log( "There are " .. numFound .. " character(s) on " .. Account .. "/" .. Realm );

    return numFound;
end


function IV_GetAccountsOnThisRealm()

    -- this structure is reset each time this function is called (should only be once during init)
    g_AccountsOnThisRealm = {};
    g_AccountsOnThisRealm.Count = 0;
    g_AccountsOnThisRealm.Selected = 0;

    local numCharactersFound = 0;
    local numAccountsFound = 0;

    for Account,junk in pairs( g_InventoryViewerTable ) do

        if ( Account ) then

            --IV_Log( "IV_GetAccountsOnThisRealm - " .. numAccountsFound .. ": " .. Account );

            -- Get the number of characters found for the Account (that are on this realm only)
            local found = IV_GetNumCharsOnAccountRealm( Account, g_Realm );

            numCharactersFound = numCharactersFound + found;

            -- If there were any characters found on the Account/Realm then add this AccountName to the g_AccountsOnThisRealm list
            if ( found > 0 ) then
                g_AccountsOnThisRealm[numAccountsFound] = Account;

                -- If the Account is the same as the currently logged in Account, set the Selected value to this index
                if ( Account == g_AccountName ) then
                    g_AccountsOnThisRealm.Selected = numAccountsFound;
                end

                -- Increment index of accounts found
                numAccountsFound = numAccountsFound + 1;
            end
        end
    end

    g_AccountsOnThisRealm.Count = numAccountsFound;

    --IV_Log( "There are " .. numAccountsFound .. " total account(s) with " .. numCharactersFound .. " total character(s) on this realm." );
end


function IV_SetCharTabNames()

    local MyTabId = 0;                    -- Default to invalid tab (0) so caller will know there are no tabs under this account (in case user deleted last character tab)
    local NextAvailDisplayOrderNum = 1;    -- This number will be handed out to any Chars that don't have a DisplayOrder number (then incremented)

    -- Figure out which characters have saved info and set our tabs as their names
    for CharName,CharTable in pairs( g_InventoryViewerTable[g_ViewAccountName][g_Realm] ) do

        if ( CharName ) then

            -- Default to the NextAvailDisplayOrderNum (will be overridden if this character has it's own DisplayOrder)
            local DisplayOrder = NextAvailDisplayOrderNum;

            -- If this character already has a DisplayOrder number, use it instead
            if ( CharTable.DisplayOrder ) then
                DisplayOrder = CharTable.DisplayOrder;
                --IV_Log( CharName.. " order already set to: " ..DisplayOrder );
            else
                -- Give this character a DisplayOrder number since he doesn't have one yet (this will happen if new character or upgrading from older AddOn)
                -- Make sure this character gets a DisplayOrder that isn't already taken
                while ( IV_IsTabOrderNumTaken( NextAvailDisplayOrderNum ) ) do
                    --IV_Log( NextAvailDisplayOrderNum .." is taken." );
                    NextAvailDisplayOrderNum = NextAvailDisplayOrderNum + 1;

                    -- protect against looping forever in case of bad data file
                    if ( NextAvailDisplayOrderNum > 8 ) then
                        IV_Log( IV_WARNING_TOO_MANY_CHARS, 1,0,0 );
                        StaticPopupDialogs["IV_WARNING_TOO_MANY_CHARS"].text = IV_WARNING_TOO_MANY_CHARS;
                        StaticPopup_Show("IV_WARNING_TOO_MANY_CHARS");
                        g_IVStatus.bTooManyCharacters = true;
                    end
                end

                --IV_Log( "NextAvailDisplayOrderNum found: " .. NextAvailDisplayOrderNum );

                -- if we got this far, we have a new DisplayOrder number
                DisplayOrder = NextAvailDisplayOrderNum;

                CharTable.DisplayOrder = DisplayOrder;

                --IV_Log( "Setting " ..CharName.. " order to: " ..DisplayOrder );
            end

            local tab = getglobal("IVFrameCharTab"..DisplayOrder );

            -- Set the Tab name and make sure it isn't hidden
            if ( tab ) then
                tab:SetText(CharName);
                tab:Show();    -- Our tabs are hidden by default, so we'll only show the ones that have names

                -- If this Character is the currently logged in Character, return this tab id to the caller (so it can be selected by default if the caller wishes)
                if ( g_ViewAccountName == g_AccountName and CharName == g_CurrentPlayerName ) then

                    MyTabId = DisplayOrder;
                end

                g_CharTabOrder[DisplayOrder] = CharName;
            end
        end
    end

    return MyTabId;
end


function IV_SelectAccount( bPrevious )

    --IV_Log( "IV_SelectAccount started" );

    -- If there are less than 2 accounts with characters on this realm, there's no account to switch to.  Bail out
    if ( g_AccountsOnThisRealm.Count < 2 ) then
        --IV_Log( "g_AccountsOnThisRealm < 2, bailing." );
        return;
    end

    -- Wipe out all the tabs so we can repopulate with characters from the previous/next realm
    for i=1, IV_MAX_CHARS_PER_REALM do
        local tab = getglobal("IVFrameCharTab"..i);
        tab:SetText("");
        tab:Hide();
    end

    --IV_Log( "g_AccountsOnThisRealm.Selected == " .. g_AccountsOnThisRealm.Selected );
    --IV_Log( "g_AccountsOnThisRealm.Count == " .. g_AccountsOnThisRealm.Count );
    --IV_Log( "g_AccountsOnThisRealm[g_AccountsOnThisRealm.Count-1] == " .. g_AccountsOnThisRealm[g_AccountsOnThisRealm.Count-1] );
    --IV_Log( "g_AccountsOnThisRealm[0] == " .. g_AccountsOnThisRealm[0] );

    -- If the caller wants to switch to the Previous Account, do so
    if ( bPrevious == true ) then

        --IV_Log( "IV_SelectAccount previous" );

        -- If the currently selected index is 0, wrap around to Count-1 (which points to the last Account Name in the array)
        if ( g_AccountsOnThisRealm.Selected == 0 ) then
            g_AccountsOnThisRealm.Selected = g_AccountsOnThisRealm.Count-1;
        else
            -- decrement the index of to point to the previous account
            g_AccountsOnThisRealm.Selected = g_AccountsOnThisRealm.Selected-1;
        end

    else -- caller wants to switch to the Next account

        --IV_Log( "IV_SelectAccount next" );

        -- If the currently selected index is Count-1, wrap around to 0 (which points to the first Account Name in the array)
        if ( g_AccountsOnThisRealm.Selected == g_AccountsOnThisRealm.Count-1 ) then
            g_AccountsOnThisRealm.Selected = 0;
        else
            -- increment the index to point to the next account
            g_AccountsOnThisRealm.Selected = g_AccountsOnThisRealm.Selected+1;
        end
    end

    --IV_Log( "Previously Selected AccountName: " .. g_ViewAccountName );

    -- Set the ViewAccount name
    g_ViewAccountName = g_AccountsOnThisRealm[g_AccountsOnThisRealm.Selected];

    --IV_Log( "Newly Selected AccountName: " .. g_ViewAccountName );

    -- Display the Account Name we are switching to
    IVFrame_AccountLeftArrow:SetText(g_ViewAccountName);

    -- Figure out which characters have saved info for the account we're viewing and set our tabs as their names
    local MyTabId = IV_SetCharTabNames();

    -- Default to first tab
    if ( MyTabId == 0 ) then
        MyTabId = 1;
    end

    -- Select the Tab of the current player (or 1st tab if current player is not found due to it being a different realm)
    -- This will update the UI with the inventory of the selected characters tab
    IVFrame_SelectCharTab( MyTabId );

    --IV_Log( "IV_SelectAccount finished" );
end


function IVFrame_AccountLeftArrow_OnClick(this)

    -- Select previous account
    IV_SelectAccount( true );
end


function IVFrame_AccountRightArrow_OnClick(this)

    -- Select next account
    IV_SelectAccount( false );
end


-- Toggle showing the Options panel
function IV_ToggleOptionsPanel()

    if ( IVConfigFrame:IsVisible() ) then
        IVConfigFrame:Hide();
    else
        IVConfigFrame:Show();
        IVFrame:SetFrameLevel(0);
        IVConfigFrame:SetFrameLevel(1);
    end
end


function IV_ToggleTooltips()

    -- Default to disabled unless we find out otherwise
    local bEnable = false;

    -- Checkbox was clicked, was it checked or unchecked?
    if ( IVConfig_ToolTips:IsChecked() ) then

        -- Enable enhanced Tooltips
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].UpdateTooltips = 1;
    else
        -- Disable enhanced Tooltips
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].UpdateTooltips = 0;
    end
end


function IV_ToggleMinimapIcon()

    -- Checkbox was clicked, was it checked or unchecked?
    if ( IVConfig_MiniMapCheck:IsChecked() ) then

        -- Enable Minimap icon
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].EnableMinimapIcon = 1;
        IV_MinimapButton:Show();
    else
        -- Disable Minimap icon
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].EnableMinimapIcon = 0;
        IV_MinimapButton:Hide();
    end
end


function IV_ToggleIconBorders()

    -- Checkbox was clicked, was it checked or unchecked?
    if ( IVConfig_ItemColor:IsChecked() ) then

        -- Enable Colored Icon Borders
        --IV_Log( "Inventory Viewer will show colored icon borders from now on.", 0,.70,0 );
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBorders = 1;

        -- Enable child options
        IVConfig_ItemColorWhite:Enable();
    else
        -- Disable Colored Icon Borders
        --IV_Log( "Inventory Viewer will no longer show colored icon borders.", .70,0,0 );
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBorders = 0;

        -- Disable child options
        IVConfig_ItemColorWhite:Disable();
    end

    -- Refresh the UI with new setting
    IV_PopulateBankInventory( g_IVSelectedCharTabName );
    IV_PopulateBackpackOrItemShopInventory( g_IVSelectedCharTabName );
    IV_PopulateFurnitureOrEquippedInventory( g_IVSelectedCharTabName );
    IV_PopulateArcaneTransmutorInventory( g_IVSelectedCharTabName );
end


function IV_ToggleIconBordersWhite()

    -- Checkbox was clicked, was it checked or unchecked?
    if ( IVConfig_ItemColorWhite:IsChecked() ) then

        -- Enable Colored Icon Borders
        --IV_Log( "Inventory Viewer will show colored white icon borders from now on.", 0,.70,0 );
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBordersWhite = 1;
    else
        -- Disable Colored Icon Borders
        --IV_Log( "Inventory Viewer will no longer show white icon borders.", .70,0,0 );
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBordersWhite = 0;
    end

    -- Refresh the UI with new setting
    IV_PopulateBankInventory( g_IVSelectedCharTabName );
    IV_PopulateBackpackOrItemShopInventory( g_IVSelectedCharTabName );
    IV_PopulateFurnitureOrEquippedInventory( g_IVSelectedCharTabName );    
    IV_PopulateArcaneTransmutorInventory( g_IVSelectedCharTabName );
end


function IV_Initialize( bAfterWipeAccount )
    --IV_Log("InventoryViewer initializing...");

    -- Bail if we're already initialized
    if ( IV_IsInitialized() == true ) then
        return;
    end

    -- Verify we have the right Account Name
    if ( g_AccountName ~= GetAccountName() ) then
        IV_Log( "Inventory Viewer Error: g_AccountName ~= GetAccountName()" .. g_AccountName .."~=".. GetAccountName(), 1,0,0 );
        g_AccountName = GetAccountName();
    end

    -- Set the Realm name once
    g_Realm = IV_StripColor( GetCurrentRealm() );

    if ( g_Realm == nil or g_Realm == "" ) then
        return;
    end

    -- Try to get the current player name.  If the player name is not available this AddOn is not considered initialized
    g_CurrentPlayerName = UnitName("player");

    if ( g_CurrentPlayerName == nil or g_CurrentPlayerName == "" ) then
        return;
    end

    -- Initialize the global data object if it isn't already
    if ( not g_InventoryViewerTable[g_AccountName] ) then
        g_InventoryViewerTable[g_AccountName] = {};
    end

    -- Create Account Money table if it doesn't exist yet (Holds Diamonds and Rubies)
    if ( not g_InventoryViewerTable[g_AccountName].Money ) then 
        g_InventoryViewerTable[g_AccountName].Money = {}; 
        g_InventoryViewerTable[g_AccountName]["Money"].Diamonds = 0;
        g_InventoryViewerTable[g_AccountName]["Money"].Rubies = 0;
    end

    -- Create Internal settings table if it doesn't exist yet
    if ( not g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE] ) then
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE] = {};
    end

    -- Check for previous versions of IV data and upgrade it if necessary
    if ( g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].Version ) then

        g_PreviousVersion = tonumber(g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].Version) or 0;

        --Handle upgrade of data if necessary
        if ( g_PreviousVersion ~= PLUGIN_VERSION ) then

            -- This may wipe out all g_InventoryViewerTable data
            local bWipedDatabase = IV_HandleUpgrade();

            -- If the database was wiped, bail out now so the Initialize can start fresh the next time it's called
            if ( bWipedDatabase == 1 ) then
                -- Call Initialize again (recursive!!)
                return IV_Initialize();
            end
        end
    end        

    -- Set the new version number
    g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].Version = PLUGIN_VERSION;

    -- Update Tooltips with IV info by default.  Use the Settings panel to toggle it off/on
    if ( not g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].UpdateTooltips ) then
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].UpdateTooltips = 1;
        IVConfig_ToolTips:SetChecked(true);
    elseif ( g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].UpdateTooltips == 1) then
        IVConfig_ToolTips:SetChecked(true);
    else
        IVConfig_ToolTips:SetChecked(false);
    end

    -- Enable the minimap icon by default.  Use the Settings panel to toggle it off/on
    if ( not g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].EnableMinimapIcon ) then
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].EnableMinimapIcon = 1;
        IVConfig_MiniMapCheck:SetChecked(true);
        IV_MinimapButton:Show();
    elseif ( g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].EnableMinimapIcon == 1) then
        IVConfig_MiniMapCheck:SetChecked(true);
        IV_MinimapButton:Show();
    else
        IVConfig_MiniMapCheck:SetChecked(false);
        IV_MinimapButton:Hide();
    end

    -- Show Icon Borders with IV info by default.  Use the settings panel to toggle it off/on
    if ( not g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBorders ) then
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBorders = 1;
    end

    if ( g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBorders == 1) then

        IVConfig_ItemColor:SetChecked(true);

        -- enable child options
        IVConfig_ItemColorWhite:Enable();
    else
        IVConfig_ItemColor:SetChecked(false);

        -- Disable child options
        IVConfig_ItemColorWhite:Disable();
    end

    -- Show White Icon Borders with IV info by default.  Use the settings panel to toggle it off/on
    if ( not g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBordersWhite ) then
        g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBordersWhite = 0;
        IVConfig_ItemColorWhite:SetChecked(false);
    elseif ( g_InventoryViewerTable[g_AccountName][INTERNAL_SETTINGS_TABLE].ShowIconBordersWhite == 1) then
        IVConfig_ItemColorWhite:SetChecked(true);
    else
        IVConfig_ItemColorWhite:SetChecked(false);
    end

    -- Initialize the basic structures if they don't exist yet
    if ( not g_InventoryViewerTable[g_AccountName][g_Realm] ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm] = {}; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName] ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName] = {}; 
    end

    -- Holds Gold and Arcane Transmutor Charges
    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Money ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Money = {}; 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["Money"].Gold = 0; 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["Money"].XMutor = 0; 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["Money"].Phirius = 0; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Bank ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Bank = {}; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Backpack ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Backpack = {}; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ItemShopBag ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ItemShopBag = {}; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped = {}; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[1] ) then
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[1] = {};
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[2] ) then
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[2] = {};
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Furniture ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Furniture = {}; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ArcaneTransmutor ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ArcaneTransmutor = {}; 
    end

    if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ClassInfo ) then 
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ClassInfo = {};
    end
    

    -- Set flag saying we're initialized so the following functions don't bail out
    IV_SetInitialized();

    -- Save off Bank items after we initialize for the first time.
    IVFrame_SetTable_Bank();

    -- Save off Backpack items after we initialize for the first time.
    IVFrame_SetTable_Backpack();

    -- Save off Item Shop Backpack items after we initialize for the first time.
    IVFrame_SetTable_ItemShopBag();

    -- Save off Arcane Transmutor items after we initialize for the first time.
    IVFrame_SetTable_ArcaneTransmutor();

    -- Save off Money info after we initialize for the first time.
    IVFrame_SetTable_Money();
    
    -- Save off this characters Classes and Levels
    IVFrame_SetTable_ClassAndLevel();

    -- Figure out which characters have saved info and set our tabs as their names
    local MyTabId = IV_SetCharTabNames();

    -- Default to first tab
    if ( MyTabId == 0 ) then 
        MyTabId = 1; 
    end

    -- Register database (table) to be saved in the SaveVariables.lua file
    SaveVariables("g_InventoryViewerTable");

    -- Build a list of Accounts that have characters on this Realm
    IV_GetAccountsOnThisRealm();

    -- Set the Tab to the current player and Populate the UI with that players inventory
    --  note: This cannot be called before IV_GetAccountsOnThisRealm() because this calls
    --            IV_PopulateMoney() which requires the g_AccountsOnThisRealm to be populated.
    IVFrame_SelectCharTab( MyTabId );

    -- Show which Account we are viewing in the UI (defaults to current Account)
    IVFrame_AccountLeftArrow:SetText(g_ViewAccountName);

    -- Set the first settings tab as default
    IVConfigFrameTitle:SetText(PLUGIN_NAME .. " " .. FOCUSFRAME_OPTION);
    IVConfigFrame_SelectConfigTab(1);

    -- If this is a normal Init ( not a special init after Account deletion)
    if ( not bAfterWipeAccount ) then

        -- Register with Alleris's AddOn Manager if available
        if ( AddonManager ) then

            local addon = {
                name = PLUGIN_NAME,
                description = "Keeps track of where your items are.",
                icon = "Interface/AddOns/InventoryViewer/Textures/IV_normal.tga",
                category = "Inventory",
                configFrame = IVFrame,
                slashCommands = SLASH_InventoryViewer2,
                miniButton = IV_AOMButton,
                version = string.format("v%.1f" , PLUGIN_VERSION),
                author = PLUGIN_CREDIT,
            }

            -- New AddOn Manager
            if AddonManager.RegisterAddonTable then

                --IV_Log( "Registering with new AddOn Manager" );
                AddonManager.RegisterAddonTable(addon)

            -- Old AddOn Manager
            else
                --IV_Log( "Registering with old AddOn Manager" );
                AddonManager.RegisterAddon( PLUGIN_TITLE, 
                                            addon.description, 
                                            addon.icon, 
                                            addon.category, 
                                            addon.configFrame, 
                                            addon.slashCommands, 
                                            addon.miniButton );
            end
        else
            IV_Log( PLUGIN_TITLE .. " loaded.  Usage: /iv" );
        end
    end
end


SLASH_InventoryViewer1 = "/inventoryviewer";
SLASH_InventoryViewer2 = "/iv";
SlashCmdList["InventoryViewer"] = function (editBox, msg)

    -- No command means show the UI
    if ( not msg or msg == "" ) then
        ShowUIPanel(IVFrame);
        return;
    end

    -- Get the Command
    local Command = string.gsub(msg, "%s*([^%s]+).*", "%1");
    --if ( Command ) then IV_Log( "Command: " .. Command ); end

    -- Show Options Panel
    if ( "OPTIONS" == string.upper(Command) ) then

        IV_ToggleOptionsPanel();
        return;
    end

    -- Wipe out the Inventory Viewer Database for this Account and start fresh 
    -- this will cause a ReloadUI()
    if ( "WIPEACCOUNT" == string.upper(Command) ) then

        local _, Param1 = string.match(msg, "(%w+) (%w+)")

        -- Make sure an AccountName was passed in
        if ( not Param1 ) then
            IV_Log( "Which account are you tring to wipe?\nUsage: /iv WipeAccount AccountName" );
            return; 
        end

        StaticPopupDialogs["DELETE_INVENTORY_VIEWER_DATA"].AccountName = Param1;
        StaticPopupDialogs["DELETE_INVENTORY_VIEWER_DATA"].text = ASK_DELETE_INVENTORY_VIEWER_DATA .. " " .. Param1;
        StaticPopup_Show("DELETE_INVENTORY_VIEWER_DATA");
        return;
    end

    -- Look up an itemlink or substring and show a detailed list of what was found and where we have it
	local tblDetailedList, total = IV_GetDetailedListOfItems2( msg );
	IV_Log( "Detailed search results for '" .. msg .. "' (" .. total .. " items found):" );
	IV_LogSearchResults( tblDetailedList );
end


function IVFrame_SetTable_ClassAndLevel()

    --IV_Log( "IVFrame_SetTable_ClassAndLevel" );

    if ( IV_IsInitialized() == false ) then
        IV_Log("Error: InventoryViewer not initialized yet.");
        return;
    end

    -- Get the current classes and levels according to RoM
    -- Note: the Secondary level will never show as higher than the Primary level in RoM, but IV will still show the real levels
    local curPrimaryClass, curSecondaryClass = UnitClass("player");
    local curPrimaryLevel, curSecondaryLevel = UnitLevel("player");
    local text = "";
    
    -- Get the level we have saved for this class
    local savedPriLevel = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["ClassInfo"][curPrimaryClass] or 0;

    -- If the current level is higher than the saved level, save the updated level
    if ( tonumber(curPrimaryLevel) > tonumber(savedPriLevel) ) then
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["ClassInfo"][curPrimaryClass] = tonumber(curPrimaryLevel);
        text = curPrimaryClass .. " " .. curPrimaryLevel;
    else
        text = curPrimaryClass .. " " .. savedPriLevel;
    end

    -- If this character has a secondary class
    if ( string.len(curSecondaryClass) > 0 ) then

        -- Get the level we have saved for the secondaryclass
        local savedSecLevel = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["ClassInfo"][curSecondaryClass] or 0;

        -- If the current level is higher than the saved level, save the updated level
        if ( tonumber(curSecondaryLevel) > tonumber(savedSecLevel) ) then
            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["ClassInfo"][curSecondaryClass] = tonumber(curSecondaryLevel);
            text = text .. " | " .. curSecondaryClass .. " " .. curSecondaryLevel;
        else
            text = text .. " | " .. curSecondaryClass .. " " .. savedSecLevel;
        end
    end
    
    -- Create the string that will show over this characters tab as a tooltip
    g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName]["ClassInfo"].Text = text;
    --IV_Log( text );
end


function IVFrame_SetTable_Money()

    --IV_Log( "IVFrame_SetTable_Money" );

    if ( IV_IsInitialized() == false ) then
        IV_Log("Error: InventoryViewer not initialized yet.");
        return;
    end

    -- Get the Gold and Transmutor charges for this character
    local tempObjCharacter      = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Money; -- reuse old table to reduce garbage
    tempObjCharacter.Gold       = GetPlayerMoney("copper");         -- Gold
    tempObjCharacter.Phirius    = IV_GetMyRealPhiriusTokenCount();  -- Phirius Tokens (in backpack, Bank, and house furniture)
    tempObjCharacter.XMutor     = GetMagicBoxEnergy();              -- Transmutor Charges

    -- Save Per-character data in the database
    g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Money = tempObjCharacter;

    -- Get the diamonds and Rubies for this account
    local tempObjAccount    = g_InventoryViewerTable[g_AccountName].Money; -- reuse old table to reduce garbage
    tempObjAccount.Diamonds = GetPlayerMoney("account");    -- Diamonds
    tempObjAccount.Rubies   = GetPlayerMoney("bonus");      -- Rubies;

    -- Save Per-account data in the database
    g_InventoryViewerTable[g_AccountName].Money = tempObjAccount;
end


function IsBankPages2345Disabled()

    if ( -1 == TimeLet_GetLetTime("BankBag" .. 2) and
         -1 == TimeLet_GetLetTime("BankBag" .. 3) and
         -1 == TimeLet_GetLetTime("BankBag" .. 4) and
         -1 == TimeLet_GetLetTime("BankBag" .. 5) ) then
         
         return true;
    end
    
    return false;
end


function IVFrame_SetTable_Bank()

    --IV_Log( "IVFrame_SetTable_Bank" );
    if ( IV_IsInitialized() == false ) then
        IV_Log("Error: InventoryViewer not initialized yet.");
        return;
    end
    
    local MaxUsableBankSlot = 200;
    
    -- See if bank pages 2,3,4,5 are disabled, if so, no point in scanning them
    if ( IsBankPages2345Disabled() == true ) then
         MaxUsableBankSlot = 40;
         --IV_Log( "Only scanning first page of bank." );
    end

    -- Loop through usable bank items (skip page 2,3,4,5 if user isn't renting them at the moment)
    local Bank = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Bank;
    for i = 1, MaxUsableBankSlot do

        local texture, name, itemCount, locked = GetBankItemInfo(i);

        if ( texture ) then

            -- we can only attempt to get an itemLink if it's not an empty slot

            local tempObj = Bank[i] or {}; -- reuse old table to reduce garbage
            tempObj.texture   = texture;
            tempObj.itemCount = itemCount;
            tempObj.itemLink  = GetBankItemLink(i);
            Bank[i] = tempObj;
        else
            Bank[i] = nil;
        end
    end
    --IV_Log("Stored Bank.");
end

function IsBackpackPages3456Disabled()

    local isLet3, letTime3 = GetBagPageLetTime(3);
    local isLet4, letTime4 = GetBagPageLetTime(4);
    local isLet5, letTime5 = GetBagPageLetTime(5);
    local isLet6, letTime6 = GetBagPageLetTime(6);
    
    if ( isLet3 == true and letTime3 == -1 and
         isLet4 == true and letTime4 == -1 and
         isLet5 == true and letTime5 == -1 and
         isLet6 == true and letTime6 == -1 ) then
         
         return true;
    end
    
    return false;
end

function IVFrame_SetTable_Backpack()

    --IV_Log( "IVFrame_SetTable_Backpack" );
    
    if ( IV_IsInitialized() == false ) then
        IV_Log("Error: InventoryViewer not initialized yet.");
        return;
    end

    local MaxUsableBagSlot = 180; -- default to all 6 pages of the backpack
    
    local EQ_set = GetEuipmentNumber();  -- when they fix the name of this function, we'll get a script error here.
    local Backpack = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Backpack;
    local Equipped = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped;
    
    -- Get the last equipped button ID that the function hook saved, just in case the user is equipping/unequipping an item from/to the backpack
    local equipped_index = 0;
    if ( g_IVStatus.LastEquippedItemUpdateButton ) then
        equipped_index = g_IVStatus.LastEquippedItemUpdateButton:GetID();
        --IV_Log( "g_IVStatus.LastEquippedItemUpdateButton:GetID() = " .. equipped_index );
    end
    local textureName = GetInventoryItemTexture("player", equipped_index);

    -- See if backpack pages 3,4,5,6 are disabled, if so, no point in scanning them
    if ( IsBackpackPages3456Disabled() == true ) then
         MaxUsableBagSlot = 60;
         --IV_Log( "Only scanning first 2 pages of backpack" );
    end
    
    -- Loop through usable backpack items (skip page 3,4,5,6 if user isn't renting them at the moment)
    for i = 1, MaxUsableBagSlot do

        local index, texture, name, itemCount, locked, invalid = GetBagItemInfo(i);

        -- If there is an item in this bag slot
        if ( texture and texture ~= "" ) then

            --IV_Log( "bag slot " .. i .. " is not empty." );
            
            -- Create a local temp object to work on, fill it with this backpack item data from the IV database if we have it
            local tempObj = Backpack[i] or {}; -- reuse old table to reduce garbage

            -- If the IV database has a texture for this slot and the texture is different than the item currently in this slot, save the previous item as the LastBackpackItemRemoved
            -- as there is a chance the previous backpack item was just equipped and what used to be equipped is now in the backpack (user right-clicked item in backpack to equip it when
            -- they had another item of this type (head piece, etc) already equipped)
            if ( tempObj and tempObj.texture and tempObj.texture ~= texture ) then
            
                --IV_Log( "Backpack slot " .. i .. " had item changed from:" .. tempObj.texture .. " to " .. texture );
                
                -- If our "EquipItemButton_Update()" function hook backed up an equipment button and the texture on that button is the same
                -- as what we have in this backpack slot in the IV database then we will assume this item was just equipped from the backpack.
                if ( g_IVStatus.LastEquippedItemUpdateButton and 
                     textureName and textureName == tempObj.texture ) then

                    --IV_Log( "Backpack slot " .. i .. " (swap)-> EQ slot " .. equipped_index .. " " .. tempObj.itemLink, 0,1,0 );

                    -- Save the newly equipped item in the IV database
                    if ( not Equipped[EQ_set][equipped_index] ) then
                        Equipped[EQ_set][equipped_index] = {};
                    end
                    Equipped[EQ_set][equipped_index].texture = tempObj.texture;
                    Equipped[EQ_set][equipped_index].itemCount = tempObj.itemCount;
                    Equipped[EQ_set][equipped_index].itemLink = tempObj.itemLink;
                end
            
            -- Same item in this slot as we have in the IV database
            elseif ( tempObj and tempObj.texture and tempObj.texture == texture ) then
            
                --IV_Log( "bag slot " .. i .. " texture didn't change." );

            -- No entry in the IV database for this backpack slot
            else -- tempObj == {}
            
                if ( g_IVStatus.LastEquippedItemUpdateButton ) then
                
                    --IV_Log( "bag slot " .. i .. " used to be empty but now it has a " .. texture );
                    
                     -- If the item is not equipped but our database thinks it is, then this item just got unequipped and put into a free bag slot
                    if ( not textureName and
                         Equipped[EQ_set] and 
                         Equipped[EQ_set][equipped_index] and 
                         Equipped[EQ_set][equipped_index].texture and
                         Equipped[EQ_set][equipped_index].texture == texture ) then

                        --IV_Log( "EQ slot " .. equipped_index .. " -> Backpack slot " .. i .. " " .. Equipped[EQ_set][equipped_index].itemLink, 0,1,0 );
                        Equipped[EQ_set][equipped_index] = nil;
                    else
                        -- it's possible we didnt' have this entry in our EQ database yet, in this case we still add it to the backpack, but no need to delete from EQ slot in database
                    end
                end
            end

            -- Save this backpack item (texture, count, itemLink) to the IV database if we don't have it already
            if ( tempObj.texture ~= texture ) then
                tempObj.texture   = texture;
            end
            if ( tempObj.itemCount ~= itemCount ) then
                tempObj.itemCount   = itemCount;
            end
            tempObj.itemLink = GetBagItemLink( index );
            Backpack[i] = tempObj;
            
        else -- This bag slot is empty

            --IV_Log( "bag slot " .. i .. " is empty." );
            
            -- There's no item in this slot, did we have a backpack item in database? If so, see if it moved to an equipped item slot
            if ( Backpack[i] ~= nil and Backpack[i].itemLink ~= nil and Backpack[i].texture ~= nil ) then
            
                --IV_Log( "Backpack slot " .. i .. " had item removed:" .. Backpack[i].itemLink );
                
                -- If our "EquipItemButton_Update()" function hook backed up an equipment button and the texture on that button is the same
                -- as what we have in this backpack slot in the IV database then we will assume this item was just equipped from the backpack.
                if ( g_IVStatus.LastEquippedItemUpdateButton and
                     textureName and textureName == Backpack[i].texture ) then

                    --IV_Log( "Backpack slot " .. i .. " -> EQ slot " .. equipped_index .. " " .. Backpack[i].itemLink, 0,1,0 );

                    -- Save the equipped item in the IV database
                    if ( not Equipped[EQ_set][equipped_index] ) then
                        Equipped[EQ_set][equipped_index] = {};
                    end
                    Equipped[EQ_set][equipped_index].texture = Backpack[i].texture;
                    Equipped[EQ_set][equipped_index].itemCount = Backpack[i].itemCount;
                    Equipped[EQ_set][equipped_index].itemLink = Backpack[i].itemLink;
                end
            end
            
            -- Wipe out data for this backpack slot as it is now empty
            if ( Backpack[i] ~= nil ) then
                Backpack[i] = nil;
            end
        end
    end
    --IV_Log("Stored Backpack.");
end


function IVFrame_SetTable_ItemShopBag()

    --IV_Log( "IVFrame_SetTable_ItemShopBag" );
    
    if ( IV_IsInitialized() == false ) then
        IV_Log("Error: InventoryViewer not initialized yet.");
        return;
    end

    local EQ_set = GetEuipmentNumber();  -- when they fix the name of this function, we'll get a script error here.
    local ItemShopBag = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ItemShopBag;
    local Equipped = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped;

    -- Get the last equipped button ID that the function hook saved, just in case the user is equipping/unequipping an item from/to the ItemShop bag.
    local equipped_index = 0;
    if ( g_IVStatus.LastEquippedItemUpdateButton ) then
        equipped_index = g_IVStatus.LastEquippedItemUpdateButton:GetID();
    end
    local textureName = GetInventoryItemTexture("player", equipped_index);

    -- Set  ItemShop Bag info (all 50 slots)
    for i = 1, 50 do

        local texture, name, itemCount, locked = GetGoodsItemInfo(i);

        -- If there is an item in this ItemShop bag slot
        if ( texture and texture ~= "" ) then

            --IV_Log( "ItemShop bag slot " .. i .. " is not empty." );
            
            -- Create a local temp object to work on, fill it with this ItemShop bag item data from the IV database if we have it
            local tempObj = ItemShopBag[i] or {}; -- reuse old table to reduce garbage

            -- If the IV database has a texture for this slot and the texture is different than the item currently in this slot, save the previous item as the LastBackpackItemRemoved
            -- as there is a chance the previous ItemShop bag item was just equipped and what used to be equipped is now in the ItemShop bag  (user right-clicked item in ItemShop bag to equip it when
            -- they had another item of this type (head piece, etc) already equipped)
            if ( tempObj and tempObj.texture and tempObj.texture ~= texture ) then

                --IV_Log( "ItemShop bag slot " .. i .. " had item changed from:" .. tempObj.texture .. " to " .. texture );
                
                -- If our "EquipItemButton_Update()" function hook backed up an equipment button and the texture on that button is the same
                -- as what we have in this backpack slot in the IV database then we will assume this item was just equipped from the backpack.
                if ( g_IVStatus.LastEquippedItemUpdateButton and 
                     textureName and textureName == tempObj.texture ) then

                    --IV_Log( "ItemShop bag slot " .. i .. " (swap)-> EQ slot " .. equipped_index .. " " .. tempObj.itemLink, 0,1,0 );

                    -- Save the newly equipped item in the IV database
                    if ( not Equipped[EQ_set][equipped_index] ) then
                        Equipped[EQ_set][equipped_index] = {};
                    end
                    Equipped[EQ_set][equipped_index].texture = tempObj.texture;
                    Equipped[EQ_set][equipped_index].itemCount = tempObj.itemCount;
                    Equipped[EQ_set][equipped_index].itemLink = tempObj.itemLink;
                end
            
            -- Same item in this slot as we have in the IV database
            elseif ( tempObj and tempObj.texture and tempObj.texture == texture ) then
            
                --IV_Log( "ItemShop bag slot " .. i .. " texture didn't change." );

            -- No entry in the IV database for this ItemShop bag slot
            else -- tempObj == {}
            
                if ( g_IVStatus.LastEquippedItemUpdateButton ) then
                
                    --IV_Log( "ItemShop bag slot " .. i .. " used to be empty but now it has a " .. texture );
                    
                    -- If the item is not equipped but our database thinks it is, then this item just got unequipped and put into a free ItemShop bag slot
                    if ( not textureName and
                         Equipped[EQ_set] and 
                         Equipped[EQ_set][equipped_index] and 
                         Equipped[EQ_set][equipped_index].texture and
                         Equipped[EQ_set][equipped_index].texture == texture ) then

                        --IV_Log( "EQ slot " .. equipped_index .. " -> ItemShop bag slot " .. i .. " " .. Equipped[EQ_set][equipped_index].itemLink, 0,1,0 );
                        Equipped[EQ_set][equipped_index] = nil;
                    else
                        -- it's possible we didnt' have this entry in our EQ database yet, in this case we still add it to the ItemShop Bag, but no need to delete from EQ slot in database
                    end
                end
            end

            -- Save this ItemShop bag item (texture, count, itemLink) to the IV database if we don't have it already
            if ( tempObj.texture ~= texture ) then
                tempObj.texture   = texture;
            end
            if ( tempObj.itemCount ~= itemCount ) then
                tempObj.itemCount   = itemCount;
            end
            tempObj.itemLink = GetBagItemLink(i);
            ItemShopBag[i] = tempObj;
            
        else -- This ItemShop bag slot is empty

            --IV_Log( "ItemShop bag slot " .. i .. " is empty." );
            
            -- There's no item in this slot, did we have a ItemShop bag item in database? If so, see if it moved to an equipped item slot
            if ( ItemShopBag[i] ~= nil and ItemShopBag[i].itemLink ~= nil and ItemShopBag[i].texture ~= nil ) then
            
                --IV_Log( "ItemShopBag slot " .. i .. " had item removed:" .. ItemShopBag[i].itemLink );
                
                -- If our "EquipItemButton_Update()" function hook backed up an equipment button and the texture on that button is the same
                -- as what we have in this ItemShop bag slot in the IV database then we will assume this item was just equipped from the ItemShop bag.
                if ( g_IVStatus.LastEquippedItemUpdateButton and
                     textureName and textureName == ItemShopBag[i].texture ) then

                    --IV_Log( "ItemShopBag slot " .. i .. " -> EQ slot " .. equipped_index .. " " .. ItemShopBag[i].itemLink, 0,1,0 );

                    -- Save the equipped item in the IV database
                    if ( not Equipped[EQ_set][equipped_index] ) then
                        Equipped[EQ_set][equipped_index] = {};
                    end
                    Equipped[EQ_set][equipped_index].texture = ItemShopBag[i].texture;
                    Equipped[EQ_set][equipped_index].itemCount = ItemShopBag[i].itemCount;
                    Equipped[EQ_set][equipped_index].itemLink = ItemShopBag[i].itemLink;
                end
            end
            
            -- Wipe out data for this ItemShop bag slot as it is now empty
            if ( ItemShopBag[i] ~= nil ) then
                ItemShopBag[i] = nil;
            end
        end
    end
    --IV_Log("Stored Item Shop Bag.");
end

function RomHouseMaidEquipmentTools_to_IV_index( RoM_index )

	-- Housekeeper's Equipment
    if ( RoM_index == 1 ) then return 1; end	-- head
    if ( RoM_index == 2 ) then return 5; end;	-- hands
	if ( RoM_index == 3 ) then return 4; end;	-- feet
	if ( RoM_index == 4 ) then return 2; end;	-- chest
	if ( RoM_index == 5 ) then return 3; end;	-- legs
	if ( RoM_index == 6 ) then return 8; end;	-- cloak
	if ( RoM_index == 7 ) then return 6; end;	-- belt
	if ( RoM_index == 8 ) then return 7; end;	-- shoulders
	if ( RoM_index == 22) then return 9; end;	-- wings
	
	-- Housekeeper's Tools
    if ( RoM_index == 31) then return 16; end	-- tools slot 1
    if ( RoM_index == 32) then return 17; end;	-- tools slot 2
	if ( RoM_index == 33) then return 18; end;	-- tools slot 3
	if ( RoM_index == 34) then return 19; end;	-- tools slot 4
	if ( RoM_index == 35) then return 20; end;	-- tools slot 5
	if ( RoM_index == 36) then return 21; end;	-- tools slot 6
	if ( RoM_index == 37) then return 22; end;	-- tools slot 7
	if ( RoM_index == 38) then return 23; end;	-- tools slot 8
	if ( RoM_index == 39) then return 24; end;	-- tools slot 9
	if ( RoM_index == 40) then return 25; end;	-- tools slot 10

	-- unhandled RoM_index
    return nil;
end


function IVFrame_SetTable_HouseFurniture( DBID, HouseItemName, nMaxItems, IsHanger, AccountName, PlayerName, IsHouseMaid )

    --IV_Log( "IVFrame_SetTable_HouseFurniture " .. DBID ..": " .. HouseItemName .. "(HouseMaid:" .. tostring(IsHouseMaid) .. ")" );
    if ( IV_IsInitialized() == false ) then
        IV_Log("Error: InventoryViewer not initialized yet.");
        return;
    end

    if ( not g_InventoryViewerTable[AccountName] ) then
        g_InventoryViewerTable[AccountName] = {};
    end
    if ( not g_InventoryViewerTable[AccountName][g_Realm] ) then
        g_InventoryViewerTable[AccountName][g_Realm] = {};
    end
    if ( not g_InventoryViewerTable[AccountName][g_Realm][PlayerName] ) then
        g_InventoryViewerTable[AccountName][g_Realm][PlayerName] = {};
    end
    if ( not g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture ) then
        g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture = {};
    end

    local Furniture = g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture;

    if ( not Furniture[DBID] ) then
        Furniture[DBID] = {};
    end

    -- Flag furniture that are hangers or House Maids so we know how to populate them so they match
	-- the original UI (or as close to it as we can)
    if ( IsHanger ) then
        Furniture[DBID].IsHanger = IsHanger;
	elseif ( IsHouseMaid ) then
        Furniture[DBID].IsHouseMaid = IsHouseMaid;
    end

    Furniture[DBID].Name = HouseItemName;
    Furniture[DBID].MaxSlots = nMaxItems;

    -- If a default display house furniture isn't set yet, set it to this one
	if ( not g_InventoryViewerTable[AccountName][g_Realm][PlayerName].SelectedFurnitureDBID ) then
		g_InventoryViewerTable[AccountName][g_Realm][PlayerName].SelectedFurnitureDBID = DBID;
		--IV_Log( "IVFrame_SetTable_HouseFurniture - Set default display House Furniture to DBID: " .. DBID .. " (" .. HouseItemName .. ")" );
	end

	if ( IsHouseMaid ) then
	
		-- Set House Maid Equipment/Tools
		for i = 1, 40 do

			local IV_index = RomHouseMaidEquipmentTools_to_IV_index(i);
			
			if ( IV_index ) then
			
				local texture, name, itemCount, locked = Houses_GetItemInfo( DBID, i );

				-- we can only attempt to get an itemLink if it's not an empty slot
				if ( texture ) then

					local tempObj = Furniture[DBID][IV_index] or {}; -- reuse old table to reduce garbage
					tempObj.texture   = texture;
					tempObj.itemCount = itemCount;
					tempObj.itemLink  = Houses_GetItemLink( DBID, i );
					Furniture[DBID][IV_index] = tempObj;
					
					--IV_Log("IVFrame_SetTable_HouseFurniture (HouseMaid Tools): i:" .. i .. "IV_index:" .. IV_index .. " DBID:" .. DBID .. " itemLink:" .. tempObj.itemLink );
				else
					--IV_Log( "Wiping out House Maid Tools DBID:" .. DBID .. "(" .. IV_index .. ")" );
					Furniture[DBID][IV_index] = nil;
				end
			end
		end
	else
		-- Set Furniture info (up to 20 slots)
		for i = 1, nMaxItems do

			local texture, name, itemCount, locked = Houses_GetItemInfo( DBID, i );

			-- we can only attempt to get an itemLink if it's not an empty slot
			if ( texture ) then

				local tempObj = Furniture[DBID][i] or {}; -- reuse old table to reduce garbage
				tempObj.texture   = texture;
				tempObj.itemCount = itemCount;
				tempObj.itemLink  = Houses_GetItemLink( DBID, i );
				Furniture[DBID][i] = tempObj;
				
				--IV_Log("IVFrame_SetTable_HouseFurniture: i:" .. i .. " DBID:" .. DBID .. " itemLink:" .. tempObj.itemLink );
			else
				Furniture[DBID][i] = nil;
			end
		end
	end
    --IV_Log("Stored House Furniture " .. DBID);
end


function IVFrame_SetTable_ArcaneTransmutor()

    --IV_Log( "IVFrame_SetTable_ArcaneTransmutor" );
    
    if ( IV_IsInitialized() == false ) then
        IV_Log("Error: InventoryViewer not initialized yet.");
        return;
    end

    -- Arcane Transmutor layout - GetGoodsItemInfo(idx) where i =
    --     52  53
    --       51
    --     54  55
    -- Hidden: 56, 57, 58, 59, 60 <- These will be destroyed if you do a transmute!
    
    local EQ_set = GetEuipmentNumber();  -- when they fix the name of this function, we'll get a script error here.
    local ArcaneTransmutor = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].ArcaneTransmutor;
    local Equipped = g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped;

    -- Get the last equipped button ID that the function hook saved, just in case the user is equipping/unequipping an item from/to the ItemShop bag.
    local equipped_index = 0;
    if ( g_IVStatus.LastEquippedItemUpdateButton ) then
        equipped_index = g_IVStatus.LastEquippedItemUpdateButton:GetID();
    end
    local textureName = GetInventoryItemTexture("player", equipped_index);

    -- Set  Arcane Transmutor info (all 10 slots, 5 shown, 5 hidden)
    for idx = 51, 60 do

        -- AT is slot 51-55 but IV stores it as 1-5 in database
        local i = idx - 50;
        local texture, name, itemCount, locked = GetGoodsItemInfo(idx);

        -- If there is an item in this AT slot
        if ( texture and texture ~= "" ) then

            --IV_Log( "AT slot " .. i .. " is not empty." );
            
            -- Create a local temp object to work on, fill it with this AT item data from the IV database if we have it
            local tempObj = ArcaneTransmutor[i] or {}; -- reuse old table to reduce garbage

            -- If the IV database has a texture for this slot and the texture is different than the item currently in this slot, save the previous item as the LastBackpackItemRemoved
            -- as there is a chance the previous AT item was just equipped and what used to be equipped is now in the AT  (user right-clicked item in AT to equip it when
            -- they had another item of this type (head piece, etc) already equipped)
            if ( tempObj and tempObj.texture and tempObj.texture ~= texture ) then
            
                --IV_Log( "AT slot " .. i .. " had item changed from:" .. tempObj.texture .. " to " .. texture );
                
                -- If our "EquipItemButton_Update()" function hook backed up an equipment button and the texture on that button is the same
                -- as what we have in this backpack slot in the IV database then we will assume this item was just equipped from the Arcane Transmutor.
                if ( g_IVStatus.LastEquippedItemUpdateButton and 
                     textureName and textureName == tempObj.texture ) then

                    --IV_Log( "AT slot " .. i .. " (swap)-> EQ slot " .. equipped_index .. " " .. tempObj.itemLink, 0,1,0 );

                    -- Save the newly equipped item in the IV database
                    if ( not Equipped[EQ_set][equipped_index] ) then
                        Equipped[EQ_set][equipped_index] = {};
                    end
                    Equipped[EQ_set][equipped_index].texture = tempObj.texture;
                    Equipped[EQ_set][equipped_index].itemCount = tempObj.itemCount;
                    Equipped[EQ_set][equipped_index].itemLink = tempObj.itemLink;
                end
            
            -- Same item in this slot as we have in the IV database
            elseif ( tempObj and tempObj.texture and tempObj.texture == texture ) then
            
                --IV_Log( "AT slot " .. i .. " texture didn't change." );

            -- No entry in the IV database for this AT slot
            else -- tempObj == {}
            
                if ( g_IVStatus.LastEquippedItemUpdateButton ) then
                
                    --IV_Log( "AT slot " .. i .. " used to be empty but now it has a " .. texture );
                    
                    -- If the item is not equipped but our database thinks it is, then this item just got unequipped and put into a free AT slot
                    if ( not textureName and
                         Equipped[EQ_set] and 
                         Equipped[EQ_set][equipped_index] and 
                         Equipped[EQ_set][equipped_index].texture and
                         Equipped[EQ_set][equipped_index].texture == texture ) then

                        --IV_Log( "EQ slot " .. equipped_index .. " -> AT slot " .. i .. " " .. Equipped[EQ_set][equipped_index].itemLink, 0,1,0 );
                        Equipped[EQ_set][equipped_index] = nil;
                    else
                        -- it's possible we didnt' have this entry in our EQ database yet, in this case we still add it to the AT, but no need to delete from EQ slot in database
                    end
                end
            end

            -- Save this AT item (texture, count, itemLink) to the IV database if we don't have it already
            if ( tempObj.texture ~= texture ) then
                tempObj.texture   = texture;
            end
            if ( tempObj.itemCount ~= itemCount ) then
                tempObj.itemCount   = itemCount;
            end
            tempObj.itemLink = GetBagItemLink(idx);
            ArcaneTransmutor[i] = tempObj;
            
        else -- This AT slot is empty

            --IV_Log( "AT slot " .. i .. " is empty." );
            
            -- There's no item in this slot, did we have an AT item in database? If so, see if it moved to an equipped item slot
            if ( ArcaneTransmutor[i] ~= nil and ArcaneTransmutor[i].itemLink ~= nil and ArcaneTransmutor[i].texture ~= nil ) then
            
                --IV_Log( "AT slot " .. i .. " had item removed:" .. ArcaneTransmutor[i].itemLink );
                
                -- If our "EquipItemButton_Update()" function hook backed up an equipment button and the texture on that button is the same
                -- as what we have in this AT slot in the IV database then we will assume this item was just equipped from the Arcane Transmutor.
                if ( g_IVStatus.LastEquippedItemUpdateButton and
                     textureName and textureName == ArcaneTransmutor[i].texture ) then

                    --IV_Log( "AT slot " .. i .. " -> EQ slot " .. equipped_index .. " " .. ArcaneTransmutor[i].itemLink, 0,1,0 );

                    -- Save the equipped item in the IV database
                    if ( not Equipped[EQ_set][equipped_index] ) then
                        Equipped[EQ_set][equipped_index] = {};
                    end
                    Equipped[EQ_set][equipped_index].texture = ArcaneTransmutor[i].texture;
                    Equipped[EQ_set][equipped_index].itemCount = ArcaneTransmutor[i].itemCount;
                    Equipped[EQ_set][equipped_index].itemLink = ArcaneTransmutor[i].itemLink;
                end
            end
            
            -- Wipe out data for this backpack slot as it is now empty
            if ( ArcaneTransmutor[i] ~= nil ) then
                ArcaneTransmutor[i] = nil;
            end
        end
    end

    --IV_Log("IVFrame_SetTable_ArcaneTransmutor - finished");
end


function IV_PopulateMoney()

    --IV_Log( "IV_PopulateMoney - start" );

    local CharacterGold     = 0;    -- Gold on specified character
    local CharacterCharges  = 0;    -- Transmuter Charges on specified character
    local CharacterPhirius  = 0;    -- Phirius Tokens on specified character

    local AccountGold       = 0;    -- Gold on all characters under the specified account on this realm
    local AccountCharges    = 0;    -- Transmuter Charges on all characters under the specified account on this realm
    local AccountPhirius    = 0;    -- Phirius Tokens on all characters under the specified account on this realm
    local AccountDiamonds   = 0;    -- Diamonds on specified account
    local AccountRubies     = 0;    -- Rubies on specified account

    local RealmGold         = 0;    -- Gold on all characters on all accounts on this realm
    local RealmCharges      = 0;    -- Transmuter Charges on all characters of all accounts on this realm
    local RealmPhirius      = 0;    -- Phirius tokens on all characters of all accounts on this realm
    local RealmDiamonds     = 0;    -- Diamonds on all accounts on this realm
    local RealmRubies       = 0;    -- Rubies on all accounts on this realm

    g_MoniesTooltipText     = {};

    -- Cycle through all accounts on this realm (that have IV data)
    for i=0, g_AccountsOnThisRealm.Count-1 do

        g_MoniesTooltipText[i] = {};

        -- Get next account
        local Account = g_AccountsOnThisRealm[i];

        g_MoniesTooltipText[i].Left = "|cff00ee00Account:|r " .. Account;
        g_MoniesTooltipText[i].Right = "|cff00ee00|r "; -- Add a Right just to keep proper spacing when displaying tooltip

        -- Get Diamonds on this iteration's account
        if ( g_InventoryViewerTable[Account]["Money"] and 
            g_InventoryViewerTable[Account]["Money"].Diamonds ) then

            if ( g_InventoryViewerTable[Account]["Money"].Diamonds > 0 ) then
                g_MoniesTooltipText[i].Left = (g_MoniesTooltipText[i].Left or "") .. "\n|cff00ffffdiamonds|r:";
                g_MoniesTooltipText[i].Right = (g_MoniesTooltipText[i].Right or "") .. "\n" .. MoneyNormalization(tonumber(g_InventoryViewerTable[Account]["Money"].Diamonds));
            end

            --IV_Log( "Acct:" .. Account .. " has diamonds: " .. g_InventoryViewerTable[Account]["Money"].Diamonds );

            -- If this iteration's Account is the currently selected Account in the UI, set this accounts total Diamond amount
            if ( Account == g_ViewAccountName ) then
                AccountDiamonds = g_InventoryViewerTable[Account]["Money"].Diamonds;
            end

            -- Update the amount of Diamonds on all accounts on this realm
            RealmDiamonds = RealmDiamonds + g_InventoryViewerTable[Account]["Money"].Diamonds;
        end

        -- Get Rubies on this account
        if ( g_InventoryViewerTable[Account]["Money"] and 
            g_InventoryViewerTable[Account]["Money"].Rubies ) then

            if ( g_InventoryViewerTable[Account]["Money"].Rubies > 0 ) then
                g_MoniesTooltipText[i].Left = (g_MoniesTooltipText[i].Left or "") .. "\n|cffee0000rubies|r:";
                g_MoniesTooltipText[i].Right = (g_MoniesTooltipText[i].Right or "") .. "\n" .. MoneyNormalization(tonumber(g_InventoryViewerTable[Account]["Money"].Rubies));
            end

            --IV_Log( "Acct:" .. Account .. " has rubies: " .. g_InventoryViewerTable[Account]["Money"].Rubies );

            -- If this iteration's Account is the currently selected Account in the UI, set this accounts total Ruby amount
            if ( Account == g_ViewAccountName ) then
                AccountRubies = g_InventoryViewerTable[Account]["Money"].Rubies;
            end

            -- Update the amount of Rubies on all accounts on this realm
            RealmRubies = RealmRubies + g_InventoryViewerTable[Account]["Money"].Rubies;
        end


        -- Cycle through known chars on this account on this realm
        for CharName,junk in pairs(g_InventoryViewerTable[Account][g_Realm]) do

            if ( CharName ) then

                if ( g_InventoryViewerTable[Account][g_Realm][CharName]["Money"] and 
                    g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Gold ) then

                    --IV_Log( "Acct:" .. Account .. " Realm:" .. g_Realm .. " Char:" .. CharName .. " has gold: " .. g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Gold );

                    -- If this iteration's Account/Character is the currently selected Account/Character in the UI, set his Gold amount
                    if ( Account == g_ViewAccountName and CharName == g_IVSelectedCharTabName ) then
                        CharacterGold = g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Gold;
                    end

                    -- If this iteration's Account is the currently selected Account in the UI, update this accounts total Gold amount
                    if ( Account == g_ViewAccountName ) then
                        AccountGold = AccountGold + g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Gold;
                    end

                    -- Update the amount of Gold on all characters on all accounts on this realm
                    RealmGold = RealmGold + g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Gold;

                    if ( g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Gold > 0 ) then
                        g_MoniesTooltipText[i].Left = (g_MoniesTooltipText[i].Left or "") .. "\n" .. CharName .. APOSTRAPHE_S .. " |cffffff34gold|r:";
                        g_MoniesTooltipText[i].Right = (g_MoniesTooltipText[i].Right or "") .. "\n" .. MoneyNormalization(tonumber(g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Gold));
                    end

                    --IV_Log( "Total Character gold: " .. CharacterGold );
                    --IV_Log( "Total Account gold: " .. AccountGold );
                    --IV_Log( "Total Realm gold: " .. RealmGold );
                end

                if ( g_InventoryViewerTable[Account][g_Realm][CharName]["Money"] and 
                    g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].XMutor ) then

                    --IV_Log( "Acct:" .. Account .. " Realm:" .. g_Realm .. " Char:" .. CharName .. " has AT Charges: " .. g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].XMutor );

                    -- If this iteration's Account/Character is the currently selected Account/Character in the UI, update his Arcane Transmutor Charges amount
                    if ( Account == g_ViewAccountName and CharName == g_IVSelectedCharTabName ) then
                        CharacterCharges = g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].XMutor;
                    end

                    -- Update the amount of Arcane Transmutor Charges on all characters on the selected Account/Realm
                    if ( Account == g_ViewAccountName ) then
                        AccountCharges = AccountCharges + g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].XMutor;
                    end

                    -- Update the amount of Arcane Transmutor Charges on all characters on all accounts on this realm
                    RealmCharges = RealmCharges + g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].XMutor;

                    if ( g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].XMutor > 0 ) then
                        g_MoniesTooltipText[i].Left = (g_MoniesTooltipText[i].Left or "") .. "\n" .. CharName .. APOSTRAPHE_S .. " |cffff952aAT charges|r:";
                        g_MoniesTooltipText[i].Right = (g_MoniesTooltipText[i].Right or "") .. "\n" .. MoneyNormalization(tonumber(g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].XMutor));
                    end

                    --IV_Log( "Total Character AT charges: " .. CharacterCharges );
                    --IV_Log( "Total Account AT charges: " .. AccountCharges );
                    --IV_Log( "Total Realm AT charges: " .. RealmCharges );
                end
                
                if ( g_InventoryViewerTable[Account][g_Realm][CharName]["Money"] and 
                    g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Phirius ) then

                    --IV_Log( "Acct:" .. Account .. " Realm:" .. g_Realm .. " Char:" .. CharName .. " has Phirius Tokens: " .. g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Phirius );

                    -- If this iteration's Account/Character is the currently selected Account/Character in the UI, update his Phirius Token amount
                    if ( Account == g_ViewAccountName and CharName == g_IVSelectedCharTabName ) then
                        CharacterPhirius = g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Phirius;
                    end

                    -- Update the amount of Phirius Tokens on all characters on the selected Account/Realm
                    if ( Account == g_ViewAccountName ) then
                        AccountPhirius = AccountPhirius + g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Phirius;
                    end

                    -- Update the amount of Phirius Tokens on all characters on all accounts on this realm
                    RealmPhirius = RealmPhirius + g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Phirius;

                    if ( g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Phirius > 0 ) then
                        g_MoniesTooltipText[i].Left = (g_MoniesTooltipText[i].Left or "") .. "\n" .. CharName .. APOSTRAPHE_S .. " |cffbebebePhirius tokens|r:";
                        g_MoniesTooltipText[i].Right = (g_MoniesTooltipText[i].Right or "") .. "\n" .. MoneyNormalization(tonumber(g_InventoryViewerTable[Account][g_Realm][CharName]["Money"].Phirius));
                    end

                    --IV_Log( "Total Character Phirius Tokens: " .. CharacterPhirius );
                    --IV_Log( "Total Account Phirius Tokens: " .. AccountPhirius );
                    --IV_Log( "Total Realm Phirius Tokens: " .. RealmPhirius );
                end
            end
        end

        g_MoniesTooltipText[i].Left = g_MoniesTooltipText[i].Left .. "\n";
        g_MoniesTooltipText[i].Right = g_MoniesTooltipText[i].Right .. "\n"; -- Add a Right just to keep proper spacing when displaying tooltip

    end


    -- Display all
    IV_CharGold:SetText( MoneyNormalization(CharacterGold) );
    IV_AccountGold:SetText( MoneyNormalization(AccountGold) );
    IV_ServerGold:SetText( MoneyNormalization(RealmGold) );
    IV_CharCharges:SetText( MoneyNormalization(CharacterCharges) .."/".. MoneyNormalization(AccountCharges) .. "/" .. MoneyNormalization(RealmCharges) );
    IV_CharPhirius:SetText( MoneyNormalization(CharacterPhirius) .."/".. MoneyNormalization(AccountPhirius) .. "/" .. MoneyNormalization(RealmPhirius) );
    IV_CharDiamonds:SetText( MoneyNormalization(AccountDiamonds) .. "/" .. MoneyNormalization(RealmDiamonds) );
    IV_CharRuby:SetText( MoneyNormalization(AccountRubies) .. "/" .. MoneyNormalization(RealmRubies) );

    --IV_Log( "IV_PopulateMoney - end" );
end


function IV_PopulateBankInventory( CharacterName )

    --IV_Log( "IV_PopulateBankInventory" );

    -- Initialize to first Tab if not initialized yet
    if ( not IVFrameBankBackdropFrame.PageIndex ) then
        IVFrameBankBackdropFrame.PageIndex = 1;
    end

    -- We only show 40 buttons for each Bank page
    for i = 1, 40 do

        local itemButton = getglobal("IVItemButton"..i);
        local itemButtonTexture = getglobal("IVItemButton"..i.."QualityBorder");
        itemButton.index = i;

        -- The Table supports all 200 slots, figure out which slot in the Bank table we're on
        local TableIndex = ( IVFrameBankBackdropFrame.PageIndex - 1 ) * 40 + i;

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Bank[TableIndex] and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Bank[TableIndex].texture and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Bank[TableIndex].itemCount) then

            -- Get the itemLink
            local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Bank[TableIndex].itemLink;

            IV_SetColorBorder( itemLink, itemButtonTexture );

            SetItemButtonTexture( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Bank[TableIndex].texture);
            SetItemButtonCount( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Bank[TableIndex].itemCount);
        else
            -- there is no item in this slot, make sure we clear out whatever we're showing
            SetItemButtonTexture( itemButton, nil );
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide(); -- Don't show quality color on empty slot
        end
    end

    --IV_Log( "end IV_PopulateBankInventory" );
end


function IV_PopulateBackpackOrItemShopInventory( PlayerName )

    -- Figure out if we're displaying ItemShop or Backpack items (based on selected tab)
    if ( 4 == IVFrameBackpackBackdropFrame.PageIndex ) then

        return IV_PopulateItemShopBackpackInventory( PlayerName );
    end

    return IV_PopulateBackpackInventory( PlayerName );
end


function IV_PopulateBackpackInventory( CharacterName )

    --IV_Log( "IV_PopulateBackpackInventory" );

    -- Initialize to first Tab if not initialized yet
    if ( not IVFrameBackpackBackdropFrame.PageIndex ) then
        IVFrameBackpackBackdropFrame.PageIndex = 1;
    end

    -- We only show 60 buttons for the Backpack
    for i = 41, 100 do

        local itemButton = getglobal("IVItemButton"..i);    
        local itemButtonTexture = getglobal("IVItemButton"..i.."QualityBorder");
        itemButton.index = i-40;

        if ( i >= 90 and i <= 100 ) then
            if ( not itemButton:IsVisible() ) then
                itemButton:Show(); -- show the button in case it was hidden during IV_PopulateItemShopBackpackInventory()
            end
        end

        -- The Table supports all 180 slots, figure out which slot in the Backpack table we're on
        local TableIndex = ( IVFrameBackpackBackdropFrame.PageIndex - 1 ) * 60 + (i-40);

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Backpack[TableIndex] and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Backpack[TableIndex].texture and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Backpack[TableIndex].itemCount) then

            -- Get the itemLink
            local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Backpack[TableIndex].itemLink;

            IV_SetColorBorder( itemLink, itemButtonTexture );

            SetItemButtonTexture( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Backpack[TableIndex].texture);
            SetItemButtonCount( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].Backpack[TableIndex].itemCount);
        else
            -- currently selected character may not have any items in this slot, make sure we clear out whatever we're showing
            SetItemButtonTexture( itemButton, nil );
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide(); -- Don't show quality color on empty slot
        end
    end    

    --IV_Log( "end IV_PopulateBackpackInventory" );
end


function IV_PopulateItemShopBackpackInventory( CharacterName )

    --IV_Log( "IV_PopulateItemShopBackpackInventory" );

    -- Initialize to 4th Tab if not initialized yet
    if ( not IVFrameBackpackBackdropFrame.PageIndex ) then
        IVFrameBackpackBackdropFrame.PageIndex = 4;
    end

    -- We only show 50 buttons for the ItemShop Backpack
    for i = 41, 90 do

        local itemButton = getglobal("IVItemButton"..i);    
        local itemButtonTexture = getglobal("IVItemButton"..i.."QualityBorder");
        itemButton.index = i-40;

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ItemShopBag[itemButton.index] and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ItemShopBag[itemButton.index].texture and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ItemShopBag[itemButton.index].itemCount) then

            -- Get the itemLink
            local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ItemShopBag[itemButton.index].itemLink;

            IV_SetColorBorder( itemLink, itemButtonTexture );

            SetItemButtonTexture( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ItemShopBag[itemButton.index].texture);
            SetItemButtonCount( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ItemShopBag[itemButton.index].itemCount);
        else
            -- currently selected character may not have any items in this slot, make sure we clear out whatever we're showing
            SetItemButtonTexture( itemButton, nil );
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide(); -- Don't show quality color on empty slot
        end
    end    

    -- Clear out the last 10 slots as we don't want to show previous Backpack data in the ItemShop backpack area
    for i = 91, 100 do
        local itemButton = getglobal("IVItemButton"..i);    
        local itemButtonTexture = getglobal("IVItemButton"..i.."QualityBorder");
        SetItemButtonTexture( itemButton, nil );
        SetItemButtonCount( itemButton, 0 );
        itemButton:Hide(); -- hide the button
        itemButtonTexture:Hide(); -- Don't show quality color on empty slot
    end
    --IV_Log( "end IV_PopulateItemShopBackpackInventory" );
end


function IV_PopulateFurnitureOrEquippedInventory( PlayerName )

    -- Figure out if we're displaying Furniture or Equipped items (based on selected tab)
    if ( 3 == IVFrameHouseFurnitureBackdropFrame.PageIndex ) then

        return IV_PopulateHouseFurnitureInventory( PlayerName );
    end

    return IV_PopulateEquippedInventory( PlayerName );
end


function IV_GetInventoryBackgroundTexture( index )

    local backgroundTextureName;

    if     ( index == 0 )  then _, backgroundTextureName = GetInventorySlotInfo("headslot");
    elseif ( index == 1 )  then _, backgroundTextureName = GetInventorySlotInfo("handsslot");
    elseif ( index == 2 )  then _, backgroundTextureName = GetInventorySlotInfo("feetslot");
    elseif ( index == 3 )  then _, backgroundTextureName = GetInventorySlotInfo("chestslot");
    elseif ( index == 4 )  then _, backgroundTextureName = GetInventorySlotInfo("legsslot");
    elseif ( index == 5 )  then _, backgroundTextureName = GetInventorySlotInfo("backslot");
    elseif ( index == 6 )  then _, backgroundTextureName = GetInventorySlotInfo("waistslot");
    elseif ( index == 7 )  then _, backgroundTextureName = GetInventorySlotInfo("shoulderslot");
    elseif ( index == 8 )  then _, backgroundTextureName = GetInventorySlotInfo("necklaceslot");
    elseif ( index == 9 )  then _, backgroundTextureName = GetInventorySlotInfo("ammoslot");
    elseif ( index == 10 ) then _, backgroundTextureName = GetInventorySlotInfo("rangedslot");
    elseif ( index == 11 ) then _, backgroundTextureName = GetInventorySlotInfo("ring0slot");
    elseif ( index == 12 ) then _, backgroundTextureName = GetInventorySlotInfo("ring1slot");
    elseif ( index == 13 ) then _, backgroundTextureName = GetInventorySlotInfo("earring0slot");
    elseif ( index == 14 ) then _, backgroundTextureName = GetInventorySlotInfo("earring1slot");
    elseif ( index == 15 ) then _, backgroundTextureName = GetInventorySlotInfo("mainhandslot");
    elseif ( index == 16 ) then _, backgroundTextureName = GetInventorySlotInfo("secondaryhandslot");
    -- TODO: 17 doesn't really exist for equipped items, so valid numbers are 0-16 and 18-21
    elseif ( index == 17 ) then _, backgroundTextureName = GetInventorySlotInfo("talisman0slot");
    elseif ( index == 18 ) then _, backgroundTextureName = GetInventorySlotInfo("talisman1slot");
    elseif ( index == 19 ) then _, backgroundTextureName = GetInventorySlotInfo("talisman2slot");
    elseif ( index == 20 ) then _, backgroundTextureName = GetInventorySlotInfo("adornmentslot");
    end

    return backgroundTextureName;
end

function IV_GetHouseMaidBackgroundTexture( index )

    local backgroundTextureName;

    if     ( index == 0 )  then _, backgroundTextureName = GetInventorySlotInfo("headslot");
    elseif ( index == 1 )  then _, backgroundTextureName = GetInventorySlotInfo("chestslot");
    elseif ( index == 2 )  then _, backgroundTextureName = GetInventorySlotInfo("legsslot");
    elseif ( index == 3 )  then _, backgroundTextureName = GetInventorySlotInfo("feetslot");
    elseif ( index == 4 )  then _, backgroundTextureName = GetInventorySlotInfo("handsslot");
    elseif ( index == 5 )  then _, backgroundTextureName = GetInventorySlotInfo("waistslot");
    elseif ( index == 6 )  then _, backgroundTextureName = GetInventorySlotInfo("shoulderslot");
    elseif ( index == 7 )  then _, backgroundTextureName = GetInventorySlotInfo("backslot");
    elseif ( index == 8 )  then _, backgroundTextureName = GetInventorySlotInfo("adornmentslot");
    elseif ( index >= 15 and index <= 24 ) then 
		_, backgroundTextureName = GetInventorySlotInfo("talisman0slot");
	end

    return backgroundTextureName;
end

function IV_PopulateEquippedInventory( PlayerName )

    --IV_Log( "start IV_PopulateEquippedInventory" );
    -- Figure out if we're displaying Equipped_1 or Equipped_2 items (based on selected tab)
    local EQSet = IVFrameHouseFurnitureBackdropFrame.PageIndex;
    if ( 3 == EQSet ) then
        return;    -- 3 is the House Furniture tab, not Equipped items
    end

    -- Change the Title to "Equipment 1 :" or "Equipment 2 :" based on which tab is selected
    local HouseFurnitureText = getglobal("IVFrameBackdropHouseFurniture");
    if ( HouseFurnitureText ) then
        HouseFurnitureText:SetText( BACKPACK_EQUIP .. " " .. EQSet .. " :" );
    end

    -- Loop through the 25 slots, displaying each Equipped_1 or Equipped_2 item, hiding the last 4 as they are always empty)
    for i = 101, 125 do

        local itemButton = getglobal("IVItemButton"..i);

        -- Hack alert: apparently this needs to be 22 (instead of 21) because RoM puts the wings 
        -- (adornment slot) as the 22nd slot even though there are only 21 equipment slots (numbered 0-20).
        -- This causes IV to show an extra empty slot for the equipment tabs unless they have wings.  This looks
        -- stupid but i'm in no mood to add hacks to work around bugs in the game.  I'll hack this later when in a better mood.
        local MaxSlots = 22; 
        
        local itemButtonTexture = getglobal("IVItemButton"..i.."QualityBorder");
        itemButton.index = i-101; -- The Equipped items are 0-based, not 1-based like everything else...

        -- If we've gone past the MaxSlots for the equipped inventory, blank out the slot
        if ( itemButton and i > 100 + MaxSlots ) then

            --IV_Log( "hiding button " .. i );
            SetItemButtonTexture( itemButton, nil );
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide();
            itemButton:Hide();

        -- otherwise display whatever is in this slot (if anything)
        elseif ( itemButton and
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped and
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped[EQSet] and
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped[EQSet][i-101] and 
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped[EQSet][i-101].texture and
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped[EQSet][i-101].itemCount ) then

            -- Get the itemLink
            local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped[EQSet][i-101].itemLink;

            if ( not itemLink ) then
                --IV_Log( "IV: Error populating EQ " .. EQSet .. " " .. i-101 .. ".  We have a texture and itemCount, but no itemLink!", 1,0,0 );
            end

            -- Make sure we can see this item button
            if ( not itemButton:IsVisible() ) then
                --IV_Log( "showing button " .. i );
                itemButtonTexture:Show();
                itemButton:Show();
            end

            IV_SetColorBorder( itemLink, itemButtonTexture );

            SetItemButtonTexture( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped[EQSet][i-101].texture );
            SetItemButtonCount( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Equipped[EQSet][i-101].itemCount );
        else
            -- currently selected character may not have anything in this slot, make sure we clear out whatever we're showing
            local backgroundTextureName = IV_GetInventoryBackgroundTexture( itemButton.index );
            getglobal("IVItemButton"..i.."Icon"):SetTexture(backgroundTextureName);
            getglobal("IVItemButton"..i.."Icon"):Show();
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide();

            -- Show any previously hidden buittons as empty
            if ( not itemButton:IsVisible() ) then
                itemButton:Show();
            end
        end
    end

    --IV_Log( "end IV_PopulateEquippedInventory" );
end


function IV_PopulateHouseFurnitureInventory( PlayerName )

    --IV_Log( "start IV_PopulateHouseFurnitureInventory" );

    local selected = IV_GetSelectedFurniture( g_ViewAccountName, PlayerName );

    local MaxSlots = 25;
    local IsHanger;
	local IsHouseMaid;

    if ( selected and g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture and
                      g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected] ) then
        
        -- If the MaxSlots was set for this piece of furniture, use it instead of our default
        if ( g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected].MaxSlots ) then
            MaxSlots = g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected].MaxSlots;
        end
        
        -- If this piece of furniture was flagged as a hanger, set IsHanger to true (otherwise keep it as nil)
        if ( g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected].IsHanger ) then
            IsHanger = true;
        end
		
        -- If this piece of furniture was flagged as a House Maid, set IsHouseMaid to true (otherwise keep it as nil)
        if ( g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected].IsHouseMaid ) then
            IsHouseMaid = true;
        end
    end

    for i = 101, 125 do

        local itemButton = getglobal("IVItemButton"..i);
        local itemButtonTexture = getglobal("IVItemButton"..i.."QualityBorder");
        itemButton.index = i-100;

        -- If we've gone past the MaxSlots for this piece of furniture, blank out the slot
        if ( itemButton and i > 100 + MaxSlots ) then

            --IV_Log( "hiding button " .. i );
            SetItemButtonTexture( itemButton, nil );
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide();
            itemButton:Hide();

        -- otherwise display whatever is in this slot (if anything)
        elseif ( itemButton and selected and
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture and
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected] and 
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected][i-100] and 
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected][i-100].texture and
                 g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected][i-100].itemCount ) then

			-- If this is a House Maid and we're on slot 10-15, blank out the slot to match the official UI
			if ( IsHouseMaid and itemButton.index >= 10 and itemButton.index <= 15 ) then
				--IV_Log( "hiding button " .. i );
				SetItemButtonTexture( itemButton, nil );
				SetItemButtonCount( itemButton, 0 );
				itemButtonTexture:Hide();
				itemButton:Hide();
			end
			
            -- Get the itemLink
            local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected][i-100].itemLink;

            -- Make sure we can see this item button
            if ( not itemButton:IsVisible() ) then
                --IV_Log( "showing button " .. i );
                itemButtonTexture:Show();
                itemButton:Show();
            end

            IV_SetColorBorder( itemLink, itemButtonTexture );

            SetItemButtonTexture( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected][i-100].texture);
            SetItemButtonCount( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture[selected][i-100].itemCount);
			
			--IV_Log("IV_PopulateHouseFurnitureInventory: i:" .. i .. " itemButton.index:" .. itemButton.index .. " itemLink:" .. itemLink );
        else
            -- currently selected character may not have anything in this slot, make sure we clear out whatever we're showing
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide();

            -- Do special handling for Hangers (Clothes/Weapon Racks) and House Maids (Equipment/Tools)
            if ( IsHanger or IsHouseMaid ) then
            
                -- Only show the icon backgrounds if they are items that fit on the clothes rack or weapons rack
                if ( IsHanger and (itemButton.index-1 <=7 or itemButton.index-1 == 15 or itemButton.index-1 == 16) ) then
                    local backgroundTextureName = IV_GetInventoryBackgroundTexture( itemButton.index - 1 ); -- -1 because IV_GetInventoryBackgroundTexture() expects 0-based index
					getglobal("IVItemButton"..i.."Icon"):SetTexture(backgroundTextureName);
					getglobal("IVItemButton"..i.."Icon"):Show();

					-- Show any previously hidden buttons as empty
					if ( not itemButton:IsVisible() ) then
						itemButton:Show();
					end
					
                -- Only show the icon backgrounds if they are items that a House Maid can hold
                elseif ( IsHouseMaid and (itemButton.index-1 <=9 or itemButton.index-1 >= 15) ) then
                    local backgroundTextureName = IV_GetHouseMaidBackgroundTexture( itemButton.index - 1 ); -- -1 because IV_GetHouseMaidBackgroundTexture() expects 0-based index
					getglobal("IVItemButton"..i.."Icon"):SetTexture(backgroundTextureName);
					getglobal("IVItemButton"..i.."Icon"):Show();

					-- Show any previously hidden buttons as empty
					if ( not itemButton:IsVisible() ) then
						itemButton:Show();
					end
                    
                -- Else hide the whole button
                else 
                   --IV_Log( "hiding button " .. i );
                    SetItemButtonTexture( itemButton, nil );
                    itemButton:Hide();
                end
                
            -- Else it's a Storage piece of furniture
            else
                -- Clear the texture for this item
                SetItemButtonTexture( itemButton, nil );
                
                -- Show any previously hidden buittons as empty
                if ( not itemButton:IsVisible() ) then
                    itemButton:Show();
                end
            end
        end
    end

    --IV_Log( "end IV_PopulateHouseFurnitureInventory" );
end


function IV_SetColorBorder( itemLink, itemButtonTexture )

    if ( IVConfig_ItemColor:IsChecked() ) then

        -- Get the R,G,B quality color from the itemLink
        local DecR, DecG, DecB = DecimalRGBFromitemLink( itemLink );

        --IV_Log("ItemSlot "..i.."   RedValue "..DecR.."   GreenValue "..DecG.."   BlueValue "..DecB); -- Debug Mode

        -- Check for Blue and Item Shop Purples and change their color and Alpha.
        if ( DecR == 0 and DecG >= 0.4 and DecG <= 0.45 and DecB >= 0.7 and DecB <= 0.75) then

            -- Set texture Alpha of Blue.
            itemButtonTexture:SetAlpha(0.9); -- (0 to 1)
            --IV_Log("Blue Found at Slot "..i); -- Debug Mode

        elseif ( DecR >= 0.65 and DecR <= 0.67 and DecG >= 0.38 and DecG <= 0.41 and DecB >= 0.65 and DecB <= 0.67 ) then

            -- Set texture Alpha and color of Item Shop Purple.
            DecR = 0.78; DecG = 0.43; DecB = 0.78;
            itemButtonTexture:SetAlpha(1); -- (0 to 1)
        else    
            -- Set texture Alpha of all other item colors.
            itemButtonTexture:SetAlpha(0.6); -- (0 to 1)
        end

        -- If it's white, skip it, otherwise show it
        if ( IVConfig_ItemColorWhite:IsChecked() == false and DecR == 1 and DecG == 1 and DecB == 1) then
            itemButtonTexture:Hide(); -- Don't show quality color on this slot
        else
            itemButtonTexture:Show();
            itemButtonTexture:SetColor(DecR,DecG,DecB); -- (0 to 1)
        end
    else
        itemButtonTexture:Hide(); -- Don't show quality color on this slot
    end
end


function IV_PopulateArcaneTransmutorInventory( CharacterName )

    --IV_Log( "IV_PopulateArcaneTransmutorInventory of char:" .. CharacterName );

    for i = 126, 135 do

        local itemButton = getglobal("IVItemButton"..i);    
        local itemButtonTexture = getglobal("IVItemButton"..i.."QualityBorder");
        itemButton.index = i-125;

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ArcaneTransmutor[itemButton.index] and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ArcaneTransmutor[itemButton.index].texture and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ArcaneTransmutor[itemButton.index].itemCount) then

            -- Get the itemLink
            local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ArcaneTransmutor[itemButton.index].itemLink;

            IV_SetColorBorder( itemLink, itemButtonTexture );

            SetItemButtonTexture( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ArcaneTransmutor[itemButton.index].texture);
            SetItemButtonCount( itemButton, g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharacterName].ArcaneTransmutor[itemButton.index].itemCount);
        else
            -- currently selected character may not have any items in this slot, make sure we clear out whatever we're showing
            SetItemButtonTexture( itemButton, nil );
            SetItemButtonCount( itemButton, 0 );
            itemButtonTexture:Hide(); -- Don't show quality color on empty slot
        end
    end    

    --IV_Log( "end IV_PopulateArcaneTransmutorInventory" );
end


function IsAnyInvalidItemsEquipped()

    -- If any of the equipment slots are showing the "Invalid" texture, then IV will not
    -- be able to re-equip the item if it's picked up
    if ( EquipHeadSlotInvalid:IsVisible() ) then return true; end
    if ( EquipHandsSlotInvalid:IsVisible() ) then return true; end
    if ( EquipFeetSlotInvalid:IsVisible() ) then return true; end
    if ( EquipChestSlotInvalid:IsVisible() ) then return true; end
    if ( EquipLegsSlotInvalid:IsVisible() ) then return true; end
    if ( EquipBackSlotInvalid:IsVisible() ) then return true; end
    if ( EquipWaistSlotInvalid:IsVisible() ) then return true; end
    if ( EquipShoulderSlotInvalid:IsVisible() ) then return true; end
    if ( EquipNecklaceSlotInvalid:IsVisible() ) then return true; end
    if ( EquipAmmoSlotInvalid:IsVisible() ) then return true; end
    if ( EquipRangedSlotInvalid:IsVisible() ) then return true; end
    if ( EquipRing0SlotInvalid:IsVisible() ) then return true; end
    if ( EquipRing1SlotInvalid:IsVisible() ) then return true; end
    if ( EquipEarring0SlotInvalid:IsVisible() ) then return true; end
    if ( EquipEarring1SlotInvalid:IsVisible() ) then return true; end
    if ( EquipMainHandSlotInvalid:IsVisible() ) then return true; end
    if ( EquipSecondaryHandSlotInvalid:IsVisible() ) then return true; end
    if ( EquipTalisman0SlotInvalid:IsVisible() ) then return true; end
    if ( EquipTalisman1SlotInvalid:IsVisible() ) then return true; end
    if ( EquipTalisman2SlotInvalid:IsVisible() ) then return true; end
    if ( EquipAdornmentSlotInvalid:IsVisible() ) then return true; end

    return false;
end


function IVFrame_WipeAccount( AccountName )

    if ( AccountName and AccountName ~= "" ) then

        -- Make sure the user isn't trying to delete the account they are logged into
        if ( AccountName == g_AccountName ) then
            IV_Log( "You can't wipe out the account data for the account you are currently logged in to." );
            return; 
        end

        -- If the ViewAccount is the one we're deleting then select the next account in the UI
        -- to avoid script errors if a user hovers the mouse over the erased item slots
        if ( AccountName == g_ViewAccountName ) then
            IV_SelectAccount( false );
        end

        IV_Log( "Wiping out all Inventory Viewer Data for account: " .. AccountName );

        -- Wipe the specified account
        g_InventoryViewerTable[AccountName] = {};

        -- Re-Initialize this AddOn (without registering with the AddOn Manager again) to recreate tables that may no
        -- longer be valid (list of accounts on this server, etc)
        g_IVStatus.Initialized = false;
        IV_Initialize( true );
        return;
    end
end


function IVItemButton_OnLeave(this)

    --IV_Log( "IVItemButton_OnLeave" )
    GameTooltip:Hide();
end


function IVItemButton_GetItemLinkFromTable( ID )

    local itemLink = "";

    -- bank item
    if ( ID > 0 and ID < 41 ) then

        -- The Table supports all 200 slots, figure out which slot in the Bank table we're on
        local TableIndex = ( IVFrameBankBackdropFrame.PageIndex - 1 ) * 40 + ID;

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Bank[TableIndex] and 
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Bank[TableIndex].itemLink) then

            itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Bank[TableIndex].itemLink;
        end

    -- backpack item
    elseif ( ID > 40 and ID < 101 and IVFrameBackpackBackdropFrame.PageIndex ~= 4 ) then

        -- The Table supports all 180 slots, figure out which slot in the Backpack table we're on
        local TableIndex = ( IVFrameBackpackBackdropFrame.PageIndex - 1 ) * 60 + (ID-40);

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Backpack[TableIndex] and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Backpack[TableIndex].itemLink) then

            itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Backpack[TableIndex].itemLink;
        end

    -- ItemShop Backpack item
    elseif ( ID > 40 and ID < 91 and IVFrameBackpackBackdropFrame.PageIndex == 4 ) then

        local TableIndex = ID-40;

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].ItemShopBag[TableIndex] and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].ItemShopBag[TableIndex].itemLink) then

            itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].ItemShopBag[TableIndex].itemLink;
        end

    -- House Furniture  or Equipped items
    elseif ( ID > 100 and ID < 126 ) then

        -- Figure out if we're displaying House Furniture or Equipped items (based on selected tab)
        if ( 3 == IVFrameHouseFurnitureBackdropFrame.PageIndex ) then

            -- House Furniture
            local selected = IV_GetSelectedFurniture( g_ViewAccountName, g_IVSelectedCharTabName );

            -- Get the itemLink from House Furniture (if there's an item in this slot)
            if ( selected ) then

                if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Furniture and
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Furniture[selected] and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Furniture[selected][ID-100] and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Furniture[selected][ID-100].itemLink) then

                    itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Furniture[selected][ID-100].itemLink;
                end
            end
        else
            -- Equipped Items
            local EQSet = IVFrameHouseFurnitureBackdropFrame.PageIndex;

            -- Get the itemLink from Equipped Items (if there's one in this slot)
            if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Equipped and
                g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Equipped[EQSet] and 
                g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Equipped[EQSet][ID-101] and 
                g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Equipped[EQSet][ID-101].itemLink) then

                itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].Equipped[EQSet][ID-101].itemLink;
            end
        end

    -- Arcane Transmutor (5 shown slots + 5 hidden slots)
    elseif ( ID > 125 and ID < 136 ) then

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].ArcaneTransmutor and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].ArcaneTransmutor[ID-125] and
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].ArcaneTransmutor[ID-125].itemLink) then

            itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].ArcaneTransmutor[ID-125].itemLink;
        end
    end

    return itemLink;
end


function IV_GetItemID( itemLink )

    local ret = "";
    local _type, _data, _name = ParseHyperlink(itemLink);

    if ( _data and _data ~= "" ) then
        _,_,ret = string.find(_data, "(%x+)");
    end

    return ret;
end


-- Public Interface: Will not change, safe to call from external AddOns or Macros
function IV_GetListOfItemsByName( Name )
    return IV_GetListOfItemsByNameOrItemLink( true, Name, false, false ); -- search for substring name, brief results
end

-- Public Interface: Will not change, safe to call from external AddOns or Macros
function IV_GetDetailedListOfItemsByName( Name )
    return IV_GetListOfItemsByNameOrItemLink( true, Name, false, true ); -- search for substring name, detailed results
end

-- Public Interface: Will not change, safe to call from external AddOns or Macros
function IV_GetListOfItems( itemLink )
    return IV_GetListOfItemsByNameOrItemLink( false, itemLink, false, false ); -- search for itemLink, brief results
end

-- Public Interface: Will not change, safe to call from external AddOns or Macros
function IV_GetDetailedListOfItems( itemLink )
    return IV_GetListOfItemsByNameOrItemLink( false, itemLink, false, true ); -- search for itemLink, detailed results
end

-- Public Interface: Will not change, safe to call from external AddOns or Macros
-- This will try to auto-detect if the caller is using an itemLink or just a Name 
-- and call the appropriate function (substring search, brief results)
function IV_GetListOfItems2( text )

    if (not text) then
        return;
    end

    -- Is there a pipe character in the string?  If so, treat it as an itemLink, else Name
    if ( string.find(text, "|") ~= nil ) then
        return IV_GetListOfItemsByNameOrItemLink( false, text, false, false ); -- search for itemLink, brief results
    else
        return IV_GetListOfItemsByNameOrItemLink( true, text, false, false ); -- search for substring name, brief results
    end
end

-- Public Interface: Will not change, safe to call from external AddOns or Macros
-- This will try to auto-detect if the caller is using an itemLink or just a Name 
-- and call the appropriate function (substring search, detailed results)
function IV_GetDetailedListOfItems2( text )

	--IV_Log( "IV_GetDetailedListOfItems2 start");
	
    if (not text) then
		--IV_Log( "IV_GetDetailedListOfItems2 end1");
        return;
    end

    -- Is there a pipe character in the string?  If so, treat it as an itemLink, else Name
    if ( string.find(text, "|") ~= nil ) then
		--IV_Log( "IV_GetDetailedListOfItems2 end2");
        return IV_GetListOfItemsByNameOrItemLink( false, text, false, true ); -- search for itemLink. detailed results
    else
		--IV_Log( "IV_GetDetailedListOfItems2 end3");
        return IV_GetListOfItemsByNameOrItemLink( true, text, false, true ); -- search for substring name, detailed results
    end
end

-- Public Interface: Will not change, safe to call from external AddOns or Macros
-- This will try to auto-detect if the caller is using an itemLink or exact Name 
-- and call the appropriate function (exact string match, brief results)
function IV_GetListOfItems3( text )

    --Log( "IV_GetListOfItems3( text ): '" .. tostring(text) .. "'" );

    if (not text) then
        return;
    end

    -- Is there a pipe character in the string?  If so, treat it as an itemLink, else Name
    if ( string.find(text, "|") ~= nil ) then
        return IV_GetListOfItemsByNameOrItemLink( false, text, false, false ); -- search for itemLink, brief results
    else
        return IV_GetListOfItemsByNameOrItemLink( true, text, true, false ); -- search for exact name, brief results
    end
end


-- Public Interface: Will not change, safe to call from external AddOns or Macros
-- This will try to auto-detect if the caller is using an itemLink or exact Name 
-- and call the appropriate function (exact string match, detailed results)
function IV_GetDetailedListOfItems3( text )

    --Log( "IV_GetDetailedListOfItems3( text ): '" .. tostring(text) .. "'" );

    if (not text) then
        return;
    end

    -- Is there a pipe character in the string?  If so, treat it as an itemLink, else Name
    if ( string.find(text, "|") ~= nil ) then
        return IV_GetListOfItemsByNameOrItemLink( false, text, false, true ); -- search for itemLink, detailed results
    else
        return IV_GetListOfItemsByNameOrItemLink( true, text, true, true ); -- search for exact name, detailed results
    end
end


-- ************************************************************************************************
-- DO NOT CALL IV_GetListOfItemsByNameOrItemLink DIRECTLY!  IT MAY CHANGE IN THE FUTURE!!!       --
-- Instead, Use IV_GetListOfItems(), IV_GetDetailedListOfItems(),
--              IV_GetListOfItemsByName(), IV_GetDetailedListOfItemsByName(),
--              IV_GetListOfItems2(), IV_GetDetailedListOfItems2(),
-- 				IV_GetListOfItems3(), or IV_GetDetailedListOfItems3()
-- ************************************************************************************************
function IV_GetListOfItemsByNameOrItemLink( bName, NameOrItemLink, bExactNameMatch, bDetailedList )

    --if ( bName ) then
    --    IV_Log( "IV_GetListOfItemsByNameOrItemLink Name: " .. NameOrItemLink );
    --else
    --    IV_Log( "IV_GetListOfItemsByNameOrItemLink itemLink: " .. NameOrItemLink );
    --end
    --if ( bExactNameMatch == true ) then
    --    IV_Log( "IV_GetListOfItemsByNameOrItemLink bExactNameMatch=true" );
    --else
    --    IV_Log( "IV_GetListOfItemsByNameOrItemLink bExactNameMatch=false" );
    --end

    local text = "";
	local tblDetailedResults = {};
    local total = 0;

    -- Cycle thru all the characters on this Account/Realm

    for CharName, CharTable in pairs( g_InventoryViewerTable[g_ViewAccountName][g_Realm] ) do

        if ( CharName ) then

            -- Loop through all bank items for CharName
            --IV_Log( "Searching " .. CharName .. "'s Bank for " .. NameOrItemLink );

            local tmpBank = 0;
			local tmpDetailedBankTxt = "";
			local location = "In " .. CharName .. APOSTRAPHE_S .. " " .. BANK;

            for i=1, 200 do

                if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Bank and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Bank[i] and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Bank[i].itemLink) then

					local itemCount = 0;
					local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Bank[i].itemLink;
					local itemID = IV_GetItemID(itemLink);
					
					
                    if ( bName ) then -- Search via Name of item
					
						-- Is the caller only interested in exact matches? (not a susbstring search)
						if ( bExactNameMatch == true ) then
						
							if ( string.upper(GetNameFromitemLink(itemLink)) == string.upper(NameOrItemLink) ) then
								itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Bank[i].itemCount or 0;
								tmpBank = tmpBank + itemCount;
								--IV_Log( "tmpBank: [" .. i .. "] " .. tmpBank );
							else
								--IV_Log( "IV_GetListOfItemsByNameOrItemLink didn't find an exact match" );
								--IV_Log( "'" .. GetNameFromitemLink(itemLink) .. "' != '" .. NameOrItemLink .. "'" )
							end
						
						-- Caller is interested in substring matches (searching for Dark Crystal will hit on Dark Crystal Sand)
                        elseif ( string.find(string.upper(itemLink), string.upper(NameOrItemLink)) ~= nil ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Bank[i].itemCount or 0;
                            tmpBank = tmpBank + itemCount;
                            --IV_Log( "tmpBank: [" .. i .. "] " .. tmpBank );
                        end
                    else -- Search via itemLink
                        if ( IV_GetItemID(NameOrItemLink) == IV_GetItemID(itemLink) ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Bank[i].itemCount or 0;
                            tmpBank = tmpBank + itemCount;
                            --IV_Log( "tmpBank: [" .. i .. "] " .. tmpBank );
                        end
                    end
					
					-- Update the detailed results table if we got a hit on this slot
					if ( bDetailedList and itemCount > 0) then
					
						if ( not tblDetailedResults[location] ) then
							tblDetailedResults[location] = {};
						end
						
						if ( not tblDetailedResults[location][itemID] ) then
							tblDetailedResults[location][itemID] = {};
							tblDetailedResults[location][itemID].count = 0;
							tblDetailedResults[location][itemID].itemLink = itemLink;
						end
						
						local prevCount = tblDetailedResults[location][itemID].count;
						tblDetailedResults[location][itemID].count = prevCount + itemCount;
					end
                else
                    --IV_Log( "Slot " .. i .. " is empty." );
                end
            end

            -- If we found any, set the  text 
            if ( tmpBank > 0 ) then
                text = text .. MoneyNormalization(tmpBank) .. " " .. location .. "\n";
                total = total + tmpBank;
            end


            -- Loop through all the backpack items for CharName
            --IV_Log( "Searching " .. CharName .. "'s Backpack for " .. NameOrItemLink );

            local tmpBackpack = 0;
			local location = "In " .. CharName .. APOSTRAPHE_S .. " " .. GCF_TEXT_BAG;
			
            for i=1, 180 do

                if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i] and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemLink) then

					local itemCount = 0;
					local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemLink;
					local itemID = IV_GetItemID(itemLink);
					
                    if ( bName ) then -- Search via Name of item
					
						-- Is the caller only interested in exact matches? (not a susbstring search)
						if ( bExactNameMatch == true ) then
						
							if ( string.upper(GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemLink)) == string.upper(NameOrItemLink) ) then
								itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemCount or 0;
								tmpBackpack = tmpBackpack + itemCount;
								--IV_Log( "tmpBackpack: [" .. i .. "] " .. tmpBackpack );
							else
								--IV_Log( "'" .. GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemLink) .. "' != '" .. NameOrItemLink .. "'" )
							end
						
						-- Caller is interested in substring matches (searching for Dark Crystal will hit on Dark Crystal Sand)
                        elseif ( string.find(string.upper(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemLink), string.upper(NameOrItemLink)) ~= nil ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemCount or 0;
							tmpBackpack = tmpBackpack + itemCount;
                            --IV_Log( "tmpBackpack: [" .. i .. "] " .. tmpBackpack );
                        end
                    else -- Search via itemLink
                        if ( IV_GetItemID(NameOrItemLink) == IV_GetItemID(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemLink) ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Backpack[i].itemCount or 0;
							tmpBackpack = tmpBackpack + itemCount;
                            --IV_Log( "tmpBackpack: [" .. i .. "] " .. tmpBackpack );
                        end
                    end
					
					-- Update the detailed results table if we got a hit on this slot
					if ( bDetailedList and itemCount > 0) then
					
						if ( not tblDetailedResults[location] ) then
							tblDetailedResults[location] = {};
						end
						
						if ( not tblDetailedResults[location][itemID] ) then
							tblDetailedResults[location][itemID] = {};
							tblDetailedResults[location][itemID].count = 0;
							tblDetailedResults[location][itemID].itemLink = itemLink;
						end
						
						local prevCount = tblDetailedResults[location][itemID].count;
						tblDetailedResults[location][itemID].count = prevCount + itemCount;
					end
                else
                    --IV_Log( "Slot " .. i .. " is empty." );
                end
            end

            -- If we found any, set the  text
            if ( tmpBackpack > 0 ) then
                text = text .. MoneyNormalization(tmpBackpack) .. " " .. location .. "\n";
                total = total + tmpBackpack;
            end


            -- Loop through all the item shop backpack items for CharName
            --IV_Log( "Searching " .. CharName .. "'s Item Shop Backpack for " .. NameOrItemLink );

            local tmpItemShopBag = 0;
			local location = "In " .. CharName .. APOSTRAPHE_S .. " " .. GOODSPACK;
			
            for i=1, 50 do

                if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i] and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemLink) then

					local itemCount = 0;
					local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemLink;
					local itemID = IV_GetItemID(itemLink);
					
                    if ( bName ) then -- Search via Name of item
					
						-- Is the caller only interested in exact matches? (not a susbstring search)
						if ( bExactNameMatch == true ) then
							
							if ( string.upper(GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemLink)) == string.upper(NameOrItemLink) ) then
								itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemCount or 0;
								tmpItemShopBag = tmpItemShopBag + itemCount;
								--IV_Log( "tmpItemShopBag: [" .. i .. "] " .. tmpItemShopBag );
							else
								--IV_Log( "'" .. GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemLink) .. "' != '" .. NameOrItemLink .. "'" )
							end
						
						-- Caller is interested in substring matches (searching for Dark Crystal will hit on Dark Crystal Sand)
                        elseif ( string.find(string.upper(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemLink), string.upper(NameOrItemLink)) ~= nil ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemCount or 0;
							tmpItemShopBag = tmpItemShopBag + itemCount;
                            --IV_Log( "tmpItemShopBag: [" .. i .. "] " .. tmpItemShopBag );
                        end
                    else -- Search via itemLink
                        if ( IV_GetItemID(NameOrItemLink) == IV_GetItemID(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemLink) ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ItemShopBag[i].itemCount or 0;
							tmpItemShopBag = tmpItemShopBag + itemCount;
                            --IV_Log( "tmpItemShopBag: [" .. i .. "] " .. tmpItemShopBag );
                        end
                    end
					
					-- Update the detailed results table if we got a hit on this slot
					if ( bDetailedList and itemCount > 0) then

						if ( not tblDetailedResults[location] ) then
							tblDetailedResults[location] = {};
						end
						
						if ( not tblDetailedResults[location][itemID] ) then
							tblDetailedResults[location][itemID] = {};
							tblDetailedResults[location][itemID].count = 0;
							tblDetailedResults[location][itemID].itemLink = itemLink;
						end
						
						local prevCount = tblDetailedResults[location][itemID].count;
						tblDetailedResults[location][itemID].count = prevCount + itemCount;
					end
                else
                    --IV_Log( "Slot " .. i .. " is empty." );
                end
            end

            -- If we found any, set the  text
            if ( tmpItemShopBag > 0 ) then
                text = text .. MoneyNormalization(tmpItemShopBag) .. " " .. location .. "\n";
                total = total + tmpItemShopBag;
            end


            -- Loop through all the Equipped items for CharName
            --IV_Log( "Searching " .. CharName .. "'s Equipped items for " .. NameOrItemLink );

            local tmpEquippedSet = 0;

            -- loop through both equipped sets
            for EQSet=1, 2 do

                -- reset count for this set of equipment
                tmpEquippedSet = 0;
				local location = "In " .. CharName .. APOSTRAPHE_S .. " " .. BACKPACK_EQUIP .. "_" .. EQSet;

                for i=0, 20 do

                    if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped and 
                        g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet] and
                        g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i] and 
                        g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemLink) then

						local itemCount = 0;
						local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemLink;
						local itemID = IV_GetItemID(itemLink);

                        if ( bName ) then -- Search via Name of item
					
							-- Is the caller only interested in exact matches? (not a susbstring search)
							if ( bExactNameMatch == true ) then
								
								if ( string.upper(GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemLink)) == string.upper(NameOrItemLink) ) then
									itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemCount or 0;
									tmpEquippedSet = tmpEquippedSet + itemCount;
									 --IV_Log( "tmpEquippedSet " .. EQSet .. ": [" .. i .. "] " .. tmpEquippedSet );
								else
									--IV_Log( "'" .. GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemLink) .. "' != '" .. NameOrItemLink .. "'" )
								end
							
							-- Caller is interested in substring matches (searching for Dark Crystal will hit on Dark Crystal Sand)
							elseif ( string.find(string.upper(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemLink), string.upper(NameOrItemLink)) ~= nil ) then
								itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemCount or 0;
								tmpEquippedSet = tmpEquippedSet + itemCount;
								--IV_Log( "tmpEquippedSet " .. EQSet .. ": [" .. i .. "] " .. tmpEquippedSet );
							end
                        else -- Search via itemLink
                            if ( IV_GetItemID(NameOrItemLink) == IV_GetItemID(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemLink) ) then
								itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Equipped[EQSet][i].itemCount or 0;
								tmpEquippedSet = tmpEquippedSet + itemCount;
                                --IV_Log( "tmpEquippedSet " .. EQSet .. ": [" .. i .. "] " .. tmpEquippedSet );
                            end
                        end

						-- Update the detailed results table if we got a hit on this slot
						if ( bDetailedList and itemCount > 0) then
						
							if ( not tblDetailedResults[location] ) then
								tblDetailedResults[location] = {};
							end
							
							if ( not tblDetailedResults[location][itemID] ) then
								tblDetailedResults[location][itemID] = {};
								tblDetailedResults[location][itemID].count = 0;
								tblDetailedResults[location][itemID].itemLink = itemLink;
							end
							
							local prevCount = tblDetailedResults[location][itemID].count;
							tblDetailedResults[location][itemID].count = prevCount + itemCount;
						end
                    else
                        --IV_Log( "Slot " .. i .. " is empty." );
                    end
                end

                -- If we found any, set the  text
                if ( tmpEquippedSet > 0 ) then
                    text = text .. MoneyNormalization(tmpEquippedSet) .. " " .. location .. "\n";
                    total = total + tmpEquippedSet;
                end
            end


            -- Loop through all Furniture for CharName
            --IV_Log( "Searching " .. CharName .. "'s Furniture for " .. NameOrItemLink );

            if ( CharTable.Furniture ) then

                for DBID, FurnitureTable in pairs( CharTable.Furniture ) do

                    local tmpFurniture = 0;
					local location = "";
					local bHouseMaid = FurnitureTable.IsHouseMaid;
					if ( bHouseMaid == true ) then
						location = "On " .. CharName .. APOSTRAPHE_S .. " " .. _glossary_00304 .. " " .. FurnitureTable.Name;
					else
						location = "In " .. CharName .. APOSTRAPHE_S .. " " .. FurnitureTable.Name;
					end
					
                    local MaxSlots = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].Furniture[DBID].MaxSlots or 20;

                    -- Loop through each item in the current furniture searching for the specified NameOrItemLink
                    for i=1, MaxSlots do
						
                        if (FurnitureTable[i] and FurnitureTable[i].itemLink) then

							local itemCount = 0;
							local itemLink = FurnitureTable[i].itemLink;
							local itemID = IV_GetItemID(itemLink);
							
                            if ( bName ) then -- Search via Name of item
					
								-- Is the caller only interested in exact matches? (not a susbstring search)
								if ( bExactNameMatch == true ) then
									
									if ( string.upper(GetNameFromitemLink(FurnitureTable[i].itemLink)) == string.upper(NameOrItemLink) ) then
										itemCount = FurnitureTable[i].itemCount or 0;
										tmpFurniture = tmpFurniture + itemCount;
										 --IV_Log( "tmpFurniture: " .. tmpFurniture );
									else
										--IV_Log( "'" .. GetNameFromitemLink(FurnitureTable[i].itemLink) .. "' != '" .. NameOrItemLink .. "'" )
									end
								
								-- Caller is interested in substring matches (searching for Dark Crystal will hit on Dark Crystal Sand)
								elseif ( string.find(string.upper(FurnitureTable[i].itemLink), string.upper(NameOrItemLink)) ~= nil ) then
									itemCount = FurnitureTable[i].itemCount or 0;
									tmpFurniture = tmpFurniture + itemCount;
                                    --IV_Log( "tmpFurniture: " .. tmpFurniture );
                                end
                            else -- Search via itemLink
                                if ( IV_GetItemID(NameOrItemLink) == IV_GetItemID(FurnitureTable[i].itemLink) ) then
									itemCount = FurnitureTable[i].itemCount or 0;
									tmpFurniture = tmpFurniture + itemCount;
                                    --IV_Log( "tmpFurniture: " .. tmpFurniture );
                                end
                            end

							-- Update the detailed results table if we got a hit on this slot
							if ( bDetailedList and itemCount > 0) then

								if ( not tblDetailedResults[location] ) then
									tblDetailedResults[location] = {};
								end
								
								if ( not tblDetailedResults[location][itemID] ) then
									tblDetailedResults[location][itemID] = {};
									tblDetailedResults[location][itemID].count = 0;
									tblDetailedResults[location][itemID].itemLink = itemLink;
								end
								
								local prevCount = tblDetailedResults[location][itemID].count;
								tblDetailedResults[location][itemID].count = prevCount + itemCount;
							end
                        else
                            --IV_Log( "Slot " .. i .. " is empty." );
                        end
                    end

                    -- If we found any, set the  text
                    if ( tmpFurniture > 0 ) then
                        text = text .. MoneyNormalization(tmpFurniture) .. " " .. location .. "\n";
                        total = total + tmpFurniture;
                    end
                end            
            end


            -- Loop through all Arcane Transmutor items for CharName
            --IV_Log( "Searching " .. CharName .. "'s Arcane Transmutor for " .. NameOrItemLink );

            local tmpArcaneTransmutor = 0;
			local location = "In " .. CharName .. APOSTRAPHE_S .. " " .. MAGICBOX_TITLE;
			
            for i=1, 10 do

                if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i] and 
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemLink) then

					local itemCount = 0;
					local itemLink = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemLink;
					local itemID = IV_GetItemID(itemLink);
					
                    if ( bName ) then -- Search via Name of item
					
						-- Is the caller only interested in exact matches? (not a susbstring search)
						if ( bExactNameMatch == true ) then
							
							if ( string.upper(GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemLink)) == string.upper(NameOrItemLink) ) then
								itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemCount or 0;
								tmpArcaneTransmutor = tmpArcaneTransmutor + itemCount;
								 --IV_Log( "tmpFurniture: " .. tmpFurniture );
							else
								--IV_Log( "'" .. GetNameFromitemLink(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemLink) .. "' != '" .. NameOrItemLink .. "'" )
							end
						
						-- Caller is interested in substring matches (searching for Dark Crystal will hit on Dark Crystal Sand)
						elseif ( string.find(string.upper(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemLink), string.upper(NameOrItemLink)) ~= nil ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemCount or 0;
							tmpArcaneTransmutor = tmpArcaneTransmutor + itemCount;
                            --IV_Log( "tmpArcaneTransmutor: [" .. i .. "] " .. tmpArcaneTransmutor );
                        end
                    else -- Search via itemLink
                        if ( IV_GetItemID(NameOrItemLink) == IV_GetItemID(g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemLink) ) then
							itemCount = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CharName].ArcaneTransmutor[i].itemCount or 0;
							tmpArcaneTransmutor = tmpArcaneTransmutor + itemCount;
                            --IV_Log( "tmpArcaneTransmutor: [" .. i .. "] " .. tmpArcaneTransmutor );
                        end
                    end

					-- Update the detailed results table if we got a hit on this slot
					if ( bDetailedList and itemCount > 0) then

						if ( not tblDetailedResults[location] ) then
							tblDetailedResults[location] = {};
						end
						
						if ( not tblDetailedResults[location][itemID] ) then
							tblDetailedResults[location][itemID] = {};
							tblDetailedResults[location][itemID].count = 0;
							tblDetailedResults[location][itemID].itemLink = itemLink;
						end
						
						local prevCount = tblDetailedResults[location][itemID].count;
						tblDetailedResults[location][itemID].count = prevCount + itemCount;
					end
                else
                    --IV_Log( "Slot " .. i .. " is empty." );
                end

            end

            -- If we found any, set the  text
            if ( tmpArcaneTransmutor > 0 ) then
                text = text .. MoneyNormalization(tmpArcaneTransmutor) .. " " .. location .. "\n";
                total = total + tmpArcaneTransmutor;
            end
        end
    end

    if ( text ~= "" and total > 0 ) then
        text = text .. "|cffFCCF00" .. MoneyNormalization(total) .. " total|r\n";
    end

	if ( bDetailedList ) then
		return tblDetailedResults, total;
	end
	
    --IV_Log( "Returning found item text: \n" .. text );
    return text;
end


-- Get the real count of Phirius tokens this character has.  The RoM API GetPlayerMoney("billdin") only gets the 
-- number of Phirius Tokens in the characters backpack (where it needs to be to spend it) but our users need to know
-- the real count, including any Phirius Tokens in the bank and house furniture
function IV_GetMyRealPhiriusTokenCount()

    -- Get the count in my backpack using the API
    local total = GetPlayerMoney("billdin");

    -- Check the bank
    for i=1, 200 do

        if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Bank and 
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Bank[i] and 
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Bank[i].itemLink) then

            if ( string.find(g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Bank[i].itemLink, "Hitem:3191e ") ~= nil ) then
                total = total + g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Bank[i].itemCount or 0;
            end
        end
    end
    
    -- Check in all the house furniture
    if (g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Furniture ) then 

        for DBID, FurnitureTable in pairs( g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Furniture ) do

            local tmpFurniture = 0;
            local MaxSlots = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CurrentPlayerName].Furniture[DBID].MaxSlots or 20;

            -- Loop through each item in the current furniture searching for the specified NameOrItemLink
            for i=1, MaxSlots do

                if (FurnitureTable[i] and FurnitureTable[i].itemLink) then

                    if ( string.find(FurnitureTable[i].itemLink, "Hitem:3191e ") ~= nil ) then
                        total = total + FurnitureTable[i].itemCount or 0;
                    end
                end
            end
        end
    end

    -- They can't go in the Item Shop backpack or Arcane Transmutor, so no need to check there.

    --IV_Log( "IV_GetMyRealPhiriusTokenCount: " .. total );
    return total;
end


function IVItemButton_OnEnter(this)

    --IV_Log( "IVItemButton_OnEnter" );

    local itemLink = IVItemButton_GetItemLinkFromTable( this:GetID() );

    if ( itemLink ~= "" ) then

        -- Set the Tooltip to the itemLink info
        GameTooltip:ClearAllAnchors();
        GameTooltip:SetAnchor("TOPLEFT", "BOTTOMRIGHT", this:GetName(),2,0);

        -- Show the tooltip
        GameTooltip:Show();
        GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 0, 0);
        GameTooltip:SetHyperLink( itemLink );
    end
end


function IVItemButton_OnClick(this, button, ignoreShift)

    --IV_Log( "IVItemButton_OnClick" )

    local itemLink = IVItemButton_GetItemLinkFromTable( this:GetID() );

    if ( button == "LBUTTON" ) then
        if( IsShiftKeyDown() ) then
            --IV_Log( "Shift key is down" .. this:GetID() );
            if( ITEMLINK_EDITBOX )then
                ChatEdit_AddItemLink( itemLink );
                return;
            end
        elseif( IsCtrlKeyDown() ) then
            --IV_Log( "Ctrl key is down" )
            ItemPreviewFrame_SetItemLink( ItemPreviewFrame, itemLink );
            return;
        end
    end
end


function IVFrame_OnLoad(this)    

    --IV_Log( "IVFrame_OnLoad" );

    UIPanelBackdropFrame_SetTexture( this, "Interface/Common/PanelCommonFrame", 256 , 256 );


    -- Set anchors and Bank button locations, anchored off IVItemButton1
    local itemButton;
    local nBankStartingSlot = 1;
    local nBankEndingSlot = 40;
    local nBankSlotsPerLine = 5;
    local nBankEndOfTopLineSlotNumber = nBankStartingSlot + nBankSlotsPerLine - 1;

    local BankText = getglobal("IVFrameBackdropBank");
    if ( BankText ) then
        BankText:SetText( BANK .. " :" );
    end

    -- skip first slot as it's Anchor is set in the XML file
    for i = nBankStartingSlot+1, nBankEndingSlot do
        itemButton = getglobal("IVItemButton" .. i);
        if ( itemButton ) then
            itemButton:ClearAllAnchors();
            if (i <= nBankEndOfTopLineSlotNumber) then
                itemButton:SetAnchor("TOPLEFT", "TOPRIGHT", "IVItemButton" .. (i-1), 4, 0);
            else                
                itemButton:SetAnchor("TOPLEFT", "BOTTOMLEFT", "IVItemButton" .. (i-nBankSlotsPerLine), 0, 4);
            end
        end
    end

    -- Set anchors and Backpack or ItemShop button locations, anchored off IVItemButton41
    local nBackPackStartingSlot = 41;
    local nBackpackEndingSlot = 100;
    local nBackpackSlotsPerLine = 6;
    local nBackpackEndOfTopLineSlotNumber = nBackPackStartingSlot + nBackpackSlotsPerLine - 1;

    local BackPackText = getglobal("IVFrameBackdropBackpack");
    if ( BackPackText ) then
        BackPackText:SetText( GCF_TEXT_BAG .. "/" .. GOODSPACK .. " :" );
    end

    -- skip first slot as it's Anchor is set in the XML file
    for i = nBackPackStartingSlot+1, nBackpackEndingSlot do
        itemButton = getglobal("IVItemButton" .. i);
        if ( itemButton ) then
            itemButton:ClearAllAnchors();
            if (i <= nBackpackEndOfTopLineSlotNumber) then
                itemButton:SetAnchor("TOPLEFT", "TOPRIGHT", "IVItemButton" .. (i-1), 4, 0);
            else                
                itemButton:SetAnchor("TOPLEFT", "BOTTOMLEFT", "IVItemButton" .. (i-nBackpackSlotsPerLine), 0, 4);
            end
        end
    end


    -- Set anchors and Equipped items / House Furniture button locations, anchored off IVItemButton101
    local nHouseFurnitureStartingSlot = 101;
    local nHouseFurnitureEndingSlot = 125;
    local nHouseFurnitureSlotsPerLine = 5;
    local nHouseFurnitureEndOfTopLineSlotNumber = nHouseFurnitureStartingSlot + nHouseFurnitureSlotsPerLine - 1;

    local HouseFurnitureText = getglobal("IVFrameBackdropHouseFurniture");
    if ( HouseFurnitureText ) then
        HouseFurnitureText:SetText( BACKPACK_EQUIP .. " / " .. UI_HOUSEFRAME_PLACEFURNISH .. " :" );
    end

    -- skip first slot as it's Anchor is set in the XML file
    for i = nHouseFurnitureStartingSlot+1, nHouseFurnitureEndingSlot do
        itemButton = getglobal("IVItemButton" .. i);
        if ( itemButton ) then
            itemButton:ClearAllAnchors();
            if (i <= nHouseFurnitureEndOfTopLineSlotNumber) then
                itemButton:SetAnchor("TOPLEFT", "TOPRIGHT", "IVItemButton" .. (i-1), 4, 0);
            else                
                itemButton:SetAnchor("TOPLEFT", "BOTTOMLEFT", "IVItemButton" .. (i-nHouseFurnitureSlotsPerLine), 0, 4);
            end
        end
    end


    -- Set anchors and Arcane Transmutor button locations, anchored off IVItemButton126
    local nArcaneTransmutorStartingSlot = 126;
    local nArcaneTransmutorEndingSlot = 135;
    local nArcaneTransmutorSlotsPerLine = 5;
    local nArcaneTransmutorEndOfTopLineSlotNumber = nArcaneTransmutorStartingSlot + nArcaneTransmutorSlotsPerLine - 1;

    local ArcaneTransmutorText = getglobal("IVFrameBackdropArcaneTransmutorText");
    if ( ArcaneTransmutorText ) then
        ArcaneTransmutorText:SetText( MAGICBOX_TITLE .. " :" );
    end

    -- skip first slot as it's Anchor is set in the XML file
    for i = nArcaneTransmutorStartingSlot+1, nArcaneTransmutorEndingSlot do
        itemButton = getglobal("IVItemButton" .. i);
        if ( itemButton ) then
            itemButton:ClearAllAnchors();

            if (i <= nArcaneTransmutorEndOfTopLineSlotNumber) then
                itemButton:SetAnchor("TOPLEFT", "TOPRIGHT", "IVItemButton" .. (i-1), 4, 0);
            else                
                itemButton:SetAnchor("TOPLEFT", "BOTTOMLEFT", "IVItemButton" .. (i-nArcaneTransmutorSlotsPerLine), 0, 4);
            end
        end
    end


    -- Show Localized Options Text 

    -- Enhanced Tooltips
    local Options_Text = getglobal("IVConfig_ToolTips_Text");
    if ( Options_Text ) then
        Options_Text:SetText( OPTIONTEXT_ENHANCED_TOOLTIPS );
    end

    -- Show Minimap icon
    Options_Text = getglobal("IVConfig_MiniMapCheck_Text");
    if ( Options_Text ) then
        Options_Text:SetText( OPTIONTEXT_SHOW_MINIMAP_ICON );
    end

    -- Item border color
    Options_Text = getglobal("IVConfig_ItemColor_Text");
    if ( Options_Text ) then
        Options_Text:SetText( OPTIONTEXT_ITEM_BORDER_COLOR );
    end

    -- Item border color White
    Options_Text = getglobal("IVConfig_ItemColorWhite_Text");
    if ( Options_Text ) then
        Options_Text:SetText( OPTIONTEXT_ITEM_BORDER_COLOR_WHITE );
    end

    -- Register for all the events IV cares about
    IV_RegisterForEvents( this );

    -- Set title bar of UI
    getglobal( this:GetName() .. "Title" ):SetText( PLUGIN_TITLE );

    --IV_Log( "end IVFrame_OnLoad" );
end


function IVFrame_OnShow(this)

    --IV_Log("IVFrame_OnShow");

    -- For performance reasons, we may not have an updated UI for the instant items (Backpack/Bank/Item Shop Backpack/Arcane Transmutor)
    -- So we need to make sure they are correct for this character before displaying the UI (only if this charcter is the currently selected tab, otherwise it's not an issue)
    if ( IV_IsSelectedTabCurrentPlayer() ) then

        IV_PopulateBankInventory( g_CurrentPlayerName );
        IV_PopulateBackpackOrItemShopInventory( g_CurrentPlayerName );
        IV_PopulateFurnitureOrEquippedInventory( g_CurrentPlayerName );
        IV_PopulateArcaneTransmutorInventory( g_CurrentPlayerName );
    end

    -- This must be populated everytime the UI is shown because changes in Money on this character affect totals shown
    -- even when a different Account or Character is selected in the IV UI.
    IV_PopulateMoney();

    this:ResetFrameOrder();
end


function IVFrame_OnHide(this)
    --IV_Log("IVFrame_OnHide");
    this:Hide();
end


function IVFrame_OnEvent(this, event, arg1, arg2, arg3, arg4, arg5, arg6)

--[[
    IV_Log("IVFrame_OnEvent Event: "..event);
    if ( arg1 ) then IV_Log("arg1: " .. tostring(arg1)); end
    if ( arg2 ) then IV_Log("arg2: " .. tostring(arg2)); end
    if ( arg3 ) then IV_Log("arg3: " .. tostring(arg3)); end
    if ( arg4 ) then IV_Log("arg4: " .. tostring(arg4)); end
    if ( arg5 ) then IV_Log("arg5: " .. tostring(arg5)); end
    if ( arg6 ) then IV_Log("arg6: " .. tostring(arg6)); end
--]]

    -- Event: VARIABLES_LOADED
    -- we load our .INI file here
    if ( event == "VARIABLES_LOADED" ) then

        -- If the user does a /script ReloadUI() only this event will be called.
        if ( IV_IsInitialized() ~= true ) then
            IV_Initialize();
        end

        return;
    end

    -- Event: SAVE_VARIABLES
    -- Logout or ReloadUI() happened, unhook our function hooks
    if ( event == "SAVE_VARIABLES" ) then

        --IV_Log( "Unhook funcitons here...." );
        IV_RemoveFunctionHooks();

        return;
    end


    -- Event: UNIT_PORTRAIT_UPDATE
    -- We Get the player name here and save off initial Backpack info
    if ( event == "UNIT_PORTRAIT_UPDATE" and arg1 == "player" ) then

        if ( IV_IsInitialized() ~= true ) then
            IV_Initialize();
        end

        return;
    end


    -- Event: BANK_OPEN : is called when a player opens the bank user interface
    -- Event: BANK_CLOSE : is (useless since we're hooking the CloseBank() call) called when a user zones (maybe when logging out as well), not when the user hides the bank window
    -- Event: BANK_UPDATE : is called when a player rents more bank space (it may also be called when that rental excpires, not sure yet), we don't care about this since we catch open/close of bank
    -- so we piggyback on the PLAYER_BAG_CHANGED event and update the bank with it (as well as this)
    if ( event == "BANK_OPEN" ) then

        -- Set a flag stating future changes might be from the Bank since it's opening
        g_IVStatus.BankItemsMayHaveChanged = true;

        -- Performance improvement: 
        -- Dont spend time doing this now if the Inventory Viewer UI isn't open, it can be done during OnShow instead.
        if ( IVFrame:IsVisible() and IV_IsSelectedTabCurrentPlayer() ) then
            IV_PopulateBankInventory( g_CurrentPlayerName );
        else
            --IV_Log( "BANK_OPEN: Not Populating Bank Inventory." );
        end

        return;
    end


    -- Event: PLAYER_BAG_CHANGED
    -- When you move an item around in your Backpack (or Item Shop Backpack or Arcane Transmutor) you get one of these.  Taking a potion also causes 2 hits on this (might be because I have 2 pages with pots using same cooldown)
    if ( event == "PLAYER_BAG_CHANGED" ) then

        -- Performance improvement: 
        -- Bail out if the player is in combat.   Set a flag to save the table once out of combat
        if ( GetPlayerCombatState() ) then

            g_IVStatus.BackpackChangedWhileInCombat = true;

            -- bail out early
            return;
        end

        -- Player is not in combat, save the Backpack items to the table
        IVFrame_SetTable_Backpack();

        -- Performance improvement: 
        -- Only If the bank items may have changed, Save it to the table
        if ( g_IVStatus.BankItemsMayHaveChanged ) then
            IVFrame_SetTable_Bank();
        end

        -- Performance improvement: 
        -- Only If the Itemshop bag items may have changed, Save it to the table
        if ( g_IVStatus.ItemShopBackpackItemsMayHaveChanged ) then
            IVFrame_SetTable_ItemShopBag();
        end

        -- Note: these can change outside of the AT User Interface via an addon that does
        -- this: PickupBagItem(51); PickupBagItem(56); -- swap AT slot 1 with hidden slot 6
        IVFrame_SetTable_ArcaneTransmutor();

        -- Performance improvement: 
        -- Dont spend time populating the IV UI if it isn't visible, it can be done during OnShow instead.
        if ( IVFrame:IsVisible() and IV_IsSelectedTabCurrentPlayer() ) then
            IV_PopulateBankInventory( g_CurrentPlayerName );
            IV_PopulateArcaneTransmutorInventory( g_CurrentPlayerName );
            IV_PopulateBackpackOrItemShopInventory( g_CurrentPlayerName );
            IV_PopulateFurnitureOrEquippedInventory( g_CurrentPlayerName );
        end

        return;
    end

	-- Event: HOUSES_SERVANT_INFO_SHOW -- User opened the House Servant UI and chose "check Housekeeper's Attributes" (which has a 2nd tab containing storage slots)
    if ( event == "HOUSES_SERVANT_INFO_SHOW" ) then
	
		--IV_Log( "HOUSES_SERVANT_INFO_SHOW begin" );
		local DBID = Houses_GetServantInfo( arg1 );
	
		-- Remember last opened House Servant DBID
		g_IVStatus.nLastOpenedHouseServant = arg1;
		g_IVStatus.nLastOpenedHouseServantDBID = DBID;
		
		--IV_Log( "IV: HOUSES_SERVANT_INFO_SHOW arg1:" .. arg1 .. " DBID:" .. DBID );
		--IV_Log( "HOUSES_SERVANT_INFO_SHOW end" );
	end
	
	
	-- Event: HOUSES_SERVANT_ITEM_CHANGED	-- User added/removed an item from a House Servant
    if ( event == "HOUSES_SERVANT_ITEM_CHANGED" ) then

		--IV_Log( "HOUSES_SERVANT_ITEM_CHANGED begin" );
		
		-- Get House number
        local _, nHouseID, _, _, _, _, _, bIsOwner = Houses_GetHouseInfo();

        -- Save off this characters house number
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].HouseID = nHouseID;
		
        local PlayerName = g_CurrentPlayerName;
        local AccountName = g_AccountName;
		local curHouseServant = g_IVStatus.nLastOpenedHouseServant;
		local DBID, HouseServantName = Houses_GetServantInfo( curHouseServant );
		local nMaxItems = 25; -- really only 19 items, but we use up to slot 25 in the IV UI
		local IsHanger = false;
		local IsHouseMaid = true;
		
		-- Save the House Servant items in the furniture area of IV
        IVFrame_SetTable_HouseFurniture( DBID, HouseServantName, nMaxItems, IsHanger, AccountName, PlayerName, IsHouseMaid );

		local selected = IV_GetSelectedFurniture( AccountName, PlayerName );
		
        -- Update the UI only if the currently selected character tab is this PlayerName and the Furniture tab is selected, and is set to the Furniture this user just opened/updated
        if ( g_ViewAccountName == AccountName and g_IVSelectedCharTabName == PlayerName and selected and selected == DBID and 3 == IVFrameHouseFurnitureBackdropFrame.PageIndex ) then
            IV_PopulateHouseFurnitureInventory( PlayerName );
        end

		--IV_Log( "HOUSES_SERVANT_ITEM_CHANGED end" );
        return;
	end

    -- Event: HOUSES_STORAGE_SHOW
    -- Event: HOUSES_STORAGE_CHANGED
    -- User opened House Furniture or moved items in the furniture
    -- Event: HOUSES_HANGER_SHOW
    -- Event: HOUSES_HANGER_CHANGED
    -- User opened the House Hanger or change clothes on hanger
    if ( event == "HOUSES_STORAGE_SHOW" or 
        event == "HOUSES_STORAGE_CHANGED" or
        event == "HOUSES_HANGER_SHOW" or 
        event == "HOUSES_HANGER_CHANGED" ) then

        -- If the player is not in his own house, ignore this event
        local _, nHouseID, _, _, _, _, _, bIsOwner = Houses_GetHouseInfo();

        local PlayerName,AccountName;

        if ( bIsOwner ) then
            -- Save off this characters house number
            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].HouseID = nHouseID;
            PlayerName = g_CurrentPlayerName;
            AccountName = g_AccountName;
        else
            -- It's not this character's house so check to see if it's one of our Alt's houses on this account
            -- NOTE: having a per realm table would speed this up a bit
            for Account,AccountTable in pairs(g_InventoryViewerTable) do
                if ( AccountTable[g_Realm] ) then
                    for Player,PlayerTable in pairs(AccountTable[g_Realm]) do
                        if ( PlayerTable.HouseID and PlayerTable.HouseID == nHouseID ) then
                            PlayerName = Player;
                            AccountName = Account;
                            break;
                        end
                    end
                end
            end
        end

        -- Is this house owned by a character on this account?
        if ( not PlayerName ) then
            --IV_Log( "IV: This house isn't owned by any characters on this account, not saving items from this furniture." );
            return; 
        end 


        local DBID = Houses_GetFocusFurnishingID();

        if ( event == "HOUSES_STORAGE_SHOW" or event == "HOUSES_HANGER_SHOW" ) then

            -- Remember last opened furniture/hanger
            g_IVStatus.nLastOpenedFurnitureDBID = DBID;

        elseif ( event == "HOUSES_STORAGE_CHANGED" or event == "HOUSES_HANGER_CHANGED" ) then

            -- Calling Houses_GetFocusFurnishingID() during the HOUSES_STORAGE_CHANGED event
            -- returns a different value as the DBID sometimes (when you right-click the item in the Furniture). 
            -- This value will instead be the Slot in your furniture List instead of the real DBID of your furniture.
            -- If this is the case,  it will cause a crash when passed into Houses_GetItemInfo() .  So we must use
            -- the ID of the last opened furniture instead. (This was believed to be broken in build 2.1.5.1997 of RoM).

            if ( g_IVStatus.nLastOpenedFurnitureDBID ) then
                DBID = g_IVStatus.nLastOpenedFurnitureDBID;
            else
                return;
            end
        end

        local nMaxItems, HouseItemName = Houses_GetItemInfo( DBID, -1 );
        
        --IV_Log( "DBID: " .. DBID .. " Name: " .. HouseItemName .. " Slots:" .. nMaxItems .. " Event: " .. event );

        local IsHanger;
        if ( event == "HOUSES_HANGER_SHOW" or event == "HOUSES_HANGER_CHANGED" ) then
            IsHanger = true;
        end

		local IsHouseMaid = false;
        IVFrame_SetTable_HouseFurniture( DBID, HouseItemName, nMaxItems, IsHanger, AccountName, PlayerName, IsHouseMaid );

        local selected = IV_GetSelectedFurniture( AccountName, PlayerName );

        -- Update the UI only if the currently selected character tab is this PlayerName and the Furniture tab is selected, and is set to the Furniture this user just opened/updated
        if ( g_ViewAccountName == AccountName and g_IVSelectedCharTabName == PlayerName and selected and selected == DBID and 3 == IVFrameHouseFurnitureBackdropFrame.PageIndex ) then
            IV_PopulateHouseFurnitureInventory( PlayerName );
        end

        return;
    end


    -- Used to detect end of combat
    if ( event == "CHAT_MSG_SYSTEM_VALUE" ) then

        -- This event may get called  2 to 10 times after combat finishes, but we only want to act on it once
        if ( g_IVStatus.BackpackChangedWhileInCombat == true ) then

            --IV_Log( "No longer in combat, saving Backpack to database." );

            -- Save backpack to the table now that we're not in combat
            IVFrame_SetTable_Backpack();

            -- Performance improvement: 
            -- Only If the Itemshop bag items may have changed, Save it to the table
            if ( g_IVStatus.ItemShopBackpackItemsMayHaveChanged ) then
                IVFrame_SetTable_ItemShopBag();
            end

            -- Performance improvement: 
            -- Dont spend time populating the IV UI if it isn't visible, it can be done during OnShow instead.
            if ( IVFrame:IsVisible() and IV_IsSelectedTabCurrentPlayer() ) then
                IV_PopulateBankInventory( g_CurrentPlayerName );
                IV_PopulateArcaneTransmutorInventory( g_CurrentPlayerName );
                IV_PopulateBackpackOrItemShopInventory( g_CurrentPlayerName );
                IV_PopulateFurnitureOrEquippedInventory( g_CurrentPlayerName );
            end

            -- Clear the flag as we've handled the backpack change that happened during combat
            g_IVStatus.BackpackChangedWhileInCombat = false;
        end

        return;
    end


    -- Called whenever the players money (gold, diamonds/rubies/Phirius Tokens?) changes
    if ( event == "PLAYER_MONEY" or event == "PLAYER_BOXENERGY_CHANGED" ) then

        -- Save Money info (Gold/Rubies/Diamonds/Arcane Transmutor Charges/Phirius Tokens) to the database
        IVFrame_SetTable_Money();

        -- Populate the Money info if the IVFrame is visible, otherwise it can happen during OnShow()
        if ( IVFrame:IsVisible() ) then
            IV_PopulateMoney();
        end

        return;
    end


    -- Called whenever the player loads a new zone, will be used to nag the user to delete any extra characters if they have too many in IV for a single account
    if ( event == "ZONE_CHANGED" and g_IVStatus.bTooManyCharacters ) then

        IV_Log( IV_WARNING_TOO_MANY_CHARS, 1,0,0 );
        StaticPopupDialogs["IV_WARNING_TOO_MANY_CHARS"].text = IV_WARNING_TOO_MANY_CHARS;
        StaticPopup_Show("IV_WARNING_TOO_MANY_CHARS");

        return;
    end
    
    -- Called whenever the player levels or swaps classes, will be used to save Class/Level info
    if ( event == "PLAYER_LEVEL_UP" or event == "EXCHANGECLASS_SUCCESS" ) then
    
        -- Update database with new level for this class
        IVFrame_SetTable_ClassAndLevel()
    end
    
end


function IV_IsSelectedTabCurrentPlayer()

    -- If this Character is the currently logged in Character, set the default selected tab to this characters tab
    if ( g_ViewAccountName == g_AccountName    and g_IVSelectedCharTabName == g_CurrentPlayerName ) then

        return true;
    end

    return false;
end


function IVFrame_SelectCharTab( id )

    --IV_Log( "IVFrame_SelectCharTab: " .. id )

    -- Set the chosen tab to a selected state and unselect all other tabs
    local tabObj;

    for i = 1, IV_MAX_CHARS_PER_REALM do

        tabObj = getglobal( "IVFrameCharTab" .. i );
        local CurChar = tabObj:GetText();

        if ( i == id ) then
            UIPanelTab_SetActiveState( tabObj, true );
            g_IVSelectedCharTabName = CurChar;
            g_IVSelectedCharTabID = i;
            --IV_Log( "set g_IVSelectedCharTabName to " .. g_IVSelectedCharTabName );
        else
            UIPanelTab_SetActiveState( tabObj, false );
        end
    end

    --IV_Log( "Populating " .. g_IVSelectedCharTabName .. "'s inventory..." );

    -- Set Bank Tab to page 1 and populate the UI
    IVFrameBankBackdropFrame.PageIndex = 1;
    IV_BankFrameTab_SetTabID( 1 );


    -- Set Backpack Tab to page 1 or last selected page
    if ( not IVFrameBackpackBackdropFrame.PageIndex ) then
        IVFrameBackpackBackdropFrame.PageIndex = 1;
    end

    -- This will populate the UI with the Backpack or ItemShop Backpack,
    -- depending on which Backpack tab (IVFrameBackpackBackdropFrame.PageIndex) was selected
    IV_BackpackFrameTab_SetTabID( IVFrameBackpackBackdropFrame.PageIndex );


    -- Set Equipment/Furniture Tab to page 3 or last selected page
    if ( not IVFrameHouseFurnitureBackdropFrame.PageIndex ) then
        IVFrameHouseFurnitureBackdropFrame.PageIndex = 3;
    end

    -- This will populate the UI with the Equipped_1, Equipped_2, or House Furniture,
    -- depending on which tab (IVFrameHouseFurnitureBackdropFrame.PageIndex) was selected
    IV_EquippedOrFurnitureFrameTab_SetTabID( IVFrameHouseFurnitureBackdropFrame.PageIndex );


    -- Populate the rest of the UI with items of the selected characters tab
    IV_PopulateArcaneTransmutorInventory( g_IVSelectedCharTabName );
    IV_PopulateMoney();
end


function IVFrameCharTab_OnClick( this, button )

    --IV_Log( "IVFrameCharTab_OnClick: " .. button )

    -- If there's a pop-up menu open already, close it
    if( IV_CharTabDropDown:IsVisible() )then
        ToggleDropDownMenu(IV_CharTabDropDown);
        IV_CharTabDropDown:Hide();
    end

    -- switch to the selected tab
    IVFrame_SelectCharTab( this:GetID() );

    if ( button == "RBUTTON" ) then
        UIDropDownMenu_SetAnchor(IV_CharTabDropDown, 0, 0, "BOTTOMLEFT", "TOPLEFT", this:GetName());
        ToggleDropDownMenu(IV_CharTabDropDown);
        IV_CharTabDropDown:Show();
    end
end


function IVFrameCharTab_OnEnter( this )

    --IV_Log( "IVFrameCharTab_OnEnter" );
    
    -- Update the tooltip if it's visible
    if ( not GameTooltip:IsVisible() ) then

        GameTooltip:SetOwner(this, "ANCHOR_TOP", 0, 0);
        GameTooltip:ClearAllAnchors();
        GameTooltip:SetAnchor("BOTTOM", "TOP", this, 0, 0);
        GameTooltip:ClearLines();

        -- Get the name on this tab and look up his class info
        local tabObj = getglobal( "IVFrameCharTab" .. this:GetID() );
        local CurChar = tabObj:GetText();
        
        if ( g_InventoryViewerTable[g_ViewAccountName][g_Realm][CurChar] and
             g_InventoryViewerTable[g_ViewAccountName][g_Realm][CurChar]["ClassInfo"] and
             g_InventoryViewerTable[g_ViewAccountName][g_Realm][CurChar]["ClassInfo"].Text ) then
        
            local text = g_InventoryViewerTable[g_ViewAccountName][g_Realm][CurChar]["ClassInfo"].Text;
        
            if ( text ) then
                GameTooltip:SetText( text );
            end
        end
    end
end


function IVFrameCharTab_OnLeave( this )

    GameTooltip:Hide();
end


function IVFrameCharTab_OnLoad( this )

    --IV_Log( "IVFrameCharTab_OnLoad" );
    PanelTemplates_TabResize( this, 9.5/GetUIScale() );
    this:RegisterForClicks("LeftButton", "RightButton");
end


function GetNameFromitemLink( itemLink )

	--IV_Log( "GetNameFromitemLink start" );

    -- If no itemLink, return Red color
    if ( itemLink == nil ) then
		--IV_Log( "GetNameFromitemLink return empty string" );
        return "";
    end

	local startPos = string.find( itemLink, "%[");
	local endPos   = string.find( itemLink, "%]");
	
	--IV_Log( "string.sub( " .. itemLink .. ", " .. tostring(startPos+1) .. ", " .. tostring(endPos-1) .. ")" ); 
	--IV_Log( "GetNameFromitemLink return string.sub(itemLink, startPos+1, endPos-1);" );
	--IV_Log( "GetNameFromitemLink return " .. string.sub(itemLink, startPos+1, endPos-1) );

	return string.sub(itemLink, startPos+1, endPos-1);
end


function DecimalRGBFromitemLink( itemLink )

    -- If no itemLink, return Red color
    if ( itemLink == nil ) then
        return 1,0,0;
    end

    -- Default to white
    local HexR = "FF";
    local HexG = "FF";
    local HexB = "FF";

    -- Get the HEX RGB values in one shot
    local HexRGB = string.upper( string.gsub( itemLink, ".*|c%x%x(%x+).*","%1" ) );
    --IV_Log( "HexRGB: " .. HexRGB );

    -- If it's not white (FFFFFF), get and convert each R,G,B value separately
    if ( HexRGB ~= "FFFFFF" ) then
        HexR = string.upper( string.gsub( itemLink, ".*|c%x%x(%x%x).*","%1" ) );
        HexG = string.upper( string.gsub( itemLink, ".*|c%x%x%x%x(%x%x).*","%1" ) );
        HexB = string.upper( string.gsub( itemLink, ".*|c%x%x%x%x%x%x(%x%x).*","%1" ) );
    end

    -- Convert each R,G,B value to decimal then divide by 255 for the SetColor() API
    DecR = tonumber(HexR, 16)/255;
    DecG = tonumber(HexG, 16)/255;
    DecB = tonumber(HexB, 16)/255;

    return DecR, DecG, DecB;
end


function IVFrame_MoniesTooltip(this)

    GameTooltip:SetOwner(this, "ANCHOR_RIGHT", 4, 0);
    GameTooltip:SetTitle( 1 );
    GameTooltip:SetText( "Details:", 1, 1, 1);

    local Left = "";
    local Right = "";
    
    for index,tbl in pairs(g_MoniesTooltipText) do
    
        Left = Left .. "\n" .. tbl.Left;
        Right = Right .. "\n" .. tbl.Right;
    end

    GameTooltip:AddDoubleLine(Left, Right, 1, 1, 1, 1, 1, 1);
    GameTooltip:Show();                        
end


function IV_SetSelectedFurniture( AccountName, PlayerName, DBID )

    --IV_Log( "IV_SetSelectedFurniture DBID: " .. tostring(DBID) );

    if ( g_InventoryViewerTable[AccountName][g_Realm][PlayerName] ) then
        g_InventoryViewerTable[AccountName][g_Realm][PlayerName].SelectedFurnitureDBID = DBID;
    else
        IV_Log( "IV_SetSelectedFurniture Error: g_InventoryViewerTable[AccountName][g_Realm][PlayerName] doesn't exist!", 1,0,0 );
        IV_Log( "IV_SetSelectedFurniture Error: g_InventoryViewerTable[" ..AccountName.. "][" ..g_Realm.. "][" ..PlayerName.. "] doesn't exist!", 1,0,0 );
    end    
end


function IV_GetPrevNextFurniture( PlayerName, CurDBID )

    --IV_Log("begin IV_GetPrevNextFurniture for " .. PlayerName );

    -- Returns the previous and next piece of furniture this character has

    local PrevDBID = nil;
    local NextDBID = nil;
    local bFindPrev = true;

    if ( g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture ) then

        for DBID, FurnitureTable in pairs( g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture ) do

            if ( DBID ) then

                -- Previous Furniture
                if ( bFindPrev and DBID ~= CurDBID ) then
                    PrevDBID = DBID;
                    --IV_Log("IV_GetPrevNextFurniture: PrevDBID = " ..DBID);
                end

                -- Current Furniture
                if ( DBID == CurDBID ) then
                    bFindPrev = false;
                    --IV_Log("IV_GetPrevNextFurniture: CurDBID = " ..DBID);
                end

                -- Next Furniture
                if ( not bFindPrev and DBID ~= CurDBID ) then
                    NextDBID = DBID;
                    --IV_Log("IV_GetPrevNextFurniture: NextDBID = " ..DBID);

                    -- we're done here
                    break;
                end
            end
        end

        -- If we're missing a PrevDBID, then set it to the last piece of furniture (wrap around)
        if( not PrevDBID ) then

            -- Loop to the end, overwriting PrevDBID so last one wins.
            for DBID, FurnitureTable in pairs( g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture ) do
                PrevDBID = DBID;
            end

            --IV_Log( "PrevDBID wrapped to " .. PrevDBID );
        end

        -- If we're missing a NextDBID, then set it to the last piece of furniture (wrap around)
        if( not NextDBID ) then

            -- Get first one and break so first one wins.
            for DBID, FurnitureTable in pairs( g_InventoryViewerTable[g_ViewAccountName][g_Realm][PlayerName].Furniture ) do
                NextDBID = DBID;
                --IV_Log( "NextDBID wrapped to " .. NextDBID );
                break;
            end
        end

    else
        --IV_Log("IV_GetPrevNextFurniture: " .. PlayerName .. " doesn't have any furniture.");
    end

    --IV_Log("end IV_GetPrevNextFurniture");

    return PrevDBID, NextDBID;
end


function IV_GetSelectedFurniture( AccountName, PlayerName )

    --IV_Log( "start IV_GetSelectedFurniture" );

    --  If we don't have any characters on this Account/Realm, we're done here
    if ( not g_InventoryViewerTable[AccountName][g_Realm] ) then
        return nil, nil;
    end

    if ( not g_InventoryViewerTable[AccountName][g_Realm][PlayerName] ) then
        return nil, nil;
    end

    local selected = nil;
    local FurnitureName = nil;

    -- See if this character had a piece of furniture previously selected, if so, populate that info
    if ( g_InventoryViewerTable[AccountName][g_Realm][PlayerName].SelectedFurnitureDBID ) then

        selected = g_InventoryViewerTable[AccountName][g_Realm][PlayerName].SelectedFurnitureDBID;

    -- else select the first piece of furniture we find in the table and populate the UI with that info
    elseif ( g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture ) then

        for DBID, FurnitureTable in pairs( g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture ) do

            if ( DBID ) then
                selected = DBID;
                IV_SetSelectedFurniture( AccountName, PlayerName, selected );

                --IV_Log( "IV_GetSelectedFurniture: No selected DBID, using first one found: " .. selected );
                break;
            end
        end
    else
        --IV_Log( "IV_GetSelectedFurniture: No SelectedFurnitureDBID, or .Furniture for " .. AccountName.."/"..g_Realm.."/"..PlayerName );
    end

    if ( selected and
        g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture and
        g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture[selected] and
        g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture[selected].Name ) then

        FurnitureName = g_InventoryViewerTable[AccountName][g_Realm][PlayerName].Furniture[selected].Name;
        --IV_Log( "IV_GetSelectedFurniture: " .. PlayerName .. " has Furniture " .. FurnitureName.. "(" .. selected .. ") selected." );

        IVFrameBackdropHouseFurniture:SetText( FurnitureName .. " :" );
    else
        --IV_Log( "IV_GetSelectedFurniture: " .. PlayerName .. " has no furniture.  Can't get/set selected furniture." );
        local HouseFurnitureText = getglobal("IVFrameBackdropHouseFurniture");
        if ( HouseFurnitureText ) then
            HouseFurnitureText:SetText( BACKPACK_EQUIP .. " / " .. UI_HOUSEFRAME_PLACEFURNISH .. " :" );
        end
    end

    --IV_Log( "end IV_GetSelectedFurniture" );

    return selected, FurnitureName;
end




----------------------------------------------------------------------------------------------------------------------
--
--    InventoryViewerDropDown Menu
--
----------------------------------------------------------------------------------------------------------------------
function IV_CharTabDropDown_OnClick( button )

    --IV_Log( "IV_CharTabDropDown_OnClick: " .. button.value );

    -- Delete the specified character entry from our database
    if(  button.value == "DELETE" ) then

        -- You can't delete the currently logged in player
        if ( IV_IsSelectedTabCurrentPlayer() == true ) then
            IV_Log( "You can not remove yourself from the Inventory Viewer." );
            return;
        end

        -- Get the DisplayOrder number before wiping him out
        local DeletedOrderNum = g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName].DisplayOrder;
        --IV_Log("Deleted OrderNum: " .. DeletedOrderNum );

        -- Remove the specified character from our database
        IV_Log( "Deleting " .. g_IVSelectedCharTabName .. " from Inventory Viewer database..." );
        g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_IVSelectedCharTabName] = nil;
        g_IVStatus.bTooManyCharacters = false;

        -- Shift left all characters after this one in the order list and change the DisplayOrder for each character 
        -- that has one above this guy
        for i=DeletedOrderNum, IV_MAX_CHARS_PER_REALM do
            g_CharTabOrder[i] = g_CharTabOrder[i+1] or nil;
            g_CharTabOrder[i+1] = nil;

            if ( g_CharTabOrder[i] ) then
                if ( g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CharTabOrder[i]] ) then
                    g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CharTabOrder[i]].DisplayOrder = i;
                else
                    -- no more characters if we hit a nil
                    break;
                end
            else
                -- no more characters if we hit a nil
                break;
            end
        end

        -- Wipe out all the tabs so we can redo them
        for i=1, IV_MAX_CHARS_PER_REALM do
            local tab = getglobal("IVFrameCharTab"..i);
            tab:SetText("");
            tab:Hide();
        end

        -- Reset the tabs to match the updated database
        local MyTabId = IV_SetCharTabNames();

        -- If user deleted last character from another account, then delete that account
        if ( MyTabId == 0 ) then
            IVFrame_WipeAccount( g_ViewAccountName );
            return;
        end

        -- Select the currently logged in players Tab,  Will also Populate the UI
        IVFrame_SelectCharTab( MyTabId );
    end

    -- Hide the popup menu as we're done with it
    --IV_CharTabDropDown:Hide();
end


function IV_CharTabDropDown_Show(this)

    --IV_Log( "IV_CharTabDropDown_Show" );

    local info = {};
    info.text           = TEXT(C_DEL);
    info.notCheckable   = 1;
    info.value          = "DELETE";
    info.func           = IV_CharTabDropDown_OnClick;
    UIDropDownMenu_AddButton( info, 1 );

    info = {};
    info.text           = TEXT(C_CANCEL);
    info.notCheckable   = 1;
    info.value          = "CANCEL";
    info.func           = IV_CharTabDropDown_OnClick;
    UIDropDownMenu_AddButton(info);
end


function IV_CharTabDropDown_OnLoad(this)

    --IV_Log( "** IV_CharTabDropDown_OnLoad **" );
    UIDropDownMenu_Initialize(this, IV_CharTabDropDown_Show, "MENU");
end


-- Function Hook, called in relation to equipped items
function EquipItemButton_Update(button, unit)

    --IV_Log( "EquipItemButton_Update hook -- ID " .. button:GetID() .. ":" .. button:GetName() );

    -- call original
    IV_Orig_EquipItemButton_Update( button, unit );

    -- Temporarily save off this button in case we get a bag changed event right after this call
    -- which will mean a bag item was put into this EQ slot
    g_IVStatus.LastEquippedItemUpdateButton = {};
    g_IVStatus.LastEquippedItemUpdateButton = button;
end


-- Function Hook, called when user hits ESC key to close all windows
function CloseAllWindows()

    -- Close IV windows
    local isMainVisible = IVFrame:IsVisible();
    HideUIPanel(IVFrame);

    local isConfigVisible = IVConfigFrame:IsVisible();
    HideUIPanel(IVConfigFrame);

    -- Call the original
    return IV_Orig_CloseAllWindows() or isMainVisible or isConfigVisible;
end


-- Function Hook, Item Shop Backpack was opened
function GoodsFrame_OnShow(this)

    --IV_Log( "GoodsFrame_OnShow hook" );

    -- Set a flag stating future changes might be from the Item Shop Backpack since it's opening
    g_IVStatus.ItemShopBackpackItemsMayHaveChanged = true;

    -- call original function
    IV_Orig_GoodsFrame_OnShow(this);
end


-- Function Hook, there's no such thing as GoodsFrame_OnHide() so we need to hook HideUIPanel()
-- in order to detect the Item Shop Backpack window closing.
function HideUIPanel(frame)

    --IV_Log( "HideUIPanel hook" );

    if ( frame ) then

        local frameName = frame:GetName() or "";

        -- If this is the Item Shop Backpack frame (GoodsFrame) closing...
        if ( frameName == "GoodsFrame" ) then

            --IV_Log( "Item Shop Backpack was closed." );

            -- Set a flag stating future changes won't be from the Item Shop Backpack since it's closing
            g_IVStatus.ItemShopBackpackItemsMayHaveChanged = false;
        else
            --IV_Log( "HideUIPanel Hook:" .. frameName );
        end
    end

    -- call original 
    IV_Orig_HideUIPanel(frame);
end


-- Function Hook, Bank was closed
function CloseBank()

    --IV_Log( "CloseBank() hook" );

    -- Write bank items to database
    IVFrame_SetTable_Bank();

    -- Set a flag stating future changes won't be from the Bank since it's closing    
    g_IVStatus.BankItemsMayHaveChanged = false;

    -- Performance improvement: 
    -- Dont spend time doing this now if the Inventory Viewer UI isn't open, it can be done during OnShow instead.
    if ( IVFrame:IsVisible() and IV_IsSelectedTabCurrentPlayer() ) then
        IV_PopulateBankInventory( g_CurrentPlayerName );
    end

    -- Call the original function
    IV_Orig_CloseBank();
end


function IV_AppendTooltipData( tooltip, itemLinkOrName )

    --IV_Log( "IV_AppendTooltipData( " ..tooltip:GetName().. ", " .. itemLinkOrName .. " )" );

    if ( IVConfig_ToolTips:IsChecked() == false ) then
        return;
    end

    -- Get text we want to insert (via itemLink or exact Name)
    local text = IV_GetListOfItems3( itemLinkOrName );

    --IV_Log( "text:" .. text );

    if ( text and text ~= "" ) then

        -- Figure out the position to put the separator and set it
        local scale = GetUIScale();
        local Separator4 = getglobal( tooltip:GetName() .. "Separator4" );
        Separator4:ClearAllAnchors();
        Separator4:SetAnchor("TOP", "TOP", tooltip, 0, (tooltip:GetBottom()/scale)-(tooltip:GetTop()/scale)-(3.25/scale) );
        tooltip:AddLine("\n");

        -- Insert the text
        --IV_Log( "Appending tooltipText: " .. text );
        tooltip:AddLine( text );

        -- Set width of the separator after we've added text (which could change the size of the tooltip
        Separator4:SetWidth(tooltip:GetWidth()-20);
        Separator4:Show();
    end
end


-- Function Hook
function GameTooltipHyperLink:SetHyperLink( itemLink )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipHyperLinkSetHyperLink( self, itemLink );

    -- Append our stuff on the tooltip
    if ( not itemLink or itemLink == "" ) then
        return;
    end

    --IV_Log( "GameTooltipHyperLink:SetHyperLink( " .. itemLink .. " )" );

    IV_AppendTooltipData( self, itemLink );
end


-- Function Hook
function GameTooltip:SetHyperLink( itemLink )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetHyperLink( self, itemLink );

    -- Append our stuff on the tooltip
    if ( not itemLink or itemLink == "" ) then
        return;
    end

    --IV_Log( "GameTooltip:SetHyperLink( " .. itemLink .. " )" );

    IV_AppendTooltipData( self, itemLink );
end


-- Function Hook
function GameTooltip:SetBagItem( BagId )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetBagItem( self, BagId );

    -- Append our stuff on the tooltip
    local itemLink = GetBagItemLink( BagId );

    if ( not itemLink or itemLink == "" ) then
        return;
    end

    --IV_Log( "GameTooltip:SetBagItem( " .. BagId .. " )" );

    IV_AppendTooltipData( self, itemLink );
end


-- Function Hook
function GameTooltip:SetBankItem( BankId )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetBankItem( self, BankId );

    local itemLink = GetBankItemLink( BankId );

    -- Append our stuff on the tooltip
    if ( not itemLink or itemLink == "" ) then
        return;
    end

    --IV_Log( "GameTooltip:SetBankItem( " .. BankId .. " )" );

    IV_AppendTooltipData( self, itemLink );
end


-- Function Hook
function GameTooltip:SetAuctionBrowseItem( AuctionId )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetAuctionBrowseItem( self, AuctionId );

    -- Append our stuff on the tooltip
    local itemLink = GetAuctionBrowseItemLink( AuctionId );

    if ( not itemLink or itemLink == "" ) then
        return;
    end

    --IV_Log( "GameTooltip:SetAuctionBrowseItem( " .. AuctionId .. " )" );

    IV_AppendTooltipData( self, itemLink );
end


-- Function Hook
function GameTooltip:SetBootyItem( BootyId )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetBootyItem( self, BootyId );

    -- Append our stuff on the tooltip
    local itemLink = GetBootyItemLink( BootyId );

    if ( not itemLink or itemLink == "" ) then
        return;
    end

    --IV_Log( "GameTooltip:SetBootyItem( " .. BootyId .. " )" );

    IV_AppendTooltipData( self, itemLink );
end


-- Function Hook
function GameTooltip:SetHouseItem( ParentDBID, ButtonId )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetHouseItem( self, ParentDBID, ButtonId );

    -- Append our stuff on the tooltip
    if ( ParentDBID ) then
        local itemLink = Houses_GetItemLink( ParentDBID, ButtonId );

        if ( not itemLink or itemLink == "" ) then
            return;
        end

        IV_AppendTooltipData( self, itemLink );
    end
end


-- Function Hook
function GameTooltip:SetStoreItem( tab, ButtonId )

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetStoreItem( self, tab, ButtonId );

    -- Append our stuff on the tooltip
    local itemLink = "";

    --IV_Log( "GameTooltip:SetStoreItem( " .. tab .."/".. ButtonId .. " )" );

    if ( tab == "SELL" ) then
        itemLink = GetStoreSellItemLink( ButtonId );
    elseif ( tab == "BUYBACK" ) then
        itemLink = GetStoreBuyBackItemLink( ButtonId );
    end

    if ( not itemLink or itemLink == "" ) then
        return;
    end

    IV_AppendTooltipData( self, itemLink );
end

-- Function Hook
function GameTooltip:SetCraftRequestItem(ObjID, Index)

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetCraftRequestItem( self, ObjID, Index );

	local _, itemName, itemTexture, itemCount, itemTotalCount, resourceCount, resourceNeed = GetCraftRequestItem( ObjID, Index );
	
	--IV_Log( "GameTooltip:SetCraftRequestItem_Hook( " .. tostring(itemName) .."/".. tostring(itemCount) .. " )" );

    if ( not itemName or itemName == "" ) then
        return;
    end

    -- Append our stuff on the tooltip (by Name instead of itemLink)
    IV_AppendTooltipData( self, itemName );
end

-- Function Hook
function GameTooltip:SetCraftItem(ObjID, Index)

    -- Call original first, then add our stuff
    IV_Orig_GameTooltipSetCraftItem( self, ObjID, Index );

    -- Append our stuff on the tooltip
    if ( ObjID ) then
        local itemLink = GetCraftItemLink( ObjID, Index );

        if ( not itemLink or itemLink == "" ) then
            return;
        end

        IV_AppendTooltipData( self, itemLink );
    end
end


function IVFrameCharTab_OnDragStart(this)

    --IV_Log( "IVFrameCharTab_OnDragStart" );

    -- Make sure SHIFT key is down for switching the order of the tabs
    if ( not IsShiftKeyDown() ) then
        --IV_Log( "Press SHIFT when dragging the Inventory Viewer Tabs around." );
        return;
    end

    -- Save Src ID
    g_MoveSrcCharId = this:GetID();

    -- Start the dragging
    local DragTab = getglobal("IVFrameCharTabDrag");
    DragTab:SetText( getglobal(this:GetName()):GetText() );
    PanelTemplates_TabResize( DragTab, 9.5/GetUIScale() );
    UIPanelTab_SetActiveState( DragTab, true );
    DragTab:ClearAllAnchors();
    DragTab:SetAnchor( "CENTER", "CENTER", this , 0, 0 );
    DragTab:Show();
    DragTab:StartMoving();
end


function IVFrameCharTab_Insert( InsertPos )

    -- Bail out if the src id is not 1 to 8
    if ( not ( g_MoveSrcCharId > 0 and g_MoveSrcCharId < 9  and  InsertPos > 0 and InsertPos < 9 ) ) then
        --IV_Log("bad src id or insert position" );
        return false;
    end

    local SrcCharName = g_CharTabOrder[g_MoveSrcCharId];

    -- Src tab is to the right of Dst tab (insert before)
    if ( InsertPos < g_MoveSrcCharId ) then

        -- only shift the values within the range that is affected
        for i=g_MoveSrcCharId, InsertPos+1, -1 do
            --IV_Log( "moving (high to low)" .. i-1 .. " to " .. i );
            g_CharTabOrder[i] = g_CharTabOrder[i-1];
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CharTabOrder[i]].DisplayOrder = i;
        end

    -- Src tab is to the left of Dst tab (insert after)
    else
        -- only shift the values within the range that is affected
        for i=g_MoveSrcCharId, InsertPos-1 do
            --IV_Log( "moving (low to high) " .. i+1 .. " to " ..i );
            g_CharTabOrder[i] = g_CharTabOrder[i+1];
            g_InventoryViewerTable[g_ViewAccountName][g_Realm][g_CharTabOrder[i]].DisplayOrder = i;
        end
    end

    -- now that we've shifted everything over, insert the src to the dst
    --IV_Log( "pasting " ..SrcCharName.. " at " ..InsertPos );
    g_CharTabOrder[InsertPos] = SrcCharName;
    g_InventoryViewerTable[g_ViewAccountName][g_Realm][SrcCharName].DisplayOrder = InsertPos;

    -- we no longer need to know what that src tab was
    g_MoveSrcCharId = 0;

    return true;
end


function IVFrameCharTab_AbortDrag(this)

    -- Hide our Drag tab (stop dragging)
    local DragTab = getglobal("IVFrameCharTabDrag")
    DragTab:StopMovingOrSizing();
    DragTab:Hide();

    -- we no longer need to know what that src tab was
    g_MoveSrcCharId = 0;
end


function IVFrameCharTab_OnReceiveDrag(this)

    --IV_Log( "IVFrameCharTab_OnReceiveDrag" );

    local DstId = this:GetID();
    --IV_Log( "this:GetID: " .. DstId );

    -- Hide our Drag tab
    local DragTab = getglobal("IVFrameCharTabDrag")
    DragTab:StopMovingOrSizing();
    DragTab:Hide();

    -- Insert the selected tab to the destination position
    if ( not IVFrameCharTab_Insert( DstId ) ) then
        -- something failed, bail out
        --IV_Log( "something failed, bailing." );
        return;
    end

    -- Update our tabs with the character names in their new locations
    IV_SetCharTabNames();

    -- Select the Tab of the src character
    IVFrame_SelectCharTab( DstId );

    -- Populate the UI with the src characters items
    local SrcCharName = g_CharTabOrder[DstId];
    IV_PopulateBankInventory( SrcCharName );
    IV_PopulateBackpackOrItemShopInventory( SrcCharName );
    IV_PopulateFurnitureOrEquippedInventory( SrcCharName );
    IV_PopulateArcaneTransmutorInventory( SrcCharName );
    IV_PopulateMoney();

    --IV_Log( "Drag completE" );
end


function IV_MinimapButton_OnClick(this)

    if ( IVFrame:IsVisible() ) then
        HideUIPanel(IVFrame);
    else
        ShowUIPanel(IVFrame);
    end
end


function IV_MinimapButton_OnEnter(this)
    -- this overides default handler which shows pop-up text
end


function IV_MinimapButton_OnLeave(this)

end


function IV_BankFrameTab_SetTabID( id )

    --IV_Log( "IV_BankFrameTab_SetTabID: " .. id );

    local tabObj;
    for i = 1, 5, 1 do
        tabObj = getglobal( "IVFrameBankTab" .. i );
        if( i == id )then
            UIPanelTab_SetActiveState( tabObj, true );
        else
            UIPanelTab_SetActiveState( tabObj, false );
        end
    end

    -- Update the UI
    IV_PopulateBankInventory( g_IVSelectedCharTabName );
end


function IV_BankFrameTab_OnClick( this )

    IVFrameBankBackdropFrame.PageIndex = this:GetID();
    IV_BankFrameTab_SetTabID( this:GetID() );
end


function IV_BackpackFrameTab_SetTabID( id )

    --IV_Log( "IV_BackpackFrameTab_SetTabID: " .. id );

    -- Tab 1 is page 1/2, Tab 2 is page 3/4, Tab 3 is page 5/6, Tab 4 is the ItemShop backpack
    local tabObj;
    for i = 1, 4, 1 do
        tabObj = getglobal( "IVFrameBackpackTab" .. i );
        if( i == id )then
            UIPanelTab_SetActiveState( tabObj, true );
        else
            UIPanelTab_SetActiveState( tabObj, false );
        end
    end

    -- Update the UI
    IV_PopulateBackpackOrItemShopInventory( g_IVSelectedCharTabName );
end


function IV_BackpackFrameTab_OnClick( this )

    IVFrameBackpackBackdropFrame.PageIndex = this:GetID();
    IV_BackpackFrameTab_SetTabID( this:GetID() );
end


function IV_BackpackFrameTab_OnLoad( this )

    --IV_Log( "IV_BackpackFrameTab_OnLoad" );

    -- If it's Tab4 (item Shop) that shows text
    if ( this:GetID() == 4 ) then

        -- Set localized text for the Item Shop tab (must override default because French version is too long)
        this:SetText( IV_ACCOUNT_SHOP );
        PanelTemplates_TabResize( this, 9.5/GetUIScale() );

    else -- Regular Backpack tabs that show a graphic symbol

        getglobal( this:GetName() .. "Texture" ):SetFile( "Interface/AddOns/InventoryViewer/Textures/IVBackPackPage" .. this:GetID() .. ".tga" );
        PanelTemplates_TabResize( this, 32 );
    end

    this:RegisterForClicks("LeftButton", "RightButton");
end


function IV_EquippedOrFurnitureFrameTab_SetTabID( id )

    local tabObj;
    for i = 1, 3, 1 do
        tabObj = getglobal( "IVFrameFurnitureAndEquipmentTab" .. i );
        if( i == id )then
            UIPanelTab_SetActiveState( tabObj, true );
        else
            UIPanelTab_SetActiveState( tabObj, false );
        end
    end

    -- Update the UI (tabs 1 & 2 are Equipped items, tab3 is house furniture)
    IV_PopulateFurnitureOrEquippedInventory( g_IVSelectedCharTabName );
end


function IV_FurnitureAndEquipmentFrameTab_OnClick( this )

    --IV_Log( "IV_FurnitureAndEquipmentFrameTab_OnClick" );
    IVFrameHouseFurnitureBackdropFrame.PageIndex = this:GetID();
    IV_EquippedOrFurnitureFrameTab_SetTabID( this:GetID() );
end


function IV_FurnitureAndEquipmentFrameTab_OnLoad( this )

    --IV_Log( "IV_FurnitureAndEquipmentFrameTab_OnLoad" );

    local ID = this:GetID();
    local Texture=getglobal( this:GetName().."Texture");

    if ( ID == 1 ) then

        -- Equipment 1 tab
        Texture:SetFile( "Interface/AddOns/InventoryViewer/Textures/IV_Equipped" .. this:GetID() .. ".tga" );
        PanelTemplates_TabResize( this, 16 );

    elseif ( ID == 2 ) then

        -- Equipment 2 tabs
        Texture:SetFile( "Interface/AddOns/InventoryViewer/Textures/IV_Equipped" .. this:GetID() .. ".tga" );
        PanelTemplates_TabResize( this, 24 );
        Texture:SetSize( 32, 32);

    elseif ( ID == 3 ) then

        -- Furniture tab
        PanelTemplates_TabResize( this, 40/GetUIScale() );
    end

    this:RegisterForClicks("LeftButton", "RightButton");
end


function IVFrame_HouseFurnitureLeftArrow_OnClick(this)

    --IV_Log( "IVFrame_HouseFurnitureLeftArrow_OnClick" );

    -- Switch to the Furniture tab if it's not set already
    if ( 3 ~= IVFrameHouseFurnitureBackdropFrame.PageIndex ) then

        -- Set page index as the Furniture tab
        IVFrameHouseFurnitureBackdropFrame.PageIndex = 3;
    end    

    local prevFurniture, nextFurniture = IV_GetPrevNextFurniture( g_IVSelectedCharTabName, IV_GetSelectedFurniture( g_ViewAccountName, g_IVSelectedCharTabName ) );

    if ( prevFurniture ) then

        IV_SetSelectedFurniture( g_ViewAccountName, g_IVSelectedCharTabName, prevFurniture );
    end

    -- This will populate the UI with the Equipped_1, Equipped_2, or House Furniture,
    -- depending on which tab (IVFrameHouseFurnitureBackdropFrame.PageIndex) was selected
    IV_EquippedOrFurnitureFrameTab_SetTabID( IVFrameHouseFurnitureBackdropFrame.PageIndex );

    --IV_Log( "Prev Furniture: " .. prevFurniture );
end


function IVFrame_HouseFurnitureRightArrow_OnClick(this)

    --IV_Log( "IVFrame_HouseFurnitureRightArrow_OnClick" );

    -- Switch to the Furniture tab if it's not set already
    if ( 3 ~= IVFrameHouseFurnitureBackdropFrame.PageIndex ) then

        -- Set page index as the Furniture tab
        IVFrameHouseFurnitureBackdropFrame.PageIndex = 3;
    end    

    local prevFurniture, nextFurniture = IV_GetPrevNextFurniture( g_IVSelectedCharTabName, IV_GetSelectedFurniture( g_ViewAccountName, g_IVSelectedCharTabName ) );

    if ( nextFurniture ) then

        IV_SetSelectedFurniture( g_ViewAccountName, g_IVSelectedCharTabName, nextFurniture );
    end

    -- This will populate the UI with the Equipped_1, Equipped_2, or House Furniture,
    -- depending on which tab (IVFrameHouseFurnitureBackdropFrame.PageIndex) was selected
    IV_EquippedOrFurnitureFrameTab_SetTabID( IVFrameHouseFurnitureBackdropFrame.PageIndex );

    --IV_Log( "Next Furniture: " .. nextFurniture );
end


StaticPopupDialogs["DELETE_INVENTORY_VIEWER_DATA"] = {
    text = "",
    button1 = TEXT("YES"),
    button2 = TEXT("NO"),
    OnAccept = function()
        IVFrame_WipeAccount( StaticPopupDialogs["DELETE_INVENTORY_VIEWER_DATA"].AccountName );
    end,
    timeout = 0,
    whileDead = 1,
    exclusive = 1,
    showAlert = 1,
    hideOnEscape = 1
};


StaticPopupDialogs["IV_WARNING_TOO_MANY_CHARS"] = {
    text = "",
    button1 = TEXT("CLOSE"),
    OnAccept = function()
        IVFrame:Show();
    end,
    timeout = 0,
    whileDead = 1,
    exclusive = 1,
    showAlert = 1,
    hideOnEscape = 1
};

-------------------------------------------------------------------------------------------------
-- Settings Configuration Panel
-------------------------------------------------------------------------------------------------
function IVConfigFrame_SelectConfigTab( id )

    --IV_Log( "IVConfigFrame_SelectConfigTab: " .. id )

    -- Set the chosen tab to a selected state and unselect all other tabs
    local tabObj;

    for i = 1, 2 do

        tabObj   = getglobal( "IVConfigFrameTab" .. i );
        frameObj = getglobal( "IVConfigFrameTab" .. i .. "Frame");

        if ( i == id ) then
            UIPanelTab_SetActiveState( tabObj, true );
            frameObj:Show();
        else
            UIPanelTab_SetActiveState( tabObj, false );
            frameObj:Hide();
        end
    end
end


function IVConfigFrameConfigTab_OnClick( this, button )

    --IV_Log( "IVConfigFrameConfigTab_OnClick: " .. tostring(button) )

    -- switch to the selected tab
    IVConfigFrame_SelectConfigTab( this:GetID() );
end


function IVConfigFrameConfigTab_OnLoad( this )

    --IV_Log( "IVFrameCharTab_OnLoad" );
    
    -- Set the tab name if this is tab 2
    if ( this:GetID() == 2 ) then
        this:SetText( "test" );
    end

    PanelTemplates_TabResize( this, 9.5/GetUIScale() );
    this:RegisterForClicks("LeftButton", "RightButton");
end


function IV_GetEmptyBagSlot()

    -- Try Arcane Transmutor slots first
    for i=55, 51, -1 do

        local a = GetGoodsItemInfo(i);

        if ( a ) then
            itemLink = GetBagItemLink(i);
            if ( itemLink ) then
                --IV_Log( "IV_GetEmptyBagSlot AT" .. i .. " (" .. a .. "):" .. itemLink );            
            else
                --IV_Log( "IV_GetEmptyBagSlot - AT " .. i );    
                return "AT", i;
            end
        end
    end

    -- Try backpack page 2 and work backwards
    for i=60, 1, -1 do

        local index, texture, name, itemCount, locked, invalid = GetBagItemInfo(i);

        if ( texture == "" ) then
            return "BP", index, i;
        end
    end
end

function IV_EquippedItemTimerButton_OnEnter(this)

    if ( not GameTooltip:IsVisible() ) then

        GameTooltip:SetOwner(this, "ANCHOR_RIGHT", 10, 0);
        GameTooltip:ClearAllAnchors();
        GameTooltip:SetAnchor("TOPLEFT", "BOTTOMRIGHT", this, 4, 0);
        GameTooltip:ClearLines();

        if ( this.EquippedItemTimerButton ) then

            GameTooltip:SetText( string.format(IV_PROCESSING_EQUIPPED_ITEM, this.equipped_index) );
        else
            GameTooltip:SetText( IV_CLICK_TO_SAVE_EQUIPPED_ITEMS );
        end
    end
end


function IV_EquippedItemTimerButton_OnLeave(this)

    --IV_Log( "IV_EquippedItemTimerButton_OnLeave" )
    GameTooltip:Hide();
end


function IV_EquippedItemTimerButton_OnClick( this, key )

    --IV_Log( key );

    -- Left-Click
    if ( key == "LBUTTON" ) then
        this.Quick = true;

    -- Right-Click
    else 
        this.Quick = false;
    end

    -- Allow the IV_EquippedItemTimerButton_OnUpdate() to do some work
    this.EquippedItemTimerButton = true;
end


function IV_EquippedItemTimerButton_Disable()

    --IV_Log( "IV_EquippedItemTimerButton_Disable" );

    -- Stop the IV_EquippedItemTimerButton_OnUpdate() from doing any work
    IV_EquippedButton.EquippedItemTimerButton = nil;
    IV_EquippedButton.equipped_index = nil;
    IV_EquippedButton.outerTimer = nil;
    IV_EquippedButton.mode = nil;
    IV_EquippedButton.dstBag = nil;
    IV_EquippedButton.dstBagSlot = nil;
    IV_EquippedButton.dstBagSlotID = nil;


    -- Set alpha on our icon back to full
    IV_EquippedButton.alpha = 1;
    IV_EquippedButtonIcon:SetAlpha(IV_EquippedButton.alpha);
    IV_EquippedButtonIcon:SetTexture("");

    -- Update the tooltip if it's visible
    if ( GameTooltip:IsVisible() and GameTooltip:IsOwned(IV_EquippedButton) ) then
        GameTooltip:ClearLines();
        GameTooltip:SetText( IV_CLICK_TO_SAVE_EQUIPPED_ITEMS );
    end

    -- Update the UI only if the currently selected tab is the logged in user and one of the Equipped Items tabs is selected
    if ( IV_IsSelectedTabCurrentPlayer() and 
        ( 1 == IVFrameHouseFurnitureBackdropFrame.PageIndex or 
        2 == IVFrameHouseFurnitureBackdropFrame.PageIndex ) ) then

        IV_PopulateEquippedInventory( g_CurrentPlayerName );
    end
end


function IV_EquippedItemTimerButton_OnUpdate(this, elapsedTime)

    if ( not this.EquippedItemTimerButton ) then
        return;
    end

    --IV_Log( "IV_EquippedItemTimerButton_OnUpdate: " .. elapsedTime );

    -- Fade the icon a bit
    if ( not this.alpha or this.alpha < 0 ) then
        this.alpha = 1;
    else
        this.alpha = this.alpha - 0.025;
        IV_EquippedButtonIcon:SetAlpha(this.alpha);
        --IV_Log( "this.alpha = " .. tostring(this.alpha) );
    end

    -- if this is the first time, don't wait,
    if ( not this.outerTimer ) then 
        this.outerTimer = 10;
    end

    -- Wait x amount of ticks before we do anything
    if ( this.outerTimer < 10 ) then 

        -- increment outer timer
        this.outerTimer = this.outerTimer + 1;
        return;
    else

        -- reset outer timer and continue...
        this.outerTimer = 0;
    end

    -- Log the mode and index for now (spammy)
    --IV_Log( "mode: " .. tostring(this.mode) );
    --IV_Log( "equipped_index: " .. tostring(this.equipped_index) );

    -- Get the  mode we're in, are we:
    --    nil        about to initialize (button was clicked to start the ball rolling)
    --     "EQ2AT"    about to figure out which equipped item slot we're on (starts at 0) and initiate an item move from Equipped to AT slot
    --    "W4AT"    waiting for the item to arrive in the AT slot and get the itemLink, itemCount, and texture
    --     "W4EQ"    waiting for the item to reappear in the equipped slot and/or gone from the AT slot
    --     about to move on to the next item and repeat the process
    if ( not this.mode ) then

        -- no mode means we're on our first run (initialize)

        -- Make sure there are no invalid items equipped since IV needs to pick them up, put them in the AT/Backpack, then re-equip them.
        -- This can be a problem when the user is on their Primary class but viewing thier Secondary class's equipped items (or vice versa)
        if ( IsAnyInvalidItemsEquipped() ) then

            IV_Log( "IV: You have items equipped that are invalid for your current class.  Please change classes and try again.", 1,0,0 );
            IV_EquippedItemTimerButton_Disable();
            return;
        end

        -- Figure out which equipment set we're working on (1 or 2)
        this.EQ_set = GetEuipmentNumber();

        -- Start at equipped item slot 0 (head piece)
        this.equipped_index = 0;

        -- Set next mode and return
        --IV_Log( "IV: Setting Mode: EQ2AT" );
        this.mode = "EQ2AT";
        return;

    elseif ( this.mode == "EQ2AT" ) then

        -- get the texture/count from the current equipped item
        this.texture = GetInventoryItemTexture("player", this.equipped_index);
        this.count = GetInventoryItemCount("player", this.equipped_index);

        -- Update the tooltip if it's visible
        if ( GameTooltip:IsVisible() and GameTooltip:IsOwned(this) ) then
            GameTooltip:ClearLines();
            GameTooltip:SetText( string.format(IV_PROCESSING_EQUIPPED_ITEM, this.equipped_index) );
        end

        -- If this is Quick mode, compare the texture and count with what we already have, skip to next item if they're the same
        if ( this.Quick ) then

            -- if both nil, skip to next item
            if ( not this.texture and not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] ) then

                --IV_Log( "Quick mode: both nil (" .. this.equipped_index .. " hasn't changed)" );

                -- Skip to next item, we got the texture and count, that's all we're going to get for this item since we can't unequip it
                this.equipped_index = this.equipped_index + 1;
                this.outerTimer = 10; -- Don't wait for the 10 ticks on the next iteration

                -- if we finished handling all of the equipped items, we're done until the next time the button is clicked
                if ( this.equipped_index > 21 ) then

                    IV_EquippedItemTimerButton_Disable();
                    return;
                end

                return;

            -- if both exist and are same, skip to next item
            elseif ( this.texture and g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index]                          and
                                    g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].texture                  and
                                    g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].texture == this.texture and
                    this.count and   g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].itemCount                      and
                                    g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].itemCount == this.count ) then

                --IV_Log( "Quick mode: both same (" .. this.equipped_index .. " hasn't changed)" );

                -- Skip to next item, we got the texture and count, that's all we're going to get for this item since we can't unequip it
                this.equipped_index = this.equipped_index + 1;
                this.outerTimer = 10; -- Don't wait for the 10 ticks on the next iteration

                -- if we finished handling all of the equipped items, we're done until the next time the button is clicked
                if ( this.equipped_index > 21 ) then

                    IV_EquippedItemTimerButton_Disable();
                    return;
                end

                return;
            else
                --IV_Log( "Quick mode: " .. this.equipped_index .. " changed.  Must update data." );
            end
        end

        if ( this.texture and this.count ) then

            --IV_Log( "texture: " .. this.texture .. " count: " .. this.count );

            -- Set our IV_EquippedButton texture to the one we're about to save off
            IV_EquippedButtonIcon:SetTexture(this.texture);
            this.alpha = 1;

            -- Save texture and count in the IV database since we have it right now and it's guaranteed to be correct
            -- this just leaves itemLinks as the pain in the ass until RoM supports getting itemLinks from equipped items
            --IV_Log( "Saving texture and count for " .. this.EQ_set .. " " .. this.equipped_index, 1,.5,1 );

            if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] ) then
                g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] = {};
            end

            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].texture = this.texture;
            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].itemCount = this.count;

            -- If it's the Talisman0, Talisman1, or Talisman2 slots, we won't be able to unequip the item (like a Fountain  of Talent)
            -- So let's not try to unequip the item to get it's itemLink or we'll be waiting forever for it to show up on the AT/Backpack.
            if ( this.equipped_index == 17 or 
                this.equipped_index == 18 or 
                this.equipped_index == 19 ) then

                --IV_Log( "Not attempting to get itemLink for equipment index " .. this.equipped_index );

                -- Skip to next item, we got the texture and count, that's all we're going to get for this item since we can't unequip it
                this.equipped_index = this.equipped_index + 1;

                return;
            end

            --  Find an empty AT/Bag slot to put the piece of equipment in so we can gether the itemLink from it
            this.dstBag, this.dstBagSlot, this.dstBagSlotID = IV_GetEmptyBagSlot();
            if ( not this.dstBag ) then
                IV_Log( "IV: All bag/AT slots are full, can't get itemLinks of equipped items.  Please empty a slot and try again.", 1,0,0 );
                IV_EquippedItemTimerButton_Disable();
                return;
            end

            --IV_Log( "Found bag/AT space: " .. this.dstBag .. " " .. this.dstBagSlot .. " " .. tostring(this.dstBagSlotID) );

            --g_IVStatus.SettingEquippedTable_BagSlot_Type = where; -- now called this.dstBag
            --g_IVStatus.SettingEquippedTable = 1;

            -- Pick up equipped item
            PickupEquipmentItem(this.equipped_index);

            -- ... and put it in the empty AT/Bag slot
            PickupBagItem(this.dstBagSlot);

            -- Set next mode and return
            --IV_Log( "IV: Setting Mode: W4AT" );
            this.mode = "W4AT";
            return;

        else
            -- no texture or count, clear the current texture
            IV_EquippedButtonIcon:SetTexture("");

            -- Wipe this slot data out from IV database since there's nothing equipped in this slot
            if ( g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set] and
                g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] ) then
                g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] = nil;
                --IV_Log( "removed equipment_" .. this.EQ_set .. " slot " .. this.equipped_index .. " from the IV database.", 0,0,1 );
            end

            --move on to next equipped item and return
            this.equipped_index = this.equipped_index + 1;

            -- if we finished handling all of the equipped items, we're done until the next time the button is clicked
            if ( this.equipped_index > 21 ) then

                IV_EquippedItemTimerButton_Disable();
                return;
            end

            return;
        end

    elseif ( this.mode == "W4AT" ) then

        -- Get the item info from the Arcane Transmutor slot we moved the equipped item to
        local texture, itemCount, itemLink;

        if ( "AT" == this.dstBag ) then

            texture, _, itemCount, _ = GetGoodsItemInfo(this.dstBagSlot);

            -- If the texture isn't available yet then our equipped item hasn't made it to the AT yet
            -- So just return and we'll check again on the next update
            if ( texture == "" ) then
                --IV_Log( "item isn't in AT yet." );
                return;
            end

            itemLink = GetBagItemLink( this.dstBagSlot );

        -- Get the item info from the Backpack slot we moved the equipped item to    
        elseif ( "BP" == this.dstBag ) then

            index, texture, _, itemCount, _, _ = GetBagItemInfo(this.dstBagSlotID);
            --IV_Log( "BP index: " .. index .. " = BP this.dstBagSlotID: " .. this.dstBagSlotID );

            -- If the texture isn't available yet then our equipped item hasn't made it to the backpack yet
            -- So just return and we'll check again on the next update
            if ( texture == "" ) then
                --IV_Log( "item isn't in Bag yet." );
                return;
            end

            itemLink = GetBagItemLink( index );
        end

        if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped ) then
            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped = {};
        end

        if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set] ) then
            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set] = {};
        end

        if ( not g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] ) then
            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] = {};
        end

        -- If the itemLink isn't available yet something is wrong, wipe out what we have in the database and return.  
        -- We'll check again on the next update
        if ( not itemLink or itemLink == "" ) then
            g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] = {};
            --IV_Log( "no itemLink yet..." );
            return;
        end

        -- save the itemLink, texture, and itemCount (should probably do this only if the item makes it back to the equipped slot)
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index] = {};
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].texture = texture;
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].itemCount = itemCount;
        g_InventoryViewerTable[g_AccountName][g_Realm][g_CurrentPlayerName].Equipped[this.EQ_set][this.equipped_index].itemLink = itemLink;

        -- Pick up the item to equip it
        PickupBagItem( this.dstBagSlot );

        -- If we got this far, we got the info we needed from the itemp, re-equip it
        PickupEquipmentItem(this.equipped_index);

        -- Set next mode and return
        --IV_Log( "IV: Setting Mode: W4EQ" );
        this.mode = "W4EQ";
        return;

    elseif ( this.mode == "W4EQ" ) then

        -- get the texture from the current equipped item
        local texture = GetInventoryItemTexture("player", this.equipped_index);

        if ( texture ) then

            --IV_Log( "item is back in the equipped slot!, moving on to next item..." );

            --move on to next equipped item
            this.equipped_index = this.equipped_index + 1;

            -- if we finished handling all of the equipped items, we're done until the next time the button is clicked
            if ( this.equipped_index > 21 ) then

                IV_EquippedItemTimerButton_Disable();
                return;
            end

            -- Set next mode and return
            --IV_Log( "IV: Setting Mode: EQ2AT" );
            this.mode = "EQ2AT";
            return;
        else
            -- item isn't back to equipped slot yet.. keep waiting...
            return;
        end
    else
        IV_Log( "IV: Unhandled mode." );
        return;
    end            
end
