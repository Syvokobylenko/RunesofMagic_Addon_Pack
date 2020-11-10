--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.string ------------------------------------------------------
local me = { 
	imports = {
		[lib.table:GetFullTableName()]="GetTableVar",
	}, 
	exports={
		"ReplaceVarArg","ReplaceSysString","ReplaceRegex", "ReplaceByArg" ,"GetLocaVar"
	}
}

--- Replace varArgs by (.*)
-- @param txt (table, string) the String which should get replaced
-- @return txt (table, string)
--
me.ReplaceVarArg = function(txt)
	AssertType(txt, "txt", me:GetFullTableName()..".ReplaceVarArg", "table","string");
	local ret = ""
	if type(txt)=="table" then
		ret = {}
		for a,b in pairs(txt) do
			ret[a] = me.ReplaceVarArg(b)
		end
	elseif type(txt)=="string" then
		return (string.gsub(txt, "%[%$VAR%d%]", "(.*)")) -- Replace VarX by (.*)
	end
	return ret
end
--- Resolves given string (ReplaceKeyword, TEXT)
-- @param txt (table, string)
-- @return txt (table, string)
--
me.ReplaceSysString = function(txt)
	AssertType(txt, "txt", me:GetFullTableName()..".ReplaceSysString", "table","string");
	local ret = ""
	if type(txt)=="table" then
		ret = {}
		for a,b in pairs(txt) do
			ret[a] = me.ReplaceSysString(b)
		end
	elseif type(txt)=="string" then
		return GetReplaceSystemKeyword(TEXT(txt))
	end
	return ret
end
--- Replace all Regex values
-- @param txt (table, string)
-- @return txt (table, string)
--
me.ReplaceRegex = function(txt)
	AssertType(txt, "txt", me:GetFullTableName()..".ReplaceRegex", "table","string");
	local ret = ""
	if type(txt)=="table" then
		ret = {}
		for a,b in pairs(txt) do
			ret[a] = me.ReplaceRegex(b)
		end
	elseif type(txt)=="string" then
		--txt = string.gsub(txt, "%[%$VAR%d%]", "(.*)") -- Replace VarX by (.*)
		txt = string.gsub(string.gsub(txt, "%(", "%%("),"%)","%%)") -- Replace ( ) by %(%)
		txt = string.gsub(string.gsub(txt, "%[", "%%["),"%]","%%]") -- Replace [ ] by %[%]
		txt = string.gsub(txt, "%?", "%%?") -- Replace ? by %?
		txt = string.gsub(txt, "%.", "%%.") -- Replace . by %.
		return txt
	end
	return ret
end
--- Applies functions to the given string
-- @param tbl table {txt, sysstring, regex, vararg} OR {{txt, sysstring, regex, vararg},{...},{...},...}
-- @return txt (table, string)
--
me.ReplaceByArg = function(tbl)
	AssertType(tbl, "tbl", me:GetFullTableName()..".ReplaceByArg", "table");
	if type(tbl)~="table" then
		return tbl
	end
	if type(tbl[1])=="table" then
		for a,b in pairs(tbl) do
			tbl[a] = me.ReplaceByArg(b)
		end
		return tbl
	else
		local txt = tbl[1]
		txt = tbl[2] and me.ReplaceSysString(txt) or txt
		txt = tbl[4] and me.ReplaceVarArg(txt) or txt
		txt = tbl[3] and me.ReplaceRegex(txt) or txt
		return txt
	end
end
--- returns the loca Value of a loca table.
-- @param tbl table - local table
-- @param key string - key of searched Locavalue
-- @return txt any
-- @return key string
--
me.GetLocaVar = function(tbl, key)
	local txt = me:GetTableVar(tbl,key)
	local typ = type(txt)
	if typ=="string" or typ=="number" then
		return txt, key
	end
		return key, typ
end
lib.CreateTable(me,name,path, lib)
