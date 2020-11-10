--[[ local Info about this version ]]-- 
local TITLE				=	"XPExtended";
local VERSION			=	"0.4.6i, Edit by Pristerofgodness";
local INTERFACE			=	"5.0.10.2634";
local RELEASE_DATE		=	"15/5-2013";
local AUTHOR			=	"Zilvermoon";
local ADDON_LOADED		=	TITLE.." v"..VERSION;

--[[ Debuging ]]-- 
local DEBUG				=	false;

--[[ Game Variables ]]-- 
local PLAYER_LEVEL_CAP = 97;
local PLAYER_ENTERED_WORLD = false;

--[[ local storage table for storing all data in ]]-- 
local XPExtended_Data	=	{
	["Current"]				=	{
		["Class"]				=	nil,
		["ClassLevel"]			=	nil,
		["SubClass"]			=	nil,
		["SubClassLevel"]		=	nil,
		["EXP"]					=	nil,
		["MaxEXP"]				=	nil,
		["RemaningEXP"]			=	nil,
		["GainedEXP"]			=	nil,
		["GainedEXPRepeats"]	=	nil,
		["EXPProgress"]			=	nil,
		["ExtraEXP"]			=	nil,
		["ExtraTP"]				=	nil,
		["ClassEXPdebt"]		=	nil,
		["ClassTPdebt"]			=	nil,
	},
	["Old"]					=	{
		["EXP"]					=	nil,
		["MaxEXP"]				=	nil,
	},
	["Stored"]				=	{
		["Class"]				=	nil,
		["ClassLevel"]			=	nil,
		["SubClass"]			=	nil,
		["SubClassLevel"]		=	nil,
		["EXP"]					=	nil,
		["MaxEXP"]				=	nil,
		["RemaningEXP"]			=	nil,
		["GainedEXP"]			=	nil,
		["GainedEXPRepeats"]	=	nil,
		["EXPProgress"]			=	nil,
		["ExtraEXP"]			=	nil,
		["ExtraTP"]				=	nil,
		["ClassEXPdebt"]		=	nil,
		["ClassTPdebt"]			=	nil,
	},
	["Session"]				=	{
		["EXPCollected"]		=	nil,
		["EXPperHour"]			=	nil,
	},
	["WorldTime"]			=	{
		["Entering"]			=	nil,
		["Current"]				=	nil,
	}
};

--[[ Functions for Reloading UI ]]-- 
local Org_ReloadUI = nil;
local i = nil;

function UI()
	CloseAllWindows();
	for i = 1 , 12 , 1 do
		FocusUnit(i, ""); 
	end
	Org_ReloadUI();
end

Org_ReloadUI = ReloadUI;
ReloadUI = UI;

SlashCmdList["UI"] = UI;
SLASH_UI1 = "/RELOADUI";
SLASH_UI2 = "/UI";

function XPE(editBox,msg)
	if((msg == "")or(msg == nil))then
		ChatFrame1:AddMessage("XPE No MSG");
	end
	msg = string.lower(msg);
	if (msg == "debug") then
		if ( DEBUG ) then
			ChatFrame1:AddMessage("XPExtended Debug off");
			DEBUG = false;
		else
			ChatFrame1:AddMessage("XPExtended Debug on");
			DEBUG = true;
		end
		XPExtended_Debug();
	end
end

SlashCmdList["XPE"] = XPE;
SLASH_XPE1 = "/XPEXTENDED";
SLASH_XPE2 = "/XPE";


function XPExtended_OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_EXP_CHANGED");
	this:RegisterEvent("EXCHANGECLASS_SUCCESS");
	this:RegisterEvent("EXCHANGECLASS_SHOW");
	this:RegisterEvent("LOADING_END");
	XPExtended_Data["WorldTime"]["Entering"] = GetTime();
	if ( DEBUG ) then XPExtended_Debug(); end
end

function XPExtended_Debug()
	if ( DEBUG ) then
		for i=1, 7 do
			local ColorTexture = getglobal("XPExtended_Text"..i.."_Color");
			ColorTexture:Show();
		end
	else
		for i=1, 7 do
			local ColorTexture = getglobal("XPExtended_Text"..i.."_Color");
			ColorTexture:Hide();
		end
	end
end

function XPExtended_OnEvent(this, event)
	if ( DEBUG ) then ChatFrame1:AddMessage(event); end
	if event == "VARIABLES_LOADED" then
		XPExtended_OnVarLoad();
	end
	if event == "PLAYER_EXP_CHANGED" then
		if ( PLAYER_ENTERED_WORLD) then
			XPExtended_Update();
		end
	end
	if event == "EXCHANGECLASS_SHOW" then
		PLAYER_ENTERED_WORLD = false;
	end
	if event == "EXCHANGECLASS_SUCCESS" then
		XPExtended_ChangedClass();
	end
	if event == "LOADING_END" then
		if ( not PLAYER_ENTERED_WORLD ) then PLAYER_ENTERED_WORLD = true; end
		XPExtended_Update();
		if ( DEBUG ) then XPExtended_SendChatMessage(XPExtended_Data["WorldTime"]["Entering"]); end
	end
end

function XPExtended_OnVarLoad()
	XPExtended_SendChatMessage("AddOn loaded: |cffffffff"..ADDON_LOADED.."|r", 0.5, 0.7, 0.1);
end

function XPExtended_Update()
	if ( XPExtended_Data["Stored"]["Class"] == nil ) then
		-- We got no data in table so populate it with data
		if ( UnitClass("player") ~= nil ) then
			-- We got a player class, insert data into table's
			XPExtended_Data["Stored"]["Class"],
			XPExtended_Data["Stored"]["SubClass"],
			XPExtended_Data["Stored"]["ClassLevel"],
			XPExtended_Data["Stored"]["SubClassLevel"],
			XPExtended_Data["Stored"]["EXP"],
			XPExtended_Data["Stored"]["MaxEXP"] = XPExtended_GetPlayerInfo();

			XPExtended_Data["Stored"]["RemaningEXP"] = XPExtended_Data["Stored"]["MaxEXP"] - XPExtended_Data["Stored"]["EXP"];
			XPExtended_Data["Stored"]["GainedEXP"] = 0;
			XPExtended_Data["Stored"]["GainedEXPRepeats"] = "~";
			XPExtended_Data["Stored"]["EXPProgress"] = math.ceil( XPExtended_Data["Stored"]["EXP"] / XPExtended_Data["Stored"]["MaxEXP"] * 100 )

			XPExtended_Data["Stored"]["ExtraEXP"],
			XPExtended_Data["Stored"]["ExtraTP"] = GetPlayerExtraPoint();

			XPExtended_Data["Stored"]["ClassEXPdebt"],
			XPExtended_Data["Stored"]["ClassTPdebt"], _, _ = GetPlayerExpDebt();

			for k, v in pairs(XPExtended_Data["Stored"]) do
				XPExtended_Data["Current"][k] = v;
				if ( DEBUG ) then XPExtended_SendChatMessage(k.." "..v); end
			end

			XPExtended_Data["Session"]["EXPCollected"] = 0;
			XPExtended_Data["Session"]["EXPperHour"] = 0;

			XPExtended_Data["Old"]["EXP"] = XPExtended_Data["Stored"]["EXP"];
			XPExtended_Data["Old"]["MaxEXP"] = XPExtended_Data["Stored"]["MaxEXP"];
		end
		if ( DEBUG ) then ChatFrame1:AddMessage("XPExtended_Data[Stored][Class] == nil"); end
--		return;
	end

	-- Calculate the time we have been in-game
	XPExtended_Data["WorldTime"]["Current"] = GetTime()-XPExtended_Data["WorldTime"]["Entering"];

	-- Get data
	XPExtended_Data["Current"]["Class"],
	XPExtended_Data["Current"]["SubClass"] = UnitClass("player");
	XPExtended_Data["Current"]["ClassLevel"],
	XPExtended_Data["Current"]["SubClassLevel"] = UnitLevel("player");
	XPExtended_Data["Current"]["EXP"] = GetPlayerExp("player");
	XPExtended_Data["Current"]["MaxEXP"] = GetPlayerMaxExp("player");
	XPExtended_Data["Current"]["NewClassLevel"] = XPExtended_Data["Current"]["ClassLevel"] + 1;

	-- Did data change since last update ?
	if ( XPExtended_Data["Current"]["EXP"] ~= XPExtended_Data["Stored"]["EXP"] ) then
		if ( DEBUG ) then ChatFrame1:AddMessage("XPExtended_Data[Current][EXP] ~= XPExtended_Data[Stored][EXP]"); end

		-- Make sure we got this for calculations later ( This table should always be populated with data )
		if ( XPExtended_Data["Stored"]["EXP"] ~= XPExtended_Data["Old"]["EXP"] ) then
			XPExtended_Data["Old"]["EXP"] = XPExtended_Data["Stored"]["EXP"];
		end
		-- Make sure we got this for calculations later ( This table should always be populated with data )
		if ( XPExtended_Data["Stored"]["MaxEXP"] ~= XPExtended_Data["Old"]["MaxEXP"] ) then
			XPExtended_Data["Old"]["MaxEXP"] = XPExtended_Data["Stored"]["MaxEXP"];
		end

		if ( XPExtended_Data["Current"]["MaxEXP"] ~= XPExtended_Data["Old"]["MaxEXP"] ) then
			XPExtended_Data["Current"]["GainedEXP"] = XPExtended_Data["Current"]["EXP"] + ( XPExtended_Data["Old"]["MaxEXP"] - XPExtended_Data["Old"]["EXP"] );
		else
			XPExtended_Data["Current"]["GainedEXP"] = XPExtended_Data["Current"]["EXP"] - XPExtended_Data["Old"]["EXP"];
		end

		if ( XPExtended_Data["Current"]["GainedEXP"] ~= nil ) then
			XPExtended_Data["Session"]["EXPCollected"] = XPExtended_Data["Session"]["EXPCollected"] + XPExtended_Data["Current"]["GainedEXP"];
		end

		XPExtended_Data["Current"]["RemaningEXP"] = XPExtended_Data["Current"]["MaxEXP"] - XPExtended_Data["Current"]["EXP"];

		if ( XPExtended_Data["Current"]["GainedEXP"] > 0 ) then
			XPExtended_Data["Current"]["GainedEXPRepeats"] = math.ceil( XPExtended_Data["Current"]["RemaningEXP"] / XPExtended_Data["Current"]["GainedEXP"] );
			XPExtended_Data["Session"]["EXPperHour"] = math.floor( XPExtended_Data["Session"]["EXPCollected"] / XPExtended_Data["WorldTime"]["Current"] * 3600 );
		else
			XPExtended_Data["Current"]["GainedEXPRepeats"] = "~";
		end

		XPExtended_Data["Current"]["EXPProgress"] = math.ceil( XPExtended_Data["Current"]["EXP"] / XPExtended_Data["Current"]["MaxEXP"] * 100 )

		XPExtended_Data["Current"]["ExtraEXP"], XPExtended_Data["Current"]["ExtraTP"] = GetPlayerExtraPoint();
		XPExtended_Data["Current"]["ClassEXPdebt"], XPExtended_Data["Current"]["ClassTPdebt"], _, _ = GetPlayerExpDebt();

		XPExtended_Data["Old"]["EXP"] = XPExtended_Data["Current"]["EXP"]; -- expect this to be 100% un-needed now
		XPExtended_Data["Old"]["MaxEXP"] = XPExtended_Data["Current"]["MaxEXP"]; -- expect this to be 100% un-needed now

		-- Copy all "new" data to storage table for later comparison & calculations
		for k, v in pairs(XPExtended_Data["Current"]) do
			XPExtended_Data["Stored"][k] = v;
			if ( DEBUG ) then XPExtended_SendChatMessage(k.." "..v); end
		end
--		XPExtended_Data["Stored"] = XPExtended_Data["Current"];

	end
		if ( XPExtended_Data["Current"]["Class"] ) then
			XPExtended_Text1:SetText( "|cffffffffXP needed: |r"..XPExtended_Data["Current"]["RemaningEXP"] );
			XPExtended_Text2:SetText( "|cffffffffProgress: |r"..XPExtended_Data["Current"]["EXPProgress"].." %" );
			XPExtended_Text3:SetText( "|cffffffffGained XP: |r"..XPExtended_Data["Session"]["EXPCollected"] );
			XPExtended_Text4:SetText( "|cffffffffXP/Hour: |r"..XPExtended_Data["Session"]["EXPperHour"] );
			if ( XPExtended_Data["Current"]["SubClass"] ~= "" ) then
				XPExtended_Text5:SetText( "|cffffffff"..XPExtended_Data["Current"]["SubClass"].." Lvl: |r"..XPExtended_Data["Current"]["SubClassLevel"] );
			else XPExtended_Text5:SetText(" "); end
			XPExtended_Text6:SetText( "|cffffffff"..XPExtended_Data["Current"]["Class"].." Lvl: |r"..XPExtended_Data["Current"]["ClassLevel"] );
			if ( XPExtended_Data["Current"]["ClassLevel"] < PLAYER_LEVEL_CAP ) then
				XPExtended_Text7:SetText( XPExtended_Data["Current"]["GainedEXPRepeats"].." |cffffffffrepeats to Lvl: |r"..XPExtended_Data["Current"]["ClassLevel"] + 1);
			else
				XPExtended_Text7:SetText( "Player Level Cap Reached" );
			end
		end
end

function XPExtended_ChangedClass()
	for k, v in pairs(XPExtended_Data["Stored"]) do
		XPExtended_Data["Stored"][k] = nil;
		if ( DEBUG ) then XPExtended_SendChatMessage(k.." "..tostring(v)); end
	end
	for k, v in pairs(XPExtended_Data["Current"]) do
		XPExtended_Data["Current"][k] = nil;
		if ( DEBUG ) then XPExtended_SendChatMessage(k.." "..tostring(v)); end
	end

	XPExtended_Data["Old"]["EXP"]					=	nil;
	XPExtended_Data["Old"]["MaxEXP"]				=	nil;

	XPExtended_Data["Session"]["EXPCollected"]		=	nil;
	XPExtended_Data["Session"]["EXPperHour"]		=	nil;
	XPExtended_Data["WorldTime"]["Entering"]		=	GetTime();

	PLAYER_ENTERED_WORLD							=	true;

	XPExtended_Update();
end

function XPExtended_GetPlayerInfo()
	local class, token, level, currExp, maxExp;
	local mClass, sClass = UnitClass("player");
	local mLvl, sLvl, mCurrExp, sCurrExp, mMaxExp, sMaxExp = 0, 0, 0, 0, 0, 0;
	local numClasses = GetNumClasses();

	for index = 1, numClasses do
		class, token, level, currExp, maxExp = GetPlayerClassInfo(index);
		if ( class ) then
			if ( class == mClass ) then
				mLvl = level;
				mCurrExp = currExp;
				mMaxExp = maxExp;
			elseif ( class == sClass ) then
				sLvl = level;
--				sCurrExp = currExp;
--				sMaxExp = maxExp;
			end
		end
	end

	return mClass, sClass, mLvl, sLvl, mCurrExp, mMaxExp;
--	return mClass, sClass, mLvl, sLvl, mCurrExp, sCurrExp, mMaxExp, sMaxExp;
end

function XPExtended_SendChatMessage(text, r, b, g)
	if ( r and b and g ) then
		ChatFrame1:AddMessage(text, r, b ,g);
	else
		ChatFrame1:AddMessage(text);
	end
end