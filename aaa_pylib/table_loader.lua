--[[
File-Author: Pyrr
File-Hash: 1d5beb41ecf22c812c5978294ab4bcd578fc7afb
File-Date: 2017-10-21T12:59:59Z
]]
local me = {version=tonumber("20171021125959") or 1}
if not DEV_FLAG and ptl and ptl.version >= me.version then return end -- don't overwrite newer version with old one
_G.ptl = me;
local error = error
local setmetatable = setmetatable
local getmetatable = getmetatable
local table = table
--- Returns the name of the library table (e.g. string)
-- @param tbl (table) The library table
--
me.GetTableName = function(tbl)
	return tbl.name
end
--- Returns the full name of the library table (e.g. pylib.lib.string)
-- @param tbl (table) The library table
--
me.GetFullTableName = function(tbl)
	if tbl:GetTableParent()==nil then
		return tbl:GetTableName()
	end
	return tbl:GetTableParent():GetFullTableName().."."..tbl:GetTableName()
end
--- Returns the parent of the library table (e.g. pylib for pylib.lib)
--- returns nil if parent is global namespace (_G)
-- @param tbl (table) The library table
--
me.GetTableParent = function(tbl)
	if tbl.parent==_G then return nil end
	return tbl.parent
end
me.PrintTableTree = function(tbl)
	local tree = tbl:GetTableTree()
	local ptn = ""
	for _,b in ipairs(tree) do
		ptn = string.rep("-", b[2])
		printf("%s> %s",ptn, b[1]:GetTableName())
	end
end
me.PrintTableTreeFunctions = function(tbl, all)
	local tree = tbl:GetTableTree()
	local ptn = ""
	for a, b in pairs(me) do
		if type(b)=="function" then
			printf(">|cffffff00%s", a) --yellow
		end
	end
	for _, tbl in ipairs(tree) do
		ptn = string.rep("-", tbl[2])
		printf("%s%s",ptn, tbl[1]:GetTableName())
		local fn = {}
		for _, name in ipairs(tbl[1].fn or {}) do
				local typ = type(tbl[1][name])
				if typ=="function" then
					printf("%s-> |cffff0000%s [%s]",ptn, name, typ) --red
				else
					printf("%s-> |cff00ff00%s [%s]",ptn, name, typ) --green
			end
			fn[name]=true
		end
		if all then
			for _, name in ipairs(tbl[1].exports or {}) do
				if not fn[name] then
					local typ = type(tbl[1][name])
					if typ=="function" then
						printf("%s-> |cffffaa00%s [%s]",ptn, name, typ) --orange
					else
						printf("%s-> |cffaaffaa%s [%s]",ptn, name, typ) --light green
					end
					fn[name]=true
				end
			end
		end
	end
end
--- Returns the children of a table
-- @param tbl (table) The library table
--
me.GetTableChildren = function(tbl, root)
	local root = root or tbl:GetTableRoot()
	local lst = {}
	for a, b in pairs(root.libs or {}) do
		if b:GetTableParent()==tbl then
			table.insert(lst, b)
		end
	end
	return lst, root
end
--- Returns the Children Tree of a table
-- @param tbl (table) The library table
--/run for a,b in ipairs(pylib:GetTableTree()) do print(b[1]) end
me.GetTableTree = function(tbl, root, lst, level)
	level = level or 1
	lst = lst or {}
	root = root or tbl:GetTableRoot()
	if level == 1 then
		table.insert(lst, {root, 0})
	end
	local children = tbl:GetTableChildren(root)
	for _, b in ipairs(children) do
		table.insert(lst, {b, level})
		lst = me.GetTableTree(b, root, lst, level+1)
	end
	return lst
end
--- Returns the root of the library table (e.g. pylib)
-- @param tbl (table) The library table
-- e.g. pylib.lib.string:GetTableRoot() => pylib
--
me.GetTableRoot = function(tbl)
	local parent = tbl:GetTableParent()
	if parent==nil then return tbl end
	return parent:GetTableRoot() or parent
end
--- Returns the path of the library file (e.g. Interface/AddOns/AA_PYLib/core.lua for pylib)
-- @param tbl (table) The library table
--
me.GetTablePath=function(tbl)
	local path = tbl.path
	if type(path)~="string" then return "" end
	if tbl==tbl:GetTableRoot() then
		path = path.."/"..tbl:GetFullTableName()..".lua"
	else
		path = path..".lua"
	end
	return path
end
me.GetTableDir=function(tbl, del)
  local path = tbl.path
  if type(path)~="string" then return "" end
  if del then
	return string.match(path, "(.*/)[^/]+$") or path
  end
  return path
end
local meta = {
	__tostring = me.GetFullTableName,
	__index = function(tbl, key) if type(me[key])=="function" then return me[key] end return nil end,
	}
local CreateMeta = function(tbl)
	setmetatable(tbl, meta);
end
--- Loads all Children of given library
-- @param tbl (table) The library table
--
local LoadChildren=function(tbl)
	if type(tbl.children)=="table" then
		for i=1, #tbl.children do
			local name, path = unpack(tbl.children[i])
			path = tbl.path..path;
			local status, ret = sloadfile(path..".lua", print, tbl, name, path)
		end
	end
end
--- Creates a library table
-- @param tbl (table) The library table
-- @param name (string or nil) The library name
-- @param path (path or nil) The library path
-- @param parent (table or nil) The parent of the library table
--
me.CreateTable = function(tbl, name, path, parent)
	tbl = tbl or {}
	tbl.name = tbl.name or name
	tbl.path = tbl.path or path
	tbl.parent = tbl.parent or parent
	CreateMeta(tbl)
	local root = tbl:GetTableRoot()
	if root == tbl then tbl.libs = {} end
	tbl.exports = tbl.exports or {}
	tbl.fn = tbl.fn or {}
	local fn = {}
	for _, b in ipairs(tbl.exports) do
		if not fn[b] then
			table.insert(tbl.fn, b)
			fn[b] = true
		end
	end
	tbl.imports = tbl.imports or {}
	for a,b in pairs(tbl.imports) do
		if root.libs[a] and type(root.libs[a])=="table" then
			if type(b)=="string" then
				tbl[b] = root.libs[a][b]
			else
				for c,d in pairs(root.libs[a].exports) do
					tbl[d] = root.libs[a][d]
					table.insert(tbl.exports, d)
				end
			end
		end
	end
	for _,b in ipairs(tbl.parent.exports or {}) do
	if not tbl[b] then
		tbl[b] = tbl.parent[b]
	end
		table.insert(tbl.exports, b)
	end
	--print(root:GetFullTableName(), tbl:GetFullTableName())
	root.libs[tbl:GetFullTableName()] = tbl
	tbl.parent[tbl.name] = tbl -- register lib in parent
	if tbl._Init then tbl._Init(false) end
	LoadChildren(tbl)
	if tbl._Init then tbl._Init(true) end
	return tbl
end
