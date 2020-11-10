local BUILD = 11
if ZZDebugBuild and ZZDebugBuild > BUILD then return end
ZZDebugBuild = BUILD

--- Throws a new error message
-- @param msg (string) The error message
-- @param level (number) The level to throw the error at (1 equals your function, 2 the function calling your function, ...)
-- @param ... (any) Values to append to the error message
--
function throw(msg, level, ...)
	local num = select('#', ...)
	for i = 1, num do
		msg = string.format("%s\n%d: %s", msg, i, tostring(select(i, ...)))
	end
	error(msg, level + 1)
end

--- Throws an error when assertion of //check// fails
-- @param check (any) The expression to check for true or false
-- @param msg (string) The message for the possible error to throw
-- @param ... (any) Values to append to the error message
--
function catch(check, msg, ...)
	if not check then
		throw(msg, 2, ...)
	end
	return check, msg, ...
end

--- Returns an argument list as string (i.e. for bug messages)
-- @param ... (any) The argumanents to list
--
function arglist(...)
	local argNum = select('#', ...)
	local argStr = ""
	if argNum > 0 then
		argStr = "Argument list:"
		for i = 1, argNum do
			local arg = select(i, ...)
			if arg ~= nil then
				local argType = type(arg)
				local str = argType == "string" and string.format("'%s'", arg) or tostring(arg)
				argStr = string.format("%s\n%d: %s", argStr, i, str)
			end
		end
	end

	return argStr
end

--- Throws an error if //var// doesnt have valid type from //types//
-- @param var (any) The variable to check
-- @param types (table) An array of valid type names
-- @param argn (num) The argument 'index'
-- @param func (string) The function name
-- @usage typecatch("invalid", {"number"}, 1, "someFunction")
-- @usage "Invalid Argument #1 for someFunction (got string, expected number)"
--
function checktype(var, types, argn, func, ...)
	local varType = type(var)
	local typesType = type(types)

	if typesType == "string" then
		if types == varType then
			return
		end
	else
		for i, type in pairs(types) do
			if type == varType then
				return
			end
		end
	end

	local argStr = arglist(...)
	local validTypeStr = typesType == "string" and types or table.concat(types, ", or ")
	throw(string.format("Invalid argument #%d for %s. (got %s; expected %s)\n%s", tonumber(argn) or 0, tostring(func), varType, validTypeStr, argStr), 3)
end
typecatch = checktype

--- Returns the number of passed parameters
-- @param ... (any) List of parameters to count
--
function argn(...)
	return arg.n
end

--- Prints a line to //DEFAULT_CHAT_FRAME//
-- @param msg (string) The message to print
--
function println(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

--- Prints a colored line to //DEFAULT_CHAT_FRAME//
-- @param msg (string) The message to print
-- @param r (number) The red color
-- @param g (number) The green color
-- @param b (number) The blue color
--
function printlnc(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b)
end

--- Prints multiple colored lines for each parameter to //DEFAULT_CHAT_FRAME//
-- @param r (number) The red color
-- @param g (number) The green color
-- @param b (number) The blue color
-- @param ... (string) The messages to print
--
function printc(r, g, b, ...)
	local num = select('#', ...)
	for i = 1, num do
		printlnc(tostring(select(i, ...)), r, g, b)
	end
end

--- Prints multiple lines for each parameter to //DEFAULT_CHAT_FRAME//
-- @param ... (string) The messages to print
--
function print(...)
	local num = select('#', ...)
	for i = 1, num do
		println(tostring(select(i, ...)))
	end
end

SLASH_PRINTFN1 = "/print"
SLASH_PRINTFN2 = "/out"
SLASH_PRINTFN3 = "/eval"
SLASH_PRINTFN4 = "/e"
SlashCmdList["PRINTFN"] = function(editBox, msg)
	print(assert(loadstring("return "..(msg or "")))())
end

--- Prints a formatted line, with a default color
-- @param r (number) The red color
-- @param g (number) The green color
-- @param b (number) The blue color
-- @param format (string) The format string (string.format())
-- @param ... (depending) The values to insert into the format
--
function printfc(format, r, g, b, ...)
	local needed = 0
	for _ in format:gmatch("%%.") do
		needed = needed + 1;
	end

	catch(needed == argn(...), "Argument number mismatch!", 2)
	DEFAULT_CHAT_FRAME:AddMessage(format:format(...), r, g, b);
end

--- Prints a formatted line
-- @param format (string) The format string (string.format())
-- @param ... (depending) The values to insert into the format
--
function printf(format, ...)
	printfc(format, 1, 1, 1, ...)
end

--- Prints an error message to //DEFAULT_CHAT_FRAME// and //BugMessageFrame//
-- @param errMsg
--
function bug(errMsg, forceFrame)
	printc(0.6, 0.6, 0.6, "|cffff0000== SCRIPT_RUNTIIME_ERROR ==|r", errMsg)
	
	BugMessageFrame_AddText(errMsg)
	BUG_MESSAGE_NEW_ITEM = true
	MinimapFrameBugGartherButton:Show()
	
	if forceFrame then
		BugMessageFrame:Show()
	end
end
newbug = bug

--- Prints an formatted error message to //DEFAULT_CHAT_FRAME// and //BugMessageFrame//
-- @param errMsg
-- @param ...
--
function bugf(errMsg, ...)
	local needVarArg = 0
	local msg

	for _ in errMsg:gmatch("%%.") do
		needVarArg = needVarArg + 1;
	end

	if needVarArg == argn(...) then
		msg = errMsg:format(...)
	else
		msg = errMsg
	end

	bug(msg)
end
