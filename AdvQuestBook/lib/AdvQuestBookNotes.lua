--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
local AQB_NewNoteIcon = {};
local AQB_NoteIDX = 0;

function AdvQuestBook_ReloadNoteIcons()
	local i, v;
	local j;
	local icon;
	local AQB_MPX;
	local AQB_MPY;
	local AQB_MWIDTH;
	local AQB_MHEIGHT;
	local AQB_MAPID;
	for j = 1, 60 do
		icon = getglobal("AdvQuestBookMapNoteIcon"..j);
		icon:Hide();
	end
	if (not WorldMapViewFrame:IsVisible()) then
		return;
	end
	if (AdvQuestBook_Config["iconsettings"][10]["value"]) then
		local AQB_MWIDTH = WorldMapViewFrame:GetWidth();
		local AQB_MHEIGHT = WorldMapViewFrame:GetHeight();
		local AQB_MAPID = WorldMapFrame.mapID;
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
end

function AdvQuestBook_NewNoteOnMouseUp(CX, CY)
	if (AdvQuestBookNewNoteFrame:IsVisible()) then
		return;
	else
		local x, y = CX, CY;
		local AQB_MAPID = WorldMapFrame.mapID;
		local _x, _y = WorldMapViewFrame:GetPos(); 
		local _w, _h = WorldMapViewFrame:GetRealSize();
		_y = WorldMapViewFrame:GetTop();
		_x = WorldMapViewFrame:GetLeft();
		local AQB_CX = (x - _x) / _w;
		local AQB_CY = (y - _y) / _h;
		AQB_NewNoteIcon = {};
		if (not AQB_CustomNotes) then
			AQB_CustomNotes = {};
		end
		if (not AQB_CustomNotes[AQB_MAPID]) then
			AQB_CustomNotes[AQB_MAPID] = {};
		end
		if (table.getn(AQB_CustomNotes[AQB_MAPID]) >= 60) then
			DEFAULT_CHAT_FRAME:AddMessage(string.format(AQB_XML_NOTE7, "|cffffffff60|r"));
			return;
		else
			AQB_NewNoteIcon = {
				["mapid"] = AQB_MAPID,
				["x"] = AQB_CX,
				["y"] = AQB_CY,
				["color"] = 1,
				["title"] = AQB_XML_NOTE10,
				["note"] = AQB_XML_NOTE11
			};
			AdvQuestBookNewNoteFrameTEB:SetText(AQB_NewNoteIcon["title"]);
			AdvQuestBookNewNoteFrameNEB:SetText(AQB_NewNoteIcon["note"]);
			local btn = getglobal("AdvQuestBookNewNoteFrameColBtn1");
			btn:LockHighlight();
			AdvQuestBookNewNoteFrameTitle:SetText(AQB_XML_NOTE5);
			AdvQuestBookNewNoteFrameSaveBtn1:Show();
			AdvQuestBookNewNoteFrame:Show();
		end
	end
end

function AdvQuestBook_SetSelNoteColor(this)
	local i;
	local num = string.gsub(this:GetName(), "AdvQuestBookNewNoteFrameColBtn", "");
	num = tonumber(num);
	for i = 1, 6 do
		local btn = getglobal("AdvQuestBookNewNoteFrameColBtn"..i);
		if (i == num) then
			btn:LockHighlight();
		else
			btn:UnlockHighlight();
		end
	end
	AQB_NewNoteIcon["color"] = num;
end

function AdvQuestBook_SaveNewNote()
	AQB_NewNoteIcon["title"] = AdvQuestBookNewNoteFrameTEB:GetText();
	AQB_NewNoteIcon["note"] = AdvQuestBookNewNoteFrameNEB:GetText();
	table.insert(AQB_CustomNotes[AQB_NewNoteIcon["mapid"]], AQB_NewNoteIcon);
	SaveVariablesPerCharacter("AQB_CustomNotes");
	AQB_NewNoteIcon = {};
	AdvQuestBookNewNoteFrame:Hide();
	AdvQuestBook_ReloadNoteIcons();
end

function AdvQuestBook_SaveCustomNote()
	AQB_NewNoteIcon["title"] = AdvQuestBookNewNoteFrameTEB:GetText();
	AQB_NewNoteIcon["note"] = AdvQuestBookNewNoteFrameNEB:GetText();
	AQB_CustomNotes[AQB_NewNoteIcon["mapid"]][AQB_NoteIDX] = AQB_NewNoteIcon;
	SaveVariablesPerCharacter("AQB_CustomNotes");
	AQB_NewNoteIcon = {};
	AQB_NoteIDX = 0;
	AdvQuestBookNewNoteFrame:Hide();
	AdvQuestBook_ReloadNoteIcons();
end

function AdvQuestBook_DeleteCustomNote(this)
	local btn = getglobal(this:GetName());
	local tempTble = {};
	for i = 1, table.getn(AQB_CustomNotes[btn.mid]) do
		if (i ~= btn.idx) then
			table.insert(tempTble, AQB_CustomNotes[btn.mid][i]);
		end
	end
	AQB_CustomNotes[btn.mid] = tempTble;
	SaveVariablesPerCharacter("AQB_CustomNotes");
	AdvQuestBook_ReloadNoteIcons();
end

function AdvQuestBook_EditCustomNote(icon)
	local i;
	local num = string.gsub(icon:GetName(), "AdvQuestBookMapNoteIcon", "");
	num = tonumber(num);
	AQB_NoteIDX = num;
	local btn = getglobal("AdvQuestBookNewNoteFrameColBtn"..icon.color);
	AdvQuestBook_SetSelNoteColor(btn);
	AQB_NewNoteIcon = {
		["mapid"] = icon.mid,
		["x"] = icon.x,
		["y"] = icon.y,
		["color"] = icon.color,
		["title"] = icon.name,
		["note"] = icon.note
	};
	AdvQuestBookNewNoteFrameTEB:SetText(icon.name);
	AdvQuestBookNewNoteFrameNEB:SetText(icon.note);
	AdvQuestBookNewNoteFrameTitle:SetText(AQB_XML_NOTE6);
	AdvQuestBookNewNoteFrameSaveBtn2:Show();
	AdvQuestBookNewNoteFrame:Show();
end

function AdvQuestBook_SaveCustomNoteLocation(this, CX, CY)
	local btn = getglobal(this:GetName());
	local x, y = CX, CY;
	local _x, _y = WorldMapViewFrame:GetPos(); 
	local _w, _h = WorldMapViewFrame:GetRealSize();
	_y = WorldMapViewFrame:GetTop();
	_x = WorldMapViewFrame:GetLeft();
	local AQB_CX = (x - _x) / _w;
	local AQB_CY = (y - _y) / _h;
	btn.x = AQB_CX;
	btn.y = AQB_CY;
	AQB_CustomNotes[btn.mid][btn.idx]["x"] = AQB_CX;
	AQB_CustomNotes[btn.mid][btn.idx]["y"] = AQB_CY;
	SaveVariablesPerCharacter("AQB_CustomNotes");
end
