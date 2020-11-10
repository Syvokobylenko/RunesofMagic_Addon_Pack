--[[ ä

	Name: Advanced Questbook
	By: Crypton

	%s is a "Wild Card" character. AQB uses these to replace with data
	such as names of items, players, etc.. It is important not to remove
	them or you will receive errors. For translating, you can move them
	where they need to go in the sentence so the data forms a proper
	sentence in your language.
]]
AQB_XML_QDTAILS = "Quest Details";
AQB_XML_DESCR = "Description:";
AQB_XML_REWARDS = "Rewards:";
AQB_XML_DETAILS = "Details:";
AQB_XML_LOCATIONS = "Locations:";
AQB_XML_CONFIG = "Config";
AQB_XML_HSECTION = "Help Section";
AQB_XML_OPENHELP = "Open Help";
AQB_XML_CLOSEHELP = "Close Help";
AQB_XML_SHARERES = "Share Results";
AQB_XML_SHOWSHARE = "Show Shared";
AQB_XML_HIDESHARE = "Hide Shared";
AQB_XML_BACK = "Back";
AQB_XML_TYPEKEYWORD = "Type a keyword to search";
AQB_XML_SEARCH = "Search";
AQB_XML_SEARCHRES = "Search Results";
AQB_XML_CONFIG2 = "Configuration";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "ReloadUI";
AQB_XML_RELOADUI2 = "Reload UI if the map icons get messed up.";
AQB_XML_RELOADUI3 = "AQD Enabled, ReloadUI Disabled.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "Sticky Tooltips";
AQB_XML_STICONS = "Sticky Icons";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "Preserve Incomplete";
AQB_XML_AQD = "Advanced Quest Dumper";
AQB_XML_QS = "Quest Share";
AQB_XML_TMBTN = "Toggle Minibutton";
--AQB_XML_SAVECLOSE = "Save/Close";
--AQB_XML_CLOSECONFIG = "Close Config";
AQB_XML_PURGE = "Clear Data";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "Show Message on Quest Dump";
AQB_XML_NOTE1 = "Drag this icon on the map to place an icon in that location.";
AQB_XML_NOTE2 = "Shift+Left Click a Note to Edit It";
AQB_XML_NOTE3 = "Hold Shift+Right Mouse to Move a Note";
AQB_XML_NOTE4 = "CTRL+Left Click to Delete a Note";
AQB_XML_NOTE5 = "New Note";
AQB_XML_NOTE6 = "Edit Note";
AQB_XML_NOTE7 = "You currently have %s notes for the current map. Please remove a note before trying to add another.";
AQB_XML_NOTE8 = "Map Notes:";
AQB_XML_NOTE9 = "Save Note";
AQB_XML_NOTE10 = "Edit Title";
AQB_XML_NOTE11 = "Edit Note";
AQB_XML_NOTE12 = "Custom Notes"; -- Edited

AdvQuestBook_Messages = {
	["AQB_AMINFO"] = "a feature rich way to find information, track, and manage your ingame quests.",
	["AQB_AMNOTFOUND"] = "AddonManager not detected. It is a useful addon and highly recommended to use for %s. Type %s to open the %s panel or you can use the provided button that appears when AddonManager is not installed.",
	["AQB_ERRFILELOAD"] = "Error loading file",
	["AQB_DFAULTSETLOAD"] = "default settings loaded",
	["AQB_SETSUPDATE"] = "updated settings",
	["AQB_GET_PQUEST"] = "Get Party Quests",
	["AQB_SHIFT_RIGHT"] = "Shift + Right Click to move the minimap buttons.",
	["AQB_RCLICK"] = "Right Click",
	["AQB_MOVE_BTN"] = "Hold down left mouse button to move button.",
	["AQB_L50ET"] = "Must have Primary and Secondary Level 45 Elite Skills.",
	["AQB_LIST_RECIEVED"] = "Recieved Quest Share List. Please open %s to see shared quests.",
	["AQB_NOLIST_RECIEVED"] = "No Shared Quest data was received.",
	["AQB_RECLEVEL"] = "Recommended Level",
	["AQB_UNKNOWNQID"] = "Unknown Quest ID",
	["AQB_COORDS"] = "Coords",
	["AQB_NEW_QD"] = "New Quest Dumped for %s.";
	["AQB_CLEARED_DATA"] = "Cleaned out %s Quests and Saved %s Quests",
	["AQB_CLEANED_ALL"] = "Cleaned out all saved quest data.",
	["AQB_UPLOAD"] = "Be sure to upload your %s to %s after you have exited the game.",
	["AQB_MIN_CHARS"] = "Please type at least %s characters to search...",
	["AQB_TOOMANY"] = "More than %s results found. Using a different search term may reduce your results to something easier to look through.",
	["AQB_SEARCHING"] = "Searching for %s. Please wait...",
	["AQB_FOUND_RESULTS"] = "Found %s results for %s.",
	["AQB_NOTSUB"] = "This quest has not been submitted yet.",
	["AQB_RECLEVEL"] = "Recommended Level",
	["AQB_START"] = "Start",
	["AQB_END"] = "End",
	["AQB_REWARDS"] = "Rewards",
	["AQB_COORDS"] = "Coords",
	["AQB_TRANSPORT"] = "Transport",
	["AQB_LINKSTO"] = "Links To",
	["AQB_DUMPED"] = "Dumped",
	["AQB_GOLD"] = "Gold",
	["AQB_XP"] = "Experience",
	["AQB_TP"] = "Talent Points",
	["AQB_MAP"] = "Map",
	["AQB_AND"] = "and",
	["AQB_OPEN"] = "Open",
	["AQB_LOCK"] = "Lock",
	["AQB_UNLOCK"] = "Unlock",
	["AQB_QSTATUS0"] = "You have not completed this quest.",
	["AQB_QSTATUS1"] = "You currently have this quest.",
	["AQB_QSTATUS2"] = "You have completed this quest.",
};
-- Help topics will be added back later. I need to rewrite them.
