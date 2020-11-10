
local me = {
	CompiledScripts = {},
}
-- BASIC HELPER FUNCITONS ----------------------------------------------------------------
--- Checks whether var has a valid type, and throws an formatted error containing parameter index, function name and parameter list, if needed
-- @param var (any) The parameter to check the type of
-- @param name (string) the name of the var
-- @param types (string / table) The typestring, or an array of typestrings, representing the valid types
-- @param func (string) The name of your function
-- @param ... (any) All parameters your function gets called with
--
local AssertType = function(var, name, func, ...)
	local varType = type(var)
	local typeNum = select('#', ...)
	for i = 1, typeNum do
		local validType = select(i, ...)
		if varType == validType then
			return
		end
	end
	local validTypes = table.concat({...}, ", or ")
	error(string.format("invalid argument '%s' for function '%s' (got %s; expected %s)", tostring(name), tostring(func), varType, validTypes), 3)
end
--- Checks if var is true or false
-- @param var (boolean)
-- @param func (number) The parameter index in your function
-- @param msg (string) the message to be sent
--
local Assert = function(var, func, msg)
	if not var then
		error(string.format("In function '%s' (%s)", tostring(func), tostring(msg)), 3)
	end
end
--- Returns formatted string
-- @param formatter (string) format string
-- @param ... (any) All Variables
--
local sprintf = function(formatter, ...)
	return string.format(tostring(formatter),...)
end;
--- Prints all Variables given
-- @param ... (any) All Variables
--
local print = function(...)
	local argNum = select('#', ...)
	local argStr = ""
	local txt = ""
	for i = 1, argNum do
		local val = select(i, ...)
		if i == 1 then
			txt = tostring(val)
		else
			txt = string.format("%s, %s",txt, tostring(val))
		end
	end
	ChatFrame1:AddMessage(txt,0.8,0.8,0.8)
end
--- Prints formatted string
-- @param formatter (string) format string
-- @param ... (any) All Variables
--
local printf = function(formatter, ...)
	print(sprintf(formatter, ...))
end;
--- Prints formatted string to SystemChats
-- @param formatter (string) format string
-- @param ... (any) All Variables
--
local prints = function(formatter, ...)
	local frame
	for i=1,8 do
		frame = _G["ChatFrame"..i]
		for i, name in ipairs(frame.messageTypeList) do
			if name=="SYSTEM" then
				frame:AddMessage(sprintf(formatter, ...))
				break;
			end
		end
	end
end;
--- PCall with internal error handler
-- @param fn (function) function to call
-- @param handler (function) Error handler
-- @param ... (any) Arguments fn has to be called with
--
local spcall = function(fn,handler,...)
	AssertType(fn, "fn", "spcall", "function")
	AssertType(handler, "handler", "spcall", "function")
	local result = {pcall(fn,...)}
	if result[1]==true then
		return unpack(result)
	end
	handler("spcall err: ", result[2]);
	return unpack(result)
end
--- loadfile with internal error handler
-- @param file (string) path to file
-- @param handler (function) Error handler
-- @param ... (any) Arguments file has to be called with
--
local sloadfile = function (file, handler, ...)
	AssertType(file, "file", "sloadfile", "string")
	AssertType(handler, "handler", "sloadfile", "function")
	local fn, err = loadfile(file);
	if err then
		handler(string.format("failed to load file %s, reason %s ",file, err));
		return false, nil
	else
		return spcall(fn, print, ...)
	end
end
local RunScript = function(script, ...)
	local Type = type(script)
	if Type == "string" then
		if me.CompiledScripts[script] then
			me.CompiledScripts[script](...)
		else
			local func, err = loadstring(script)
			Assert(func, "RunScript", sprintf("%s: %s", tostring(script), tostring(err)))
			me.CompiledScripts[script] = func
			func(...)
		end
	elseif Type == "function" then
		script(...)
	end
end
local CompileScript = function(script)
	if type(script)=="string" then
		if me.CompiledScripts[script] then
			return me.CompiledScripts[script]
		end
		local func, err = loadstring(script)
		Assert(func, "RunScript", sprintf("%s: %s", tostring(script), tostring(err)))
		me.CompiledScripts[script] = func
		return func
	end
	return script
end
--- push functions to global namespace
function PY_BASE_FN_LOADER()
	_G.AssertType = AssertType
	_G.print = print
	_G.printf = printf
	_G.sprintf = sprintf
	_G.spcall = spcall
	_G.sloadfile = sloadfile
	_G.Assert = Assert
	_G.RunScript2 = RunScript
	_G.CompileScript = CompileScript
	_G.prints = prints
end
PY_BASE_FN_LOADER()
