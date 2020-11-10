--[[
File-Author: Pyrr
File-Hash: fbdddb6297e5c890a233a9022c849155e41ab1ff
File-Date: 2018-04-07T3:10:07Z
]]

if not ptl then error("pylib error: ptl not found",1) end
local me = {
	version = "1.2.7",
	name = "pylib",
	path = "interface/addons/aaa_pylib",
	--[===[@alpha@
	debug = true,
	--@end-alpha@]===]
	exports = {"SendEvent","GetVersion","RegisterEventHandler","UnRegisterEventHandler","RegisterOnUpdateHandler", "UnRegisterOnUpdateHandler","Error"},
	Settings = {
		colorblind = false, -- lib.color
	},
	children = {
		{"lib", "/lib/lib"},
		{"ui", "/ui/ui"},
		{"bindings", "/src/bindings"},
	},
	EventList = {},
	OnUpdateList = {},
}
--- Returns Current version of lib
me.GetVersion = function () return me.version end

me._Init = function(var)
	if var then return end --before load of children
	-- Initialize Frame --
	me.Frame = CreateUIComponent("Frame", "Pylib_Scripts", "", nil);
	_G[me.Frame:GetName()] = nil
	me.Frame:Hide()
	me.Frame:SetScripts("OnEvent", sprintf([=[ %s.OnEvent(this, event, arg1, arg2,arg3,arg4,arg5,arg6,arg7,arg8); ]=], me:GetFullTableName()))
	me.Frame:SetScripts("OnUpdate", sprintf([=[ %s.OnUpdate(this, elapsedTime); ]=], me:GetFullTableName()))
	
	me.RegisterEventHandler("VARIABLES_LOADED","PYLIB_SHOWFRAME", me.OnVarsLoaded)
end
me.OnVarsLoaded = function()
	PY_BASE_FN_LOADER()
	me.Frame:Show()
	for a,b in pairs(PYLIB_SETTINGS or {}) do
		me.Settings[a] = b
	end
	PYLIB_SETTINGS = me.Settings
	SaveVariables("PYLIB_SETTINGS")
	me.SendEvent("PYLIB_VARS_LOADED", true)
	printf("|cffff9a00%s loaded!", me.name)
	me.Frame:Show()
end

------------------------------------------------------ Events ------------------------------------------------------
me.OnEvent = function(this, event, ...)
	for key, value in pairs(me.EventList[event] or {}) do
		if value[2] and value[2]>0 then
			if me.lib.table.IsEmpty(value[3]) then
				me.lib.timer.Add({value[2]}, value[1], sprintf("CoolDown_%s_%s",event, key), nil, nil, event, ...)
			else
				me.lib.timer.Add({value[2]}, value[1], sprintf("CoolDown_%s_%s",event, key), nil, nil, unpack(value[3]), event, ...)
			end
		else
			if me.lib.table.IsEmpty(value[3]) then
				local success, ret = pcall(value[1], event,	...)
				if not success then me.Error("pylib.OnEvent", 2, "%s %s %s",event, key, tostring(ret)) end
			else
				local success, ret = pcall(value[1], event, unpack(value[3]), ...)
				if not success then me.Error("pylib.OnEvent", 2, "%s %s %s",event, key, tostring(ret)) end
			end
		end
	end
	if event=="VARIABLES_LOADED" then
		me.SendEvent("PYLIB_VARS_LOADED_END")
	end
end
me.SendEvent = function (event, ...)
	me.OnEvent(me.Frame, event, ...)
end
me.RegisterEventHandler = function(event, key, func, delay,...)
	AssertType(event,"event",me:GetFullTableName()..".RegisterEventHandler","string")
	AssertType(key,"key",me:GetFullTableName()..".RegisterEventHandler","string")
	AssertType(func,"func",me:GetFullTableName()..".RegisterEventHandler","function","string")
	if not me.EventList[event] then
		me.EventList[event] = {}
		pcall(me.Frame.RegisterEvent, me.Frame, event)
	end
	me.EventList[event][key] = {CompileScript(func), delay, {...}}
end
me.UnRegisterEventHandler = function(event, key)
	AssertType(event,"event",me:GetFullTableName()..".RegisterEventHandler","string")
	AssertType(key,"key",me:GetFullTableName()..".RegisterEventHandler","string")
	if not me.EventList[event] then return end
	if not me.EventList[event][key] then return end
	me.EventList[event][key] = nil
	if me.table and me.table.IsEmpty(me.EventList[event]) then
		me.EventList[event] = nil
		pcall(me.Frame.UnregisterEvent, me.Frame, event)
	end
end
me.ClearEventHandler = function()
	local lst = {}
	for event, keys in pairs(me.EventList) do
		pcall(me.Frame.UnregisterEvent, me.Frame, event)
		me.EventList[event] = nil
		lst[event] = keys
	end
	return lst
end
me.ReapplyEventHandler = function(lst)
	for event, keys in pairs(lst) do
		me.EventList[event] = keys
		pcall(me.Frame.RegisterEvent, me.Frame, event)
	end
end
------------------------------------------------------ Update Handler ------------------------------------------------------
me.OnUpdate = function(this, elapsed)
	for key, value in pairs(me.OnUpdateList) do
		pcall(value, frame, elapsed)
	end
end
me.RegisterOnUpdateHandler = function(key, func)
	AssertType(key,"key",me:GetFullTableName()..".RegisterEventHandler","string")
	AssertType(func,"func",me:GetFullTableName()..".RegisterEventHandler","function","string")
	me.OnUpdateList[key] = CompileScript(func)
end
me.UnRegisterOnUpdateHandler = function(key)
	AssertType(key,"key",me:GetFullTableName()..".RegisterEventHandler","string")
	if not me.OnUpdateList[key] then return end
	me.OnUpdateList[key] = nil
end

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- Error Handler --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
me.Errtypes = {
	[0] = {"Log",		1.0,1.0,1.0},
	[1] = {"Note",		0.5,0.5,0.5},
	[2] = {"Warning",	1.0,1.0,0.0},
	[3] = {"Error",		1.0,0.5,1.0},
	[4] = {"Critical",	1.0,0.0,0.0},
}
me.Error = function(fn, level, ...)
	me.SendEvent("PYLIB_Error", fn, level, ...);
	if not me.debug then return end
	if type(level)=="number" and me.Errtypes[level] then
		local typ = me.Errtypes[level]
		level = string.format("|cff%02x%02x%02x%s",typ[2]*255,typ[3]*255,typ[4]*255,typ[1])
	end
	print(string.format("%s: in function '%s' (%s)", tostring(level), tostring(fn), sprintf(...)))
end
me.GetLibraries = function()
	return me, me.lib.timer, me.lib.string, me.lib.table, me.lib.num, me.lib.hash, me.lib.color, me.lib.hook, me.lib.callback, me.lib.item, me.lib.helper
end
me.GetUI = function()
	local ui = me.ui
	return ui, ui.layout, ui.fontstring, ui.texture, ui.frame, ui.button, ui.checkbutton, ui.editbox, ui.messageframe, ui.model, ui.radiobutton, ui.scrollframe, ui.slider, ui.statusbar, ui.tooltip
end

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- Slash Commands --------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
function me.LoadSlashCommands()
	SLASH_RELOADUI1= "/reloadui"
	SlashCmdList["RELOADUI"] = function (editBox, msg)
		ReloadUI()
	end
	SLASH_PYLIB1= "/pylib"
	SLASH_PYLIB2= "/pl"
	SlashCmdList["PYLIB"] = function (editBox, msg)
		if msg=="reload" then
			ReloadUI()
		elseif msg=="version" then
			for a,b in pairs(pylib.libs or {}) do
				if b.GetVersion() then
					printf("%s Version: %s",tostring(b:GetfullTableName()),tostring(b:GetVersion()))
				end
			end
		elseif msg=="st" or msg=="showtree" then
			me:PrintTableTree()
		elseif msg=="ex" or msg=="exports" then
			me:PrintTableTreeFunctions(true)
		elseif msg=="fn" or msg=="functions" then
			me:PrintTableTreeFunctions(false)
		elseif msg=="color" then
			me.lib.color.ToggleColorblind()
		end
	end
end
me.LoadSlashCommands()
ptl.CreateTable(me, me.name, nil, _G) --Create Parent
