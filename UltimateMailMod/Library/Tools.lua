
-- ###########################
-- ##                       ##
-- ##  Miscellaneous Tools  ##
-- ##                       ##
-- ###########################

-- ### Locale Loader ###

UMMPath = "Interface/Addons/UltimateMailMod/";
local LOCALE_PATH = UMMPath.."Locales/";
local Sol = LibStub("Sol");

local function LoadLUAFile(fileName)
  local func, err = loadfile(fileName);
  if err then
    return false, err;
  else
    dofile(fileName);
    return true;
  end
end

local locale = string.sub(GetLanguage():upper(), 1, 2);			-- release 4.0.8.2506
-- old function: GetLocation() loads the settings of the RoM Client instead of the selected RoM language
if not LoadLUAFile(LOCALE_PATH..locale..".lua") then
  local dummy1, dummy2 = LoadLUAFile(LOCALE_PATH.."DE.lua");	-- release 4.0.8.2506
end

-- ### Miscellaneous Public Functions ###

function UMMPrompt(strMessage)
  local prefix = "|cff"..UMMColor.Header.."[|r|cff"..UMMColor.Medium..UMM_PROMPT.."|r|cff"..UMMColor.Header.."] |r";
  local msgColor = "|cff"..UMMColor.Bright;
  DEFAULT_CHAT_FRAME:AddMessage(prefix..msgColor..strMessage.."|r");
end

function UMMPrint(strMessage)
  local msgColor = "|cff"..UMMColor.Bright;
  DEFAULT_CHAT_FRAME:AddMessage(msgColor..strMessage.."|r");
end

local function Pad3Zero(v)
  local wrk = ""..v.."";
  if (string.len(wrk) == 1) then
    wrk = "00"..v.."";
  elseif (string.len(wrk) == 2) then
    wrk = "0"..v.."";
  end
  return ""..wrk.."";
end

function UMMFormatNumber(n)
  local MONEY_DIVIDER = 1000;
  local result, value, giga, mega, kilo, rest;
  value = n;
  mega = math.floor(value / (MONEY_DIVIDER * MONEY_DIVIDER));
  kilo = math.floor((value - (mega * (MONEY_DIVIDER * MONEY_DIVIDER))) / MONEY_DIVIDER);
  rest = math.mod(value, MONEY_DIVIDER);
  if (mega > 999) then
    value = mega;
    local dummy = math.floor(value / (MONEY_DIVIDER * MONEY_DIVIDER));
    giga = math.floor((value - (dummy * (MONEY_DIVIDER * MONEY_DIVIDER))) / MONEY_DIVIDER);
    mega = math.mod(value, MONEY_DIVIDER);
  else
    giga = 0;
  end
  
  result = "";
  if (giga > 0) then
    result = result .. giga .. ".";
  end
  if (mega > 0) then
    if (giga > 0) then
      result = result .. Pad3Zero(mega);
    else
      result = result .. mega;
    end
    result = result .. "."; -- release 4.0.8.2506
  elseif (giga > 0) then
    result = result .. "000."; -- release 4.0.8.2506
  end
  if (kilo > 0) then
    if (mega > 0) then
      result = result .. Pad3Zero(kilo);
    else
      result = result .. kilo;
    end
    result = result .. "."; -- release 4.0.8.2506
  elseif (mega > 0 or giga > 0) then
    result = result .. "000."; -- release 4.0.8.2506
  end
  if (rest > 0) then
    if (kilo > 0) then
      result = result .. Pad3Zero(rest);
    else
      result = result .. rest;
    end
  elseif (kilo > 0 or mega > 0 or giga > 0) then
    result = result .. "000";
  end
  
  return result;
end

-- Global timing

UMMGlobalTimeout = 0;
UMMGlobalFailTimeout = 0;
UMMGlobalTimeoutCallFunction = nil;
UMMGlobalFailTimeoutCallFunction = nil;
UMMGlobalInboxLoadTimeout = 0;

-- 200ms seem to be stable for medium level hardware usage
UMM_GLOBAL_AUTOMATION_WAITTIME    = 0.2;					-- release 5.0.1.2553
-- 10 seconds to wait for automation fail is suitable
UMM_GLOBAL_AUTOMATION_WAITTIMEOUT = 10;
--125ms delete delay seems to be stable for medium level hardware usage
UMM_AUTOMATION_DELETE_WAITTIME    = 0.125;					-- release 5.0.1.2553

function UMMSetGlobalFailTimeout(callFunction)
  UMMGlobalFailTimeoutCallFunction = callFunction;
  UMMGlobalFailTimeout = UMM_GLOBAL_AUTOMATION_WAITTIMEOUT;
end

function UMMSetGlobalTimeout(callFunction, deleteTimer)
  UMMGlobalTimeoutCallFunction = callFunction;
  if (deleteTimer) then
    UMMGlobalTimeout = UMM_AUTOMATION_DELETE_WAITTIME;
  else
    UMMGlobalTimeout = UMM_GLOBAL_AUTOMATION_WAITTIME;
  end
  UMMSetGlobalFailTimeout(callFunction);
end

-- **************************************************************
-- Test to implement the GetType Function
-- **************************************************************
function UMMGetItemType(index, item)
  Sol.tooltip.ClearAllText(GameTooltip);
  GameTooltip:SetBagItem(GetBagItemInfo(index));
  -- GameTooltip:Hide();
  local lines = Sol.tooltip.ReadTooltip(GameTooltip);
  local result = UMMSearchInTooltip(item);
  return result;
end

function UMMSearchInTooltip(searchString)
  searchString = string.gsub(searchString, "-", "%%-");
  local lowerString = string.lower(searchString);
  local result;
  for i = 2, 40 do
    --Search for text in left sides
    result = getglobal("GameTooltipTextLeft"..i):GetText();
    if result ~= nil and getglobal("GameTooltipTextLeft"..i):IsVisible() then
      if string.find(string.lower(result), string.lower(searchString)) then
        return result;
      end
    end
    --Search for text in right sides
    result = getglobal("GameTooltipTextRight"..i):GetText();
    if result ~= nil and getglobal("GameTooltipTextRight"..i):IsVisible() then
      if string.find(string.lower(result), string.lower(searchString)) then
        return result;
      end
    end
  end
  result = "Item";
  return result;
end
