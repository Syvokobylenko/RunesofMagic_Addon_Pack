--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
--[[
	%s is a "Wild Card" character. AQB uses these to replace with data
	such as names of items, players, etc.. It is important not to remove
	them or you will receive errors. For translating, you can move them
	where they need to go in the sentence so the data forms a proper
	sentence in your language.
]]
AQB_XML_QDTAILS = "Quest-Details";
AQB_XML_DESCR = "Beschreibung:";
AQB_XML_REWARDS = "Belohnungen:";
AQB_XML_DETAILS = "Details:";
AQB_XML_LOCATIONS = "Standorte:";
AQB_XML_CONFIG = "Einstellungen";
AQB_XML_HSECTION = "Hilfe-Bereich";
AQB_XML_OPENHELP = "Hilfe öffnen";
AQB_XML_CLOSEHELP = "Hilfe schließen";
AQB_XML_SHARERES = "Suchergebnis teilen";
AQB_XML_SHOWSHARE = "Zeige geteilte Quests";
AQB_XML_HIDESHARE = "Geteilte Quests verstecken";
AQB_XML_BACK = "Zurück";
AQB_XML_TYPEKEYWORD = "Stichwort zur Suche eingeben";
AQB_XML_SEARCH = "Suche";
AQB_XML_SEARCHRES = "Suchergebnis";
AQB_XML_CONFIG2 = "Einstellungen";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "UI neu laden";
AQB_XML_RELOADUI2 = "Lädt das UI bei Problemen mit den Kompassicons neu.";
AQB_XML_RELOADUI3 = "AQD aktiviert, UI wird nicht neu geladen.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "Tooltips dauerhaft anzeigen";
AQB_XML_STICONS = "Icons dauerhaft anzeigen";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "Unvollständige behalten";
AQB_XML_AQD = "Advanced Quest Dumper";
AQB_XML_QS = "Quest Share";
AQB_XML_TMBTN = "Minimap-Icon zeigen/verstecken";
--AQB_XML_SAVECLOSE = "Speichern/Schließen";
--AQB_XML_CLOSECONFIG = "Einstellungen schließen";
AQB_XML_PURGE = "Exportierte Daten leeren";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "Nachricht beim Quest-Export zeigen";
AQB_XML_NOTE1 = "Drag this icon on the map to place an icon in that location."; -- New
AQB_XML_NOTE2 = "Shift+Left Click a Note to Edit It"; -- New
AQB_XML_NOTE3 = "Hold Shift+Right Mouse to Move a Note"; -- New
AQB_XML_NOTE4 = "CTRL+Left Click to Delete a Note"; -- New
AQB_XML_NOTE5 = "New Note"; -- New
AQB_XML_NOTE6 = "Edit Note"; -- New
AQB_XML_NOTE7 = "You currently have %s notes for the current map. Please remove a note before trying to add another."; -- New
AQB_XML_NOTE8 = "Map Notes:"; -- New
AQB_XML_NOTE9 = "Save Note"; -- New
AQB_XML_NOTE10 = "Edit Title"; -- New
AQB_XML_NOTE11 = "Edit Note"; -- New
AQB_XML_NOTE12 = "Custom Notes"; -- Edited

AdvQuestBook_Messages = {
	["AQB_AMINFO"] = "ein nützliches Addon, um Quest-Informationen zu finden, zu verfolgen und zu verwalten.",
	["AQB_AMNOTFOUND"] = "AddonManager nicht gefunden. Dieses nützliche Addon wird zur Verwendung mit %s empfohlen. Tippe %s um das %s-Fenster zu öffnen oder klicke auf die angezeigte Schaltfläche.",
	["AQB_ERRFILELOAD"] = "Fehler beim Laden einer Datei",
	["AQB_DFAULTSETLOAD"] = "Standard-Einstellungen geladen",
	["AQB_SETSUPDATE"] = "Einstellungen aktualisiert",
	["AQB_GET_PQUEST"] = "Quests der Gruppe empfangen",
	["AQB_SHIFT_RIGHT"] = "Shift + Rechtsklick, um die Minimap-Schaltfläche zu verschieben..",
	["AQB_RCLICK"] = "Rechtsklick",
	["AQB_MOVE_BTN"] = "Halte die linke Maustaste gedrückt, um die Schaltfläche zu verschieben.",
	["AQB_L50ET"] = "Du benötigst 45er-Elite-Fertigkeiten für beide deiner Klassen.",
	["AQB_LIST_RECIEVED"] = "Liste geteilter Quests empfangen. Öffne %s, um alle geteilten Quests zu sehen.",
	["AQB_NOLIST_RECIEVED"] = "Keine geteilten Quests empfangen.",
	["AQB_RECLEVEL"] = "Empfohlene Stufe",
	["AQB_UNKNOWNQID"] = "Unbekannte Quest-ID",
	["AQB_COORDS"] = "Koordinaten",
	["AQB_NEW_QD"] = "Questdaten von %s wurden exportiert.";
	["AQB_CLEARED_DATA"] = "Es wurden %s Quests gelöscht und %s (unvollständige) Quests behalten",
	["AQB_CLEANED_ALL"] = "Alle exportierten Quest-Daten wurden gelöscht.",
	["AQB_UPLOAD"] = "Lade deine %s auf %s hoch, wenn du das Spiel beendet hast.",
	["AQB_MIN_CHARS"] = "Um zu suchen, gib mindestens %s Zeichen ein...",
	["AQB_TOOMANY"] = "Mehr als %s Suchergebnisse. Versuche ein anderes Stichwort, um deine Suchergebnisse übersichtlicher zu machen.",
	["AQB_SEARCHING"] = "Suche nach %s. Bitte warten...",
	["AQB_FOUND_RESULTS"] = "%s Ergebnisse der Suche nach %s.",
	["AQB_NOTSUB"] = "Dieses Quest befindet sich nicht in der Datenbank.",
	["AQB_RECLEVEL"] = "Empfohlene Stufe",
	["AQB_START"] = "Start",
	["AQB_END"] = "Ende",
	["AQB_REWARDS"] = "Belohnung",
	["AQB_COORDS"] = "Koordinaten",
	["AQB_TRANSPORT"] = "Transportpunkt",
	["AQB_LINKSTO"] = "Verbindung nach",
	["AQB_DUMPED"] = "exportiert",
	["AQB_GOLD"] = "Gold",
	["AQB_XP"] = "Erfahrungs-Punkte",
	["AQB_TP"] = "Talent-Punkte",
	["AQB_MAP"] = "Karte",
	["AQB_AND"] = "und",
	["AQB_OPEN"] = "Öffnen",
	["AQB_LOCK"] = "Lock",
	["AQB_UNLOCK"] = "Unlock",
	["AQB_QSTATUS0"] = "Dieses Quest hast du noch nicht gemacht.",
	["AQB_QSTATUS1"] = "Dieses Quest machst du gerade.",
	["AQB_QSTATUS2"] = "Dieses Quest hast du abgeschlossen.",
};
-- Help topics will be added back later. I need to rewrite them.
