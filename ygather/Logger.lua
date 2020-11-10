if (yGather == nil) then
    yGather = {}
end

yGather.logger = {};

local out = DEFAULT_CHAT_FRAME;

setfenv(1, yGather.logger);

mLevel = 1;
mLevels = {"error", "warn", "info", "dbg", "trace"};
mLevelColor = {"ffFF0000", "ffFFFF00", "ff00FF00", "ff00FFFF", "ffFF90FF"};

function setLevel(level)
    if ((level < 0) or (level > 5)) then
        return;
    end
    mLevel = level;
end;

function user(message)
    out:AddMessage(message);
end;

function log(level, message)
    local name = "yGather";
    if (mLevel >= level) then
        out:AddMessage(name .. " " .. mLevels[level] .. "|c" .. mLevelColor[level] .. " " .. message .. "|r ");
    end;
end;

function error( message)
    log(1, message);
end

function warn(message)
    log(2, message);
end;

function info(message)
    log(3, message);
end;

function debug(message)
    log(4, message);
end;

function trace(message)
    log(5, message);
end;
