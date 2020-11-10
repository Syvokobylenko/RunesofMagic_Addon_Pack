--[[
pbInfo - Locales/lang.French.lua
	v0.49
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/

	thx to wolf79400 and Yogg for the translation!
	-- commented lines need translations

   à : \195\160    è : \195\168    ì : \195\172    ò : \195\178    ù : \195\185
   á : \195\161    é : \195\169    í : \195\173    ó : \195\179    ú : \195\186
   â : \195\162    ê : \195\170    î : \195\174    ô : \195\180    û : \195\187
   ã : \195\163    ë : \195\171    ï : \195\175    õ : \195\181    ü : \195\188
   ä : \195\164                    ñ : \195\177    ö : \195\182
   æ : \195\166                                    ø : \195\184
   ç : \195\167                                    ? : \197\147
   
   Ä : \195\132
   Ö : \195\150
   Ü : \195\156
   ß : \195\159
]]--
pbInfo.Locale["Messages"]["LOADED"]  		= "Add-on charg\195\169 - traduit par |cff00FF00wolf|r et |cff00FF00Yogg|r";
pbInfo.Locale["Messages"]["NVT"] 			= "Cible incorrecte !";
pbInfo.Locale["Messages"]["TOGGLEtrue"] 	= " A \195\169t\195\169 |cff00FF00activ\195\169|r avec succ\195\168s.";
pbInfo.Locale["Messages"]["TOGGLEfalse"]	= " A \195\169t\195\169 |cffFF0000d\195\169sactiv\195\169|r avec succ\195\168s.";
pbInfo.Locale["Messages"]["TOGGLEerror"]	= " n'existe pas dans la configuration.";
pbInfo.Locale["Messages"]["ONLOAD"]			= "Utilisez le bouton de la minimap ou /pbic pour changer les options.";
pbInfo.Locale["Messages"]["ATTENTIONENABLE"]= "Attention : l'add-on a \195\169t\195\169 |cffFF0000d\195\169sactiv\195\169|r dans le pass\195\169. Utilisez /pbic pour le remettre.";
pbInfo.Locale["Tooltip"]["HP"] 			= "Vie";
pbInfo.Locale["Tooltip"]["LVL"] 		= "Niveau";
pbInfo.Locale["Tooltip"]["PROGRESS"]	= "Progression";
pbInfo.Locale["Tooltip"]["TITLE"]		= "Titre";
pbInfo.Locale["Tooltip"]["GUILD"]	 	= "Guilde";
pbInfo.Locale["Tooltip"]["DISTANCE"]	= "Distance";
pbInfo.Locale["Tooltip"]["TARGET"] 		= "Cible";
pbInfo.Locale["Tooltip"]["MANATYPE1"] 	= "Mana";
pbInfo.Locale["Tooltip"]["MANATYPE2"] 	= "Rage";
pbInfo.Locale["Tooltip"]["MANATYPE3"] 	= "Focus";
pbInfo.Locale["Tooltip"]["MANATYPE4"] 	= "Energie";
pbInfo.Locale["Tooltip"]["MATINBAG"]	= "Dans les sacs";
pbInfo.Locale["Tooltip"]["MATONBANK"]	= "Dans la banque";
pbInfo.Locale["ClockTooltip"]["CNDTIME"] 	= "Heure en Candara";
pbInfo.Locale["ClockTooltip"]["ONLINE"] 	= "En ligne depuis ";
pbInfo.Locale["QuestTracker"]["DAILY"] 		= "Quete journali\195\168re"
pbInfo.Locale["QuestTracker"]["REWARD"] 	= "R\195\169compense";
pbInfo.Locale["QuestTracker"]["QUESTNPC"] 	= "PNJ";
pbInfo.Locale["QuestTracker"]["XP"] 		= "XP";
pbInfo.Locale["QuestTracker"]["TP"] 		= "TP";
pbInfo.Locale["QuestTracker"]["GOLD"] 		= "Or";
pbInfo.Locale["QuestTracker"]["DQITEMS"] 		= "Objets de qu\195\170te journali\195\168re";
pbInfo.Locale["QuestTracker"]["COMPLQUESTS"]	= "Qu\195\170tes termin\195\169es";
pbInfo.Locale["QuestTracker"]["INFOTOOLTIP"] = "Clic gauche pour activer le suivi des quetes.\n\nMaj + clic droit pour le d\195\169placer.";
pbInfo.Locale["Config"]["Title"] 								= "Configuration de pbInfo";
pbInfo.Locale["Config"]["TabGeneral"] 							= "G\195\169n\195\169ral";
pbInfo.Locale["Config"]["TabTooltip"] 							= "Info-bulle";
pbInfo.Locale["Config"]["TabTargetFrame"] 						= "Vie de la cible";
pbInfo.Locale["Config"]["TabBloodBars"] 						= "BloodBars";
pbInfo.Locale["Config"]["TabThreatMeter"] 						= "ThreatMeter";
pbInfo.Locale["Config"]["TabQuestTracker"] 						= "Suivi des qu\195\170tes";
pbInfo.Locale["Config"]["TabChatLog"] 							= "ChatLog"; 
pbInfo.Locale["Config"]["TabCastingBar"] 						= "Barre de cast";
pbInfo.Locale["Config"]["TabChatFrame"] 							= "Discussion";
pbInfo.Locale["Config"]["SettingEnable"] 						= "Activer pbInfo";
--pbInfo.Locale["Config"]["SettingThousandsSeparatorFormat"] 	= "ThousandsSeparator:";
--pbInfo.Locale["Config"]["SettingTimeStampFormat"] 			= "TimeStamp format:";
pbInfo.Locale["Config"]["SettingExtraLanguage"] 				= "Langage :";
pbInfo.Locale["Config"]["SettingModifyTooltip"] 				= "Montrer les infos des monstres et des joueurs";
pbInfo.Locale["Config"]["SettingModifyHealthbar"] 				= "Montrer la vraie vie de la cible";
pbInfo.Locale["Config"]["SettingHealthbarShowPercentage"] 		= "Garder les valeurs en pourcentage";
pbInfo.Locale["Config"]["SettingHealthColorFade"] 				= "Lisser les couleurs de vie";
pbInfo.Locale["Config"]["SettingShowMana"] 						= "Afficher le mana, rage, energie et focus";
pbInfo.Locale["Config"]["SettingShowDistance"] 					= "Afficher la distance";
pbInfo.Locale["Config"]["SettingTooltipShowRace"] 				= "Afficher la race";
pbInfo.Locale["Config"]["SettingTooltipShowPlayerInfo"] 		= "Afficher les titres des joueurs (experimental)";
pbInfo.Locale["Config"]["SettingShowMouseoverTarget"] 			= "Afficher la cible de la cible";
pbInfo.Locale["Config"]["SettingAllNPC"] 						= "Activer pour tous les PNJ";
pbInfo.Locale["Config"]["SettingStickyTooltip"] 				= "Position de l'info-bulle";
pbInfo.Locale["Config"]["SettingStickyAllTooltips"] 			= "Toute les info-bulles (sorts, objets, etc.)";
pbInfo.Locale["Config"]["SettingStickyTooltipButton"] 			= "D\195\169finir";
pbInfo.Locale["Config"]["SettingShowMaterialInfo"] 				= "Infos sur la collecte des mat\195\169riaux";
pbInfo.Locale["Config"]["SettingShowMatInfoItemCount"] 			= "Afficher le nombre d'\195\169l\195\169ments";
pbInfo.Locale["Config"]["SettingShowMatInfoItemCountBank"] 		= "+ \195\169l\195\169ments en banque";
pbInfo.Locale["Config"]["SettingShowMatInfoItemCountIV"] 		= "+ support d'InventoryViewer";
pbInfo.Locale["Config"]["SettingShowClockTooltip"] 				= "Afficher l'horloge dans l'info-bulle Jour/Nuit";
pbInfo.Locale["Config"]["SettingHealthBarColorFade"] 			= "Att\195\169nuation de la couleur de vie";
pbInfo.Locale["Config"]["SettingModifyBloodBars"] 				= "Voir la vraie vie dans la barre de vie";
pbInfo.Locale["Config"]["SettingBloodBarsColorFade"] 			= "Couleur de la barre de vie du vert au rouge";
pbInfo.Locale["Config"]["SettingBloodBarsDelay"] 				= "Fr\195\169quence de mise \195\160 jour en sec.:";
pbInfo.Locale["Config"]["SettingThreatMeter"] 					= "ThreatMeter";
pbInfo.Locale["Config"]["SettingThreatMeterShowTitle"] 			= "Afficher le titre";
pbInfo.Locale["Config"]["SettingThreatMeterLock"] 				= "Fixer la position";
pbInfo.Locale["Config"]["SettingThreatMeterPlayerOnTop"] 		= "Toujours placer le joueur en haut";
pbInfo.Locale["Config"]["SettingThreatMeterWarnTargetTargetTarget"]= "Alerter si je suis la cible de la cible du tank";
pbInfo.Locale["Config"]["TooltipThreatMeterWarnTargetTargetTarget"]= "Alerter si je suis la cible de la cible du tank";
pbInfo.Locale["Config"]["SettingThreatMeterHideOnNoTarget"] 	= "Masquer si aucune cible n'est s\195\169lectionn\195\169e";
pbInfo.Locale["Config"]["SettingThreatMeterHideOnNoParty"] 		= "Masquer si il n'y a pas de groupe";
pbInfo.Locale["Config"]["SettingThreatMeterRelativeToMaxThreat"]= "Voir l'aggro par rapport au max";
pbInfo.Locale["Config"]["SettingThreatMeterShowRealThreat"] 	= "Voir la vraie menace au lieu des pourcentages";
pbInfo.Locale["Config"]["SettingThreatMeterDisplayLimit"] 		= "% minimum \195\160 afficher dans la liste";
pbInfo.Locale["Config"]["SettingGameTooltipAlpha"] 				= "% transparence du fond des info-bulles";
pbInfo.Locale["Config"]["SettingThreatMeterAlpha"] 				= "% transparence du fond du ThreatMeter";
pbInfo.Locale["Config"]["SettingThreatMeterDelay"] 				= "Fr\195\169quence de mise \195\160 jour en sec.:";
pbInfo.Locale["Config"]["SettingQuestTracker"] 					= "Suivi des qu\195\170tes";
pbInfo.Locale["Config"]["SettingQuestTrackerShowTitle"] 		= "Afficher le titre";
pbInfo.Locale["Config"]["SettingQuestTrackerSortAsc"] 			= "Tri croissant";
pbInfo.Locale["Config"]["SettingQuestTrackerProgressColorFade"] = "Colorer avec l'avancement";
pbInfo.Locale["Config"]["SettingQuestTrackerTooltip"] 			= "Afficher l'info-bulle";
pbInfo.Locale["Config"]["SettingQuestTrackerTooltipRight"] 		= "Afficher l'info-bulle \195\160 droite";
pbInfo.Locale["Config"]["SettingQuestTrackerTooltipDescription"]= "Afficher le r\195\169sum\195\169 de qu\195\170te";
pbInfo.Locale["Config"]["SettingQuestTrackerHighlightDailies"] 	= "Surligner les qu\195\170tes journali\195\168res";
pbInfo.Locale["Config"]["SettingQuestTrackerOpenQuestbook"] 		= "Clic gauche ouvre le journal des qu\195\170tes";
pbInfo.Locale["Config"]["SettingQuestTrackerShowDailiesCounter"] 		= "Afficher le compteur de qu\195\170tes journali\195\168res (experimental)";
pbInfo.Locale["Config"]["SettingQuestTrackerFontSizesTitle"] 		= "Taille de police du titre du suivi des qu\195\170tes:";
pbInfo.Locale["Config"]["SettingQuestTrackerFontSizesQuestTitle"] 	= "Taille de police du nom des qu\195\170tes:";
pbInfo.Locale["Config"]["SettingQuestTrackerFontSizesQuestItems"] 	= "Taille de police des \195\169l\195\169ments des qu\195\170tes:";
pbInfo.Locale["Config"]["SettingQuestTrackerColorsDailyQuest"] 	= "Couleur des qu\195\170tes journali\195\168res";
pbInfo.Locale["Config"]["SettingChatLog"] 						= "ChatLog";
pbInfo.Locale["Config"]["SettingChatLogMaxLinesPerChat"] 		= "lignes \195\160 enregistrer dans l'historique";
pbInfo.Locale["Config"]["SettingChatFrameFilterTitles"] 			= "Supprimer les titres des canaux ([Zone], [Party], ...)";
pbInfo.Locale["Config"]["SettingChatFrameFilterXPTP"] 				= "Supprimer les gains d'XP/TP";
pbInfo.Locale["Config"]["SettingTimeStamp"] 					= "Afficher l'heure";
pbInfo.Locale["Config"]["SettingTimeStampNotInCombatLog"] 			= "Ne pas afficher dans le journal de combat";
pbInfo.Locale["Config"]["SettingAutoRepairAll"] 				= "Reparer l'\195\169quipement automatiquement";
pbInfo.Locale["Config"]["SettingCastingBarShowCastTime"] 		= "Afficher le temps de cast";
pbInfo.Locale["Config"]["SettingCastingBarButton"] 				= "D\195\169placer";
pbInfo.Locale["Config"]["TooltipBorderTitle"] 					= "Position de l'info-bulle du jeu";
pbInfo.Locale["Config"]["TooltipBorderText"] 					= "Cliquer pour d\195\169placer";
pbInfo.Locale["Config"]["ResetButton"] 							= "R\195\169init pbInfo";
pbInfo.Locale["Config"]["CloseButton"] 							= "Fermer";
pbInfo.Locale["Config"]["SaveButton"] 							= "Sauvegarder";