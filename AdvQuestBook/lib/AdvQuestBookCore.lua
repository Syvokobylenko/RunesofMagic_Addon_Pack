--[[ ä

	Name: Advanced Questbook
	By: Crypton

]]
AQB_VER_NUM = 1.59;
AQB_SDB_VER = "SDB: v.5.0.0.2538";
AQB_ADDON_NAME = "Advanced Quest Book";
AQB_TITLE_PAGE = AQB_ADDON_NAME.." v."..AQB_VER_NUM;
AQB_PATH = "Interface/AddOns/AdvQuestBook/";
AQB_LIB_PATH = AQB_PATH.."lib/";
AQB_LANG_PATH = AQB_PATH.."local/";
AQB_DB_PATH = AQB_LIB_PATH.."db/";
AQB_ICON_PATH = AQB_PATH.."images/";
AQB_ICON_1 = AQB_ICON_PATH.."fin.png";
AQB_ICON_2 = AQB_ICON_PATH.."inc.png";
AQB_ICON_3 = AQB_ICON_PATH.."index.png";
AQB_ICON_4 = AQB_ICON_PATH.."item.png";
--[[
	AQB_DEBUG_GAMESTRINGS

	This debug setting is for my own copy which I
	have 1 extra file with debug code to debug
	game strings. Please DO NOT enable or you
	will get errors without the debug file.
]]
AQB_DEBUG_GAMESTRINGS = false;
AQB_DEBUG_PL = "Mufasa";
AQB_TTW = 3;
AQB_ENABLE_ICONS = false;
AQB_SHOW = false;
AQB_LASTMAPID= 0;
AQB_LASTSCALE = 0;
AQB_FIN_COUNT = 0;
AQB_INC_COUNT = 0;
AQB_IDX_COUNT = 0;
AQB_ITEM_COUNT = 0;
AQB_SHA_COUNT = 0;
AQB_QST_ICOUNT = 0;
AQB_LAST_SHARE = 0;
AQB_MIN_ST = 3;
AQB_MAX_WIN = 16;
AQB_QST_MAX = 8000;
AQB_QST_RESULTS = {};
if (not AQB_DEBUG_LANG_STRINGS) then
	AQB_DEBUG_LANG_STRINGS = {};
end
AQB_SUPPORTED = {"ENUS", "ENEU", "DE", "FR", "ES", "JP", "KR", "TW", "CN", "PH", "BR", "SAPT"};
AQB_REPLIST = {"%<%S%>", "%<%/%S%>", "%<%C%R%>", "%<%/%C%R%>", "%<%C%S%>", "%<%/%C%S%>", "%<%C%M%>", "%<%/%C%M%>", "%<%C%N%>", "%<%/%C%N%>", "%<%C%Y%>", "%<%/%C%Y%>", "%<%C%B%>", "%<%/%C%B%>", "%<%C%P%>", "%<%/%C%P%>"};
AQB_NoteColorsImg = {
	[1] = AQB_ICON_PATH.."bdot.png", [2] = AQB_ICON_PATH.."cdot.png", [3] = AQB_ICON_PATH.."pdot.png",
	[4] = AQB_ICON_PATH.."rdot.png", [5] = AQB_ICON_PATH.."sdot.png", [6] = AQB_ICON_PATH.."ydot.png",
};

function AdvQuestBook_DebugArgs(event, aqbqs1, aqbqs2, aqbqs3, aqbqs4)
	-- Just a dummy function incase something slips up :P
	return;
end

function AQB_IsEmpty(str, zero)
	if (type(str) == "nil" or str == "" or (zero == true and str == 0)) then
		return true;
	end
	return false;
end

function AQB_FileLoader(AQB_FPATH, AQB_FNAME)
	local func, err = loadfile(AQB_FPATH..AQB_FNAME);
	if (err) then
		DEFAULT_CHAT_FRAME:AddMessage("Error loading file: "..AQB_FNAME.. " : "..err);
		return false;
	end
	dofile(AQB_FPATH..AQB_FNAME);
	return true;
end

AQB_FileLoader(AQB_LIB_PATH, "AdvQuestBookDefaultConfig.lua");

-- Set default temp until vars loaded...
AdvQuestBook_Config = AQB_Default_Config;

AQB_LOCAL = GetLanguage();

-- Lang UI Debug
--AQB_LOCAL = "SAPT";

if (AQB_LOCAL == "ENUS" or AQB_LOCAL == "ENEU") then
	AQB_LOCAL = "ENUS";
	AQB_LANG_FILE = "en";
elseif (AQB_LOCAL == "DE") then
	AQB_LANG_FILE = "de";
elseif (AQB_LOCAL == "FR") then
	AQB_LANG_FILE = "fr";
elseif (AQB_LOCAL == "ES") then
	AQB_LANG_FILE = "es";
elseif (AQB_LOCAL == "JP") then
	AQB_LANG_FILE = "jp";
elseif (AQB_LOCAL == "KR") then
	AQB_LANG_FILE = "kr";
elseif (AQB_LOCAL == "TW") then
	AQB_LANG_FILE = "tw";
elseif (AQB_LOCAL == "CN") then
	AQB_LANG_FILE = "cn";
elseif (AQB_LOCAL == "PH") then
	AQB_LANG_FILE = "ph";
elseif (AQB_LOCAL == "BR") then
	AQB_LANG_FILE = "br";
elseif (AQB_LOCAL == "SAPT") then
	AQB_LANG_FILE = "sapt";
else
	AQB_LANG_FILE = "en";
	DEFAULT_CHAT_FRAME:AddMessage("|cFFffffff"..AQB_ADDON_NAME..": does not currently support your language version of the game. Please contact Crypton on curse.com or curseforge.com if you would like to help add support for your language.|r");
end

AQB_FileLoader(AQB_LANG_PATH, AQB_LANG_FILE..".lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookMaps.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookClasses.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookItems.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookTransports.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookDailies.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookData.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookZones.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookMapID.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookCoords.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookAirships.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookEliteTrainers.lua");
AQB_FileLoader(AQB_DB_PATH, "AdvQuestBookSnoopLocs.lua");

AQB_PAT = {
	COMPLETE = TEXT("QUEST_MSG_REQUEST_COMPLETE"),
	GIVEUP = string.gsub(TEXT("QUEST_MSG_ALREADY_GIVEUP"), "%%s", "%(%.%+%)"),
	MET = string.gsub(TEXT("QUEST_MSG_CONDITION_FINISHED"), "%%s", "%(%.%+%)"),
	FINISHED = string.gsub(TEXT("QUEST_MSG_FINISHED"), "%%s", "%(%.%+%)"),
	GET = string.gsub(TEXT("QUEST_MSG_GET"), "%%s", "%(%.%+%)"),
	GETITEM = string.gsub(string.gsub(TEXT("QUEST_MSG_GET_ITEM"), "%%s", "%(%.%+%)"), "%%d", "%(%%d%+%)"),
	KILLMOB = string.gsub(string.gsub(TEXT("QUEST_MSG_KILL_MONSTER"), "%%s", "%(%.%+%)"), "%%d", "%(%%d%+%)"),
	ITEM = string.gsub(string.gsub(TEXT("QUEST_MSG_REQUEST_ITEM"), "%%s", "%(%.%+%)"), "%%d", "%(%%d%+%)"),
	KEYITEM = string.gsub(TEXT("QUEST_MSG_REQUEST_KEYITEM"), "%%s", "%(%.%+%)"),
	KILL = string.gsub(string.gsub(TEXT("QUEST_MSG_REQUEST_KILL"), "%%s", "%(%.%+%)"), "%%d", "%(%%d%+%)"),
};

function AQB_DecMagic(AQB_DECVAL, AQB_DEC)
	local aqbdec = tonumber(AQB_DEC);
	local aqbdecval = tonumber(AQB_DECVAL);
	local movedec = 10 ^ aqbdec;
	local result = aqbdecval * movedec;
	local shiftdec = 10 ^ 1;
	return math.floor(result * shiftdec) / shiftdec;
end

function AQB_Round(val, places)
	local dec = 10^(places or 0);
	return math.floor(val * dec + 0.5) / dec;
end

function AQB_Dec2Hex(val)
	local num = val;
	if (type(num) == "string") then
		num = string.tonumber(num);
	end
	return string.format("%x", num);
end

function AQB_DEBUG_MESSAGE(AQB_DBG_MSG)
	DEFAULT_CHAT_FRAME:AddMessage("AQB Debug: "..AQB_DBG_MSG);
	return;
end

function AdvQuestBookConfig_Defaults()
	local AQB_UPDATE = false;
	if (tonumber(AdvQuestBook_Config["version"]) < tonumber(1.49)) then
		AdvQuestBook_Config = AQB_Default_Config;
		DEFAULT_CHAT_FRAME:AddMessage(AQB_ADDON_NAME.." "..AdvQuestBook_Messages["AQB_DFAULTSETLOAD"].."...");
		DEFAULT_CHAT_FRAME:AddMessage("|cFF22ff17"..AQB_ADDON_NAME.."|r |cFFffffff"..AdvQuestBook_Messages["AQB_SETSUPDATE"].."...|r");
	end
	if (AQB_IsEmpty(AdvQuestBook_Config, true)) then
		AdvQuestBook_Config = AQB_Default_Config;
		DEFAULT_CHAT_FRAME:AddMessage(AQB_ADDON_NAME.." "..AdvQuestBook_Messages["AQB_DFAULTSETLOAD"].."...");
	else
		local i;
		if (AQB_IsEmpty(AdvQuestBook_Config["version"], true)) then
			AdvQuestBook_Config["version"] = AQB_Default_Config["version"];
			AQB_UPDATE = true;
		end
		if (AQB_IsEmpty(AdvQuestBook_Config["minibook"], true)) then
			AdvQuestBook_Config["minibook"] = AQB_Default_Config["minibook"];
			AQB_UPDATE = true;
		end
		if (AQB_IsEmpty(AdvQuestBook_Config["minibook"]["x"], true)) then
			AdvQuestBook_Config["minibook"]["x"] = AQB_Default_Config["minibook"]["x"];
		end
		if (AQB_IsEmpty(AdvQuestBook_Config["minibook"]["y"], true)) then
			AdvQuestBook_Config["minibook"]["y"] = AQB_Default_Config["minibook"]["y"];
		end
		if (AQB_IsEmpty(AdvQuestBook_Config["minibook"]["show"], true)) then
			AdvQuestBook_Config["minibook"]["show"] = AQB_Default_Config["minibook"]["show"];
			AQB_UPDATE = true;
		end
		if (AQB_IsEmpty(AdvQuestBook_Config["minibook"]["status"], true)) then
			AdvQuestBook_Config["minibook"]["status"] = AQB_Default_Config["minibook"]["status"];
			AQB_UPDATE = true;
		end
		if (AQB_IsEmpty(AdvQuestBook_Config["settings"], true)) then
			AdvQuestBook_Config["settings"] = AQB_Default_Config["setting"];
			AQB_UPDATE = true;
		end
		if (AQB_IsEmpty(AdvQuestBook_Config["iconsettings"], true)) then
			AdvQuestBook_Config["iconsettings"] = AQB_Default_Config["iconsettings"];
			AQB_UPDATE = true;
		end
		for i = 1, table.getn(AQB_Default_Config["settings"]) do
			if (AQB_IsEmpty(AdvQuestBook_Config["settings"][i], true)) then
				AdvQuestBook_Config["settings"][i] = AQB_Default_Config["settings"][i];
				AQB_UPDATE = true;
			else
				if (AQB_IsEmpty(AdvQuestBook_Config["settings"][i]["name"], true)) then
					AdvQuestBook_Config["settings"]["name"] = AQB_Default_Config["settings"]["value"];
					AQB_UPDATE = true;
				end
				if (AQB_IsEmpty(AdvQuestBook_Config["settings"][i]["value"], true)) then
					AdvQuestBook_Config["settings"]["value"] = AQB_Default_Config["settings"]["value"];
					AQB_UPDATE = true;
				end
			end
		end
		for i = 1, table.getn(AQB_Default_Config["iconsettings"]) do
			if (AQB_IsEmpty(AdvQuestBook_Config["iconsettings"][i], true)) then
				AdvQuestBook_Config["iconsettings"][i] = AQB_Default_Config["iconsettings"][i];
				AQB_UPDATE = true;
			else
				if (AQB_IsEmpty(AdvQuestBook_Config["iconsettings"][i]["name"], true)) then
					AdvQuestBook_Config["iconsettings"]["name"] = AQB_Default_Config["iconsettings"]["value"];
					AQB_UPDATE = true;
				end
				if (AQB_IsEmpty(AdvQuestBook_Config["iconsettings"][i]["value"], true)) then
					AdvQuestBook_Config["iconsettings"]["value"] = AQB_Default_Config["iconsettings"]["value"];
					AQB_UPDATE = true;
				end
			end
		end
	end
	if (tonumber(AdvQuestBook_Config["version"]) < tonumber(AQB_VER_NUM)) then
		AQB_UPDATE = true;
		AdvQuestBook_Config["version"] = AQB_VER_NUM;
	end
	if (AQB_LOCAL ~= "ENUS") then
		AdvQuestBook_Config["settings"][1]["value"] = false;
		AdvQuestBook_Config["settings"][2]["value"] = false;
		AdvQuestBook_Config["settings"][4]["value"] = false;
		AdvQuestBookConfigPurgeButton:Hide();
		AdvQuestBookConfigCheckbox1:Hide();
		AdvQuestBookConfigCheckbox2:Hide();
		AdvQuestBookConfigCheckbox4:Hide();
	else
		if (AQB_IsEmpty(AdvQuestBook_Dumped_Quests, true)) then
			AdvQuestBook_Dumped_Quests = {};
			AdvQuestBook_Dumped_Quests[AQB_LOCAL] = {};
		elseif (AQB_IsEmpty(AdvQuestBook_Dumped_Quests[AQB_LOCAL], true)) then
			AdvQuestBook_Dumped_Quests[AQB_LOCAL] = {};
		end
	end
	if (not AddonManager) then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(AdvQuestBook_Messages["AQB_AMNOTFOUND"], AQB_ADDON_NAME, "|cFFffffff/aqb|r", AQB_ADDON_NAME));
	end
	SaveVariables("AdvQuestBook_Config");
	if (AQB_UPDATE) then
		AQB_UPDATE = false;
		DEFAULT_CHAT_FRAME:AddMessage("|cFF22ff17"..AQB_ADDON_NAME.."|r |cFFffffff"..AdvQuestBook_Messages["AQB_SETSUPDATE"].."...|r");
	end
	return;
end

-- Not used, yet...
function AdvQuestBook_OrderByName(aqb1, aqb2)
	local i;
	local tmparr = {};
	for i in pairs(aqb1) do
		table.insert(tmparr, i)
	end
	table.sort(tmparr, aqb2);
	i = 0;
	local loopy = function()
		i = i + 1;
		if (tmparr[i] == nil) then
			return nil;
		else
			return tmparr[i], aqb1[tmparr[i]];
		end
	end
	return loopy;
end

function AdvQuestBook_SortByNum(t)
	local i;
	local j;
	local k = table.getn(t);
	local idxm;
	for i = 1, k, 1 do
		idxm = i;
		for j = i + 1, k, 1 do
			if (t[j] < t[idxm]) then
				idxm = j;
			end
		end
		t[i], t[idxm] = t[idxm], t[i];
	end
	return t;
end

function AdvQuestBook_ConvertCSV(s, t)
	local start = 1;
	local i = start;
	local nexti;
	repeat
		nexti = string.find(s, ',', start);
		table.insert(t, string.sub(s, start, nexti - 1));
		start = nexti + 1;
	until start > string.len(s);
	return t;
end

function AdvQuestBook_AutoMoveTo(this)
	local icon = getglobal(this);
	if (icon.mid ~= nil and icon.x ~= nil and icon.y ~= nil) then
		info = {};
		info.text = UI_AUTO_MOVE; 
		info.value = 0;
		info.func = WorldMap_AutoMove(icon.mid, icon.x, icon.y);
		info.owner = DropDownframe;
	end
end

function AdvQuestBook_eAutoMoveToByNPCID(this)
	local icon = getglobal(this);
	if (icon.enpcid ~= nil) then
		info = {};
		info.text = UI_AUTO_MOVE; 
		info.value = 0;
		info.func = WorldMap_AutoMoveByNpcID(icon.enpcid);
		info.owner = DropDownframe;
	end
end

-- No longer used, keeping just incase though.
function AdvQuestBook_GSubUTF8(str, start, numChars)
	local currentIndex = start;
	while (numChars > 0 and currentIndex <= #str) do
		local char = string.byte(str, currentIndex);
		if (char > 240) then
			currentIndex = currentIndex + 4;
		elseif (char > 225) then
			currentIndex = currentIndex + 3;
		elseif (char > 192) then
			currentIndex = currentIndex + 2;
		else 
			currentIndex = currentIndex + 1;
		end
		numChars = numChars - 1;
	end
	return str:sub(start, currentIndex - 1);
end

function AdvQuestBook_LevelTextColor(qlevel)
	local cl1, cl2 = UnitLevel("player");
	local diff = qlevel - cl1;
	local color;
	if (diff >= 5) then
		color = "FF1804";
	elseif (diff >= -3 and diff <= 4) then
		color = "F6FF04";
	else
		color = "00FB00";
	end
	return color;
end

function AdvQuestBook_ZoneParse(xtext)
	local ztext = xtext;
	local i, v;
	local zname;
	local r;
	for _, r in pairs(AQB_REPLIST) do
		ztext = string.gsub(ztext, r, "");
	end
	for r in string.gmatch(ztext, "%[(SC_.+)%]") do
		ztext = string.gsub(ztext, "%["..r.."%]", TEXT(r));
	end
	ztext = string.gsub(ztext, "%[%$PLAYERNAME%]", "|cffffffff"..UnitName("player").."|r");
	for i, v in pairs(AdvQuestBookZones) do
		if (string.find(ztext, i)) then
			zname = "|cff128f01"..v.."|r";
			ztext = string.gsub(ztext, "%["..i.."%]", zname);
		end
	end
	for i, v in (string.gmatch(ztext, "%[(ZONE_.-)|(.-)%]")) do
		ztext = string.gsub(ztext, "%["..i.."|"..v.."%]", "|cff128f01"..TEXT(i).."|r");
	end

	return ztext;
end

function AdvQuestBook_IDParse(idtext)
	local tmptext = idtext;
	local idmatch;
	local idname;
	local idmark;
	local idcolor;
	local i, v;
	local r;
	for i, v in (string.gmatch(tmptext, "%[(%d+)|(.-)%]")) do
		tmptext = string.gsub(tmptext, "%["..i.."|"..v.."%]", "["..i.."]");
	end
	for _, r in pairs(AQB_REPLIST) do
		tmptext = string.gsub(tmptext, r, "");
	end
	for idmatch in string.gmatch(tmptext, "%[(%d+)%]") do
		idmatch = tonumber(idmatch);
		if (idmatch >= 100004 and idmatch <= 121073) then
			idmark = "npc";
			idcolor = "0122ed";
		elseif (idmatch >= 200000 and idmatch <= 241629) then
			idmark = "item";
			idcolor = "ca5720";
		else
			idmark = "";
			idcolor = "ffffff";
		end
		if (string.len(idmatch) >= 6) then
			local tmpid = string.match(idmatch, "%d%d%d%d%d%d");
			idname = "|H"..idmark..":"..tmpid.."0|h|cff"..idcolor..TEXT("Sys"..tmpid.."_name").."|r|h";
		elseif (string.len(idmatch) == 5) then
			idname = "|H"..idmark..":"..idmatch.."0|h|cff"..idcolor..TEXT("Sys"..idmatch.."0_name").."|r|h";
		else
			idname = "|H"..idmark..":"..idmatch.."|h|cff"..idcolor..TEXT("Sys"..idmatch.."_name").."|r|h";
		end
		tmptext = string.gsub(tmptext, "%["..idmatch.."%]", idname);
	end
	return tmptext;
end

function AdvQuestBook_IDtoName(iid, docolor)
	local numid = tonumber(iid);
	local idname;
	local idmark;
	local idcolor;
	if (numid >= 100004 and numid <= 121073) then
		idmark = "npc";
		idcolor = "0122ed";
	elseif (numid >= 200000 and numid <= 241629) then
		idmark = "item";
		idcolor = "ca5720";
	else
		idmark = "";
		idcolor = "ffffff";
	end
	if (docolor) then
		idname = "|H"..idmark..":"..numid.."|h|cff"..idcolor..TEXT("Sys"..numid.."_name").."|r|h";
	else
		idname = TEXT("Sys"..idmatch.."_name");
	end
	return idname;
end

function AdvQuestBook_SavePatterns()
	local tmplang = GetLanguage();
	A_AQB_Strings = {};
	A_AQB_Strings[tmplang] = {};
	A_AQB_Strings[tmplang]["QUEST_MSG_FINISHED"] = TEXT("QUEST_MSG_FINISHED");
	A_AQB_Strings[tmplang]["QUEST_MSG_CONDITION_FINISHED"] = TEXT("QUEST_MSG_CONDITION_FINISHED");
	A_AQB_Strings[tmplang]["QUEST_MSG_ALREADY_GIVEUP"] = TEXT("QUEST_MSG_ALREADY_GIVEUP");
	A_AQB_Strings[tmplang]["QUEST_MSG_GET"] = TEXT("QUEST_MSG_GET");
	A_AQB_Strings[tmplang]["QUEST_MSG_GET_ITEM"] = TEXT("QUEST_MSG_GET_ITEM");
	A_AQB_Strings[tmplang]["QUEST_MSG_REQUEST_ITEM"] = TEXT("QUEST_MSG_REQUEST_ITEM");
	A_AQB_Strings[tmplang]["QUEST_MSG_REQUEST_KILL"] = TEXT("QUEST_MSG_REQUEST_KILL");
	A_AQB_Strings[tmplang]["QUEST_MSG_REQUEST_COMPLETE"] = TEXT("QUEST_MSG_REQUEST_COMPLETE");
	A_AQB_Strings[tmplang]["QUEST_MSG_REQUEST_KEYITEM"] = TEXT("QUEST_MSG_REQUEST_KEYITEM");
	A_AQB_Strings[tmplang]["SYS_PARTY_LEAVE"] = TEXT("SYS_PARTY_LEAVE");
	A_AQB_Strings[tmplang]["SYS_PARTY_JOIN"] = TEXT("SYS_PARTY_JOIN");
	A_AQB_Strings[tmplang]["SYS_PARTY_UNINVITE"] = TEXT("SYS_PARTY_UNINVITE");
	A_AQB_Strings[tmplang]["SYS_ADD_PARTY"] = TEXT("SYS_ADD_PARTY");
	A_AQB_Strings[tmplang]["QUEST_MSG_ALREADYDONE"] = TEXT("QUEST_MSG_ALREADYDONE");
	SaveVariables("A_AQB_Strings");
	A_AQB_Strings2 = {};
	A_AQB_Strings2[tmplang] = AdvQuestBookPatterns;
	SaveVariables("A_AQB_Strings2");
	return;
end

function AdvQuestBook_SetPatterns()
	local i;
	local j;
	local k;
	local m;
	local n;
	if (string.find(AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"], ".+:%s\"%%s\"")) then
		AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"], "\"%%s\"", "");
		AdvQuestBookPatterns["AQB_QUEST_ACCEPT"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_ACCEPT"], "\"%%s\"", "");
		AdvQuestBookPatterns["AQB_QUEST_MET"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_MET"], "\"%%s\"", "");
		AdvQuestBookPatterns["AQB_QUEST_ABANDON"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_ABANDON"], "\"%%s\"", "");
	elseif (string.find(AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"], ".+%s%%s%s.+")) then
		j = string.gsub("{"..AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"].."}", "%s%%s%s", "}{");
		k = string.gsub("{"..AdvQuestBookPatterns["AQB_QUEST_MET"].."}", "%s%%s%s", "}{");
		m = string.gsub("{"..AdvQuestBookPatterns["AQB_QUEST_ABANDON"].."}", "%s%%s%s", "}{");
		i = 1;
		for n in string.gmatch(j, "{(.-)}") do
			AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"..i] = n;
			i = i + 1;
		end
		for n in string.gmatch(k, "{(.-)}") do
			AdvQuestBookPatterns["AQB_QUEST_MET"..i] = n;
			i = i + 1;
		end
		for n in string.gmatch(m, "{(.-)}") do
			AdvQuestBookPatterns["AQB_QUEST_ABANDON"..i] = n;
			i = i + 1;
		end
	else
		AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"], "%%s", "");
		AdvQuestBookPatterns["AQB_QUEST_MET"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_MET"], "%%s", "");
		AdvQuestBookPatterns["AQB_QUEST_ABANDON"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_ABANDON"], "%%s", "");
	end
	if (string.find(AdvQuestBookPatterns["AQB_QUEST_ACCEPT"], ".+%s%%s")) then
		AdvQuestBookPatterns["AQB_QUEST_ACCEPT"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_ACCEPT"], "%%s", "");
	elseif (string.find(AdvQuestBookPatterns["AQB_QUEST_ACCEPT"], ".+%s%%s%s.+")) then
		j = string.gsub("{"..AdvQuestBookPatterns["AQB_QUEST_ACCEPT"].."}", "%s%%s%s", "}{");
		i = 1;
		for n in string.gmatch(j, "{(.-)}") do
			AdvQuestBookPatterns["AQB_QUEST_ACCEPT"..i] = n;
			i = i + 1;
		end
	end
	AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"], "%(", "%%(");
	AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"], "%)", "%%)");
	AdvQuestBookPatterns["PARTY_YOU_LEFT"] = string.gsub(AdvQuestBookPatterns["PARTY_YOU_LEFT"], "%.", "%%.");
	AdvQuestBookPatterns["PARTY_JOIN"] = string.gsub(AdvQuestBookPatterns["PARTY_JOIN"], "%.", "%%.");
	AdvQuestBookPatterns["AQB_QUEST_ABANDON"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_ABANDON"], "%.", "%%.");
	AdvQuestBookPatterns["PARTY_JOIN"] = string.gsub(AdvQuestBookPatterns["PARTY_JOIN"], "%.", "%%.");
	AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"] = string.gsub(AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"], "%.", "%%.");
	AdvQuestBookPatterns["PARTY_JOIN"] = string.gsub(AdvQuestBookPatterns["PARTY_JOIN"], "%[%%s%]", "");
	AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"] = string.gsub(AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"], "%[%%s%]", "");
	AdvQuestBookPatterns["AQB_QUEST_UPDATED"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_UPDATED"], "%%s", "", 1);
	AdvQuestBookPatterns["AQB_QUEST_UPDATED"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_UPDATED"], "%%s", "%(%.%+%)", 1);
	AdvQuestBookPatterns["AQB_QUEST_UPDATED"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_UPDATED"], "%%d", "%(%%d%+%)");
	AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"] = string.gsub(AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"], "%%s", "%(%.%+%)");
	AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"] = string.gsub(AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"], "%%d", "%(%%d%+%)");
	AdvQuestBookPatterns["AQB_MATCH_AMOUNT2"] = AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"];
	AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"] = AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"]..AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"];
	AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"] = string.gsub(AdvQuestBookPatterns["AQB_MATCH_AMOUNT1"], "%s", "%%s");
	AdvQuestBookPatterns["AQB_QUEST_ACCEPT"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_ACCEPT"], "%s", "%%s");
	AdvQuestBookPatterns["AQB_QUEST_MET"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_MET"], "%s", "%%s");
	AdvQuestBookPatterns["AQB_QUEST_ABANDON"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_ABANDON"], "%s", "%%s");
	AdvQuestBookPatterns["AQB_QUEST_UPDATED"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_UPDATED"], "%s", "%%s");
	AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_COMPLETE1"], "%s", "%%s");
	AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"] = string.gsub(AdvQuestBookPatterns["AQB_QUEST_COMPLETE2"], "%s", "%%s");
	AdvQuestBookPatterns["PARTY_JOIN"] = string.gsub(AdvQuestBookPatterns["PARTY_JOIN"], "%s", "%%s");
	AdvQuestBookPatterns["PARTY_YOU_LEFT"] = string.gsub(AdvQuestBookPatterns["PARTY_YOU_LEFT"], "%s", "%%s");
	AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"] = string.gsub(AdvQuestBookPatterns["PARTY_MEMBER_LEAVES"], "%s", "%%s");
	return;
end

function AdvQuestBook_CleanupOldData()
	local j, k;
	local l, m;
	for j, k in pairs(AdvQuestBook_Dumped_Quests) do
		for l, m in pairs(k) do
			if (not AQB_IsEmpty(AdvQuestBook_Dumped_Quests[j][l]["info"]["descshort"], true)) then
				AdvQuestBook_Dumped_Quests[j][l]["info"]["descshort"] = nil;
				SaveVariables("AdvQuestBook_Dumped_Quests");
			end
			if (not AQB_IsEmpty(AdvQuestBook_Dumped_Quests[j][l]["info"]["desclong"], true)) then
				AdvQuestBook_Dumped_Quests[j][l]["info"]["desclong"] = nil;
				SaveVariables("AdvQuestBook_Dumped_Quests");
			end
		end
	end
	SaveVariables("AdvQuestBook_Dumped_Quests");
	return;
end

function AdvQuestBookCore_OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
end

function AdvQuestBookCore_EventHandler(this, event)
	if (event == "VARIABLES_LOADED") then
		AQB_SERVER = GetCurrentRealm();
		AQB_CurPlayer = UnitName("player");
		if (not AQB_IsEmpty(AdvQuestBook_Config, true)) then
			SaveVariables("AdvQuestBook_Config");
		end
		if (not AQB_IsEmpty(AQB_CustomNotes, true)) then
			SaveVariablesPerCharacter("AQB_CustomNotes");
		elseif (AQB_CustomNotes == nil) then
			AQB_CustomNotes = {};
			SaveVariablesPerCharacter("AQB_CustomNotes");
		end
		if (not AQB_IsEmpty(AdvQuestBook_Dumped_Quests, true)) then
			if (AQB_LANG_FILE == "en") then
				SaveVariables("AdvQuestBook_Dumped_Quests");
			end
		end
		if (AQB_LOCAL == "ENUS") then
			if (AdvQuestBook_Config ~= nil) then
				if (AdvQuestBook_Config["version"] ~= nil) then
					if (tonumber(AdvQuestBook_Config["version"]) < tonumber(1.32)) then
						if (not AQB_IsEmpty(AdvQuestBook_Dumped_Quests, true)) then
							AdvQuestBook_CleanupOldData();
						end
					end
				end
			end
		end
		AdvQuestBookConfig_Defaults();
		AQB_COUNT_DUMPED = 0;
		AQB_TEMP_QUESTS = {};
		AdvQuestBook_SetPatterns();
		local la;
		local langsupp = false;
		for _, la in pairs(AQB_SUPPORTED) do
			if (la == AQB_LOCAL) then
				langsupp = true;
				break;
			end
		end
		if (not langsupp) then
			AdvQuestBook_SavePatterns();
			DEFAULT_CHAT_FRAME:AddMessage("|cFFffffff"..AQB_ADDON_NAME..":|r Please send your |cffffffffSaveVariables.lua|r to |cffffffffCrypton|r on |cffffffffhttp://www.curse.com/users/Crypton|r when you exit the game. Your language is not supported yet and |cFFffffff"..AQB_ADDON_NAME..":|r has saved information regarding your language strings that are needed to add support.|r");
		end
	end
end
