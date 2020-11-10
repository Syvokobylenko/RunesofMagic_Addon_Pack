--[[ chat message function ]]
function GuildPanel.SendMsg(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg);
end;

--[[ sort functions ]]
function GuildPanel.helpers.SortName(v1,v2)

    -- sort precedence
    if(GuildPanel.Settings["sortOnlineTop"] == 1) then
        if(v1["isOnline"] == 1 and v2["isOnline"] == 0) then
            return true;
        end;

        if(v1["isOnline"] == 0 and v2["isOnline"] == 1) then
            return false;
        end;
    end;

    -- strings have ascii comparison: b > a
    if(v2["name"] > v1["name"]) then
        return true;
    else
        return false;
    end;
end;

function GuildPanel.helpers.SortLevel(v1,v2)
    -- sort precedence
    if(GuildPanel.Settings["sortOnlineTop"] == 1) then
        if(v1["isOnline"] == 1 and v2["isOnline"] == 0) then
            return true;
        end;

        if(v1["isOnline"] == 0 and v2["isOnline"] == 1) then
            return false;
        end;
    end;


    if(v1["level"] > v2["level"]) then
        return true;
    end;

    if(v1["level"] < v2["level"]) then
        return false;
    end;

    -- primary levels are equal
    if(v1["subLevel"] > 0 and v1["subLevel"] > 0) then
        if(v1["subLevel"] > v2["subLevel"]) then
            return true;
        end;

        if(v2["subLevel"] > v1["subLevel"]) then
            return false;
        end;
    end;

    -- secondary classes equal or not available
    return GuildPanel.helpers.SortName(v1,v2);
end;

function GuildPanel.helpers.SortRank(v1,v2)
    -- sort precedence
    if(GuildPanel.Settings["sortOnlineTop"] == 1) then
        if(v1["isOnline"] == 1 and v2["isOnline"] == 0) then
            return true;
        end;

        if(v1["isOnline"] == 0 and v2["isOnline"] == 1) then
            return false;
        end;
    end;

    if(v1["rank"] > v2["rank"]) then
        return true;
    else
        return false;
    end;
end;

function GuildPanel.helpers.SortClass(v1,v2)
    -- sort precedence
    if(GuildPanel.Settings["sortOnlineTop"] == 1) then
        if(v1["isOnline"] == 1 and v2["isOnline"] == 0) then
            return true;
        end;

        if(v1["isOnline"] == 0 and v2["isOnline"] == 1) then
            return false;
        end;
    end;

    if(v1["class"] < v2["class"]) then
        return true;
    elseif(v1["class"] == v2["class"]) then
        return GuildPanel.helpers.SortName(v1,v2);
    else
        return false;
    end;
end;

function GuildPanel.helpers.SortZone(v1,v2)
    -- this will always sort by online/offline status first
    if(v1["isOnline"] == 1 and v2["isOnline"] == 0) then
        return true;
    end;

    if(v1["isOnline"] == 0 and v2["isOnline"] == 1) then
        return false;
    end;

    -- if both are online or offline, sort by zone name
    if(v1["currentZone"] < v2["currentZone"]) then
        return true;
    end;
end;

function GuildPanel.helpers.SortOnline(v1,v2)
    -- first sort all those that have online = 1, then online = 0,
    -- then sort by names, if online, by offline time if offline

    if(v1["isOnline"] == 1 and v2["isOnline"] == 1) then
        return GuildPanel.helpers.SortName(v1,v2);
    end;

    if(v1["isOnline"] == 1 and v2["isOnline"] == 0) then
        -- v1 first
        return true;
    end;

    if(v1["isOnline"] == 0 and v2["isOnline"] == 1) then
        -- v2 first
        return false;
    end;

    if(v1["isOnline"] == 0 and v2["isOnline"] == 0) then
        -- "earlier" offline time wins
        if(v2["logoutSort"] > v1["logoutSort"]) then return true; end;
        if(v1["logoutSort"] > v2["logoutSort"]) then return false; end;
        if(v1["logoutSort"] == v2["logoutSort"]) then return GuildPanel.helpers.SortName(v1,v2); end;
    end;
end;

function GuildPanel.helpers.ParseTime(val)
     local a,b;

     if(string.find(val,GuildPanel.patterns["day"])) then
          -- 2 days 10 hours 17 minutes

          arg = SplitArgString(val);
          a = tonumber(arg[1] * 100 + arg[3]);

          b = tonumber(arg[1]);
          if(b == 1) then b = "1 "..GuildPanel.locale["SingleDay"]; else b = b.." "..GuildPanel.locale["MultiDays"]; end;
     else
          -- 12:22:11
          
          -- match this pattern
          if(string.find(val,"%d%d:%d%d:%d%d")) then
			  
			  a = tonumber(string.sub(val,1,2));
			  a = a + (tonumber(string.sub(val,4,5)) / 100);
			  b = val;
		  else 
			  -- bad data
			  
			  a = -1;
			  b = "???";		
			 
		  end;
     end;

     return a,b;
end;

function GuildPanel.helpers.SortResourceAll(v1,v2)
    if(v1["offset"] < v2["offset"]) then
    	return true;
    end;

    if(v1["offset"] > v2["offset"]) then
    	return false;
    end;

    -- this will trigger for members who contributed and left the guild
    if(v1["name"] == nil or v2["name"] == nil) then
		return false;
    end;
    
    
    if(v1["name"] < v2["name"]) then
    	return true;
    end;

    if(v1["name"] > v2["name"]) then
    	return false;
    end;

    -- same name, same offset, check resid, this is unique
    if(v1["type"] > v2["type"]) then
    	return true;
	else
    	return false;
    end;

end;
