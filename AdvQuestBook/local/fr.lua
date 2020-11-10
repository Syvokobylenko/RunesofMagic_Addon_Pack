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
AQB_XML_QDTAILS = "Détails de la quête";
AQB_XML_DESCR = "Description:";
AQB_XML_REWARDS = "Récompenses:";
AQB_XML_DETAILS = "Détails:";
AQB_XML_LOCATIONS = "Lieux:";
AQB_XML_CONFIG = "Paramètres";
AQB_XML_HSECTION = "Aide";
AQB_XML_OPENHELP = "Ouvrir l\'aide";
AQB_XML_CLOSEHELP = "Fermer l\'aide";
AQB_XML_SHARERES = "Résultats partagés";
AQB_XML_SHOWSHARE = "Afficher paratgées";
AQB_XML_HIDESHARE = "Masquer paratgées";
AQB_XML_BACK = "Retour";
AQB_XML_TYPEKEYWORD = "Saisissez un mot à rechercher";
AQB_XML_SEARCH = "Chercher";
AQB_XML_SEARCHRES = "Résultats de la recherche";
AQB_XML_CONFIG2 = "Configuration";
AQB_XML_CONFIG3 = "Icon Configuration"; -- New
AQB_XML_RELOADUI1 = "ReloadUI";
AQB_XML_RELOADUI2 = "Reload UI si les icônes ne s\'affichent pas correctement.";
AQB_XML_RELOADUI3 = "AQD activé, ReloadUI désactivé.";
AQB_XML_SHTOOLTIPS = "Tooltips"; -- Edited
AQB_XML_STTOOLTIPS = "Bulles d\'aides fixes";
AQB_XML_STICONS = "Icônes fixes";
AQB_XML_QDONTIPS = "Quest Description"; -- Edited
AQB_XML_RLONTIPS = "Recommended Level"; -- Edited
AQB_XML_REWONTIPS = "Rewards"; -- Edited
AQB_XML_COORDONTIPS = "Coordinates"; -- Edited
AQB_XML_PREINC = "Concerver les incomplètes";
AQB_XML_AQD = "Advanced Quest Dumper";
AQB_XML_QS = "Partage de quêtes";
AQB_XML_TMBTN = "Afficher le boutton";
--AQB_XML_SAVECLOSE = "Sauvegarder et Fermer";
--AQB_XML_CLOSECONFIG = "Fermer";
AQB_XML_PURGE = "Vider les Data";
AQB_XML_STPORT = "Snoop Transports"; -- Edited
AQB_XML_ETRAIN = "Elite Trainers"; -- Edited
AQB_XML_SHOWSHARED = "Shared Quests"; -- Edited
AQB_XML_SHOWDAILY = "Daily Quests"; -- New
AQB_XML_SHOWQUESTS = "Quests"; -- New
AQB_XML_AIRPORT = "Airships"; -- New
AQB_XML_MSGONDUMP = "Afficher les messages dans Quest Dump";
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
	["AQB_AMINFO"] = "permet de trouver de sinformations, de suivre et de gérer vos quêtes.",
	["AQB_AMNOTFOUND"] = "AddonManager n\'est pas détecté. Saisissez %s pour configurer %s ou cliquez sur le bouton.",
	["AQB_ERRFILELOAD"] = "Erreur de chargement",
	["AQB_DFAULTSETLOAD"] = "Paramètres par defaut",
	["AQB_SETSUPDATE"] = "Paramètres sauvegardés",
	["AQB_GET_PQUEST"] = "Quêtes de groupe",
	["AQB_SHIFT_RIGHT"] = "Shift+Clic droit pour bouger le bouton sur la mini carte.",
	["AQB_RCLICK"] = "Clic droit",
	["AQB_MOVE_BTN"] = "Maintenir enfoncé pour déplacer le bouton.",
	["AQB_L50ET"] = "Vous devez avoir vos compétences élites niveau 45.",
	["AQB_LIST_RECIEVED"] = "Liste des quêtes partagés reçue. Ouvre %s pour les visualiser.",
	["AQB_NOLIST_RECIEVED"] = "Pas de quête paratgée reçue.",
	["AQB_RECLEVEL"] = "Niveau recommandé",
	["AQB_UNKNOWNQID"] = "ID de quête inconnu",
	["AQB_COORDS"] = "Coordonées",
	["AQB_NEW_QD"] = "Nouvelle quête Dumped pour %s.",
	["AQB_CLEARED_DATA"] = "Cleaned out %s Quests and Saved %s Quests",
	["AQB_CLEANED_ALL"] = "Nettoyage des quetes sauvegardées.",
	["AQB_UPLOAD"] = "Uploadez votre %s pour %s après avoir quitté le jeu.",
	["AQB_MIN_CHARS"] = "Saisissez au moins %s caractères à rechercher...",
	["AQB_TOOMANY"] = "Plus de %s résultats trouvés. Utilisez un terme différent pour affiner la recherche.",
	["AQB_SEARCHING"] = "Recherche en cours pour %s. Patientez...",
	["AQB_FOUND_RESULTS"] = "Trouvé %s résultats pour %s.",
	["AQB_NOTSUB"] = "Cette quête n\'a pas encore été soumise.",
	["AQB_RECLEVEL"] = "Niveau recommandé",
	["AQB_START"] = "Début",
	["AQB_END"] = "Fin",
	["AQB_REWARDS"] = "Récompenses",
	["AQB_COORDS"] = "Coordonées",
	["AQB_TRANSPORT"] = "Transport",
	["AQB_LINKSTO"] = "Vers",
	["AQB_DUMPED"] = "Dumped",
	["AQB_GOLD"] = "Or",
	["AQB_XP"] = "Expérience",
	["AQB_TP"] = "Points de Talent",
	["AQB_MAP"] = "Carte",
	["AQB_AND"] = "et",
	["AQB_OPEN"] = "Ouvrir",
	["AQB_LOCK"] = "Vérouiller",
	["AQB_UNLOCK"] = "Dévérouiller",
	["AQB_QSTATUS0"] = "You have not completed this quest.",
	["AQB_QSTATUS1"] = "You currently have this quest.",
	["AQB_QSTATUS2"] = "You have completed this quest.",
};
-- Help topics will be added back later. I need to rewrite them.
