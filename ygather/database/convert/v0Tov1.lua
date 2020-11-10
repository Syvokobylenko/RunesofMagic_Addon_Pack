return function (oldDatabase)
    local newDatabase = {};
    local idTable = dofile("Interface/Addons/yGather/database/convert/v0Tov1IdTable.lua");
    for zoneId, zoneData in pairs(oldDatabase) do
        if (newDatabase[zoneId] == nil) then
            newDatabase[zoneId] = {};
        end
        for oldResourceId, oldData in pairs(zoneData) do
            local newResourceId = idTable[oldResourceId];
            if (newResourceId ~= nil) then
                if (newDatabase[zoneId][newResourceId] == nil) then
                    newDatabase[zoneId][newResourceId] = {};
                end
                newData = newDatabase[zoneId][newResourceId];
                for _, stackLocation in pairs(oldData) do
                    table.insert(newData, {["x"] = stackLocation.x, ["y"] = stackLocation.y, ["text"] = stackLocation.text});
                end;
            else
                yGather.logger.warn("db convert v0 to v1: unknown database id (" .. tostring(oldResourceId) .. ")");
            end;
        end;
    end;
    newDatabase.version = 1;
    return newDatabase;
end
