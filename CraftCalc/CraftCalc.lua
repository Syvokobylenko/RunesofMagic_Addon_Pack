g_CraftCalcTable = {};			-- Save Craft Skill info each time it changes
local g_CraftCalcStatus = {};
local PLUGIN_TITLE = "CraftCalc v0.2 (by The Gooch)"
local TABLE_DATA_FILENAME = "CraftCalc.ini"

function Log(msg)
	if (DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end


function CraftCalc_LoadTable()

	--Log("CraftCalc_LoadTable - loading " .. TABLE_DATA_FILENAME);

	--local IniName=GC_GetGlobalPath(TABLE_DATA_FILENAME);
	--local tableIni=table.load(IniName);
	--table.copy(g_CraftCalcTable,tableIni);	
	--Log("Loaded " .. TABLE_DATA_FILENAME );
end


function CraftCalc_SaveTable()

	--Log("CraftCalc_SaveTable - saving " .. TABLE_DATA_FILENAME);
	
	SaveVariables( "g_CraftCalcTable" );
	--local IniName=GC_GetGlobalPath(TABLE_DATA_FILENAME);
	--table.save(g_CraftCalcTable,IniName);
	--Log("Saved " .. TABLE_DATA_FILENAME );
end


function IsCraftCalcInitialized()
	
	if ( g_CraftCalcStatus.Initialized == true ) then
		return true;
	end

	return false;
end


function SetCraftCalcInitialized()

	g_CraftCalcStatus.Initialized = true;
	--Log( "g_CraftCalcTable Initialized." );
end


function Initialize_CraftCalc()
	--Log("g_CraftCalcTable initializing...");

	-- Bail if we're already initialized
	if ( IsCraftCalcInitialized() == true ) then
		return;
	end

	-- Try to get the current player name.  If we can then we consider ourselves initialized
	local PlayerName = UnitName("player");

	if ( not PlayerName or PlayerName == "" ) then
		return;
	end
	
	--Log ("Got player name: " .. PlayerName );
	
	local Realm = GetCurrentRealm();
	
	if ( not Realm or Realm == "" ) then 
		return;
	end

	--Log ("Got realm name: " .. Realm );

	-- Initilaize our global data object if it isn't already
	if ( not g_CraftCalcTable[Realm] ) then 
		g_CraftCalcTable[Realm] = {}; 
	end
	
	if ( not g_CraftCalcTable[Realm][PlayerName] ) then 
		g_CraftCalcTable[Realm][PlayerName] = {}; 
	end
		
	if ( not g_CraftCalcTable[Realm][PlayerName].Previous ) then 
		g_CraftCalcTable[Realm][PlayerName].Previous = {}; 
	end

	if ( not g_CraftCalcTable[Realm][PlayerName].Current ) then 
		g_CraftCalcTable[Realm][PlayerName].Current = {}; 
	end


	-- Set flag saying we're initialized so following functions don't bail out
	SetCraftCalcInitialized();

	
	-- Initialize the table ( 1  means This is the first run)
	CraftCalc_SetTable( 1 );


	-- Save the latest table
	CraftCalc_SaveTable();

end


function CraftCalc_SetTable( bFirstRun )

	--Log( "CraftCalc_SetTable bFirstRun:" .. bFirstRun );

	if ( false == IsCraftCalcInitialized() ) then
		Log("Error: CraftCalc not initialized yet.");
		return;
	end
	
	-- Get Player Name and Relam so we know where to save this guys info in the table
	local PlayerName = UnitName("player");
	local Realm = GetCurrentRealm();

	
	-- Cycle through all the Crafting (Production & Gathering) status frames of the Character Crafting UI
	for i = 1 , CCFrame.ItemCount do
		
		-- Build names of the status bars so we can retrive info from them
		local StatusBar = CCFrame.Items[i];
		local SkillTitleText = getglobal( StatusBar:GetName() .. "ExplainTitle" ) ;
		local SkillValueText = getglobal( StatusBar:GetName() .. "ExplainValue" ) ;
		local SkillLevelText = getglobal( StatusBar:GetName() .. "ExplainLevel" ) ;
		
		-- Get info from the status bars
		local SkillLevelCur = GetPlayerCurrentSkillValue( StatusBar.ItemData.ID );
		local SkillLevelMax = GetPlayerMaxSkillValue( StatusBar.ItemData.ID );
		local SkillRank = CCFrame_GetLifeSkillRankString( SkillLevelMax );

		--Log( "[CraftCalc] Rank:" .. SkillRank .. " CurSkillVal/MaxSkillVal: " .. SkillLevelCur .. "/" .. SkillLevelMax );
		
		-- Round down do chop off all the decimal values from our skill level
		local SkillLevelCurFloored =  math.floor( SkillLevelCur );
		
		-- Get a Percent value for our crafting skill level
		local exp = ( SkillLevelCur - SkillLevelCurFloored ) * 100 ;

		--Never hit 100%
		if( exp > 99.99 )then
			exp = 99.99;
		end

		local strTitle = StatusBar.ItemData.Name .. SkillRank;
		local SkillLevelPercent = string.format( "%.2f" , exp ) ;		
		
		local tempObj = {};
		tempObj.Index = i;
		tempObj.SkillName = StatusBar.ItemData.Name;
		tempObj.SkillRank = SkillRank;
		tempObj.SkillLevelCur = SkillLevelCur;
		tempObj.SkillLevelCurFloored = SkillLevelCurFloored;
		tempObj.SkillLevelMax = SkillLevelMax;
		tempObj.SkillLevelPercent = SkillLevelPercent;
		
		--Log( "[CraftCalc] " .. tempObj.SkillName .. " (" .. SkillRank .. ")\n[Level:" .. SkillLevelCur .. "] (" .. SkillLevelCurFloored .. "/" .. SkillLevelMax .. ") (" .. SkillLevelPercent .. " % toward level " .. SkillLevelCurFloored+1 .. ")\n" );

		if ( 1 == bFirstRun ) then
		
			-- This is the first run.  Initialize the Previous to the values we just calculated
			g_CraftCalcTable[Realm][PlayerName].Previous[i] = {};
			g_CraftCalcTable[Realm][PlayerName].Previous[i] = tempObj;
		else 
			-- This is not the first run.  Backup Current to Previous,
			g_CraftCalcTable[Realm][PlayerName].Previous[i] = {};
			g_CraftCalcTable[Realm][PlayerName].Previous[i] = g_CraftCalcTable[Realm][PlayerName].Current[i];
		end

		-- Always update Current to the values we just calculated
		g_CraftCalcTable[Realm][PlayerName].Current[i] = {};
		g_CraftCalcTable[Realm][PlayerName].Current[i] = tempObj;
		
	end 

	--Log("CraftCalc_InitPreviousAndCurrent complete.");
end


function CraftCalc_CalculateDiffs()

	--Log("CraftCalc_CalculateDiffs starting...");
	
	-- Get Player Name and Relam so we know where to read this guys info from the table
	local PlayerName = UnitName("player");
	local Realm = GetCurrentRealm();


	-- Cycle through all the Crafting (Production & Gathering) status frames of the Character Crafting UI
	for i = 1 , CCFrame.ItemCount do
	
		local Current = {};
		Current.SkillLevelCurFloored = g_CraftCalcTable[Realm][PlayerName].Current[i].SkillLevelCurFloored
		Current.SkillLevelPercent 	 = g_CraftCalcTable[Realm][PlayerName].Current[i].SkillLevelPercent
		Current.SkillName 			 = g_CraftCalcTable[Realm][PlayerName].Current[i].SkillName

		local Previous = {};
		Previous.SkillLevelPercent 	  = g_CraftCalcTable[Realm][PlayerName].Previous[i].SkillLevelPercent

		-- If the Skill Level Percent Changed, log it
		if ( Current.SkillLevelPercent ~= Previous.SkillLevelPercent ) then
		
			local AddedPercent = 0;
			
			-- If we just leveled this skill our new % will be lower than our previous % (for example: from 99.99% to 2.66%) fix our Previous so our math works later on.
			-- Do the 'if' statement with integers not strings or it''ll think 10.03 < 9.70
			if ( (Current.SkillLevelPercent+0) < (Previous.SkillLevelPercent+0) ) then
			
				--Log( Current.SkillLevelPercent .. " < " .. Previous.SkillLevelPercent );

				-- Make sure percentage is shown to only 2 decimal places (add 100% because we just leveled)
				AddedPercent = string.format( "%.2f" , (Current.SkillLevelPercent+100) - Previous.SkillLevelPercent ) ;
			else
				-- Make sure percentage is shown to only 2 decimal places
				AddedPercent = string.format( "%.2f" , Current.SkillLevelPercent - Previous.SkillLevelPercent ) ;
			end
			
			Log( Current.SkillName .. " skill is level " .. Current.SkillLevelCurFloored .. " with " .. Current.SkillLevelPercent .. "% (+" .. AddedPercent .. "%)." );
		end
		
	end 

	--Log("CraftCalc_CalculateDiffs complete.");

end


function CraftCalc_OnLoad(this)

	--CraftCalc_LoadTable();
	Log( PLUGIN_TITLE .. " loaded." );

	-- Register for Events we care about
	this:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	this:RegisterEvent("PLAYER_LIFESKILL_CHANGED");
	this:RegisterEvent("VARIABLES_LOADED");
	
end


function CraftCalc_OnEvent(this, event)
	
	--Log("CraftCalc Event: " .. event);
	
	-- we load our .INI file here
	if ( event == "VARIABLES_LOADED" ) then
		--Log( "VARIABLES_LOADED" );
		if ( IsCraftCalcInitialized() ~= true ) then
			Initialize_CraftCalc();
		end
		return;
	end
	
	-- Event: UNIT_PORTRAIT_UPDATE
	-- We Get the player name here and Initialize our AddOn
	if ( event == "UNIT_PORTRAIT_UPDATE" and arg1 == "player" ) then
		
		if ( IsCraftCalcInitialized() ~= true ) then
			Initialize_CraftCalc();
		end
		return;
	end

	if ( event == "PLAYER_LIFESKILL_CHANGED" ) then
	
		-- Update the table (0 means This is not the first run)
		CraftCalc_SetTable( 0 );

		-- Save the latest table
		CraftCalc_SaveTable();
		
		-- Figure out what changed and log it
		CraftCalc_CalculateDiffs();
		
		return;
	end
	
end
