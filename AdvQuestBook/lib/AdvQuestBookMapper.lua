--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
function AdvQuestBook_ClearIcons(toclear)
	local i;
	local icon;
	if (toclear == "items") then
		for i = 1, AQB_ITEM_COUNT do
			icon = getglobal("AdvQuestBookMapItemIcons"..i);
			icon:Hide();
		end
		AQB_ITEM_COUNT = 0;
	else
		for i = 1, AQB_FIN_COUNT do
			icon = getglobal("AdvQuestBookMapFinIcons"..i);
			icon:Hide();
		end
		for i = 1, AQB_IDX_COUNT do
			icon = getglobal("AdvQuestBookMapIndexIcons"..i);
			icon:Hide();
		end

		for i = 1, AQB_SHA_COUNT do
			icon = getglobal("AdvQuestBookMapSharedIcons"..i);
			icon:Hide();
		end
		AQB_FIN_COUNT = 0;
		AQB_IDX_COUNT = 0;
		AQB_SHA_COUNT = 0;
		AQB_ENABLE_ICONS = false;
		icon = getglobal("AdvQuestBookSnoopIconsa");
		icon:Hide();
		icon = getglobal("AdvQuestBookSnoopIconsb");
		icon:Hide();
		icon = getglobal("AdvQuestBookAirshipIcons1");
		icon:Hide();
		for i = 1, 2 do
			icon = getglobal("AdvQuestBookEliteTrainerIcons"..i)
			icon:Hide();
		end
		for i = 1, 60 do
			icon = getglobal("AdvQuestBookMapNoteIcon"..i);
			icon:Hide();
		end
		-- Dailies
		for i = 1, 30 do
			icon = getglobal("AdvQuestBookMapDailiesIcons"..i);
			icon:Hide();
		end

	end
	return;
end

function AdvQuestBook_DynIcons(questnum)
	local AQB_MWIDTH = WorldMapViewFrame:GetWidth();
	local AQB_MHEIGHT = WorldMapViewFrame:GetHeight();
	local AQB_I, AQB_V;
	local AQB_CLOCS;
	local i;
	local z = 0;
	local flag;
	local icon;
	if (not AQB_IsEmpty(AdvQuestBookCoords[questnum], true)) then
		if (not AQB_IsEmpty(AdvQuestBookCoords[questnum]["items"], true)) then
			for AQB_I, AQB_V in pairs(AdvQuestBookCoords[questnum]["items"]) do
				AQB_CLOCS = table.getn(AQB_V["locations"]);
				if (AQB_CLOCS > 0) then
					for i = 1, AQB_CLOCS do
						if (AQB_CLOCS > 1 and i == 1) then
							flag = true;
						else
							flag = false;
						end
						if (not flag) then
							local AQB_MID = AQB_V["locations"][i]["mapid"];
							local AQB_MPX = AQB_V["locations"][i]["x"];
							local AQB_MPY = AQB_V["locations"][i]["y"];
							if (AQB_MID == AQB_LASTMAPID) then
								z = z + 1;
								icon = getglobal("AdvQuestBookMapItemIcons"..z);
								icon:ClearAllAnchors();
								icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
								icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
								icon.qid = questnum;
								icon.mid = AQB_MID;
								icon.iid = AQB_I;
								icon.x = AQB_MPX;
								icon.y = AQB_MPY;
								icon:Show();
								AQB_ITEM_COUNT = AQB_ITEM_COUNT + 1;
							end
						end
					end
				end
			end
		end
	end
	return;
end

function AdvQuestBook_MapLocations(QID, SHARED)
	local i;
	local j;
	local ico;
	local icon;
	if (SHARED) then
		ico = "AdvQuestBookMapSharedIcons";
	else
		ico = "AdvQuestBookMapIndexIcons";
	end
	local AQB_I, AQB_V;
	local AQB_MSCALE = WorldMapViewFrame:GetScale();
	local AQB_MWIDTH = WorldMapViewFrame:GetWidth();
	local AQB_MHEIGHT = WorldMapViewFrame:GetHeight();
	local AQB_MAPID = WorldMapFrame.mapID;
	local AQB_LOCS = table.getn(AdvQuestBookCoords[QID]["locations"]);
	if (AQB_LOCS > 0) then
		for i = 1, AQB_LOCS do
			local AQB_MID = AdvQuestBookCoords[QID]["locations"][i]["mapid"];
			local AQB_MPX = AdvQuestBookCoords[QID]["locations"][i]["x"];
			local AQB_MPY = AdvQuestBookCoords[QID]["locations"][i]["y"];
			local AQB_NPCID = AdvQuestBookCoords[QID]["end"]["id"];
			if (not AQB_IsEmpty(AQB_MID, true) and not AQB_IsEmpty(AQB_MPX, true) and not AQB_IsEmpty(AQB_MPY, true)) then
				if (AQB_MID == AQB_MAPID) then
					if (SHARED) then
						AQB_SHA_COUNT = AQB_SHA_COUNT + 1;
						j = AQB_SHA_COUNT;
					else
						AQB_IDX_COUNT = AQB_IDX_COUNT + 1;
						j = AQB_IDX_COUNT;
					end
					icon = getglobal(ico..j);
					icon:ClearAllAnchors();
					icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
					icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
					icon.qid = QID;
					icon.mid = AQB_MID;
					if (SHARED) then
						icon.pid = AQB_LAST_SHARE;
					end
					icon.x = AQB_MPX;
					icon.y = AQB_MPY;
					icon.enpcid = AQB_NPCID;
					icon:Show();
				end
			end
		end
	else
		for AQB_I, AQB_V in pairs(AdvQuestBookCoords[QID]["items"]) do
			local AQB_MID = AQB_V["locations"][1]["mapid"];
			local AQB_MPX = AQB_V["locations"][1]["x"];
			local AQB_MPY = AQB_V["locations"][1]["y"];
			local AQB_NPCID = AdvQuestBookCoords[QID]["end"]["id"];
			if (not AQB_IsEmpty(AQB_MID, true) and not AQB_IsEmpty(AQB_MPX, true) and not AQB_IsEmpty(AQB_MPY, true)) then
				if (AQB_MID == AQB_MAPID) then
					if (SHARED) then
						AQB_SHA_COUNT = AQB_SHA_COUNT + 1;
						j = AQB_SHA_COUNT;
					else
						AQB_IDX_COUNT = AQB_IDX_COUNT + 1;
						j = AQB_IDX_COUNT;
					end
					icon = getglobal(ico..j);
					icon:ClearAllAnchors();
					icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
					icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
					if (SHARED) then
						icon:GetNormalTexture():SetFile(AQB_ICON_PATH.."shared.png");
						icon:GetPushedTexture():SetFile(AQB_ICON_PATH.."shared.png");
						icon:SetSize(24, 24);
					elseif (AdvQuestBookCoords[QID]["info"]["daily"]) then
						icon:GetNormalTexture():SetFile(AQB_ICON_PATH.."bddot.png");
						icon:GetPushedTexture():SetFile(AQB_ICON_PATH.."bddot.png");
						icon:SetSize(12, 12);
					else
						icon:GetNormalTexture():SetFile(AQB_ICON_PATH.."index.png");
						icon:GetPushedTexture():SetFile(AQB_ICON_PATH.."index.png");
						icon:SetSize(12, 12);
					end
					icon.qid = QID;
					icon.mid = AQB_MID;
					if (SHARED) then
						icon.pid = AQB_LAST_SHARE;
					end
					icon.x = AQB_MPX;
					icon.y = AQB_MPY;
					icon:Show();
				end
			end
		end
	end
	return;
end

function AdvQuestBook_MapPoints()
	local AQB_MSCALE = WorldMapViewFrame:GetScale();
	local AQB_MWIDTH = WorldMapViewFrame:GetWidth();
	local AQB_MHEIGHT = WorldMapViewFrame:GetHeight();
	local AQB_MAPID = WorldMapFrame.mapID;
	local i;
	local j;
	local v;
	local AQB_I, AQB_V;
	local icount;
	local icon;
	local AQB_MPX;
	local AQB_MPY;
	if (not AdvQuestBook_Config) then
		return;
	end
	AQB_LASTMAPID = AQB_MAPID;
	AQB_LASTSCALE = AQB_MSCALE;
	AdvQuestBook_ClearIcons("nil");
	AQB_ENABLE_ICONS = true;
	for i = 1, AQB_ITEM_COUNT do
		icon = getglobal("AdvQuestBookMapItemIcons"..i);
		if (icon.mid ~= AQB_MAPID) then
			icon:Hide();
		else
			icon:ClearAllAnchors();
			icon:SetPos(icon.x * AQB_MWIDTH, icon.y * AQB_MHEIGHT);
			icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", icon.x * AQB_MWIDTH, icon.y * AQB_MHEIGHT);
		end
	end
	if (AdvQuestBook_Config["iconsettings"][8]["value"]) then
		local AQB_TOTALQUESTS = GetNumQuestBookButton_QuestBook();
		for i = 1, AQB_TOTALQUESTS do
			local AQB_MAPPER_QC = false;
			local AQB_INDEX, AQB_CATID, AQB_NAME, AQB_TRACK, AQB_LEVEL, AQB_DAILY, _, _, AQB_QUESTID, AQB_COMPLETE = GetQuestInfo(i);
			if (AQB_COMPLETE) then
				AQB_MAPPER_QC = true;
			end
			local AQB_QUESTNAME = string.gsub(AQB_NAME, AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"], "");
			if (AdvQuestBookByName[AQB_QUESTNAME] ~= nil) then
				local AQB_QID = tonumber(AdvQuestBookByName[AQB_QUESTNAME]);
				if (AdvQuestBookCoords[AQB_QID]) then
					if (AQB_MAPPER_QC) then
						local AQB_MID = AdvQuestBookCoords[AQB_QID]["end"]["mid"];
						local AQB_NPCID = AdvQuestBookCoords[AQB_QID]["end"]["id"];
						AQB_MPX = AdvQuestBookCoords[AQB_QID]["end"]["x"];
						AQB_MPY = AdvQuestBookCoords[AQB_QID]["end"]["y"];
						if (not AQB_IsEmpty(AQB_MID, true) and not AQB_IsEmpty(AQB_NPCID, true) and not AQB_IsEmpty(AQB_MPX, true) and not AQB_IsEmpty(AQB_MPY, true)) then
							if (AQB_MID == AQB_MAPID) then
								AQB_FIN_COUNT = AQB_FIN_COUNT + 1;
								icon = getglobal("AdvQuestBookMapFinIcons"..AQB_FIN_COUNT);
								icon:ClearAllAnchors();
								icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
								icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
								icon.qid = AQB_QID;
								icon.mid = AQB_MID;
								icon.x = AQB_MPX;
								icon.y = AQB_MPY;
								icon.enpcid = AQB_NPCID;
								icon:Show();
							end
						end
					else
						AdvQuestBook_MapLocations(AQB_QID, false);
					end
				end
			end
		end
	end
	-- Shared Quests
	if (AdvQuestBook_Config["iconsettings"][9]["value"]) then
		if (AQB_LAST_SHARE > 0) then
			icount = table.getn(AQB_SharedQuests[AQB_LAST_SHARE]["quests"]);
			for i = 1, icount do
				AQB_QID = AQB_SharedQuests[AQB_LAST_SHARE]["quests"][i];
				AQB_QID = tonumber(AQB_QID);
				if (AdvQuestBookCoords[AQB_QID]) then
					AdvQuestBook_MapLocations(AQB_QID, true);
				end
			end
		end
	end
	-- Snoop Transports
	if (AdvQuestBook_Config["iconsettings"][12]["value"]) then
		icount = table.getn(AdvQuestBook_Snoop);
		local prim, sec = UnitLevel("player");
		local icotype;
		for i = 1, icount do
			if (AdvQuestBook_Snoop[i]["mapid"] == AQB_MAPID) then
				if (prim < AdvQuestBook_Snoop[i]["level"]) then
					icotype = "b";
				else
					icotype = "a";
				end
				AQB_MPX = AdvQuestBook_Snoop[i]["x"];
				AQB_MPY = AdvQuestBook_Snoop[i]["y"];
				icon = getglobal("AdvQuestBookSnoopIcons"..icotype);
				icon:ClearAllAnchors();
				icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon.mid = AQB_MAPID;
				icon.name = AdvQuestBook_Snoop[i]["name"];
				icon.level = AdvQuestBook_Snoop[i]["level"];
				icon.links = AdvQuestBook_Snoop[i]["links"];
				icon.x = AQB_MPX;
				icon.y = AQB_MPY;
				icon:Show();
			end
		end
	end
	-- Airships
	if (AdvQuestBook_Config["iconsettings"][11]["value"]) then
		icount = table.getn(AdvQuestBook_Airships);
		for i = 1, icount do
			if (AdvQuestBook_Airships[i]["mapid"] == AQB_MAPID) then
				AQB_MPX = AdvQuestBook_Airships[i]["x"];
				AQB_MPY = AdvQuestBook_Airships[i]["y"];
				icon = getglobal("AdvQuestBookAirshipIcons1");
				icon:ClearAllAnchors();
				icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon.mid = AQB_MAPID;
				icon.name = AdvQuestBook_Airships[i]["name"];
				icon.links = AdvQuestBook_Airships[i]["links"];
				icon.x = AQB_MPX;
				icon.y = AQB_MPY;
				icon:Show();
			end
		end
	end
	-- Elite Trainers
	if (AdvQuestBook_Config["iconsettings"][14]["value"]) then
		if (not AQB_IsEmpty(AdvQuestBook_EliteTrainers[AQB_MAPID], true)) then
			icount = table.getn(AdvQuestBook_EliteTrainers[AQB_MAPID]);
			for i = 1, icount do
				AQB_MPX = AdvQuestBook_EliteTrainers[AQB_MAPID][i]["x"];
				AQB_MPY = AdvQuestBook_EliteTrainers[AQB_MAPID][i]["y"];
				icon = getglobal("AdvQuestBookEliteTrainerIcons"..i);
				icon:ClearAllAnchors();
				icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon.mid = AQB_MAPID;
				icon.x = AQB_MPX;
				icon.y = AQB_MPY;
				icon.name = AdvQuestBook_EliteTrainers[AQB_MAPID][i]["name"];
				icon.items = AdvQuestBook_EliteTrainers[AQB_MAPID][i]["items"];
				icon:Show();
			end
		end
	end
	-- Custom Notes
	if (AdvQuestBook_Config["iconsettings"][10]["value"]) then
		if (AQB_CustomNotes ~= nil) then
			if (AQB_CustomNotes[AQB_MAPID] ~= nil) then
				for i, v in pairs(AQB_CustomNotes[AQB_MAPID]) do
					AQB_MPX = v["x"];
					AQB_MPY = v["y"];
					icon = getglobal("AdvQuestBookMapNoteIcon"..i);
					icon:ClearAllAnchors();
					icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
					icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
					icon.idx = i;
					icon.mid = AQB_MAPID;
					icon.x = AQB_MPX;
					icon.y = AQB_MPY;
					icon.name = v["title"];
					icon.note = v["note"];
					icon.color = v["color"];
					icon:GetNormalTexture():SetFile(AQB_NoteColorsImg[v["color"]]);
					icon:GetPushedTexture():SetFile(AQB_NoteColorsImg[v["color"]]);
					icon:Show();
				end
			end
		end
	end
	-- Dailies
	if (AdvQuestBook_Config["iconsettings"][13]["value"]) then
		if (AQB_Dailies[AQB_MAPID] ~= nil) then
			for i = 1, table.getn(AQB_Dailies[AQB_MAPID]) do
				AQB_MPX = AQB_Dailies[AQB_MAPID][i]["x"];
				AQB_MPY = AQB_Dailies[AQB_MAPID][i]["y"];
				icon = getglobal("AdvQuestBookMapDailiesIcons"..i);
				icon:ClearAllAnchors();
				icon:SetPos(AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", AQB_MPX * AQB_MWIDTH, AQB_MPY * AQB_MHEIGHT);
				icon.idx = i;
				icon.mid = AQB_MAPID;
				icon.x = AQB_MPX;
				icon.y = AQB_MPY;
				icon.name = AQB_Dailies[AQB_MAPID][i]["name"];
				icon:Show();
			end
		end
	end
	return;
end

function AdvQuestBook_OnUpdate(this)
	if (WorldMapFrame:IsVisible()) then
		if (AQB_ENABLE_ICONS) then
			local AQB_MAPID = WorldMapFrame.mapID;
			local AQB_MSCALE = WorldMapViewFrame:GetScale();
			if (AQB_LASTMAPID ~= AQB_MAPID or AQB_LASTSCALE ~= AQB_MSCALE) then
				AdvQuestBook_MapPoints();
			end
		elseif (not AQB_ENABLE_ICONS) then
			AQB_ENABLE_ICONS = true;
			AdvQuestBook_MapPoints();
		end
	elseif (not WorldMapFrame:IsVisible()) then
		if (AQB_ENABLE_ICONS) then
			AQB_ENABLE_ICONS = false;
			AdvQuestBook_ClearIcons("items");
			AdvQuestBook_ClearIcons("nil");
		end
	end
end
