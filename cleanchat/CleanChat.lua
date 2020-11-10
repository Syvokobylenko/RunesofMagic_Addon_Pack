-- Define default options and variables
local CleanChat = {
	Title			= "CleanChat",
	Version			= "1.0",
	Author			= "Rycerzodie",
	Loaded			= false,

	LocalesPath		= "Interface/AddOns/CleanChat/locales/",
	Locales			= {},
	
	PredefinedFilters = dofile( "Interface/Addons/CleanChat/db.lua" ),
	PredefinedFiltersSorted = dofile( "Interface/Addons/CleanChat/db.lua" ),
};
_G.CleanChat = CleanChat;

-- Include library allowing to filter chat
local Sol = LibStub( "Sol" );

function CleanChat_OnLoad()
	CleanChat.LoadChannels();

	-- Register events
	CleanChat_Frame:RegisterEvent( "VARIABLES_LOADED" );
	for chatChannel, _ in ipairs( CleanChat.ChatTypes ) do
		CleanChat_Frame:RegisterEvent( "CHAT_MSG_".. chatChannel );
	end

	CleanChat_Frame:RegisterEvent( "CHAT_MSG_CHANNEL_CREATE" );
	CleanChat_Frame:RegisterEvent( "CHAT_MSG_CHANNEL_JOIN" );
	CleanChat_Frame:RegisterEvent( "CHAT_MSG_CHANNEL_LEAVE" );

	-- Add slash command
	SLASH_CleanChat_SlashHandler1 = "/CleanChat";
	SLASH_CleanChat_SlashHandler1 = "/cleanchat";
	SlashCmdList["CleanChat_SlashHandler"] = function( editBox, msg )
		--[[if ( string.lower( msg ) ) == "config" then
			CleanChat.ToggleFrame( "Config" );
		elseif ( string.lower( msg ) ) == "filters" then]]--
			CleanChat.ToggleFrame( "Filters" );
		--end
	end

	-- Load client's locale
	local locale = string.lower( string.sub( GetLanguage(), 1, 2 ) );
	local func, err = loadfile( CleanChat.LocalesPath .. locale .. ".lua" );
	if ( err ) then
		locale = "en";
	end

	CleanChat.Locales = dofile( CleanChat.LocalesPath .. locale .. ".lua" );
end

function CleanChat_OnEvent( event )
	if ( event == "VARIABLES_LOADED" ) then
		-- Define addon's settings
		if ( not CleanChat_Settings ) then
			CleanChat_Settings = {
				Version				= CleanChat.Version,
				Filters				= {},
				CurrentFilter		= 1,
			}
			CleanChat.NewFilter();
		end

		--[[if ( CleanChat_Settings.Version ~= CleanChat.Version ) then
			CleanChat_Settings.Version = CleanChat.Version;
		end]]

		CleanChat.CheckPredefinedFilters( nil, CleanChat.PredefinedFilters );
		CleanChat.KeywordPredefinedFilters( CleanChat.PredefinedFilters );
		CleanChat.KeywordPredefinedFilters( CleanChat.PredefinedFiltersSorted );
		CleanChat.SortPredefinedFilters();

		-- Save settings
		SaveVariables( "CleanChat_Settings" );

		-- Addon is loaded
		CleanChat.LoadUI();
		CleanChat.Loaded = true;

		-- Add addon to AddonManager if exists
		if ( AddonManager ) then
			local addon = {
				name = CleanChat.Title,
				description = CleanChat.Locales.Description,
				category = "Interface",
				configFrame = CleanChat_FiltersFrame,
				slashCommands = SLASH_CleanChat_SlashHandler1,
				version = CleanChat.Version,
				author = CleanChat.Author,
				icon = "Interface/Addons/CleanChat/graphics/icon.tga",
				mini_icon = "Interface/Addons/CleanChat/graphics/icon.tga",
				mini_icon_pushed = "Interface/Addons/CleanChat/graphics/icon.tga",
			}

			if ( AddonManager.RegisterAddonTable ) then
				AddonManager.RegisterAddonTable( addon );
			else
				AddonManager.RegisterAddon( addon.name, addon.description, addon.icon, addon.category, addon.configFrame, addon.slashCommands, addon.miniButton, addon.onClickScript );
			end
		else
			CleanChat.Msg( string.gsub( string.gsub( CleanChat.Locales.AddonLoaded, "<ADDON>", CleanChat.Title .." ".. CleanChat.Version ), "<COMMAND>", SLASH_CleanChat_SlashHandler1 ), 0.5, 0.7, 0.1 );
		end;

		-- Allow addon to filter chat
		Sol.hooks.Hook( "CleanChat", "ChatFrame_OnEvent", CleanChat.ChatFrame_OnEvent );

		return;
	end
end

function CleanChat.LoadChannels()
	CleanChat.ChatTypeGroups = {};
	CleanChat.ChatTypes = {};
	
	local i = 1;
	for index, _ in pairs( ChatTypeGroup ) do
		CleanChat.ChatTypeGroups[i] = index;
		i = i + 1;
	end

	i = 1;
	for index = 1, CleanChat.TableLength( CleanChat.ChatTypeGroups ) do
		local messageGroup = ChatTypeGroup[CleanChat.ChatTypeGroups[index]];
		for _, value in pairs( messageGroup ) do
			CleanChat.ChatTypes[i] = value;
			i = i + 1;
		end
	end

	local namedChatTypeGroups = {};
	for index, value in pairs( CleanChat.ChatTypeGroups ) do
		namedChatTypeGroups[value] = TEXT( "MESSAGE_".. value );
	end
	CleanChat.ChatTypeGroups = namedChatTypeGroups;

	local channelList = { GetChannelList() };
	if ( CleanChat.TableLength( channelList ) > 0 ) then
		CleanChat.ChatTypeGroups["CHANNEL"] = {};
		i = 0;
		for index, value in ipairs( channelList ) do
			i = i + 1;
			if ( not ( i % 2 == 0 ) ) then
				CleanChat.ChatTypeGroups["CHANNEL"][value] = channelList[index + 1];
			end
		end
	end
end

function CleanChat.LoadUI()
	CleanChat.PredefinedFilters.Others.Header = CleanChat.Locales.FiltersOthers;
	CleanChat.PredefinedFiltersSorted.Others.Header = CleanChat.Locales.FiltersOthers;

	-- Initialize dropdowns
	UIDropDownMenu_Initialize( CleanChat_FiltersFrame_Dropdown, CleanChat.FiltersDropdown );
	UIDropDownMenu_Initialize( CleanChat_FiltersFrame_ChatDropdown, CleanChat.ChatDropdown );
	
	local currentChat = CleanChat.GetFilterField( nil, "ChatTypeGroup", CleanChat_Settings.CurrentFilter );
	UIDropDownMenu_SetText( CleanChat_FiltersFrame_ChatDropdown, ( currentChat == "CHANNEL" and TEXT( "USER_DEFINE_CHANNNEL" ) or CleanChat.ChatTypeGroups[currentChat] ) );

	CleanChat_FiltersFrame_Title:SetText( CleanChat.Title ..": ".. CleanChat.Locales.FiltersFrame );
	CleanChat_FiltersFrame_ActiveLabel:SetText( CleanChat.Locales.Active );

	CleanChat.SetCurrentFilter();
end

function CleanChat.ChatFrame_ChatTypeEvent( event, chatTypes )
	for _, chatType in ipairs( chatTypes ) do
		if ( chatType == event ) then
			return true;
		end
	end

	return false;
end

function CleanChat.ChatFrame_OnEvent( this, event )
	local _event = event;
	local _arg1  = arg1;
	local _arg2  = arg2;
	local _arg3  = arg3;
	local _arg4  = arg4;

	if ( CleanChat.Loaded and ( event == "CHAT_MSG_CHANNEL_CREATE" or event == "CHAT_MSG_CHANNEL_JOIN" or event == "CHAT_MSG_CHANNEL_LEAVE" ) ) then
		CleanChat.LoadChannels();
	end
		

	if ( CleanChat.Loaded and CleanChat.ChatFrame_ChatTypeEvent( event, CleanChat.ChatTypes ) and type( arg1 ) == "string" ) then
		for i = 1, CleanChat.TableLength( CleanChat_Settings.Filters ) do
			local chatTypeGroup = CleanChat.GetFilterField( nil, "ChatTypeGroup", i );
			if (
				CleanChat.GetFilterField( nil, "Active", i ) == true
				and ( ( type( chatTypeGroup ) == "string" and CleanChat.ChatFrame_ChatTypeEvent( event, ChatTypeGroup[chatTypeGroup] ) )
					or ( type( chatTypeGroup ) == "number" and CleanChat.ChatFrame_ChatTypeEvent( event, ChatTypeGroup["CHANNEL"] ) and arg3 == chatTypeGroup ) )
			) then
				local filterText = CleanChat.GetFilterField( nil, "Text", i );
				if ( filterText ~= nil and filterText ~= "" and string.find( arg1, string.gsub( filterText, "*", ".-" ) ) ~= nil ) then
					return;
				end
			end
		end
	end
  
	-- Reset to stored eventvalues and continue with original eventhandler
	event = _event;
	arg1  = _arg1;
	arg2  = _arg2;
	arg3  = _arg3;
	arg4  = _arg4;
	Sol.hooks.GetOriginalFn( "CleanChat", "ChatFrame_OnEvent" )( this, event );
end

function CleanChat.GetFilterField( id, field, setting_id )
	if ( CleanChat.TableLength( CleanChat_Settings.Filters ) > 0 ) then
		local mainTable = CleanChat_Settings.Filters;

		if ( id == nil and setting_id ~= nil and CleanChat_Settings.Filters[setting_id].ID ~= nil ) then
			id = CleanChat_Settings.Filters[setting_id].ID;
		elseif ( setting_id ~= nil ) then
			local output = CleanChat_Settings.Filters[setting_id][field];
			return output;
		end

		if ( id == nil ) then return nil; end

		if ( field == "Active" or field == "ID" ) then
			local index = CleanChat.PredefinedFilterIndex( id );
			if ( index ~= nil and CleanChat_Settings.Filters[index][field] ~= nil ) then
				return CleanChat_Settings.Filters[index][field];
			else
				return false;
			end
		else
			local readID = CleanChat.Explode( id, "." );
			if ( CleanChat.TableLength( readID ) == 2 ) then
				local output = CleanChat.PredefinedFilters[ readID[1] ][ tonumber( readID[2] ) ][field];
				return output;
			elseif ( CleanChat.TableLength( readID ) == 3 ) then
				--SendSystemChat( ( id or "id" ) .." / ".. ( field or "field" ) .." / ".. ( readID[1] or "readID1" ) .." / ".. ( readID[2] or "readID2" ) .." / ".. ( readID[3] or "readID3" ) );
				local output = CleanChat.PredefinedFilters[ readID[1] ][ readID[2] ][ tonumber( readID[3] ) ][field];
				return output;
			end
		end
	end

	return nil;
end

function CleanChat.FilterName( setting_id, id )
	local name = CleanChat.GetFilterField( id, "Text", setting_id );
	if ( name ~= nil and name ~= "" and string.len( name ) > 0 ) then
		return string.sub( name, 0, 50 );
	else
		return "|cffc0c0c0---|r";
	end
end

function CleanChat.NewFilter()
	table.insert( CleanChat_Settings.Filters, { ["Active"] = true, ["ChatTypeGroup"] = "SYSTEM", ["Text"] = "" } );
	CleanChat.SetCurrentFilter();
end

function CleanChat.RemoveFilter()
	if ( CleanChat.GetFilterField( nil, "ID", CleanChat_Settings.CurrentFilter ) == nil ) then
		table.remove( CleanChat_Settings.Filters, CleanChat_Settings.CurrentFilter );

		if ( not CleanChat.CheckCustomFilters() ) then
			CleanChat.NewFilter();
		end
		CleanChat.SetCurrentFilter();
	end
end

function CleanChat.SetCurrentFilter( id, predefined )
	if ( id == nil and CleanChat_Settings.CurrentFilter == nil ) then
		if ( CleanChat.Loaded ) then
			CleanChat_Settings.CurrentFilter = table.maxn( CleanChat_Settings.Filters );
		else
			CleanChat_Settings.CurrentFilter = 1;
		end
	else
		if ( predefined ~= nil and predefined == true ) then
			CleanChat_Settings.CurrentFilter = CleanChat.PredefinedFilterIndex( id );
		else	
			CleanChat_Settings.CurrentFilter = id;
		end;
	end
	
	if ( CleanChat.GetFilterField( nil, "ID", CleanChat_Settings.CurrentFilter ) ~= nil ) then
		_G["CleanChat_FiltersFrame_ChatDropdown"]:Disable();
		_G["CleanChat_FiltersFrame_Text"]:Disable();
		_G["CleanChat_FiltersFrame_Remove"]:Disable();
	else
		_G["CleanChat_FiltersFrame_ChatDropdown"]:Enable();
		_G["CleanChat_FiltersFrame_Text"]:Enable();
		_G["CleanChat_FiltersFrame_Remove"]:Enable();
	end
	
	UIDropDownMenu_SetText( CleanChat_FiltersFrame_Dropdown, CleanChat.FilterName( CleanChat_Settings.CurrentFilter ) );
	local currentChat = CleanChat.GetFilterField( nil, "ChatTypeGroup", CleanChat_Settings.CurrentFilter );
	UIDropDownMenu_SetText( CleanChat_FiltersFrame_ChatDropdown, ( currentChat == "CHANNEL" and TEXT( "USER_DEFINE_CHANNNEL" ) or CleanChat.ChatTypeGroups[currentChat] ) );
	
	CleanChat_FiltersFrame_Active:SetChecked( CleanChat.GetFilterField( nil, "Active", CleanChat_Settings.CurrentFilter ) );
	CleanChat_FiltersFrame_Text:SetText( CleanChat.GetFilterField( nil, "Text", CleanChat_Settings.CurrentFilter ) );
end

function CleanChat.PredefinedFilterIndex( id )
	if ( CleanChat.TableLength( CleanChat_Settings.Filters ) > 0 ) then
		for index, data in pairs( CleanChat_Settings.Filters ) do
			if ( data.ID ~= nil and data.ID == id ) then
				return index;
			end
		end
	end

	return nil;
end

function CleanChat.CheckCustomFilters( countTwo )
	local count = 0;

	if ( CleanChat.TableLength( CleanChat_Settings.Filters ) > 0 ) then
		for index, data in pairs( CleanChat_Settings.Filters ) do
			if ( data.ID == nil and countTwo == true and count ) then
				count = count + 1;
				
				if ( count == 2 ) then
					return true;
				end
			elseif ( data.ID == nil ) then
				return true;
			end
		end
	end

	return false;
end

function CleanChat.CheckPredefinedFilters( currentID, loop, action, active )
	if ( CleanChat.TableLength( loop ) > 0 ) then
		local id = "";
		local filterIndex = nil;

		for index, data in pairs( loop ) do
			if ( type( index ) == "number" ) then
				id = ( currentID ~= nil and currentID .."." or "" ) .. index;
				filterIndex = CleanChat.PredefinedFilterIndex( id );

				if ( filterIndex == nil ) then
					table.insert( CleanChat_Settings.Filters, { ["Active"] = false, ["ID"] = id } );
				elseif ( action == "isActive" and CleanChat.GetFilterField( nil, "Active", filterIndex ) == false ) then
					return nil;
				elseif ( action == "massActive" and active ~= nil ) then
					CleanChat_Settings.Filters[filterIndex]["Active"] = active;
				end
			elseif ( type( data ) == "table" ) then
				for index2, data2 in pairs( data ) do
					if ( type( index2 ) == "number" ) then
						id = ( currentID ~= nil and currentID .."." or "" ) .. index ..".".. index2;
						filterIndex = CleanChat.PredefinedFilterIndex( id );

						if ( filterIndex == nil ) then
							table.insert( CleanChat_Settings.Filters, { ["Active"] = false, ["ID"] = id } );
						elseif ( action == "isActive" and CleanChat.GetFilterField( nil, "Active", filterIndex ) == false ) then
							return nil;
						elseif ( action == "massActive" and active ~= nil ) then
							CleanChat_Settings.Filters[filterIndex]["Active"] = active;
						end
					elseif ( type( data2 ) == "table" ) then
						for index3, data3 in pairs( data2 ) do
							if ( type( index3 ) == "number" ) then
								id = ( currentID ~= nil and currentID .."." or "" ) .. index ..".".. index2 ..".".. index3;
								filterIndex = CleanChat.PredefinedFilterIndex( id );

								if ( filterIndex == nil ) then
									table.insert( CleanChat_Settings.Filters, { ["Active"] = false, ["ID"] = id } );
								elseif ( action == "isActive" and CleanChat.GetFilterField( nil, "Active", filterIndex ) == false ) then
									return nil;
								elseif ( action == "massActive" and active ~= nil ) then
									CleanChat_Settings.Filters[filterIndex]["Active"] = active;
								end
							end
						end
					end
				end
			end
		end

		if ( action == "isActive" ) then
			return 1;
		end
	end

	return false;
end

function CleanChat.KeywordPredefinedFilters( loop )
	for index, data in pairs( loop ) do
		if ( type( index ) == "number" ) then
			data.Text = GetReplaceSystemKeyword( data.Text );
		elseif ( type( data ) == "table" ) then
			CleanChat.KeywordPredefinedFilters( data );
		end
	end
end

function CleanChat.SortPredefinedFilters( loop )
	loop = ( loop ~= nil and loop or CleanChat.PredefinedFiltersSorted );

	for index, data in pairs( loop ) do
		if ( type( index ) == "number" ) then
			data.Index = index;
		elseif ( type( data ) == "table" ) then
			CleanChat.SortPredefinedFilters( data );
		end
	end

	table.sort( loop, function( a, b )
		if ( type( a ) == "table" and type( b ) == "table" and a.Header ~= nil and b.Header ~= nil ) then
			return a.Header < b.Header;
		elseif ( type( a ) == "table" and type( b ) == "table" and a.Text ~= nil and b.Text ~= nil ) then
			return a.Text < b.Text;
		else
			return false;
		end
	end );
end

function CleanChat.SortPredefinedFiltersCategories( tbl, sortFunction )
	local keys = {};

	for key in pairs( tbl ) do
		if ( key ~= "ChatTypeGroup" and key ~= "Header" ) then
			table.insert( keys, key );
		end
	end

	table.sort( keys, function( a, b )
		return sortFunction( tbl[a], tbl[b] );
	end );

	return keys;
end

function CleanChat.FiltersDropdown_PredefinedItem( loop, menulevel, parent )
	local loopClone = CleanChat.TableClone( loop );
	local sortKeys = CleanChat.SortPredefinedFiltersCategories( loopClone, function( a, b )
		if ( type( a ) == "table" and type( b ) == "table" and a.Header ~= nil and b.Header ~= nil ) then
			return a.Header < b.Header;
		else
			return false;
		end
	end );
	local id = 0;

	for iOrg, dataOrg in pairs( loopClone ) do
		if ( type( iOrg ) == "number" or dataOrg.Header ~= nil ) then
			id = id + 1;
			dataOrg.id = id;

			local data = {};
			local menuitem = {};

			if ( type( iOrg ) == "number" ) then
				local i = dataOrg.id;
				data = loopClone[i];

				local predefinedID = ( parent ~= nil and parent ..".".. data.Index or data.Index );

				if ( CleanChat.GetFilterField( predefinedID, "Active" ) ) then
					menuitem.checked = 1;
				else
					menuitem.checked = nil;
				end

				menuitem.func = function()
					CleanChat.SetCurrentFilter( predefinedID, true );
					CloseDropDownMenus();
				end;

				menuitem.text = CleanChat.FilterName( nil, predefinedID );
			else
				local i = sortKeys[dataOrg.id];
				data = loopClone[i];

				local predefinedID = ( parent ~= nil and parent ..".".. i or i );
				menuitem.hasArrow = 1;
				menuitem.value = predefinedID;
				menuitem.text = data.Header;

				local isActive = CleanChat.CheckPredefinedFilters( predefinedID, data, "isActive" );
				menuitem.checked = isActive;

				menuitem.func = function()
					CleanChat.CheckPredefinedFilters( predefinedID, data, "massActive", not isActive );
					CloseDropDownMenus();
				end;
			end

			local index = data["ChatTypeGroup"];
			if ( type( index ) == "number" ) then
				index = "CHANNEL".. index;
			end

			if ( data["ChatTypeColor"] ~= nil ) then
				menuitem.textR = data["ChatTypeColor"].r;
				menuitem.textG = data["ChatTypeColor"].g;
				menuitem.textB = data["ChatTypeColor"].b;
			elseif ( ChatTypeInfo[index] ~= nil ) then
				menuitem.textR = ChatTypeInfo[index].r;
				menuitem.textG = ChatTypeInfo[index].g;
				menuitem.textB = ChatTypeInfo[index].b;
			else
				menuitem.textR = nil;
				menuitem.textG = nil;
				menuitem.textB = nil;
			end

			UIDropDownMenu_AddButton( menuitem, menulevel );
		end
	end
end

function CleanChat.FiltersDropdown()
	if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
		local menuitem = {};

		if ( CleanChat.PredefinedFiltersSorted ~= nil and CleanChat.TableLength( CleanChat.PredefinedFiltersSorted ) > 0 ) then
			menuitem.text = CleanChat.Locales.FiltersPredefined;
			menuitem.isTitle = 1;
			menuitem.notCheckable = 1;
			UIDropDownMenu_AddButton( menuitem );


			CleanChat.FiltersDropdown_PredefinedItem( CleanChat.PredefinedFiltersSorted, 1 );

			menuitem = {};
		end

		if ( CleanChat.TableLength( CleanChat_Settings.Filters ) > 0 ) then
			menuitem.text = CleanChat.Locales.FiltersCustom;
			menuitem.isTitle = 1;
			menuitem.notCheckable = 1;
			UIDropDownMenu_AddButton( menuitem );

			menuitem = {};

			for i = 1, CleanChat.TableLength( CleanChat_Settings.Filters ) do
				if ( CleanChat_Settings.Filters[i]["ID"] == nil ) then
					if ( CleanChat_Settings.Filters[i]["Active"] ) then
						menuitem.checked = 1;
					else
						menuitem.checked = nil;
					end

					menuitem.func = function() CleanChat.SetCurrentFilter( i ); end;
					menuitem.text = CleanChat.FilterName( i );

					local index = CleanChat_Settings.Filters[i]["ChatTypeGroup"];
					if ( type( index ) == "number" ) then
						index = "CHANNEL".. index;
					end

					if ( ChatTypeInfo[index] ~= nil ) then
						menuitem.textR = ChatTypeInfo[index].r;
						menuitem.textG = ChatTypeInfo[index].g;
						menuitem.textB = ChatTypeInfo[index].b;
					else
						menuitem.textR = nil;
						menuitem.textG = nil;
						menuitem.textB = nil;
					end

					UIDropDownMenu_AddButton( menuitem );
				end
			end
		end
	elseif ( UIDROPDOWNMENU_MENU_LEVEL < 4 ) then
		if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
			local loop = CleanChat.PredefinedFiltersSorted[ UIDROPDOWNMENU_MENU_VALUE ];
			CleanChat.FiltersDropdown_PredefinedItem( loop, UIDROPDOWNMENU_MENU_LEVEL, UIDROPDOWNMENU_MENU_VALUE );
		else
			local parent = string.sub( UIDROPDOWNMENU_MENU_VALUE, 1, ( string.find( UIDROPDOWNMENU_MENU_VALUE, "%." ) - 1 ) );
			local value = string.sub( UIDROPDOWNMENU_MENU_VALUE, ( string.find( UIDROPDOWNMENU_MENU_VALUE, "%." ) + 1 ) );
			local loop = CleanChat.PredefinedFiltersSorted[parent][value];
			CleanChat.FiltersDropdown_PredefinedItem( loop, UIDROPDOWNMENU_MENU_LEVEL, UIDROPDOWNMENU_MENU_VALUE );
		end
	end
end

function CleanChat.ChatDropdown()
	local menuitem = {};
	local isPredefined = ( CleanChat.GetFilterField( nil, "ID", CleanChat_Settings.CurrentFilter ) ~= nil );
	
	if ( isPredefined ) then
		menuitem.disabled = 1;
	end

	if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
		for index, value in pairs( CleanChat.ChatTypeGroups ) do
			if ( CleanChat.GetFilterField( nil, "ChatTypeGroup", CleanChat_Settings.CurrentFilter ) == index ) then
				menuitem.checked = 1;
			else
				menuitem.checked = nil;
			end

			if ( not isPredefined ) then
				menuitem.func = function()
					CleanChat_Settings.Filters[CleanChat_Settings.CurrentFilter]["ChatTypeGroup"] = index;
					UIDropDownMenu_SetText( CleanChat_FiltersFrame_ChatDropdown, ( index == "CHANNEL" and TEXT( "USER_DEFINE_CHANNNEL" ) or value ) );
				end
			end

			menuitem.hasArrow = nil;
			if ( index == "CHANNEL" ) then
				menuitem.text = TEXT( "USER_DEFINE_CHANNNEL" );
				if ( type( value ) == "table" ) then
					menuitem.hasArrow = 1;
				end
			else
				menuitem.text = value;
			end

			if ( ChatTypeInfo[index] ~= nil ) then
				menuitem.textR = ChatTypeInfo[index].r;
				menuitem.textG = ChatTypeInfo[index].g;
				menuitem.textB = ChatTypeInfo[index].b;
			else
				menuitem.textR = nil;
				menuitem.textG = nil;
				menuitem.textB = nil;
			end

			UIDropDownMenu_AddButton( menuitem );
		end
	else
		for index, value in pairs( CleanChat.ChatTypeGroups["CHANNEL"] ) do
			if ( CleanChat.GetFilterField( nil, "ChatTypeGroup", CleanChat_Settings.CurrentFilter ) == index ) then
				menuitem.checked = 1;
			else
				menuitem.checked = nil;
			end

			if ( not isPredefined ) then
				menuitem.func = function()
					CleanChat_Settings.Filters[CleanChat_Settings.CurrentFilter]["ChatTypeGroup"] = index;
					UIDropDownMenu_SetText( CleanChat_FiltersFrame_ChatDropdown, value );
					ToggleDropDownMenu( CleanChat_FiltersFrame_ChatDropdown, 1 );
				end
			end

			menuitem.text = value;

			if ( ChatTypeInfo["CHANNEL".. index] ~= nil ) then
				menuitem.textR = ChatTypeInfo["CHANNEL".. index].r;
				menuitem.textG = ChatTypeInfo["CHANNEL".. index].g;
				menuitem.textB = ChatTypeInfo["CHANNEL".. index].b;
			else
				menuitem.textR = nil;
				menuitem.textG = nil;
				menuitem.textB = nil;
			end

			UIDropDownMenu_AddButton( menuitem, UIDROPDOWNMENU_MENU_LEVEL );
		end
	end
end

function CleanChat.ToggleFrame( frame, state )
	state = state or nil;

	if ( state == true ) then
		_G["CleanChat_".. frame .."Frame"]:Show();
	elseif ( state == false ) then
		_G["CleanChat_".. frame .."Frame"]:Hide();
	else
		ToggleUIFrame( _G["CleanChat_".. frame .."Frame"] );
	end
end

function CleanChat.Msg( msg, red, green, blue )
	if ( red and green and blue ) then
		DEFAULT_CHAT_FRAME:AddMessage( msg, red, green, blue );
	else
		DEFAULT_CHAT_FRAME:AddMessage( msg );
	end
end

function CleanChat.TableLength( T )
	local count = 0;
	for _ in pairs( T ) do
		count = count + 1;
	end
	return count;
end

-- http://lua-users.org/wiki/SplitJoin
function CleanChat.Explode( p, d )
	local t = {};
	local ll = 0;

	if ( #p == 1 ) then
		return {p}
	end

	while true do
		l = string.find( p, d, ll, true ) -- find the next d in the string
		if l ~= nil then -- if "not not" found then..
			table.insert( t, string.sub( p, ll, l - 1 ) ); -- Save it in our array.
			ll = l + 1; -- save just after where we found it for searching next time.
		else
			table.insert( t, string.sub( p, ll ) ); -- Save what's left in our array.
			break;
		end
	end

	return t;
end

function CleanChat.TableClone( orig )
    local orig_type = type( orig );
    local copy;
    if orig_type == 'table' then
        copy = {};
        for orig_key, orig_value in next, orig, nil do
            copy[ CleanChat.TableClone( orig_key ) ] = CleanChat.TableClone( orig_value );
        end
        setmetatable( copy, CleanChat.TableClone( getmetatable( orig ) ) );
    else -- number, string, boolean, etc
        copy = orig;
    end

    return copy;
end