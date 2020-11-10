yGather.minimapHighlight = {};

-- this package needs following globals
local yGMatdb = yGather.matdb;
local logger = yGather.logger;
local settings = yGather.settings;

local GetMinimapIconText = GetMinimapIconText;

local _G = _G;
local math = math;
local pairs = pairs;
local tostring = tostring;
local type = type;

setfenv(1, yGather.minimapHighlight);

local HIGHLIGHT_ON_MINIMAP_SETTING = "highlightOnMinimap/";

function SetHighlight(matId, highlight)
    if (type(matId) ~= "number") then
        logger.error("SetHighlight: matId must be a number");
    end;
    if (false == highlight) then
        settings.ResetValue(HIGHLIGHT_ON_MINIMAP_SETTING .. matId);
    else
        settings.SetValue(HIGHLIGHT_ON_MINIMAP_SETTING .. matId, true);
    end;
end;

function GetHighlight(matId)
    if (type(matId) ~= "number") then
        return false;
    end;
    
    return settings.GetValue(HIGHLIGHT_ON_MINIMAP_SETTING .. matId,  false);
end;

function OnLoad(frame)
    local id = frame:GetID();
    local romIconName = "MinimapFrame_Icon" .. id;
    local romIcon = _G[romIconName];
    if (nil == romIcon) then
        return;
    end;
    frame.yGRoMIcon = romIcon;
    frame.yGRoMIconId = romIcon:GetID();
    frame.yGTexture = _G[frame:GetName() .. "_Texture"];
    frame.yGTexture:Hide();
    frame:ClearAllAnchors();
    frame:SetAnchor("TOPLEFT", "TOPLEFT", romIconName, -5, -5);
    frame:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", romIconName, 5, 5);
end;

local UPDATE_INTERVAL = 0.1;
local mElapsedTime = 0;
local previousText = nil;

function OnShow(frame)
    local iconName = GetMinimapIconText(frame.yGRoMIconId);
    if (iconName ~= frame.yGPreviousIconName) then
        frame.yGPreviousIconName = iconName;
        local matId = yGMatdb.GetResourceId(iconName);
        if (GetHighlight(matId)) then
            frame.yGTexture:Show();
        else
            frame.yGTexture:Hide();
        end;
    end;
end;

function OnUpdate(frame, aElapsedTime)
    -- mElapsedTime = mElapsedTime + aElapsedTime;
    -- if (mElapsedTime >= UPDATE_INTERVAL) then
        -- mElapsedTime = 0;
        -- if (not frame.yGRoMIcon:IsVisible()) then
            -- frame.yGTexture:Hide();
            -- return;
        -- end;
        -- local text = GetMinimapIconText(frame.yGRoMIconId);
        -- local matId = yGMatdb.GetResourceId(text);
        -- if (GetHighlight(matId)) then
            -- frame.yGTexture:Show();
        -- else
            -- frame.yGTexture:Hide();
        -- end;
    -- end;
end;
