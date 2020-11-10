yGather.minimap.watch = {};

-- this package needs following globals
local yGMatdb = yGather.matdb;
local logger = yGather.logger;
local zonescaling = yGather.zonescaling;
local database = yGather.database;
local yGather = yGather

local _G = _G;
local GetPlayerWorldMapPos = GetPlayerWorldMapPos;
local MinimapViewFrame = MinimapViewFrame;
local GetCurrentWorldMapID = GetCurrentWorldMapID;
local GetMinimapIconText = GetMinimapIconText;
local math = math;
local pairs = pairs;
local tostring = tostring;

setfenv(1, yGather.minimap.watch);

local player = {x = 0, y = 0};

local function round(n, p)
    if (n == nil) then
        return;
    end
    
    if (p == nil) then
        p = 0;
    end;
    
    local shift = math.pow(10, p);
    return math.floor(n * shift + 0.5) / shift;
end

function CalcMinimap2WorldScaling()
    local currentZoneScaling = zonescaling.GetScaling(GetCurrentWorldMapID());
    if (nil == currentZoneScaling) then
        return;
    end;
    local realScale = MinimapViewFrame:GetRealScale();
    return (realScale * yGather.minimapZoom * currentZoneScaling.x), (realScale * yGather.minimapZoom * currentZoneScaling.y);
end;

local minimap2WorldScaling = {x = 1, y = 1};
local function CalcWorldCoordinates(ix, iy)
    local mmx,mmy = MinimapViewFrame:GetCenter();
    local dx = (ix - mmx) / minimap2WorldScaling.x;
    local dy = (iy - mmy) / minimap2WorldScaling.y;

    return round((player.x + dx) * 1000, 2), round((player.y + dy) * 1000, 2);
end;

local function CalcMinimapRange()
    local mmMax = math.min(MinimapViewFrame:GetHeight() / minimap2WorldScaling.x,
            MinimapViewFrame:GetWidth() / minimap2WorldScaling.y);
    return (mmMax / 2) * 1000;
end;

local previousMinimapIcons = {};
function CheckMinimap()
    minimap2WorldScaling.x, minimap2WorldScaling.y = CalcMinimap2WorldScaling();
    if (nil == minimap2WorldScaling.x) then
        return false;
    end;
    
    player.x, player.y = GetPlayerWorldMapPos();

    local i = 1;
    local minimapSpots = {changed = false; spots = {}; missingSpots = {}};
    local minimapIcons = {};
    local icon = _G["MinimapFrame_Icon" .. i];
    while (nil ~= icon) do
        if (icon:IsVisible()) then
            local iconX, iconY = icon:GetCenter();
            local spot = {};
            spot.icon = icon;
            spot.matId = yGMatdb.GetResourceId(GetMinimapIconText(icon:GetID()));
            spot.x, spot.y = CalcWorldCoordinates(iconX, iconY);
            minimapSpots.spots[i] = spot;
            
            minimapIcons[i] = {iconX, iconY, spot.matId};
        else
            minimapIcons[i] = nil;
        end
        
        --[[avoids the stack cluster problem which occurs when RoM runs in full screen and is minimized while moving]]
        if (not minimapSpots.changed) then
            local current = minimapIcons[i];
            local previous = previousMinimapIcons[i];
            if (((current == nil) and (previous ~= nil)) or ((current ~= nil) and (previous == nil))) then
                minimapSpots.changed = true;
            elseif (((current ~= nil) and (previous ~= nil))
                    and ((current[1] ~= previous[1])
                        or (current[2] ~= previous[2])
                        or (current[3] ~= previous[3]))) then
                minimapSpots.changed = true;
            end;
        end;
                
        i = i + 1;
        icon = _G["MinimapFrame_Icon" .. i];
    end;
    
    database.SyncWithDatabase(minimapSpots, CalcMinimapRange()); 
    Notify(minimapSpots);
    previousMinimapIcons = minimapIcons;
    return true;
end;

local listeners = {};

function AddListener(key, callback)
    listeners[key] = callback;
end

function RemoveListener(key)
    listeners[key] = nil;
end

function Notify(locations)
    for key, callback in pairs(listeners) do
        callback(key, locations);
    end
end
