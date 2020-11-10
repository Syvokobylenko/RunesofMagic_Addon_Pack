--[[
pbInfo - Locales/lang.FR.lua
Traduit par Juki de la guilde <Carpe Diem> serveur Claiomh FR

	v0.49
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/

	thx to wolf79400 and Yogg for the translation!
	-- commented lines need translations

   ・: \195\160    ・: \195\168    ・: \195\172    ・: \195\178    ・: \195\185
   ・: \195\161    ・: \195\169    ・: \195\173    ・: \195\179    ・: \195\186
   ・: \195\162    ・: \195\170    ・: \195\174    ・: \195\180    ・: \195\187
   ・: \195\163    ・: \195\171    ・: \195\175    ・: \195\181    ・: \195\188
   ・: \195\164                    ・: \195\177    ・: \195\182
   ・: \195\166                                    ・: \195\184
   ・: \195\167                                    ? : \197\147
   
   ト : \195\132
   ヨ : \195\150
   ワ : \195\156
   ゜ : \195\159
]]--
pbInfo.QuestTracker.CompleteText = "%(Termin\195\169e%)";
pbInfo.QuestTracker.DailyQuestPatterns = {"pouvez encore terminer (%d+) Qu", "ne pouvez pas terminer Qu", "utilisez Billet de qu\195\170tes quotidiennes"};
pbInfo.ChatFrame.XPTP = {'^%d+ XP', '^%d+ PTA'};
pbInfo.ChatFrame.XPTPDebt = {"^Votre dette d'exp\195\169rience a diminu\195\169 de %d+", "^Votre dette de PTA a diminu\195\169 de %d+"};
pbInfo.ChatFrame.Progress = {'^Progression de (.+) : [%d.]+%%'}; -- do not translate %s and PERCENTAGE

pbInfo.Locale = {
	["Messages"] = {
		["DESCRIPTION"]  		= "pbInfo shows a tooltip with several information about the mob, player or NPC you are hovering, a tooltip with information about gathering materials and it modifies the target blood bars to show a mob's real healthpoints.\n\nBy now, pbInfo includes a ThreatMeter, a QuestTracker and a ChatLog.",
		["LOADED"]  		= "Add-on charg\195\169 - traduit par |cff00FF00wolf|r, |cff00FF00Yogg|r et |cff00FF00Juki|r",
		["NVT"] 			= "Cible incorrecte !",
		["TOGGLEtrue"] 		= " A \195\169t\195\169 |cff00FF00activ\195\169|r avec succ\195\168s.",
		["TOGGLEfalse"]		= " A \195\169t\195\169 |cffFF0000d\195\169sactiv\195\169|r avec succ\195\168s.",
		["TOGGLEerror"]		= " n'existe pas dans la configuration.",
		["ONLOAD"]			= "Utilisez le bouton de la minimap ou /pbic pour changer les options.",
		["ATTENTIONENABLE"]	= "Attention : l'add-on a \195\169t\195\169 |cffFF0000d\195\169sactiv\195\169|r dans le pass\195\169. Utilisez /pbic pour le remettre."
	},
	["Tooltip"] = {
		["HP"] 			= "Vie",
		["LVL"] 		= "Niveau",
		["PROGRESS"]	= "Progression",
		["TITLE"]		= "Titre",
		["GUILD"]	 	= "Guilde",
		["DISTANCE"]	= "Distance",
		["TARGET"] 		= "Cible",
		["MANATYPE1"] 	= "Mana",
		["MANATYPE2"] 	= "Rage",
		["MANATYPE3"] 	= "Focus",
		["MANATYPE4"] 	= "Energie",
		["MATINBAG"]	= "Dans les sacs",
		["MATONBANK"]	= "Dans la banque"
	},
	["ClockTooltip"] = {
		["CNDTIME"] 	= "Moment :",
		["ONLINE"] 		= "En ligne depuis ",
		["TIMEFORMAT"] 	= "%H:%M" -- http://www.lua.org/pil/22.1.html
	},
	["QuestTracker"] = {
		["DAILY"] 		= "Quete journali\195\168re",
		["REWARD"] 		= "R\195\169compense",
		["QUESTNPC"] 	= "PNJ",
		["XP"] 			= "XP",
		["TP"] 			= "TP",
		["GOLD"] 		= "Or",
		["DQITEMS"] 	= "Objets de qu\195\170te journali\195\168re",
		["COMPLQUESTS"]	= "Qu\195\170tes termin\195\169es",
		["INFOTOOLTIP"] = "Clic gauche pour activer le suivi des qu\195\170tes.\n\nMaj + clic droit pour le d\195\169placer."
	},
	["Config"] = {
		["Title"] 									= "Configuration de pbInfo",
		["TabGeneral"] 								= "G\195\169n\195\169ral",
		["TabTooltip"] 								= "Info-bulle",
		["TabTargetFrame"] 							= "Vie de la cible",
		["TabBloodBars"] 							= "BloodBars",
		["TabThreatMeter"] 							= "ThreatMeter",
		["TabQuestTracker"] 						= "Suivi des qu\195\170tes",
		["TabChatLog"] 								= "Journal",
		["TabChatFrame"] 							= "Discussion",
		["TabCastingBar"] 							= "Barre de cast",
		["SettingEnable"] 							= "Activer pbInfo",
		["SettingThousandsSeparatorFormat"]			= "S\195\169parateur de milliers :",
		["SettingTimeStampFormat"] 					= "Format heure :",
		["SettingExtraLanguage"] 					= "Langue :",
		["SettingModifyTooltip"] 					= "Montrer les infos des monstres et des joueurs",
		["SettingModifyHealthbar"] 					= "Montrer la vraie vie de la cible",
		["SettingHealthbarShowPercentage"] 			= "Garder les valeurs en pourcentage",
		["SettingHealthColorFade"] 					= "Lisser les couleurs de vie",
		["SettingShowMana"] 						= "Afficher le mana, rage, energie et focus",
		["SettingShowDistance"] 					= "Afficher la distance",
		["SettingTooltipShowRace"] 					= "Afficher la race",
		["SettingTooltipShowPlayerInfo"] 			= "Afficher les titres des joueurs (experimental)",
		["SettingShowMouseoverTarget"] 				= "Afficher la cible de la cible",
		["SettingAllNPC"] 							= "Activer pour tous les PNJ",
		["SettingStickyTooltip"] 					= "Position de l'info-bulle",
		["SettingStickyAllTooltips"] 				= "Toutes les info-bulles (sorts, objets, etc.)",
		["SettingStickyTooltipButton"] 				= "D\195\169finir position",
		["SettingShowMaterialInfo"] 				= "Infos sur la collecte des mat\195\169riaux",
		["SettingShowMatInfoItemCount"] 			= "Afficher le nombre d'\195\169l\195\169ments",
		["SettingShowMatInfoItemCountBank"] 		= "+ \195\169l\195\169ments en banque",
		["SettingShowMatInfoItemCountIV"] 			= "+ support d'InventoryViewer",
		["SettingShowClockTooltip"] 				= "Afficher l'horloge dans l'info-bulle Jour/Nuit",		
		["SettingHealthBarColorFade"] 				= "Att\195\169nuation de la couleur de vie du vert au rouge",
		["SettingModifyBloodBars"] 					= "Voir la vraie vie dans la barre de vie",
		["SettingBloodBarsColorFade"] 				= "Couleur de la barre de vie du vert au rouge",
		["SettingBloodBarsDelay"] 					= "Fr\195\169quence de mise \195\160 jour en sec. :",
		["SettingThreatMeter"] 						= "ThreatMeter",
		["SettingThreatMeterShowTitle"] 			= "Afficher le titre",
		["SettingThreatMeterLock"] 					= "Fixer la position",
		["SettingThreatMeterPlayerOnTop"] 			= "Toujours placer le joueur en haut",
		["SettingThreatMeterWarnTargetTargetTarget"]= "M'alerter si la cible de ma cible me cible",
		["TooltipThreatMeterWarnTargetTargetTarget"]= "M'alerter si la cible de ma cible me cible\nEx.: Tank -> Mob -> Moi",
		["SettingThreatMeterHideOnNoTarget"] 		= "Masquer si aucune cible n'est s\195\169lectionn\195\169e",
		["SettingThreatMeterHideOnNoParty"] 		= "Masquer si il n'y a pas de groupe",
		["SettingThreatMeterRelativeToMaxThreat"] 	= "Voir l'aggro par rapport au max",
		["SettingThreatMeterShowRealThreat"] 		= "Voir la vraie menace au lieu des pourcentages",
		["SettingThreatMeterDisplayLimit"] 			= "% minimum \195\160 afficher dans la liste",
		["SettingGameTooltipAlpha"] 				= "% transparence du fond des info-bulles",
		["SettingThreatMeterAlpha"] 				= "% transparence du fond du ThreatMeter",
		["SettingThreatMeterDelay"] 				= "Fr\195\169quence de mise \195\160 jour en sec. :",
		["SettingQuestTracker"] 					= "Suivi des qu\195\170tes",
		["SettingQuestTrackerShowTitle"] 			= "Afficher le titre",
		["SettingQuestTrackerSortAsc"] 				= "Tri croissant",
		["SettingQuestTrackerProgressColorFade"] 	= "Colorer avec l'avancement",
		["SettingQuestTrackerTooltip"] 				= "Afficher l'info-bulle",
		["SettingQuestTrackerTooltipRight"] 		= "Afficher l'info-bulle \195\160 droite",
		["SettingQuestTrackerTooltipDescription"] 	= "Afficher le r\195\169sum\195\169 de qu\195\170te",
		["SettingQuestTrackerHighlightDailies"] 	= "Surligner les qu\195\170tes journali\195\168res",
		["SettingQuestTrackerOpenQuestbook"] 		= "Clic gauche ouvre le journal des qu\195\170tes",
		["SettingQuestTrackerShowDailiesCounter"] 	= "Afficher le compteur de qu\195\170tes journali\195\168res (experimental)",
		["SettingQuestTrackerFontSizesTitle"] 		= "Taille de police du titre du suivi des qu\195\170tes :",
		["SettingQuestTrackerFontSizesQuestTitle"] 	= "Taille de police du nom des qu\195\170tes :",
		["SettingQuestTrackerFontSizesQuestItems"] 	= "Taille de police des \195\169l\195\169ments des qu\195\170tes :",
		["SettingQuestTrackerColorsDailyQuest"] 	= "Couleur des qu\195\170tes journali\195\168res",
		["SettingChatLog"] 							= "Journal de discussion",
		["SettingChatLogMaxLinesPerChat"] 			= "lignes \195\160 enregistrer dans l'historique",
		["SettingChatFrameFilterTitles"] 			= "Supprimer les titres des canaux ([Zone], [Groupe], ...)",
		["SettingChatFrameFilterXPTP"] 				= "Supprimer les gains d'XP/PTA",	
		["SettingChatFrameFilterXPTPDebt"] 			= "Enlever les messages de dettes",
		["SettingChatFrameFilterProgress"] 			= "Remove progress messages", -- please translate this. changed: remove all progress messages
		["SettingChatFrameFilterProgressGather"]	= "Gathering only",  -- please translate this. added: remove gathering progress messages only (mining, woodcutting, harbalism)
		["SettingChatFrameShowPlayerInfo"] 			= "Afficher la classe et le niveau (experimental)",
		["SettingTimeStamp"] 						= "Afficher l'heure dans le chat",
		["SettingTimeStampNotInCombatLog"] 			= "Ne pas afficher dans le journal de combat",
		["SettingAutoRepairAll"] 					= "R\195\169parer l'\195\169quipement automatiquement",
		["SettingCastingBarShowCastTime"] 			= "Afficher le temps de cast",
		["SettingCastingBarButton"] 				= "D\195\169placer la barre de cast",
		["TooltipBorderTitle"] 						= "Position de l'info-bulle du jeu",
		["TooltipBorderText"] 						= "Cliquer pour d\195\169placer",
		["ResetButton"] 							= "! R\195\169init pbInfo !",
		["CloseButton"] 							= "Fermer",
		["SaveButton"] 								= "Sauvegarder"
	}
};