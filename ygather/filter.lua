yGather.filter = {};

-- this package needs following globals
local tostring = tostring;

local yGSettings = yGather.settings;
local yGMatdb = yGather.matdb;
local logger = yGather.logger;

local GetPlayerCurrentSkillValue = GetPlayerCurrentSkillValue;

setfenv(1, yGather.filter);

function UnravelAboveLevelFilter()
    yGSettings.StartTransaction();
    local lumLevel = GetPlayerCurrentSkillValue("LUMBERING")
    local minLevel = GetPlayerCurrentSkillValue("MINING")
    local herbLevel = GetPlayerCurrentSkillValue("HERBLISM")
    
    for _, entry in yGMatdb.LumIterator() do
        if (lumLevel < entry[3]) then
            yGSettings.SetValue("filters/" .. entry[1], true);
        end;
    end;
    
    for _, entry in yGMatdb.MinIterator() do
        if (minLevel < entry[3]) then
            yGSettings.SetValue("filters/" .. entry[1], true);
        end;
    end;
    
    for _, entry in yGMatdb.HerbIterator() do
        if (herbLevel < entry[3]) then
            yGSettings.SetValue("filters/" .. entry[1], true);
        end;
    end;
    
    yGSettings.ResetValue("filters/AboveLevel");
    yGSettings.EndTransaction();
end;

function UnravelLumberingFilter()
    for _, entry in yGMatdb.LumIterator() do
        yGSettings.SetValue("filters/" .. entry[1], true);
    end;
    yGSettings.ResetValue("filters/Lumbering");
end;

function UnravelMiningFilter()
    for _, entry in yGMatdb.MinIterator() do
        yGSettings.SetValue("filters/" .. entry[1], true);
    end;
    yGSettings.ResetValue("filters/Mining");
end;

function UnravelHerblismFilter()
    for _, entry in yGMatdb.HerbIterator() do
        yGSettings.SetValue("filters/" .. entry[1], true);
    end;
    yGSettings.ResetValue("filters/Herblism");
end;

function SetAboveLevelFilter(activate)
    if (activate) then
        yGSettings.SetValue("filters/AboveLevel", true);
    else
        yGSettings.ResetValue("filters/AboveLevel");
    end;
end;

function SetLumberingFilter(activate)
    if (activate) then
        yGSettings.SetValue("filters/Lumbering", true);
    else
        yGSettings.ResetValue("filters/Lumbering");
    end;
end;

function SetMiningFilter(activate)
    if (activate) then
        yGSettings.SetValue("filters/Mining", true);
    else
        yGSettings.ResetValue("filters/Mining");
    end;
end;

function SetHerblismFilter(activate)
    if (activate) then
        yGSettings.SetValue("filters/Herblism", true);
    else
        yGSettings.ResetValue("filters/Herblism");
    end;
end;

function SetFilter(activate, matId)
    if (IsActiveAboveLevelFilter()) then
        UnravelAboveLevelFilter();
    end;
    
    skill = yGMatdb.GetResourceSkill(matId);
    
    if ((skill == "LUMBERING") and IsActiveLumberingFilter()) then
        UnravelLumberingFilter();
    end;
    
    if ((skill == "MINING") and IsActiveMiningFilter()) then
        UnravelMiningFilter();
    end;
    
    if ((skill == "HERBLISM") and IsActiveHerblismFilter()) then
        UnravelHerblismFilter();
    end;

    if (activate) then
        yGSettings.SetValue("filters/" .. matId, true);
    else
        yGSettings.ResetValue("filters/" .. matId);
    end;
end;

function ClearFilters()
    yGSettings.StartTransaction();
    yGSettings.ResetValue("filters/AboveLevel");
    yGSettings.ResetValue("filters/Lumbering");
    yGSettings.ResetValue("filters/Mining");
    yGSettings.ResetValue("filters/Herblism");
    for _, resource in yGMatdb.Iterator() do
        yGSettings.ResetValue("filters/" .. resource[1]);
    end;
    yGSettings.EndTransaction();
end;

function IsActiveAboveLevelFilter()
    return yGSettings.GetValue("filters/AboveLevel") == true;
end;

function IsActiveLumberingFilter()
    return yGSettings.GetValue("filters/Lumbering") == true;
end;
    
function IsActiveMiningFilter()
    return yGSettings.GetValue("filters/Mining") == true;
end;
    
function IsActiveHerblismFilter()
    return yGSettings.GetValue("filters/Herblism") == true;
end;


local prevMatId = nil;
local skill = nil;
local level = nil;
function IsFiltered(matId)
    if (matId ~= prevMatId) then
        skill = yGMatdb.GetResourceSkill(matId);
        level = yGMatdb.GetSkillLevel(matId);
        prevMatId = matId;
    end;
    
    if (IsActiveAboveLevelFilter()) then
        local currentLevel = GetPlayerCurrentSkillValue(skill);
        if (currentLevel < level) then
            return true;
        end;
    end;
    
    if ((skill == "LUMBERING") and IsActiveLumberingFilter()) then
        return true;
    end;
    
    if ((skill == "MINING") and IsActiveMiningFilter()) then
        return true;
    end;
    
    if ((skill == "HERBLISM") and IsActiveHerblismFilter()) then
        return true;
    end;
    
    if (yGSettings.GetValue("filters/" .. matId) == true) then
        return true;
    else
        return false;
    end;
end;
