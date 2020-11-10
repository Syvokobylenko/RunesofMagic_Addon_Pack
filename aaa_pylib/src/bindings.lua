--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...
------------------------------------------------------ bindings ------------------------------------------------------
local me = {
	name = "bindings",
	registered = {},
	bind = {},
	MAXBIND = 20,
	bindcount = 0,
	keys = {},
}
BINDINGS_PRELOAD =  {}
me.Press = function(id, state)
	if me.bind[id] then
		me.bind[id](keystate == "down", id)
	end
end
BINDING_HEADER_PYLIB = "PyLib Bindings";
for i = 1, me.MAXBIND do
	local namestring = string.format("BINDING_NAME_PYLIB%d", i);
	_G[namestring] = "-- Unused "..i.." --";
	me.registered[i] = { key= "PYLIB"..i, addonkey=nil, key1=nil, key2=nil}
end
me.SetBindingKey = function(key, key1, key2)
	if me.keys[key] then
		SetBindingKey(string.format("PYLIB%d", me.keys[key]), key1, key2)
	end
end
me.GetBindingKey = function(key)
	if me.keys[key] then
		return GetBindingKey(string.format("PYLIB%d", me.keys[key]));
	else
		return nil, nil
	end
end
me.Register = function(key, name, func)
	if me._loaded then
		local num
		if not me.keys[key] then
			me.bindcount = me.bindcount + 1
			num = me.bindcount
			me.keys[key] = num
		else
			num = me.keys[key]
		end
		me.registered[num].addonkey = key
		me.bind[num] = func
		local namestring = string.format("BINDING_NAME_PYLIB%d", num);
		_G[namestring] = name;
		for a,b in ipairs(me.OldBindings) do
			if b.addonkey==key then
				SetBindingKey(string.format("PYLIB%d", num), b.key1, b.key2)
			end
		end
		SaveBindingKey();
		KeyDefineFrame_Update();
	else
		table.insert(BINDINGS_PRELOAD, {key, name, func})
	end
end
me.LoadVar = function()
	me.OldBindings = PYLIB_BINDINGS or {}
	PYLIB_BINDINGS = me.registered
	me._loaded = true
	for a,b in ipairs(BINDINGS_PRELOAD) do
		me.Register(b[1], b[2], b[3])
	end
	BINDINGS_PRELOAD = {}
end
me.Update = function(...)
	if not me._loaded then return end
	local k1,k2
	for i=1, me.MAXBIND do
		k1,k2 = GetBindingKey("PYLIB"..i)
		me.registered[i].key1 = k1
		me.registered[i].key2 = k2
	end
end
me._Init = function(val)
	SaveVariables("PYLIB_BINDINGS")
	me.RegisterEventHandler("VARIABLES_LOADED", "PYLIB_BINDINGS", me.LoadVar)
	me.RegisterEventHandler("UPDATE_BINDINGS", "PYLIB_BINDINGS", me.Update)
end
lib.CreateTable(me, name, nil, lib)
