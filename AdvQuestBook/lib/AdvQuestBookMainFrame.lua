--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
function AdvQuestBook_UIAdjust()
	local opt;
	if (AQB_LOCAL == "DE" or AQB_LOCAL == "ES" or AQB_LOCAL == "FR") then
		opt = getglobal("AdvQuestBookConfigMiniToggle");
		opt:ClearAllAnchors();
		if (AQB_LOCAL == "FR") then
			opt:SetAnchor("LEFT", "TOPRIGHT", "AdvQuestBookConfig", -175, 60);
		else
			opt:SetAnchor("LEFT", "TOPRIGHT", "AdvQuestBookConfig", -200, 60);
		end
		opt = getglobal("AdvQuestBookConfigReloadUI");
		opt:ClearAllAnchors();
		opt:SetAnchor("LEFT", "BOTTOMLEFT", "AdvQuestBookConfig", 10, -50);
		AdvQuestBookMainFrameSearchResultsTitle:SetText("");
		opt = getglobal("AdvQuestBookMainFrameSearchResultsTitle");
		opt:ClearAllAnchors();
		if (AQB_LOCAL == "DE") then
			opt:SetAnchor("RIGHT", "TOPRIGHT", "AdvQuestBookMainFrameSearchResults", -50, 15);
		else
			opt:SetAnchor("RIGHT", "TOPRIGHT", "AdvQuestBookMainFrameSearchResults", -15, 15);
		end
		AdvQuestBookMainFrameSearchResultsTitle:SetText(AQB_XML_SEARCHRES);
		AdvQuestBookMainFrameShareButton:SetText("");
		opt = getglobal("AdvQuestBookMainFrameShareButton");
		opt:ClearAllAnchors();
		if (AQB_LOCAL == "DE") then
			opt:SetSize(155, 20);
		else
			opt:SetSize(130, 20);
		end
		if (AQB_LOCAL == "FR") then
			opt:SetAnchor("LEFT", "TOPLEFT", "AdvQuestBookMainFrameSearchResults", 14, 17);
		else
			opt:SetAnchor("LEFT", "TOPLEFT", "AdvQuestBookMainFrameSearchResults", 20, 17);
		end
		AdvQuestBookMainFrameShareButton:SetText(AQB_XML_HIDESHARE);
		AdvQuestBookMainFrameShareResultsTitle:SetText("");
		opt = getglobal("AdvQuestBookMainFrameShareResultsTitle");
		opt:ClearAllAnchors();
		opt:SetAnchor("RIGHT", "TOPRIGHT", "AdvQuestBookMainFrameShareQuestResults", -18, 15);
		AdvQuestBookMainFrameShareResultsTitle:SetText(AQB_XML_SHARERES);
	elseif (AQB_LOCAL == "BR" or AQB_LOCAL == "SAPT") then
		opt = getglobal("AdvQuestBookMainFrameShareButton");
		opt:SetText("");
		opt:SetSize(140, 20);
		opt:SetText(AQB_XML_SHOWSHARE);
		opt = getglobal("AdvQuestBookMainFrameSearchResultsTitle");
		opt:ClearAllAnchors();
		opt:SetAnchor("LEFT", "RIGHT", "AdvQuestBookMainFrameShareButton", 5, 0);
		opt:SetText(AQB_XML_SEARCHRES);
		opt = getglobal("AdvQuestBookMainFrameShareResultsTitle");
		opt:ClearAllAnchors();
		opt:SetAnchor("LEFT", "RIGHT", "AdvQuestBookMainFrameShareButton", 5, 0);
		opt:SetText(AQB_XML_SHARERES);
	end
	return;
end

function AdvQuestBookMainFrame_CommandHandler(this, cmd)
	if (AQB_SHOW) then
		AQB_SHOW = false;
		AdvQuestBookMainFrame:Hide();
	else
		AQB_SHOW = true;
		AdvQuestBookMainFrame:Show();
	end
end

function AdvQuestBookMainFrame_Toggle()
	AdvQuestBookMainFrame_CommandHandler(false, false);
end

function AdvQuestBookMiniMapShareButton_OnClick()
	AdvQuestBook_QuestPingRequest();
end

function AdvQuestBook_CloseOpen()
	AdvQuestBookConfig:Hide();
	AdvQuestBookIconConfig:Hide();
	AdvQuestBookMainFrameHelpResults:Hide();
	AdvQuestBookMainFrameShareResults:Hide();
	AdvQuestBookMainFrameShareQuestResults:Hide();
	AdvQuestBookMainFrameSearchResults:Hide();
	AdvQuestBookMainFrameShareButton:Hide();
	AdvQuestBookMainFrameDonFrame:Hide();
	return;
end

function AdvQuestBookMiniBook_OnClick(this, key)
	if (key == "LBUTTON") then
		AdvQuestBookMainFrame_Toggle();
	elseif (key == "RBUTTON") then
		if (AdvQuestBook_Config["minibook"]["status"] == "unlocked") then
			AdvQuestBook_Config["minibook"]["status"] = "locked";
			SaveVariables("AdvQuestBook_Config");
			AdvQuestBookMiniBookFrameCorner:Hide();
			AdvQuestBookMiniBookFrameBorder:Hide();
		else
			AdvQuestBook_Config["minibook"]["status"] = "unlocked";
			SaveVariables("AdvQuestBook_Config");
			AdvQuestBookMiniBookFrameCorner:Show();
			AdvQuestBookMiniBookFrameBorder:Show();
		end
	end
end

function AdvQuestBookCleanQuestDumpData()
	if (AdvQuestBook_Config["settings"][2]["value"]) then
		local i, v;
		local j, k;
		local savecount = 0;
		local cleancount = 0;
		local New_AdvQuestBook_Dumped_Quests = {};
		for i, v in pairs(AdvQuestBook_Dumped_Quests) do
			New_AdvQuestBook_Dumped_Quests[i] = {};
		end
		for i, v in pairs(AdvQuestBook_Dumped_Quests) do
			for j, k in pairs(v) do
				if (not k["turnedin"]) then
					New_AdvQuestBook_Dumped_Quests[i][j] = k;
					savecount = savecount + 1;
				else
					cleancount = cleancount + 1;
				end
			end
		end
		AdvQuestBook_Dumped_Quests = New_AdvQuestBook_Dumped_Quests;
		SaveVariables("AdvQuestBook_Dumped_Quests");
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFFffffff"..AQB_ADDON_NAME.."|r "..AdvQuestBook_Messages["AQB_CLEARED_DATA"], cleancount, savecount));
	else
		AdvQuestBook_Dumped_Quests = {};
		if (AQB_LANG_FILE == "en") then
			SaveVariables("AdvQuestBook_Dumped_Quests");
		end
		AdvQuestBook_Dumped_Quests[AQB_LOCAL] = {};
		SaveVariables("AdvQuestBook_Dumped_Quests");
		DEFAULT_CHAT_FRAME:AddMessage("|cFFffffff"..AQB_ADDON_NAME.."|r "..AdvQuestBook_Messages["AQB_CLEANED_ALL"]);
	end
	return;
end

--[[ Begin Config ]]
function AdvQuestBookMiniButton_SavePOS()
	local x, y = AdvQuestBookMiniBookFrame:GetPos();
	AdvQuestBook_Config["minibook"]["x"] = x;
	AdvQuestBook_Config["minibook"]["y"] = y;
	SaveVariables("AdvQuestBook_Config");
end

function AdvQuestBookShareMiniButton_OnClick(this, key)
	if (key == "LBUTTON") then
		PlaySoundByPath("sound\\interface\\ui_contextmenu_click.mp3");
		AdvQuestBookMiniMapShareButton_OnClick();
	elseif (key == "RBUTTON") then
		if (IsShiftKeyDown()) then
			UIPanelAnchorFrame_StartMoving(this);
		end
	end
end

function AdvQuestBookMiniButton_Set()
	if (not AddonManager) then
		if (AdvQuestBook_Config["minibook"]["show"]) then
			local AQBMBookX = AdvQuestBook_Config["minibook"]["x"];
			local AQBMBookY = AdvQuestBook_Config["minibook"]["y"];
			AdvQuestBookMiniBookFrame:Show();
			if (not AQB_IsEmpty(AQBMBookX, true) and not AQB_IsEmpty(AQBMBookY, true)) then
				AdvQuestBookMiniBookFrame:SetPos(AQBMBookX, AQBMBookY);
			end
		else
			AdvQuestBookMiniBookFrame:Hide();
		end
	else
		AdvQuestBookMiniBookFrame:Hide();
	end
	if (AQB_IsEmpty(AdvQuestBook_Config["minibook"]["status"], true)) then
		AdvQuestBook_Config["minibook"]["status"] = "unlocked";
	end
	SaveVariables("AdvQuestBook_Config");
	if (AdvQuestBook_Config["minibook"]["status"] == "locked") then
		AdvQuestBookMiniBookFrameCorner:Hide();
		AdvQuestBookMiniBookFrameBorder:Hide();
	else
		AdvQuestBookMiniBookFrameCorner:Show();
		AdvQuestBookMiniBookFrameBorder:Show();
	end
end

function AdvQuestBookConfig_SetChecked()
	local i, j;
	local cbi;
	local cbtbl = table.getn(AdvQuestBook_Config["settings"]);
	local chkbx;
	local qtxt;
	AQB_COUNT_DUMPED = 0;
	AdvQuestBookConfigDBVerText:SetText("QDB: v."..AQBDBVER);
	if (AQB_LOCAL ~= "ENUS") then
		AQB_COUNT_DUMPED = 0;
	else
		for i, j in pairs(AdvQuestBook_Dumped_Quests[AQB_LOCAL]) do
			AQB_COUNT_DUMPED = AQB_COUNT_DUMPED + 1;
		end
	end
	if (AQB_COUNT_DUMPED == 1) then
		qtxt = " Quest";
	else
		qtxt = " Quests";
	end
	if (AQB_LOCAL == "ENUS") then
		AdvQuestBookConfigCheckbox1QuestDumpText:SetText("("..AQB_COUNT_DUMPED..qtxt.." "..AdvQuestBook_Messages["AQB_DUMPED"]..")");
	end
	for cbi = 1, cbtbl do
		chkbx = getglobal("AdvQuestBookConfigCheckbox"..cbi);
		chkbx:SetChecked(AdvQuestBook_Config["settings"][cbi]["value"]);
		if (cbi == 1) then
			if (AdvQuestBook_Config["settings"][1]["value"]) then
				AdvQuestBookConfigReloadButton:Disable();
				AdvQuestBookConfigReloadUI:SetText(AQB_XML_RELOADUI3);
			else
				AdvQuestBookConfigReloadButton:Enable();
				AdvQuestBookConfigReloadUI:SetText(AQB_XML_RELOADUI2);
			end
		end
	end
	chkbx = getglobal("AdvQuestBookConfigMiniToggle");
	chkbx:SetChecked(AdvQuestBook_Config["minibook"]["show"]);
	if (AddonManager) then
		AdvQuestBookConfigMiniToggle:Disable();
	end
end

function AdvQuestBookIconConfig_SetChecked()
	local i;
	for i = 1, table.getn(AdvQuestBook_Config["iconsettings"]) do
		local chkbx = getglobal("AdvQuestBookIconConfigCheckbox"..i);
		chkbx:SetChecked(AdvQuestBook_Config["iconsettings"][i]["value"]);
	end
end

function AdvQuestBookConfig_PurgeData()
	AdvQuestBookCleanQuestDumpData();
end

function AdvQuestBookConfig_ReloadUI()
	CloseAllWindows();
	ReloadUI();
end
--[[ End Config ]]

function AdvQuestBook_CheckBoxOnClick(this)
	local chkbox;
	local cfgsection;
	if (string.find(this, "AdvQuestBookConfigCheckbox")) then
		cfgsection = "settings";
		chkbx = string.gsub(this, "AdvQuestBookConfigCheckbox", "");
	elseif (string.find(this, "AdvQuestBookIconConfig")) then
		cfgsection = "iconsettings";
		chkbx = string.gsub(this, "AdvQuestBookIconConfigCheckbox", "");
	else
		return;
	end
	chkbx = tonumber(chkbx);
	if (AdvQuestBook_Config[cfgsection][chkbx]["value"]) then
		AdvQuestBook_Config[cfgsection][chkbx]["value"] = false;
	else
		AdvQuestBook_Config[cfgsection][chkbx]["value"] = true;
	end
	if (cfgsection == "settings" and chkbx == 1) then
		if (AdvQuestBook_Config["settings"][1]["value"]) then
			AdvQuestBookConfigReloadButton:Disable();
			AdvQuestBookConfigReloadUI:SetText(AQB_XML_RELOADUI3);
		else
			AdvQuestBookConfigReloadButton:Enable();
			AdvQuestBookConfigReloadUI:SetText(AQB_XML_RELOADUI2);
		end
	end
end

function AdvQuestBook_ScrollButtonCTRL(this, cval)
	local scrollbar = getglobal(this);
	local svval = scrollbar:GetValue();
	local tablecount;
	if (string.find(this, "SearchResults")) then
		tablecount = table.getn(AQB_QST_RESULTS);
	else
		tablecount = table.getn(AQB_SharedQuests);
	end
	if (svval == cval) then
		getglobal(this.."ScrollDownButton"):Disable();
	else
		getglobal(this.."ScrollDownButton"):Enable();
	end
	if (svval > 0) then
		getglobal(this.."ScrollUpButton"):Enable();
	else
		getglobal(this.."ScrollUpButton"):Disable();
	end
	if (svval < cval) then
		getglobal(this.."ScrollDownButton"):Enable();
	else
		getglobal(this.."ScrollDownButton"):Disable();
	end
	if (tablecount <= AQB_MAX_WIN) then
		getglobal(this.."ScrollUpButton"):Disable();
		getglobal(this.."ScrollDownButton"):Disable();
	end
end

function AdvQuestBook_ClearDesc()
	AdvQuestBookMainFrameQuestName:SetText(" ");
	AdvQuestBookMainFrameQuestDescMessage:ClearText();
	AdvQuestBookMainFrameQuestDescMessageText:SetText("");
	AdvQuestBookMainFrameQuestDescMessage:SetHeight(0);
	AdvQuestBookMainFrameQuestDetailsMessage:ClearText();
	AdvQuestBookMainFrameQuestDetailsMessageText:SetText("");
	AdvQuestBookMainFrameQuestDetailsMessage:SetHeight(0);
	AdvQuestBookMainFrameQuestRewardMessage:ClearText();
	AdvQuestBookMainFrameQuestRewardMessageText:SetText("");
	AdvQuestBookMainFrameQuestRewardMessage:SetHeight(0);
	AdvQuestBookMainFrameQuestLocationMessage:ClearText();
	AdvQuestBookMainFrameQuestLocationMessageText:SetText("");
	AdvQuestBookMainFrameQuestLocationMessage:SetHeight(0);
	AdvQuestBookMainFrameQuestDesc:Hide();
	AdvQuestBookMainFrameQuestDetails:Hide();
	AdvQuestBookMainFrameQuestReward:Hide();
	AdvQuestBookMainFrameQuestLocation:Hide();
	return;
end

function AdvQuestBook_OnValueChanged(this, arg1)
	local i;
	local btn;
	local x = 9;
	local y = 13;
	local itemarr;
	local scrollbar = getglobal(this);
	local textitem = string.gsub(this, "List_ScrollBar", "");
	local sv = scrollbar:GetValue() + 1;
	if (textitem == "AdvQuestBookMainFrameSearchResults") then
		itemarr = AQB_QST_RESULTS;
	elseif (textitem == "AdvQuestBookMainFrameShareResults") then	
		itemarr = AQB_SharedQuests;
	else
		itemarr = AQB_SharedQuests[AQB_LAST_SHARE]["quests"];
	end
	local ICOUNT = table.getn(itemarr);
	for i = 1, AQB_MAX_WIN do
		btn = getglobal(textitem.."ItemButton_"..i);
		btn:Hide();
		btn:UnlockHighlight();
	end
	for i = 1, AQB_MAX_WIN do
		if (itemarr[sv]) then
			btn = getglobal(textitem.."ItemButton_"..i);
			btn:ClearAllAnchors();
			btn.id = i;
			btn:SetAnchor("TOPLEFT", "TOPLEFT", textitem, x, (21 * i) + y);
			if (textitem == "AdvQuestBookMainFrameShareResults") then
				btn.pid = sv;
				btn:SetText(itemarr[sv]["name"]);
			elseif (textitem == "AdvQuestBookMainFrameShareQuestResults") then
				btn.qid = AQB_SharedQuests[AQB_LAST_SHARE]["quests"][sv];
				btn.qid = tonumber(btn.qid);
				btn:SetText(AdvQuestBookText[btn.qid]["name"]);
			else
				btn.qid = itemarr[sv];
				btn:SetText(AdvQuestBookText[btn.qid]["name"]);
			end
			btn:Show();
			sv = sv + 1;
		else
			break;
		end
	end
	if (ICOUNT > AQB_MAX_WIN) then
		scrollbar:SetMaxValue(ICOUNT - AQB_MAX_WIN);
		AdvQuestBook_ScrollButtonCTRL(this, ICOUNT - AQB_MAX_WIN);
	else
		scrollbar:SetMaxValue(0);
		AdvQuestBook_ScrollButtonCTRL(this, ICOUNT);
	end
end

function AdvQuestBook_OnMouseWheel(this, delta)
	if (delta > 0) then
		this:SetValue(this:GetValue() - 1);
	else
		this:SetValue(this:GetValue() + 1);
	end
end

function AdvQuestBook_ResultsOnClick(this, key, lrtype)
	local i;
	local btn;
	local totalh = 0;
	local restext = "";
	local text = "";
	local text2;
	local rewards = "";
	local locations = "";
	if (key == "RBUTTON") then
--		if (not AdvQuestBookQuestLink:IsVisible()) then
--			AdvQuestBookQuestLink:Show();
--		end
--		btn = getglobal(this);
--		local qlink = "|Hquest:|h|cffa0a020["..AdvQuestBookText[btn.qid]["name"].."]|r|h";
--		DEFAULT_CHAT_FRAME:AddMessage(qlink);
		return;
	end
	if (key == "LBUTTON" and IsShiftKeyDown()) then
		btn = getglobal(this);
		local qid = AQB_Dec2Hex(btn.qid);
		local link = "|Hquest:"..qid.."|h|cffa0a020["..AdvQuestBookText[btn.qid]["name"].."]|r|h";
		ChatEdit_AddItemLink(link);
		return;
	end
	AdvQuestBook_ClearDesc();
	AdvQuestBookConfig:Hide();
	AdvQuestBookIconConfig:Hide();
	for i = 1, AQB_MAX_WIN do
		local tmpthis = string.gsub(this, "_(%d+)", "");
		btn = getglobal(tmpthis.."_"..i);
		btn:UnlockHighlight();
	end
	btn = getglobal(this);
	btn:LockHighlight();
	if (lrtype == "qst" or lrtype == "sha") then
		local sNPCid = "";
		local sNPCname = "";
		local sMap = "";
		local eMap = "";
		local eNPCid = "";
		local eNPCname = "";
		local gold = "";
		local xp = "";
		local tp = "";
		local qstatus;
		if (not AQB_IsEmpty(AdvQuestBookText[btn.qid]["name"], true)) then
			restext = AdvQuestBookText[btn.qid]["name"];
		end
		if (not AQB_IsEmpty(AdvQuestBookText[btn.qid]["desc"], true)) then
			text = AdvQuestBookText[btn.qid]["desc"];
			if (lrtype == "qst") then
				text = string.gsub(text, "%(P%)", "|cffc00000"..UnitName("player").."|r");
			else
				text = string.gsub(text, "%(P%)", "|cffc00000"..AQB_SharedQuests[AQB_LAST_SHARE]["name"].."|r");
			end
			text = AdvQuestBook_ZoneParse(text);
			text = AdvQuestBook_IDParse(text);
		end
		if (not AdvQuestBookCoords[btn.qid]) then
			text = "|cffc30500"..AdvQuestBook_Messages["AQB_NOTSUB"].."|r\n\n"..text;
		end
		qstatus = CheckQuest(btn.qid);
		text = "|cff000982"..AdvQuestBook_Messages["AQB_QSTATUS"..qstatus].."|r\n\n"..text;
		if (not AQB_IsEmpty(AdvQuestBookText[btn.qid]["det"], true)) then
			text2 = AdvQuestBookText[btn.qid]["det"];
			if (lrtype == "qst") then
				text2 = string.gsub(text2, "%(P%)", "|cffc00000"..UnitName("player").."|r");
			else
				text2 = string.gsub(text2, "%(P%)", "|cffc00000"..AQB_SharedQuests[AQB_LAST_SHARE]["name"].."|r");
			end
			text2 = AdvQuestBook_ZoneParse(text2);
			text2 = AdvQuestBook_IDParse(text2);
		end
		if (AdvQuestBookCoords[btn.qid]) then
			if (not AQB_IsEmpty(AdvQuestBookCoords[btn.qid]["start"]["id"], true)) then
				sNPCid = AdvQuestBookCoords[btn.qid]["start"]["id"];
				sNPCname = AdvQuestBook_IDtoName(sNPCid, true);
			end
			if (not AQB_IsEmpty(AdvQuestBookCoords[btn.qid]["start"]["mid"], true)) then
				sMap = AdvQuestBookCoords[btn.qid]["start"]["mid"];
				if (not AQB_IsEmpty(AdvQuestBook_MapID[sMap], true)) then
					sMap = AdvQuestBook_MapID[sMap];
				end
			end
			if (not AQB_IsEmpty(AdvQuestBookCoords[btn.qid]["end"]["mid"], true)) then
				eMap = AdvQuestBookCoords[btn.qid]["end"]["mid"];
				if (not AQB_IsEmpty(AdvQuestBook_MapID[eMap], true)) then
					eMap = AdvQuestBook_MapID[eMap];
				end
			end
			if (not AQB_IsEmpty(AdvQuestBookCoords[btn.qid]["end"]["id"], true)) then
				eNPCid = AdvQuestBookCoords[btn.qid]["end"]["id"];
				eNPCname = AdvQuestBook_IDtoName(eNPCid, true);
			end
			if (not AQB_IsEmpty(AdvQuestBookCoords[btn.qid]["info"]["gold"], true)) then
				gold = AdvQuestBookCoords[btn.qid]["info"]["gold"];
			end
			if (not AQB_IsEmpty(AdvQuestBookCoords[btn.qid]["info"]["xp"], true)) then
				xp = AdvQuestBookCoords[btn.qid]["info"]["xp"];
			end
			if (not AQB_IsEmpty(AdvQuestBookCoords[btn.qid]["info"]["tp"], true)) then
				tp = AdvQuestBookCoords[btn.qid]["info"]["tp"];
			end
		end
		rewards = AdvQuestBook_Messages["AQB_GOLD"]..": "..gold.."\n"..AdvQuestBook_Messages["AQB_XP"]..": "..xp.."\n"..AdvQuestBook_Messages["AQB_TP"]..": "..tp;
		locations = AdvQuestBook_Messages["AQB_START"]..": "..sNPCname.." - "..AdvQuestBook_Messages["AQB_MAP"]..": "..sMap.."\n"..AdvQuestBook_Messages["AQB_END"]..": "..eNPCname.." - "..AdvQuestBook_Messages["AQB_MAP"]..": "..eMap;
	elseif (lrtype == "help") then

	end
	-- Name
	AdvQuestBookMainFrameQuestName:SetText(restext);
	-- Description
	AdvQuestBookMainFrameQuestDescMessage:AddMessage(text);
	AdvQuestBookMainFrameQuestDescMessageText:SetText(text);
	local h = AdvQuestBookMainFrameQuestDescMessageText:GetHeight();
	AdvQuestBookMainFrameQuestDescMessage:SetHeight(h);
	totalh = h;
	-- Details
	AdvQuestBookMainFrameQuestDetailsMessage:AddMessage(text2);
	AdvQuestBookMainFrameQuestDetailsMessageText:SetText(text2);
	local h = AdvQuestBookMainFrameQuestDetailsMessageText:GetHeight();
	AdvQuestBookMainFrameQuestDetailsMessage:SetHeight(h);
	totalh = totalh + h;
	-- Rewards
	if (AdvQuestBookCoords[btn.qid]) then
		AdvQuestBookMainFrameQuestRewardMessage:AddMessage(rewards);
		AdvQuestBookMainFrameQuestRewardMessageText:SetText(rewards);
		local h = AdvQuestBookMainFrameQuestRewardMessageText:GetHeight();
		AdvQuestBookMainFrameQuestRewardMessage:SetHeight(h);
		totalh = totalh + h;
		-- Locations
		AdvQuestBookMainFrameQuestLocationMessage:AddMessage(locations);
		AdvQuestBookMainFrameQuestLocationMessageText:SetText(locations);
		local h = AdvQuestBookMainFrameQuestLocationMessageText:GetHeight();
		AdvQuestBookMainFrameQuestLocationMessage:SetHeight(h);
		totalh = totalh + h;
	end
	local scrollbar = getglobal("AdvQuestBookMainFrameQuestDetailScrollFrameScrollBar");
	scrollbar:SetMinMaxValues(0, totalh);
	scrollbar:SetValue(0);
	AdvQuestBookMainFrameQuestDetailScrollFrame:UpdateScrollChildRect();
	if (lrtype == "qst" or lrtype == "sha" or lrtype == "help") then
		AdvQuestBookMainFrameQuestDesc:Show();
	end
	if (lrtype == "qst" or lrtype == "sha") then
		AdvQuestBookMainFrameQuestDetails:Show();
	end
	if ((lrtype == "qst" or lrtype == "sha") and (AdvQuestBookCoords[btn.qid])) then
		AdvQuestBookMainFrameQuestReward:Show();
	end
	if ((lrtype == "qst" or lrtype == "sha") and (AdvQuestBookCoords[btn.qid])) then
		AdvQuestBookMainFrameQuestLocation:Show();
	end
end

function AdvQuestBookMainFrameShareResult_OnClick(this)
	AdvQuestBookMainFrameShareQuestResultsList_ScrollBar:SetMaxValue(0);
	local i;
	local x = 9;
	local y = 15;
	local tmpbtn = getglobal(this);
	local resnum = tmpbtn.pid;
	local qid;
	local qname;
	local AQB_CRESULTS = table.getn(AQB_SharedQuests[resnum]["quests"]);
	AQB_LAST_SHARE = resnum;
	for i = 1, AQB_MAX_WIN do
		if (AQB_SharedQuests[resnum]["quests"][i]) then
			local btn = getglobal("AdvQuestBookMainFrameShareQuestResultsItemButton_"..i);
			qid = AQB_SharedQuests[resnum]["quests"][i];
			qid = tonumber(qid);
			btn:ClearAllAnchors();
			btn:SetAnchor("TOPLEFT", "TOPLEFT", "AdvQuestBookMainFrameShareQuestResults", x, (21 * i) + y);
			btn.qid = qid;
			btn:SetText(AdvQuestBookText[qid]["name"]);
			btn:Show();
		else
			break;
		end
	end
	AdvQuestBook_CloseOpen();
	AdvQuestBookMainFrameShareQuestResults:Show();
	if (AQB_CRESULTS > AQB_MAX_WIN) then
		AdvQuestBookMainFrameShareQuestResultsList_ScrollBar:SetMaxValue(AQB_CRESULTS - AQB_MAX_WIN);
		AdvQuestBook_ScrollButtonCTRL("AdvQuestBookMainFrameShareQuestResultsList_ScrollBar", AQB_CRESULTS - AQB_MAX_WIN);
	else
		AdvQuestBookMainFrameShareQuestResultsList_ScrollBar:SetMaxValue(0);
		AdvQuestBook_ScrollButtonCTRL("AdvQuestBookMainFrameShareQuestResultsList_ScrollBar", AQB_CRESULTS);
	end
end

function AdvQuestBookMainFrameShareButton_ShowShared()
	AdvQuestBookMainFrameShareResultsList_ScrollBar:SetMaxValue(0);
	local i;
	local x = 9;
	local y = 11;
	local AQB_CRESULTS = table.getn(AQB_SharedQuests);
	local btn;
	for i = 1, AQB_MAX_WIN do
		btn = getglobal("AdvQuestBookMainFrameShareResultsItemButton_"..i);
		btn:Hide();
	end
	if (AQB_CRESULTS > 0) then
		for i = 1, AQB_MAX_WIN do
			if (AQB_SharedQuests[i]) then
				btn = getglobal("AdvQuestBookMainFrameShareResultsItemButton_"..i);
				btn:ClearAllAnchors();
				btn:SetAnchor("TOPLEFT", "TOPLEFT", "AdvQuestBookMainFrameShareResults", x, (21 * i) + y);
				btn:SetText(AQB_SharedQuests[i]["name"]);
				btn.pid = i;
				btn:Show();
			else
				break;
			end
		end
	end
	if (AQB_CRESULTS > AQB_MAX_WIN) then
		AdvQuestBookMainFrameShareResultsList_ScrollBar:SetMaxValue(AQB_CRESULTS - AQB_MAX_WIN);
		AdvQuestBook_ScrollButtonCTRL("AdvQuestBookMainFrameShareResultsList_ScrollBar", AQB_CRESULTS - AQB_MAX_WIN);
	else
		AdvQuestBookMainFrameShareResultsList_ScrollBar:SetMaxValue(0);
		AdvQuestBook_ScrollButtonCTRL("AdvQuestBookMainFrameShareResultsList_ScrollBar", AQB_CRESULTS);
	end
end

function AdvQuestBookMainFrameShareBack_OnClick()
	AdvQuestBook_CloseOpen();
	AdvQuestBookMainFrameShareResults:Show();
	AdvQuestBookMainFrameShareButton:SetText(AQB_XML_HIDESHARE);
	AdvQuestBookMainFrameShareButton:Show();
end

function AdvQuestBookMainFrame_SearchQuest()
	local AQB_QSTS_TEXT = AdvQuestBookMainFrameSearchOptionsSearchBox:GetText();
	if (string.len(AQB_QSTS_TEXT) < AQB_MIN_ST) then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(AdvQuestBook_Messages["AQB_MIN_CHARS"], AQB_MIN_ST));
		return;
	end
	local i;
	local icount;
	local AQB_QSTA, AQB_QSTB;
	local AQB_RES_COUNT = 0;
	AQB_QST_ICOUNT = 0;
	AQB_QST_RESULTS = {};
	local AQB_TEMP_RESULTS = {};
	local x = 9;
	local y = 13;
	for i = 1, AQB_MAX_WIN do
		local btn = getglobal("AdvQuestBookMainFrameSearchResultsItemButton_"..i);
		btn:Hide();
	end
	local NEW_TEXT = "\"|cFFffffff"..AQB_QSTS_TEXT.."|r\"";
	DEFAULT_CHAT_FRAME:AddMessage(string.format(AdvQuestBook_Messages["AQB_SEARCHING"], NEW_TEXT));
	AQB_QST_LOWER = string.lower(AQB_QSTS_TEXT);
	for AQB_QSTA, AQB_QSTB in pairs(AdvQuestBookText) do
		local AQB_QSTK_LOWER = string.lower(AQB_QSTB["name"]);
		if (string.match(AQB_QSTK_LOWER, AQB_QST_LOWER)) then
			if (AQB_RES_COUNT < AQB_QST_MAX) then
				AQB_RES_COUNT = AQB_RES_COUNT + 1;
				AQB_TEMP_RESULTS[AQB_QSTA] = AQB_QSTB["name"];
			else
				AQB_RES_COUNT = AQB_RES_COUNT + 1;
				DEFAULT_CHAT_FRAME:AddMessage(string.format(AdvQuestBook_Messages["AQB_TOOMANY"], "|cffffffff"..AQB_QST_MAX.."|r"));
				break;
			end
		end
	end
	for AQB_QSTA, AQB_QSTB in AdvQuestBook_OrderByName(AQB_TEMP_RESULTS) do
		table.insert(AQB_QST_RESULTS, AQB_QSTA);
	end
	icount = table.getn(AQB_QST_RESULTS);
	if (icount > AQB_MAX_WIN) then
		icount = AQB_MAX_WIN;
	end
	for i = 1, icount do
		local btn = getglobal("AdvQuestBookMainFrameSearchResultsItemButton_"..i);
		btn:ClearAllAnchors();
		btn:SetAnchor("TOPLEFT", "TOPLEFT", "AdvQuestBookMainFrameSearchResults", x, (21 * i) + y);
		btn.id = i;
		btn.qid = tonumber(AQB_QST_RESULTS[i]);
		btn:SetText(AdvQuestBookText[tonumber(AQB_QST_RESULTS[i])]["name"]);
		btn:Show();
	end
	if (AQB_RES_COUNT <= AQB_QST_MAX) then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(AdvQuestBook_Messages["AQB_FOUND_RESULTS"], AQB_RES_COUNT, NEW_TEXT));
	end
	AdvQuestBookMainFrameSearchOptionsSearchBox:ClearFocus();
	AdvQuestBook_ClearDesc();
	local AQB_CRESULTS = table.getn(AQB_QST_RESULTS);
	if (AQB_CRESULTS > AQB_MAX_WIN) then
		AdvQuestBookMainFrameSearchResultsList_ScrollBar:SetMaxValue(AQB_CRESULTS - AQB_MAX_WIN);
		AdvQuestBook_ScrollButtonCTRL("AdvQuestBookMainFrameSearchResultsList_ScrollBar", AQB_CRESULTS - AQB_MAX_WIN);
	else
		AdvQuestBookMainFrameSearchResultsList_ScrollBar:SetMaxValue(0);
		AdvQuestBook_ScrollButtonCTRL("AdvQuestBookMainFrameSearchResultsList_ScrollBar", AQB_CRESULTS);
	end
end

function AdvQuestBookMainFrame_SearchEditOnEnterPressed()
	AdvQuestBook_CloseOpen();
	AdvQuestBookMainFrame_SearchQuest();
end

function AdvQuestBookMainFrame_OnHyperlinkClick(this, link, key)
	Hyperlink_Assign(link, key);
end

function AdvQuestBookMainFrame_OnHyperlinkEnter(this, link)
	SetHyperlinkCursor(true);
end

function AdvQuestBookMainFrame_OnHyperlinkLeave(this, link)
	SetHyperlinkCursor(false);
end

function AdvQuestBookMainFrame_OnEvent(this, event)
	if (event == "VARIABLES_LOADED") then
		AdvQuestBookMiniMapShareButton:RegisterForClicks("LeftButton", "RightButton");
		AdvQuestBookMiniBookButton:RegisterForClicks("LeftButton", "RightButton");
		SLASH_AQB1 = "/aqb";
		SlashCmdList["AQB"] = AdvQuestBookMainFrame_CommandHandler;
		-- Begin AddonManager Support
		if AddonManager then
			AddonManager.RegisterAddon(
				"|cffFFFF00Advanced Quest Book|r",
				"\n"..AdvQuestBook_Messages["AQB_AMINFO"],
				"Interface\\AddOns\\AdvQuestBook\\images\\aqb.png",
				"Information",
				false,
				"/aqb",
				AdvQuestBookMiniButton,
				AdvQuestBookMainFrame_Toggle,
				"v."..AQB_VER_NUM,
				"Crypton",
				false,
				false
			);
		else
		-- End AddonManager Support
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffffff"..AQB_TITLE_PAGE.."|r by |cffffca13Crypton|r Loaded...");
		end
		AdvQuestBookMiniButton_Set();
	end
end

function AdvQuestBookMainFrame_OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
	tdetailh = 0;
	local slider = UIPanelScrollFrame_GetScrollBar(AdvQuestBookMainFrameQuestDetailScrollFrame);
	slider:ClearAllAnchors();
	slider:SetAnchor("TOPLEFT", "TOPRIGHT", AdvQuestBookMainFrameQuestDetailBackdrop, -13, 45);
	slider:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", AdvQuestBookMainFrameQuestDetailBackdrop, -1, -19);
	AdvQuestBookMainFrameQuestDesc:Hide();
	AdvQuestBookMainFrameQuestDetails:Hide();
	AdvQuestBookMainFrameQuestReward:Hide();
	AdvQuestBookMainFrameQuestLocation:Hide();
--	local i;
--	local x = 9;
--	local y = 15;
--	local hc = table.getn(AQB_HELP_TOPICS);
--	for i = 1, hc do
--		local btn = getglobal("AdvQuestBookMainFrameHelpResultsItemButton_"..i);
--		btn:Hide();
--		local btn = getglobal("AdvQuestBookMainFrameHelpResultsItemButton_"..i);
--		btn:ClearAllAnchors();
--		btn:SetAnchor("TOPLEFT", "TOPLEFT", "AdvQuestBookMainFrameHelpResults", x, (21 * i) + y);
--		btn:SetText(AQB_HELP_TOPICS[i]);
--		btn:Show();
--	end
	AdvQuestBookMainFrameSearchResultsList_ScrollBar:SetValueStepMode("INT");
	AdvQuestBookMainFrameShareResultsList_ScrollBar:SetValueStepMode("INT");
	AdvQuestBookMainFrameShareQuestResultsList_ScrollBar:SetValueStepMode("INT");
	getglobal("AdvQuestBookMainFrameSearchResultsList_ScrollBar".."ScrollUpButton"):Disable();
	getglobal("AdvQuestBookMainFrameSearchResultsList_ScrollBar".."ScrollDownButton"):Disable();
	getglobal("AdvQuestBookMainFrameShareResultsList_ScrollBar".."ScrollUpButton"):Disable();
	getglobal("AdvQuestBookMainFrameShareResultsList_ScrollBar".."ScrollDownButton"):Disable();
	getglobal("AdvQuestBookMainFrameShareQuestResultsList_ScrollBar".."ScrollUpButton"):Disable();
	getglobal("AdvQuestBookMainFrameShareQuestResultsList_ScrollBar".."ScrollDownButton"):Disable();
end
