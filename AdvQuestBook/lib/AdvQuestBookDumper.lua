--[[ ä

	Name: Advanced Questbook
	By: Crypton
	License: All Rights Reserved

]]
local PAT = AQB_PAT;
local LANG = AQB_LOCAL;
local LAST = "";

if (not AdvQuestBook_Dumped_Quests) then
	AdvQuestBook_Dumped_Quests = {};
	AdvQuestBook_Dumped_Quests[LANG] = {};
end

function AQB_ACCEPTQUEST(arg1, arg2)
	local i;
	local QID = arg1;
	local QNAME = arg2;
	local TOTAL = GetNumQuestBookButton_QuestBook();
	for i = 1, TOTAL do
		local INDEX, CATID, NAME, TRACK, LEVEL, DAILY = GetQuestInfo(i);
		local NAME = string.gsub(NAME, PAT.COMPLETE, "");
		if (NAME == QNAME) then
			if (not AdvQuestBook_Dumped_Quests) then
				AdvQuestBook_Dumped_Quests = {};
				AdvQuestBook_Dumped_Quests[LANG] = {};
			end
			if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][QNAME], true)) then
				ViewQuest_QuestBook(i);
				local NPCIDQ = QuestDetail_GetQuestNPC();
				local QNPCID, QNPCNAME, QNPCMAPID, QNPCX, QNPCY = "", "", "", "", "";
				if (not AQB_IsEmpty(NPCIDQ, true)) then
					QNPCID, QNPCNAME, QNPCMAPID, QNPCX, QNPCY = NpcTrack_GetNpc(NpcTrack_SearchNpcByDBID(NPCIDQ));
				end
				local NPCIDR = QuestDetail_GetRequestQuestNPC();
				local RNPCID, RNPCNAME, RNPCMAPID, RNPCX, RNPCY = "", "", "", "", "";
				if (not AQB_IsEmpty(NPCIDR, true)) then
					RNPCID, RNPCNAME, RNPCMAPID, RNPCX, RNPCY = NpcTrack_GetNpc(NpcTrack_SearchNpcByDBID(NPCIDR));
				end
				local EXP, TP, GOLD = GetQuestExp_QuestDetail(), GetQuestTP_QuestDetail(), GetQuestMoney_QuestDetail();
				if (AQB_IsEmpty(EXP, true)) then
					EXP = 0;
				end
				if (AQB_IsEmpty(TP, true)) then
					TP = 0;
				end
				if (AQB_IsEmpty(GOLD, true)) then
					GOLD = 0;
				end
				AdvQuestBook_Dumped_Quests[LANG][QNAME] = {
					["id"] = QID,
					["turnedin"] = false,
					["info"] = {
						["index"] = INDEX,
						["catalogID"] = CATID,
						["track"] = TRACK,
						["level"] = LEVEL,
						["daily"] = DAILY,
					},
					["start"] = {
						["npcid"] = QNPCID,
						["npc"] = QNPCNAME,
						["mapid"] = QNPCMAPID,
						["x"] = QNPCX,
						["y"] = QNPCY,
					},
					["end"] = {
						["npcid"] = RNPCID,
						["npc"] = RNPCNAME,
						["mapid"] = RNPCMAPID,
						["x"] = RNPCX,
						["y"] = RNPCY,
					},
					["rewards"] = {
						["Exp"] = EXP,
						["TP"] = TP,
						["Gold"] = GOLD,
					},
					["items"] = {
					},
					["locations"] = {
					},
				};
				SaveVariables("AdvQuestBook_Dumped_Quests");
				if (AdvQuestBookConfig:IsVisible()) then
					local AQB_COUNT_DUMPED = 0;
					local i, j;
					local qtxt;
					for i, j in pairs(AdvQuestBook_Dumped_Quests[LANG]) do
						AQB_COUNT_DUMPED = AQB_COUNT_DUMPED + 1;
					end
					if (AQB_COUNT_DUMPED == 1) then
						qtxt = " Quest";
					else
						qtxt = " Quests";
					end
					AdvQuestBookConfigCheckbox1QuestDumpText:SetText("("..AQB_COUNT_DUMPED..qtxt.." "..AdvQuestBook_Messages["AQB_DUMPED"]..")");
				end
			end
		end
	end
	return;
end

function AQB_ADDID(arg1)
	AdvQuestBook_Dumped_Quests[LANG][LAST]["id"] = arg1;
	SaveVariables("AdvQuestBook_Dumped_Quests");
	LAST = "";
	return;
end

function AQB_DROP(arg1)
	local i, v;
	local QNAME = arg1;
	local BACKUP = AdvQuestBook_Dumped_Quests[LANG];
	AdvQuestBook_Dumped_Quests[LANG] = {};
	for i, v in pairs(BACKUP) do
		if (i ~= QNAME) then
			AdvQuestBook_Dumped_Quests[LANG][i] = v;
		end
	end
	SaveVariables("AdvQuestBook_Dumped_Quests");
	return;
end

function AQB_MET(arg1, arg2, arg3, arg4)
	local i;
	local quest, mapid, x, y = arg1, arg2, arg3, arg4;
	if (not AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest], true)) then
		if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest]["locations"], true)) then
			AdvQuestBook_Dumped_Quests[LANG][quest]["locations"] = {};
		end
		for i = 1, 5 do
			if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest]["locations"][i], true)) then
				AdvQuestBook_Dumped_Quests[LANG][quest]["locations"][i] = {
					["mapid"] = mapid,
					["x"] = x,
					["y"] = y
				};
				SaveVariables("AdvQuestBook_Dumped_Quests");
				break;
			end
		end
	end
	return;
end

function AQB_QUPDATE(arg1, arg2, arg3, arg4, arg5, arg7)
	local quest, item, minitem, maxitem, mapid = arg1, arg2, arg3, arg4, arg5, arg6, arg7;
	if (not AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest], true)) then
		if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item], true)) then
			AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item] = {};
		end
		if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item]["total"], true)) then
			AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item]["total"] = maxitem;
		end
		if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item]["locations"], true)) then
			AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item]["locations"] = {};
		end
		for i = 1, maxitem do
			if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item]["locations"][i], true)) then
				AdvQuestBook_Dumped_Quests[LANG][quest]["items"][item]["locations"][i] = {
					["mapid"] = mapid,
					["x"] = x,
					["y"] = y
				};
				SaveVariables("AdvQuestBook_Dumped_Quests");
				break;
			end
		end
	end
	return;
end

function AQB_COMPLETE(arg1)
	local i, v;
	local id = arg1;
	local name = AdvQuestBookText[id]["name"]
	for i, v in pairs(AdvQuestBook_Dumped_Quests[LANG]) do
		if (v["id"] == id) then
			AdvQuestBook_Dumped_Quests[LANG][i]["turnedin"] = true;
			break;
		end
	end
	SaveVariables("AdvQuestBook_Dumped_Quests");
	if (AdvQuestBook_Config["settings"][4]["value"]) then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFFffffff"..AQB_ADDON_NAME..":|r "..name..AQB_PAT.COMPLETE..". "..AdvQuestBook_Messages["AQB_UPLOAD"], "|cFFffffffSaveVariables.lua|r", "|cFFffffffhttp://aqb.freevar.com|r"));
	end
	return;
end

function AQB_DUMPEVENT(this, event)
	if (AdvQuestBook_Config["settings"][1]["value"] and LANG == "ENUS") then
		local a1, a2 = arg1, arg2;
		if (event == "VARIABLES_LOADED") then
			if (not AdvQuestBook_Dumped_Quests) then
				AdvQuestBook_Dumped_Quests = {};
				AdvQuestBook_Dumped_Quests[LANG] = {};
			end
		elseif (event == "ADDNEW_QUESTBOOK") then
			if (not AdvQuestBookCoords[a1] or UnitName("player") == AQB_DEBUG_PL) then
				AQB_ADDID(a1);
			end
		elseif (event == "QUEST_COMPLETE") then
			if (not AdvQuestBookCoords[a2] or UnitName("player") == AQB_DEBUG_PL) then
				AQB_COMPLETE(a2);
			end
		elseif (event == "CHAT_MSG_SYSTEM") then
			if (string.match(a1, PAT.MET)) then
				local quest = string.match(a1, PAT.MET);
				local mapid = GetCurrentWorldMapID();
				local x, y = GetPlayerWorldMapPos();
				quest = string.match(string.match(string.gsub(quest, PAT.COMPLETE, ""), "^%s*(.+)"), "(.-)%s*$");
				local id = tonumber(AdvQuestBookByName[quest]);
				if (not AdvQuestBookCoords[id] or UnitName("player") == AQB_DEBUG_PL) then
					AQB_MET(quest, mapid, x, y);
				end
			elseif (string.match(a1, PAT.GETITEM) or string.match(a1, PAT.GETITEM..PAT.COMPLETE) or string.match(a1, PAT.KILLMOB) or string.match(a1, PAT.KILLMOB..PAT.COMPLETE)) then
				local quest, item, minitem, maxitem;
				--[[
					GETITEM and KILLMOB same on ENG servers. Did not check other
					lang files so adding dupes for -possible- multi-lang dump
					support later down the road.
				]]
				if (string.match(a1, PAT.GETITEM)) then
					quest, item, minitem, maxitem = string.match(a1, PAT.GETITEM);
				elseif (string.match(a1, PAT.KILLMOB)) then
					quest, item, minitem, maxitem = string.match(a1, PAT.KILLMOB);
				elseif (string.match(a1, PAT.GETITEM..PAT.COMPLETE)) then
					quest, item, minitem, maxitem = string.match(a1, PAT.GETITEM..PAT.COMPLETE);
					quest = string.gsub(quest, PAT.COMPLETE, "");
				else
					quest, item, minitem, maxitem = string.match(a1, PAT.KILLMOB..PAT.COMPLETE);
					quest = string.gsub(quest, PAT.COMPLETE, "");
				end
				quest = string.match(string.match(quest, "^%s*(.+)"), "(.-)%s*$");
				item = string.match(string.match(item, "^%s*(.+)"), "(.-)%s*$");
				local mapid = GetCurrentWorldMapID();
				local x, y = GetPlayerWorldMapPos();
				if (not AdvQuestBookCoords[AdvQuestBookByName[quest]] or UnitName("player") == AQB_DEBUG_PL) then
					AQB_QUPDATE(quest, item, minitem, maxitem, mapid, x, y);
				end
			end
		elseif (event == "SYSTEM_MESSAGE") then
			if (string.match(a1, PAT.GET)) then
				local id;
				local quest = string.match(string.match(string.match(a1, PAT.GET), "^%s*(.+)"), "(.-)%s*$");
				LAST = quest;
				if (AdvQuestBookByName[quest]) then
					id = tonumber(AdvQuestBookByName[quest]);
				else
					id = 0;
				end
				if (not AdvQuestBookCoords[AdvQuestBookByName[quest]] or UnitName("player") == AQB_DEBUG_PL) then
					if (AdvQuestBook_Config["settings"][4]["value"]) then
						DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFFffffff"..AQB_ADDON_NAME..":|r "..AdvQuestBook_Messages["AQB_NEW_QD"], quest));
					end
					AQB_ACCEPTQUEST(id, quest);
				end
			elseif (string.match(a1, PAT.GIVEUP)) then
				local quest = string.match(string.match(string.match(a1, PAT.GIVEUP), "^%s*(.+)"), "(.-)%s*$");
				AQB_DROP(quest);
			end
		end
	end
end
