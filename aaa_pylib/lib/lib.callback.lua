--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.callback ------------------------------------------------------
local me = {
	children = {},
	exports = {"Add", "Remove", "Clear","Call"},
	CallbackList = {},
}

me._Init = function(val)
	if val then return end
	me.RegisterEventHandler( "PYLIB_VARS_LOADED_END", "PYLIB_CALLBACK", function() me.SendEvent("REGISTER_CALLBACK") end)
end

me.ListCallbacks = function()
	for name, fn in pairs(me.CallbackList) do
		print(name, fn)
	end
end

me.Clear = function()
	for name, h in pairs(me.CallbackList) do
		me.CallbackList[name] = nil
	end
	me.CallbackList = {}
end
me.Remove = function(name, key)
	AssertType(name, "name", me:GetFullTableName()..".Remove", "string");
	if me.CallbackList[name] then
		me.CallbackList[name] = nil
	end
end
me.Call = function(name, default, ...)
	AssertType(name, "name", me:GetFullTableName()..".Call", "string");
	if me.CallbackList[name] == nil then
		return default
	else
		return me.CallbackList[name](...)
	end
end
me.Add = function(name, func)
	AssertType(name, "name", me:GetFullTableName()..".Add", "string");
	AssertType(func, "func", me:GetFullTableName()..".Add", "function");
	if me.CallbackList[name] == nil then
		me.CallbackList[name] = func
	else
		me.Error( me:GetFullTableName()..".AddCallback",2, "Already registered! "..name)
	end
end
lib.CreateTable(me,name,path, lib)
