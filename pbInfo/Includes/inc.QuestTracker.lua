--[[
pbInfo - Includes/inc.QuestTracker.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
pbInfo.QuestTracker.Loaded = false;
pbInfo.QuestTracker.Quests = {};
pbInfo.QuestTracker.TrackedQuests = {};

function pbInfo.QuestTracker.UpdateTracker()
	local questTrackNum = GetQuestTrack(-1);
	if (questTrackNum == 0) then
		pbInfoQuestTracker:Hide();
		return false;
	else
		pbInfoQuestTracker:Show();
	end;
	local RED, GREEN, YELLOW, COLORDAILY = "FF0000", "00FF00", "FFFF00", RGBtoHEX(unpack(pbInfoSettings["QuestTrackerColors"][1])); -- configurable in future versions
	local questTrackMax = 30;
	local width = pbInfoQuestTracker:GetWidth();
	local quests = {};
	for i = 1, questTrackNum, 1 do
		quests[i] = {};
		quests[i]["name"], quests[i]["level"], quests[i]["items"] = pbInfo.QuestTracker.ParseQuest(GetQuestTrack(i));
	end;
	table.sort(quests, pbInfo.QuestTracker.SortTracker);
	for i, v in pairs(quests) do
		local quest = quests[i];
		local questFrame 		= _G["pbInfoQuestTrackerQuest" .. i];
		local questFrameTitle 	= _G["pbInfoQuestTrackerQuest" .. i .. "Title"];
		local questFrameItems 	= _G["pbInfoQuestTrackerQuest" .. i .. "Items"];
		local questInfo = pbInfo.QuestTracker.Quests[quest["name"]] or {};
		pbInfo.QuestTracker.TrackedQuests[i] = quest["name"];

		questFrame:SetWidth(width);
		questFrameTitle:SetWidth(width);
		questFrameItems:SetWidth(width - 10);

		local questDifficulty = GetCurrentVocLV() - quest["level"];
		local questColor = YELLOW;
		if (questDifficulty <= -3) then
			questColor = RED;
		elseif (questDifficulty >= 3) then
			questColor = GREEN;
		end;

		local items = "";
		local numItems, numItemsCompleted = 0, 0;
		for _, v in pairs(quest["items"]) do
			local num = "";
			if (type(v["itemNum"]) == "number") then
				num = v["itemNum"] .. "/" .. v["itemMax"];
				if (not v["itemComplete"]) then
					if (pbInfoSettings["QUESTTRACKERPROGRESSCOLORFADE"]) then
						num = pbColor(num, HSBtoHEX(math.ceil((v["itemNum"]/v["itemMax"]) * 127.5), 100, 100));
					else
						if (v["itemNum"] == 0) then
							num = pbColor(num, RED);
						elseif (v["itemNum"] < v["itemMax"]) then
							num = pbColor(num, YELLOW);
						end;
					end;
				end;
				num = ": " .. num;
			end;
			local item = v["itemName"] .. num;
			if (v["itemComplete"] == true) then
				item = pbColor(item, GREEN);
				numItemsCompleted = numItemsCompleted + 1;
			end;
			items = items .. item .. "\n";
			numItems = numItems + 1;
		end;
		local title, level = "", pbColor(quest["level"], questColor);
		if (questInfo["daily"] and pbInfoSettings["QUESTTRACKERHIGHLIGHTDAILIES"]) then
			level = pbColor("[", COLORDAILY) .. level .. pbColor("] ", COLORDAILY);
		else
			level = "[" .. level .. "] ";
		end;
		if (numItems == numItemsCompleted) then
			title = level .. pbColor(quest["name"], GREEN);
		elseif (questInfo["daily"] and pbInfoSettings["QUESTTRACKERHIGHLIGHTDAILIES"]) then
			title = level .. pbColor(quest["name"], COLORDAILY);
		else
			title = level .. quest["name"];
		end;
		questFrameTitle:SetText(title);
		questFrameItems:SetText(items);
		questFrame:SetHeight(questFrameTitle:GetHeight() + questFrameItems:GetHeight() + 5);
		questFrame:Show();
	end;
	for i = questTrackNum + 1, questTrackMax, 1 do
		_G["pbInfoQuestTrackerQuest" .. i]:Hide();
		pbInfo.QuestTracker.TrackedQuests[i] = nil;
	end;
end;

function pbInfo.QuestTracker.ParseQuest(id)
	local questName = GetQuestRequest(id, -2);
	local questLevel = GetQuestRequest(id, -3);
	local questItems = {};

	local i = 1;
	repeat
		local questItem = GetQuestRequest(id, i);
		if (type(questItem) == "string") then
			questItems[i] = {};
			local itemComplete = false;
			-- additional pattern for Japanese
			-- JP client has 2 strings for "QuestName (CompleteText)" and "QuestItem (CompleteItemText)"
			if (pbInfo.QuestTracker.CompleteItemText and string.find(questItem, pbInfo.QuestTracker.CompleteItemText)) then
				itemComplete = true;
				questItem = string.gsub(questItem, pbInfo.QuestTracker.CompleteItemText, "");
			elseif (string.find(questItem, pbInfo.QuestTracker.CompleteText)) then
				itemComplete = true;
				questItem = string.gsub(questItem, pbInfo.QuestTracker.CompleteText, "");
			end;
			local itemcount_start, itemcount_end, itemNum, itemMax = string.find(questItem, "(%d+)/(%d+)");
			local name_start, name_end = 1, (itemcount_start and (itemcount_start - 2)) or string.len(questItem);
			questItems[i]["itemName"] = string.sub(questItem, name_start, name_end);
			questItems[i]["itemComplete"] = itemComplete;
			if (type(itemNum) == "string" and type(itemMax) == "string") then
				questItems[i]["itemNum"] = tonumber(itemNum);
				questItems[i]["itemMax"] = tonumber(itemMax);
			end;
			i = i + 1;
		else
			i = 0;
		end;
	until(i == 0);
	return questName, questLevel, questItems;
end;

function pbInfo.QuestTracker.Tooltip(frame)
	local id = frame:GetID();
	local name = pbInfo.QuestTracker.TrackedQuests[id];
	local quest = pbInfo.QuestTracker.Quests[name];
	local RED, GREEN, YELLOW, LIGHTBLUE = "FF0000", "00FF00", "FFFF00", "00FFFF"; -- configurable in future versions
	if (type(quest) ~= "table") then return; end;
	local daily = (quest["daily"] and "\n(" .. pbInfo.Locale["QuestTracker"]["DAILY"] .. ")") or "";
	local reward = (not pbIsEmpty(quest["reward"]["experience"]) and pbColor("\n" .. pbInfo.Locale["QuestTracker"]["XP"] .. ": " .. pbAddThousandsSeparator(quest["reward"]["experience"]), GREEN)) or "";
	local reward = reward .. ((not pbIsEmpty(quest["reward"]["talentpoints"]) and pbColor("\n" .. pbInfo.Locale["QuestTracker"]["TP"] .. ": " .. pbAddThousandsSeparator(quest["reward"]["talentpoints"]), LIGHTBLUE)) or "");
	local reward = reward .. ((not pbIsEmpty(quest["reward"]["money"]) and pbColor("\n" .. pbInfo.Locale["QuestTracker"]["GOLD"] .. ": " .. pbAddThousandsSeparator(quest["reward"]["money"]), YELLOW)) or "");
	GameTooltip:SetOwner(frame, (pbInfoSettings["QUESTTRACKERTOOLTIPRIGHT"] and "ANCHOR_RIGHT") or "ANCHOR_LEFT");
	GameTooltip:ClearLines();
	GameTooltip:SetText(name, 1.0, 1.0, 1.0);
	GameTooltip:AddLine(((quest["parentName"] ~= false and quest["parentName"]) or "") .. daily, 1.0, 1.0, 1.0);
--	GameTooltip:AddLine("Questgeber: " .. quest["questNPC"]["name"], 1.0, 1.0, 1.0);
	if (type(quest["rewardNPC"]["name"]) == "string") then
		local zone = (not pbIsEmpty(GetZoneLocalName(quest["rewardNPC"]["mapId"]))
			and GetZoneLocalName(quest["rewardNPC"]["mapId"])
				.. ": " 
				.. string.format("%0.1f", quest["rewardNPC"]["x"] * 100)	.. ", "	.. string.format("%0.1f", quest["rewardNPC"]["y"] * 100)
		) or "";
		GameTooltip:AddLine("\n" .. pbInfo.Locale["QuestTracker"]["QUESTNPC"] .. ":\n" .. quest["rewardNPC"]["name"] .. "\n" .. zone, 1.0, 1.0, 1.0);
	end;
	if (not pbIsEmpty(reward)) then
		GameTooltip:AddLine("\n" .. pbInfo.Locale["QuestTracker"]["REWARD"] .. ":" .. reward, 1.0, 1.0, 1.0);
	end;
	if (quest["daily"]) then
		local item, items = {}, string.gsub(_G["pbInfoQuestTrackerQuest" .. id .. "Items"]:GetText(), "|c%w%w%w%w%w%w%w%w(.-)|r", "%1");
		item.name, item.max = string.match(items, "%s(.+):.+/(%d+)");
		if (not pbIsEmpty(item.name)) then
			local a = {"Get"}; -- fix for possible errors
			for k, v in pairs(a) do
				item.name = string.gsub(item.name, v, "");
			end;
			item.count = pbInfo.Tooltip.getItemCount(item.name);
			local count = item.count[1] + item.count[2];
			if (count > 0) then
				GameTooltip:AddLine("\n" .. pbInfo.Locale["QuestTracker"]["DQITEMS"] .. ":\n" .. (item.count[1] + item.count[2]) .. "/" .. item.max .. " [" .. math.floor((item.count[1] + item.count[2]) / item.max) .. " " .. pbInfo.Locale["QuestTracker"]["COMPLQUESTS"] .. "]", 1.0, 1.0, 1.0);
			end;
		end;
	end;
	if (not pbIsEmpty(quest["description"]) and pbInfoSettings["QUESTTRACKERTOOLTIPDESCRIPTION"]) then
		quest["description"] = string.gsub(quest["description"], "|Hnpc:%d+|h(.-)|h", "%1");
		quest["description"] = string.gsub(quest["description"], "|c%w%w%w%w%w%w%w%w(.-)|r", "%1");
		quest["description"] = string.gsub(quest["description"], "%[(.-)%]", "%1");
		GameTooltip:AddLine("\n" .. quest["description"], 1.0, 1.0, 1.0);
	end;
	GameTooltip:Show();
end;

function pbInfo.QuestTracker.UpdateTrackerQuests()
	local numQuests = GetNumQuestBookButton_QuestBook();
	for i = 1, numQuests, 1 do
		local index, catalogId, name, track, level, daily = GetQuestInfo(i);
		name = GetQuestRequest(i, -2);
		name = string.gsub(name, "%s" .. pbInfo.QuestTracker.CompleteText, "");
		local parentName = pbInfo.QuestTracker.GetCategoryName(name) or false;
		ViewQuest_QuestBook(index);
		local qNPCid = QuestDetail_GetQuestNPC();
		local rNPCid = QuestDetail_GetRequestQuestNPC();
		local questNPCid, questNPCname, questNPCmapID, questNPCx, questNPCy = false, false, false, false, false;
		local rewardNPCid, rewardNPCname, rewardNPCmapID, rewardNPCx, rewardNPCy = false, false, false, false, false;
		if (not pbIsEmpty(qNPCid, true)) then
			questNPCid, questNPCname, questNPCmapID, questNPCx, questNPCy = NpcTrack_GetNpc(NpcTrack_SearchNpcByDBID(qNPCid));
		end;
		if (not pbIsEmpty(rNPCid, true)) then
			rewardNPCid, rewardNPCname, rewardNPCmapID, rewardNPCx, rewardNPCy = NpcTrack_GetNpc(NpcTrack_SearchNpcByDBID(rNPCid));
		end;
		local experience, talentpoints, money = GetQuestExp_QuestDetail(), GetQuestTP_QuestDetail(), GetQuestMoney_QuestDetail();

		pbInfo.QuestTracker.Quests[name] = {
			["index"] = index,
			["catalogId"] = catalogId,
			["parentName"] = parentName,
			["track"] = track,-- 0 = no track possible, 1 = not tracked, 2 = tracked; daily: true/false
			["level"] = level,
			["daily"] = daily,-- true/false
			["description"] = GetQuestDesc_QuestDetail(1);
			["questNPC"] = {
				["id"] = questNPCid,
				["name"] = questNPCname,
				["mapId"] = questNPCmapID,
				["x"] = questNPCx,
				["y"] = questNPCy
			},
			["rewardNPC"] = {
				["id"] = rewardNPCid,
				["name"] = rewardNPCname,
				["mapId"] = rewardNPCmapID,
				["x"] = rewardNPCx,
				["y"] = rewardNPCy
			},
			["reward"] = {
				["experience"] = experience,
				["talentpoints"] = talentpoints,
				["money"] = money
			}
		}
		pbInfo.QuestTracker.QuestParents = {}
		for i, v in pairs(pbInfo.QuestTracker.Quests) do
			if (type(pbInfo.QuestTracker.QuestParents[v["parentName"]]) ~= "table") then
				pbInfo.QuestTracker.QuestParents[v["parentName"]] = {};
			end;
			table.insert(pbInfo.QuestTracker.QuestParents[v["parentName"]], i);
		end;
	end;
end;

function pbInfo.QuestTracker.InfoTooltip(frame)
	GameTooltip:SetOwner(frame, (pbInfoSettings["QUESTTRACKERTOOLTIPRIGHT"] and "ANCHOR_RIGHT") or "ANCHOR_LEFT");
	GameTooltip:ClearLines();
	GameTooltip:SetText(pbInfo.Locale["Config"]["TabQuestTracker"], 1.0, 1.0, 1.0);
	GameTooltip:AddLine(pbInfo.Locale["QuestTracker"]["INFOTOOLTIP"], 0.0, 0.75, 0.95);
	GameTooltip:Show();
end;

function pbInfo.QuestTracker.SortTracker(a, b)
	if (not type(a) == "table" and not type(b) == "table") then 
		return false;
	end;
	local sortby = {"level", "name"};
	if (a[sortby[1]] == b[sortby[1]]) then
		return a[sortby[2]] < b[sortby[2]];
	end;
	if (pbInfoSettings["QUESTTRACKERSORTASC"]) then
		return a[sortby[1]] < b[sortby[1]];
	else
		return a[sortby[1]] > b[sortby[1]];
	end;
end;

function pbInfo.QuestTracker.CheckDailyQuests(msg)
    if (not pbIsEmpty(msg)) then
        local dailies = (
            string.match(msg, pbInfo.QuestTracker.DailyQuestPatterns[1])
            or (string.find(msg, pbInfo.QuestTracker.DailyQuestPatterns[2]) and "0")
            or (string.find(msg, pbInfo.QuestTracker.DailyQuestPatterns[3]) and "10")
        );
        if (type(dailies) == "string") then
            local dailyQuestsDone, dailyQuestsPerDay = Daily_count();
            pbInfoQuestTracker_Dailies:SetText((dailyQuestsPerDay - dailyQuestsDone) .. "/" .. dailyQuestsPerDay);
        end
        if (pbInfoSettings["QUESTTRACKERSHOWDAILIESCOUNTER"]) then
            pbInfoQuestTracker_Dailies:Show();
        end
    end
end

function pbInfo.QuestTracker.ShowOnWorldmap(npc)
	if (not pbIsEmpty(npc["mapId"], true)) then
		WorldMapFrame:Show();
		WorldMap_SelectMapMenu_OnClick({arg1 = "SelectZone", value = npc["mapId"], })
		local width, height = WorldMapViewFrame:GetSize();
		pbInfoQuestTracker_Worldmap:SetID(npc["id"]);
		pbInfoQuestTracker_Worldmap:ClearAllAnchors();
		pbInfoQuestTracker_Worldmap:SetAnchor("BOTTOMLEFT", "TOPLEFT", "WorldMapViewFrame", npc["x"] * width - 4, npc["y"] * height);
		pbInfoQuestTracker_Worldmap:Show();
	end;
end;

function pbInfo.QuestTracker.Scripts.OnLoad(this)
	if (pbInfoSettings["QUESTTRACKER"] == false or pbInfoSettings["ENABLE"] == false) then
		this:Hide();
	else
		local scale, x, y = GetUIScale(), unpack(pbInfoSettings["QuestTrackerPosition"]);
		
		this:ClearAllAnchors();
		this:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", x / scale, y / scale);
		
		pbInfoQuestTracker_Head:SetHeight(pbInfoSettings["QuestTrackerFontSizes"][1] + 3);
		
		pbInfoQuestTracker_Title:SetText("");
		pbInfoQuestTracker_Title:SetHeight(pbInfoSettings["QuestTrackerFontSizes"][1]);
		pbInfoQuestTracker_Title:SetFontSize(pbInfoSettings["QuestTrackerFontSizes"][1]);
		
		pbInfoQuestTracker_Dailies:SetText("");
		pbInfoQuestTracker_Dailies:SetHeight(pbInfoSettings["QuestTrackerFontSizes"][1]);
		pbInfoQuestTracker_Dailies:SetFontSize(pbInfoSettings["QuestTrackerFontSizes"][1]);

		for i = 1, 30, 1 do
			_G["pbInfoQuestTrackerQuest" .. i .. "Title"]:SetText("");
			_G["pbInfoQuestTrackerQuest" .. i .. "Title"]:SetFontSize(pbInfoSettings["QuestTrackerFontSizes"][2]);
			_G["pbInfoQuestTrackerQuest" .. i .. "Items"]:SetText("");
			_G["pbInfoQuestTrackerQuest" .. i .. "Items"]:SetFontSize(pbInfoSettings["QuestTrackerFontSizes"][3]);
		end;

		if (pbInfoSettings["QUESTTRACKERSHOWTITLE"] == false) then
			pbInfoQuestTracker_Head:SetHeight(5);
			pbInfoQuestTracker_Head:Hide();
			pbInfoQuestTracker_Body:Show();
		else
			pbInfoQuestTracker_Title:SetText(pbInfo.Locale["Config"]["TabQuestTracker"]);
			pbInfoQuestTracker_Head:Show();
		end;

        if (pbInfoSettings["QUESTTRACKERSHOWDAILIESCOUNTER"]) then
            local dailyQuestsDone, dailyQuestsPerDay = Daily_count();
            pbInfoQuestTracker_Dailies:SetText((dailyQuestsPerDay - dailyQuestsDone) .. "/" .. dailyQuestsPerDay);
            pbInfoQuestTracker_Dailies:Show();
        else
            pbInfoQuestTracker_Dailies:Hide();
        end;
		
		pbInfo.QuestTracker.Loaded = true;
	end;
end;

function pbInfo.QuestTracker.SavePosition(this)
	pbInfoQuestTracker:StopMovingOrSizing();
	pbInfoSettings["QuestTrackerPosition"] = {pbInfoQuestTracker:GetPos()};
	pbInfoSettings["QuestTrackerSize"] = {pbInfoQuestTracker:GetSize()};
end;

function pbInfo.QuestTracker.GetCategoryName(questName)
	local categoryname = false;
	local questTree = TreeView_GetCollect(UI_QuestBook, 1, 30+10);
	
	if (type(questTree) == "table" and type(questTree.list) == "table") then
		for i, item in pairs(questTree.list) do
			if (item.type == 0) then
				categoryname = GetQuestCatalogInfo(item.id);
			else
				local _, _, name = GetQuestInfo(item.id);
				if (string.match(name, questName) ~= nil) then
					return categoryname;
				end;
			end;
		end;
	end;
	return false;
end;

pbInfo.Hooked.OnClick_QuestTrackButton = OnClick_QuestTrackButton;
function OnClick_QuestTrackButton(button)
	if (pbInfoSettings["QUESTTRACKER"]) then
		if (pbInfoQuestTracker:IsVisible()) then
			pbInfoQuestTracker:Hide();
		else
			pbInfoQuestTracker:Show();
		end;
	else
		pbInfo.Hooked.OnClick_QuestTrackButton(button);
	end;
end;