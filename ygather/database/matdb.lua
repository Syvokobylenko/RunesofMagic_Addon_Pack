yGather.matdb = {};

-- make globals available
local dofile = dofile;
local pcall = pcall;
local pairs = pairs;
local ipairs = ipairs;
local table = table;
local TEXT = TEXT;

local logger = yGather.logger;
local translate = yGather.i18n.translate;

setfenv(1, yGather.matdb);

local idDB = {};
local nameDB = {};
local lumDB = {};
local minDB = {};
local herbDB = {};
local userDB = {};

function LoadDB()
    local db = dofile("Interface/AddOns/yGather/resources/spotnames.lua");

    -- create table indexed by id and indexed by name
    local entry;
    for id, data in pairs(db) do
        local spotname;
        if (id > 4000) then
            spotname = translate(data[1]);
        else
            spotname = TEXT(data[1]);
        end;
        
        entry = {id, spotname, data[2], data[3]};
        idDB[id] = entry;
        nameDB[spotname] = entry;

        if (data[3] == "LUMBERING") then
            table.insert(lumDB, entry);
        end;
        if (data[3] == "MINING") then
            table.insert(minDB, entry);
        end;
        if (data[3] == "HERBLISM") then
            table.insert(herbDB, entry);
        end;
        if (data[3] == "USER") then
            table.insert(userDB, entry);
        end;
    end;
    
    local function sortMats(mat1, mat2)
        return mat1[1] < mat2[1];
    end;
    
    table.sort(idDB, sortMats);
    table.sort(lumDB, sortMats);
    table.sort(minDB, sortMats);
    table.sort(herbDB, sortMats);
end

function Iterator()
    local a, b, c = pairs(idDB);
    return a, b, c;
end;

function LumIterator()
    local a, b, c = ipairs(lumDB);
    return a, b, c;
end;

function MinIterator()
    local a, b, c = ipairs(minDB);
    return a, b, c;
end;

function HerbIterator()
    local a, b, c = ipairs(herbDB);
    return a, b, c;
end;

function UserIterator()
    local a, b, c = ipairs(userDB);
    return a, b, c;
end;

function GetResourceName(id)
    local entry = idDB[id];
    if (entry ~= nil) then
        return entry[2];
    end
end

function GetSkillLevel(id)
    local entry = idDB[id];
    if (entry ~= nil) then
        return entry[3];
    end
end

function GetResourceSkill(id)
    local entry = idDB[id];
    if (entry ~= nil) then
        return entry[4];
    end
end

function GetResourceId(name)
    local entry = nameDB[name];
    if (entry ~= nil) then
        return entry[1];
    end
end;
