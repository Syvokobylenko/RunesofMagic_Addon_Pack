yGather.settings = {};

-- this package needs following globals
local _G = _G;
local SaveVariables = SaveVariables;
local pairs = pairs;
local tostring = tostring;

local logger = yGather.logger;

setfenv(1, yGather.settings);

local nilvalue = {}; -- dummy to represent nil value in temporary table
local current = {};
local temporary = {};
local default = {
    ["worldmap/showResources"] = true;
    ["worldmap/iconSet"] = "coloredDots";
    ["worldmap/iconOreColor"] = {1, 1, 0};
    ["worldmap/iconHerbsColor"] = {0, 1, 0};
    ["worldmap/iconWoodColor"] = {1, 0.5, 0};
    ["worldmap/iconTransparency"] = 0;
    ["worldmap/iconSize"] = 6;
    
    ["minimap/showResources"] = true;
    ["minimap/iconSet"] = "coloredDots";
    ["minimap/iconOreColor"] = {1, 1, 0};
    ["minimap/iconHerbsColor"] = {0, 1, 0};
    ["minimap/iconWoodColor"] = {1, 0.5, 0};
    ["minimap/iconTransparency"] = 0;
    ["minimap/iconSize"] = 6;
};

local function ConvertLegacyValues()
    -- iconMode was replaced with iconSet
    if (nil ~= current["worldmap/iconMode"]) then
        if (nil == current["worldmap/iconSet"]) then
            current["worldmap/iconSet"] = current["worldmap/iconMode"];
        end;
        current["worldmap/iconMode"] = nil;
    end;
end;

local listeners = {};

function HandleVariablesLoaded()
	local settings = _G["yGather_Settings"];
	if (settings == nil) then
		settings = {};
	end;
    SetCurrent(settings);
    _G["yGather_Settings"] = GetCurrent();
    SaveVariables("yGather_Settings");
end

function HandleSaveVariables()
    _G["yGather_Settings"] = GetCurrent();
    SaveVariables("yGather_Settings");
end

function SetValue(key, value)
    current[key] = value;
    Notify();
end

function ResetValue(key)
    current[key] = nil;
    Notify();
end

function GetValue(key, defaultValue)
    local value = temporary[key];
    if ((value ~= nil) and (value ~= nilvalue)) then
        return value;
    end

    value = current[key];
    if (value ~= nil) then
        return value;
    end

    value = default[key];
    if (value ~= nil) then
        return value;
    end

    return defaultValue;
end

function SetCurrent(newCurrent)
    if (newCurrent) then
        current = newCurrent;
        ConvertLegacyValues();
        Notify();
    end
end

function GetCurrent()
    return current;
end

function Reset()
    current = {};
    temporary = {};
    Notify();
end

function SetTemporaryValue(key, value)
    if (value == nil) then
        value = nilvalue;
    end;
    temporary[key] = value;
    Notify();
end

function ApplyTemporary()
    for k, v in pairs(temporary) do
        if (v == nilvalue) then
            v = nil;
        end;
        current[k] = v;
    end
end

function ClearTemporary()
    temporary = {};
    Notify();
end


local transaction = false;
function StartTransaction()
    transaction = true;
end;

function EndTransaction()
    transaction = false;
    Notify();
end;


local listeners = {};

function AddListener(key, callback)
    listeners[key] = callback;
end

function RemoveListener(key)
    listeners[key] = nil;
end

function Notify()
    if (transaction) then
        return;
    end;
    
    for key, callback in pairs(listeners) do
        callback(key);
    end
end
