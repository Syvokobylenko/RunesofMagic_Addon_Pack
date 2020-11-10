local QuestState = _G.QuestState;
QuestState.filter = 0;

QuestStateSettings = {};
local defaultSettings = {
	sameMap = false;
	normalQuests = true;
	dailyQuests = false;
	publicQuests = false;
	changeSpeakFrame = true;
};

local questsCategory = {};
local needsToBeRefeshed = true;
local history = {};
local currentQuestID = 0;



----------------------------------- UTILITY ------------------------------------

local function TableContains(t, val)
	for k, v in pairs(t) do
		if(val == v) then
			return true;
		end;
	end;
	return false;
end;

local function NewQueue()
	return {first = 0, last = -1};
end;

local function QueueEmpty(queue)
	return queue.last < queue.first;
end;

local function QueuePush(queue, value)
	local last = queue.last + 1;
	queue.last = last;
	queue[last] = value;
end;

local function QueuePop(queue)
	local first = queue.first;
	local value = queue[first];
	queue[first] = nil;
	queue.first = first + 1;
	return value;
end;



-------------------------------------- UI --------------------------------------

function QuestState.ClearResults()
	NpcTrackFrame_TrackPreview(nil);
	g_NpcTrackSearchResultListSelected = nil;
	g_NpcTrackSearchResultTable = {};
	NpcTrackSearchResultListScrollBar:SetMaxValue(0);
	NpcTrackSearchResultListScrollBar_OnValueChanged(NpcTrackSearchResultListScrollBar, 0);
end;

local function AddResult(id, name, npcID, mapID, x, z)
	local i = table.getn(g_NpcTrackSearchResultTable)+1;
	g_NpcTrackSearchResultTable[i] = {};
	g_NpcTrackSearchResultTable[i].id = id;
	g_NpcTrackSearchResultTable[i].name = name;
	g_NpcTrackSearchResultTable[i].npcID = npcID;
	g_NpcTrackSearchResultTable[i].mapID = mapID;
	g_NpcTrackSearchResultTable[i].x = x;
	g_NpcTrackSearchResultTable[i].z = z;
end;

local function ShowResults()
	local n = table.getn(g_NpcTrackSearchResultTable);

	if(n > DF_NPCTRACKFRAME_SEARCHRESULTLIST_MAX) then
		NpcTrackSearchResultListScrollBar:SetMaxValue(n - DF_NPCTRACKFRAME_SEARCHRESULTLIST_MAX);
	else
		NpcTrackSearchResultListScrollBar:SetMaxValue(0);
	end

	NpcTrackSearchResultListScrollBar_OnValueChanged(NpcTrackSearchResultListScrollBar, 0);
end;

function QuestState.SetNPCOnMap(npcID)
	local info = {};
	info.mapID, info.x, info.z = QuestState.util.GetNPCData(npcID);
	info.name = QuestState.util.GetAllNPCsString({npcID});
	NpcTrackFrame_TrackPreview(info);
	
	g_NpcTrackSearchResultListSelected = nil;
	g_NpcTrackNPCListSelected = nil;
	NpcTrackFrame_UpdateNpcList();
	NpcTrackFrame_UpdateNpcSearchResultList();
	
	if(info.mapID == 400) then
		NpcTrackFrameFlagTexture:Hide();
		NpcTrackWorldMapFrameMsgBar:Hide();
	end;
end;



--------------------------------------------------------------------------------

local function UpdateTable()
	questsCategory = {};
	questsCategory[0] = {};
	questsCategory[1] = {};
	questsCategory[2] = {};

	for id = QuestState.minQuestID, QuestState.maxQuestID do
		if(QuestState.quests[id] ~= nil) then
			table.insert(questsCategory[QuestState.util.CheckQuest(id)], id);
		end;
	end;
end;

function QuestState.GetHistoryTop()
	return history[table.getn(history)];
end;

local function AddToHistory(questID)
	if(questID == QuestState.GetHistoryTop()) then
		table.remove(history);	-- removes last element
	else
		local currentQuest = QuestState.quests[currentQuestID];
		if(currentQuest ~= nil) then
			local connected = false;
			if(currentQuest.r ~= nil) then
				connected = TableContains(currentQuest.r, questID);
			end;
			if(currentQuest.f ~= nil and not connected) then
				connected = TableContains(currentQuest.f, questID);
			end;
			if(connected) then
				table.insert(history, currentQuestID);
			else
				history = {};
			end;
		end;
	end;
end;

local function FillResultTable(questID, sameMapRequired)
	local quest = QuestState.quests[questID];

	local npcID = 0;
	local map = 400;
	local x = 0.5;
	local z = 0.5;
	
	if(sameMapRequired) then
		table.sort(quest.n, QuestState.util.SortNpcsPreferSameMap);
	else
		table.sort(quest.n, QuestState.util.SortNpcs);
	end;
	if(quest.n[1] ~= nil) then
		npcID = quest.n[1];
		map, x, z = QuestState.util.GetNPCData(npcID);
	end;

	if(not sameMapRequired or (map == GetCurrentWorldMapID())) then
		AddResult(questID, quest.name, npcID, map, x, z);
	end;
end;



--------------------------------------------------------------------------------

function QuestState.LoadQuest(questID)
	if(questID < 0) then
		QuestState.ListAllFollowUpQuests(-questID);
	elseif(QuestState.quests[questID] ~= nil) then
		table.sort(QuestState.quests[questID].n, QuestState.util.SortNpcs);
		QuestState.SetQuest(questID);
		QuestState.SetNPCOnMap(QuestState.quests[questID].n[1]);
	end;
end;

function QuestState.SetQuest(questID)
	if(questID == nil) then
		history = {};
		QuestState.UI.Reset();
		return;
	elseif(QuestState.quests[questID] ~= nil) then
		AddToHistory(questID);
		currentQuestID = questID;
		
		QuestState.UI.SetQuestInfo(questID);
	end;
end;

function QuestState.ListAllFollowUpQuests(questID)
	QuestState.ClearResults();

	local followUpQuest = QuestState.quests[questID].f;
	if(followUpQuest ~= nil) then
		for k, id in pairs(followUpQuest) do
			local npcID = 0;
			local map = 400;
			local x = 0.5;
			local z = 0.5;
			
			local quest = QuestState.quests[id];
			table.sort(quest.n, QuestState.util.SortNpcs);
			if(quest.n[1] ~= nil) then
				npcID = quest.n[1];
				map, x, z = QuestState.util.GetNPCData(npcID);
			end;
			AddResult(id, quest.name, npcID, map, x, z);
		end;
	end;
	
	ShowResults();
	QuestState.filter = 3;
	QuestState.UI.ShowSearchBox();
end;



--------------------------------------------------------------------------------

function QuestState.RESET_QUESTBOOK()
	needsToBeRefeshed = true;
	if(QuestState.UI.IsVisible() and (QuestState.filter ~= 3)) then
		QuestState.Search();
	end;
end;

function QuestState.VARIABLES_LOADED()
	for k, v in pairs(defaultSettings) do
		if(QuestStateSettings[k] == nil) then
			QuestStateSettings[k] = v;
		end;
	end;
end;

function QuestState.OnLoad()
	SaveVariables("QuestStateSettings");
	
	if(not QuestState.util.LoadLang()) then
		return false;
	end;
	
	if(not QuestState.util.LoadFlags()) then
		return false;
	end;
	
	for id, quest in pairs(QuestState.quests) do
		quest.name = QuestState.util.TEXT(id);
	end;
	
	return true;
end;

function QuestState.Search()
	if(needsToBeRefeshed) then
		UpdateTable();
		needsToBeRefeshed = false;
	end;

	local normalQuests		= QuestStateSettings["normalQuests"]	or (QuestState.filter == 3);
	local dailyQuests		= QuestStateSettings["dailyQuests"]		or (QuestState.filter == 3);
	local publicQuests		= QuestStateSettings["publicQuests"]	or (QuestState.filter == 3);
	local sameMapRequired	= QuestStateSettings["sameMap"]			and (QuestState.filter ~= 3);

	QuestState.ClearResults();

	if(QuestState.filter == 3) then
		local searchText = string.lower(QuestState.UI.GetSearchText());
		for id = QuestState.minQuestID, QuestState.maxQuestID do
			if(QuestState.quests[id] ~= nil) then
				if(tostring(id) == searchText or (string.find(string.lower(TEXT("Sys"..id.."_name")), searchText) ~= nil)) then
					local quest = QuestState.quests[id];
					if((quest.t == 0 and normalQuests) or (quest.t == 2 and dailyQuests) or (quest.t == 3 and publicQuests)) then	-- quest.t == type
						FillResultTable(id, sameMapRequired);
					end;
				end;
			end;
		end;
	else
		for k, id in pairs(questsCategory[QuestState.filter]) do
			local quest = QuestState.quests[id];
			if((quest.t == 0 and normalQuests) or (quest.t == 2 and dailyQuests) or (quest.t == 3 and publicQuests)) then	-- quest.t = type
				FillResultTable(id, sameMapRequired);
			end;
		end;
	end;

	ShowResults();
end;

function QuestState.SearchLooseEnd()
	local queue = NewQueue();
	QueuePush(queue, {id = currentQuestID, path = {}});
	
	local result = nil;
	while(not QueueEmpty(queue)) do
		local quest = QueuePop(queue);
		if(QuestState.quests[quest.id] ~= nil) then
			local requirements = QuestState.quests[quest.id].r;
			if(requirements ~= nil) then
				local requirementsFulfilled = true;
				for k, v in pairs(requirements) do
					local status = QuestState.util.CheckQuest(v);
					if(status == 1) then	-- active quest, available quest found
						local pathReq = quest.path;
						table.insert(pathReq, quest.id);
						result = {id = v, path = pathReq};
						break;
					elseif(status == 0) then
						requirementsFulfilled = false;
						if(v < 500000) then	-- not a flag
							local pathReq = quest.path;
							table.insert(pathReq, quest.id);
							QueuePush(queue, {id = v, path = pathReq});
						end;
					end;
				end;
				if(result ~= nil) then
					break;
				end;
				if(requirementsFulfilled) then	-- unfinished quest with fulfilled requirements, available quest found
					result = quest;
					break;
				end;
			else	-- unfinished quest with no requirements, available quest found
				result = quest;
				break;
			end;
		end;
	end;
	
	if(result ~= nil) then
		for i = 2, table.getn(result.path) do
			AddToHistory(result.path[i]);
			currentQuestID = result.path[i];
		end;
		
		QuestState.LoadQuest(result.id);
		return true;
	else
		return false;
	end;
end;
