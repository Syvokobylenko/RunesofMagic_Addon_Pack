local QuestState = _G.QuestState;
QuestState.UI = {};	-- interface
local ui = {};	-- table of frames, labels, buttons, ...



----------------------------------- UTILITY ------------------------------------

local function TableFind(t, val)
	for k, v in pairs(t) do
		if(val == v) then
			return k;
		end;
	end;
	return nil;
end;

local function CreateLabel(name, parent, point, relativePoint, relativeTo, offsetX, offsetY, fontSize)
	local label = CreateUIComponent("FontString", "QuestState_"..name.."Label", parent:GetName(), "GameFontHighlight");
	label:ClearAllAnchors();
	label:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY);
	label:SetJustifyHType("LEFT");
	parent:SetLayers(1, label);
	if(fontSize ~= nil) then
		label:SetFontSize(fontSize);
	end;
	if(QuestState.lang[name] ~= nil) then
		label:SetText(QuestState.lang[name]);
	else
		label:SetText("");
	end;
	
	_G[label:GetName()] = nil;
	
	return label;
end;

local function CreateCheckbox(name, parent, point, relativePoint, relativeTo, offsetX, offsetY, onClick)
	local checkbutton = CreateUIComponent("CheckButton", "QuestState_"..name.."Checkbutton", parent:GetName(), "UIPanelCheckButtonTemplate");
	checkbutton:SetSize(22, 22);
	checkbutton:ClearAllAnchors();
	checkbutton:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY);
	checkbutton:SetFrameLevel(1);
	checkbutton:SetScripts("OnClick", onClick);
	
	checkbutton.label = CreateLabel(name, checkbutton, "LEFT", "RIGHT", checkbutton, 2, 0);
	
	_G[checkbutton:GetName()] = nil;
	
	return checkbutton;
end;

local function CreateFrame(name, parent, width, height, point, relativePoint, relativeTo, offsetX, offsetY)
	local frame = CreateUIComponent("Frame", "QuestState_"..name.."Frame", parent:GetName());
	frame:SetSize(width, height);
	if(point ~= nil) then
		frame:ClearAllAnchors();
		frame:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY);
	end;
	frame:SetMouseEnable(true);
	
	_G[frame:GetName()] = nil;
	
	return frame;
end;

local function CreateTexture(name, parent, point, relativePoint, relativeTo, offsetX, offsetY)
	local texture = CreateUIComponent("Texture", "QuestState_"..name.."Texture", parent:GetName());
	texture:ClearAllAnchors();
	texture:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY);
	texture:SetTexCoord(0.0, 1.0, 0.0, 1.0); -- left, right, top, bottom
	texture:SetColor(1.0, 1.0, 1.0);
	texture:SetAlpha(1.0);
	texture:SetAlphaMode("ADD");
	parent:SetLayers(3, texture);
	
	_G[texture:GetName()] = nil;
	
	return texture;
end;



--------------------------------------------------------------------------------

local function ResizeTabs()
	local tabsWidth = NpcTrackTab1:GetWidth() + NpcTrackTab2:GetWidth() + ui.tab:GetWidth();
	local scale = NpcTrackSearchFrame:GetWidth() / tabsWidth;
	if(scale < 1) then
		local deltaOffset = NpcTrackTab1:GetHeight() * (1 - scale);
		local TabAnchor_point, TabAnchor_relativePoint, TabAnchor_relativeTo, TabAnchor_offsetX, TabAnchor_offsetY = NpcTrackTab1:GetAnchor();
		NpcTrackTab1:ClearAllAnchors();
		NpcTrackTab1:SetAnchor(TabAnchor_point, TabAnchor_relativePoint, TabAnchor_relativeTo, TabAnchor_offsetX, TabAnchor_offsetY+deltaOffset);

		NpcTrackTab1:SetScale(scale);
		NpcTrackTab2:SetScale(scale);
		ui.tab:SetScale(scale);
	end;
end;

local function SetMsgBar(q)
	if(q.mapID ~= 400) then
		local msg = string.format("%s ( %.1f , %.1f )", QuestState.util.GetAllNPCsString({q.npcID}), q.x*100, q.z*100);
		NpcTrackWorldMapFrameMsgBar_String:SetText(msg);
	else
		NpcTrackFrameFlagTexture:Hide();
		NpcTrackWorldMapFrameMsgBar:Hide();
	end;
end;

local function FillNode(frame, string, questID)
	local text = QuestState.util.TEXT(questID);
	local status = QuestState.util.CheckQuest(questID);
	
	if(questID >= 500000) then	-- flag
		frame:SetBackdropTileColor(0.5, 0.5, 0.5);
		frame:SetBackdropEdgeColor(0.5, 0.5, 0.5);
		
		if(status == 0) then
			string:SetText("|cffff0000"..text.."|r");
		else
			string:SetText("|cff00ff00"..text.."|r");
		end;
	else
		if(status == 0) then
			frame:SetBackdropTileColor(1.0, 0.0, 0.0);
			frame:SetBackdropEdgeColor(1.0, 0.0, 0.0);
		elseif(status == 1) then
			frame:SetBackdropTileColor(1.0, 1.0, 0.0);
			frame:SetBackdropEdgeColor(1.0, 1.0, 0.0);
		else
			frame:SetBackdropTileColor(0.0, 1.0, 0.0);
			frame:SetBackdropEdgeColor(0.0, 1.0, 0.0);
		end;
		
		if(questID == QuestState.GetHistoryTop()) then
			string:SetText("|cff7f7f7f"..text.."|r");
		else
			string:SetText(text);
		end;
	end;
	
	local width, height = frame:GetSize();
	string:SetSize(width - 10, height);
	
	frame:SetID(questID);
	frame:Show();
end;

local function SetRequirements(req)	-- returns the height of the requirement frames
	if(req) then	-- requirements
		n = table.getn(req);
		ui.requirementsTexture:Show();
		ui.requirementsLabel:Show();
		ui.preTexture:SetFile("interface/addons/QuestState/images/down"..n);
		ui.preTexture:SetSize(10, n*30-20-((n-1)%2)*4);
		ui.preTexture:Show();
		
		-- reposition prequest frames
		for i = 1, n do
			ui.preFrame[i]:ClearAllAnchors();
	
			if((i < n) or (i%2 == 0)) then
				ui.preFrame[i]:SetAnchor("TOP", "BOTTOM", ui.curQFrame, 150*(((i-1)%2)-0.5), 36+60*math.floor((i-1)/2));
			else
				ui.preFrame[i]:SetAnchor("TOP", "BOTTOM", ui.curQFrame, 0, 36+60*math.floor((i-1)/2));
			end;
			
			FillNode(ui.preFrame[i], ui.preLabel[i], req[i]);
		end;
		for i = n+1, 5 do
			ui.preFrame[i]:Hide();
		end;
		
		return 26 + 60 * math.ceil(n/2);
	else
		ui.requirementsTexture:Hide();
		ui.requirementsLabel:Hide();
		ui.preTexture:Hide();
		
		for i = 1, 5 do
			ui.preFrame[i]:Hide();
		end;
		
		return 0;
	end;
end;

local function SetFollowUpQuests(questID, quests)	-- returns the height of the follow up quest frames
	if(quests) then
		n = table.getn(quests);
		local overMax = 0;
		if(n > 5) then
			overMax = n - 4;	-- -4 because the fifth will not contain a quest
			n = 5;
		end;
		ui.followUpTexture:Show();
		ui.followUpLabel:Show();
		ui.postTexture:SetFile("interface/addons/QuestState/images/up"..n);
		ui.postTexture:SetSize(10, n*30-20-((n-1)%2)*4);
		ui.postTexture:Show();
		
		for i = 1, n do
			ui.postFrame[i]:ClearAllAnchors();
	
			if((i < n) or (i%2 == 0)) then
				ui.postFrame[i]:SetAnchor("BOTTOM", "TOP", ui.curQFrame, 150*(((i-1)%2)-0.5), -36-60*math.floor((i-1)/2));
			else
				ui.postFrame[i]:SetAnchor("BOTTOM", "TOP", ui.curQFrame, 0, -36-60*math.floor((i-1)/2));
			end;
			
			if((i == 5) and (overMax > 0)) then
				ui.postFrame[i]:SetBackdropTileColor(0.5, 0.5, 0.5);
				ui.postFrame[i]:SetBackdropEdgeColor(0.5, 0.5, 0.5);
				ui.postFrame[i]:SetID(-questID);	-- -questID will trigger the QuestState.ListAllFollowUpQuests(questID) function
				ui.postLabel[i]:SetText(QuestState.lang["overMax"]:format(overMax));
				ui.postFrame[i]:Show();
			else
				FillNode(ui.postFrame[i], ui.postLabel[i], quests[i]);
			end;
		end;
		for i = n+1, 5 do
			ui.postFrame[i]:Hide();
		end;
		if((overMax > 0) and (QuestState.GetHistoryTop() ~= nil)) then
			local i = TableFind(quests, QuestState.GetHistoryTop());
			if(i > 4) then
				FillNode(ui.postFrame[4], ui.postLabel[4], quests[i]);
			end;
		end;
		
		return 26 + 60 * math.ceil(n/2);
	else
		ui.followUpTexture:Hide();
		ui.followUpLabel:Hide();
		ui.postTexture:Hide();
		
		for i = 1, 5 do
			ui.postFrame[i]:Hide();
		end;
		
		return 0;
	end;
end;

local function TraceNPC(questID, sameMapRequired)
	local quest = QuestState.quests[questID];

	info = {};
	info.id = questID;
	info.name = quest.name;

	if(sameMapRequired) then
		table.sort(quest.n, QuestState.util.SortNpcsPreferSameMap);
	else
		table.sort(quest.n, QuestState.util.SortNpcs);
	end;
	if(quest.n[1] ~= nil) then
		info.npcID = quest.n[1];
		info.map, info.x, info.z = QuestState.util.GetNPCData(info.npcID);
	else
		return;
	end;

	NpcTrackFrame_AddToTrace(info);
end;



--------------------------------------------------------------------------------

function QuestState.UI.Create()
	ui.tab = CreateUIComponent("Button", "NpcTrackTab3", "NpcTrackFrame", "NpcTrackTabTemplate");
	ui.tab:SetID(3);
	ui.tab:ClearAllAnchors();
	ui.tab:SetAnchor("LEFT", "RIGHT", "NpcTrackTab2", -2, 0);
	ui.tab:SetFrameLevel(1);
	ui.tab:SetText("QuestState");
	
	NpcTrackTraceButton:ClearAllAnchors();
	NpcTrackTraceButton:SetAnchor("BOTTOM", "BOTTOM", "NpcTrackSearchResultListFrame", 0, -4);
	


	ui.searchFrame = CreateUIComponent("Frame", "QuestState_searchFrame", "NpcTrackFrame");
	ui.searchFrame:Hide();
	ui.searchFrame:SetSize(1, 1);
	ui.searchFrame:ClearAllAnchors();
	ui.searchFrame:SetAnchor("TOPLEFT", "TOPLEFT", "NpcTrackTopFrame", 0, 0);
	ui.searchFrame:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", "NpcTrackTopFrame", 0, 0);
	ui.searchFrame:SetScripts("OnShow", [=[ QuestState.UI.OnShow(); ]=] );
	ui.searchFrame:SetScripts("OnHide", [=[ QuestState.UI.OnHide(); ]=] );
	
	ui.filter = CreateUIComponent("Frame", "QuestState_dropDown", ui.searchFrame:GetName(), "UIDropDownMenuTemplate");
	ui.filter:ClearAllAnchors();
	ui.filter:SetAnchor("TOPLEFT", "TOPLEFT", ui.searchFrame, 15, 10);
	ui.filter:SetScripts("OnLoad", [=[ QuestState.UI.FilterDropDown_OnLoad(this); ]=]);
	
	ui.sameMap = CreateCheckbox("sameMap", ui.searchFrame, "TOPLEFT", "BOTTOMLEFT", ui.filter, 0, 0, [=[ QuestStateSettings["sameMap"] = this:IsChecked(); QuestState.Search(); ]=]);
	ui.normal = CreateCheckbox("questType0", ui.searchFrame, "TOP", "BOTTOM", ui.sameMap, 0, 0, [=[ QuestStateSettings["normalQuests"] = this:IsChecked(); QuestState.Search(); ]=]);
	ui.daily = CreateCheckbox("questType2", ui.searchFrame, "LEFT", "RIGHT", ui.normal.label, 10, 0, [=[ QuestStateSettings["dailyQuests"] = this:IsChecked(); QuestState.Search(); ]=]);
	ui.public = CreateCheckbox("questType3", ui.searchFrame, "LEFT", "RIGHT", ui.daily.label, 10, 0, [=[ QuestStateSettings["publicQuests"] = this:IsChecked(); QuestState.Search(); ]=]);
	
	ui.searchEditBox = CreateUIComponent("EditBox", "QuestState_searchEditBox", ui.searchFrame:GetName(), "NpcTrackSearchEditBox");
	ui.searchEditBox:Hide();
	ui.searchEditBox:SetSize(130, 32);
	local searchEditBox_point, searchEditBox_relativePoint, searchEditBox_relativeTo, searchEditBox_offsetX, searchEditBox_offsetY = NpcTrackSearchEditBox:GetAnchor();
	ui.searchEditBox:ClearAllAnchors();
	ui.searchEditBox:SetAnchor(searchEditBox_point, searchEditBox_relativePoint, ui.searchFrame, searchEditBox_offsetX, searchEditBox_offsetY+9);
	ui.searchEditBox:SetScripts("OnEnterPressed", [=[ QuestState.Search(); ]=]);
	ui.searchEditBox:SetScripts("OnTextChanged", [=[ if(this:GetText() == "") then this.label:Show(); else this.label:Hide(); end; ]=]);
	
	ui.searchEditBox.label = CreateLabel("searchPlaceholder", ui.searchEditBox, "LEFT", "LEFT", ui.searchEditBox, 4, -4, 10);
	ui.searchEditBox.label:SetText("|cff7f7f7f"..ui.searchEditBox.label:GetText().."|r");

	ui.searchButton = CreateUIComponent("Button", "QuestState_searchButton", ui.searchFrame:GetName(), "NpcTrackSearchButton");
	ui.searchButton:Hide();
	ui.searchButton:SetScripts("OnLoad", [=[  ]=]);	-- "stack overflow" - workaround
	ui.searchButton:SetScripts("OnClick", [=[ QuestState.Search(); ]=]);
	
	
	
	--- Quest Info
	
	ui.questInfo = CreateFrame("questInfo", ui.searchFrame, 280, 76, "TOP", "BOTTOM", "NpcTrackSearchResultListFrame", 0, 4);
	local backdrop = {
		edgeFile = "Interface/Tooltips/Tooltip-border",
		bgFile = "Interface/Tooltips/Tooltip-background",
		BackgroundInsets = { top = 4, left = 4, bottom = 4, right = 4 },
		EdgeSize = 16,
		TileSize = 16,
	};
	ui.questInfo:SetBackdrop(backdrop);
	
	ui.nameFrame = CreateFrame("questName", ui.questInfo, 264, 16, "TOPLEFT", "TOPLEFT", ui.questInfo, 8, 8);
	ui.nameFrame:SetScripts("OnEnter", [=[ QuestState.UI.ShowTooltip("name"); ]=] );
	ui.nameFrame:SetScripts("OnLeave", [=[ GameTooltip:Hide(); ]=] );
	ui.name = CreateLabel("questName", ui.questInfo, "LEFT", "LEFT", ui.nameFrame, 0, 0, 16);
	
	ui.questLevelLabel = CreateLabel("questLevel", ui.questInfo, "TOPLEFT", "BOTTOMLEFT", ui.name, 0, 4);
	ui.questID = CreateLabel("questID", ui.questInfo, "TOP", "BOTTOM", ui.name, 0, 4);
	ui.questType = CreateLabel("questType", ui.questInfo, "TOPRIGHT", "BOTTOMRIGHT", ui.name, 0, 4);

	ui.npcsFrame = CreateFrame("questNPCs", ui.questInfo, 264, 12, "TOPLEFT", "BOTTOMLEFT", ui.questLevelLabel, 0, 4);
	ui.npcsFrame:SetScripts("OnEnter", [=[ QuestState.UI.ShowTooltip("npcs"); ]=] );
	ui.npcsFrame:SetScripts("OnLeave", [=[ GameTooltip:Hide(); ]=] );
	ui.npcs = CreateLabel("questNPCs", ui.npcsFrame, "LEFT", "LEFT", ui.npcsFrame, 0, 0);

	ui.searchLooseEndFrame = CreateFrame("searchLooseEnd", ui.questInfo, 264, 12, "BOTTOM", "BOTTOM", ui.questInfo, 0, -4);
	ui.searchLooseEndFrame:SetScripts("OnClick", [=[ QuestState.UI.SearchLooseEnd(); ]=] );
	ui.searchLooseEnd = CreateLabel("searchLooseEnd", ui.searchLooseEndFrame, "CENTER", "CENTER", ui.searchLooseEndFrame, 0, 0);
	
	
	
	--- Settings
	
	ui.settings = CreateFrame("settings", ui.searchFrame, 280, 76, "CENTER", "CENTER", ui.questInfo, 0, 0);
	ui.settings:SetBackdrop(backdrop);
	ui.settings.label = CreateLabel("settings", ui.settings, "TOPLEFT", "TOPLEFT", ui.settings, 8, 8, 16);
	ui.speakframe = CreateCheckbox("speakframe", ui.settings, "LEFT", "LEFT", ui.settings, 4, ui.settings.label:GetHeight()/2, [=[ QuestStateSettings["changeSpeakFrame"] = this:IsChecked(); ]=]);
	ui.speakframe.label:SetSize(250, 76-ui.settings.label:GetHeight());
	
	
	
	--- Tree
	
	ui.tree = CreateFrame("Tree", ui.searchFrame, 300, 0);
	ui.tree:SetBackdrop(backdrop);
	
	local backdropElement = {
		edgeFile = "Interface/Tooltips/Tooltip-border",
		bgFile = "Interface/Common/panelblackbackgroup",
		BackgroundInsets = { top = 4, left = 4, bottom = 4, right = 4 },
		EdgeSize = 16,
		TileSize = 16,
	};
	ui.curQFrame = CreateFrame("Tree_curQ", ui.tree, 250, 50, "BOTTOM", "BOTTOMLEFT", "NpcTrackFrame", -148, -216);
	ui.curQFrame:SetBackdrop(backdropElement);

	ui.curQLabel = CreateLabel("Tree_curQ", ui.curQFrame, "CENTER", "CENTER", ui.curQFrame, 0, 0, 14);
	ui.curQLabel:SetJustifyHType("CENTER");

	ui.preFrame = {};
	ui.preLabel = {};
	ui.postFrame = {};
	ui.postLabel = {};
	for i = 1, 5 do
		ui.preFrame[i] = CreateFrame("Tree_pre"..i, ui.tree, 140, 50);
		ui.preFrame[i]:SetID(0);
		ui.preFrame[i]:SetBackdrop(backdropElement);
		ui.preFrame[i]:SetScripts("OnClick", [=[ QuestState.LoadQuest(this:GetID()); ]=] );
		
		ui.preLabel[i] = CreateLabel("Tree_pre"..i, ui.preFrame[i], "CENTER", "CENTER", "QuestState_Tree_preFrame"..i, 0, 0, 11);
		ui.preLabel[i]:SetJustifyHType("CENTER");
		
		ui.postFrame[i] = CreateFrame("Tree_post"..i, ui.tree, 140, 50);
		ui.postFrame[i]:SetID(0);
		ui.postFrame[i]:SetBackdrop(backdropElement);
		ui.postFrame[i]:SetScripts("OnClick", [=[ QuestState.LoadQuest(this:GetID()); ]=] );

		ui.postLabel[i] = CreateLabel("Tree_post"..i, ui.postFrame[i], "CENTER", "CENTER", "QuestState_Tree_postFrame"..i, 0, 0, 11);
		ui.postLabel[i]:SetJustifyHType("CENTER");
	end;

	ui.requirementsTexture = CreateTexture("Tree_requirements", ui.tree, "TOP", "BOTTOM", ui.curQFrame, 0, 0);
	ui.requirementsTexture:SetFile("interface/addons/QuestState/images/down1");
	ui.requirementsTexture:SetSize(10, 10);
	ui.requirementsLabel = CreateLabel("requirements", ui.tree, "TOP", "BOTTOM", ui.requirementsTexture, 0, 2);
	ui.preTexture = CreateTexture("Tree_pre", ui.tree, "TOP", "BOTTOM", ui.requirementsLabel, 0, 2);
	
	ui.followUpTexture = CreateTexture("Tree_followUp", ui.tree, "BOTTOM", "TOP", ui.curQFrame, 0, 0);
	ui.followUpTexture:SetFile("interface/addons/QuestState/images/up1");
	ui.followUpTexture:SetSize(10, 10);
	ui.followUpLabel = CreateLabel("followUpQuests", ui.tree, "BOTTOM", "TOP", ui.followUpTexture, 0, -2);
	ui.postTexture = CreateTexture("Tree_post", ui.tree, "BOTTOM", "TOP", ui.followUpLabel, 0, -2);
	
	
	
	--- Register NPC Track Frame
	
	g_NpcTrackTabs[3] = { frame = ui.searchFrame:GetName(), tab = ui.tab:GetName(), title = "QuestState" };
	
	
	
	--- Speakframe
	
	ui.speakFrameOptionIcon = {};
	for i = 1, DF_MAX_SPEAKOPTION do
		ui.speakFrameOptionIcon[i] = CreateUIComponent("Texture", "QuestState_speakFrameOptionIcon"..i, "SpeakFrame_Option"..i.."_Button");
		ui.speakFrameOptionIcon[i]:ClearAllAnchors();
		ui.speakFrameOptionIcon[i]:SetAnchor("RIGHT", "RIGHT", "SpeakFrame_Option"..i.."_Button", 0, 0);
		ui.speakFrameOptionIcon[i]:SetTexCoord(0.0, 1.0, 0.0, 1.0); -- left, right, top, bottom
		ui.speakFrameOptionIcon[i]:SetColor(1.0, 1.0, 1.0);
		ui.speakFrameOptionIcon[i]:SetAlpha(1.0);
		ui.speakFrameOptionIcon[i]:SetAlphaMode("ADD");
		getglobal("SpeakFrame_Option"..i.."_Button"):SetLayers(3, ui.speakFrameOptionIcon[i]);
	end;
end;

function QuestState.UI.Reset()
	ui.questInfo:Hide();
	ui.settings:Show();
	ui.tree:Hide();
end;

function QuestState.UI.SetQuestInfo(questID)
	local quest = QuestState.quests[questID];
	
	ui.settings:Hide();
	ui.questInfo:Show();

	ui.name:SetText(QuestState.util.TEXT(questID));
	ui.name:SetWidth(264);

	local mainLevel, secLevel = UnitLevel("player");
	if(quest.l < mainLevel) then
		ui.questLevelLabel:SetText(QuestState.lang["level"]:format(quest.l));
	else
		ui.questLevelLabel:SetText(QuestState.lang["level"]:format("|cffff0000"..quest.l.."|r"));
	end;
	ui.questType:SetText(QuestState.lang["questType"..quest.t]);
	ui.questID:SetText(QuestState.lang["id"]:format(questID));

	ui.npcs:SetText(QuestState.lang["npcs"]:format(QuestState.util.GetAllNPCsString(quest.n)));
	ui.npcs:SetWidth(264);
	
	ui.searchLooseEnd:SetText("");
	ui.searchLooseEndFrame:SetMouseEnable(false);
	if((quest.r ~= nil) and (QuestState.util.CheckQuest(questID) == 0)) then
		local requirementsFulfilled = true;
		for k, v in pairs(quest.r) do
			if((v < 500000) and QuestState.util.CheckQuest(v) ~= 2) then	-- not a flag and quest not finished
				ui.searchLooseEnd:SetText(QuestState.lang["searchLooseEnd"]);
				ui.searchLooseEndFrame:SetMouseEnable(true);
				break;
			end;
		end;
	end;
	
	
	-- Tree
	local yOffset = SetFollowUpQuests(questID, quest.f) + 10;
	local height = SetRequirements(quest.r) + yOffset + 60;
	
	FillNode(ui.curQFrame, ui.curQLabel, questID);

	ui.tree:SetHeight(height);
	ui.tree:ClearAllAnchors();
	ui.tree:SetAnchor("TOP", "TOP", ui.curQFrame, 0, -yOffset);

	local x, y = NpcTrackFrame:GetPos();
	if(x < 300) then
		local point, relativePoint, relativeTo, offsetX, offsetY = NpcTrackFrame:GetAnchor();
		NpcTrackFrame:ClearAllAnchors();
		NpcTrackFrame:SetAnchor(point, relativePoint, relativeTo, offsetX+300-x, offsetY);
	end;
	ui.tree:Show();
end;

function QuestState.UI.GetSearchText()
	return ui.searchEditBox:GetText();
end;

function QuestState.UI.ShowSearchBox()
	UIDropDownMenu_SetSelectedID(ui.filter, 4);
	ui.sameMap:Hide();
	ui.normal:Hide();
	ui.daily:Hide();
	ui.public:Hide();
	ui.searchEditBox:Show();
	ui.searchButton:Show();
	ui.searchEditBox:SetText("");
	ui.searchEditBox:SetFocus();
end;

function QuestState.UI.HideSearchBox()
	ui.searchButton:Hide();
	ui.searchEditBox:Hide();
	ui.sameMap:Show();
	ui.normal:Show();
	ui.daily:Show();
	ui.public:Show();
end;

function QuestState.UI.IsVisible()
	return ui.searchFrame:IsVisible();
end;



--------------------------------------------------------------------------------

function QuestState.UI.SearchLooseEnd()
	if(QuestState.SearchLooseEnd()) then
		ui.searchLooseEnd:SetText("");
	else
		ui.searchLooseEnd:SetText(QuestState.lang["noLooseEndFound"]);
	end;
	ui.searchLooseEndFrame:SetMouseEnable(false);
end;

function QuestState.UI.ShowTooltip(text)
	local label = ui[text];
	local frame = ui[text.."Frame"];
	if(label:IsDrawDot()) then
		GameTooltip:SetText(label:GetText());
		GameTooltip:ClearAllAnchors();
		GameTooltip:SetAnchor("TOPLEFT", "TOPRIGHT", frame, 0, 0);
		GameTooltip:Show();
	end;
end;

function QuestState.UI.FilterDropDown_OnLoad(object)
	UIDropDownMenu_SetWidth(object, 160);
	UIDropDownMenu_Initialize(object, QuestState.UI.FilterDropDown_Show);
	UIDropDownMenu_SetSelectedID(object, 1);
end;

function QuestState.UI.FilterDropDown_Show()
	local selected = UIDropDownMenu_GetSelectedID(ui.filter);
	for i = 1, 4 do
		local info = {};
		info.func = QuestState.UI.FilterDropDown_Click;
		info.text = QuestState.lang["filter"..i];
		info.checked = i == selected; 
		UIDropDownMenu_AddButton(info);
	end;
end;

function QuestState.UI.FilterDropDown_Click(button)
	local id = button:GetID();
	UIDropDownMenu_SetSelectedID(ui.filter, id);
	QuestState.filter = id - 1;

	if(id == 4) then
		QuestState.UI.ShowSearchBox();
		QuestState.ClearResults();
	else
		QuestState.UI.HideSearchBox();
		QuestState.Search();
	end;
end;



--- NPC Track Frame

local oldSearchResultListMax = DF_NPCTRACKFRAME_SEARCHRESULTLIST_MAX;

function QuestState.UI.OnShow()
	for i = 7, oldSearchResultListMax do
		getglobal("NpcTrackSearchResultButton_"..i):Hide();
	end;
	DF_NPCTRACKFRAME_SEARCHRESULTLIST_MAX = 6;
	NpcTrackSearchResultListFrame:SetHeight(190);
	local point, relativePoint, relativeTo, x, y = NpcTrackNPCListFrame:GetAnchor();
	NpcTrackNPCListFrame:ClearAllAnchors();
	NpcTrackNPCListFrame:SetAnchor(point, relativePoint, relativeTo, 0, 84);

	-- workaround for editbox: Because Runewaker did not give one of NpcTrackSearchEditBox's texture layers a name there is no inherited "copy" and thus this "copied" layer
	-- (in fact it is not copied, it's the original) is always at the same position as it's original one. But it has to be repositioned.
	local point, relativePoint, relativeTo, offsetX, offsetY = ui.searchEditBox:GetAnchor();
	NpcTrackSearchEditBox:ClearAllAnchors();
	NpcTrackSearchEditBox:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY);
end;

function QuestState.UI.OnHide()
	for i = 7, oldSearchResultListMax do
		getglobal("NpcTrackSearchResultButton_"..i):Show();
	end;
	DF_NPCTRACKFRAME_SEARCHRESULTLIST_MAX = oldSearchResultListMax;
	NpcTrackSearchResultListFrame:SetHeight(270);
	local point, relativePoint, relativeTo, x, y = NpcTrackNPCListFrame:GetAnchor();
	NpcTrackNPCListFrame:ClearAllAnchors();
	NpcTrackNPCListFrame:SetAnchor(point, relativePoint, relativeTo, 0, 4);

	-- workaround for editbox: Because Runewaker did not give one of NpcTrackSearchEditBox's texture layers a name there is no inherited "copy" and thus this "copied" layer
	-- (in fact it is not copied, it's the original) is always at the same position as it's original one. But it has to be repositioned.
	local point, relativePoint, relativeTo, offsetX, offsetY = ui.searchEditBox:GetAnchor();
	NpcTrackSearchEditBox:ClearAllAnchors();
	NpcTrackSearchEditBox:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY-9);
end;

local hookedNpcTrackSearchResultListButton_OnClick = NpcTrackSearchResultListButton_OnClick;
function NpcTrackSearchResultListButton_OnClick(obj)
	hookedNpcTrackSearchResultListButton_OnClick(obj);

	if(QuestState.UI.IsVisible()) then
		QuestState.SetQuest(g_NpcTrackSearchResultTable[obj.index].id);
		SetMsgBar(g_NpcTrackSearchResultTable[obj.index]);
	end;
end;

local hookedNpcTrackNPCListButton_OnClick = NpcTrackNPCListButton_OnClick;
function NpcTrackNPCListButton_OnClick(obj)
	hookedNpcTrackNPCListButton_OnClick(obj);

	local q = g_NpcTrackTable[obj.index];
	if(q.id) then
		QuestState.SetQuest(q.id);
		SetMsgBar(q);
	end;
end;

local hookedNpcTrackFrame_InitializeNpcList = NpcTrackFrame_InitializeNpcList;
function NpcTrackFrame_InitializeNpcList(NpcID)
	hookedNpcTrackFrame_InitializeNpcList(NpcID);

	if(QuestState.UI.IsVisible()) then
		if((g_NpcTrackNPCListSelected == -1) or (g_NpcTrackNPCListSelected == nil)) then
			QuestState.SetQuest(nil);
		end;
		QuestState.Search();
	end;
end;

local hookedNpcTrackTraceButton_OnClick = NpcTrackTraceButton_OnClick;
function NpcTrackTraceButton_OnClick()
	if(ui.questInfo:IsVisible() and not g_NpcTrackSearchResultListSelected) then
		TraceNPC(ui.curQFrame:GetID(), QuestStateSettings["sameMap"]);
	end;

	hookedNpcTrackTraceButton_OnClick();
end



--- Speak Frame

local hookedSpeakFrame_LoadQuest = SpeakFrame_LoadQuest;
function SpeakFrame_LoadQuest()
	hookedSpeakFrame_LoadQuest();

	for i = 1, DF_MAX_SPEAKOPTION do
		ui.speakFrameOptionIcon[i]:Hide();
	end;
	if(QuestStateSettings["changeSpeakFrame"]) then
		local npcName = GetSpeakObjName();

		local iOption = 1;
		for i = 1, 3 do
			local num = GetNumQuest(i);
			if(num ~= 0) then
				iOption = iOption + 1;
			end;

			for j = 1, num do
				local questName, daily, group = GetQuestNameByIndex(i, j);
				local type = 0;
				if(daily) then
					type = 2;
				elseif(group == 3) then
					type = 3
				end;

				ui.speakFrameOptionIcon[iOption]:SetFile("interface/addons/QuestState/images/SpeakOption"..CheckQuest(QuestState.util.GetQuestIDByInfo(questName, npcName, type)));
				ui.speakFrameOptionIcon[iOption]:SetSize(28, 28);
				ui.speakFrameOptionIcon[iOption]:Show();

				iOption = iOption + 1;
			end;
		end;
	end;
end;

local hookedSpeakFrame_LoadQuestDetail = SpeakFrame_LoadQuestDetail; 
function SpeakFrame_LoadQuestDetail(quitmode)
	hookedSpeakFrame_LoadQuestDetail(quitmode);

	for i = 1, DF_MAX_SPEAKOPTION do
		ui.speakFrameOptionIcon[i]:Hide();
	end;
end;



------------------------------------ EVENTS ------------------------------------

function QuestState.UI.RESET_QUESTBOOK()
	QuestState.RESET_QUESTBOOK();
end;

function QuestState.UI.VARIABLES_LOADED()
	QuestState.VARIABLES_LOADED();

	ResizeTabs();
	
	ui.speakframe:SetChecked(QuestStateSettings["changeSpeakFrame"]);
	ui.sameMap:SetChecked(QuestStateSettings["sameMap"]);
	ui.normal:SetChecked(QuestStateSettings["normalQuests"]);
	ui.daily:SetChecked(QuestStateSettings["dailyQuests"]);
	ui.public:SetChecked(QuestStateSettings["publicQuests"]);
end;



---------------------------------- INITIALIZE ----------------------------------

local mainFrame = CreateUIComponent("Frame", "QuestState_mainFrame", "UIParent");
mainFrame:SetScripts("OnEvent", [=[ QuestState.UI[event](self, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9); ]=] );
mainFrame:SetScripts("OnLoad", [=[ if(QuestState.OnLoad()) then QuestState.UI.Create(); end;  ]=]);
mainFrame:RegisterEvent("RESET_QUESTBOOK");
mainFrame:RegisterEvent("VARIABLES_LOADED");
