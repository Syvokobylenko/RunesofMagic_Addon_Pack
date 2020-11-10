yGather.iconsets = {};

local logger = yGather.logger;
local settings = yGather.settings;
local table = table;
local unpack = unpack;
local pcall = pcall;
local dofile = dofile;
local pairs = pairs;
setfenv(1, yGather.iconsets);

local mIconsetPath = "Interface/AddOns/yGather/resources";
local mWorldmapSet = {name = nil};
local mSets = {}
local mDefaultSet = {"interface/minimap/minimapicon.tga", 663 / 2048, 678 / 2048, 0, 1, 1, 1, 1};

function LoadIconSets()
    mSets = {};
    local loaded = true;
    for i = 1, 6 do
        local filename = mIconsetPath .. "/iconset." .. i .. ".lua";
        local set = dofile(filename);
        mSets[set.name] = set;
    end;
end
LoadIconSets();

local function NameCompare(arg1, arg2)
    return arg1 < arg2;
end;
--- Gets the names of all available iconsets
-- @return a table with the names of all available iconsets
function GetNames()
    local names = {};
    local loaded = true;
    local i = 1;
    for name, _ in pairs(mSets) do
        table.insert(names, name);
    end;
    table.sort(names, NameCompare);
    return names;
end;

function GetByName(name)
    return mSets[name];
end;

function SetupTexture(texture, setName, matId, skill, color, transparency)
    local textureInfo = nil;
    local set = mSets[setName];
    local colored = false;
    if (nil ~= set) then
        colored = set.coloring or false;
        textureInfo = set[matId];
        if (nil == textureInfo) then
            textureInfo = set[skill];
        end;
    end;
    if (nil == textureInfo) then
        logger.debug("no texture info found for " .. skill .. "(" .. matId .. ") - using default");
        textureInfo = mDefaultSet;
    end;
    
    local path, x1, x2, y1, y2, r, g, b = unpack(textureInfo);
    
    if (nil ~= color) then
        r, g, b = unpack(color);
    end
    
    texture:SetTexture(path);
    texture:SetTexCoord(x1, x2, y1, y2);
    texture:SetAlpha(1 - transparency);
    if (colored) then
        texture:SetColor(r, g, b, 1.0);
    else
        texture:SetColor(1, 1, 1, 1);
    end;
end;
