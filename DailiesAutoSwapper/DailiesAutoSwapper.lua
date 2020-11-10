local ADDON = "Dailies Auto Swapper"
local VERSION = 2.13
local AUTHOR = "ZTrek"

DASwapper = false
local DASLoaded = true

local GreenText = "|cff00DD00"
local OrangeText = "|cffFF4400"
local BlueText = "|cff00A5EC"
local YellowText = "|cffFFFF00"
local EndColor = "|r"

DEFAULT_CHAT_FRAME:AddMessage(string.format("%s%s%s %sv%s%s by %s%s%s", BlueText, ADDON, EndColor, GreenText, VERSION, EndColor, OrangeText, AUTHOR, EndColor))

local RightClickToUse = TEXT("SC_USERIGHT")--	Right-click to use
local RightClickToCancelEffect = TEXT("Sys502398_shortnote")

local Daily = TEXT("UI_QUEST_MSG_DAILY")--Daily
local DailyQuest = TEXT("QUEST_TRACK_TOOLTIP_DAILY_TITLE")--Daily
local Auto = TEXT("UI_LOTTERYSHOP_AUTO")
local Changeclass = TEXT("HOUSE_MAID_HOUSE_CHANGEJOB")--	Change class
local HouseMaid = TEXT("Sys110752_titlename")--	House Maid
local WarningafterSwitchingClasses = TEXT("Sys420659_name")--Warning after Switching Classes
local SwitchClassSuccess = TEXT("SYS_EXCHANGE_CLASS_SUCCESS")--Class Change Successful

local Warning = TEXT("Sys420460_name")
local report = string.lower(TEXT("PARTY_BOARD_REPORT"))
local reportafterreport = string.lower(TEXT("Sys420427_name"):gsub(" ",""))--Report after report
local after = string.gsub(reportafterreport, report, "")
local afterSwitchingClasses = string.gsub(WarningafterSwitchingClasses, Warning, "")
local SwitchingClasses = string.gsub(afterSwitchingClasses, after, "")
local SwitchingClasses = string.gsub(SwitchingClasses, "  ", "")
	
function DailiesAutoSwapper_OnLoad(this)
	this:RegisterEvent("SHOW_QUESTLIST")
	this:RegisterEvent("EXCHANGECLASS_SHOW")
	this:RegisterEvent("EXCHANGECLASS_SUCCESS")
	this:RegisterEvent("SHOW_REQUESTLIST_DIALOG")
    this:RegisterEvent("VARIABLES_LOADED")
--    this:RegisterEvent("LOADING_END")
end

function DailiesAutoSwapper_OnEvent(this, event)
	if event == "VARIABLES_LOADED" then
		DASClassEquipData = DASClassEquipData or {}
		DAS_Toggle:UnlockPushed()
		SaveVariablesPerCharacter("DASClassEquipData")
	end
--[[	if event == "LOADING_END" then
		if DASLoaded then
			DASLoaded = false
		end
	end]]
	if (event == "SHOW_QUESTLIST" and DASwapper and EXCHANGECLASS_SUBCLASS ~= 0) then
		if GetNumSpeakOption() > 0 then
			for i = 1, GetNumSpeakOption() do
				if GetSpeakOption(i) == TEXT("SO_110581_1") then
					DASOutput(Auto.." "..SwitchingClasses)
					ChoiceOption(i)
				end
			end
		end
	end
	if (event == "EXCHANGECLASS_SHOW" and DASwapper and EXCHANGECLASS_SUBCLASS ~= 0) then
		DASClassEquipData[UnitClass("player")] = GetEuipmentNumber()
		ExchangeClass(EXCHANGECLASS_SUBCLASS, EXCHANGECLASS_MAINCLASS)
	end
	if (event == "EXCHANGECLASS_SUCCESS") then
		if DASClassEquipData[UnitClass("player")] then
			SwapEquipmentItem(DASClassEquipData[UnitClass("player")]-1)
		end
		DASOutput(SwitchClassSuccess)
	end
	if (event == "SHOW_REQUESTLIST_DIALOG" and DASwapper and EXCHANGECLASS_SUBCLASS ~= 0) then
		for i = 1, GetNumSpeakOption() do
			if GetSpeakOption(i) == TEXT("HOUSE_MAID_HOUSE_CHANGEJOB") then
				DASOutput(Auto.." "..SwitchingClasses)
				ChoiceListDialogOption(i-1)
			end
		end
	end
end

function DailiesAutoSwapperMacroGen()
	for macroslot = 1,49 do
		DASOutput("Running Macro Generator")
		local MacroExists = HasMacro(macroslot);
	if (not MacroExists) then
		EditMacro(macroslot, "Dailies Auto Swapper toggle", 16, "/run DailiesAutoSwapper()")
		DASOutput("Your macro has been created and can be found in macro slot "..macroslot)
	break end
	end
end

function DASToggle()
	if DASwapper == false then
		DASwapper = true
		DAS_Toggle:LockPushed()
--		SendSystemMsg("Dailies Auto Swapper is now on")
		PlaySoundByPath("Interface/AddOns/DailiesAutoSwapper/DASOn.mp3")
	elseif DASwapper == true then
		DASwapper = false
		DAS_Toggle:UnlockPushed()
--		SendSystemMsg("Dailies Auto Swapper is now off")
		PlaySoundByPath("Interface/AddOns/DailiesAutoSwapper/DASOff.mp3")
	end
end

function DASOutput(OutputText)
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(OutputText)
	end

	if SELECTED_CHAT_FRAME and SELECTED_CHAT_FRAME ~= DEFAULT_CHAT_FRAME then
		SELECTED_CHAT_FRAME:AddMessage(OutputText)
	end
end

function DASMinimapButton_OnEnter(this)
	DASToolTip(this)
end

function DASMinimapButton_onClick(this, key)
--[[	if key == "LBUTTON" then
		if aaiConfig:IsVisible() == false then
			aaiConfig:Show()
		end]]
--	elseif key == "RBUTTON" and not IsShiftKeyDown() then
	if key == "RBUTTON" and not IsShiftKeyDown() then
		DASToggle()
	end
	DASToolTip(this)
end

function DASToolTip(this)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT", 4, 0)
	GameTooltip:SetText(DailyQuest.." "..Auto.." "..Changeclass, 1, 1, 1)
	GameTooltip:AddLine(ADDON.." v"..VERSION, 50/255, 50/255, 230/255)
	if DASwapper == false then
		GameTooltip:AddLine(RightClickToUse, 0, 0.75, 0.95)
	elseif DASwapper == true then
		GameTooltip:AddLine(RightClickToCancelEffect, 0, 0.75, 0.95)
	end
	GameTooltip:AddLine(HouseMaid.." "..Auto.." "..Changeclass, 1, 1, 1)
	GameTooltip:AddLine(UI_MINIMAPBUTTON_MOVE, 0, 0.75, 0.95)
	GameTooltip:Show()
end

SLASH_DASTOGGLE1 = "/das"
SlashCmdList["DASTOGGLE"] = DASToggle

--[[
Select gear for class

]]