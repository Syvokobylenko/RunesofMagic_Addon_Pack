--[[
File-Author: Pyrr
File-Hash: 1d5beb41ecf22c812c5978294ab4bcd578fc7afb
File-Date: 2017-10-21T12:59:59Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.num ------------------------------------------------------
local me = {
	exports = {"AddThousandSeparator", "Round", "ToString"},
	children = {
		{"vector", ".vector"},
	},
}
--- Returns formatted number
-- @param str (number, string) number
-- @param sep (string) Separator
-- @return formatted string
--
me.AddThousandSeparator = function (str, sep, sep2)
	AssertType(str, "str", me:GetFullTableName()..".AddThousandSeparator", "string", "number");
	sep = type(sep)=="string" and sep or "."
	sep2 = type(sep2)=="string" and sep2 or ","
	str = string.gsub(str, "%.", ",")
	while true do
		local k = nil;
		str, k = string.gsub(str, "^(-?%d+)(%d%d%d)",'%1' .. sep .. '%2');
		if k == 0 then
			break;
		end;
	end;
	return str
end
--- Rounds number to x digits
-- @param number (number) number
-- @param round (number) cumber of digits to round
-- @return rounded number
--
me.Round = function(number, round)
	AssertType(number, "number", me:GetFullTableName()..".Round",	"number");
	round = type(round)=="number" and round or 0
	if round > 0 then
		local fac = 10^round
		number = number*fac
		number = math.floor(number+0.5)
		number = number / fac
	end
	return number
end
--- Return Number as formatted String
-- @param number (number) number
-- @param round (number) number of digits to round
-- @param sep (any) thousand separator
-- @return formatted number
--
me.ToString = function(number, round, sep)
	AssertType(number, "number", me:GetFullTableName()..".ToString",	"number");
	number = me.Round(number, round)
	if sep ~= nil then
		number = me.AddThousandSeparator(tostring(number), sep)
	end
	return number
end

lib.CreateTable(me,name,path, lib)
