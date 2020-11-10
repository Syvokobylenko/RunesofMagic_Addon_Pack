local me = {
	name = "yaCIt",
	Version = "3.2 (12/2019)",
	author = "Corgrind",

	Red = "|cffe00000%s|r", -- text red
	Green = "|cff00c000%s|r", -- text green
	Yellow = "|cfff0d000%s|r", -- text yellow 
	Orange = "|cfff66000%s|r", -- text orange
	NumCategories = 15,

	NumCharacters = 1;
	NumCards = 0,
	NumOwned = 0,
	CardList = {},
	Owned = {};
	ZoneLookup = {},
	ZoneSelectDDneedUpdate = false,
	NameLookup = {},

	RarityColors = {},
	StatBonuses = {}
}

--[[ =================================================================
  Several helper function, most copied from other tools
================================================================= --]]
function me.Print(text)
	DEFAULT_CHAT_FRAME:AddMessage(me.Logo .. ": " .. text, 0.9, 0.9, 0.9);
end

function me.PrintF(stringFormat, ...)
	local msg = stringFormat:format(...);
	me.Print(msg);
end

function me.CreateLink(linktype, data, text)
	return string.format("|H%s:%s|h%s|h", linktype, data, text);
end

function iif(condition, truevalue, falsevalue)
    if condition then
        return truevalue;
    else
        return falsevalue;
    end
end

function me.dec2hex(dec)
	return string.format("%x", dec);
end

function me.TableSize(val)
	local iCount = 0;
	if type(val) == "table" then
		for _, _ in pairs(val) do
			iCount = iCount + 1;
		end
	end
	return iCount;
end

--[[ =================================================================
  The following two functions are used to convert the internal color
  coding (r,g,b in values between 0 and 1) into the hex strings
  needed for output in the message (chat) area
================================================================= --]]
function me.SolPercentToHex (percent)
	if not percent or type(percent) ~= "number" then
		return nil;
	end
	percent = (percent * 255) + 0.5;
	if percent >= 255 then
		return "FF";
	end
	local c1 = math.floor(percent / 16);
	local c2 = math.floor(percent % 16);
	return me.dec2hex(c1) .. me.dec2hex(c2);
end

function me.SolColorValuesToHexColor (r, g, b)
	if not r or not g or not b or type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
		return nil;
	end
	r = me.SolPercentToHex(r);
	g = me.SolPercentToHex(g);
	b = me.SolPercentToHex(b);
	return r .. g .. b;
end

--[[ =================================================================
  Send card numbers to chat frame
================================================================= --]]
function me.ShowNumbers()
	local strPerc = me.Yellow:format(math.floor(me.NumOwned / me.NumCards * 10000) / 100 .. "%");
	local strCSum = me.Red:format(me.NumCards);
	local strCOwned = me.Green:format(me.NumOwned);
	me.PrintF(me.Locales.cardnumbers, strCSum, strCOwned, strPerc);
end

--[[ =================================================================
  Calls the original tooltip of a card and retrieves the card name
  Must be done this way because the compendium list only shoes 
  questionmarks if a card is not owned
================================================================= --]]
function me.GetCardName(strIDhex)
	local ttip = getglobal(me.name .. "Tooltip");
	local ttiptext = getglobal(me.name .. "TooltipTextLeft1");
	ttip:SetText("")
	ttip:SetHyperLink(me.CreateLink("item", strIDhex, ""));
	ttip:Hide();
	local name = ttiptext:GetText()
	name = name:sub(TEXT("SYS_CARD_TITLE"):len() + 1);
	return name;
end

--[[ =================================================================
  Creates the basic card list and the name lookup table.
  Anything created here is permanent over runtime except the field
  'Owned' which may be changed when a card is added to or removed 
  from the compendium
================================================================= --]]
function me.CreateCardList()
	for i = 0, 7 do
		me.RarityColors[i] = "|cff" .. me.SolColorValuesToHexColor(GetItemQualityColor(i)) .. "%s|r";
	end

	me.NumCards = 0;
	me.NumOwned = 0;

	for i = 0 , me.NumCategories do
		local intCardsInCat = LuaFunc_GetCardMaxCount(i);
		if intCardsInCat and intCardsInCat > 0 then
			for j = 1 , intCardsInCat do
				local cID, cOwned, cName, cDescr, cRace, cRare, cResist, cStat = LuaFunc_GetCardInfo(i , j - 1);
				local strIDhex = me.dec2hex(cID);
				local strCardName = me.GetCardName(strIDhex);

				-- check if an unknown card has name or not
				if not cName or cName == "" or cName:sub(1, 1) == "?" then
					cName = strCardName;
				end
				if cName ~= "" and (cName:sub(1,3) ~= "Sys" or cName:sub(-4) ~= "name") then
					me.NumCards = me.NumCards + 1;
					me.CardList[strIDhex] = {};
					me.CardList[strIDhex].cName = cName;
					me.Owned[strIDhex] = cOwned; -- 1 if card is owned, 0 if not
					me.CardList[strIDhex].Description = cDescr;
					me.CardList[strIDhex].RaceID = cRace; -- normally same as category number
					me.CardList[strIDhex].Rarity = cRare + 2; -- 0 = blue, 1 = violett, 2 = orange card
					me.CardList[strIDhex].Resist = cResist; -- Real impact unknown, defines color of card frame
					cStat = cStat:match("(.-) *$"); -- trim
					me.CardList[strIDhex].Stat = cStat; -- granted stat bonus if in compendium / owned
					me.CardList[strIDhex].Zones = {}; -- predefined table for zone associations
					me.CardList[strIDhex].CharOwned = {}; -- predefined table for owned state of other chars

					-- Create reverse lookup
					if not me.NameLookup[cName] then me.NameLookup[cName] = {}; end
					table.insert(me.NameLookup[cName], strIDhex);

					-- Add to list of stat bonus  types
					local statval, statname = cStat:match ("%+?(%d+) +(.-) *$");
					statname = statname:gsub( ".%d+ ", "" ); -- for % dmg + %mdmg
					if statname then 
						if not me.StatBonuses[statname] then me.StatBonuses[statname] = { Own = 0, Total = 0 }; end
						me.StatBonuses[statname].Total = me.StatBonuses[statname].Total + tonumber(statval); 
						if cOwned == 1 then me.StatBonuses[statname].Own = me.StatBonuses[statname].Own + tonumber(statval); end
					end

					if cOwned == 1 then
						me.NumOwned = me.NumOwned + 1;
					end
				end -- cName
			end -- for j
		end -- intCardsInCat
	end -- for i
end

--[[ =================================================================
  Updates the basic card list after the event CARDBOOKFRAME_UPDATE
  This occurs when a card is added to or removed from the compendium
  and may change the field 'Owned'
  Unfortunately the event carries no information about the related 
  card which would make that update faster
================================================================= --]]
function me.UpdateList()
	
	me.NumOwned = 0;
	for statname, data in pairs(me.StatBonuses) do
		data.Own = 0;
	end
	
	for i = 0 , me.NumCategories do
		local intCardsInCat = LuaFunc_GetCardMaxCount(i);

		if intCardsInCat and intCardsInCat > 0 then
			for j = 1 , intCardsInCat do
				local cID, cOwned = LuaFunc_GetCardInfo(i , j - 1);
				local strIDhex = me.dec2hex(cID);

				local strucCard = me.CardList[strIDhex];
				if strucCard then
					me.Owned[strIDhex] = cOwned; -- 1 if card is owned, 0 if not
					if cOwned == 1 then
						me.NumOwned = me.NumOwned + 1;
						local statval, statname = strucCard.Stat:match ("%+?(%d+) +(.-) *$");
						if statname then 
							me.StatBonuses[statname].Own = me.StatBonuses[statname].Own + tonumber(statval);
						end
					end 
				end -- me.CardList
			end -- for j
		end -- intCardsInCat
	end -- for i

	me.ShowNumbers();
end

--[[ =================================================================
  Add several informations to the basic card list which do not 
  originate from the game's internal card list
  Anything created here is permanent over runtime 
================================================================= --]]
function me.AddListSpecials()
	if me.MobNamePatch then
		for cName, strIDhex in pairs(me.MobNamePatch) do
			if not me.NameLookup[cName] then me.NameLookup[cName] = {}; end
			table.insert(me.NameLookup[cName], strIDhex);
		end
	end
	
	for strIDhex, val in pairs(me.SpecialProps) do
		if me.CardList[strIDhex] then
			if val == 1 then
				me.CardList[strIDhex].QuestReward = 1;
			elseif  val == 2 then
				me.CardList[strIDhex].QuestMob = 1;
			elseif  val == 3 then
				me.CardList[strIDhex].DracoMob = 1;
			elseif  val == 4 then
				me.CardList[strIDhex].NotObtainable = 1;
			elseif	val == 5 then
				me.CardList[strIDhex].EventMob = 1;
			elseif	val == 7 then
				me.CardList[strIDhex].RareMob = 1;
			elseif	val == 8 then
				me.CardList[strIDhex].RandomMob = 1;
			end
		end
	end
end

--[[ =================================================================
  Add informations the other registered chars owned cards. 
  Anything created here is permanent over runtime 
================================================================= --]]
function me.AddCharOwnedInfo()
	for CharName, Data in pairs(_G[me.name .. "_Persistent"][me.Realm]) do
		if CharName ~= me.Player and Data.Owned then
			for strIDhex, state in pairs(Data.Owned) do
				if state == 1 then table.insert(me.CardList[strIDhex].CharOwned, CharName); end
			end
			me.NumCharacters = me.NumCharacters + 1;
		end
	end	
end

--[[ =================================================================
  Does a NPC search with the given cardname. 
  Returns a table with matching ZoneIDs and NpcIDs
================================================================= --]]
function me.GetZonesFromName(cardname)
	if type(cardname) ~= "string" then return nil; end
	local zones = {};
	local HitCount = NpcTrack_SearchNpc(cardname);
	for idxFound = 1, HitCount do
		local npcID, npcName, npcZone = NpcTrack_GetNpc(idxFound);
		if npcName == cardname then
			zones[npcZone] = npcID;
		end
	end -- for idxFound
	return zones;
end

--[[ =================================================================
  Creates the list of associated zones using NPC search; expands an existing list
================================================================= --]]
function me.CreateZonesFromNPCsearch()
	if not _G[me.name .. "_Persistent"].NPCzones then _G[me.name .. "_Persistent"].NPCzones = {}; end
	local zonelist = _G[me.name .. "_Persistent"].NPCzones;

	if not zonelist.ProcessedCards or zonelist.ProcessedCards ~= me.NumCards then
		for strIDhex, strucCard in pairs(me.CardList) do
			local zones = me.GetZonesFromName(strucCard.cName);
			if me.TableSize(zones) > 0 then
				if not zonelist[strIDhex] then zonelist[strIDhex] = {}; end
				zonelist[strIDhex] = zones;
			end
		end
		zonelist.ProcessedCards = me.NumCards;
	end
end

--[[ =================================================================
  Adds the given zone or table of zones to the zones lookup table
================================================================= --]]
function me.AddZoneInfo(strIDhex, zones)
	if not zones then return false; end

	if type(zones) == "table" then
		for zone, val in pairs(zones) do
			if not me.ZoneLookup[zone] then me.ZoneLookup[zone] = {}; end
			if me.ZoneLookup[zone][strIDhex] ~= -1 then
				me.ZoneLookup[zone][strIDhex] = val;
				me.CardList[strIDhex].Zones[zone] = val;
			end
		end
	else
		if not me.ZoneLookup[zones] then me.ZoneLookup[zones] = {}; end
		if me.ZoneLookup[zones][strIDhex] ~= -1 then
			me.ZoneLookup[zones][strIDhex] = 1;
			me.CardList[strIDhex].Zones[zones] = 1;
		end
	end
end

--[[ =================================================================
  Add zone informations to the basic card list which do not 
  originate from the game's internal card list. The table 'Zones' 
   may be changed when a known mob is found in a new location.
================================================================= --]]
function me.AddListZones()
	for strIDhex, Zones in pairs(_G[me.name .. "_Persistent"].NPCzones) do
		if me.CardList[strIDhex] then
			me.AddZoneInfo(strIDhex, Zones);
		end
	end

	for strIDhex, Zones in pairs(me.MobZones) do
		if me.CardList[strIDhex] then
			me.AddZoneInfo(strIDhex, Zones);
		end
	end

	for strIDhex, Zones in pairs(_G[me.name .. "_Persistent"].MobZonesFix) do
		if me.CardList[strIDhex] then
			me.AddZoneInfo(strIDhex, Zones);
		end
	end
end

--[[ =================================================================
  Returns headline for item tooltip or link text
================================================================= --]]
function me.GetCardLabel(strucCard, islink)
	local color = me.RarityColors[strucCard.Rarity];
	local label = TEXT("SYS_CARD_TITLE"):gsub("^%l", string.upper) .. strucCard.cName;
	if islink then
		return color:format("[") .. me.ShortLogo .. color:format(":" .. label .. "]");
	else
		return color:format(label);
	end
end

--[[ =================================================================
  Returns the full status string of a card, if requested with colored
  'card' and appended counter for all characters
================================================================= --]]
function me.GetOwnedString(strIDhex, withcolor)
	local strucCard = me.CardList[strIDhex];
	local statusstr = iif(me.Owned[strIDhex] == 1, me.haveC, me.donthaveC);
	local cardstr = iif(me.Owned[strIDhex] == 1 , me.Locales.card, me.Locales.nocard);
	local count = "";
	if	not _G[me.name .. "_Persistent"][me.Realm][me.Player].HideSums then
		count = string.format(" (%d/%d)", #strucCard.CharOwned + me.Owned[strIDhex], me.NumCharacters);
	end

	if withcolor then
		local card = "|r" .. me.RarityColors[strucCard.Rarity]:format(cardstr) .. statusstr:sub(1,10);
		return statusstr:format(card, count);
	else
		return statusstr:format(cardstr, count);
	end
end

--[[ =================================================================
  Converts the given zones table into a string
================================================================= --]]
function me.GetZonesString(strucCard)
	local strZones = "";
	if strucCard then
		for zone, val in pairs(strucCard.Zones) do
			if val ~= -1 then 
				if strZones ~= "" then strZones = strZones .. ", "; end
				strZones = strZones .. GetZoneLocalName(zone);
			end
		end
  	end
	return iif(strZones=="", me.Locales.unknown, strZones);
end

--[[ =================================================================
  Tries to evaluate the correct card ID from the given name and zoneID. 
  Also returns a flag, if the card is already registered for the given zoneID.
  - If the zoneID is -1 (some mini instances have that, see Ystra Labyrinth),
    then zoneID is ignored but the 'registered flag' is returned.
  - If zoneID is 0 or nil, it is ignored. This may result in the wrong 
    ID if the cardname exists more than once. 
  - If the cardname exists more than once in the same zone (known for Count 
    Hibara and Zurhidon Disciple) there is a natural chance to return the wrong ID. 
  - Added a fix for Ystra Highlands. It seems, that the snow festival adds an
    instance layer to that zone, which has to be treated. 
================================================================= --]]
function me.GetIDfromNameZone(cardname, zoneID)
	local chkZoneID = iif(zoneID, zoneID, 0);
	if chkZoneID == 358 then chkZoneID = 5; end -- Ystra fix
	if type(cardname) ~= "string" or type(chkZoneID) ~= "number" then return nil; end
	if not me.NameLookup[cardname] then return nil; end
	if chkZoneID > 0 and not GetZoneLocalName(chkZoneID) then return nil; end

	if ( table.maxn( me.NameLookup[cardname] ) > 1 ) then
		table.sort( me.NameLookup[cardname],
			function( a, b )
				return me.CardList[a].Rarity < me.CardList[b].Rarity;
			end
		);
	end
	local newIDhex = nil;
	for _, strIDhex in ipairs(me.NameLookup[cardname]) do
		if not me.CardList[strIDhex].Zones[chkZoneID] then
			newIDhex = strIDhex;
		elseif me.CardList[strIDhex].Zones[chkZoneID] ~= -1 then
			return strIDhex, 1;
		end
	end
	return newIDhex, iif(chkZoneID == -1, 1, 0)
end

--[[ =================================================================
  Checks if mouseover mob exists only for ambience (and has no card)
  This is normally the case if the mobs has level 1 except starting areas
================================================================= --]]
function me.IsAmbientMob()
	local StartArea = { 
		[1] = { X1=0.18, Y1=0.56, X2=0.54, Y2=1 }, -- Howling Mountains
		[12] = { X1=0.43, Y1=0.32, X2=0.72, Y2=0.65 }, -- Elven Isle
		[10] = { X1=0.52, Y1=0.24, X2=1, Y2=0.48 }, -- Sascilia Steppes
		[31] = { X1=0.10, Y1=0.45, X2=0.25, Y2=0.70 } }; -- Yrvandis Hollows

	local mobLevel, _ = UnitLevel("mouseover");
	if mobLevel > 1 then return false; end

	local WMapID = GetCurrentWorldMapID();
	if not StartArea[WMapID] then return true; end
	
	local PosX, PosY = GetPlayerWorldMapPos();
	if StartArea[WMapID].X1 < PosX and PosX < StartArea[WMapID].X2 and
	   StartArea[WMapID].Y1 < PosY and PosY < StartArea[WMapID].Y2 then return false; end
	
	return true;
end

--[[ =================================================================
  Creates the new tooltip for cards (item).
================================================================= --]]
function me.ShowCardTooltip(tooltip, strIDhex)

	if not tooltip or not strIDhex or strIDhex == "" then return false; end
	if not me.CardList[strIDhex] then return false; end

	local strucCard = me.CardList[strIDhex];

	tooltip:ClearLines();
	tooltip:SetText(me.GetCardLabel(strucCard, false));

	tooltip:AddLine(me.Locales.category .. me.Yellow:format(LuaFunc_GetString("SYS_RACE_" .. strucCard.RaceID)));
	tooltip:AddLine(me.Locales.stat .. me.Yellow:format(strucCard.Stat));
	--tooltip:AddLine(me.Locales.resist .. me.Yellow:format(strucCard.Resist));

	tooltip:AddLine(me.Locales.location .. me.Yellow:format(me.GetZonesString(strucCard)));

	tooltip:AddLine(strucCard.Description);

	if strucCard.QuestReward then
		tooltip:AddLine(me.Orange:format(me.Locales.reward));
	elseif strucCard.QuestMob then
		tooltip:AddLine(me.Orange:format(me.Locales.questmob));
	--elseif strucCard.NotObtainable then
		--tooltip:AddLine(me.Orange:format(me.Locales.notobtain));
	elseif strucCard.EventMob then
		tooltip:AddLine(me.Orange:format(me.Locales.eventmob));
	elseif strucCard.DracoMob then
		tooltip:AddLine(me.Orange:format(me.Locales.dracomob));
	elseif strucCard.RareMob then
		tooltip:AddLine(me.Orange:format(me.Locales.raremob));
	elseif strucCard.RandomMob then
		tooltip:AddLine(me.Orange:format(me.Locales.randommob));
	end

	tooltip:AddLine(me.GetOwnedString(strIDhex, false));
	
	local Separator = getglobal(tooltip:GetName() .. "Separator5");
	Separator:ClearAllAnchors();
	Separator:SetAnchor("TOP", "TOP", tooltip, 0, (tooltip:GetBottom()-tooltip:GetTop()-3.25)/GetUIScale());
	tooltip:AddLine("\n");

	tooltip:AddLine(yaCIt.Locales.book.cardoverlay.cardid .. " " .. me.Yellow:format(tonumber(strIDhex,16) .. " / " .. strIDhex));
 -- tooltip:AddLine(yaCIt.Locales.book.cardoverlay.monsterid .. " " .. me.Yellow:format(TEXT("??????")));

	Separator:SetWidth(tooltip:GetWidth()-20);
	Separator:Show();
end

--[[ =================================================================
  MouseOver event; used to expand mob tooltip with card information
================================================================= --]]
function me.MouseOverUnit()
	if not _G[me.name .. "_Persistent"].ShowMobTT then return false; end

	local WMapID = GetCurrentWorldMapID();
	if WMapID == 402 or (WMapID >= 440 and WMapID < 450) then -- Skip PvP zones
		return false;
	end

	if not GameTooltip:IsVisible() or not UnitCanAttack("player", "mouseover") or UnitIsPlayer("mouseover") then
		return false;
	end
	
	local strName = UnitName("mouseover");
	local Separator = getglobal(GameTooltip:GetName() .. "Separator5");
	Separator:ClearAllAnchors();
	Separator:SetAnchor("TOP", "TOP", GameTooltip, 0, (GameTooltip:GetBottom()-GameTooltip:GetTop()-3.25)/GetUIScale());
	GameTooltip:AddLine("\n");

	if me.IsAmbientMob() then
		GameTooltip:AddLine(me.Logo .. ": " .. me.Yellow:format(me.Locales.ambience));
	else
		local strIDhex, isReg = me.GetIDfromNameZone(strName, WMapID);

		if not strIDhex or UnitMaster("mouseover") then
			GameTooltip:AddLine(me.Logo .. ": " .. me.Yellow:format(me.Locales.notfound));
		else
			local strucCard = me.CardList[strIDhex];
			GameTooltip:AddLine(me.Logo .. ": " .. me.Yellow:format(strucCard.Stat));
			if strucCard.QuestMob then GameTooltip:AddLine(me.Orange:format(me.Locales.questmob)); end
			if strucCard.DracoMob then GameTooltip:AddLine(me.Orange:format(me.Locales.dracomob)); end
			if strucCard.NotObtainable then GameTooltip:AddLine(me.Orange:format(me.Locales.notobtain)); end
			if strucCard.EventMob then GameTooltip:AddLine(me.Orange:format(me.Locales.eventmob)); end
			if strucCard.RareMob then GameTooltip:AddLine(me.Orange:format(me.Locales.raremob)); end
			if strucCard.RandomMob then GameTooltip:AddLine(me.Orange:format(me.Locales.randommob)); end

			GameTooltip:AddLine(me.GetOwnedString(strIDhex, true));
			
			Separator:ClearAllAnchors();
			Separator:SetAnchor("TOP", "TOP", GameTooltip, 0, (GameTooltip:GetBottom()-GameTooltip:GetTop()-3.25)/GetUIScale());
			GameTooltip:AddLine("\n");
			
			local nameOfRune = "";
			local resist = strucCard.Resist;
			local resistoverlay = yaCIt.Locales.book.resistoverlay;
			if resist == 0 then
				nameOfRune = resistoverlay.empty;
			elseif resist == 1 then
				nameOfRune = resistoverlay.linkRune;
			elseif resist == 2 then
				nameOfRune = resistoverlay.frostRune;
			elseif resist == 3 then
				nameOfRune = resistoverlay.activateRune;
			elseif resist == 4 then
				nameOfRune = resistoverlay.disenchantRune;
			elseif resist == 5 then
				nameOfRune = resistoverlay.purifyRune;
			elseif resist == 6 then
				nameOfRune = resistoverlay.blendRune;
			end;
			
--			GameTooltip:AddLine(yaCIt.Locales.book.cardoverlay.cardid .. " " .. me.Yellow:format(tonumber(strIDhex,16) .. " / " .. strIDhex));
			GameTooltip:AddLine(yaCIt.Locales.book.cardoverlay.resistlabel .. " " .. me.Yellow:format(nameOfRune));
--			GameTooltip:AddLine("ID: " .. me.Yellow:format(tonumber(strIDhex, 16) .. " / " .. strIDhex));

			-- register new zone if unknown
			if isReg == 0 then
				local ZonesFix = _G[me.name .. "_Persistent"].MobZonesFix;
				if not ZonesFix[strIDhex] then ZonesFix[strIDhex] = {}; end
				ZonesFix[strIDhex][WMapID] = 1;
				me.AddZoneInfo(strIDhex, WMapID);
				me.ZoneSelectDDneedUpdate = true
				me.PrintF(me.Red, me.Locales.update:format(strName));
			end
		end
	end
	Separator:SetWidth(GameTooltip:GetWidth()-20);
	Separator:Show();
end

--[[ =================================================================
  Hook function for mouse-over event if another tooltip addon is installed
  ensures correct order of event handling
================================================================= --]]
function me.TooltipAddonUpdate()
	me.TooltipAddonUpdate_orig();
	me.MouseOverUnit();
end

--[[ =================================================================
  command line processing
================================================================= --]]

--[[ =================================================================
  Send current status to chat frame
================================================================= --]]
function me.ShowStatus()
	me.Print(me.Version);
	me.ShowNumbers();

	me.Print(me.Locales.shorthelp);
end

--[[ =================================================================
  Search card containing given text and add to chat frame
================================================================= --]]
function me.SearchCards(filter)
	
	local intFound = 0;
	for strIDhex, strucCard in pairs(me.CardList) do
		local isMatch = true;
		for word in filter:gmatch("%w+") do
			isMatch = isMatch and (strucCard.cName:lower():match(word) ~= nil)
		end

		if isMatch then
			intFound = intFound + 1;
			local linkText = me.GetCardLabel(strucCard, true);
			local link = me.CreateLink("item", strIDhex, linkText);
			me.Print(link);
		end -- isMatch
	end -- for
	me.Print(me.Locales.cmdfound:format(intFound));
end

--[[ =================================================================
  Send command line help to chat frame
================================================================= --]]
function me.ShowHelp()
	if me.Locales.cmdhelp then
		for i = 1, #me.Locales.cmdhelp do
			me.Print(me.Locales.cmdhelp[i]);
		end
	end
end

--[[ =================================================================
  command line processing - dispatcher
================================================================= --]]
function me.CmdParser(_, arg)

	arg = iif(arg, arg:lower(), "");

	if arg == "help" then
		me.ShowHelp();
		return;
	elseif arg == "cfg" then
		if yaCItConfigFrame then
			ShowUIPanel(yaCItConfigFrame);
		end
		return;
	elseif arg ~= "" then
		me.SearchCards(arg);
		return;
	end
	me.ShowStatus();
end

--[[ =================================================================
  The following functions are called by the XML (UI) object
================================================================= --]]
function me.OnLoad(this)
	me.ShortLogo = me.Red:format("C") .. me.Green:format("I");
	me.Logo = "ya" .. me.ShortLogo .. "t" .." ".. me.Orange:format("Z");
	me.Realm = GetCurrentRealm();

	local lang = GetLanguage():upper();
	local locfile = string.format("Interface/Addons/%s/locales/%s.%s.lua", me.name, me.name, lang);
	local _, e = loadfile(locfile);
	if e then
		locfile = string.format("Interface/Addons/%s/locales/%s.ENEU.lua", me.name, me.name);
		loadfile(locfile);
	end
	dofile(locfile);
	
	this:RegisterEvent("CARDBOOKFRAME_UPDATE");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("LOADING_END");

	SaveVariables(me.name .. "_Persistent");
end

--[[ =================================================================
  Event handler. Initilizes most tables
================================================================= --]]
function me.OnEvent(frame, event)
	if event == "CARDBOOKFRAME_UPDATE" then
		me.UpdateList();
		if CardBookFrame:IsVisible() then
			OnShow_CardFrame();
		end
	end

	if event == "UPDATE_MOUSEOVER_UNIT" then
		me.MouseOverUnit();
	end

	if event == "VARIABLES_LOADED" then
		if not _G[me.name .. "_Persistent"] then
			_G[me.name .. "_Persistent"] = {
				ShowItemTT = true,
				ShowMobTT = true,
				MobZonesFix = {}
			}
		end

		LuaFunc_InitCardInfo();
		me.CreateCardList();
		me.AddListSpecials();

		me.CreateZonesFromNPCsearch();
		me.AddListZones();
		me.ZoneSelectDDneedUpdate = true;

		me.CreateHooks();

		local myframe = getglobal(me.name .. "Frame");
		if pbInfo then
			me.TooltipAddonUpdate_orig = pbInfo.Tooltip.Scripts.OnUpdate;
			pbInfo.Tooltip.Scripts.OnUpdate = me.TooltipAddonUpdate;
		else
			myframe:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
		end

		if AdvancedAuctionHouse then
			me.CreateAAHfilterHook();
		end

		_G["SLASH_" .. me.name .. "1"] = "/ci";
		_G["SLASH_" .. me.name .. "2"] = "/" .. me.name:lower();
		SlashCmdList[me.name] = me.CmdParser;

		me.haveC = me.Green:format(me.Locales.have .. "%s");
		me.donthaveC = me.Red:format(me.Locales.donthave .. "%s");
		
		me.ShowStatus();
	end

	if event == "LOADING_END" then
		if not me.AllOwnedInit then
			me.Player = UnitName("player");
		
			if not _G[me.name .. "_Persistent"][me.Realm] then 
				_G[me.name .. "_Persistent"][me.Realm] = {}; 
			end;
			if not _G[me.name .. "_Persistent"][me.Realm][me.Player] then 
				_G[me.name .. "_Persistent"][me.Realm][me.Player] = {}; 
			end;

			me.AddCharOwnedInfo();
			me.AllOwnedInit = true;
			if not _G[me.name .. "_Persistent"][me.Realm][me.Player].DontSave then
				_G[me.name .. "_Persistent"][me.Realm][me.Player].Owned = me.Owned; 
			end
		end
	end
end

--[[ =================================================================
  Displays the card item itooltip, reference is an item link
================================================================= --]]
function me.ShowTooltipByLink(tooltip, link)

	if not tooltip or not link then return false; end
	if not _G[me.name .. "_Persistent"].ShowItemTT then return false; end

	local _, _, strIDhex = link:find(':([0-9a-f]+)');
	if not strIDhex or strIDhex == "" then return false; end

	me.ShowCardTooltip(tooltip, strIDhex);
end

--[[ =================================================================
  Displays the card item itooltip, reference is the tooltip itself
  Workaround for tooltip hooks where retrieving link is not possible
================================================================= --]]
function me.ShowTooltipBySelf(tooltip)

	if not tooltip then return false; end
	if not _G[me.name .. "_Persistent"].ShowItemTT then return false; end

	local origtooltipname = tooltip:GetName();
	local itemname = getglobal(origtooltipname .. "TextLeft1"):GetText();
	itemname = itemname:sub(TEXT("SYS_CARD_TITLE"):len() + 1);

	local strIDhex = me.GetIDfromNameZone(itemname,0);
	if strIDhex then me.ShowCardTooltip(tooltip, strIDhex); end
end

--[[ =================================================================
  Hook functions for all the calls to display an item tooltip
  support for Inventory Viewer and Adv. Auctionhouse
================================================================= --]]
function me.CreateHooks()
	local GameTooltip_obj = _G.GameTooltip;
	local GameTooltipHyperLink_obj = _G.GameTooltipHyperLink;

--[[ -----------------------------------------------------------------
  Auctionhouse hooks (browse, bid, sell, sell prepare and history)
----------------------------------------------------------------- --]]
	local SetAuctionBrowseItem_orig = GameTooltip_obj.SetAuctionBrowseItem;
	function GameTooltip:SetAuctionBrowseItem(id)
		SetAuctionBrowseItem_orig(GameTooltip_obj, id);
		me.ShowTooltipByLink(self, GetAuctionBrowseItemLink(id));
	end
	local SetAuctionBidItem_orig = GameTooltip_obj.SetAuctionBidItem;
	function GameTooltip:SetAuctionBidItem(id)
		SetAuctionBidItem_orig(GameTooltip_obj, id);
		me.ShowTooltipBySelf(self);
	end
	local SetAuctionSellItem_orig = GameTooltip_obj.SetAuctionSellItem;
	function GameTooltip:SetAuctionSellItem(id)
		SetAuctionSellItem_orig(GameTooltip_obj, id);
		me.ShowTooltipBySelf(self);
	end
	local SetAuctionItem_orig = GameTooltip_obj.SetAuctionItem;
	function GameTooltip:SetAuctionItem()
		SetAuctionItem_orig(GameTooltip_obj);
		me.ShowTooltipBySelf(self);
	end
	local SetHistoryItem_orig = GameTooltip_obj.SetHistoryItem;
	function GameTooltip:SetHistoryItem(id)
		SetHistoryItem_orig(GameTooltip_obj, id);
		me.ShowTooltipBySelf(self);
	end

--[[ -----------------------------------------------------------------
  mailbox hooks (inbox, send)
----------------------------------------------------------------- --]]
	local SetInboxItem_orig = GameTooltip_obj.SetInboxItem;
	function GameTooltip:SetInboxItem(id)
		SetInboxItem_orig(GameTooltip_obj, id);
		me.ShowTooltipBySelf(self);
	end
	local SetSendMailItem_orig = GameTooltip_obj.SetSendMailItem;
	function GameTooltip:SetSendMailItem()
		SetSendMailItem_orig(GameTooltip_obj);
		me.ShowTooltipBySelf(self);
	end

--[[ -----------------------------------------------------------------
  private storage areas (bag, bank, chests and other house storage)
----------------------------------------------------------------- --]]
	local SetBagItem_orig = GameTooltip_obj.SetBagItem;
	function GameTooltip:SetBagItem(id)
		SetBagItem_orig (GameTooltip_obj, id);
		me.ShowTooltipByLink(self, GetBagItemLink(id));
	end
	local SetBankItem_orig = GameTooltip_obj.SetBankItem;
	function GameTooltip:SetBankItem(id)
		SetBankItem_orig(GameTooltip_obj, id);
		me.ShowTooltipByLink(self, GetBankItemLink(id));
	end
	local SetHouseItem_orig = GameTooltip_obj.SetHouseItem;
	function GameTooltip:SetHouseItem(emplacementID, id)
		SetHouseItem_orig(GameTooltip_obj, emplacementID, id);
		if not emplacementID then
			me.ShowTooltipByLink(self, Houses_GetItemLink(emplacementID, id));
		end
	end
	local SetHyperLink_orig = GameTooltip_obj.SetHyperLink;
	function GameTooltip:SetHyperLink(link)
		SetHyperLink_orig(GameTooltip_obj, link);
		me.ShowTooltipByLink(self, link);
	end

--[[ -----------------------------------------------------------------
  Other card related hooks (loot, quest reward, trade window)
----------------------------------------------------------------- --]]
	local SetBootyItem_orig = GameTooltip_obj.SetBootyItem;
	function GameTooltip:SetBootyItem(id)
		SetBootyItem_orig(GameTooltip_obj, id);
		me.ShowTooltipByLink(self, GetBootyItemLink(id));
	end
	local SetLootItem_orig = GameTooltip_obj.SetLootItem;
	function GameTooltip:SetLootItem(info1, info2, info3, info4)
		SetLootItem_orig(GameTooltip_obj, info1, info2, info3, info4);
		me.ShowTooltipBySelf(self);
	end
	local SetQuestItem_orig = GameTooltip_obj.SetQuestItem;
	function GameTooltip:SetQuestItem(rewardType, id)
		SetQuestItem_orig(GameTooltip_obj, rewardType, id);
		me.ShowTooltipBySelf(self);
	end
	local SetTradePlayerItem_orig = GameTooltip_obj.SetTradePlayerItem;
	function GameTooltip:SetTradePlayerItem(id)
		SetTradePlayerItem_orig(GameTooltip_obj, id);
		me.ShowTooltipBySelf(self);
	end
	local SetTradeTargetItem_orig = GameTooltip_obj.SetTradeTargetItem;
	function GameTooltip:SetTradeTargetItem(id)
		SetTradeTargetItem_orig(GameTooltip_obj, id);
		me.ShowTooltipBySelf(self);
	end

--[[ -----------------------------------------------------------------
  hyperlink hook (e.g. that things in the chat frames)
----------------------------------------------------------------- --]]
	local SetHyperLink_orig = GameTooltipHyperLink_obj.SetHyperLink;
	function GameTooltipHyperLink:SetHyperLink(link)
		SetHyperLink_orig(GameTooltipHyperLink_obj, link);
		me.ShowTooltipByLink(self, link);
	end

--[[ -----------------------------------------------------------------
  Advanced Auctionhouse 1.2+ / thx to: Graves
  This is called when using a filter.
----------------------------------------------------------------- --]]
	if AA_Tooltip then
		local AA_Tooltip_obj = AA_Tooltip;
		local SetHyperLink_orig = AA_Tooltip_obj.SetHyperLink;
		function AA_Tooltip:SetHyperLink(link)
			SetHyperLink_orig(AA_Tooltip_obj, link);
			me.ShowTooltipByLink(self, link);
		end
	end
--[[ -----------------------------------------------------------------
  Advanced Auctionhouse 2.7+
  This is called when using a filter.
----------------------------------------------------------------- --]]
	if AAH_Tooltip then
		local AA_Tooltip_obj = AAH_Tooltip;
		local SetHyperLink_orig = AA_Tooltip_obj.SetHyperLink;
		function AAH_Tooltip:SetHyperLink(link)
			SetHyperLink_orig(AA_Tooltip_obj, link);
			me.ShowTooltipByLink(self, link);
		end
	end
end

--[[ =================================================================
  Adds a new filter option ($notowned) to Adv. Auctionhouse 
  filter list. Option is also added to tooltip help
================================================================= --]]
function me.CreateAAHfilterHook()

	local filter = me.Locales.donthave:format(me.Locales.nocard);
	function me.AAH_FilterCardNotOwned(param, listing)
		return AAHFunc.FiltersSearchInTooltip(filter, listing);
	end

	AAHFunc.FiltersRegister({coms = "$notowned", func =  me.AAH_FilterCardNotOwned})
	AAHLocale.Messages.BROWSE_FILTER_TOOLTIP_TEXT3 = "|cffffd200$notowned|r - " .. yaCIt.Locales.AAHfilterhelp .. "\n" .. AAHLocale.Messages.BROWSE_FILTER_TOOLTIP_TEXT3

end

--[[ =================================================================
======================================================================
  expansions for the config dialog
======================================================================
================================================================= --]]

--[[ =================================================================
  Event function mouse enter object with tooltip awareness
  If a tooltip text is defined in the localize data it is displayed
  The function call to hide it on leave is located in the XML file  
================================================================= --]]
function me.ShowTooltip(Object)
	if _G[me.name .. "_Persistent"].HideHelpTT then return false; end

	GameTooltip:SetOwner(Object,"ANCHOR_BOTTOMRIGHT",-Object:GetWidth(),0);

	local tthelp = me.Locales.tthelp[Object:GetName():match(".-_(.+)")];
	if tthelp then
		GameTooltip:SetText(yaCIt.Yellow:format(tthelp[1]));
		GameTooltip:AddLine(tthelp[2]);
	end;
end;

--[[ =================================================================
  function for info ripping (only for debug)
================================================================= --]]
function me.SaveZoneList()
	local ZoneList = {};
	local continentID = 1;
	local mapTables = WorldMapTable[continentID].mapTables;

	for _, mapType in ipairs(g_MapTypes) do
		local mapTypeName = TEXT(string.upper("UI_WORLDMAP_" .. mapType));

		if not ZoneList[mapTypeName] then ZoneList[mapTypeName] = {}; end

		for zoneIdx, zone in ipairs(mapTables[mapType]) do
		  ZoneList[mapTypeName][zoneIdx] = zone;
		end
	end

	_G[me.name .. "_ZoneList"] = ZoneList;
	SaveVariables(me.name .. "_ZoneList");
end

function me.SaveCardList()
	_G[me.name .. "_CardList"] = me.CardList;
	SaveVariables(me.name .. "_CardList");
end

_G[me.name] = me;
