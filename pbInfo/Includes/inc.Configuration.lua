--[[
pbInfo - Includes/inc.Configuration.lua
	v0.56
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
function pbInfo.Scripts.OnLoad()
	pbInfo.DefaultSettings = {
		["ENABLE"]  						= true,
		["MODIFYTOOLTIP"] 					= true,
		["MODIFYHEALTHBAR"] 				= true,
		["HEALTHCOLORFADE"] 				= true,
		["HEALTHBARCOLORFADE"] 				= false,
		["HEALTHBARSHOWPERCENTAGE"] 		= true,
		["SHOWMANA"] 						= true,
--		["SHOWDISTANCE"] 					= false,
		["TOOLTIPSHOWRACE"] 				= true,
		["TOOLTIPSHOWPLAYERINFO"] 			= false,
		["SHOWMOUSEOVERTARGET"] 			= false,
		["SHOWMATERIALINFO"] 				= true,
		["MATINFOITEMCOUNT"] 				= true,
		["MATINFOITEMCOUNTBANK"] 			= true,
		["MATINFOITEMCOUNTIV"] 				= true,
		["ALLNPC"] 							= true,
		["STICKYTOOLTIP"] 					= true,
		["STICKYALLTOOLTIPS"] 				= true,
		["MODIFYBLOODBARS"] 				= true,
		["BLOODBARSCOLORFADE"] 				= false,
		["BloodBarsDelay"] 					= 0.2,
		["THREATMETER"] 					= true,
		["THREATMETERLOCK"] 				= false,
		["THREATMETERSHOWTITLE"] 			= true,
		["ThreatMeterDelay"] 				= 0.5,
		["THREATMETERSHOWREALTHREAT"] 		= true,
		["THREATMETERRELATIVETOMAXTHREAT"] 	= false,
		["THREATMETERHIDEONNOTARGET"] 		= false,
		["THREATMETERHIDEONNOPARTY"] 		= false,
		["THREATMETERPLAYERONTOP"] 			= false,
		["THREATMETEWARNTARGETTARGETTARGET"]= false,
		["QUESTTRACKER"] 					= false,
		["QUESTTRACKERSHOWTITLE"] 			= true,
		["QUESTTRACKERSORTASC"] 			= false,
		["QUESTTRACKERPROGRESSCOLORFADE"] 	= true,
		["QUESTTRACKERTOOLTIP"] 			= true,
		["QUESTTRACKERTOOLTIPRIGHT"] 		= false,
		["QUESTTRACKERTOOLTIPDESCRIPTION"] 	= true,
		["QUESTTRACKEROPENQUESTBOOK"] 		= true,
		["QUESTTRACKERHIGHLIGHTDAILIES"] 	= true,
		["QUESTTRACKERSHOWDAILIESCOUNTER"]	= true,
		["QuestTrackerColors"]				= {{0.8, 0.8, 1}},
		["CHATFRAMEFILTERTITLES"]			= true,
		["CHATFRAMEHIDEXPTP"]				= false,
		["CHATFRAMEHIDEXPTPDEBT"]			= false,
		["CHATFRAMEHIDEPROGRESS"]			= true, -- changed: hide all progress messages
		["CHATFRAMEHIDEPROGRESSGATHER"]		= false, -- added: hide ghatering only
		["CHATFRAMESHOWPLAYERINFO"]			= true,
		["TIMESTAMP"] 						= true,
		["TIMESTAMPNOTINCOMBATLOG"] 		= true,
		["TimeStampFormat"] 				= "%M:%S",
		["ThousandsSeparatorFormat"]		= ".",
		["CHATLOG"] 						= true,
		["AUTOREPAIRALL"] 					= true,
		["SHOWCLOCKTOOLTIP"] 				= false,
		["CASTINGBARMOVEONLOAD"] 			= false,
		["CASTINGBARSHOWCASTTIME"] 			= false,
		["ChatLogMaxLinesPerChat"] 			= 99,
		["HIDESCROLLBANNER"] 				= {false, 1},
--		["QUESTTRACKERRESIZE"] 				= true,
		["ThreatMeterDisplayLimit"] 		= 0,
		["ThreatMeterPosition"] 			= {372, 623},
		["GameTooltipPosition"] 			= {939, 55},
		["QuestTrackerPosition"] 			= {400, 300},
		["CastingBarPosition"] 				= {0, 0},
--		["QuestTrackerSize"] 					= {175, 200},
		["ThreatMeterAlpha"] 				= 1,
		["GameTooltipAlpha"] 				= 1,
		["QuestTrackerFontSizes"] 			= {14, 12, 10},
		["PLAYERINFO"] 						= true,
		["PLAYERINFOSAVEDATA"] 				= false,
		["extraLanguage"] 					= false
	};
    if (type(pbInfoSettings) ~= "table") then
		pbInfoSettings = pbInfo.DefaultSettings;
	else
--		pbInfoSettings = {};
		for k, v in pairs(pbInfo.DefaultSettings) do
			if (type(pbInfoSettings[k]) == "nil") then
				pbInfoSettings[k] = v;
			end;
		end;
	end;
	GameTooltip:SetBackdropTileAlpha(pbInfoSettings["GameTooltipAlpha"]);
	GameTooltip:SetBackdropEdgeAlpha(pbInfoSettings["GameTooltipAlpha"]);

	if (pbInfoSettings["extraLanguage"] ~= false) then
		pbInfo.LoadExtraLanguage(pbInfoSettings["extraLanguage"]);
	end;
	
	if (pbInfoSettings["PLAYERINFOSAVEDATA"]) then
		SaveVariables("pbInfoPlayers");
		pbInfo.PlayerDB.Players = pbInfoPlayers or {};
	end;
	if (type(pbInfo.PlayerDB.Players[pbInfo.RealmName]) ~= "table") then
		pbInfo.PlayerDB.Players[pbInfo.RealmName] = {};
	end;
end;

function pbInfo.Config.Scripts.OnLoad(this)
	this:ClearAllAnchors();
	this:SetAnchor("CENTER", "CENTER", "UIParent", 0, 0);
	pbInfoConfig_Version:SetText(										pbInfo.Version);
	pbInfoConfig_Title:SetText(											pbInfo.Locale["Config"]["Title"]);
	pbInfoConfig_TabGeneral:SetText(									pbInfo.Locale["Config"]["TabGeneral"]);
	pbInfoConfig_TabTooltip:SetText(									pbInfo.Locale["Config"]["TabTooltip"]);
	pbInfoConfig_TabTargetFrame:SetText(								pbInfo.Locale["Config"]["TabTargetFrame"]);
	pbInfoConfig_TabThreatMeter:SetText(								pbInfo.Locale["Config"]["TabThreatMeter"]);
	pbInfoConfig_TabQuestTracker:SetText(								pbInfo.Locale["Config"]["TabQuestTracker"]);
	pbInfoConfig_TabChatLog:SetText(									pbInfo.Locale["Config"]["TabChatLog"]);
	pbInfoConfig_TabCastingBar:SetText(									pbInfo.Locale["Config"]["TabCastingBar"]);
	pbInfoConfig_TabChatFrame:SetText(									pbInfo.Locale["Config"]["TabChatFrame"]);
--	pbInfoConfig_TabBloodBars:SetText(									pbInfo.Locale["Config"]["TabBloodBars"]);
	pbInfoConfig_SettingEnable_Text:SetText(							pbInfo.Locale["Config"]["SettingEnable"]);
	pbInfoConfig_SettingThousandsSeparatorFormat_Text:SetText(			pbInfo.Locale["Config"]["SettingThousandsSeparatorFormat"]);
	pbInfoConfig_SettingTimeStampFormat_Text:SetText(					pbInfo.Locale["Config"]["SettingTimeStampFormat"]);
	pbInfoConfig_SettingExtraLanguage_Text:SetText(						pbInfo.Locale["Config"]["SettingExtraLanguage"]);
	pbInfoConfig_SettingModifyTooltip_Text:SetText(						pbInfo.Locale["Config"]["SettingModifyTooltip"]);
	pbInfoConfig_SettingModifyHealthbar_Text:SetText(					pbInfo.Locale["Config"]["SettingModifyHealthbar"]);
	pbInfoConfig_SettingHealthbarShowPercentage_Text:SetText(			pbInfo.Locale["Config"]["SettingHealthbarShowPercentage"]);
	pbInfoConfig_SettingHealthbarColorFade_Text:SetText(				pbInfo.Locale["Config"]["SettingHealthBarColorFade"]);
	pbInfoConfig_SettingHealthColorFade_Text:SetText(					pbInfo.Locale["Config"]["SettingHealthColorFade"]);
	pbInfoConfig_SettingShowMana_Text:SetText(							pbInfo.Locale["Config"]["SettingShowMana"]);
--	pbInfoConfig_SettingShowDistance_Text:SetText(						pbInfo.Locale["Config"]["SettingShowDistance"]);
	pbInfoConfig_SettingTooltipShowRace_Text:SetText(					pbInfo.Locale["Config"]["SettingTooltipShowRace"]);
	pbInfoConfig_SettingTooltipShowPlayerInfo_Text:SetText(				pbInfo.Locale["Config"]["SettingTooltipShowPlayerInfo"]);
	pbInfoConfig_SettingShowMouseoverTarget_Text:SetText(				pbInfo.Locale["Config"]["SettingShowMouseoverTarget"]);
	pbInfoConfig_SettingShowClockTooltip_Text:SetText(					pbInfo.Locale["Config"]["SettingShowClockTooltip"]);
	pbInfoConfig_SettingShowMaterialInfo_Text:SetText(					pbInfo.Locale["Config"]["SettingShowMaterialInfo"]);
	pbInfoConfig_SettingShowMatInfoItemCount_Text:SetText(				pbInfo.Locale["Config"]["SettingShowMatInfoItemCount"]);
	pbInfoConfig_SettingShowMatInfoItemCountBank_Text:SetText(			pbInfo.Locale["Config"]["SettingShowMatInfoItemCountBank"]);
	pbInfoConfig_SettingShowMatInfoItemCountIV_Text:SetText(			pbInfo.Locale["Config"]["SettingShowMatInfoItemCountIV"]);
	pbInfoConfig_SettingAllNPC_Text:SetText(							pbInfo.Locale["Config"]["SettingAllNPC"]);
	pbInfoConfig_SettingStickyTooltip_Text:SetText(						pbInfo.Locale["Config"]["SettingStickyTooltip"]);
	pbInfoConfig_SettingStickyTooltip_Button:SetText(					pbInfo.Locale["Config"]["SettingStickyTooltipButton"]);
	pbInfoConfig_SettingStickyAllTooltips_Text:SetText(					pbInfo.Locale["Config"]["SettingStickyAllTooltips"]);
	pbInfoConfig_SettingGameTooltipAlpha_Text:SetText(					pbInfo.Locale["Config"]["SettingGameTooltipAlpha"]);
	pbInfoConfig_SettingThreatMeter_Text:SetText(						pbInfo.Locale["Config"]["SettingThreatMeter"]);
	pbInfoConfig_SettingThreatMeterLock_Text:SetText(					pbInfo.Locale["Config"]["SettingThreatMeterLock"]);
	pbInfoConfig_SettingThreatMeterShowTitle_Text:SetText(				pbInfo.Locale["Config"]["SettingThreatMeterShowTitle"]);
	pbInfoConfig_SettingThreatMeterAlpha_Text:SetText(					pbInfo.Locale["Config"]["SettingThreatMeterAlpha"]);
	pbInfoConfig_SettingThreatMeterDelay_Text:SetText(					pbInfo.Locale["Config"]["SettingThreatMeterDelay"]);
	pbInfoConfig_SettingThreatMeterRelativeToMaxThreat_Text:SetText(	pbInfo.Locale["Config"]["SettingThreatMeterRelativeToMaxThreat"]);
	pbInfoConfig_SettingThreatMeterShowRealThreat_Text:SetText(			pbInfo.Locale["Config"]["SettingThreatMeterShowRealThreat"]);
	pbInfoConfig_SettingThreatMeterDisplayLimit_Text:SetText(			pbInfo.Locale["Config"]["SettingThreatMeterDisplayLimit"]);
	pbInfoConfig_SettingThreatMeterHideOnNoTarget_Text:SetText(			pbInfo.Locale["Config"]["SettingThreatMeterHideOnNoTarget"]);
	pbInfoConfig_SettingThreatMeterHideOnNoParty_Text:SetText(			pbInfo.Locale["Config"]["SettingThreatMeterHideOnNoParty"]);
	pbInfoConfig_SettingThreatMeterPlayerOnTop_Text:SetText(			pbInfo.Locale["Config"]["SettingThreatMeterPlayerOnTop"]);
	pbInfoConfig_SettingThreatMeterWarnTargetTargetTarget_Text:SetText(	pbInfo.Locale["Config"]["SettingThreatMeterWarnTargetTargetTarget"]);
	pbInfoConfig_SettingModifyBloodBars_Text:SetText(					pbInfo.Locale["Config"]["SettingModifyBloodBars"]);
	pbInfoConfig_SettingBloodBarsColorFade_Text:SetText(				pbInfo.Locale["Config"]["SettingBloodBarsColorFade"]);
	pbInfoConfig_SettingBloodBarsDelay_Text:SetText(					pbInfo.Locale["Config"]["SettingBloodBarsDelay"]);
	pbInfoConfig_SettingQuestTracker_Text:SetText(						pbInfo.Locale["Config"]["SettingQuestTracker"]);
	pbInfoConfig_SettingQuestTrackerShowTitle_Text:SetText(				pbInfo.Locale["Config"]["SettingQuestTrackerShowTitle"]);
	pbInfoConfig_SettingQuestTrackerSortAsc_Text:SetText(				pbInfo.Locale["Config"]["SettingQuestTrackerSortAsc"]);
	pbInfoConfig_SettingQuestTrackerProgressColorFade_Text:SetText(		pbInfo.Locale["Config"]["SettingQuestTrackerProgressColorFade"]);
	pbInfoConfig_SettingQuestTrackerTooltip_Text:SetText(				pbInfo.Locale["Config"]["SettingQuestTrackerTooltip"]);
	pbInfoConfig_SettingQuestTrackerTooltipRight_Text:SetText(			pbInfo.Locale["Config"]["SettingQuestTrackerTooltipRight"]);
	pbInfoConfig_SettingQuestTrackerTooltipDescription_Text:SetText(	pbInfo.Locale["Config"]["SettingQuestTrackerTooltipDescription"]);
	pbInfoConfig_SettingQuestTrackerHighlightDailies_Text:SetText(		pbInfo.Locale["Config"]["SettingQuestTrackerHighlightDailies"]);
	pbInfoConfig_SettingQuestTrackerOpenQuestbook_Text:SetText(			pbInfo.Locale["Config"]["SettingQuestTrackerOpenQuestbook"]);
	pbInfoConfig_SettingQuestTrackerShowDailiesCounter_Text:SetText(	pbInfo.Locale["Config"]["SettingQuestTrackerShowDailiesCounter"]);
	pbInfoConfig_SettingQuestTrackerFontSizesTitle_Text:SetText(		pbInfo.Locale["Config"]["SettingQuestTrackerFontSizesTitle"]);
	pbInfoConfig_SettingQuestTrackerFontSizesQuestTitle_Text:SetText(	pbInfo.Locale["Config"]["SettingQuestTrackerFontSizesQuestTitle"]);
	pbInfoConfig_SettingQuestTrackerFontSizesQuestItems_Text:SetText(	pbInfo.Locale["Config"]["SettingQuestTrackerFontSizesQuestItems"]);
	pbInfoConfig_SettingQuestTrackerColors1_Text:SetText(				pbInfo.Locale["Config"]["SettingQuestTrackerColorsDailyQuest"]);
	pbInfoConfig_SettingChatLog_Text:SetText(							pbInfo.Locale["Config"]["SettingChatLog"]);
	pbInfoConfig_SettingChatLogMaxLinesPerChat_Text:SetText(			pbInfo.Locale["Config"]["SettingChatLogMaxLinesPerChat"]);
	pbInfoConfig_SettingChatFrameFilterTitles_Text:SetText(				pbInfo.Locale["Config"]["SettingChatFrameFilterTitles"]);
	pbInfoConfig_SettingChatFrameFilterXPTP_Text:SetText(				pbInfo.Locale["Config"]["SettingChatFrameFilterXPTP"]);
	pbInfoConfig_SettingChatFrameFilterXPTPDebt_Text:SetText(			pbInfo.Locale["Config"]["SettingChatFrameFilterXPTPDebt"]);
	pbInfoConfig_SettingChatFrameFilterProgress_Text:SetText(			pbInfo.Locale["Config"]["SettingChatFrameFilterProgress"]); -- Changed: remove all progress messages
	pbInfoConfig_SettingChatFrameFilterProgressGather_Text:SetText(		pbInfo.Locale["Config"]["SettingChatFrameFilterProgressGather"]); -- added: gathering only
	pbInfoConfig_SettingChatFrameShowPlayerInfo_Text:SetText(			pbInfo.Locale["Config"]["SettingChatFrameShowPlayerInfo"]);
	pbInfoConfig_SettingTimeStamp_Text:SetText(							pbInfo.Locale["Config"]["SettingTimeStamp"]);
	pbInfoConfig_SettingTimeStampNotInCombatLog_Text:SetText(			pbInfo.Locale["Config"]["SettingTimeStampNotInCombatLog"]);
	pbInfoConfig_SettingAutoRepairAll_Text:SetText(						pbInfo.Locale["Config"]["SettingAutoRepairAll"]);
--	pbInfoConfig_SettingCastingBarMoveOnLoad_Text:SetText(				pbInfo.Locale["Config"]["SettingCastingBarMoveOnLoad"]);
	pbInfoConfig_SettingCastingBarShowCastTime_Text:SetText(			pbInfo.Locale["Config"]["SettingCastingBarShowCastTime"]);
	pbInfoConfig_SettingCastingBar_Button:SetText(						pbInfo.Locale["Config"]["SettingCastingBarButton"]);
	pbInfoConfig_ResetButton:SetText(									pbInfo.Locale["Config"]["ResetButton"]);
	pbInfoConfig_SaveButton:SetText(									pbInfo.Locale["Config"]["SaveButton"]);
	pbInfoConfig_CloseButton:SetText(									pbInfo.Locale["Config"]["CloseButton"]);
	pbInfoConfig_SettingThreatMeterDelay:SetValueStepMode("FLOAT");
	pbInfoConfig_SettingThreatMeterDelay:SetMinMaxValues(0.5, 1.0);
	pbInfoConfig_SettingBloodBarsDelay:SetValueStepMode("FLOAT");
	pbInfoConfig_SettingBloodBarsDelay:SetMinMaxValues(0.05, 1.0);
	pbInfoConfig_SettingQuestTrackerFontSizesTitle:SetValueStepMode("INT");
	pbInfoConfig_SettingQuestTrackerFontSizesTitle:SetMinMaxValues(8, 16);
	pbInfoConfig_SettingQuestTrackerFontSizesQuestTitle:SetValueStepMode("INT");
	pbInfoConfig_SettingQuestTrackerFontSizesQuestTitle:SetMinMaxValues(8, 16);
	pbInfoConfig_SettingQuestTrackerFontSizesQuestItems:SetValueStepMode("INT");
	pbInfoConfig_SettingQuestTrackerFontSizesQuestItems:SetMinMaxValues(8, 16);
	pbInfo.Config.Scripts.OnShow();
end;

function pbInfo.Config.Scripts.OnShow()
	pbInfoConfig_SettingEnable:SetChecked(							(pbInfoSettings["ENABLE"] 							and 1) or nil);
	pbInfoConfig_SettingModifyTooltip:SetChecked(					(pbInfoSettings["MODIFYTOOLTIP"] 					and 1) or nil);
	pbInfoConfig_SettingModifyHealthbar:SetChecked(					(pbInfoSettings["MODIFYHEALTHBAR"] 					and 1) or nil);
	pbInfoConfig_SettingHealthbarShowPercentage:SetChecked(			(pbInfoSettings["HEALTHBARSHOWPERCENTAGE"] 			and 1) or nil);
	pbInfoConfig_SettingHealthbarColorFade:SetChecked(				(pbInfoSettings["HEALTHBARCOLORFADE"] 				and 1) or nil);
	pbInfoConfig_SettingHealthColorFade:SetChecked(					(pbInfoSettings["HEALTHCOLORFADE"] 					and 1) or nil);
	pbInfoConfig_SettingShowMana:SetChecked(						(pbInfoSettings["SHOWMANA"] 						and 1) or nil);
--	pbInfoConfig_SettingShowDistance:SetChecked(					(pbInfoSettings["SHOWDISTANCE"] 					and 1) or nil);
	pbInfoConfig_SettingTooltipShowRace:SetChecked(					(pbInfoSettings["TOOLTIPSHOWRACE"] 					and 1) or nil);
	pbInfoConfig_SettingTooltipShowPlayerInfo:SetChecked(			(pbInfoSettings["TOOLTIPSHOWPLAYERINFO"] 			and 1) or nil);
	pbInfoConfig_SettingShowMouseoverTarget:SetChecked(				(pbInfoSettings["SHOWMOUSEOVERTARGET"] 				and 1) or nil);
	pbInfoConfig_SettingShowClockTooltip:SetChecked(				(pbInfoSettings["SHOWCLOCKTOOLTIP"] 				and 1) or nil);
	pbInfoConfig_SettingShowMaterialInfo:SetChecked(				(pbInfoSettings["SHOWMATERIALINFO"] 				and 1) or nil);
	pbInfoConfig_SettingShowMatInfoItemCount:SetChecked(			(pbInfoSettings["MATINFOITEMCOUNT"] 				and 1) or nil);
	pbInfoConfig_SettingShowMatInfoItemCountBank:SetChecked(		(pbInfoSettings["MATINFOITEMCOUNTBANK"] 			and 1) or nil);
	pbInfoConfig_SettingShowMatInfoItemCountIV:SetChecked(			(pbInfoSettings["MATINFOITEMCOUNTIV"] 				and 1) or nil);
	pbInfoConfig_SettingAllNPC:SetChecked(							(pbInfoSettings["ALLNPC"] 							and 1) or nil);
	pbInfoConfig_SettingStickyTooltip:SetChecked(					(pbInfoSettings["STICKYTOOLTIP"] 					and 1) or nil);
	pbInfoConfig_SettingStickyAllTooltips:SetChecked(				(pbInfoSettings["STICKYALLTOOLTIPS"] 				and 1) or nil);
	pbInfoConfig_SettingThreatMeter:SetChecked(						(pbInfoSettings["THREATMETER"] 						and 1) or nil);
	pbInfoConfig_SettingThreatMeterLock:SetChecked(					(pbInfoSettings["THREATMETERLOCK"] 					and 1) or nil);
	pbInfoConfig_SettingThreatMeterShowTitle:SetChecked(			(pbInfoSettings["THREATMETERSHOWTITLE"] 			and 1) or nil);
	pbInfoConfig_SettingThreatMeterHideOnNoTarget:SetChecked( 		(pbInfoSettings["THREATMETERHIDEONNOTARGET"] 		and 1) or nil);
	pbInfoConfig_SettingThreatMeterHideOnNoParty:SetChecked( 		(pbInfoSettings["THREATMETERHIDEONNOPARTY"] 		and 1) or nil);
	pbInfoConfig_SettingThreatMeterPlayerOnTop:SetChecked( 			(pbInfoSettings["THREATMETERPLAYERONTOP"] 			and 1) or nil);
	pbInfoConfig_SettingThreatMeterWarnTargetTargetTarget:SetChecked((pbInfoSettings["THREATMETEWARNTARGETTARGETTARGET"] and 1) or nil);
	pbInfoConfig_SettingThreatMeterRelativeToMaxThreat:SetChecked(	(pbInfoSettings["THREATMETERRELATIVETOMAXTHREAT"] 	and 1) or nil);
	pbInfoConfig_SettingThreatMeterShowRealThreat:SetChecked(		(pbInfoSettings["THREATMETERSHOWREALTHREAT"] 		and 1) or nil);
	pbInfoConfig_SettingModifyBloodBars:SetChecked(					(pbInfoSettings["MODIFYBLOODBARS"] 					and 1) or nil);
	pbInfoConfig_SettingBloodBarsColorFade:SetChecked(				(pbInfoSettings["BLOODBARSCOLORFADE"] 				and 1) or nil);
	pbInfoConfig_SettingQuestTracker:SetChecked(					(pbInfoSettings["QUESTTRACKER"] 					and 1) or nil);
	pbInfoConfig_SettingQuestTrackerShowTitle:SetChecked(			(pbInfoSettings["QUESTTRACKERSHOWTITLE"] 			and 1) or nil);
	pbInfoConfig_SettingQuestTrackerSortAsc:SetChecked(				(pbInfoSettings["QUESTTRACKERSORTASC"] 				and 1) or nil);
	pbInfoConfig_SettingQuestTrackerProgressColorFade:SetChecked(	(pbInfoSettings["QUESTTRACKERPROGRESSCOLORFADE"] 	and 1) or nil);
	pbInfoConfig_SettingQuestTrackerTooltip:SetChecked(				(pbInfoSettings["QUESTTRACKERTOOLTIP"] 				and 1) or nil);
	pbInfoConfig_SettingQuestTrackerTooltipRight:SetChecked(		(pbInfoSettings["QUESTTRACKERTOOLTIPRIGHT"] 		and 1) or nil);
	pbInfoConfig_SettingQuestTrackerTooltipDescription:SetChecked(	(pbInfoSettings["QUESTTRACKERTOOLTIPDESCRIPTION"] 	and 1) or nil);
	pbInfoConfig_SettingQuestTrackerHighlightDailies:SetChecked(	(pbInfoSettings["QUESTTRACKERHIGHLIGHTDAILIES"] 	and 1) or nil);
	pbInfoConfig_SettingQuestTrackerOpenQuestbook:SetChecked(		(pbInfoSettings["QUESTTRACKEROPENQUESTBOOK"] 		and 1) or nil);
	pbInfoConfig_SettingQuestTrackerShowDailiesCounter:SetChecked(	(pbInfoSettings["QUESTTRACKERSHOWDAILIESCOUNTER"] 	and 1) or nil);
	pbInfoConfig_SettingChatLog:SetChecked(							(pbInfoSettings["CHATLOG"] 							and 1) or nil);
	pbInfoConfig_SettingChatFrameFilterTitles:SetChecked(			(pbInfoSettings["CHATFRAMEFILTERTITLES"] 			and 1) or nil);
	pbInfoConfig_SettingChatFrameFilterXPTP:SetChecked(				(pbInfoSettings["CHATFRAMEHIDEXPTP"] 				and 1) or nil);
	pbInfoConfig_SettingChatFrameFilterXPTPDebt:SetChecked(			(pbInfoSettings["CHATFRAMEHIDEXPTPDEBT"] 			and 1) or nil);
	pbInfoConfig_SettingChatFrameFilterProgress:SetChecked(			(pbInfoSettings["CHATFRAMEHIDEPROGRESS"]			and 1) or nil); -- Changed: remove all progress messages
	pbInfoConfig_SettingChatFrameFilterProgressGather:SetChecked(	(pbInfoSettings["CHATFRAMEHIDEPROGRESSGATHER"]		and 1) or nil); -- Added: gathering only
	pbInfoConfig_SettingChatFrameShowPlayerInfo:SetChecked(			(pbInfoSettings["CHATFRAMESHOWPLAYERINFO"] 			and 1) or nil);
	pbInfoConfig_SettingTimeStamp:SetChecked(						(pbInfoSettings["TIMESTAMP"] 						and 1) or nil);
	pbInfoConfig_SettingTimeStampNotInCombatLog:SetChecked(			(pbInfoSettings["TIMESTAMPNOTINCOMBATLOG"] 			and 1) or nil);
	pbInfoConfig_SettingAutoRepairAll:SetChecked(					(pbInfoSettings["AUTOREPAIRALL"] 					and 1) or nil);
	pbInfoConfig_SettingCastingBarMoveOnLoad:SetChecked(			(pbInfoSettings["CASTINGBARMOVEONLOAD"] 			and 1) or nil);
	pbInfoConfig_SettingCastingBarShowCastTime:SetChecked(			(pbInfoSettings["CASTINGBARSHOWCASTTIME"] 			and 1) or nil);
	pbInfoConfig_SettingChatLogMaxLinesPerChat:SetText(				tonumber(pbInfoSettings["ChatLogMaxLinesPerChat"]));
	pbInfoConfig_SettingGameTooltipAlpha:SetText(					tonumber(100 - (pbInfoSettings["GameTooltipAlpha"] 	* 100)));
	pbInfoConfig_SettingThreatMeterAlpha:SetText(					tonumber(100 - (pbInfoSettings["ThreatMeterAlpha"] 	* 100)));
	pbInfoConfig_SettingThreatMeterDisplayLimit:SetText(			tonumber(pbInfoSettings["ThreatMeterDisplayLimit"]));
	pbInfoConfig_SettingThreatMeterDelay:SetValue(					tonumber(pbInfoSettings["ThreatMeterDelay"]));
	pbInfoConfig_SettingBloodBarsDelay:SetValue(					tonumber(pbInfoSettings["BloodBarsDelay"]));
	pbInfoConfig_SettingQuestTrackerFontSizesTitle:SetValue(		tonumber(pbInfoSettings["QuestTrackerFontSizes"][1]));
	pbInfoConfig_SettingQuestTrackerFontSizesQuestTitle:SetValue(	tonumber(pbInfoSettings["QuestTrackerFontSizes"][2]));
	pbInfoConfig_SettingQuestTrackerFontSizesQuestItems:SetValue(	tonumber(pbInfoSettings["QuestTrackerFontSizes"][3]));
	UIDropDownMenu_SetSelectedID(pbInfoConfig_SettingExtraLanguage, pbInfo.Config.GetLanguageId(pbInfoSettings["extraLanguage"]));
	pbInfoConfig_SettingExtraLanguageText:SetText(pbInfoSettings["extraLanguage"] or "Default");
	UIDropDownMenu_SetSelectedID(pbInfoConfig_SettingTimeStampFormat, pbInfo.Config.GetTimeStampFormatId(pbInfoSettings["TimeStampFormat"]));
	pbInfoConfig_SettingTimeStampFormatText:SetText(pbInfoSettings["TimeStampFormat"]);
	UIDropDownMenu_SetSelectedID(pbInfoConfig_SettingThousandsSeparatorFormat, pbInfo.Config.GetThousandsSeparatorFormatId(pbInfoSettings["ThousandsSeparatorFormat"]));
	pbInfoConfig_SettingThousandsSeparatorFormatText:SetText(pbInfoSettings["ThousandsSeparatorFormat"]);
	for id, colors in pairs(pbInfoSettings["QuestTrackerColors"]) do
		local r, g, b = unpack(colors);
		_G["pbInfoConfig_SettingQuestTrackerColors" .. id .. "ButtonBlock"]:SetColor(r, g, b);
	end;
end;
function pbInfo.Config.TabClick()
	pbInfoConfig_PageGeneral:Hide();
	pbInfoConfig_PageTooltip:Hide();
	pbInfoConfig_PageTooltip2:Hide();
	pbInfoConfig_PageTargetFrame:Hide();
	pbInfoConfig_PageBloodBars:Hide();
	pbInfoConfig_PageThreatMeter:Hide();
	pbInfoConfig_PageQuestTracker:Hide();
	pbInfoConfig_PageQuestTracker2:Hide();
	pbInfoConfig_PageChatLog:Hide();
	pbInfoConfig_PageChatFrame:Hide();
	pbInfoConfig_PageCastingBar:Hide();
end;
function pbInfo.Config.Save()
	pbInfoSettings["ENABLE"]						= (pbInfoConfig_SettingEnable:IsChecked() 							and true) or false;
	pbInfoSettings["MODIFYTOOLTIP"] 				= (pbInfoConfig_SettingModifyTooltip:IsChecked() 					and true) or false;
	pbInfoSettings["MODIFYHEALTHBAR"] 				= (pbInfoConfig_SettingModifyHealthbar:IsChecked() 					and true) or false;
	pbInfoSettings["HEALTHBARSHOWPERCENTAGE"] 		= (pbInfoConfig_SettingHealthbarShowPercentage:IsChecked() 			and true) or false;
	pbInfoSettings["HEALTHBARCOLORFADE"]			= (pbInfoConfig_SettingHealthbarColorFade:IsChecked() 				and true) or false;
	pbInfoSettings["HEALTHCOLORFADE"]				= (pbInfoConfig_SettingHealthColorFade:IsChecked() 					and true) or false;
	pbInfoSettings["SHOWMANA"]						= (pbInfoConfig_SettingShowMana:IsChecked() 						and true) or false;
--	pbInfoSettings["SHOWDISTANCE"]						= (pbInfoConfig_SettingShowDistance:IsChecked() 					and true) or false;
	pbInfoSettings["TOOLTIPSHOWRACE"]				= (pbInfoConfig_SettingTooltipShowRace:IsChecked() 						and true) or false;
	pbInfoSettings["TOOLTIPSHOWPLAYERINFO"]			= (pbInfoConfig_SettingTooltipShowPlayerInfo:IsChecked() 			and true) or false;
	pbInfoSettings["SHOWMOUSEOVERTARGET"]			= (pbInfoConfig_SettingShowMouseoverTarget:IsChecked() 				and true) or false;
	pbInfoSettings["SHOWCLOCKTOOLTIP"]				= (pbInfoConfig_SettingShowClockTooltip:IsChecked() 				and true) or false;
	pbInfoSettings["SHOWMATERIALINFO"]				= (pbInfoConfig_SettingShowMaterialInfo:IsChecked() 				and true) or false;
	pbInfoSettings["MATINFOITEMCOUNT"]				= (pbInfoConfig_SettingShowMatInfoItemCount:IsChecked() 			and true) or false;
	pbInfoSettings["MATINFOITEMCOUNTBANK"]			= (pbInfoConfig_SettingShowMatInfoItemCountBank:IsChecked() 		and true) or false;
	pbInfoSettings["MATINFOITEMCOUNTIV"]			= (pbInfoConfig_SettingShowMatInfoItemCountIV:IsChecked() 			and true) or false;
	pbInfoSettings["ALLNPC"]						= (pbInfoConfig_SettingAllNPC:IsChecked() 							and true) or false;
	pbInfoSettings["STICKYTOOLTIP"]					= (pbInfoConfig_SettingStickyTooltip:IsChecked() 					and true) or false;
	pbInfoSettings["STICKYALLTOOLTIPS"]				= (pbInfoConfig_SettingStickyAllTooltips:IsChecked() 				and true) or false;
	pbInfoSettings["THREATMETER"]					= (pbInfoConfig_SettingThreatMeter:IsChecked() 						and true) or false;
	pbInfoSettings["THREATMETERLOCK"]				= (pbInfoConfig_SettingThreatMeterLock:IsChecked() 					and true) or false;
	pbInfoSettings["THREATMETERSHOWTITLE"]			= (pbInfoConfig_SettingThreatMeterShowTitle:IsChecked() 			and true) or false;
	pbInfoSettings["THREATMETERHIDEONNOTARGET"]		= (pbInfoConfig_SettingThreatMeterHideOnNoTarget:IsChecked()		and true) or false;
	pbInfoSettings["THREATMETERHIDEONNOPARTY"]		= (pbInfoConfig_SettingThreatMeterHideOnNoParty:IsChecked() 		and true) or false;
	pbInfoSettings["THREATMETERPLAYERONTOP"]		= (pbInfoConfig_SettingThreatMeterPlayerOnTop:IsChecked() 			and true) or false;
	pbInfoSettings["THREATMETEWARNTARGETTARGETTARGET"]= (pbInfoConfig_SettingThreatMeterWarnTargetTargetTarget:IsChecked() and true) or false;
	pbInfoSettings["THREATMETERRELATIVETOMAXTHREAT"]= (pbInfoConfig_SettingThreatMeterRelativeToMaxThreat:IsChecked() 	and true) or false;
	pbInfoSettings["THREATMETERSHOWREALTHREAT"] 	= (pbInfoConfig_SettingThreatMeterShowRealThreat:IsChecked() 		and true) or false;
	pbInfoSettings["MODIFYBLOODBARS"] 				= (pbInfoConfig_SettingModifyBloodBars:IsChecked() 					and true) or false;
	pbInfoSettings["BLOODBARSCOLORFADE"] 			= (pbInfoConfig_SettingBloodBarsColorFade:IsChecked() 				and true) or false;
	pbInfoSettings["QUESTTRACKER"] 					= (pbInfoConfig_SettingQuestTracker:IsChecked() 					and true) or false;
	pbInfoSettings["QUESTTRACKERSHOWTITLE"] 		= (pbInfoConfig_SettingQuestTrackerShowTitle:IsChecked() 			and true) or false;
	pbInfoSettings["QUESTTRACKERSORTASC"] 			= (pbInfoConfig_SettingQuestTrackerSortAsc:IsChecked() 				and true) or false;
	pbInfoSettings["QUESTTRACKERPROGRESSCOLORFADE"] = (pbInfoConfig_SettingQuestTrackerProgressColorFade:IsChecked() 	and true) or false;
	pbInfoSettings["QUESTTRACKERTOOLTIP"] 			= (pbInfoConfig_SettingQuestTrackerTooltip:IsChecked() 				and true) or false;
	pbInfoSettings["QUESTTRACKERTOOLTIPRIGHT"] 		= (pbInfoConfig_SettingQuestTrackerTooltipRight:IsChecked() 		and true) or false;
	pbInfoSettings["QUESTTRACKERTOOLTIPDESCRIPTION"]= (pbInfoConfig_SettingQuestTrackerTooltipDescription:IsChecked() 	and true) or false;
	pbInfoSettings["QUESTTRACKERHIGHLIGHTDAILIES"]	= (pbInfoConfig_SettingQuestTrackerHighlightDailies:IsChecked() 	and true) or false;
	pbInfoSettings["QUESTTRACKEROPENQUESTBOOK"]		= (pbInfoConfig_SettingQuestTrackerOpenQuestbook:IsChecked() 		and true) or false;
	pbInfoSettings["QUESTTRACKERSHOWDAILIESCOUNTER"]= (pbInfoConfig_SettingQuestTrackerShowDailiesCounter:IsChecked() 	and true) or false;
	pbInfoSettings["CHATLOG"] 						= (pbInfoConfig_SettingChatLog:IsChecked() 							and true) or false;
	pbInfoSettings["CHATFRAMEFILTERTITLES"] 		= (pbInfoConfig_SettingChatFrameFilterTitles:IsChecked() 			and true) or false;
	pbInfoSettings["CHATFRAMEHIDEXPTP"] 			= (pbInfoConfig_SettingChatFrameFilterXPTP:IsChecked() 				and true) or false;
	pbInfoSettings["CHATFRAMEHIDEXPTPDEBT"] 		= (pbInfoConfig_SettingChatFrameFilterXPTPDebt:IsChecked() 			and true) or false;
	pbInfoSettings["CHATFRAMEHIDEPROGRESS"] 		= (pbInfoConfig_SettingChatFrameFilterProgress:IsChecked() 			and true) or false;
	pbInfoSettings["CHATFRAMEHIDEPROGRESSGATHER"] 	= (pbInfoConfig_SettingChatFrameFilterProgressGather:IsChecked() 	and true) or false;
	pbInfoSettings["CHATFRAMESHOWPLAYERINFO"] 		= (pbInfoConfig_SettingChatFrameShowPlayerInfo:IsChecked() 			and true) or false;
	pbInfoSettings["TIMESTAMP"] 					= (pbInfoConfig_SettingTimeStamp:IsChecked() 						and true) or false;
	pbInfoSettings["TIMESTAMPNOTINCOMBATLOG"] 		= (pbInfoConfig_SettingTimeStampNotInCombatLog:IsChecked() 			and true) or false;
	pbInfoSettings["AUTOREPAIRALL"] 				= (pbInfoConfig_SettingAutoRepairAll:IsChecked() 					and true) or false;
	pbInfoSettings["CASTINGBARMOVEONLOAD"] 			= (pbInfoConfig_SettingCastingBarMoveOnLoad:IsChecked() 			and true) or false;
	pbInfoSettings["CASTINGBARSHOWCASTTIME"] 		= (pbInfoConfig_SettingCastingBarShowCastTime:IsChecked() 			and true) or false;
	
	-- more tricky options
	local alpha = 100 - tonumber(pbInfoConfig_SettingGameTooltipAlpha:GetText());
	if (pbIsEmpty(alpha) or alpha < 0 or alpha > 100) then alpha = 100 end;
	pbInfoSettings["GameTooltipAlpha"] = alpha / 100;
	
	alpha = 100 - tonumber(pbInfoConfig_SettingThreatMeterAlpha:GetText());
	if (pbIsEmpty(alpha) or alpha < 0 or alpha > 100) then alpha = 100 end;
	pbInfoSettings["ThreatMeterAlpha"] = alpha / 100;

	local limit = tonumber(pbInfoConfig_SettingThreatMeterDisplayLimit:GetText());
	if (pbIsEmpty(limit) or limit < 0 or limit > 100) then limit = 0 end;
	pbInfoSettings["ThreatMeterDisplayLimit"] = limit;
	
	pbInfoSettings["ThreatMeterDelay"] = math.floor(tonumber(pbInfoConfig_SettingThreatMeterDelay:GetValue()) * 100) / 100;
	pbInfoSettings["BloodBarsDelay"] = math.floor(tonumber(pbInfoConfig_SettingBloodBarsDelay:GetValue()) * 100) / 100;
	pbInfoSettings["QuestTrackerFontSizes"] = {pbInfoConfig_SettingQuestTrackerFontSizesTitle:GetValue(), pbInfoConfig_SettingQuestTrackerFontSizesQuestTitle:GetValue(), pbInfoConfig_SettingQuestTrackerFontSizesQuestItems:GetValue()};
	
	pbInfoSettings["ChatLogMaxLinesPerChat"] = tonumber(pbInfoConfig_SettingChatLogMaxLinesPerChat:GetText());
	
	local langId = UIDropDownMenu_GetSelectedID(pbInfoConfig_SettingExtraLanguage);
	pbInfoSettings["extraLanguage"] = (langId > 1 and pbInfo.Languages[langId]) or false;
	
	pbInfoSettings["TimeStampFormat"] = pbInfoConfig_SettingTimeStampFormatText:GetText();
	
	pbInfoSettings["ThousandsSeparatorFormat"] = pbInfoConfig_SettingThousandsSeparatorFormatText:GetText();
	
	-- apply changes
	pbInfo.LoadExtraLanguage(pbInfoSettings["extraLanguage"] or pbInfo.Language);
	GameTooltip:SetBackdropTileAlpha(pbInfoSettings["GameTooltipAlpha"]);
	GameTooltip:SetBackdropEdgeAlpha(pbInfoSettings["GameTooltipAlpha"]);

	if (pbInfoSettings["QUESTTRACKER"] == false or pbInfoSettings["ENABLE"] == false) then
		pbInfoQuestTracker:Hide();
--		MinimapFrameQuestTrackButton:SetChecked(false);
--		MinimapFrameQuestTrackButton:Hide();
	else
		pbInfo.QuestTracker.Scripts.OnLoad(pbInfoQuestTracker);
		pbInfoQuestTracker:Show();
--		QuestTrackerFrame:Hide(); --original RoM QuestTrack
		pbInfo.QuestTracker.UpdateTrackerQuests();
		pbInfo.QuestTracker.UpdateTracker();
--		if (GetQuestTrack(-1) == 0) then		
--			MinimapFrameQuestTrackButton:SetChecked(false);
--			MinimapFrameQuestTrackButton:Hide();
--		else
--			MinimapFrameQuestTrackButton:SetChecked( true );
--			MinimapFrameQuestTrackButton:Show();
--		end;
	end;
	
	if (pbInfoSettings["CASTINGBARSHOWCASTTIME"] == false and not CastingBarText:IsVisible()) then
		CastingBarText:Show()
	end;

	if (pbInfoSettings["PLAYERINFOSAVEDATA"]) then
		SaveVariables("pbInfoPlayers");
	else 
		pbInfoPlayers = nil;
	end;
	pbInfo.Config.Scripts.OnLoad(pbInfoConfig);
	pbInfo.LoadScripts();
--	pbInfoConfig:Show();
end;

function pbInfo.Config.LoadColorPicker(button)
	local id = button:GetParent():GetID();
	pbInfo.Config.ColorPickerId = id;
	local r, g, b = unpack(pbInfoSettings["QuestTrackerColors"][id]);
	OpenColorPickerFrame(pbInfo.Config.SaveColorPicker, false, "pbInfo - " .. _G[button:GetParent():GetName() .. "_Text"]:GetText(), r, g, b, 1, pbInfoConfig);
end;

function pbInfo.Config.SaveColorPicker()
	local id = pbInfo.Config.ColorPickerId;
	local r, g, b = ColorPickerFrame.r, ColorPickerFrame.g, ColorPickerFrame.b;
	pbInfoSettings["QuestTrackerColors"][id] = {r, g, b};
	_G["pbInfoConfig_SettingQuestTrackerColors" .. id .. "ButtonBlock"]:SetColor(r, g, b);
end;

function pbInfo.LoadScripts()
	pbInfo.BloodBars.Scripts.OnLoad();
	pbInfo.ChatLog.Scripts.OnLoad();
	pbInfo.TargetFrame.Scripts.OnLoad();
	pbInfo.Tooltip.Scripts.OnLoad();
	pbInfo.ThreatMeter.Scripts.OnLoad();
end;

function pbInfo.LoadExtraLanguage(lang)
	if (not pbIsEmpty(lang) and type(loadfile(pbInfo.Directory .. "Locales/lang." .. lang .. ".lua")) == "function") then
		pbLoadFile(pbInfo.Directory .. "Locales/lang." .. lang .. ".lua");
	end;
end;

function pbInfo.Config.LanguageDropDownShow()
	for _, v in pairs(pbInfo.Languages) do
		UIDropDownMenu_AddButton({["text"] = v, ["func"] = pbInfo.Config.LanguageDropDownClick})
	end;
end;
function pbInfo.Config.LanguageDropDownClick(button)
    UIDropDownMenu_SetSelectedID(pbInfoConfig_SettingExtraLanguage, button:GetID())
end
function pbInfo.Config.GetLanguageId(value)
	for i, v in pairs(pbInfo.Languages) do
		if (v == value) then return i; end;
	end;
	return 1;
end

function pbInfo.Config.TimeStampFormatDropDownShow()
	for _, v in pairs(pbInfo.TimeStampFormats) do
		UIDropDownMenu_AddButton({["text"] = v, ["func"] = pbInfo.Config.TimeStampFormatDropDownClick})
	end;
end;
function pbInfo.Config.TimeStampFormatDropDownClick(button)
    UIDropDownMenu_SetSelectedID(pbInfoConfig_SettingTimeStampFormat, button:GetID())
end
function pbInfo.Config.GetTimeStampFormatId(value)
	for i, v in pairs(pbInfo.TimeStampFormats) do
		if (v == value) then return i; end;
	end;
	return 1;
end

function pbInfo.Config.ThousandsSeparatorFormatDropDownShow()
	for _, v in pairs(pbInfo.ThousandsSeparatorFormats) do
		UIDropDownMenu_AddButton({["text"] = v, ["func"] = pbInfo.Config.ThousandsSeparatorFormatDropDownClick})
	end;
end;
function pbInfo.Config.ThousandsSeparatorFormatDropDownClick(button)
    UIDropDownMenu_SetSelectedID(pbInfoConfig_SettingThousandsSeparatorFormat, button:GetID())
end
function pbInfo.Config.GetThousandsSeparatorFormatId(value)
	for i, v in pairs(pbInfo.ThousandsSeparatorFormats) do
		if (v == value) then return i; end;
	end;
	return 1;
end


function pbInfo.Config.Hide()
	pbInfo.Config.TabClick();
	pbInfoConfig:Hide();
end;
function pbInfo.Config.Reset()
	pbInfoSettings = {};
--[[	for k, v in pairs(pbInfo.DefaultSettings) do
		pbInfoSettings[k] = v;
	end; ]]
	table.copy(pbInfoSettings, pbInfo.DefaultSettings);
	pbInfo.Config.Scripts.OnLoad(pbInfoConfig);
	pbInfo.Config.Save();
end;

function pbInfo.CharData.Scripts.OnLoad(name)
	if (os and os.date and os.time) then
		if(type(pbInfoCharData[pbInfo.Account]) ~= "table") then
			pbInfoCharData[pbInfo.Account] = {};
		end;
		if(type(pbInfoCharData[pbInfo.Account][pbInfo.RealmName]) ~= "table") then
			pbInfoCharData[pbInfo.Account][pbInfo.RealmName] = {};
		end;
		
		local defaults = {
			["DAILIES"] = {10, 0};
		}
	    if (type(pbInfoCharData[pbInfo.Account][pbInfo.RealmName][name]) ~= "table") then
			pbInfoCharData[pbInfo.Account][pbInfo.RealmName][name] = defaults;
		else
			for k, v in pairs(defaults) do
				if (type(pbInfoCharData[pbInfo.Account][pbInfo.RealmName][name][k]) == "nil") then
					pbInfoCharData[pbInfo.Account][pbInfo.RealmName][name][k] = v;
				end;
			end;
		end;
		
		pbInfo.CharData.Loaded = true;
		pbInfoCharDataTimer:Hide();
	
		pbInfo.QuestTracker.CheckDailyQuests("startup");
		pbInfoQuestTracker_Dailies:SetText(pbInfoCharData[pbInfo.Account][pbInfo.RealmName][name]["DAILIES"][1] .. "/10");
	end;
end;

function pbInfo.Config.Scripts.OnClick_MinimapButton()
	PlaySoundByPath("sound\\interface\\ui_generic_click.mp3");
    if (pbInfoConfig:IsVisible()) then
        pbInfoConfig:Hide()
    else
        pbInfoConfig:Show()
		PlaySoundByPath("sound\\interface\\ui_generic_open.mp3");
    end;
end;

function pbInfo.ToggleConfig(ebox, text)
	pbInfoConfig:Show();
end;
SLASH_pbInfoToggleConfig1 = "/pbinfoconfig";
SLASH_pbInfoToggleConfig2 = "/pbic";
SlashCmdList["pbInfoToggleConfig"] = pbInfo.ToggleConfig;