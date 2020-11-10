--[[
File-Author: Pyrr
File-Hash: 8ff1c09e6901ad8f19e16942bf88c24694ef06fa
File-Date: 2018-01-31T11:48:22Z
]]
local lib,name,path = ...

PY_LIB_HOOKS = PY_LIB_HOOKS or {}
------------------------------------------------------ lib.hook ------------------------------------------------------
local me = {
	exports = {
		"AddHook", "RemoveHook", "ClearHooks"
	},
	imports = {
		[lib.table:GetFullTableName()] = true
	},
	HookList = PY_LIB_HOOKS,
}
me._Init = function(val)
	if val then return end
	me.RegisterEventHandler("SAVE_VARIABLES","PYLIB_HOOK", function()
		me.SendEvent("UNREGISTER_HOOKS") 
			me.ClearHooks()
	end)
	me.RegisterEventHandler("VARIABLES_LOADED","PYLIB_HOOK", function() me.SendEvent("REGISTER_HOOKS") end)

end
me.ClearHooks = function()
	local list = {}
	for name,b in pairs(me.HookList) do
		for i, tbl in ipairs(me.HookList[name]) do
			table.insert(list, {name, tbl[1], tbl[2]})
		end
	end
	for _, data in ipairs(list) do
		me.RemoveHook(unpack(data))
	end
	return list
end
me.ReapplyHooks = function(list)
	for _, data in ipairs(list) do
		me.AddHook(unpack(data))
	end
end
me.RemoveHook = function(name, key)
	AssertType(name, "name", me:GetFullTableName()..".AddHook", "string");
	AssertType(key, "key", me:GetFullTableName()..".AddHook", "string","number");
	for i, tbl in ipairs(me.HookList[name] or {}) do
		if tbl[1]==key then
			table.remove(me.HookList[name], i)
			break;
		end
	end
	if me.HookList[name] and #me.HookList[name]==0 then
		me.SetTableVar(_G, name, me.HookList[name].orig)
		me.HookList[name] = nil
	end
end
me.Process = function(name, ...)
	local vars = {...}
	local orig_fn = me.HookList[name].orig
	local tbl = me.HookList[name]
	local nextfn = nil
	local i=0
	nextfn = function(...)
		if #tbl==i then
				return orig_fn(...)
		end
		i=i+1
		return tbl[i][2](nextfn, ...)
	end
	return nextfn(...)
end
me.AddHook = function(name, key, func)
	AssertType(name, "name", me:GetFullTableName()..".AddHook", "string");
	AssertType(key, "key", me:GetFullTableName()..".AddHook", "string","number");
	AssertType(func, "func", me:GetFullTableName()..".AddHook", "function");
	me.RemoveHook(name, key)
	if me.HookList[name] == nil then
		local fcn = me.GetTableVar(_G, name, nil);
		me.HookList[name] = { orig = fcn }
		local fn = function(...)
			me.Process(name, ...)
		end
		me.SetTableVar(_G, name, fn)
		me.HookList[name].hook = fn
	end
	for _, b in ipairs(me.HookList[name]) do
		Assert(b[1]~=key, me:GetFullTableName()..".AddHook", string.format("key (%s) already hooked", key))
	end
	table.insert(me.HookList[name],1, {key, func})
end
lib.CreateTable(me,name,path, lib)
