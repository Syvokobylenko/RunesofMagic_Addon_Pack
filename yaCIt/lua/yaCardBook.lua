local me = {
	name = "yaCardBook",

	FrameItemListSize = 18,

	CardList_Sorted = {},
	CardList_Filtered = {},
	NumOwned_Filtered = 0,
	ItemListSelected = 1,

	ciGrey50 = "|cff808080%s|r", -- text grey 50%

	DD_Zone_Value = -1,
	DD_Category_Value = -1,
	DD_Bonus_Value = -1,
	DD_FiltMisc_Value = -1,
	DD_Sort_Value = -1,

	Sort_Price_Sections = { 999999999, 5000000, 2000000, 1000000, 500000, 200000, 100000, 50000, 1 },
	
	FilterBox_Value = "",
	FilterBox_Num = 0,
	ScrollBar_Value = 0
}
--[[ =================================================================
  Retrieves a node from a hierarchic structured table. A valid node
  must be a table element named 'child'. Optimized for menu structures
================================================================= --]]
function me.GetIndexedNodeFromTab(tab, path)
	local result = tab;
	for idx in string.gmatch(path, "(%d+).?") do
		idx = tonumber(idx);
		if result[idx] and result[idx].child then
			result = result[idx].child;
		else
			return {};
		end
	end
	return result;
end

--[[ =================================================================
  Adds a menu structure to the currently opened menu (dropdown or else)
  If isTitle is true that entry is disabled and it's color is yellow
================================================================= --]]
function me.ShowMenu(ddname, menu, checkval)
	if type(ddname) ~= "string" or ddname == "" or type(menu) ~= "table" then
		return;
	end

	local func = me[ddname .. "_Click"];
	if type(func) ~= "function" then return; end

	local MenuLevel = UIDROPDOWNMENU_MENU_LEVEL;
	local SubMenuKey = "child";
	local entries = menu;
	if MenuLevel > 1 then
		SubMenuKey = UIDROPDOWNMENU_MENU_VALUE;
		entries = me.GetIndexedNodeFromTab(menu, UIDROPDOWNMENU_MENU_VALUE);
	end

	for idx, entry in pairs(entries) do
		local info = {};
		info.text = entry.text;
		info.value = iif(entry.child, SubMenuKey .. "." .. idx, entry.value);
		info.checked = (checkval == info.value);
		info.isTitle = entry.isTitle;
		info.notCheckable = entry.isTitle;
		info.disabled = entry.disabled;
		info.markNumber = entry.markNumber;
		info.notCheckable = entry.notCheckable;
		info.hasArrow = iif(entry.child, 1, nil);
		info.func = iif(entry.child, nil, func);
		info.owner = getglobal(me.name .. "_" .. ddname);
		UIDropDownMenu_AddButton(info, MenuLevel);
	end
end

--[[ =================================================================
  Searches a menu structure for an option with the given value
  and returns the related text label; otherwise nil
================================================================= --]]
function me.GetMenuTextFromValue(menu, value)
local result = nil;
	for idx, entry in pairs(menu) do
		if entry.child then 
			result = me.GetMenuTextFromValue(entry.child, value);
		else
			if entry.value == value then result = entry.text; end
		end
		if result then return result; end
	end
end

--[[ =================================================================
  Sets a dropdown menu with the given value
================================================================= --]]
function me.SetMenuValue(DDname, value)
	local menu = me[DDname .. "_Menu"];
	if not menu then return; end
	local DD_Text = getglobal(me.name .. "_" .. DDname .. "Text");
	DD_Text:SetText(me.GetMenuTextFromValue(menu, value));
	me[DDname .. "_Value"] = value;
end

--[[ =================================================================
  DropDown menu to select/filter zone (me.name .. "_DD_Zone")
  Standard definition set: 
    value variable, menu entry table, 
    open-, show- and click-event, create menu and filter function
================================================================= --]]
function me.Zone_Populated(zoneID)
	if yaCIt.ZoneLookup[zoneID] then
		for _, val in pairs(yaCIt.ZoneLookup[zoneID]) do
			if val ~= -1 then return true; end
		end
	end
	return false;
end
				
function me.DD_Zone_CreateMenu()
	if yaCIt.ZoneSelectDDneedUpdate and table.getn(yaCIt.ZoneLookup) > 0 then
		me.DD_Zone_Menu = {};
		local strLocales = yaCIt.Locales.book.zone;
		table.insert(me.DD_Zone_Menu, {text = strLocales.title, isTitle = 1, notCheckable = 1});
		table.insert(me.DD_Zone_Menu, {value = -1, text = strLocales.allcards});
		table.insert(me.DD_Zone_Menu, {value = -2, text = strLocales.unknown});
		table.insert(me.DD_Zone_Menu, {value = -3, text = strLocales.current});

		local continentID = 1; -- Only one continent
		local mapTables = WorldMapTable[continentID].mapTables;

		for mapTypeIndex, mapType in ipairs(g_MapTypes) do
			local mapTypeName = TEXT(string.upper("UI_WORLDMAP_" .. mapType));
			local MenuEntry = {text = mapTypeName, child = {}};
			local mapTypePopulated = false;

			for _, zone in ipairs(mapTables[mapType]) do
				if ( zone.id == 182 ) then
					zone.id = 181;
				end
				if me.Zone_Populated(zone.id) then
					mapTypePopulated  = true;
					table.insert(MenuEntry.child, { value = zone.id, text = zone.name .. " " .. "(" .. zone.id .. ")" } );
				end
			end

			if mapTypePopulated then
				table.insert(me.DD_Zone_Menu, MenuEntry);
			end
		end
		yaCIt.ZoneSelectDDneedUpdate = false;
	end
end

function me.DD_Zone_OnLoad(this)
	UIDropDownMenu_SetWidth(this, 120);
	UIDropDownMenu_SetText(this, yaCIt.Locales.book.zone.allcards);
	UIDropDownMenu_Initialize(this, me.DD_Zone_Show);
end

function me.DD_Zone_Show()
	me.DD_Zone_CreateMenu();
	if me.DD_Zone_Menu then me.DD_Zone_Menu[4].disabled = iif(me.Zone_Populated(GetCurrentWorldMapID()), nil, 1); end
	me.ShowMenu("DD_Zone", me.DD_Zone_Menu, me.DD_Zone_Value);
end

function me.DD_Zone_Click(button)
	if me.DD_Zone_Value ~= button.value then
		if button.value == -3 then
			UIDropDownMenu_SetText(button.owner, GetZoneLocalName(GetCurrentWorldMapID()));
		else
			UIDropDownMenu_SetText(button.owner, button:GetText());
		end
		me.DD_Zone_Value = button.value;
		me.CreateFilteredList();
		me.UpdateFrame();
	end
	CloseDropDownMenus();
end

function me.DD_Zone_Filter(strucCard)
	if me.DD_Zone_Value == -1 then
		return true;
	elseif me.DD_Zone_Value == -2 then
		for _, val in pairs(strucCard.Zones) do
			if val ~= -1 then return false; end
		end
		return true;
	end
	
	local zoneID = iif(me.DD_Zone_Value == -3,  GetCurrentWorldMapID(), me.DD_Zone_Value);
	if not strucCard.Zones[zoneID] then return false; end
	if strucCard.Zones[zoneID] == -1 then return false; end

	return true;
end

--[[ =================================================================
  DropDown menu to select/filter card category (me.name .. "_DD_Category")
  Standard definition set: 
    value variable, menu entry table, 
    open-, show- and click-event, create menu and filter function
================================================================= --]]
function me.DD_Category_CreateMenu()
	if type(me.DD_Category_Menu) ~= "table" then
		me.DD_Category_Menu = {};
		local strLocales = yaCIt.Locales.book.category;
		table.insert(me.DD_Category_Menu, {text = strLocales.title, isTitle = 1, notCheckable = 1});
		table.insert(me.DD_Category_Menu, {value = -1, text = strLocales.allcards});

		for idx = 0, yaCIt.NumCategories do
			if LuaFunc_GetCardMaxCount(idx) > 0 then
				local name = LuaFunc_GetString("SYS_RACE_" .. idx);
				table.insert(me.DD_Category_Menu, {value = idx, text = name});
			end
		end
	end
end

function me.DD_Category_OnLoad(this)
	UIDropDownMenu_SetWidth(this, 120);
	UIDropDownMenu_SetText(this, yaCIt.Locales.book.category.allcards);
	UIDropDownMenu_Initialize(this, me.DD_Category_Show);
end

function me.DD_Category_Show()
	me.DD_Category_CreateMenu();
	me.ShowMenu("DD_Category", me.DD_Category_Menu, me.DD_Category_Value);
end

function me.DD_Category_Click(button)
	if me.DD_Category_Value ~= button.value then
		UIDropDownMenu_SetText(button.owner, button:GetText());
		me.DD_Category_Value = button.value;
		me.CreateFilteredList();
		me.UpdateFrame();
	end
end

function me.DD_Category_Filter(strucCard)
	return iif(not me.DD_Category_Value or me.DD_Category_Value == -1, true, strucCard.RaceID == me.DD_Category_Value);
end

--[[ =================================================================
  DropDown menu to select/filter stat bonus (me.name .. "_DD_Bonus")
  Standard definition set: 
    value variable, menu entry table, 
    open-, show- and click-event, create menu and filter function
================================================================= --]]
function me.DD_Bonus_CreateMenu()
	me.DD_Bonus_Menu = {};
	local strLocales = yaCIt.Locales.book.bonus;
	table.insert(me.DD_Bonus_Menu, {text = strLocales.title, isTitle = 1, notCheckable = 1});
	table.insert(me.DD_Bonus_Menu, {value = -1, text = strLocales.allcards});
--	table.insert(me.DD_Bonus_Menu, {value = -2, text = strLocales.unknown});

	for bonus, data in pairs(yaCIt.StatBonuses) do
		table.insert(me.DD_Bonus_Menu, {value = bonus, text = bonus});
	end
end

function me.DD_Bonus_OnLoad(this)
	UIDropDownMenu_SetWidth(this, 120);
	UIDropDownMenu_SetText(this, yaCIt.Locales.book.bonus.allcards);
	UIDropDownMenu_Initialize(this, me.DD_Bonus_Show);
end

function me.DD_Bonus_Show()
	me.DD_Bonus_CreateMenu();
	me.ShowMenu("DD_Bonus", me.DD_Bonus_Menu, me.DD_Bonus_Value);
end

function me.DD_Bonus_Click(button)
	if me.DD_Bonus_Value ~= button.value then
		UIDropDownMenu_SetText(button.owner, button:GetText());
		me.DD_Bonus_Value = button.value;
		me.CreateFilteredList();
		me.UpdateFrame();
	end
end

function me.DD_Bonus_Filter(strucCard)
	if not me.DD_Bonus_Value or me.DD_Bonus_Value == -1 then
		return true;
	elseif me.DD_Bonus_Value == -2 then
		return strucCard.Stat:len() == 0;
	else
	--	return strucCard.Stat:sub(4) == me.DD_Bonus_Value;
		return strucCard.Stat:gsub( ".%d+ ", "" ) == me.DD_Bonus_Value
	end
end

--[[ =================================================================
  DropDown menu to select/filter misc. options (me.name .. "_DD_FiltMisc")
  Standard definition set: 
    value variable, menu entry table, 
    open-, show- and click-event, create menu and filter function
================================================================= --]]
function me.DD_FiltMisc_CreateMenu()
	me.DD_FiltMisc_Menu = {};
	local strLocales = yaCIt.Locales.book.misc;
	table.insert(me.DD_FiltMisc_Menu, {text = strLocales.title, isTitle = 1, notCheckable = 1});
	table.insert(me.DD_FiltMisc_Menu, {value = -1, text = strLocales.allcards});

	if yaCIt_Persistent then
		local MenuEntry = {text = strLocales.owned, child = {}};
		for CharName, Data in pairs(yaCIt_Persistent[yaCIt.Realm]) do
			
			if Data.Owned then
				table.insert(MenuEntry.child, {value = CharName, text = CharName, markNumber = iif(CharName == yaCIt.Player, 1, nil)});
			end
		end
		table.insert(me.DD_FiltMisc_Menu, MenuEntry);
	end

	table.insert(me.DD_FiltMisc_Menu, {value = -6, text = strLocales.dracomob});
	table.insert(me.DD_FiltMisc_Menu, {value = -7, text = strLocales.raremob});
	table.insert(me.DD_FiltMisc_Menu, {value = -8, text = strLocales.randommob});
	table.insert(me.DD_FiltMisc_Menu, {value = -3, text = strLocales.questmob});
	table.insert(me.DD_FiltMisc_Menu, {value = -2, text = strLocales.reward});
	table.insert(me.DD_FiltMisc_Menu, {value = -5, text = strLocales.eventmob});
	--table.insert(me.DD_FiltMisc_Menu, {value = -4, text = strLocales.notobtain});
	--if AAH_SavedHistoryTable then
		--table.insert(me.DD_FiltMisc_Menu, {value = -6, text = strLocales.AAHhistory});
	--end
end

function me.DD_FiltMisc_OnLoad(this)
	UIDropDownMenu_SetWidth(this, 120);
	UIDropDownMenu_SetText(this, yaCIt.Locales.book.misc.allcards);
	UIDropDownMenu_Initialize(this, me.DD_FiltMisc_Show);
end

function me.DD_FiltMisc_Show()
	me.DD_FiltMisc_CreateMenu();
	me.ShowMenu("DD_FiltMisc", me.DD_FiltMisc_Menu, me.DD_FiltMisc_Value);
end

function me.DD_FiltMisc_Click(button)
	if me.DD_FiltMisc_Value ~= button.value then
		UIDropDownMenu_SetText(button.owner, button:GetText());
		me.DD_FiltMisc_Value = button.value;
		me.CreateFilteredList();
		me.UpdateFrame();
	end
	CloseDropDownMenus();
end

function me.DD_FiltMisc_Filter(strIDhex)
	local strucCard = yaCIt.CardList[strIDhex];
	if not me.DD_FiltMisc_Value or me.DD_FiltMisc_Value == -1 then
		return true;
	elseif me.DD_FiltMisc_Value == -2 then
		return (strucCard.QuestReward == 1);
	elseif me.DD_FiltMisc_Value == -3 then
		return (strucCard.QuestMob == 1);
	elseif me.DD_FiltMisc_Value == -4 then
		return (strucCard.NotObtainable == 1);
	elseif me.DD_FiltMisc_Value == -5 then
		return (strucCard.EventMob == 1);
	elseif me.DD_FiltMisc_Value == -6 then
		return (strucCard.DracoMob == 1);
	elseif me.DD_FiltMisc_Value == -7 then
		return (strucCard.RareMob == 1);
	elseif me.DD_FiltMisc_Value == -8 then
		return (strucCard.RandomMob == 1);
		--return (AAH_SavedHistoryTable[tonumber(strIDhex,16)] ~= nil);
	end
	return yaCIt_Persistent[yaCIt.Realm][me.DD_FiltMisc_Value].Owned[strIDhex] == 1;
end

--[[ =================================================================
  DropDown menu to select primary sort order (me.name .. "_DD_Sort")
  Standard definition set: 
    value variable, menu entry table, 
    open-, show- and click-event, create menu function
================================================================= --]]
function me.DD_Sort_CreateMenu()
	me.DD_Sort_Menu = {};
	local strLocales = yaCIt.Locales.book.sort;
	table.insert(me.DD_Sort_Menu, {text = strLocales.title, isTitle = 1, notCheckable = 1});
	table.insert(me.DD_Sort_Menu, {value = -1, text = strLocales.nosort});
	table.insert(me.DD_Sort_Menu, {value = 1, text = strLocales.zone});
	table.insert(me.DD_Sort_Menu, {value = 2, text = strLocales.stat});
	--table.insert(me.DD_Sort_Menu, {value = 3, text = strLocales.owned});
	--if AAH_SavedHistoryTable then
		--table.insert(me.DD_Sort_Menu, {value = 4, text = strLocales.AAHavg});
	--end
end

function me.DD_Sort_OnLoad(this)
	UIDropDownMenu_SetWidth(this, 120);
	UIDropDownMenu_SetText(this, yaCIt.Locales.book.sort.nosort);
	UIDropDownMenu_Initialize(this, me.DD_Sort_Show);
end

function me.DD_Sort_Show()
	me.DD_Sort_CreateMenu();
	me.ShowMenu("DD_Sort", me.DD_Sort_Menu, me.DD_Sort_Value);
end

function me.DD_Sort_Sort()
	me.CardList_Sorted = {};
	if me.DD_Sort_Value == -1 then
		table.sort(me.CardList_Filtered, function (c1, c2)
			return yaCIt.CardList[c1].cName < yaCIt.CardList[c2].cName; 
		end)
		me.CardList_Sorted = me.CardList_Filtered;
	elseif me.DD_Sort_Value == 1 then
		table.sort(me.CardList_Filtered, function (c1, c2)
			local Zones1 = yaCIt.GetZonesString(yaCIt.CardList[c1]);
			local Zones2 = yaCIt.GetZonesString(yaCIt.CardList[c2]);
			if Zones1 == Zones2 then
				return yaCIt.CardList[c1].cName < yaCIt.CardList[c2].cName; 
			else
				return Zones1 < Zones2;
			end
		end)
		local lastVal = "";
		for idx,strIDhex in ipairs(me.CardList_Filtered) do
			local zone = yaCIt.GetZonesString(yaCIt.CardList[strIDhex]);
			if zone ~= lastVal then
				lastVal = zone;
				table.insert(me.CardList_Sorted, zone);
			end
			table.insert(me.CardList_Sorted, strIDhex);
		end
	elseif me.DD_Sort_Value == 2 then
		table.sort(me.CardList_Filtered, function (c1, c2)
			local Card1 = yaCIt.CardList[c1];
			local Card2 = yaCIt.CardList[c2];
			if Card1.Stat == Card2.Stat then
				return Card1.cName < Card2.cName; 
			else
				return Card1.Stat < Card2.Stat;
			end
		end)
		local lastVal = "";
		for idx,strIDhex in ipairs(me.CardList_Filtered) do
			local stat = yaCIt.CardList[strIDhex].Stat;
			if stat ~= lastVal then
				lastVal = stat;
				table.insert(me.CardList_Sorted, stat);
			end
			table.insert(me.CardList_Sorted, strIDhex);
		end
	elseif me.DD_Sort_Value == 3 then
		table.sort(me.CardList_Filtered, function (c1, c2)
			if yaCIt.Owned[c1] == yaCIt.Owned[c2] then
				return yaCIt.CardList[c1].cName < yaCIt.CardList[c2].cName; 
			else
				return yaCIt.Owned[c1] > yaCIt.Owned[c2];
			end
		end)
		me.CardList_Sorted = me.CardList_Filtered;
	elseif me.DD_Sort_Value == 4 then
		table.sort(me.CardList_Filtered, function (c1, c2)
			local avg1;
			local avg2;
		  if AAH_SavedHistoryTable[tonumber(c1,16)] then
		  	avg1 = AAH_SavedHistoryTable[tonumber(c1,16)].avg;
		  else
		  	avg1 = nil;
			end
		  if AAH_SavedHistoryTable[tonumber(c2,16)] then
		  	avg2 = AAH_SavedHistoryTable[tonumber(c2,16)].avg;
		  else
		  	avg2 = nil;
			end
			if avg1 == avg2 then
				return yaCIt.CardList[c1].cName < yaCIt.CardList[c2].cName; 
			else
				if not avg1 then return false; end
				if not avg2 then return true; end
				return avg1 > avg2;
			end
		end)
		local idxValue = 1;
		local MinValue = me.Sort_Price_Sections[idxValue];
		local avg;
		for idx,strIDhex in ipairs(me.CardList_Filtered) do
			if not AAH_SavedHistoryTable[tonumber(strIDhex,16)] then
				if MinValue ~= 0 then 
					table.insert(me.CardList_Sorted, yaCIt.Locales.book.sort.sectnohist);
					MinValue = 0
				end
			else
				avg = AAH_SavedHistoryTable[tonumber(strIDhex,16)].avg;
				if avg < MinValue then
					while avg < me.Sort_Price_Sections[idxValue] do 
						idxValue = idxValue + 1; 
					end
					MinValue = me.Sort_Price_Sections[idxValue];
					table.insert(me.CardList_Sorted, yaCIt.Locales.book.sort.sectavglimit .. MinValue);
				end
			end
			table.insert(me.CardList_Sorted, strIDhex);
		end
	end
end

function me.DD_Sort_Click(button)
	if me.DD_Sort_Value ~= button.value then
		UIDropDownMenu_SetText(button.owner, button:GetText());
		me.DD_Sort_Value = button.value;
		me.DD_Sort_Sort();
		me.UpdateFrame();
	end
end

--[[ =================================================================
  Card context menu to select card related action (me.name .. "_DD_CardContext")
  Standard definition set: 
    menu entry table, open-, show- and click-event, create menu function
================================================================= --]]
function me.DD_ListContext_CreateMenu()
	local strIDhex = me.CardList_Sorted[me.ItemListSelected];
	local strucCard = yaCIt.CardList[strIDhex];

	me.DD_ListContext_Menu = {};
	local strLocales = yaCIt.Locales.book.context;
	table.insert(me.DD_ListContext_Menu, {text = strLocales.title, isTitle = 1, notCheckable = 1});
	table.insert(me.DD_ListContext_Menu, {value = -1, text = CARDBOOK_TAKEOUTCARD, notCheckable = 1, disabled = iif(yaCIt.Owned[strIDhex] == 1, nil, 1)});
	table.insert(me.DD_ListContext_Menu, {value = -2, text = strLocales.linkcard, notCheckable = 1});
	local zones = yaCIt.GetZonesFromName(strucCard.cName);
	for npcZone, npcID in pairs(zones) do
		if strucCard.Zones[npcZone] ~= -1 then
			table.insert(me.DD_ListContext_Menu, {value = npcID, text = strLocales.showmap .. GetZoneLocalName(npcZone), notCheckable = 1});
		end
	end
	table.insert(me.DD_ListContext_Menu, {value = -6, text = C_CANCEL, notCheckable = 1});
end

function me.DD_ListContext_OnLoad(this)
	UIDropDownMenu_Initialize(this, me.DD_ListContext_Show, "MENU");
end

function me.DD_ListContext_Show()
	me.DD_ListContext_CreateMenu();
	me.ShowMenu("DD_ListContext", me.DD_ListContext_Menu, -99);
end

function me.DD_ListContext_Click(button)
	local action = button.value;
	local strIDhex = me.CardList_Sorted[me.ItemListSelected];
	local strucCard = yaCIt.CardList[strIDhex];
	
	if action == -1 then
		LuaFunc_TakeOutCard(tonumber(strIDhex, 16));
	elseif action == -2 then			
		local strColor = yaCIt.RarityColors[strucCard.Rarity];		
		local item = yaCIt.CreateLink("item", strIDhex, strColor:format(yaCIt.GetCardLabel(strucCard, true)));
		if not ChatEdit_AddItemLink(item) and not DEFAULT_CHAT_EDITBOX:IsVisible() then
			DEFAULT_CHAT_FRAME:AddMessage(item)
		end
	elseif action > 0 then
		ShowUIPanel(NpcTrackFrame);
		NpcTrackFrame_InitializeNpcList(action);
		NpcTrackFrame:ResetFrameOrder();
	end
end

--[[ =================================================================
  OnClick event for filtered list counts 
  Stores the current filtered list in SaveVariables.lua where they
  can be extracted after the next save
================================================================= --]]
function me.FilterCountText_OnClick(this, key)
	if IsCtrlKeyDown() and not IsShiftKeyDown() then
		_G[me.name .. "_FilterList"] = {};
		for idx, strIDhex in ipairs(me.CardList_Sorted) do
			table.insert(_G[me.name .. "_FilterList"], yaCIt.CardList[strIDhex]);
		end
		SaveVariables(me.name .. "_FilterList");
		yaCIt.Print(yaCIt.Locales.debug.savedfilterlist);
	end
end

--[[ =================================================================
  EditBox to select/filter by part of cardname (me.name .. "_FilterBox")
  A '#' followed by a 6-digit number searches for the card with ID
  Standard definition set: 
    value variable, update-event and filter function
================================================================= --]]
function me.FilterBox_Update(this)
	me.FilterBox_Num = 0;
	me.FilterBox_Value = this:GetText():lower();
	if  me.FilterBox_Value:len() == 6 and tonumber(me.FilterBox_Value) then
		me.FilterBox_Num = tonumber(me.FilterBox_Value);		
	end
	if  me.FilterBox_Value:len() == 5 and  tonumber(me.FilterBox_Value, 16) then
		me.FilterBox_Num = tonumber(me.FilterBox_Value, 16);		
	end
	me.CreateFilteredList();
	me.UpdateFrame();
end

function me.FilterBox_Filter(strIDhex)
local strLookupID;
	if me.FilterBox_Value == "" or me.FilterBox_Num == -1 then return true; end
	if me.FilterBox_Num > 0 then strLookupID = yaCIt.dec2hex(me.FilterBox_Num); end
	return strLookupID == strIDhex or yaCIt.CardList[strIDhex].cName:lower():find(me.FilterBox_Value);
end

--[[ =================================================================
  When this checkbox is clicked, just recreate filtered list and show
  Status of the checkbox is used in 'CreateFilteredList' function
================================================================= --]]
function me.Chk_Invert_Click(this)
	me.CreateFilteredList();
	me.UpdateFrame();
end

--[[ =================================================================
  Set all filters to their default value (no filter)
  While reseting the FilterBox implies the recalculation this has 
  to be called if only dropdown menus are reset
================================================================= --]]
function me.ResetFilters()
	me.SetMenuValue("DD_Zone", -1);
	me.SetMenuValue("DD_Category", -1);
	me.SetMenuValue("DD_Bonus", -1);
	me.SetMenuValue("DD_FiltMisc", -1);
	me.SetMenuValue("DD_Sort", -1);
	getglobal(me.name .. "_Chk_Invert"):SetChecked(false);

	if me.FilterBox_Value == "" then
		me.CreateFilteredList();
		me.UpdateFrame();
	else
		getglobal(me.name .. "_FilterBox"):SetText("");
	end
end

--[[ =================================================================
  Creates the filtered cardlist (indexes only)
================================================================= --]]
function me.CreateFilteredList()
	local miscstate = false;
	me.CardList_Filtered = {}
	me.NumOwned_Filtered = 0;

	for strIDhex, strucCard in pairs(yaCIt.CardList) do
		miscstate = me.DD_FiltMisc_Filter(strIDhex);
		if getglobal(me.name .. "_Chk_Invert"):IsChecked() then miscstate = not miscstate; end
		if me.DD_Zone_Filter(strucCard) and me.DD_Category_Filter(strucCard) and
			me.DD_Bonus_Filter(strucCard) and me.FilterBox_Filter(strIDhex) and miscstate then

			table.insert(me.CardList_Filtered, strIDhex);
			if yaCIt.Owned[strIDhex] == 1 then
				me.NumOwned_Filtered = me.NumOwned_Filtered + 1;
			end
		end
	end
	me.DD_Sort_Sort();
end

--[[ =================================================================
  This functions fills the 'listbox' regarding current scrollbar value
================================================================= --]]
function me.FillListbox()
	for i = 1, me.FrameItemListSize do
		local ListItem = getglobal("CardBookFrameList" .. i);
		local ListItemHL = getglobal("CardBookFrameList" .. i .. "_Select");
		local ListItemText = getglobal("CardBookFrameList" .. i .. "Text");
		local strIDhex = me.CardList_Sorted[i + me.ScrollBar_Value];
		local strucCard = yaCIt.CardList[strIDhex];

		ListItemHL:Hide();
		if i <= #me.CardList_Sorted then
			ListItem:Show();
			if strucCard then
				local strColor = iif(yaCIt.Owned[strIDhex] == 1, yaCIt.RarityColors[strucCard.Rarity], me.ciGrey50);
				ListItemText:SetText("   " .. strColor:format(strucCard.cName));
			else
				ListItemText:SetText(yaCIt.Yellow:format(me.CardList_Sorted[i + me.ScrollBar_Value]));
			end
		else
			ListItem:Hide();
		end

		if i + me.ScrollBar_Value == me.ItemListSelected then
			ListItemHL:Show();
		end
	end
end

--[[ =================================================================
  Event function when the scrollbar is moved
  --> overloaded function <--
================================================================= --]]
--function me.ScrollBar_OnValueChanged(arg1)
function CardFarmeItemListReset()
	me.ScrollBar_Value = CardBookFrameScrollBar:GetValue();
	me.FillListbox();
end

--[[ =================================================================
  Event function when the mouse wheel is used over a list item
  Event moves the scrollbar only one tick regardless of the delta value
  --> hooked function <--
  ================================================================= --]]
me.ListItem_OnMouseWheel = OnMouseWheel_CardFarmeScorllItem;
function OnMouseWheel_CardFarmeScorllItem(this, delta)
	if not CardBookFrameScrollBar:IsVisible() then
		return;
	end

	me.ListItem_OnMouseWheel(this, delta);
end

--[[ =================================================================
  Event function when  a list item is clicked
  --> overloaded function <--
================================================================= --]]
--function me.ListItem_OnClick(this, id , key)
function OnClick_CardFarmeSelectItem(this, id, key)
	CloseDropDownMenus();
	for i = 1 , me.FrameItemListSize do
		getglobal("CardBookFrameList" .. i .. "_Select"):Hide();
	end

	me.ItemListSelected = id + me.ScrollBar_Value;
	getglobal(this:GetName() .. "_Select"):Show();
	me.ShowSelectedCard();

	if key == "RBUTTON" and me.CardList_Sorted[me.ItemListSelected]:len() == 5 then
		ToggleDropDownMenu(getglobal(me.name .. "_DD_ListContext"), 1, nil, this:GetName());
	end
end

--[[ =================================================================
  Event function click on summary button
  Shows cumulated stat bonuses in InfoOverlay
================================================================= --]]
function me.ToggleSummaryButton_OnClick(this)
	if getglobal(me.name .. "_InfoOverlay"):GetID() == 200 then
		getglobal(me.name .. "_InfoOverlay"):SetID(0); -- Fallback if details hidden
		me.ShowSelectedCard();
	else
		local data = {};
		local valuepattern = yaCIt.Green .. " / " .. yaCIt.Red;

		data.ID = 200;
		for statname, totals in pairs(yaCIt.StatBonuses) do
			table.insert(data, { Left = statname .. ":", Right = valuepattern:format(totals.Own, totals.Total) } );
		end
		data.title = yaCIt.Locales.book.statoverlay.title;
		me.ShowInfoOverlay(data);
	end
end

--[[ =================================================================
  Event function click on checkbox addit. info
  Status is handled in ShowSelectedCard
================================================================= --]]
function me.Chk_ShowDetails_Click(Object)
	me.ShowSelectedCard();
end

--[[ =================================================================
  Sets anything around the card display (right part of the frame)
  for the seleceted card
================================================================= --]]
function me.ShowSelectedCard()

	me.ShowInfoOverlay(nil);

	local strIDhex = me.CardList_Sorted[me.ItemListSelected];
	local strucCard = yaCIt.CardList[strIDhex];
	getglobal(me.name .. "_CardReward"):SetText(nil);
	if not strucCard then
		getglobal(me.name .. "_CardStatus"):SetText(nil);
		CardBookFrameCard:Hide();
		return; 
	end

	CardBookFrameCard2DImage:SetTexture("interface\\CardFrame\\CardBk" .. iif(yaCIt.Owned[strIDhex] == 1, strucCard.Resist, 0));
	CardBookFrameCardName:SetText(yaCIt.RarityColors[strucCard.Rarity]:format(strucCard.cName));
	CardBookFrameCardType:SetText(LuaFunc_GetString("SYS_RACE_" .. strucCard.RaceID));
	CardBookFrameCardRare:SetText(strucCard.Stat);
	getglobal(me.name .. "_MobLocation"):SetText(yaCIt.Locales.location .. yaCIt.GetZonesString(strucCard));

	local CardDescrScrollText = getglobal(me.name .. "_CardDescription");
	CardDescrScrollText:SetText(strucCard.Description);

	local CardDescrScrollbar = getglobal(me.name .. "_CardDescrScrollFrameScrollBar");
	CardDescrScrollbar:SetMinMaxValues(0, CardDescrScrollText:GetHeight());
	CardDescrScrollbar:SetValue(0);
	getglobal(me.name .. "_CardDescrScrollFrame"):UpdateScrollChildRect();

	LuaFunc_ShowCardImage(tonumber(strIDhex, 16));
	CommonModel_OnShow(CardBookFrameCardImage);

	getglobal(me.name .. "_CardStatus"):SetText(yaCIt.GetOwnedString(strIDhex, false));
	if strucCard.QuestReward then
		getglobal(me.name .. "_CardReward"):SetText(yaCIt.Yellow:format(yaCIt.Locales.reward));
	elseif strucCard.QuestMob then
		getglobal(me.name .. "_CardReward"):SetText(yaCIt.Yellow:format(yaCIt.Locales.questmob));
	elseif strucCard.NotObtainable then
		getglobal(me.name .. "_CardReward"):SetText(yaCIt.Yellow:format(yaCIt.Locales.notobtain));
	elseif strucCard.EventMob then
		getglobal(me.name .. "_CardReward"):SetText(yaCIt.Yellow:format(yaCIt.Locales.eventmob));
	elseif strucCard.DracoMob then
		getglobal(me.name .. "_CardReward"):SetText(yaCIt.Yellow:format(yaCIt.Locales.dracomob));
	elseif strucCard.RareMob then
		getglobal(me.name .. "_CardReward"):SetText(yaCIt.Yellow:format(yaCIt.Locales.raremob));
	elseif strucCard.RandomMob then
		getglobal(me.name .. "_CardReward"):SetText(yaCIt.Yellow:format(yaCIt.Locales.randommob));
	end
	CardBookFrameCard:Show();
	if getglobal(me.name .. "_Chk_ShowDetails"):IsChecked() then
		me.ShowSelectedCardDetails(strIDhex);
	end
end

--[[ =================================================================
  Creates the 'additional info' overlay and shows it
================================================================= --]]
function me.ShowSelectedCardDetails(strIDhex)
	local data = {};
	local strucCard = yaCIt.CardList[strIDhex];

	data.ID = 100;
	
	local locales = yaCIt.Locales.book.cardoverlay;
	local label = locales.altnamelabel;
	for cName, cards in pairs(yaCIt.NameLookup) do
		for _, IDhex in ipairs(cards) do
			if IDhex == strIDhex and cName ~= strucCard.cName then
				table.insert(data, { Left = label, Right = cName } );
				label = " ";
			end
		end
	end

	table.insert(data, { Left = "ID:", Right = strIDhex .. " / " .. tonumber(strIDhex,16) } );
	local strRare = LuaFunc_GetString("SYS_RARECOLOR_" .. strucCard.Rarity-2) .. " (" .. (strucCard.Rarity-2) .. ")";
	table.insert(data, { Left = locales.rarelabel, Right = strRare } );
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
		
	table.insert(data, { Left = locales.resistlabel, Right = nameOfRune } );

	if AAH_SavedHistoryTable then
		if AAH_SavedHistoryTable[tonumber(strIDhex,16)] then
			local AAH_Item = AAH_SavedHistoryTable[tonumber(strIDhex,16)];
			--table.insert(data, { Left = locales.aahlabel, Right = AAH_Item.min .. " / " .. AAH_Item.avg .. " / " .. AAH_Item.max } );
		end
	end

	label = locales.owners;
	for CharName, Data in pairs(yaCIt_Persistent[yaCIt.Realm]) do
		if CharName ~= yaCIt.Player and Data.Owned and Data.Owned[strIDhex] == 1 then
			table.insert(data, { Left = label, Right = CharName } );
			label = " ";
		end
	end
	
	data.title = locales.title;
	me.ShowInfoOverlay(data);
end

--[[ =================================================================
  Shows the overlay frame (hides the frame if data == nil)
================================================================= --]]
function me.ShowInfoOverlay(data)
	local frame = getglobal(me.name .. "_InfoOverlay");
	frame.constructing = true;
	frame:Hide();
	if type(data) == "table" then
		frame:SetText(data.title);

		for _, line in ipairs(data) do
			frame:AddDoubleLine(line.Left, yaCIt.Yellow:format(line.Right));
		end
		frame:SetID(data.ID);
		frame:ClearAllAnchors();
		frame:SetAnchor("TOPLEFT", "BOTTOMLEFT", yaCardBook_CardIDhex, (230-frame:GetWidth())/(GetUIScale()*2), 5);

		frame.LastHeight = frame:GetHeight();
		frame.LastWidth = frame:GetWidth();
	end
	frame.constructing = false;
end

--[[ =================================================================
  Manages anything around the listbox and status informations 
  if the content of the listbox changes
================================================================= --]]
function me.UpdateFrame()
	local strPerc = math.floor(yaCIt.NumOwned / yaCIt.NumCards * 10000) / 100 .. "%";
	local strTotal = yaCIt.Locales.book.titlestats:format(yaCIt.NumOwned, yaCIt.NumCards, strPerc);
	getglobal(me.name .. "_Title"):SetText(yaCIt.Logo .. " " .. SYSTEM_CARDBOOK .. strTotal);

	if me.FrameItemListSize >= #me.CardList_Sorted then
		me.ScrollBar_Value = 0;
		CardBookFrameScrollBar:Hide();
	else
		CardBookFrameScrollBar:Show();
		CardBookFrameScrollBar:SetMinMaxValues(0, #me.CardList_Sorted - me.FrameItemListSize);
		me.ScrollBar_Value = CardBookFrameScrollBar:GetValue();
	end
	me.ItemListSelected = 1;
	me.FillListbox();
	
	if #me.CardList_Filtered == yaCIt.NumCards then
		getglobal(me.name .. "_FilterCount"):Hide();
	else
		getglobal(me.name .. "_FilterCount"):Show();
		getglobal(me.name .. "_FilterCountText"):SetText(yaCIt.Locales.book.filtercountlabel .. me.NumOwned_Filtered .. "/" .. #me.CardList_Filtered);
	end
	me.ShowSelectedCard();
end

--[[ =================================================================
  Event function OnLoad; realigns reused object of the original
  CardBookFrame and hides the obsolete objects. New object are added
  with the XML file. Sets all language dependent labels
================================================================= --]]
function me.OnLoad(this)

	CardBookFrame:SetSize(628,540); -- Resize master frame
	CardTitleFrame:SetSize(582,28); -- resize drag area

	-- add new background; here to access the original background layer
	local CBFtexture = CreateUIComponent("Texture", me.name .. "_Texture", "CardBookFrame");
	CBFtexture:SetSize(1024, 1024);
	CBFtexture:SetTexture("Interface/AddOns/yaCIt/data/yaCardBookFrame");
    CBFtexture:ClearAllAnchors();
    CBFtexture:SetAnchor("TOPLEFT", "TOPLEFT", CardBookFrame, 0, 0);		
	CardBookFrame:SetLayers(1, CBFtexture);

	CardBookFrameText:Hide(); -- Hide old window title (already overlayed by new background)
	CardBookFrameTab1:Hide(); -- Hide very obsolete tab
	CardBookFrameType:Hide(); -- Hide race select dropdown; need new one
	CardBookFrameCountText:Hide(); -- Hide old filter counter
	CardBookFrameCardSP:Hide(); -- Hide old stat label
	CardBookFrameCardTip:Hide(); -- Hide old description box
	CardBookFrameCardNoteScrollFrame:Hide(); -- remove description scroll box; need new one

	for idx = 1, 18 do -- resize lines of the scroll list
		_G["CardBookFrameList" .. idx]:SetSize(268,16);
		_G["CardBookFrameList" .. idx .. "Text"]:SetSize(263,12);
		_G["CardBookFrameList" .. idx .. "Text"]:SetJustifyHType("LEFT");
		_G["CardBookFrameList" .. idx .. "Text"]:ClearAllAnchors();
		_G["CardBookFrameList" .. idx .. "Text"]:SetAnchor("LEFT","LEFT",_G["CardBookFrameList" .. idx],10,0);
	end

	CardBookFrameList1:ClearAllAnchors(); -- set new position of the scroll list
	CardBookFrameList1:SetAnchor("TOPLEFT","TOPLEFT",CardBookFrame,20,151);

	CardBookFrameScrollBar:ClearAllAnchors(); -- set new position of the scroll bar
	CardBookFrameScrollBar:SetAnchor("TOPLEFT","TOPRIGHT",CardBookFrameList1,0,19);
	CardBookFrameScrollBar:SetSize(16,250); -- and resize it
	
	CardBookFrameCard:ClearAllAnchors(); -- set new position of the card image area
	CardBookFrameCard:SetAnchor("TOPLEFT","TOPLEFT",CardBookFrame,320,84);

	local book = yaCIt.Locales.book;
	getglobal(me.name .. "_FilterBoxLabel"):SetText(book.filterboxlabel);
	getglobal(me.name .. "_Chk_Invert_Text"):SetText(book.chkinvertlabel);
	getglobal(me.name .. "_Chk_ShowDetails_Text"):SetText(book.chkshowdetailslabel);

	CardBookFrame:UnregisterEvent("CARDBOOKFRAME_UPDATE");
end

--[[ =================================================================
  Event function OnShow
  --> overloaded function <--
================================================================= --]]
--function me.OnShow(this)
function OnShow_CardFrame(this)
	if me.DD_Zone_Value == -3 then
		local zoneID = GetCurrentWorldMapID();
		local zoneName = GetZoneLocalName(zoneID);
		if zoneID == 400 then
			zoneName = TEXT("ZONE_DEFAULT");
		elseif not zoneName then
			zoneName = string.format("<%s>", TEXT("GUILD_TEXT_ZONE_UNKOWN"));
		end
		getglobal(me.name .. "_DD_ZoneText"):SetText(zoneName);
	end

	getglobal(me.name .. "_InfoOverlay"):SetID(0); -- fallback if stat sums were shown
	
	me.CreateFilteredList();
	me.UpdateFrame();
end

--[[ =================================================================
  Event function OnEvent
  Additional matches the zone DD label on LOADING_END event if 
  'current zone' is selected
  --> hooked function <--
================================================================= --]]
me.OnEvent = CardFrame_OnEvent;
function CardFrame_OnEvent(this, event)
	if event ~= "CARDBOOKFRAME_UPDATE" then
		me.OnEvent(this, event);
	end
end

_G[me.name] = me;
