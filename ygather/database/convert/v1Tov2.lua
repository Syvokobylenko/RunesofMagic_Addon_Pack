return function (v1Data)
    local v2Data = {};
    local database = {};
    v2Data.db = database;
    
    for zoneId, zoneData in pairs(v1Data) do
        if (type(zoneData) == "table") then
            if (database[zoneId] == nil) then
                database[zoneId] = {};
            end
            for matId, matData in pairs(zoneData) do
                if (database[zoneId][matId] == nil) then
                    database[zoneId][matId] = {};
                end
                local v2MatData = database[zoneId][matId];
                for _, stackLocation in pairs(matData) do
                    local newEntry = {}
                    newEntry[1] = stackLocation.x;
                    newEntry[2] = stackLocation.y;
                    newEntry[6] = stackLocation.text;
                    table.insert(v2MatData, newEntry);
                end;
            end;
        end;
    end;
    v2Data.version = 2;
    return v2Data;
end
