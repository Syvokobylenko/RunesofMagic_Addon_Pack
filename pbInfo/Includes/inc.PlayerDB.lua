--[[
pbInfo - Includes/inc.PlayerDB.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
function pbInfo.PlayerDB.ParseGroupSearch()
--if (pbIsEmpty(pbInfo.RealmName)) then
--	return false;
--end;
	local total = GetSearchGroupResult(-1);
	if (type(pbInfo.PlayerDB.Players[pbInfo.RealmName]) ~= "table") then
		pbInfo.PlayerDB.Players[pbInfo.RealmName] = {}
	end;
	for i = 1, total, 1 do
		local _name, _mC, _mL, _sC, _sL, _title, _guild, _zone, _world = GetSearchGroupResult(i);
		pbInfo.PlayerDB.Players[pbInfo.RealmName][_name] = {
			["name"] 	= _name,
			["mC"] 		= _mC,
			["mL"] 		= _mL,
			["sC"] 		= _sC,
			["sL"] 		= _sL,
			["title"] 	= _title,
			["guild"] 	= _guild,
			["zone"] 	= _zone,
			["channel"] = string.match(_world, "%d");
			["_time"] 	= GetTime();
		};
	end;
	
	pbInfoPlayers = nil;
	if (pbInfoSettings["PLAYERINFOSAVEDATA"]) then
		pbInfoPlayers = pbInfo.PlayerDB.Players;
	end;
	return false;
end;