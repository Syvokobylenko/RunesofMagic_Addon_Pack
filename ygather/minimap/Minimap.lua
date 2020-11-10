yGather.minimap = {};

-- this package needs following globals
local GetPlayerWorldMapPos = GetPlayerWorldMapPos;
local GetMinimapIconText = GetMinimapIconText;
local GetCurrentWorldMapID = GetCurrentWorldMapID;
local MinimapViewFrame = MinimapViewFrame;
local WorldMapFrame = WorldMapFrame;
local _G = _G;
local math = math;
local unpack = unpack;
local pairs = pairs
local table = table;

local logger = yGather.logger;
local yGather = yGather;
local yGMatdb = yGather.matdb
local SettingsGetValue = yGather.settings.GetValue;

setfenv(1, yGather.minimap);

local mFrame = nil;
local mElapsedTime = 0;
local mLastUpdatePosition = {0, 0};

--[[ scaling variables ]]
local mFirstScalePosition = nil;
local mMaxDistScalePosition = nil;
scaleReference = "dummy";

-- constants
local MINIMAL_MOVEMENT = 0.001;
local UPDATE_TIME = 0.5;
local MAX_ICONS = 30;

-- local copies of current settings
local settings = {};


local mVisibleIcons = {};
local function ConfigureIconsAndTextures()
    local skill;
    local color;
    local iconSize = settings["iconSize"];
    local setName = settings["iconSet"];
    local transparency = settings["iconTransparency"];
    local px, py = GetPlayerWorldMapPos();
    local sx, sy = watch.CalcMinimap2WorldScaling()
    if (sx == nil) then
        return;
    end;
    
    for _, iconAndTexture in pairs(mVisibleIcons) do
        icon = iconAndTexture[1]
        skill = yGMatdb.GetResourceSkill(icon.yGMatId);
        color = settings[skill];
        yGather.iconsets.SetupTexture(iconAndTexture[2], setName, icon.yGMatId, skill, color, transparency);

        icon:ClearAllAnchors();
        icon:SetAnchor("CENTER", "CENTER", "MinimapViewFrame", (icon.yGWorldMapX - px) * sx, (icon.yGWorldMapY - py) * sy);            
        icon:SetWidth(iconSize);
        icon:SetHeight(iconSize);
    end;
end

local function SetIconsPositions()
    local sx, sy = watch.CalcMinimap2WorldScaling()
    if (sx == nil) then
        return;
    end;
    local px, py = GetPlayerWorldMapPos();
    for _, iconAndTexture in pairs(mVisibleIcons) do
        icon = iconAndTexture[1]
        icon:ClearAllAnchors();
        icon:SetAnchor("CENTER", "CENTER", "MinimapViewFrame", (icon.yGWorldMapX - px) * sx, (icon.yGWorldMapY - py) * sy);            
    end;
end;

local function UpdateIconParameters(listener, minimapSpots)
    mVisibleIcons = {};

    if (not SettingsGetValue("minimap/showResources")) then
        return;
    end;
    
    local mmIcon = nil;
    local mmTexture= nil;
    local skillLevel = nil;
    local i = 1;
    for _, spot in pairs(minimapSpots.missingSpots) do
        if (i <= MAX_ICONS) then
            mmIcon = _G["yGather_MinimapFrame_Icon" .. i];
            mmTexture = _G["yGather_MinimapFrame_Icon" .. i .. "_Texture"];
            mmIcon.yGWorldMapX = spot.x / 1000;
            mmIcon.yGWorldMapY = spot.y / 1000;
            mmIcon.yGMatId =  spot.matId;
            mmIcon.yGName = yGMatdb.GetResourceName(spot.matId);
            mmIcon.yGZoneId = GetCurrentWorldMapID();
            
            skillLevel = yGMatdb.GetSkillLevel(spot.matId);
            if ((skillLevel ~= nil) and (skillLevel > 0)) then
                mmIcon.yGName = mmIcon.yGName .. " (" .. skillLevel .. ")";
            end
            mmIcon:Show();
            table.insert(mVisibleIcons, {mmIcon, mmTexture});
            i = i + 1;
        end;
        
    end;
    
    for j = i, MAX_ICONS do
        _G["yGather_MinimapFrame_Icon" .. j]:Hide();
    end
    
    ConfigureIconsAndTextures();
end;

local function HideAllIcons()
    for i = 1, MAX_ICONS  do
        _G["yGather_MinimapFrame_Icon" .. i]:Hide();
    end;
    mVisibleIcons = {};
end;

local function HandleSettingsChanged(listener)
    settings["showResources"] = SettingsGetValue("minimap/showResources");
    settings["iconSet"] = SettingsGetValue("minimap/iconSet");
    settings["iconTransparency"] = SettingsGetValue("minimap/iconTransparency", 0);
    settings["LUMBERING"] = SettingsGetValue("minimap/iconWoodColor");
    settings["MINING"] = SettingsGetValue("minimap/iconOreColor");
    settings["HERBLISM"] = SettingsGetValue("minimap/iconHerbsColor");
    settings["iconSize"] = SettingsGetValue("minimap/iconSize");
    
    if (not settings["showResources"]) then
        HideAllIcons();
        return;
    end;
end;

function OnLoad(aFrame)
    mFrame = aFrame;
    watch.AddListener(aFrame, UpdateIconParameters);
    yGather.settings.AddListener(aFrame, HandleSettingsChanged);
end

function OnUpdate(aFrame, aElapsedTime)
    local oldx, oldy = unpack(mLastUpdatePosition);
    local x, y = GetPlayerWorldMapPos();
    
    --[[ GetPlayerWorldMapPos may return nil (e.g. during transport) ]]
    if (not x or not y) then
        return;
    end;
    
    mElapsedTime = mElapsedTime + aElapsedTime;
    if ((math.abs(oldx - x) > MINIMAL_MOVEMENT) or (math.abs(oldy - y) > MINIMAL_MOVEMENT)
            or (mElapsedTime >= UPDATE_TIME)) then
        mLastUpdatePosition = {x, y};
        mElapsedTime = 0;
        Scale(scaleReference);
        if (not watch.CheckMinimap() and (#mVisibleIcons > 0)) then
            HideAllIcons();
        end;
		-- Hide the mats in minimap in the Ystra Event Zone
		-- if (GetCurrentWorldMapID()==5) then
			-- HideAllIcons();
		-- end;		
    end;
    SetIconsPositions();
end

function Scale(iconName)
    local icon = GetIcon(iconName);
    if (icon == nil) then
        mFirstScalePosition = nil;
        mMaxDistScalePosition = nil;
        return;
    end
    
    local x,y = icon:GetCenter();
    local px, py = GetPlayerWorldMapPos();
    if (mFirstScalePosition == nil) then
        mFirstScalePosition = {player = {px, py}, icon = {x, y}};
        return;
    end
    
    if (mMaxDistScalePosition == nil) then
        mMaxDistScalePosition = {player = {px, py}, icon = {x, y}};
        return;
    end
    
    local oldDx = math.abs(mFirstScalePosition.icon[1] - mMaxDistScalePosition.icon[1]);
    local oldDy = math.abs(mFirstScalePosition.icon[2] - mMaxDistScalePosition.icon[2]);
    local dx = math.abs(mFirstScalePosition.icon[1] - x);
    local dy = math.abs(mFirstScalePosition.icon[2] - y);
    
    if (dx > oldDx) then
        mMaxDistScalePosition.icon[1] = x;
        mMaxDistScalePosition.player[1] = px;
    end
    
    if (dy > oldDy) then
        mMaxDistScalePosition.icon[2] = y;
        mMaxDistScalePosition.player[2] = py;
    end
    
    if ((dx > oldDx) or (dy > oldDy)) then
        dx = math.abs(mFirstScalePosition.icon[1] - mMaxDistScalePosition.icon[1]);
        dy = math.abs(mFirstScalePosition.icon[2] - mMaxDistScalePosition.icon[2]);
        pdx = math.abs(mFirstScalePosition.player[1] - mMaxDistScalePosition.player[1]);
        pdy = math.abs(mFirstScalePosition.player[2] - mMaxDistScalePosition.player[2]);
        local minimapZoom = yGather.minimapZoom;
        local minimapRealScale = MinimapViewFrame:GetRealScale();

        local scaleX = dx / minimapRealScale / minimapZoom / pdx;
        local scaleY = dy / minimapRealScale / minimapZoom / pdy;
        logger.user("Scale: " .. scaleX .. ", " .. scaleY);
    end
    
end

function GetIcon(name)
    local i = 1;
    local icon = _G["MinimapFrame_Icon" .. i];
    while (icon ~= nil) do
        local text = GetMinimapIconText(icon:GetID());
        if (icon:IsVisible() and (text == name)) then
            return icon;
        end;
        i = i + 1;
        icon = _G["MinimapFrame_Icon" .. i];
    end;
    return nil;
end
