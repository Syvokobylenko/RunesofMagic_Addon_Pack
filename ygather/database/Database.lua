
yGather.database = {};

local pairs = pairs;
local ipairs = ipairs;
local dofile = dofile;
local error = error;
local table = table;
local math = math;
local GetTime = GetTime;
local tostring = tostring;

local _G = _G;
local SaveVariables = SaveVariables;
local GetCurrentWorldMapID = GetCurrentWorldMapID
local GetPlayerWorldMapPos = GetPlayerWorldMapPos;
local logger = yGather.logger;
local yGather = yGather;

setfenv(1, yGather.database);

local mData = {}
local mListeners = {};
local mVersion = 2;
local mSIGHTING_INTERVAL = 600;
local mMAX_NO_SIGHTING_COUNT = 10;

local function ImportData(aData)
    local count = 0;   
    if (mData.db == nil) then
        mData.db = {};
    end;
    for zoneId, zoneData in pairs(aData) do
        for matId, matData in pairs(zoneData) do
            for _, location in pairs(matData) do
                if ((location ~= nil) and (location[1] ~= nil) and (location[1] >= 0) and (location[1] <= 1000)
                         and (location[2] ~= nil) and (location[2] >= 0) and (location[2] <= 1000)) then
                    -- location seems to be valid
                    local lZoneData = mData.db[zoneId];
                    if (lZoneData == nil) then
                        lZoneData = {};
                        mData.db[zoneId] = lZoneData;
                    end;
                    
                    local lMatData = lZoneData[matId];
                    if (lMatData == nil) then
                        lMatData = {};
                        lZoneData[matId] = lMatData;
                    end;
                    table.insert(lMatData, {location[1], location[2], location[3], location[4], location[5], location[6]});
                    count = count + 1;
                end;
            end;
        end;
    end;
end

local function ExportSaveData()
    return mData;
end

function HandleVariablesLoaded()
    local saveData = _G["yGather_data"];
    if (saveData == nil) then
        saveData = {version = mVersion, db = {}};
    end;
    
    while (saveData.version ~= mVersion) do
        local oldVersion = saveData.version or 0;
        local convertFunctionFileName = "Interface/Addons/yGather/database/convert/v" .. oldVersion .. "Tov" .. (oldVersion + 1) .. ".lua";
        local convertFunction = dofile(convertFunctionFileName);
        saveData = convertFunction(saveData);
    end
    
    mData = {version = saveData.version};
    ImportData(saveData.db);
    SaveVariables("yGather_data");
    Notify();
end

function HandleSaveVariables()
    _G["yGather_data"] = ExportSaveData();
end

function DumpZone(zoneId, zone)
    if (zone == nil) then
        zone = GetZoneData(zoneId);
    end
    for matId, mat in pairs(zone) do
        for locIdx, location in pairs(mat) do
            logger.user("[" .. zoneId .. "][" .. matId .. "][" .. locIdx .. "]= " .. location[1] .. "," .. location[2]);
        end
    end
end

function Dump()
    for zoneId, zone in pairs(mData.db) do
        DumpZone(zoneId, zone)
    end
end

function ClearZone(zone)
    if (zone == nil) then
        logger.info("clearing current zone");
        zone = GetCurrentWorldMapID();
    end
    mData.db[zone] = {};
    Notify();
    logger.user(yGather.translate("config/clearmsg") .." "..zone);
end

function Clearall()
	mData.db = {};
    Notify();
    logger.user(yGather.translate("config/clearallmsg"));
end

function GetStackCount()
    local stackCount = 0;
    for i, zone in pairs(mData.db) do
        if (zone ~= nil) then
            for matId, stacks in pairs(zone) do
                if (stacks ~= nil) then
                    stackCount = stackCount + #stacks;
                end
            end
        end
    end
    return stackCount;
end

function GetZoneData(zone)
    if (zone == nil) then
        return nil;
    end;
    return mData.db[zone];
end

function GetZoneResourceData(zone, resource)
    if (zone == nil) then
        return nil;
    end;
    if (resource == nil) then
        return nil;
    end;
    
    local zoneData = mData.db[zone];
    if (zoneData == nil) then
        return nil;
    end
    
    return zoneData[resource];
end

function GetEntry(zone, material, x, y)
    local zoneData = mData.db[zone];
    if (zoneData ~= nil) then
        local matData = zoneData[material];
        if (matData ~= nil) then
            for _, entry in ipairs(matData) do
                if ((entry[1] == x) and (entry[2] == y)) then
                    return entry;
                end;
            end;
        end;
    end;
    return nil;
end;

local function GetRoundedEntry(x, y, matData)
    for _, location in ipairs(matData) do
        if ((math.abs(location[1] - x) < 2) and (math.abs(location[2] - y) < 2)) then
            return location;
        end
    end
    return;
end;

function EntryExists(zone, material, x, y)
    return (GetEntry(zone, material, x, y) ~= nil);
end

function GetEntryText(zone, material, x, y)
    local entry = GetEntry(zone, material, x, y);
    if (entry == nil) then
        return nil;
    end
    return entry[6];
end;

function SetEntryText(zone, material, x, y, text)
    local entry = GetEntry(zone, material, x, y);
    if (entry == nil) then
        error("no database entry for zone " .. zone .. ", material " .. material .. " " .. x .. "/" .. y, 1);
    end
    entry[6] = text;
    Notify();
end;

function GetZoneStackCount(zoneId)
    if (zoneId == nil) then
        error("zoneId must not be nil", 2);
    end
    local stackCount = 0;
    local zone = mData.db[zoneId];
    if (zone ~= nil) then
        for matId, stacks in pairs(zone) do
            if (stacks ~= nil) then
                stackCount = stackCount + #stacks;
            end
        end
    end
    return stackCount;
end

function RemoveEntry(zoneId, matId, x, y)
    if (zoneId == nil) then
        error("zoneId must not be nil", 2);
    end
    if (matId == nil) then
        error("matId must not be nil", 2);
    end
    if (x == nil) then
        error("x must not be nil", 2);
    end
    if (y == nil) then
        error("y must not be nil", 2);
    end
    logger.debug("removing entry: " .. zoneId .. ", " .. matId .. ", " .. x .. "/" .. y);
    local zone = mData.db[zoneId];
    if (zone ~= nil) then
        local locations = zone[matId];
        if (locations ~= nil) then
            for index, entry in ipairs(locations) do
                if ((entry[1] == x) and (entry[2] == y)) then
                    table.remove(locations, index);
                    Notify();
                    logger.debug("removed entry: " .. zoneId .. ", " .. matId .. ", " .. x .. "/" .. y);
                    return;
                end;
            end;
        end;
    end;
end;

function AddStackLocation(id, zone, x, y)
    if (id == nil) then
        error("id must not be nil", 2);
    end
    if (zone == nil) then
        error("zone must not be nil", 2);
    end
    if (x == nil) then
        error("id must not be nil", 2);
    end
    if (y == nil) then
        error("id must not be nil", 2);
    end
    
    if ((x < 0) or (x > 1000)) then
        logger.debug("x coordinate is out of range: " .. tostring(x));
        return;
    end;

    if ((y < 0) or (y > 1000)) then
        logger.debug("y coordinate is out of range: " .. tostring(y));
        return;
    end;

    logger.info("adding resource " .. id .. " in " .. zone .. " at (" .. x ..", " .. y .. ")");

    if (mData.db[zone] == nil) then
        mData.db[zone] = {};
    end
    if (mData.db[zone][id] == nil) then
        mData.db[zone][id] = {};
    end
    table.insert(mData.db[zone][id], {x,y});

    Notify();
end

local function IsInDatabase(x, y, matData)
    return (GetRoundedEntry(x, y, matData) ~= nil);
end

local function LocationIsValid(x, y)
    return (x >= 0) and (x <= 1000) and (y >= 0) and (y <= 1000);
end;

local function IsInRange(x, y, refx, refy, squareRange)
    local distX = math.abs(x - refx);
    local distY = math.abs(y - refy);
    local squareDist = distX * distX + distY * distY;
    local inRange = squareDist < squareRange;
    return inRange;
end;

function SyncWithDatabase(locationData, range)
    local timestamp = GetTime();
    
    local zoneId = GetCurrentWorldMapID();
    local zoneData = mData.db[zoneId];
    if (zoneData == nil) then
        zoneData = {};
        mData.db[zoneId] = zoneData;
    end;
    
    local dbChanged = false;
    for _, spot in pairs(locationData.spots) do
        -- process only location types we know (i.e. which have a matId) and which are no USER markers
        local matId = spot.matId;
        if ((matId ~= nil) and (yGather.matdb.GetResourceSkill(matId) ~= "USER")) then
            local x, y = spot.x, spot.y;
            local matData = zoneData[matId];
            if (matData == nil) then
                matData = {};
                zoneData[matId] = matData;
            end
            if (not LocationIsValid(x, y)) then
                logger.warn("invalid location: " .. matId .. " at (" .. x .. ", " .. y .. ") in " .. zoneId);
            else
                local dbEntry = GetRoundedEntry(x, y, matData);

                if ((dbEntry == nil) and locationData.changed) then
                    --[[ add new entries only if the minimap changed; prevents resource clusters when moving while RoM
                    is minimized (minimap is not updated by the client in that case)]]
                    dbEntry = {x, y};
                    table.insert(matData, dbEntry);
                    dbChanged = true;
                end;
                if (nil ~= dbEntry) then
                    dbEntry[3] = timestamp;
                    dbEntry[4] = nil;
                    dbEntry[5] = nil;
                end;
            end;
        end;
    end;
    
    local px, py = GetPlayerWorldMapPos();
    local missingSpots = locationData.missingSpots;
    if (range ~= nil) then
        -- use square range to avoid multiple calculation of square root
        local squareRange = range * range;
        for matId, matData in pairs(zoneData) do
            for locIndex, entry in ipairs(matData) do
                if (entry[3] ~= timestamp) then
                    -- resource stack is missing
                    if (IsInRange(entry[1], entry[2], px * 1000, py * 1000, squareRange)) then
                        -- ... and is in range - check and update timestamps
                        table.insert(missingSpots, {x = entry[1], y = entry[2], matId = matId});
                    end;
                end;
            end;
        end;
    end;
    
    if (dbChanged) then
        Notify();
    end;
end;

function AddListener(key, callback)
    mListeners[key] = callback;
end

function RemoveListener(key)
    mListeners[key] = nil;
end

function Notify()
    for key, callback in pairs(mListeners) do
        callback(key);
    end;
end;
