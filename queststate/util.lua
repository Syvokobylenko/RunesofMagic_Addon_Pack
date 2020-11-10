local QuestState = {};
_G.QuestState = QuestState;
QuestState.util = {};

function QuestState.util.CheckQuest(quest)
	if(quest >= 500000) then	-- flags
		return 2*CheckFlag(quest);
	end;
	return CheckQuest(quest);
end;

function QuestState.util.GetAllNPCsString(npcIDs)
	local text = "";
	
	for k, npcID in pairs(npcIDs) do
		if(npcs ~= 0) then
			if(text ~= "") then
				text = text..", ";
			end;
			local found = NpcTrack_SearchNpcByDBID(npcID);
			if(found == 1) then
				if(text == "") then	-- This npc is the one shown on the map
					text = text.."|cff00ff00"..TEXT("Sys"..npcID.."_name").."|r";
				else
					text = text.."|cffffff00"..TEXT("Sys"..npcID.."_name").."|r";
				end;
			else
				text = text.."|cffff0000"..TEXT("Sys"..npcID.."_name").."|r";
			end;
		end;
	end;

	if(text == "") then
		return QuestState.lang["unknown"];
	else
		return text;
	end;
end;

function QuestState.util.GetNPCData(npcID)
	local map = 400;
	local x = 0.5;
	local z = 0.5;

	if(QuestState.npcs[npcID]) then
		map = QuestState.npcs[npcID].m;
		x = QuestState.npcs[npcID].x;
		z = QuestState.npcs[npcID].z;
	else
		local found = NpcTrack_SearchNpcByDBID(npcID);	-- if the npc is not in the database maybe the client can find him
		if(found == 1) then
			local npcID;
			local npcName;
			npcID, npcName, map, x, z = NpcTrack_GetNpc(1);
		end;
	end;
	
	return map, x, z;
end;

function QuestState.util.GetQuestIDByInfo(questName, npcName, questType)
	for id, info in pairs(QuestState.quests) do
		if((TEXT("Sys"..id.."_name") == questName) and (info.t == questType)) then
			if(type(info.n) == "number") then
				if(TEXT("Sys"..info.n.."_name") == npcName) then
					return id;
				end;
			else
				for i = 1, table.getn(info.n) do
					if(TEXT("Sys"..info.n[i].."_name") == npcName) then
						return id;
					end;
				end;
			end;
		end;
	end;

	return 0;
end;

function QuestState.util.LoadFile(filename)
	local func, error = loadfile("Interface/Addons/QuestState/"..filename);
	if(error) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffff0000QUESTSTATE ERROR: "..filename.." missing or invalid!|r");
		return false;
	end;
	func();
	
	return true;
end;

function QuestState.util.LoadLang()
	local lang = string.lower(string.sub(GetLanguage(),1,2));
	if(not QuestState.util.LoadFile("lang/"..lang..".lua")) then
		if(not QuestState.util.LoadFile("lang/eneu.lua")) then
			return false;
		end;
	end;
	
	return true;
end;

function QuestState.util.LoadFlags()
	if(not QuestState.util.LoadFile("flags.lua")) then
		return false;
	end;
	
	return true;
end;

function QuestState.util.SortNpcs(npcID1, npcID2)
	local trackable1 = NpcTrack_SearchNpcByDBID(npcID1) == 1;
	local trackable2 = NpcTrack_SearchNpcByDBID(npcID2) == 1;
	
	if(trackable1 and not trackable2) then
		return true;
	elseif(trackable2 and not trackable1) then
		return false;
	end;
	
	local map1, x1, z1 = QuestState.util.GetNPCData(npcID1);
	local map2, x2, z2 = QuestState.util.GetNPCData(npcID2);
	local currentMap = GetCurrentWorldMapID();
	local onMap1 = map1 == currentMap;
	local onMap2 = map2 == currentMap;
	
	if(onMap1 and not onMap2) then
		return true;
	elseif(onMap2 and not onMap1) then
		return false;
	end;
	
	if(map1 ~= 400 and map2 == 400) then
		return true;
	elseif(map1 == 400 and map2 ~= 400) then
		return false;
	end;
	
	return npcID1 < npcID2;
end;

function QuestState.util.SortNpcsPreferSameMap(npcID1, npcID2)
	local map1, x1, z1 = QuestState.util.GetNPCData(npcID1);
	local map2, x2, z2 = QuestState.util.GetNPCData(npcID2);
	local currentMap = GetCurrentWorldMapID();
	local onMap1 = map1 == currentMap;
	local onMap2 = map2 == currentMap;
	
	if(onMap1 and not onMap2) then
		return true;
	elseif(onMap2 and not onMap1) then
		return false;
	end;
	
	local trackable1 = NpcTrack_SearchNpcByDBID(npcID1) == 1;
	local trackable2 = NpcTrack_SearchNpcByDBID(npcID2) == 1;
	
	if(trackable1 and not trackable2) then
		return true;
	elseif(trackable2 and not trackable1) then
		return false;
	end;
	
	if(map1 ~= 400 and map2 == 400) then
		return true;
	elseif(map1 == 400 and map2 ~= 400) then
		return false;
	end;
	
	return npcID1 < npcID2;
end;

function QuestState.util.TEXT(id)
	if(id >= 500000) then   -- flags
		if(TEXT("Sys"..id.."_name") ~= "Sys"..id.."_name") then
			return TEXT("Sys"..id.."_name");
		end;
		if(QuestState.flags[id] ~= nil) then
			return QuestState.flags[id];
		end;

		return QuestState.lang["internalFlag"]:format(id);
	end;

	return TEXT("Sys"..id.."_name");
end;
