--[[
File-Author: Pyrr
File-Hash: fbdddb6297e5c890a233a9022c849155e41ab1ff
File-Date: 2018-04-07T3:10:07Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.table ------------------------------------------------------
local me = {
	name="table",
	exports= {"GetTableVar","SetTableVar","Translate_keytable","IsEmpty" },
	sort = {},
	hasUpdate = false,
	rec_data = {
		--{left, right, i, j},
	},
	count = 100,
}

me.Quicksort = function(data, left, right, i, j, fn)
	if left < right then
		local pivot = me.Separate(data, left, right, i, j, fn)
		if pivot then
			local x1 = me.Quicksort(data, left, pivot - 1)
			local x2 = me.Quicksort(data, pivot + 1 , right)
			if x1 and x2 then
				return true
			else
				return false
			end
		else
			return false
		end
	end
	return true
end
local default_sortfn = function(a,b)
	return a<b
end
me.Separate = function(data, left, right, i, j, fn)
	local i = i or left
	local j = j or right - 1
	local piv = data[right]
	local swap
	while (i<j) do
		while (fn(data[i], piv) and i<right) do
			i = i+1
			if me.count<=0 then
				table.insert(me.rec_data,{left, right, i, j})
				return false
			end
			me.count = me.count - 1
		end
		while ((not fn(data[j], piv)) and j>left) do
			j = j-1
			if me.count<=0 then
				table.insert(me.rec_data,{ left, right, i, j})
				return false
			end
			me.count = me.count - 1
		end
		if i < j  then
			swap = data[i]
			data[i] = data[j]
			data[j] = swap
		end
	end
	if fn(data[i], piv) then
		swap = data[i]
		data[i] = data[right]
		data[right] = swap
	end
	return i
end
me.SortCoroutine = function(data)
	local tbl = data.tbl
	local fn = data.fn
	local l,r,i,j
	while true do
		me.count = data.comparisons
		me.rec_data = data.qs_data
		if #me.rec_data>0 then
			l,r,i,j = unpack(table.remove(me.rec_data))
			if not me.Quicksort(tbl, l, r, i, j, fn) then
				data.qs_data = me.rec_data
				data.tbl = tbl
				coroutine.yield(false)
			end
		else
			break
		end
	end
	coroutine.yield(true)
end
me.SortTimer = function()
	local count=0
	for key, data in pairs(me.sort) do
		local _, x = coroutine.resume(data.coroutine, data)
		if x then
			data.callback(data.tbl)
			me.sort[key] = nil
		else
			count = count + 1
		end
	end
	if count==0 then
		me.UnRegisterOnUpdateHandler("SORT_BIG_TIMER")
		me.hasUpdate = false
	end
end

-- /run local tbl={{1,id=1},{3,id=3},{2,id=2}} pylib.lib.table.SortBig("TEST", tbl, function(a,b) return a.id>b.id end, function(data) for a,b in pairs(data) do print(a,b.id)end end, 10)
--- Sort Big Table FN
me.SortBig = function(key, tbl, sort_fn, callback, comparisons)
	AssertType(comparisons, "comparisons", me:GetFullTableName()..".SortBig", "nil","number");
	AssertType(sort_fn, "sort_fn", me:GetFullTableName()..".SortBig", "nil","function");
	AssertType(tbl, "tbl", me:GetFullTableName()..".SortBig", "table");
	AssertType(key, "key", me:GetFullTableName()..".SortBig", "string");
	AssertType(callback, "callback", me:GetFullTableName()..".SortBig", "function");
	me.sort[key] = {
		--fn = sort_fn or default_sortfn,
		fn = sort_fn,
		callback = callback,
		comparisons = comparisons or 1000,
		coroutine = coroutine.create(me.SortCoroutine),
		tbl = tbl,
		qs_data = {{1,#tbl,nil,nil}},
	}
	if me.hasUpdate==false then
		me.RegisterOnUpdateHandler("SORT_BIG_TIMER", me.SortTimer)
		me.hasUpdate = true
	end
end

--- Replace varArgs by (.*)
-- @param keys (table, string) the Table which contains the parts of the key
-- @return key (string)
--
me.Translate_keytable = function(keys)
	AssertType(keys, "keys", me:GetFullTableName()..".Translate_keytable", "table","string","number");
	if type(keys)=="table" then
		Assert(#keys>=1, me:GetFullTableName()..".Translate_keytable","#keys>=1")
		local tmp = tostring(keys[1])
		for i=2, #keys do
			tmp = tmp.."."..tostring(keys[i])
		end
		return tmp
	end
	return tostring(keys)
end
--- Returns value of table
-- @param tbl (table) Table to look for the value
-- @param key (string, number, table) key of the searched value
-- @param default (any) default value if key not found,
-- @return value (any)
--
me.GetTableVar = function(tbl, key, default)
	AssertType(tbl, "tbl", me:GetFullTableName()..".GetTableVar", "table","nil");
	key = me.Translate_keytable(key)
	AssertType(key, "key", me:GetFullTableName()..".GetTableVar", "string", "nil");
	local key, key2 = string.match(key or "", "^([^.]+)%.*(.*)$")
	if key==nil or tbl==nil then
		return default
	end
	if tbl[key]==nil then
		if string.match(key, "^%d+$") then
			key = tonumber(key)
		end
	end
	if key2=="" then
		return tbl[key] or default
	end
	return me.GetTableVar(tbl[key], key2, default)
end
--- Returns value of table
-- @param tbl (table) Table to look for the value
-- @param key (string, number, table) key of the searched value
-- @return value (any)
--
me.SetTableVar = function(tbl, key, value)
	key = me.Translate_keytable(key)
	if type(tbl)=="table" then
		local key, key2 = string.match(key or "", "^([^.]+)%.*(.*)$")
		if key2==nil and key==nil then
			me:GetTableRoot().Error(me:GetFullTableName()..".SetTableVar",3, "Error Setting Table var! key is nil")
			return
		end
		if string.match(key2 or "", "^%s*$") then key2=nil end
		if key2==nil then
			if string.match(key, "^%d+$") then
				key=tonumber(key)
			end
			tbl[key]=value
			return
		end
		me.SetTableVar(tbl[key] or {}, key2, value)
	else
			me:GetTableRoot().Error(me:GetFullTableName()..".SetTableVar",3, "Error Setting Table var! tbl isn't a table")
	end
end
--- Checks if table is empty
me.IsEmpty = function(tbl)
	AssertType(tbl, "tbl", me:GetFullTableName()..".IsEmpty", "table");
	for _, _ in pairs(tbl) do return false end
	return true
end
--- Merges Values of Table into other if not set
-- @param orig (table) Table to insert value
-- @param new (table)	table to get value
me.Merge = function (orig, new, ...)
	AssertType(orig, "orig", me:GetFullTableName()..".Merge", "table");
	AssertType(new, "new", me:GetFullTableName()..".Merge", "table", "nil")
	if new == nil then
		return orig
	end;
	for a, b in pairs(new) do
		if orig[a] == nil then
			orig[a] = b
		elseif type(orig[a])=="table" and type(b)=="table" then
			me.Merge(orig[a], b)
		end
	end
	return me.Merge(orig, ...)
end

--- Adds Values of (Array like) Table into other
-- @param orig (table) Table to insert value
-- @param new (table)	table to get value
me.Add = function (orig, new, ...)
	AssertType(orig, "orig", me:GetFullTableName()..".Add", "table");
	AssertType(new, "new", me:GetFullTableName()..".Merge", "table", "nil")
	if new == nil then
		return orig
	end;
	for a, b in pairs(new) do
		table.insert(orig, b)
	end
	return me.Add(orig, ...)
	
end

--- Deletes Duplicates in (Array like) Tables
-- @param tbl (table) Table
--/run print(unpack(pylib.lib.table.DeleteDuplicate({1,1,2,3,4,5})))
me.DeleteDuplicate = function (tbl)
	AssertType(tbl, "tbl", me:GetFullTableName()..".DeleteDuplicate", "table");
	local tmp = {}
	for i = #tbl, 1, -1 do
		if tmp[ tbl[i] ] then
			table.remove(tbl, i)
		else
			tmp[ tbl[i] ] = true
		end
	end
	return tbl
end

--- Translates values of array like table into keys
-- @param tbl (table) Table
me.Translate = function(tbl)
	local ret = {}
	for a, b in pairs(tbl) do
		ret[b] = true
	end
	return ret;
end
--- Compares 2 tables
me.Compare2 = function(tbl1, tbl2, keys)
	for key, value in pairs(tbl1) do
		if keys then
			if tbl2[key]==nil then
				return false
			elseif type(value)=="table" then
				if not me.Compare2(value, tbl2[key], keys) then
					return false
				end
			end
		else
			if type(value)==type(tbl2[key]) then
				if type(value)=="table" then
					if not me.Compare2(value, tbl2[key], keys) then
						return false
					end
				else
					return value==tbl2[key]
				end
			else
				return false
			end
		end
	end
	return true
end
me.Compare = function(tbl1, tbl2)
	AssertType(tbl1, "tbl1", me:GetFullTableName()..".Compare", "table");
	AssertType(tbl2, "tbl2", me:GetFullTableName()..".Compare", "table");
	return me.Compare2(tbl1, tbl2) and me.Compare2(tbl2, tbl1, true)
end

lib.CreateTable(me,name,path, lib)
