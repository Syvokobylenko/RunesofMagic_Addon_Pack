------------------------------------------------------------
-- ZZLIBRARY -----------------------------------------------
-- WRITTEN BY NOGUAI ---------------------------------------
------------------------------------------------------------
-- RELEASED UNDER CREATIVE COMMONS BY-NC-ND 3.0 ------------
-- http://www.creativecommons.org/licenses/by-nc-nd/3.0/ ---
------------------------------------------------------------
-- DISCLAIMER: ---------------------------------------------
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ---
-- ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT ---------
-- LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS ---
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO -----
-- EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE --
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN ---
-- AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING -------
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE --
-- USE OR OTHER DEALINGS IN THE SOFTWARE. ------------------
------------------------------------------------------------
local BUILD = tonumber("20170425195100") or 99999999999999
if ZZLibrary and BUILD ~= 99999999999999 and ZZLibrary.System.Version >= BUILD then return end


-- NAMESPACE DEFINITIONS -------------------------------------------------------------
local Lib = {
	System = {
		Name = "ZZLibrary",
		Version = BUILD,
		Debug = false,
	},
	Printer = {
		Name = "print",
		Version = 0,
		Debug = false,
	},
	Config = {},
	Bit = {},
	Table = {},
	Math = {},
	String = {},
	Classes = {},
	Hash = {},
	Colors = {},
	Anim = {
		List = {},
	},
	Story = {
		Output = false,
		List = {},
		Transition = {},
	},
	Event = {
		Output = false,
		List = {},
	},
	Timer = {
		Output = false,
		List = {},
	},
	Widget = {}
}

_G.ZZLibrary = Lib
local Table = Lib.Table
local Math = Lib.Math
local String = Lib.String
local Classes = Lib.Classes
local Colors = Lib.Colors
local Hash = Lib.Hash
local Anim = Lib.Anim
local Story = Lib.Story
local Transition = Story.Transition
local Event = Lib.Event
local Timer = Lib.Timer
local Widget = Lib.Widget
local bit = Lib.Bit
local Config = Lib.Config

ZZLibrary_EventList = ZZLibrary_EventList or {}
ZZLibrary_AnimList = ZZLibrary_AnimList or {}
ZZLibrary_StoryList = ZZLibrary_StoryList or {}
ZZLibrary_TimerList = ZZLibrary_TimerList or {}


-- PERFORMANCE LOCALS ----------------------------------------------------------------
local string = string
local math = math
local table = table
local pairs = pairs
local ipairs = ipairs
local type = type
local tostring = tostring
local tonumber = tonumber
local error = error
local assert = assert
local loadstring = loadstring
local pcall = pcall
local getmetatable = getmetatable
local setmetatable = setmetatable


-- INTERNAL TOOLS --------------------------------------------------------------------
local doNothing = function() end

local CompiledStrings = {}
local ExecString = RunScript
--- Local override of RunScript to reuse already compiled strings
-- @param script (string / function) The script to execute
-- @param ... (any) The parameters to pass to the script
--
local function RunScript(script, ...)
	local Type = type(script)
	if Type == "string" then
		if CompiledStrings[script] then
			CompiledStrings[script](...)
		else
			local func, err = loadstring(script)
			assert(func, err)
			CompiledStrings[script] = func
			func(...)
		end
	elseif Type == "function" then
		script(...)
	end
end

--- Returns the number of parameters passed
-- @param ... (any) The parameters to count
--
local function argn(...)
	return arg.n
end

--- Throws an error with formatted parameter list
-- @param msg (string) The error message
-- @param level (number) The error level (1: the caller itself)
-- @param ... (any, optional) The params to be appended to the message
--
local function throw(msg, level, ...)
	for i, v in ipairs(arg) do
		msg = string.format("%s\n%d: %s", msg, i, tostring(v))
	end

	error(msg, level + 1)
end

--- Throws an error at level 2 with formatted parameter list if test is false
-- @param test (boolean) The assertion
-- @param msg (string) The error message
-- @param ... (any, optional) The params to be appended to the message
--
local function catch(test, msg, ...)
	if not test then throw(msg, 2, ...) end
end

--- Returns a formatted arguments list
-- @param ... (any) The arguments to create a list of
--
local function arglist(...)
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

--- Checks whether var has a valid type, and throws an formatted error containing parameter index, function name and parameter list, if needed
-- @param var (any) The parameter to check the type of
-- @param types (string / table) The typestring, or an array of typestrings, representing the valid types
-- @param argn (number) The parameter index in your function
-- @param func (string) The name of your function
-- @param ... (any) All parameters your function gets called with
--
local function checktypefn(var, name, func, ...)
	local varType = type(var)
	local typeNum = select('#', ...)

	for i = 1, typeNum do
		local validType = select(i, ...)

		if varType == validType then
			return
		end
	end

	local validTypes = table.concat({...}, ", or ")
	throw(string.format("invalid argument '%s' for function '%s' (got %s; expected %s)", tostring(name), tostring(func), varType, validTypes), 3)
end

local checktype = checktypefn

--- Reports a bug to the user without interrupting code execution, like error would. Useful for errors on ui loading otherwise causing "cannot resume on non suspended coroutine".
-- @param errMsg (string) The error message
-- @param forceFrame (boolean, optional) Whether to force show the BugMessageFrame
--
local function bug(errMsg, forceFrame)
	printc(0.6, 0.6, 0.6, "|cffff0000== SCRIPT_RUNTIIME_ERROR ==|r", errMsg)

	BugMessageFrame_AddText(errMsg)
	BUG_MESSAGE_NEW_ITEM = true
	MinimapFrameBugGartherButton:Show()

	if forceFrame then
		BugMessageFrame:Show()
	end
end

--- Executes bug with formatted error message. Reports a bug to the user without interrupting code execution, like error would. Useful for errors on ui loading otherwise causing "cannot resume on non suspended coroutine".
-- @param errMsg (string) The error message format
-- @param ... (any) The parameters to format with
--
local function bugf(errMsg, ...)
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

local function dbg(msg, forceswitch)
	Lib.Print(msg, Lib.System, true, forceswitch)
end

local function mdbg(forceswitch, ...)
	for _, msg in ipairs(arg) do
		Lib.Print(msg, Lib.System, true, forceswitch)
	end
end

local function sout(msg, sender)
	if sender and sender.Name then
		msg = msg or "" -- for string.format
		if sender.Version then
			DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFFFF0000%s (v. %s):|r %s", sender.Name, sender.Version, msg))
		else
			DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFFFF0000%s:|r %s", sender.Name, msg))
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end


-- EVENT AND UPDATE FRAME CONTROL ----------------------------------------------------
local function CheckOnUpdateNeeded()
	if Table.IsEmpty(ZZLibrary_AnimList) and Table.IsEmpty(ZZLibrary_TimerList) and Table.IsEmpty(ZZLibrary_StoryList) then
		ZZLibrary_Frame:Hide()
	else
		ZZLibrary_Frame:Show()
	end
end

local function CheckEventRegister(event)
	if not ZZLibrary_EventList[event] then
		ZZLibrary_EventList[event] = {}
		ZZLibrary_Frame:RegisterEvent(event)
	end
end

local function CheckEventUnRegister(event)
	if Table.IsEmpty(ZZLibrary_EventList[event]) then
		ZZLibrary_EventList[event] = nil
		ZZLibrary_Frame:UnregisterEvent(event)
	end
end

local function UpdateAnims(this, elapsedTime)
	for name, anim in pairs(ZZLibrary_AnimList) do
		if anim.Curr == anim.Total then
			Anim.Remove(name)
		else
			anim.Next = anim.Next - elapsedTime
			if anim.Next <= 0 then
				local Increase = 1 + math.floor(-anim.Next/anim.Delay)
				anim.Curr = anim.Curr + Increase
				anim.Next = anim.Next + (Increase * anim.Delay)

				anim.Curr = (anim.Curr > 0) and anim.Curr or 1
				anim.Curr = (anim.Curr < #anim.Frames) and anim.Curr or #anim.Frames

				if anim.Frames[anim.Curr].Width then
					anim.Object:SetWidth(anim.Frames[anim.Curr].Width)
				end
				if anim.Frames[anim.Curr].Height then
					anim.Object:SetHeight(anim.Frames[anim.Curr].Height)
				end
				if anim.Frames[anim.Curr].Scale then
					anim.Object:SetScale(anim.Frames[anim.Curr].Scale)
				end
				if anim.Frames[anim.Curr].Alpha then
					anim.Object:SetAlpha(anim.Frames[anim.Curr].Alpha)
				end
				if anim.Frames[anim.Curr].Pos then
					anim.Object:SetPos(anim.Frames[anim.Curr].Pos[1], anim.Frames[anim.Curr].Pos[2])
				end

				if anim.StartScript then
					-- Move Script into local variable; If script fails, it won't be executed again
					local script = anim.StartScript
					anim.StartScript = nil
					-- Finally execute script
					RunScript(script, name)

				end
			end
		end
	end
end

local function ApplyStoryFrame(frames, num, name)
	local Frame = frames[num]

	local Script = Frame.Script
	local Target, TargetName = Frame.Target, Frame.Target:GetName()
	for Setter, Value in pairs(Frame.Values) do
		dbg(string.format("story frame: |cffff0000%s|r > |cff00ff00%s|r > |cff00ffff%s|r", tostring(name), num, TargetName..":"..tostring(Setter)), Story.Output)

		local Success, Error = pcall(Target[Setter], Target, Value[1], Value[2], Value[3], Value[4], Value[5], Value[6], Value[7])
		if not Success and Error then
			bugf("ZZLibrary: Error while processing '%s' (Frame: %03d / %03d) on animation '%s'.\nError: %s\n%s",
				Setter, num, #frames, name, Error,
				arglist(Value[1], Value[2], Value[3], Value[4], Value[5], Value[6], Value[7]))
		end
	end
	if Script then
		RunScript(Script)
	end
end

local function UpdateStory(this, elapsedTime)
	for Name, Animation in pairs(ZZLibrary_StoryList) do
		local NumFrames = #Animation.Frames
		local CurrFrame = Animation.Curr
		local Frames = Animation.Frames
		local Delay = Animation.Delay
		local Next = Animation.Next

		if CurrFrame == NumFrames then
			Story.Remove(Name)
		else
			Next = Next - elapsedTime
			if Next <= 0 then
				local Increase = 1 + math.floor(-Next / Delay)
				local NextForcedFrame = Animation.ForceFrames[1]
				CurrFrame = CurrFrame + Increase
				CurrFrame = (CurrFrame > 0) and CurrFrame or 1
				CurrFrame = (CurrFrame < NumFrames) and CurrFrame or NumFrames
				CurrFrame = (CurrFrame < (NextForcedFrame or math.huge)) and CurrFrame or NextForcedFrame
				if CurrFrame == NextForcedFrame then
					table.remove(Animation.ForceFrames, 1)
				end

				Animation.Curr = CurrFrame

				Next = Next + (Increase * Animation.Delay)
				ApplyStoryFrame(Frames, CurrFrame, Name)
			end
			Animation.Next = Next
		end
	end
end

local function UpdateTimers(this, elapsedTime)
	for key, timer in pairs(ZZLibrary_TimerList) do
		timer.Time = timer.Time - elapsedTime

		if timer.Time <= 0 then
			dbg(string.format("timer: |cff00ff00%s|r", tostring(key)), Timer.Output)
			if not timer.Delay or timer.Delay <= 0 then
				Timer.Remove(key)
			else
				timer.Time = timer.Time + timer.Delay
				timer.NumFired = timer.NumFired + 1
			end

			--RunScript(timer.Script, timer)
			local Success, Error = pcall(RunScript, timer.Script, timer)
			if not Success and Error then
				bugf("ZZLibrary: Error while processing timer '%s'.\nError: %s", key, tostring(Error))
			end
		end
	end
end

local function InvokeEventHandler(key, handler, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	local script, coolDown, delayOnLoading = handler.Script, handler.CoolDown, handler.DelayOnLoading
	local coolDownTimer = "CoolDown_"..event.."_"..key

	if coolDown or (delayOnLoading and LoadingFrame:IsVisible()) then
		if delayOnLoading then
			coolDown = 1
		end

		if (Timer.GetRemainingTime(coolDownTimer) or -math.huge) > 0 then
			ZZLibrary_TimerList[coolDownTimer].EventArgs = {event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9}
			return
		else
			Timer.Add({coolDown}, function(timer)
				local event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = unpack(timer.EventArgs)
				if event then
					InvokeEventHandler(key, handler, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
				end
			end, coolDownTimer)
			ZZLibrary_TimerList[coolDownTimer].EventArgs = {}
		end
	end

	dbg(string.format("event: |cffff0000%s|r > |cff00ff00%s|r > |cff00ffff%s|r", tostring(event), key, tostring(script)), Event.Output)
	--RunScript(script, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	local Success, Error = pcall(RunScript, script, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if not Success and Error then
		bugf("ZZLibrary: Error while processing '%s' on event '%s'.\nError: %s\n%s", key, tostring(event), tostring(Error),
			arglist(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9))
	end
end

local function TriggerEvents(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	for key, handler in pairs(ZZLibrary_EventList[event]) do
		InvokeEventHandler(key, handler, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	end
end

function Lib.OnUpdate(frame, elapsedTime)
	UpdateAnims(frame, elapsedTime)
	UpdateStory(frame, elapsedTime)
	UpdateTimers(frame, elapsedTime)
end

function Lib.OnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	TriggerEvents(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

function Lib.ReregisterEvents()
	for event in pairs(ZZLibrary_EventList) do
		ZZLibrary_Frame:RegisterEvent(event)
	end
end

local unloaded = false
local unloaded_EventList
local unloaded_StoryList
local unloaded_AnimList
local unloaded_TimerList
function Lib.UnloadFrame()
	if not unloaded then
		ZZLibrary_Frame:Hide()

		unloaded_EventList = ZZLibrary_EventList
		for k, v in pairs(ZZLibrary_EventList) do
			ZZLibrary_Frame:UnregisterEvent(k)
			ZZLibrary_EventList[k] = nil
		end
		ZZLibrary_EventList = {}

		unloaded_StoryList = ZZLibrary_StoryList
		ZZLibrary_StoryList = {}
		unloaded_AnimList = ZZLibrary_AnimList
		ZZLibrary_AnimList = {}
		unloaded_TimerList = ZZLibrary_TimerList
		ZZLibrary_TimerList = {}

		unloaded = true
	end
end

function Lib.ReloadFrame()
	if unloaded then
		ZZLibrary_EventList = unloaded_EventList
		for k, v in pairs(ZZLibrary_EventList) do
			ZZLibrary_Frame:RegisterEvent(k)
		end

		ZZLibrary_StoryList = unloaded_StoryList
		ZZLibrary_AnimList = unloaded_AnimList
		ZZLibrary_TimerList = unloaded_TimerList

		ZZLibrary_Frame:Show()

		unloaded = false
	end
end

-- GENERAL STUFF ---------------------------------------------------------------------
--- Enable type checking in library functions at the cost of game performance
--
function Lib.DisableTypeChecks()
	checktype = doNothing
end
--- Disable type checking in library functions to increase game performance (default)
--
function Lib.EnableTypeChecks()
	checktype = checktypefn
end
--- Returns the build of ZZLibrary
-- @return build (number) The build number
--
function Lib.GetBuildNumber()
	return BUILD
end

--- Prints a preformatted message to the chat frame.
-- @param msg (string) The message that is printed
-- @param sender (table) Table with information about the sender (see <a href="#PrintSender">PrintSender</a>)
-- @param debug (bool) A switch to print only when sender has Debug-flag set
-- @param force (bool) A switch to force print a message
--
function Lib.Print(msg, sender, debug, force)
	if not (msg and sender) then return end
	if debug and sender.Debug or force == true then
		local l, r = string.match(GetTime(), "(%d*)(.%d%d%d)")
		l = string.rep("0", 6-string.len(tostring(l)))..tostring(l)
		sout("|cFFFFFFFF[t: "..l..tostring(r).."] "..tostring(msg), sender)
	elseif not debug and force == nil then
		sout(msg, sender)
	end
end

--- Checks whether a table is a valid frame.
-- @param table The table to check
-- @return isValid (bool)
function Lib.IsValidFrame(table)
--	Does not work well
--	if type(table) == "table" and table["_uilua.lightuserdate"] then
--		return true
--	end
--	return false
	if type(table) == "table" and pcall(table.IsVisible, table) then
		return table
	end
end

--- Used to import the library into a variable.
-- @return (table) The library
--
function Lib.Import()
	return Lib
end

--- Return shortcuts to ZZLibrary libraries
-- @usage local zzTable, zzMath, zzString, zzClasses, zzHash, zzColors, zzStory, zzEvent, zzTimer, zzWidget, zzConfig = ZZLibrary.GetLibraries()
--
function Lib.GetLibraries()
	return Table, Math, String, Classes, Hash, Colors, Story, Event, Timer, Widget, Config
end

--- Loads addon locales from a base path and a base locale file
-- @param basePath (string) The path where the locale files are placed ta
-- @param baseFile (string) The base locale file used as fallback
-- @return (table) The locales dictionary table
-- @return (function) A locale getter function
--
function Lib.LoadLocales(basePath, baseFile)
	local baseLoad, baseErr = loadfile(basePath.."/"..baseFile..".lua")
	if baseErr then
		throw("Error loading base locales: \n"..tostring(baseErr), 2)
	end

	local locName = string.upper(string.sub(GetLanguage(),1,2))
	local locLoad, locErr = loadfile(basePath.."/"..locName..".lua")
	if locErr then
		locLoad = doNothing
	end

	local base = baseLoad()
	local loc = locLoad()
	for k, v in pairs(loc) do
		base[k] = v
	end

	local getFn = function(key)
		return base[key] or key
	end

	return base, getFn
end

--[[
--Example Configuration Structures:
--An Addon not using profiles nor setting sets:
MyAddon_Settings = {
	default_profile = {
		default_set = {
			setting1 = "value",
			setting2 = true,
			setting3 = 42,
		},
	},
}

--An Addon using profiles to save character specific settings
--in global SaveVariables.lua for profile copying
MyAddon_Settings = {
	Character1 = {
		default_set = {
			setting1 = "value",
			setting2 = true,
			setting3 = 42,
		},
	},
	Character2 = {
		default_set = {
			setting1 = "test",
			setting2 = false,
			setting3 = 3.14,
		},
	},
}

--An Addon using profiles to save character specific settings
--in global SaveVariables.lua and setting sets for character specific
--profiles, here class combination specific stuff
MyAddon_Settings = {
	Character1 = {
		WARRIOR_ROGUE = {
			setting1 = "value",
			setting2 = true,
			setting3 = 42,
		},
		WARRIOR_KNIGHT = {
			setting1 = "value",
			setting2 = false,
			setting3 = 3.14,
		},
	},
	Character2 = {
		WARRIOR_SCOUT = {
			setting1 = "test",
			setting2 = false,
			setting3 = 42,
		},
		WARRIOR_KNIGHT = {
			setting1 = "value",
			setting2 = false,
			setting3 = 3.14,
		},
	},
}
]]

--- Returns a set of settings from a settings profile in a settings table and creates the structure if needed. This also checks the set for missing settings and applies their defaults.
-- @param tableName (string) The name of the settings table
-- @param settings (table) An array of settings containing fields 'Name' and 'Default'
-- @param savePerChar (bool, optional) Whether to save the settings per character instead of globally
-- @param profileName (string, optional) The profile to access (default: default_profile)
-- @param set (string, optional) The set of settings in your profile (e.g. class combination specific) to use (default: default_set)
-- @return (table) The (eventually new) settings set with saved variables or default values
--
function Config.GetConfig(tableName, settings, savePerChar, profileName, set)
	checktype(tableName, "tableName", "Config.GetProfile", "string")
	checktype(settings, "settings", "Lib.CheckConfig", "table")
	checktype(savePerChar, "savePerChar", "Lib.CheckConfig", "boolean", "nil")
	checktype(profileName, "profileName", "Lib.CheckConfig", "string", "nil")
	checktype(set, "set", "Lib.CheckConfig", "string", "nil")
	
	local config = _G[tableName] or {}
	_G[tableName] = config

	profileName = profileName or "default_profile"
	config[profileName] = config[profileName] or {}
	local profile = config[profileName]

	set = set or "default_set"
	profile[set] = profile[set] or {}
	local set = profile[set]

	for i, setting in ipairs(settings) do
		if set[setting.Name] == nil then
			set[setting.Name] = setting.Default
		end
	end

	if savePerChar then
		SaveVariablesPerCharacter(tableName)
	else
		SaveVariables(tableName)
	end
	
	return set
end

--- Returns what profiles a settings table has
-- @param tableName (string) The settings table name
-- @return (table) An array of profile names
--
function Config.GetProfiles(tableName)
	checktype(tableName, "tableName", "Config.GetProfiles", "string")

	local config = _G[tableName] or {}
	local profiles = {}

	for profile, sets in pairs(config) do
		table.insert(profiles, profile)
	end

	return profiles
end

--- Returns what sets a settings profile in a settings table has
-- @param tableName (string) The settings table name
-- @param profileName (string, optional) The profile name (default: default_profile)
-- @return (table) An array of profile names
--
function Config.GetSets(tableName, profileName)
	checktype(tableName, "tableName", "Config.GetSets", "string")
	checktype(profileName, "profileName", "Config.GetSets", "string", "nil")

	local config = _G[tableName] or {}

	profileName = profileName or "default_profile"
	local profile = config[profileName] or {}

	local sets = {}
	for set, settings in pairs(profile) do
		table.insert(sets, set)
	end

	return sets
end

--- Copies an settings set from a settings profile into another
-- @param tableName (string) The settings table name
-- @param settings (table) An array of settings containing fields 'Name' and 'Default'
-- @param savePerChar (bool, optional) Whether to save the settings per character instead of globally
-- @param targetSet (string)
-- @param sourceSet (string, optional)
-- @param profileName (string, optional)
-- @param targetProfile (string, optional)
--
function Config.CopySet(tableName, settings, savePerChar, targetSet, sourceSet, profileName, targetProfile)
	checktype(tableName, "tableName", "Config.CopySet", "string")
	checktype(settings, "settings", "Lib.CopySet", "table")
	checktype(savePerChar, "savePerChar", "Lib.CopySet", "boolean", "nil")
	checktype(targetSet, "targetSet", "Config.CopySet", "string")
	checktype(sourceSet, "sourceSet", "Config.CopySet", "string", "nil")
	checktype(profileName, "profileName", "Config.CopySet", "string", "nil")
	checktype(targetProfile, "targetProfile", "Config.CopySet", "string", "nil")

	profileName = profileName or "default_profile"
	targetProfile = targetProfile or profileName
	sourceSet = sourceSet or "default_set"

	local sourceSet = Config.GetConfig(tableName, settings, savePerChar, profileName, sourceSet)
	local targetSet = Config.GetConfig(tableName, settings, savePerChar, targetProfile, targetSet)

	for setting, value in pairs(sourceSet) do
		targetSet[setting] = value
	end

	return targetSet
end

--- Copies a settings profile from another
-- @param tableName (string) The settings table name
-- @param settings (table) An array of settings containing fields 'Name' and 'Default'
-- @param savePerChar (bool, optional) Whether to save the settings per character instead of globally
-- @param targetProfile (string)
-- @param sourceProfile (string, optional)
--
function Config.CopyProfile(tableName, settings, savePerChar, targetProfile, sourceProfile)
	checktype(tableName, "tableName", "Config.CopySet", "string")
	checktype(settings, "settings", "Config.CopySet", "table")
	checktype(savePerChar, "savePerChar", "Config.CopySet", "boolean", "nil")
	checktype(targetProfile, "targetProfile", "Config.CopySet", "string")
	checktype(sourceProfile, "sourceProfile", "Config.CopySet", "string", "nil")

	local sourceProfile = sourceProfile or "default_profile"
	local sourceSets = Config.GetSets(tableName, sourceProfile)

	for i, set in pairs(sourceSets) do
		Config.CopySet(tableName, settings, savePerChar, set, set, sourceProfile, targetProfile)
	end
end


-- TOOLTIPS --------------------------------------------------------------------------
--- Displays a GameTooltip with the given template.
-- @param frame (frame) The owner frame of the tooltip
-- @param title (string) The title of the tooltip
-- @param content (array) The contents of the tooltip. See <a href="#TooltipContents">TooltipContents</a>
-- @param anchor (string, optional) The position of the tooltip around the owner.
--
function Lib.Tooltip(frame, title, content, anchor, tooltipFrame)
	checktype(frame, "frame", "Lib.Tooltip", "table")
	checktype(title, "title", "Lib.Tooltip", "string")
	checktype(content, "content", "Lib.Tooltip", "table","nil")
	checktype(anchor, "anchor", "Lib.Tooltip", "string","nil")


	local GameTooltip = Lib.IsValidFrame(tooltipFrame) or GameTooltip
	GameTooltip:ClearLines()

	local IsSame = GameTooltip:IsVisible() and _G[GameTooltip:GetName().."TextLeft1"]:GetText() == title
	GameTooltip:SetText(title)
	if not IsSame then
		GameTooltip:Hide()
	end

	if content then
		GameTooltip:AddSeparator()
		local startDesc, colR, colG, colB = 1, 1.00, 0.82, 0
		for i = 1, #content do
			if content[i] == true then
				startDesc = i
			end
		end
		for i = 1, #content do
			if i == startDesc then
				colR, colG, colB = 0, 0.75, 0.95
			end
			if content[i] == true then
				GameTooltip:AddSeparator()
			elseif type(content[i]) == "table" then
				GameTooltip:AddDoubleLine(content[i][1] or "-", content[i][2], colR, colG, colB, 1, 1, 1)
			elseif type(content[i]) == "string" then
				GameTooltip:AddDoubleLine(content[i], "", colR, colG, colB, 1, 1, 1)
			end
		end
	end

	if anchor then
		GameTooltip:SetOwner(frame, anchor)
	else
		local a1, a2 = "TOP", "LEFT"
		GameTooltip:SetOwner(frame, "ANCHOR_"..a1..a2)
		local x, y = GameTooltip:GetPos()
		a1 = (y < 0) and "BOTTOM" or "TOP"
		a2 = (x < 0) and "RIGHT" or "LEFT"
		GameTooltip:SetOwner(frame, "ANCHOR_"..a1..a2)
	end

	if not IsSame then
		Story.Remove("ZZLib_Tooltip")
		Story.New("ZZLib_Tooltip", {
			{
				_Frame = GameTooltip,
				_Start = function() GameTooltip:Show() end,
				_Time = 0.125,
				SetScale = {
					From = {0.8},
					To = {1},
				},
				SetAlpha = {
					From = {0.1},
					To = {1},
				},
			},
		}, 36)
	end
end

--- (depracted) Hides the GameTooltip (used to be animated).
--
function Lib.TooltipHide(tooltipFrame)
	local GameTooltip = tooltipFrame or GameTooltip
	Story.Remove("ZZLib_Tooltip")
	GameTooltip:Hide()
end

--- Hides the GameTooltip animated.
--
function Lib.TooltipAnimHide(tooltipFrame)
	local GameTooltip = tooltipFrame or GameTooltip
	if GameTooltip:IsVisible() then
		Story.Remove("ZZLib_Tooltip")
		Story.New("ZZLib_Tooltip", {
			{
				_Frame = GameTooltip,
				_End = function()
					local GameTooltip = GameTooltip
					GameTooltip:Hide()
					GameTooltip:SetScale(1)
					GameTooltip:SetAlpha(1)
				end,
				_Time = 0.1,
				SetAlpha = {
					From = {1},
					To = {0},
				},
			},
		}, 36)
	end
end


-- DUMPS -----------------------------------------------------------------------------
local DumpAsString, DumpAsTable
local DumpIndent = "    "
local DumpColors = {
	["default"] = "|cFFFFFFFF",
	["nil"] = "|cFF666666",
	["boolean"] = "|cFFD100D1",
	["number"] = "|cFFE8C100",
	["string"] = "|cFF008000",
	["table"] = "|cFF009999",
	["userdata"] = "|cFF9966FF",
	["metatable"] = "|cFF9966FF",
	["function"] = "|cFF405FBD",
}
local DumpTypes = {
	["nil"] = function(k, v, indent, maxrecursion, showmeta)
		DumpAsString(k, v, "nil", indent)
	end,
	["boolean"] = function(k, v, indent, maxrecursion, showmeta)
		DumpAsString(k, v, "boolean", indent)
	end,
	["number"] = function(k, v, indent, maxrecursion, showmeta)
		DumpAsString(k, v, "number", indent)
	end,
	["string"] = function(k, v, indent, maxrecursion, showmeta)
		DumpAsString(k, v, "string", indent)
	end,
	["function"] = function(k, v, indent, maxrecursion, showmeta)
		DumpAsString(k, v, "function", indent)
	end,
	["userdata"] = function(k, v, indent, maxrecursion, showmeta)
		DumpAsString(k, v, "userdata", indent)
	end,
	["metatable"] = function(k, v, indent, maxrecursion, showmeta)
		if showmeta then
			if indent < maxrecursion then
				DumpAsTable(k, v, "metatable", indent, maxrecursion, showmeta)
			else
				DumpAsString(k, v, "metatable", indent)
			end
		end
	end,
	["table"] = function(k, v, indent, maxrecursion, showmeta)
		if indent < maxrecursion then
			DumpAsTable(k, v, "table", indent, maxrecursion, showmeta)
		else
			DumpAsString(k, v, "table", indent)
		end
	end,
}

function DumpAsString(k, v, vartype, indent)
	printf("%s%s%s|r = %s", DumpIndent:rep(indent or 0), DumpColors[vartype or "default"] or DumpColors["default"], k, tostring(v))
end
function DumpAsTable(k, v, vartype, indent, maxrecursion, showmeta)
	printf("%s%s%s|r = {", DumpIndent:rep(indent or 0), DumpColors[vartype or "default"], k)
	for k, v in pairs(v) do
		local VarType = type(v)
		local Dumper =  DumpTypes[VarType]
		if Dumper then
			Dumper(k, v, indent+1, maxrecursion, showmeta)
		end
	end
	local meta = getmetatable(v)
	if meta then
		DumpTypes["metatable"]("metatable", meta, indent+1, maxrecursion, showmeta)
	end
	printf("%s}", DumpIndent:rep(indent or 0))
end

--- Dumps the content of a variable into the chat frame
-- @param var (any) The variable to dump
-- @param name (string) The name of the variable in display (default: type(var))
-- @param initindent (number, optional) Initial indentation (default: 0)
-- @param maxrecursion (number, optional) Max recursion level for table dumps (default: initindent + 5)
-- @param showmeta (boolean, optional) Show metatables
--
function Lib.DumpVar(var, name, initindent, maxrecursion, showmeta)
	initindent = initindent or 0
	maxrecursion = (maxrecursion or 5) + initindent
	showmeta = showmeta or false
	local VarType = type(var)
	local Dumper = DumpTypes[VarType]
	if Dumper then
		Dumper(name or VarType, var, initindent, maxrecursion, showmeta)
	else
		printf("%s|cFFFF0000can't dump object of type '%s'", DumpIndent:rep(initindent), VarType)
	end
end

SLASH_DUMPFN1 = "/dump"
SLASH_DUMPFN2 = "/dmp"
SlashCmdList["DUMPFN"] = function(editBox, msg)
	if msg ~= "" then
		Lib.DumpVar(Table.GetSubValue(msg), msg)
	end
end

SLASH_MDUMPFN1 = "/mdump"
SLASH_MDUMPFN2 = "/mdmp"
SLASH_MDUMPFN3 = "/metadump"
SlashCmdList["MDUMPFN"] = function(editBox, msg)
	if msg ~= "" then
		Lib.DumpVar(Table.GetSubValue(msg), msg, nil, nil, true)
	end
end

--- Prints the contents of a table to the chat frame.
-- @param table (table) The table that gets printed
-- @param layer (number) Internal, used for subvalue depth
-- @param message (string) A message to be printed before the table
--
function Lib.PrintTable(table, layer, message)
	print(message)
	Lib.DumpVar(table, nil, layer)
end


-- TABLES ----------------------------------------------------------------------------
--- Checks whether a table is empty.
-- @param tbl (table) The table to check
-- @return (bool) isEmpty
function Table.IsEmpty(tbl)
	checktype(tbl, "tbl", "Table.IsEmpty", "table")

	for _, _ in pairs(tbl) do return false end
	return true
end

--- Checks whether the contents of two tables are equal
-- @param tbl1 (table) The first table to check
-- @param tbl2 (table) The second table to check
--
function Table.Equals(tbl1, tbl2)
	checktype(tbl1, "tbl1", "Table.Equals", "table")
	checktype(tbl2, "tbl2", "Table.Equals", "table")

	for key, value in pairs(tbl1) do
		if type(value) == "table" then
			if type(tbl2[key]) ~= "table" or not Table.Equals(value, tbl2[key]) then
				return false
			end
		else
			if tbl2[key] ~= value then
				return false
			end
		end
	end
	for key, value in pairs(tbl1) do
		if type(value) == "table" then
			if type(tbl2[key]) ~= "table" or not Table.Equals(value, tbl2[key]) then
				return false
			end
		else
			if tbl2[key] ~= value then
				return false
			end
		end
	end
	return true
end

--- Turns a table into an array without blank fields. (Deletes alphanumeric indecies)
-- @param self
--
function Table.Shrink(self)
	checktype(self, "self", "Table.Shrink", "table")

	local tbl = {}
	for k, v in pairs(self) do
		if type(k) == "number" then
			table.insert(tbl, v)
		end
	end
	return tbl
end

--- Checks whether a table contains a value.
-- @param tbl (table) The table that is checked
-- @param value (var) The value to search for
-- @return (bool) containsValue
function Table.ContainsValue(tbl, value)
	checktype(tbl, "tbl", "Table.ContainsValue", "table")

	for k, v in pairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

--- Searches for a value and deletes it.
-- @param self (table) The table to search in
-- @param value The value that gets searched for
--
function Table.RemoveByValue(self, value)
	checktype(self, "self", "Table.RemoveByValue", "table")

	for i, v in pairs(self) do
		if v == value then
			self[i] = nil
			break
		end
	end
	return self
end

--- Gets a subvalue of a table.
-- @param valuePath (string) A "path" to the value. (e.g "Layer1.ChildLayer.Value")
-- @param tblSource (table, optional) The table to search in (default: _G)
--
function Table.GetSubValue(valuePath, tblSource)
	checktype(valuePath, "valuePath", "Table.GetSubValue", "string")
	checktype(tblSource, "tblSource", "Table.GetSubValue", "table","nil")

	local Value = tblSource or _G
	for SubValue in string.gmatch(valuePath, "[^%.]+") do
		Value = Value[SubValue]
	end

	return Value
end

--- Moves a value from the global environment.
-- @param self (var) The variable the value gets stored in
-- @param global (var/string) The variable to move
--
function Table.Move(self, global)
	if type(global) == "string" then
		self = _G[global]
		_G[global] = nil
	else
		self = global
		global = nil
	end
end

--- Merges two tables into the first one.
-- @param self (table) The first table to merge in.
-- @param table2 (table) The other table.
--
function Table.Merge(self, table2)
	checktype(self, "self", "Table.Merge", "table")
	checktype(table2, "table2", "Table.Merge", "table")

	for k, v in pairs(table2) do
		if type(v) == "table" then
			if type(self[k] or false) == "table" then
					Table.Merge(self[k] or {}, table2[k] or {})
			else
					self[k] = v
			end
		else
			self[k] = v
		end
	end
	return self
end

--- Returns the greatest numeric index in a table. Supports nil values inbetween.
-- @param tbl (table) The table to search in
-- @return (number) The greatest index found
function Table.GreatestKey(tbl)
	checktype(tbl, "tbl", "Table.GreatestKey", "table")

	local max = 0
	for k, _ in pairs(tbl) do
		local key = tonumber(k)
		max = (key > max) and key or max
	end
	return max
end

--- Appends a variable amount of arrays into a new one.
-- @param ... (table) Arrays to append
-- @return (table) An array containing each value of the input arrays
function Table.AppendMultiple(...)
	-- http://stackoverflow.com/questions/1410862/concatenation-of-tables-in-lua
	local t = {}

	for i = 1, arg.n do
		local array = arg[i]
		if (type(array) == "table") then
			for j = 1, #array do
				t[#t+1] = array[j]
			end
		else
			t[#t+1] = array
		end
	end

	return t
end

--- Appends a array to the first one.
-- @param self (table) The array to append to
-- @param array2 (table) The array to append
--
function Table.Append(self, array2)
	checktype(self, "self", "Table.Append", "table")
	checktype(array2, "array2", "Table.Append", "table")

	for i = 1, #array2 do
		self[#self + 1] = array2[i]
	end
	return self
end

--- Clears a table from all values but keeps the reference
-- @param tbl (table) The table to clear
--
function Table.Clear(tbl)
	for k, v in pairs(tbl) do
		tbl[k] = nil
	end
	setmetatable(tbl, nil)
end


-- MATH ------------------------------------------------------------------------------
--- Calculates the logarithm for a custom base
-- @param n (number) The number
-- @param b (number) The base
--
function Math.Log(n, b)
	checktype(n, "n", "Math.Log", "number")
	checktype(b, "b", "Math.Log", "number")

	return math.log(n) / math.log(b)
end

--- Rounds a number to a defined number of decimals.
-- @param num (number) The number to round
-- @param dec (number) The number of decimals to round to
--
function Math.Round(num, dec)
	checktype(num, "num", "Math.Round", "number")
	checktype(dec, "dec", "Math.Round", "number")

	return tonumber(string.format("%."..dec.."f",tonumber(num) or 0))
end

--- Conerts a decimal number into its hexadecimal representation.
-- @param int (number) The decimal to convert
-- @param digits (number) The mininum amount of digits to print
-- @return (string) The hexadecimal representation of int
--
function Math.ToHex(int, digits)
	checktype(int, "int", "Math.ToHex", "number")
	checktype(digits, "digits", "Math.ToHex", "number")

	return string.format("%0"..digits.."x", int)
end

--- Converts a hexadecimal number into its decimal representation.
-- @param hex (string) The hexadecimal to convert
-- @return (number) The resulting decimal
--
function Math.ToDec(hex)
	checktype(hex, "hex", "Math.ToDec", "string")

	return tonumber(hex, 16)
end

--- Formats a number 'n' to have thousand seperators.
-- @author RichardWarburton (edit by Noguai)
-- @param n (number, string) The number to format
-- @return (string) A string with the formatted number
function Math.Clean(n)
	checktype(n, "n", "Math.Clean", "number")

	local left,digits,decimals,right = string.match(tostring(n),"^([^%d]*%d)(%d*)%.?(%d*)(.-)$")
	digits = digits and digits:reverse():gsub("(%d%d%d)","%1."):reverse() or ""
	decimals = (decimals or "") ~= "" and ","..(decimals:gsub("(%d%d%d)", "%1."):gsub("(.*)%.$", "%1")) or ""
	return (left or "")..digits..decimals..(right or "")
end

--- Abbreviates a number to a short form (e.g 12,5 k).
-- @param num (number/string) The number to short.
-- @param active (bool, optional) A switch to activate shortening (default: true)
-- @return (string) A shortened, cleaned form of the number
--
function Math.Shorten(num, active)
	checktype(num, "num", "Math.Shorten", "number")
	if active == nil then active = true end

	if active then
		if math.abs(num) >= 1000000 then
			num = Math.Clean(Math.Round(num / 1000000, 2)).." M"
		elseif math.abs(num) >= 1000 then
			num = Math.Clean(Math.Round(num / 1000, 2)).." k"
		end
	else
		num = Math.Clean(num)
	end
	return tostring(num)
end

local mathPrefixes = {
	[-8] = " y",
	[-7] = " z",
	[-6] = " a",
	[-5] = " f",
	[-4] = " p",
	[-3] = " n",
	[-2] = " µ",
	[-1] = " m",
	[0]  = "",
	[1]  = " k",
	[2]  = " M",
	[3]  = " G",
	[4]  = " T",
	[5]  = " P",
	[6]  = " E",
	[7]  = " Z",
	[8]  = " Y",
}
--- Provides extended formatting capabilities for raw numbers.
-- @param num (number) The number to be formatted
-- @param dec (number, optional) The number of decimals to round to (Default: 2)
-- @param rank (number, optional) A exponent from <a href="#SIPrefixes">SIPrefixes</a> (Use 0 to disable automatic rank calculation)
-- @param base (number, optional) A base to apply the exponent on. (Default: 1000)
-- @return (string) The formatted number
--
function Math.Format(num, dec, rank, base)
	checktype(num, "num", "Math.Format", "number")
	checktype(dec, "dec", "Math.Format", "number","nil")
	checktype(rank, "rank", "Math.Format", "number","nil")
	checktype(base, "base", "Math.Format", "number","nil")

	num = num or 0
	base = base or 1000
	rank = rank or (num == 0) and 0 or math.floor(Math.Log(num, base))
	rank = (rank > #mathPrefixes) and #mathPrefixes or (rank < -8) and -8 or rank
	num = Math.Round(num / math.pow(base, rank), dec or 2)

	local Digits, Decimals = string.match(tostring(num),"^(%d*)%.?(%d*)$")
	Digits = Digits and Digits:reverse():gsub("(%d%d%d)","%1."):reverse():gsub("^%.(.*)", "%1") or ""
	Decimals = (Decimals and Decimals ~= "") and ","..(Decimals:gsub("(%d%d%d)", "%1."):gsub("(.*)%.$", "%1")) or ""

	return Digits..Decimals.. mathPrefixes[rank]
end


-- STRINGS ---------------------------------------------------------------------------
--- Retruns true when //str// equals "" or nil
-- @param str (string) The string to check
--
function String.IsEmpty(str)
	checktype(str, "str", "String.IsEmpty", "string","nil")

	return str == nil or str == ""
end

--- Returns //str// with all color tags removed
-- @param str (string)
--
function String.RemoveColor(str)
	return type(str) == "string" and str:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "") or str
end

--- Splits a string with delimiter and returns an array with the parts.
-- @param str (string) The string to split.
-- @param delim (string) The delimiter at which the string is split
-- @return (table) An array of the delimited parts
--
function String.Split(str, delim)
	checktype(str, "str", "String.Split", "string")
	checktype(delim, "delim", "String.Split", "string")

	local parts = {}
	for part in string.gmatch(str, "[^"..delim.."]+") do
		table.insert(parts, part)
	end
	return parts
end

--- Removes leading and trailing space characters (if 'chars' = nil), or the given ones from a string.
-- @param str (string) The string to trim
-- @param chars (string, optional) A set of characters (and special chars) that shall be trimmed
-- @return (string) The trimmed string
function String.Trim(str, chars)
	checktype(str, "str", "String.Trim", "string")
	checktype(chars, "chars", "String.Trim", "string","nil")

	chars = chars or "%s"
	return string.match(str, "^["..chars.."]*(.-)["..chars.."]*$")
end

--- Checks whether a string starts with another one.
-- @param str (string) The string to test
-- @param test (string) The comparison string to test with
--
function String.StartsWith(str, test)
	checktype(str, "str", "String.StartsWith", "string")
	checktype(test, "test", "String.StartsWith", "string")

	return test == "" or string.sub(str, 1, string.len(test or "")) == test
end

--- Checks whether a string ends with another one.
-- @param str (string) The string to test
-- @param test (string) The comparison string to test with
--
function String.EndsWith(str, test)
	checktype(str, "str", "String.EndsWith", "string")
	checktype(test, "test", "String.EndsWith", "string")

	return test == "" or string.sub(str, -string.len(test or "")) == test
end

--- Returns the index of the last occurance of 'test' in a string.
-- @param str (string) The string to search in
-- @param test (string) The string to search for
function String.Lastindex(str, test)
	checktype(str, "str", "String.Lastindex", "string")
	checktype(test, "test", "String.Lastindex", "string")

	if not test or test == "" then return end
	local i = string.find(string.reverse(str), string.reverse(test))
	if i then
		return string.len(str) - i - string.len(test) + 2
	end
end

--- Wraps a string after 'width' characters.
-- Inserts new line characters after width characters.
-- @param text (string) The string to wrap
-- @param width (number) The the maximum number of chars in a line
-- @return The wrapped string
--
function String.Wrap(text, width)
	checktype(text, "text", "String.Wrap", "string")
	checktype(width, "width", "String.Wrap", "number")

	local wrapped, lines = "", 0
	for line in string.gmatch(text, string.rep(".", width).."[.]*") do
		lines = lines + 1
		wrapped = wrapped..line.."\n"
	end
	return wrapped..string.sub(text, lines*width+1)
end

--- Does the string matching with additional matching of RoM localization markers.
-- @param str (string) The string to search for matches in
-- @param format (string) A format string
-- @param replaceLoca (bool) Switch activating the matching of RoM loca markers
-- @return (strings) A variable amount of strings, which are the results of matching
--
function String.MatchFormat(str, format, replaceLoca)
	checktype(str, "str", "String.Wrap", "string")
	checktype(format, "format", "String.Wrap", "string")
	checktype(replaceLoca, "replaceLoca", "String.Wrap", "boolean","nil")

	if replaceLoca then
		format = format:gsub("%b<>", "%%s"):gsub("%b[]", "%%s")
	end
	format = format:gsub("%%.", "(.*)")
	return string.match(str, format)
end

--- Fills the leading spaces of a string until it reaches a given length.
-- @param str (string) The string to fill in
-- @param fill (character) The character to fill in
-- @param len (number) The width to fill to
-- @return (string) A string of given length with leading spaces filled
--
function String.FillLeading(str, fill, len)
	checktype(str, "str", "String.FillLeading", "string", "number")
	checktype(fill, "fill", "String.FillLeading", "string", "number")
	checktype(len, "len", "String.FillLeading", "number")

	return string.rep(fill, len-string.len(str))..str
end


-- CLASS CONVERSION ------------------------------------------------------------------

local classTokens = {}
for i = -1, GetClassCount() do
	local name, token = GetClassInfoByID(i)
	classTokens[name] = token
	classTokens[token] = token
end

--- Converts a class name back to its token
-- @param class (string) The class name
--
function Classes.ToToken(class)
	return classTokens[class]
end

--- Converts a class name or its token to it's hexadecimal color.
-- @param class (string) Class token to convert
-- @return (string) Hexadecimal representaion of the class color
--
function Classes.ToColor(class)
	checktype(class, "class", "Classes.ToColor", "string")

	if not class or class == "" then return "|cffffffff" end
	for i = -1, GetClassCount() do
		local name, token = GetClassInfoByID(i)
		if token and (class == name or class == token) and g_ClassColors[token] then
			return Colors.RGBAToHEX(g_ClassColors[token].r, g_ClassColors[token].g, g_ClassColors[token].b)
		end
	end
	return "|cffffffff"
end

--- Converts a class name or its token to it's icon.
-- @param class (string) A class token to convert to
-- @return (string) The path to the class token
--
function Classes.ToIcon(class)
	checktype(class, "class", "Classes.ToIcon", "string")

	if not class or class == "" then return "" end
	for i = -1, GetClassCount() do
		local name, token = GetClassInfoByID(i)
		if token and (class == name or class == token) then
			return "Interface/TargetFrame/TargetFrameIcon-"..token..".tga"
		end
	end
	return ""
end

--- Converts a class combination or their tokens into an combined icon
-- @param main (string) The main class
-- @param sec (string, optional) The secondary class
--
function Classes.ToCombinedIcon(main, sec)
	local tokenMain = Classes.ToToken(main)
	local tokenSec = Classes.ToToken(sec)

	if tokenMain then
		if tokenSec then
			return "Interface/widgeticons/classicon_"..tokenMain.."_"..tokenSec..".tga"
		else
			return "Interface/widgeticons/classicon_"..tokenMain..".tga"
		end
	end
	return ""
end

-- BIT LIBRARY -----------------------------------------------------------------------
local bits = 32
bit.bits = bits

local function printbits(x)
	local l = x < 0
	x = math.abs(math.floor(x))
	local p = 1
	local t = ""
	for i = 1, bits - 1 do
		t = (x % (p + p) >= p and "1" or "0").." "..t
		p = p * 2
	end
	t = (l and 1 or 0).."  "..t
	print(t)
end
bit.printbits = printbits

local function getbit(pos)
	return 2 ^ (pos - 1)
end
bit.getbit = getbit

local function hasbit(x, p)
	if p < bits then
		p = getbit(p)
		return x % (p + p) >= p
	else
		return x < 0
	end
end
bit.hasbit = hasbit

local function setbit(x, p, n)
	if p < bits then
		local l = hasbit(x, p)
		local q = getbit(p)
		if n == 1 then
			return l and x or x + q
		else
			return l and x - q or x
		end
	else
		if n == 1 then
			return x > 0 and -x or x
		else
			return x < 0 and -x or x
		end
	end
end
bit.setbit = setbit

local function bnot(a)
	local l = a < 0 and -1 or 1
	a = math.abs(math.floor(a))
	local x = 0
	local p = 1
	local q = 2

	for i = 1, bits - 1 do
		if a % q < p then
			x = x + p
		end
		p = p * 2
		q = q * 2
	end
	x = x * l

	return x
end
bit.bnot = bnot

local function band(a, b)
	local l = (a < 0 and b < 0) and -1 or 1
	a = math.abs(math.floor(a))
	b = math.abs(math.floor(b))
	local x = 0
	local p = 1
	local q = 2
	local b1, b2

	for i = 1, bits - 1 do
		b1 = a % q >= p
		b2 = b % q >= p
		if b1 and b2 then
			x = x + p
		end
		p = p * 2
		q = q * 2
	end
	x = x * l

	return x
end
bit.band = band

local function bor(a, b)
	local l = (a < 0 or b < 0) and -1 or 1
	a = math.abs(math.floor(a))
	b = math.abs(math.floor(b))
	local x = 0
	local p = 1
	local q = 2
	local b1, b2

	for i = 1, bits - 1 do
		b1 = a % q >= p
		b2 = b % q >= p
		if b1 or b2 then
			x = x + p
		end
		p = p * 2
		q = q * 2
	end
	x = x * l

	return x
end
bit.bor = bor

local function bxor(a, b)
	local l = ((a > 0 and b < 0) or (a < 0 and b > 0)) and -1 or 1
	a = math.abs(math.floor(a))
	b = math.abs(math.floor(b))
	local x = 0
	local p = 1
	local q = 2
	local b1, b2
	for i = 1, bits - 1 do
		b1 = a % q >= p
		b2 = b % q >= p
		if (not b1 and b2) or (b1 and not b2) then
			x = x + p
		end
		p = p * 2
		q = q * 2
	end
	x = x * l

	return x
end
bit.bxor = bxor

local function brshift(a, n)
	local x = math.abs(math.floor(a))

	for i = 1, math.floor(n) do
		x = x / 2
	end
	if a < 0 then
		x = setbit(x, bits - n, 1)
	end

	return x
end
bit.rshift = brshift

local function barshift(a, n)
	local x = math.abs(math.floor(a))

	local l = a < 0 and 1 or 0
	for i = 1, math.floor(n) do
		x = x / 2
		x = setbit(x, bits - 1, l)
	end
	if a < 0 then
		x = -x
	end

	return x
end
bit.arshift = barshift

local function blshift(a, n)
	local x = math.abs(math.floor(a))

	for i = 1, math.floor(n) do
		x = x * 2
	end
	if hasbit(a, bits - n) then
		x = -x
	end

	return x
end
bit.lshift = blshift


-- HASHING ---------------------------------------------------------------------------
local consts = {
	0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419, 0x706AF48F, 0xE963A535, 0x9E6495A3,
	0x0EDB8832, 0x79DCB8A4, 0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD, 0xE7B82D07, 0x90BF1D91,
	0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE, 0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7,
	0x136C9856, 0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9, 0xFA0F3D63, 0x8D080DF5,
	0x3B6E20C8, 0x4C69105E, 0xD56041E4, 0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B,
	0x35B5A8FA, 0x42B2986C, 0xDBBBC9D6, 0xACBCF940, 0x32D86CE3, 0x45DF5C75, 0xDCD60DCF, 0xABD13D59,
	0x26D930AC, 0x51DE003A, 0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599, 0xB8BDA50F,
	0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924, 0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D,
	0x76DC4190, 0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F, 0x9FBFE4A5, 0xE8B8D433,
	0x7807C9A2, 0x0F00F934, 0x9609A88E, 0xE10E9818, 0x7F6A0DBB, 0x086D3D2D, 0x91646C97, 0xE6635C01,
	0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 0x6C0695ED, 0x1B01A57B, 0x8208F4C1, 0xF50FC457,
	0x65B0D9C6, 0x12B7E950, 0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3, 0xFBD44C65,
	0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2, 0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB,
	0x4369E96A, 0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5, 0xAA0A4C5F, 0xDD0D7CC9,
	0x5005713C, 0x270241AA, 0xBE0B1010, 0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
	0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17, 0x2EB40D81, 0xB7BD5C3B, 0xC0BA6CAD,
	0xEDB88320, 0x9ABFB3B6, 0x03B6E20C, 0x74B1D29A, 0xEAD54739, 0x9DD277AF, 0x04DB2615, 0x73DC1683,
	0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8, 0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1,
	0xF00F9344, 0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB, 0x196C3671, 0x6E6B06E7,
	0xFED41B76, 0x89D32BE0, 0x10DA7A5A, 0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5,
	0xD6D6A3E8, 0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1, 0xA6BC5767, 0x3FB506DD, 0x48B2364B,
	0xD80D2BDA, 0xAF0A1B4C, 0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF, 0x4669BE79,
	0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236, 0xCC0C7795, 0xBB0B4703, 0x220216B9, 0x5505262F,
	0xC5BA3BBE, 0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 0xB5D0CF31, 0x2CD99E8B, 0x5BDEAE1D,
	0x9B64C2B0, 0xEC63F226, 0x756AA39C, 0x026D930A, 0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713,
	0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38, 0x92D28E9B, 0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21,
	0x86D3D2D4, 0xF1D4E242, 0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1, 0x18B74777,
	0x88085AE6, 0xFF0F6A70, 0x66063BCA, 0x11010B5C, 0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45,
	0xA00AE278, 0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7, 0x4969474D, 0x3E6E77DB,
	0xAED16A4A, 0xD9D65ADC, 0x40DF0B66, 0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 0x47B2CF7F, 0x30B5FFE9,
	0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605, 0xCDD70693, 0x54DE5729, 0x23D967BF,
	0xB3667A2E, 0xC4614AB8, 0x5D681B02, 0x2A6F2B94, 0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B, 0x2D02EF8D }

--- Calculates the CRC32 hash sum of a given string.
-- @author Allara (http://forums.curseforge.com/showpost.php?p=252484&postcount=8)
-- @param s (string) The string to calculate the hash from
-- @return (number) The hash sum
function Hash.CRC32(s)
	checktype(s, "s", "Hash.CRC32", "string")

	local crc, l = 0xFFFFFFFF, s:len()
	local bitxor = bit.bxor
	local bitand = bit.band
	local bitrshift = bit.rshift

	for i = 1, l do
		crc = bitxor(bitrshift(crc, 8), consts[bitand(bitxor(crc, s:byte(i)), 0xFF) + 1])
	end
	return bitxor(crc, -1)
end


-- COLOR TOOLSET ---------------------------------------------------------------------
--- Converts the RGB (with optional Alpha) color into it's hexadecimal representation.
-- @param r (number) Red channel (0 - 1)
-- @param g (number) Green channel (0 - 1)
-- @param b (number) Blue channel (0 - 1)
-- @param a (number, optional) Alpha channel (0 - 1)
-- @return (string) The hexadecimal representation of the color
--
function Colors.RGBAToHEX(r, g, b, a)
	checktype(r, "r", "Colors.RGBAToHEX", "number")
	checktype(g, "g", "Colors.RGBAToHEX", "number")
	checktype(b, "b", "Colors.RGBAToHEX", "number")
	checktype(a, "a", "Colors.RGBAToHEX", "number","nil")

	a = a or 1
	r = r or 1
	g = g or 1
	b = b or 1
	return string.format("|c%02x%02x%02x%02x", a*255, r*255, g*255, b*255)
end

--- Converts a color in RGB format to HSV.
-- @param r (number) Red channel (0 - 1)
-- @param g (number) Green channel (0 - 1)
-- @param b (number) Blue channel (0 - 1)
-- @param a (number, optional) Alpha channel (0 - 1)
-- @return (number) Hue channel (0 - 1)
-- @return (number) Saturation channel (0 - 1)
-- @return (number) Value channel (0 - 1)
-- @return (number) Alpha channel (0 - 1)
--
function Colors.RGBToHSV(r, g, b, a)
	checktype(r, "r", "Colors.RGBToHSV", "number")
	checktype(g, "g", "Colors.RGBToHSV", "number")
	checktype(b, "b", "Colors.RGBToHSV", "number")
	checktype(a, "a", "Colors.RGBToHSV", "number","nil")

	a = a or 1
	r = r or 1
	g = g or 1
	b = b or 1

	local h, s, v
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)

	if r == g == b then
		h = 0
	elseif r == max then
		h = 60 * (0 + ((g - b) / (max - min)))
	elseif g == max then
		h = 60 * (2 + ((b - r) / (max - min)))
	elseif b == max then
		h = 60 * (4 + ((r - g) / (max - min)))
	end

	if h < 0 then
		h = h + 360
	end

	if max == 0 then
		s = 0
	else
		s = (max - min) / max
	end
	v = max

	return h / 360, s, v, a
end

--- Converts a color in RGB format to HSL.
-- @param r (number) Red channel (0 - 1)
-- @param g (number) Green channel (0 - 1)
-- @param b (number) Blue channel (0 - 1)
-- @param a (number, optional) Alpha channel (0 - 1)
-- @return (number) Hue channel (0 - 1)
-- @return (number) Saturation channel (0 - 1)
-- @return (number) Luminance channel (0 - 1)
-- @return (number) Alpha channel (0 - 1)
--
function Colors.RGBToHSL(r, g, b, a)
	checktype(r, "r", "Colors.RGBToHSL", "number")
	checktype(g, "g", "Colors.RGBToHSL", "number")
	checktype(b, "b", "Colors.RGBToHSL", "number")
	checktype(a, "a", "Colors.RGBToHSL", "number","nil")

	a = a or 1
	r = r or 1
	g = g or 1
	b = b or 1

	local h, s, l
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)

	if r == g == b then
		h = 0
	elseif r == max then
		h = 60 * (0 + ((g - b) / (max - min)))
	elseif g == max then
		h = 60 * (2 + ((b - r) / (max - min)))
	elseif b == max then
		h = 60 * (4 + ((r - g) / (max - min)))
	end

	if h < 0 then
		h = h + 360
	end

	if max == 0 then
		s = 0
	else
		s = (max - min) / (1 - math.abs(max + min - 1))
	end
	l = (max + min) / 2

	return h / 360, s, l, a
end

--- Converts the HEX ([AA]RRGGBB) color into it's RGB representation.
-- @param str (string) The HEX color
-- @return (number) Red channel (0 - 1)
-- @return (number) Green channel (0 - 1)
-- @return (number) Blue channel (0 - 1)
-- @return (number) Alpha channel (0 - 1)
--
function Colors.HEXToRGBA(str)
	checktype(str, "str", "Colors.HEXToRGBA", "string")

	local cols = {}
	for col in string.gmatch(string.gsub(str, "|c", ""), "..") do
		table.insert(cols, tonumber(col, 16) / 255)
	end

	if #cols == 3 then
		return cols[1], cols[2], cols[3], 1
	else
		return cols[2], cols[3], cols[4], cols[1]
	end
end

--- Converts a color in HSV format to RGB.
-- @param h (number) Hue channel (0 - 1)
-- @param s (number) Saturation channel (0 - 1)
-- @param v (number) Value channel (0 - 1)
-- @param a (number, optional) Alpha channel (0 - 1)
-- @return (number) Red channel (0 - 1)
-- @return (number) Green channel (0 - 1)
-- @return (number) Blue channel (0 - 1)
-- @return (number) Alpha channel (0 - 1)
--
function Colors.HSVToRGB(h, s, v, a)
	checktype(h, "h", "Colors.HSVToRGB", "number")
	checktype(s, "s", "Colors.HSVToRGB", "number")
	checktype(v, "v", "Colors.HSVToRGB", "number")
	checktype(a, "a", "Colors.HSVToRGB", "number","nil")

	local r, g, b

	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

	local switch = i % 6
	if switch == 0 then
		r = v g = t b = p
	elseif switch == 1 then
		r = q g = v b = p
	elseif switch == 2 then
		r = p g = v b = t
	elseif switch == 3 then
		r = p g = q b = v
	elseif switch == 4 then
		r = t g = p b = v
	elseif switch == 5 then
		r = v g = p b = q
	end

	return r, g, b, a
end

--- Converts a color in HSL format to RGB.
-- @param h (number) Hue channel (0 - 1)
-- @param s (number) Saturation channel (0 - 1)
-- @param l (number) Luminance channel (0 - 1)
-- @param a (number, optional) Alpha channel (0 - 1)
-- @return (number) Red channel (0 - 1)
-- @return (number) Green channel (0 - 1)
-- @return (number) Blue channel (0 - 1)
-- @return (number) Alpha channel (0 - 1)
--
function Colors.HSLToRGB(h, s, l, a)
	checktype(h, "h", "Colors.HSLToRGB", "number")
	checktype(s, "s", "Colors.HSLToRGB", "number")
	checktype(l, "l", "Colors.HSLToRGB", "number")
	checktype(a, "a", "Colors.HSLToRGB", "number","nil")

	local r, g, b

	local c = (1 - math.abs(2 * l - 1)) * s
	h = (h * 360) / 60
	local x = c * (1 - math.abs(h % 2 - 1))
	local m = l - (0.5 * c)

	if 0 <= h and h <= 1 then
		r = c g = x b = 0
	elseif 1 <= h and h <= 2 then
		r = x g = c b = 0
	elseif 2 <= h and h <= 3 then
		r = 0 g = c b = x
	elseif 3 <= h and h <= 4 then
		r = 0 g = x b = c
	elseif 4 <= h and h <= 5 then
		r = x g = 0 b = c
	elseif 5 <= h and h <= 6 then
		r = c g = 0 b = x
	end

	return r + m, g + m, b + m, a
end

--- Calculates the color from a gradient with a value.
-- @param val (number) The value to pick from the gradient
-- @param gradient (table) An array of gradient stops (RGBA); See: <a href="#RGBAGradientStop">RGBAGradientStop</a>
-- @return (number) Red channel (0 - 1)
-- @return (number) Green channel (0 - 1)
-- @return (number) Blue channel (0 - 1)
-- @return (number) Alpha channel (0 - 1)
--
function Colors.RGBAGradient(val, gradient)
	checktype(val, "val", "Colors.RGBAGradient", "number")
	checktype(gradient, "gradient", "Colors.RGBAGradient", "table")

	if not val or not gradient then return 1, 1, 1, 1 end
	table.sort(gradient, function(a,b) return a[1] < b[1] end)
	if val <= gradient[1][1] then return gradient[1][2], gradient[1][3], gradient[1][4], gradient[1][5] end
	if val >= gradient[#gradient][1] then return gradient[#gradient][2], gradient[#gradient][3], gradient[#gradient][4], gradient[#gradient][5] end

	for i = 1, #gradient-1 do
		if val >= gradient[i][1] and val <= gradient[i+1][1] then
			local temp = {}
			for j = 1, 5 do
				temp[j] = gradient[i+1][j] - gradient[i][j]
			end

			local pct = (val - gradient[i][1]) / temp[1]
			for j = 2, 5 do
				temp[j] = gradient[i][j] + (temp[j] * pct)
			end
			return temp[2], temp[3], temp[4], temp[5]
		end
	end

	return "|cffffffff" -- fallback for -1#IND (e.g. 0/0, math.log10(-1), ...)
end

--- Calculates the color from a gradient with a value.
-- @param val (number) The value to pick from the gradient
-- @param gradient (table) An array of gradient stops (HEX); See: <a href="#HEXGradientStop">HEXGradientStop</a>
-- @return (string) HEX color (AARRGGBB)
--
function Colors.HEXGradient(val, gradient)
	checktype(val, "val", "Colors.HEXGradient", "number")
	checktype(gradient, "gradient", "Colors.HEXGradient", "table")

	if not val or not gradient then return "|cffffffff" end
	table.sort(gradient, function(a,b) return a[1] < b[1] end)
	if val <= gradient[1][1] then return gradient[1][2] end
	if val >= gradient[#gradient][1] then return gradient[#gradient][2] end

	for i = 1, #gradient-1 do
		if val >= gradient[i][1] and val <= gradient[i+1][1] then
			temp = {}
			temp[1], temp[2], temp[3], temp[4] = Colors.HEXToRGBA(gradient[i+1][2])
			temp[5], temp[6], temp[7], temp[8] = Colors.HEXToRGBA(gradient[i][2])
			local pct = (val - gradient[i][1]) / (gradient[i+1][1] - gradient[i][1])

			for j = 1, 4 do
				temp[j] = temp[j+4] + ((temp[j] - temp[j+4]) * pct)
			end
			return Colors.RGBAToHEX(temp[1], temp[2], temp[3], temp[4])
		end
	end

	return "|cffffffff" -- fallback for -1#IND (e.g. 0/0, math.log10(-1), ...)
end


-- ANIMATIONS ------------------------------------------------------------------------
--- Registers a new animation to be played
-- @param name (string) An animation identifer
-- @param object (frame) The frame the animation gets applied on
-- @param anim (table) An array consisting of animation keyframes; See: <a href="#">AnimationStoryboard</a>
-- @param fps (number) The fps to render the animation at
-- @param startscript (string/function) A script to be executed on animation start
-- @param endscript (string/funcion) A script to be executed on animation end
--
function Anim.New(name, object, anim, fps, startscript, endscript)
	if not (name and object and anim) then return end

	fps = fps or 30
	if type(object) == "string" then
		object = Table.GetSubValue(object)
	end

	local frames = {}
	local frame, width, height, scale, alpha, posx, posy
	for i = 1, #anim do
		if not anim[i].Duration then return end
		if anim[i].Width then
			anim[i].Width[2] = anim[i].Width[2] or object:GetWidth()
			width = anim[i].Width[1] - anim[i].Width[2]
			width = width / (anim[i].Duration * fps)
		end
		if anim[i].Height then
			anim[i].Height[2] = anim[i].Height[2] or object:GetHeight()
			height = anim[i].Height[1] - anim[i].Height[2]
			height = height / (anim[i].Duration * fps)
		end
		if anim[i].Scale then
			anim[i].Scale[2] = anim[i].Scale[2] or object:GetScale()
			scale = anim[i].Scale[1] - anim[i].Scale[2]
			scale = scale / (anim[i].Duration * fps)
		end
		if anim[i].Alpha then
			anim[i].Alpha[2] = anim[i].Alpha[2] or object:GetAlpha()
			alpha = anim[i].Alpha[1] - anim[i].Alpha[2]
			alpha = alpha / (anim[i].Duration * fps)
		end
		if anim[i].Pos then
			local x, y = object:GetPos()
			anim[i].Pos[2][1] = anim[i].Pos[2][1] or x
			anim[i].Pos[2][2] = anim[i].Pos[2][2] or y
			posx = anim[i].Pos[1][1] - anim[i].Pos[2][1]
			posy = anim[i].Pos[1][2] - anim[i].Pos[2][2]
			posx = posx / (anim[i].Duration * fps)
			posy = posy / (anim[i].Duration * fps)
		end
		for j = 1, anim[i].Duration * fps do
			frame = {}
			if width then
				frame.Width = anim[i].Width[2] + j * width
			end
			if height then
				frame.Height = anim[i].Height[2] + j * height
			end
			if scale then
				frame.Scale = anim[i].Scale[2] + j * scale
			end
			if alpha then
				frame.Alpha = anim[i].Alpha[2] + j * alpha
			end
			if posx and posy then
				frame.Pos = {anim[i].Pos[2][1] + j * posx, anim[i].Pos[2][2] + j * posy}
			end
			table.insert(frames, frame)
		end
		frame = {}
		if width then
			frame.Width = anim[i].Width[1]
		end
		if height then
			frame.Height = anim[i].Height[1]
		end
		if scale then
			frame.Scale = anim[i].Scale[1]
		end
		if alpha then
			frame.Alpha = anim[i].Alpha[1]
		end
		if posx and posy then
			frame.Pos = {anim[i].Pos[1][1], anim[i].Pos[1][2]}
		end
		table.insert(frames, frame)
	end
	ZZLibrary_AnimList[name] = {
		Next = 0,
		Delay = 1/fps,
		Object = object,
		Curr = 0,
		Frames = frames,
		Total = #frames,
		FinishScript = endscript,
		StartScript = startscript,
	}
	CheckOnUpdateNeeded()
end

--- Unregisters a animation from being played
-- @param name (string) The animation identifer
--
function Anim.Remove(name)
	if ZZLibrary_AnimList[name] then
		local anim = ZZLibrary_AnimList[name]
		if anim.Frames[anim.Total].Width then
			anim.Object:SetWidth(anim.Frames[anim.Total].Width)
		end
		if anim.Frames[anim.Total].Height then
			anim.Object:SetHeight(anim.Frames[anim.Total].Height)
		end
		if anim.Frames[anim.Total].Scale then
			anim.Object:SetScale(anim.Frames[anim.Total].Scale)
		end
		if anim.Frames[anim.Total].Alpha then
			anim.Object:SetAlpha(anim.Frames[anim.Total].Alpha)
		end
		if anim.Frames[anim.Total].Pos then
			anim.Object:SetPos(anim.Frames[anim.Total].Pos[1], anim.Frames[anim.Total].Pos[2])
		end

		if anim.FinishScript then
			RunScript(anim.FinishScript, name)
		end

		ZZLibrary_AnimList[name] = nil
		CheckOnUpdateNeeded()
	end
end


-- STORYBOARDING ---------------------------------------------------------------------
--[[
	StoryBoard = {
		{
			_Frame = "frame",
			_Start = "startscript",
			_End = "endscript",
			_Time = "t in sec",
			SetAlpha = {
				From = {},
				To = {},
			},
		},
	}
	 ]]
--- Creates and starts a new storyboard for timed actions
-- @param name (string) The name of the new storyboard
-- @param storyboard (table) The storyboard (See: TODO)
-- @param fps (number) The framerate to run the storyboard with
-- @param interpol (function) A transition interpolarization function
--
function Story.New(name, storyboard, fps, interpol)
	local Frames = {}
	local ForceFrames = {}
	local interpol = interpol or Transition.CubicHermiteSpline
	for Step, Animation in pairs(storyboard) do
		local Target = Animation._Frame
		local StartScript = Animation._Start
		local EndScript = Animation._End
		local Time = Animation._Time
		local NumFrames = math.floor(fps * Time)

		local Transitions = {};
		for Setter, Trans in pairs(Animation) do
			if Target[Setter] then
				if #Trans.From == #Trans.To then
					Transitions[Setter] = {}
					for Param = 1, #Trans.From do
						if type(Trans.From[Param]) == "number" then
							Transitions[Setter][Param] = function(progress) return Trans.From[Param] + (interpol(progress) * (Trans.To[Param] - Trans.From[Param]))end
						else
							Transitions[Setter][Param] = function(progress) return (progress <= 0.5) and Trans.From[Param] or Trans.To[Param] end
					    end
					end
				end
			end
		end

		for CurrFrame = 1, NumFrames do
			local Frame = {
				Values = {}
			}
			for Setter, ValGetter in pairs(Transitions) do
				Frame.Values[Setter] = {}
				for Param = 1, #ValGetter do
					local Value = ValGetter[Param](CurrFrame / NumFrames)
					Frame.Values[Setter][Param] = Value
				end
			end
			if CurrFrame == 1 then
				table.insert(ForceFrames, #Frames + 1)
				Frame.Script = StartScript
			elseif CurrFrame == NumFrames then
				Frame.Script = EndScript
				table.insert(ForceFrames, #Frames + 1)
			end
			Frame.Target = Target
			table.insert(Frames, Frame)
		end
	end
	ZZLibrary_StoryList[name] = {
		Delay = 1 / fps,
		Next = 0,
		Curr = 0,
		Frames = Frames,
		ForceFrames = ForceFrames,
	}
	CheckOnUpdateNeeded()
end

--- Removes and stops a running storyboard
-- @param name (string) The name of the storyboard to stop
--
function Story.Remove(name)
	if ZZLibrary_StoryList[name] then
		local Animation = ZZLibrary_StoryList[name]
		for Index, FrameNum in pairs(Animation.ForceFrames) do
			ApplyStoryFrame(Animation.Frames, FrameNum, name)
		end
		ZZLibrary_StoryList[name] = nil
		CheckOnUpdateNeeded()
	end
end

function Transition.Linear(p) return p end
function Transition.CubicHermiteSpline(p) return p * p * (3 - 2 * p) end
function Transition.CubicSine(p) p = math.sin(p * math.pi/2) return p * p * p end


-- EVENT HANDLING LIBRARY-------------------------------------------------------------
Event.AllEvents = {"ACCOUNTBAG_CLOSE","ACCOUNTBAG_UPDATE","ACCOUNTBOOK_SHOW","ACCOUNTBOOK_CLOSE","ACCOUNTBOOK_UPDATE","ACTIONBAR_SLOT_CHANGED","ACTIONBAR_UPDATE_COOLDOWN","ADD_FRIEND","ADDNEW_QUESTBOOK","ASK_JOIN_TO_PARTY","ATF_Fame_UPDATE","ATF_Titlt_REPEAT","ATF_UPDATE","ATF_USE_ITEMFRAME_UPDATE","AUCTION_AUCTION_INFO_UPDATE","AUCTION_AUCTION_MONEY_UPDATE","AUCTION_BORWSE_PRICE_UPDATE","AUCTION_BROWSE_UPDATE","AUCTION_BUY_UPDATE","AUCTION_CLOSE","AUCTION_HISTORY_HIDE","AUCTION_HISTORY_SHOW","AUCTION_OPEN","AUCTION_SEARCH_RESULT","AUCTION_SELL_UPDATE","AUTO_HIDE_PARTY_INVITE","AUTO_HIDE_PARTY_JOIN","BAG_ITEM_UPDATE","BAG_UPDATE_COOLDOWN","BANK_CAPACITY_CHANGED","BANK_CLOSE","BANK_OPEN","BANK_UPDTAE","BEFRIEND_REQUEST","BILLBOARD_CLOSE","BILLBOARD_OPEN","BILLBOARD_UPDATE","BOOTY_HIDE","BOOTY_SHOW","BOOTY_UPDATE","BULLETINBOARD_UPDATE","BUY_ACCOUNTSHOP_FAILED","BUY_ACCOUNTSHOP_SUCCEEDED","CAFrame_OnMouseWheel","CANCEL_LOOT_ROLL","CARDBOOKFRAME_CLOSE","CARDBOOKFRAME_OPEN","CARDBOOKFRAME_UPDATE","CASTING_DELAYED","CASTING_FAILED","CASTING_START","CASTING_STOP","CHAT_MSG_BG","CHAT_MSG_CHANNEL","CHAT_MSG_CHANNEL_COLOR_CHANGE","CHAT_MSG_CHANNEL_CREATE","CHAT_MSG_CHANNEL_JOIN","CHAT_MSG_CHANNEL_LEAVE","CHAT_MSG_COMBAT","CHAT_MSG_EMOTE","CHAT_MSG_GM_TALK","CHAT_MSG_GM","CHAT_MSG_GUILD","CHAT_MSG_LFG","CHAT_MSG_LOOT","CHAT_MSG_PARTY","CHAT_MSG_RAID","CHAT_MSG_SALE","CHAT_MSG_SAY","CHAT_MSG_SYSTEM_GET","CHAT_MSG_SYSTEM_VALUE","CHAT_MSG_SYSTEM","CHAT_MSG_WHISPER_INFORM","CHAT_MSG_WHISPER_OFFLINE","CHAT_MSG_WHISPER","CHAT_MSG_YELL","CHAT_MSG_ZONE","CHAT_MSN_ADD","CHAT_MSN_ADDBUTTON","CHAT_MSN_ADDITEMLINK","CHAT_MSN_CLOSE","CHAT_MSN_ITEMPREVIEW","CHAT_MSN_OPEN","CHAT_MSN_POPUP","CHAT_MSN_SMALL","CHECKGETITEMBEQUEUEITEM","CLEAR_ALL_QUEUE_STATUS","CLEARSTONE_ERROR","CLEARSTONE_OK","CLIENT_COUNT_DOWN_START","CLIENT_COUNT_DOWN_STOP","CLOSE_BATTLEGROUND_CAMP_SCORE_FRAME","CLOSE_BATTLEGROUND_PLAYER_SCORE_FRAME","CLOSE_BATTLEGROUND_ROOM_LIST_FRAME","CLOSE_ENTER_BATTLEGROUND_QUERY_DIALOG","CLOSE_INBOX_ITEM","CLOSE_SPEAKFRAME","CLOSE_WINDOW","CloseBuyLottery","CloseExchangePrize","COLORING_END","COMBATMETER_DAMAGE","COMBATMETER_HEAL","COOLCLOTHBAG_KEYITEM","COOLCLOTHBAG_PENDING1_CONFIRM","COOLCLOTHBAG_PENDING2_CONFIRM","COOLCLOTHBAG_PENDING3_CONFIRM","COOLCLOTHBAG_UPDATE","COOLCLOTHBAG_UPDTAE","COOLSUIT_KEYITEM","COUNTDOWN_END","COUNTDOWN_START","CRAFT_LEARNRECIPE","CRAFT_NEXT_CREATE","CRAFT_NUMBER_CHANGED","CRAFT_STOP_CREATE","CRAFT_UNLOCK","CRAFTQUEUE_DELETE_CREATE","CRAFTQUEUE_NEXT_CREATE","CRAFTQUEUE_NUMBER_CHANGED","CRAFTQUEUE_STOP_CREATE","CREATE_PLAYER_SPRITE","CRG_UPDATE_LIST","CRG_UPDATE_MEMBERLIST","CRG_UPDATE_OWNER","CURSOR_ITEM_UPDATE","DEL_FRIEND","DELETE_ITEM_CONFIRM","DELETE_QUESETITEM_CONFIRM","DRAWRUNE_ERROR","DRAWRUNE_OK","DUEL_READY","DUEL_REQUESTED","","ELITE_BOSS_BELL","EM_NewTitleSysUseItemResult_ItemNotFind","EM_NewTitleSysUseItemResult_NoEffect","EM_NewTitleSysUseItemResult_OK","ENTER_MOUNT","EQUIP_BIND_CONFIRM","EQUIPMENT_UPDATE_COOLDOWN","EXCHANGECLASS_CLOSED","EXCHANGECLASS_FAILED","EXCHANGECLASS_SHOW","EXCHANGECLASS_SUCCESS","EXTRA_ACTIONBAR_HIDE","EXTRA_ACTIONBAR_SHOW","FOCUS_CHANGED","FORCE_DIALOG_HIDE","FORCE_DIALOG_SHOW","FSF_CLOSE","FSF_OPEN","FSF_UPDATE","FUSION_STONE_TRADE_CLOSE","FUSION_STONE_TRADE_DATA_ERR","FUSION_STONE_TRADE_NO_MONEY","GAMBLE_CLOSE","GAMBLE_ITEM_CHANGED","GAMBLE_ITEM_EXCHANGED","GAMBLE_OPEN","GAMBLE_RESULT_FAILED","GAMBLE_RESULT_OK","GAMEBAR_CHANGEZONE","GAMEBAR_CLOSE","GAMEBAR_ITEM_CHANGED","GAMEBAR_ITEM_EXCHANGED","GAMEBAR_OPEN","GAMEBAR_RESULT_FAILED","GAMEBAR_RESULT_OK","GARBAGE_UPDATE","GIVE_NEW_ITEM","GIVEITEMFRAME_OPEN","GIVEITEMFRAME_UPDATE","GOT_BATTLE_GROUND_QUEUE_RESULT","GRF_UPDATELOG","GRF_UPDATERESOURCE","GSF_INFO_UPDATE","GSF_SETMENNTYPE","GUILD_ASK_LEADERCHANGE","GUILD_ASK_LEADERCHANGE_RESULT","GUILD_BBS_MESSAGEUPDATE","GUILD_BBS_PAGEUPDATE","Guild_Board_Result","GUILD_COMMAND_CLOSE","GUILD_COMMAND_OPEN","GUILD_CONTRIBUTION_CLOSE","GUILD_CONTRIBUTION_OPEN","GUILD_HOUSES_CLOSE_VISIT_HOUSE","GUILD_HOUSES_OPEN_VISIT_HOUSE","GUILD_INVITE_REQUEST","GUILD_KICK","GUILD_PETITION_SIGNATURE","GUILD_REGISTER","GUILD_RENAME_OPEN","GUILD_SHOP_CLOSE","GUILD_SHOP_OPEN","GUILDBANK_CAPACITY_CHANGED","GUILDBANK_CLOSE","GUILDBANK_FIX_ITEM","GUILDBANK_OPEN","GUILDBANK_PAGE_LOG_UPDATE","GUILDBANK_PAGE_UPDATE","GUILDBANK_UPDTAE","GUILDHOUSE_FURNITURE_CHANGED","GUILDHOUSES_BUILDINGINFO_CHANGED","GUILDHOUSES_OPEN_BUILDING_RESOURCES","GUILDHOUSESFRAME_HIDE","GUILDHOUSESFRAME_SHOW","GUILDHOUSESTYLE_UPDATE","GUILDHOUSEWAR_INFOS_UPDATE","GUILDHOUSEWAR_LADDER_UPDATE","GUILDHOUSEWAR_LADDERHISTORY_UPDATE","GUILDHOUSEWAR_STATE_CHANGE","GUILDINVITE_SELF","GUILDWAR_DECLARE_RESULT","GUILDWAR_DECLARELIST_UPDATE","GUILDWARREPORT_UPDATE","GUILDWARSCORE","HIDE_MINIMAP_BG_OPTION","HIDE_PET_EVENT_DIALOG","HIDE_REQUEST_DIALOG","HIDE_SERVERINPUTDIALOG","HORSE_RACING_FINAL_RANKING","HOUSES_CHANGED_NAME","HOUSES_CHANGED_PASSWORD","HOUSES_CLOSE_VISIT_HOUSE","HOUSES_FRIEND_CHANGED","HOUSES_FRIEND_ITEM_LOG_CHANGED","HOUSES_FRIEND_ITEM_LOG_SHOW","HOUSES_FURNITURE_CHANGED","HOUSES_HANGER_CHANGED","HOUSES_HANGER_SHOW","HOUSES_MAID_SPEAK","HOUSES_OPEN_VISIT_HOUSE","HOUSES_PLANT_CHANGED","HOUSES_PLANT_CLOSE","HOUSES_PLANT_OPEN","HOUSES_SERVANT_HIRE_LIST_SHOW","HOUSES_SERVANT_INFO_SHOW","HOUSES_SERVANT_INFO_UPDATE","HOUSES_SERVANT_ITEM_CHANGED","HOUSES_SERVANT_LIST_CHANGED","HOUSES_STORAGE_CHANGED","HOUSES_STORAGE_SHOW","HOUSES_VISIT_HOUSE_NOTFIND","HOUSES_VISIT_HOUSE_PASSWORDERROR","HOUSESFRAME_HIDE","HOUSESFRAME_SHOW","IM_UPDATE_LIST","IMF_FILTER_UPDATE","IMF_ITEM_UPDATE","IMPLEMENT_ACTIONBAR_HIDE","IMPLEMENT_ACTIONBAR_SHOW","IMPLEMENT_ACTIONBAR_UPDATE","IMPLEMENT_ACTIONBAR_UPDATE_COOLDOWN","INSPECT_INTRODUCE_UPDATE","INSTANCE_CONFIRM_HIDE","INSTANCE_CONFIRM_SHOW","INSTANCE_RESET","INVITE_TO_CHANNEL","ITEMMALL_INFO_UPDATE","ITEMMALL_ITEM_OK","ITEMMALL_ITEMTYPE_UPDATE","ITEMMALL_LOADING","ITEMMALL_MAILNAME_ERROR","ITEMMALL_MESSAGELIST_UPDATE","ITEMMALL_PLAYER_NOTFAND","ITEMMARGE_CLOSE","ITEMMARGE_OPEN","ITEMQUEUE_CLEAR","ITEMQUEUE_INSERT","ITEMQUEUE_UPDATE","LEADER_CHANNEL_CONFIRM","LEARNSUITSKILL_SUCCESS","LEAVE_MOUNT","LOADING_END","LOADING_START","LOOT_ITEM_SHOW","LOOT_METHOD_CHANGED","Lottery_Exchange_SLOT_CHANGED","MACROFRAME_UPDATE","MAGICBOX_CHANGED","MAGICBOX_ENABLE","MAGICBOX_NOT_ENOUGH_ENERGY","MAIL_CLOSED","MAIL_FAILED","MAIL_INBOX_UPDATE","MAIL_SEND_INFO_UPDATE","MAIL_SEND_SUCCESS","MAIL_SHOW","MAP_CHANGED","MAP_DISABLE","MAP_ENABLE","MAP_PING","MSN_MENU_OPEN","NPCTRACK_CLEAR_TARGET","OBJECTBLOODBAR_CHANGEPOS","OBJECTBLOODBAR_CHANGEVALUE","OBJECTBLOODBAR_HIDE","OBJECTBLOODBAR_SHOW","ON_BATTLEGROUND_CLOSE","ON_GUILDHOUSE_CLOSE","ONLINE_FRIEND","OPEN_BATTLEGROUND_CAMP_SCORE_FRAME","OPEN_BATTLEGROUND_PLAYER_SCORE_FRAME","OPEN_BATTLEGROUND_ROOM_LIST_FRAME","OPEN_CLEARATTRIBSTONE_FRAME","OPEN_ENTER_BATTLEGROUND_QUERY_DIALOG","OPEN_FUSION_STONE_TRADE_FARME","OPEN_GUILDHOUSE_PLAYER_SCORE_FRAME","OPEN_PET_FRAME","OPEN_POSTVIEW","OPEN_SERVER_LIST","OpenBuyLottery","OpenExchangePrize","PARTNERFRAME_ADDPARTNER","PARTNERFRAME_ADDPETCOLLECTION","PARTNERFRAME_ERROR","PARTNERFRAME_REMOVEPARTNER","PARTY_BOARD_POST_DELETED","PARTY_BOARD_REFRESH","PARTY_INVITE_REQUEST","PARTY_LEADER_CHANGED","PARTY_MEMBER_CHANGED","PASSWORD_CONFIRM","PASSWORD_FAILED","PB_RAIDINFO_REFRESH","PE_ACTIVE_PHASE_CHANGE","PE_FAILED","PE_INTO","PE_LEAVE","PE_LeaveAndClose","PE_OBJECTIVE_VALUE_CHANGE","PE_PHASE_FAILED","PE_PHASE_SUCCESS","PE_PLAYER_SCORE","PE_SUCCESS","PET_ACTIONBAR_HIDE","PET_ACTIONBAR_SHOW","PET_ACTIONBAR_UPDATE","PET_ACTIONBAR_UPDATE_COOLDOWN","PET_COUNT_CHANGE","PET_CRAFT_END","PET_CRAFT_START","PET_CRAFTING_END","PET_CRAFTING_FAILED","PET_CRAFTING_START","PET_EGG_PUSH_OK","PET_EQUIPMENT_UPDATE","PET_FEED_INFO_UPDATE","PET_FRAME_UPDATE","PET_MIX_FAILED","PET_MIX_SUCESS","PET_NAME_UPDATE","PET_PUSH_SUCCESS","PET_RELEASE_SUCCEED","PET_RELEASE_SUCCESS","PET_RETURN_SUCCEED","PET_SUMMON_LEVEL_ERROR","PET_SUMMON_SUCCEED","PET_SWAPITEM_FAILD","PET_SWAPITEM_SUCESS","PET_TAKEOUT_SUCCESS","PETBOOKFRAME_CLOSE","PETBOOKFRAME_OPEN","PETBOOKFRAME_UPDATE","PLAYER_ABILITY_CHANGED","PLAYER_ABILITYPOINT_CHANGED","PLAYER_ALIVE","PLAYER_BAG_CHANGED","PLAYER_BOXENERGY_CHANGED","PLAYER_BUFF_CHANGED","PLAYER_COOL_SUIT_CHANGED","PLAYER_DEAD","PLAYER_ENTER_COMBAT","PLAYER_EQUIPMENT_UPDATE","PLAYER_EXP","PLAYER_EXP_CHANGED","PLAYER_GET_TITLE","PLAYER_GOODEVIL_CHANGED","PLAYER_HONOR_CHANGED","PLAYER_HONORPOINT_CHANGED","PLAYER_INVENTORY_CHANGED","PLAYER_LEAVE_COMBAT","PLAYER_LEVEL_UP","PLAYER_LIFESKILL_CHANGED","PLAYER_MAXEQSKILLCOUNT_CHANGED","PLAYER_MODEL_INFO_READY","PLAYER_MONEY","PLAYER_SKILLED_CHANGED","PLAYER_TARGET_CHANGED","PLAYER_TITLE_FLAG_CHANGED","PLAYER_TITLE_ID_CHANGED","PLAYER_TRADE_MONEY","PLAYTIME_QOUTA_NOTIFY","QUEST_COMPLETE","QUEST_REQUEST_COMPLETE","RAID_TARGET_CHANGED","RESET_BAD_FRIEND","RESET_FRIEND","RESET_QUESTBOOK","RESET_QUESTTRACK","RESET_SPEAKFRAME_TEXT","REST_MERGE_TIME","RESURRECT_REQUEST","RIDE_INVITE_REQUEST","RUNE_EXCHANGE_FRAME_CLOSE","RUNE_EXCHANGE_FRAME_OPEN","RUNE_EXCHANGE_PLATE","SAVE_VARIABLES","SCREEN_RESIZE","SCRIPT_RUNTIME_ERROR","ScrollBannerMessage","ScrollBannerMessageEX","SEARCH_GROUP_RESULT","SELECT_REWARD_ITEM","SET_ANCILLARY_TITLE_FRAME","SERVER_BOARD_UPDATE","SERVER_LIST_UPDATE","SHOW_FRIEND_DETAIL","SHOW_GEME_PROMRT","SHOW_MESSAGE_DIALOG","SHOW_MINIMAP_BG_OPTION","SHOW_PET_EVENT_DIALOG","SHOW_QUESTDETAIL_FROM_BOOK","SHOW_QUESTDETAIL_FROM_NPC","SHOW_QUESTLIST","SHOW_REQUEST_DIALOG","SHOW_REQUESTLIST_DIALOG","SHOW_SCRIPTBORDER","SHOW_SERVERINPUT_DIALOG","ShowMessageDialog","SKILL_UPDATE","SKILL_UPDATE_COOLDOWN","SKILLPLATE_DELETE","SSB_SORTTYPE_UPDATE","START_FLASH_BG_OPTION_BUTTON","STOP_FLASH_BG_OPTION_BUTTON","STORE_CLOSE","STORE_OPEN","SUIT_SKILL_PLATE_UPDATE","SUITSKILL_CLOSE","SUITSKILL_MODELUPDATE","SUITSKILL_OPEN","SUITSKILLEPLATE_UPDATE","SUITSKILLEQUIP_UPDATE","SWAP_EQUIPMENT_SUCCESS","SYS_WINDOWS_RESIZE","SYSTEM_MESSAGE","TALISMAN_BIND_CONFIRM","TARGET_HATE_LIST_UPDATED","TB_UPDATE","TIMEKEEPER_CLOSE","TIMEKEEPER_PAUSE","TIMEKEEPER_START","TP_EXP_UPDATE","TRADE_ACCEPT_UPDATE","TRADE_CLOSED","TRADE_MONEY_CHANGED","TRADE_PLAYER_ITEM_STATE","TRADE_RECIPIENT_ITEM_STATE","TRADE_REQUEST","TRADE_REQUEST_CANCEL","TRADE_SHOW","TUTORIAL_TRIGGER","UIEVENT_HOUSES_SERVANT_HIRE_FAIL","UNIT_BUFF_CHANGED","UNIT_CASTINGTIME","UNIT_CLASS_CHANGED","UNIT_HEALTH","UNIT_INVENTORY_CHANGED","UNIT_LEVEL","UNIT_MANA","UNIT_MAXHEALTH","UNIT_MAXMANA","UNIT_MAXSKILL","UNIT_NAME_UPDATE","UNIT_PET_CHANGED","UNIT_PORTRAIT_UPDATE","UNIT_RELATION","UNIT_SKILL","UNIT_TARGET_CHANGED","UNLOCKED_ITEM_CONFIRM","UPDATE_BATTLEGROUND_CAMP_SCORE","UPDATE_BATTLEGROUND_PLAYER_SCORE","UPDATE_BATTLEGROUND_ROOM_LIST_FRAME","UPDATE_BATTLEGROUND_TOWER_IVAR","UPDATE_BINDINGS","UPDATE_CHAT_FRAMES","UPDATE_FRIEND","UPDATE_GUILD_INFO","UPDATE_GUILD_MEMBER","UPDATE_GUILD_MEMBER_INFO","UPDATE_GUILDHOUSE_PLAYER_SCORE","UPDATE_GUILDWARTIME","UPDATE_HORSE_RACING_RANKING","UPDATE_LOOT_ASSIGN","UPDATE_MINIMAP","UPDATE_MOUSE_LEAVE","UPDATE_MOUSE_LIGHT","UPDATE_MOUSE_LIGHT_NotEnough","UPDATE_MOUSEOVER_UNIT","UPDATE_PARALLEL","UPDATE_PLAYTIMEQUOTA","UPDATE_QUEUE_FRAME_INFO","UPDATE_STORE_BUYBACK_ITEMS","UPDATE_STORE_SELL_ITEMS","USE_CRAFTFRAME_SKILL","VARIABLES_LOADED","VIEW_FRIEND_ALERT","VOICE_CHANNEL_MEMBER_UPDATE","VOICE_CHANNEL_UPDATE","Voice_Chat_World_Event_Ch_Exit","Voice_Chat_World_Event_Ch_Exit_Partner","Voice_Chat_World_Event_Ch_Join","Voice_Chat_World_Event_Ch_Join_Partner","Voice_Chat_World_Event_Disable_OK","Voice_Chat_World_Event_Enable_OK","Voice_Chat_World_Event_Part_Mute_Off","Voice_Chat_World_Event_Part_Mute_On","Voice_Chat_World_Event_Part_Silent","Voice_Chat_World_Event_Part_Update","WARNING_MEMORY","WARNING_MESSAGE","WARNING_START","WARNING_STOP","WBG_FRAME__PRIZE_TIMEUPDATE","WBG_FRAME_END_TIMEUPDATE","WBG_FRAME_INFLUENCE_SCOREUPDATE","WBG_SCORE_UPDATE","WBG_Tie_UPDATE","WORLDMAP_ICONCLICK","ZONE_CHANGE","ZONE_CHANGED" }

--- Registers a script for execution on event.
-- @param event (string) A event identifier; Custom ones for library internal events are allowed.
-- @param script (string/function) A script to be executed on event
-- @param key (string) A event specific registration identifer
--
function Event.Register(event, script, key, noOverride, coolDown, delayOnLoading)
	checktype(event, "event", "Event.Register", "string")
	checktype(script, "script", "Event.Register", "function","string")
	checktype(key, "key", "Event.Register", "string")
	checktype(coolDown, "coolDown", "Event.Register", "number","nil")

	dbg(string.format("register event: |cffffff00%s|r > |cff00ff00%s|r > |cff00ffff%s|r", event, key, tostring(script)), Event.Output)
	CheckEventRegister(event)
	if noOverride and ZZLibrary_EventList[event][key] then
		return
	end
	ZZLibrary_EventList[event][key] = { Script = script, CoolDown = coolDown, DelayOnLoading = delayOnLoading, }
end

--- Registers a script for execution on all events.
-- @param script (string/function) A script to be executed on event
-- @param key (string) A event specific registration identifer
--
function Event.RegisterAll(script, key, noOverride, coolDown, delayOnLoading)
	checktype(script, "script", "Event.Register", "function","string")
	checktype(key, "key", "Event.Register", "string")
	checktype(coolDown, "coolDown", "Event.Register", "number","nil")

	local allEvents = Event.AllEvents
	local registerFn = Event.Register
	for i, event in pairs(allEvents) do
		registerFn(event, script, key, noOverride, coolDown, delayOnLoading)
	end
end

--- Unregisteres/Removes a script for execution on event.
-- @param event (string) The event identifer that has ben registerd for
-- @param key (string) The event specific registration identifer
--
function Event.Unregister(event, key)
	checktype(event, "event", "Event.Unregister", "string")
	checktype(key, "key", "Event.Unregister", "string")

	dbg(string.format("unregister event: |cffffff00%s|r > |cff00ff00%s|r", event, key), Event.Output)
	if ZZLibrary_EventList[event] then
		ZZLibrary_EventList[event][key] = nil
		CheckEventUnRegister(event)
	end
end

--- Unregisteres/Removes a script for execution on all events.
-- @param key (string) The event specific registration identifer
--
function Event.UnregisterAll(key)
	checktype(key, "key", "Event.Unregister", "string")

	local allEvents = Event.AllEvents
	local unregisterFn = Event.Unregister
	for i, event in pairs(allEvents) do
		unregisterFn(event, key)
	end
end

--- Checks whether there is an event registration
-- @param event (string) The event to check the registration in
-- @param key (string) The registration identifer to check for
--
function Event.IsRegistered(event, key)
	checktype(event, "event", "Event.IsRegistered", "string")
	checktype(key, "key", "Event.IsRegistered", "string")

	if ZZLibrary_EventList[event] then
		return ZZLibrary_EventList[event][key] ~= nil
	end
	return false
end

--- Gets all Events that have been registered with a given identifer
-- @param key (string) The event specific registration identifer
--
function Event.GetRegisteredWith(key)
	checktype(key, "key", "Event.GetRegisteredWith", "string")

	local allEvents = Event.AllEvents
	local registeredEvents = {}
	for i, event in pairs(allEvents) do
		if Event.IsRegistered(event, key) then
			table.insert(registeredEvents, event)
		end
	end

	return registeredEvents
end

--- Triggers an library internal event.
-- @param event (string) The event identifer
-- @param arg1 (var) A event parameter
-- @param arg2 (var) A event parameter
-- @param arg3 (var) A event parameter
-- @param arg4 (var) A event parameter
-- @param arg5 (var) A event parameter
-- @param arg6 (var) A event parameter
-- @param arg7 (var) A event parameter
-- @param arg8 (var) A event parameter
-- @param arg9 (var) A event parameter
--
function Event.Trigger(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	checktype(event, "event", "Event.Trigger", "string")

	dbg(string.format("trigger event: |cffff00ff%s|r", event), Event.Output)
	if ZZLibrary_EventList[event] then
		TriggerEvents(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	end
end


-- TIMING LIBRARY --------------------------------------------------------------------
--- Registers a new timer.
-- @param delay (number, table) Measured in seconds. For numbers: Synchronous delay. For tables see <a href="#TimerDelay">TimerDelay</a>
-- @param script (string, functions) The script that gets executed each tick
-- @param key (string) A identifer for the timer
--
function Timer.Add(delay, script, key, noOverride)
	checktype(delay, "delay", "Timer.Add", "table","number")
	checktype(script, "script", "Timer.Add", "function","string")
	checktype(key, "key", "Timer.Add", "string")

	local initdelay
	if type(delay) == "table" then
		initdelay = delay[1]
		delay = delay[2]
	else
		initdelay = delay
	end

	if noOverride and ZZLibrary_TimerList[key] then
		return
	end

	dbg(string.format("add timer: |cffffff00%s,%s|r > |cff00ff00%s|r > |cff00ffff%s|r", tostring(initdelay), tostring(delay), key, tostring(script)), Timer.Output)
	ZZLibrary_TimerList[key] = {
		Time = initdelay,
		Delay = delay,
		NumFired = 0,
		Script = script,
	}

	CheckOnUpdateNeeded()
end

--- Removes and stops a timer.
-- @param key The timer to be removed
--
function Timer.Remove(key)
	checktype(key, "key", "Timer.Remove", "string")

	dbg(string.format("del timer: |cff00ff00%s|r", key), Timer.Output)
	ZZLibrary_TimerList[key] = nil
	CheckOnUpdateNeeded()
end

--- Returns the remaining time after which the callback is executed
-- @param key (string) The timers identifer
--
function Timer.GetRemainingTime(key)
	checktype(key, "key", "Timer.GetRemainingTime", "string")

	if ZZLibrary_TimerList[key] then
		return ZZLibrary_TimerList[key].Time
	end
end

-- FRAME CREATION --------------------------------------------------------------------
local ApplyTemplate = {}

function ApplyTemplate.Layout(widget, template)
	if template.Hidden then
		widget:Hide()
	else
		widget:Show()
	end

	if template.Alpha then
		widget:SetAlpha(template.Alpha)
	end

	if template.Anchors then
		widget:ClearAllAnchors()
		for idx, anchor in ipairs(template.Anchors) do
			widget:SetAnchor(anchor.AnchorPoint, anchor.RelativePoint, anchor.RelativeTo or "$parent", anchor.OffsetX or 0, anchor.OffsetY or 0)
		end
	end

	local color = template.Color
	if color then
		widget:SetColor(color.R or 0, color.G or 0, color.B or 0)
	end

	local size = template.Size
	if size then
		if size.Height then
			widget:SetHeight(size.Height)
		end
		if size.Width then
			widget:SetWidth(size.Width)
		end
	end

	local pos = template.Pos
	if pos then
		widget:SetPos(pos.X or 0, pos.Y or 0)
	end

	if template.Scale then
		widget:SetScale(template.Scale)
	end
end

function ApplyTemplate.FontString(widget, template)
	ApplyTemplate.Layout(widget, template)

	local font = template.Font
	if font then
		widget:SetFont(font.Font or "Fonts/DFHEIMDU.TTF", font.Size or 12, font.Weight or "NORMAL", font.Outline or "NORMAL")
	else
		widget:SetFont("Fonts/DFHEIMDU.TTF", 12, "NORMAL", "NORMAL")
	end

	if template.JustifyH then
		widget:SetJustifyHType(template.JustifyH or "RIGHT")
	end
	if template.Text then
		widget:SetText(template.Text)
	end
end

function ApplyTemplate.Texture(widget, template)
	ApplyTemplate.Layout(widget, template)

	if template.AlphaMode then
		widget:SetAlphaMode(template.AlphaMode)
	end

	if template.Texture then
		widget:SetFile(template.Texture)
	end

	local texCoord = template.TexCoord
	if texCoord then
		widget:SetTexCoord(texCoord.Left or 0, texCoord.Right or 1, texCoord.Top or 0, texCoord.Bottom or 1)
	end

	if template.Rotate then
		widget:SetRotate(template.Rotate)
	end

	if template.MaskFile then
		widget:SetMaskFile(template.MaskFile)
	end

	if template.Luminance then
		widget:SetLuminance(template.Luminance)
	end
end

function ApplyTemplate.Frame(widget, template)
	ApplyTemplate.Layout(widget, template)

	if template.Backdrop then
		widget:SetBackdrop(template.Backdrop)
	end

	if template.FrameLevel then
		widget:SetFrameLevel(template.FrameLevel)
	end

	if template.FrameStrata then
		widget:SetFrameStrata(template.FrameStrata)
	end

	if template.Enabled == false then
		widget:Disable()
	else
		widget:Enable()
	end

	if template.KeyboardEnable then
		widget:SetKeyboardEnable(template.KeyboardEnable)
	end

	if template.MouseEnable then
		widget:SetMouseEnable(template.MouseEnable)
	end

	if template.ID then
		widget:SetID(template.ID)
	end

	if template.Clicks then
		widget:RegisterForClicks(unpack(template.Clicks))
	end

	if template.Drag then
		widget:RegisterForDrag(template.Drag)
	end

	if template.Layers then
		for i, frame in ipairs(template.Layers) do
			local widgetName = widget:GetName()
			frame._parent = widgetName ~= "" and widgetName

			local new = Widget.Create(frame, frame._keepGlobal)
			if frame._key then
				widget[frame._key] = new
			end
			widget:SetLayers(frame._layer or 10, new)
		end
	end

	if template.Frames then
		for i, frame in ipairs(template.Frames) do
			local widgetName = widget:GetName()
			frame._parent = frame._parent or widgetName ~= "" and widgetName or widget

			local new = Widget.Create(frame, frame._keepGlobal)
			if frame._key then
				widget[frame._key] = new
			end
		end
	end

	if template.Events then
		for i, event in pairs(template.Events) do
			widget:RegisterEvent(event)
		end
	end

	if template.Scripts then
		for event, script in pairs(template.Scripts) do
			widget:SetScripts(event, script)
		end
	end
end

function ApplyTemplate.Button(widget, template)
	ApplyTemplate.Frame(widget, template)

	local disabledTex = template.DisabledTexture
	if disabledTex then
		local widgetName = widget:GetName()
		local texture = Widget.Create({
			_type = "Texture",
			_name = widgetName ~= "" and widgetName.."_DisabledTexture" or "",
			_parent = widgetName ~= "" and widgetName,
			Texture = disabledTex.File,
			TexCoord = disabledTex.TexCoord,
			Anchors = {
				{
					AnchorPoint = "TOPLEFT",
					RelativePoint = "TOPLEFT",
					RelativeTo = widget,
				},
				{
					AnchorPoint = "BOTTOMRIGHT",
					RelativePoint = "BOTTOMRIGHT",
					RelativeTo = widget,
				},
			},
		})
		widget:SetDisabledTexture(texture)
		widget.TexDisabled = texture
	end

	local normalTex = template.NormalTexture
	if normalTex then
		local widgetName = widget:GetName()
		local texture = Widget.Create({
			_type = "Texture",
			_name = widgetName ~= "" and widgetName.."_NormalTexture" or "",
			_parent = widgetName ~= "" and widgetName,
			Texture = normalTex.File,
			TexCoord = normalTex.TexCoord,
			Anchors = {
				{
					AnchorPoint = "TOPLEFT",
					RelativePoint = "TOPLEFT",
					RelativeTo = widget,
				},
				{
					AnchorPoint = "BOTTOMRIGHT",
					RelativePoint = "BOTTOMRIGHT",
					RelativeTo = widget,
				},
			},
		})
		widget:SetNormalTexture(texture)
		widget.TexNormal = texture
	end

	local highlightTex = template.HighlightTexture
	if highlightTex then
		local widgetName = widget:GetName()
		local texture = Widget.Create({
			_type = "Texture",
			_name = widgetName ~= "" and widgetName.."_HighlightTexture" or "",
			_parent = widgetName ~= "" and widgetName,
			Texture = highlightTex.File,
			TexCoord = highlightTex.TexCoord,
			AlphaMode = highlightTex.AlphaMode or "ADD",
			Anchors = {
				{
					AnchorPoint = "TOPLEFT",
					RelativePoint = "TOPLEFT",
					RelativeTo = widget,
				},
				{
					AnchorPoint = "BOTTOMRIGHT",
					RelativePoint = "BOTTOMRIGHT",
					RelativeTo = widget,
				},
			},
		})
		widget:SetHighlightTexture(texture)
		widget.TexHighlight = texture
	end

	local pushedTex = template.PushedTexture
	if pushedTex then
		local widgetName = widget:GetName()
		local texture = Widget.Create({
			_type = "Texture",
			_name = widgetName ~= "" and widgetName.."_PushedTexture" or "",
			_parent = widgetName ~= "" and widgetName,
			Texture = pushedTex.File,
			TexCoord = pushedTex.TexCoord,
			Anchors = {
				{
					AnchorPoint = "TOPLEFT",
					RelativePoint = "TOPLEFT",
					RelativeTo = widget,
				},
				{
					AnchorPoint = "BOTTOMRIGHT",
					RelativePoint = "BOTTOMRIGHT",
					RelativeTo = widget,
				},
			},
		})
		widget:SetPushedTexture(texture)
		widget.TexPushed = texture
	end

	if template.Text then
		widget:SetText(template.Text)
	end

	if template.TextAnchor then
		widget:SetTextAnchor(unpack(template.TextAnchor))
	end

	local textColor = template.TextColor
	if textColor then
		widget:SetTextColor(textColor.R, textColor.G, textColor.B)
	end
end

function Widget.Create(template, keepGlobal)
	local parent = type(template._parent) ~= "table" and (template._parent or "") or template._parent:GetName()
	local name = template._name:gsub("$parent", parent)

	local widget = CreateUIComponent(template._type, name or "", parent or "", template._inherits)
	if parent == "" and type(template._parent) == "table" then
		widget:SetParent(template._parent)
	end

	if not keepGlobal and name ~= "" then
		_G[name] = nil
	end

	ApplyTemplate[template._type](widget, template)
	return widget
end
function Widget.ApplyTemplate(widget, template)
	ApplyTemplate[template._type](widget, template)
end

-- SLASH COMMANDS --------------------------------------------------------------------
SLASH_PRINTFN1 = "/print"
SLASH_PRINTFN2 = "/out"
SLASH_PRINTFN3 = "/eval"
SLASH_PRINTFN4 = "/e"
SlashCmdList["PRINTFN"] = function(editBox, msg)
	print(assert(loadstring("return "..(msg or "")))())
end

SLASH_SEARCHFN1 = "/search"
SlashCmdList["SEARCHFN"] = function(editBox, msg)
	if msg == "" then return end

	printf("Searching for globals with '%s' in name", msg)
	msg = string.lower(msg)
	local num = 0
	for k, v in pairs(_G) do
		local key = tostring(k)
		local val = tostring(v)

		if string.find(string.lower(key), msg) then
			num = num + 1
			printf("%s = %s", key, val)
		end
	end
	printf("%d results", num)
end

SLASH_CLEARCONSOLEFN1 = "/cls"
SlashCmdList["CLEARCONSOLEFN"] = function(editBox, msg)
	ChatFrame1:ClearText()
	ChatFrame2:ClearText()
	ChatFrame3:ClearText()
	ChatFrame4:ClearText()
	ChatFrame5:ClearText()
	ChatFrame6:ClearText()
end

-- FINAL LOADING ---------------------------------------------------------------------
if not zzLib_ReloadUIHooked then
	local orig_ReloadUI = ReloadUI
	ReloadUI = function(...)
		ZZLibrary.UnloadFrame()
		zzLib_ReloadUIHooked = false
		orig_ReloadUI(...)
	end

	zzLib_ReloadUIHooked = true
end
if not zzLib_LogoutHooked then
	local orig_Logout = Logout
	Logout = function(...)
		ZZLibrary.UnloadFrame()
		zzLib_LogoutHooked = false
		orig_Logout(...)
	end

	local orig_CancelLogout = CancelLogout
	CancelLogout = function(...)
		ZZLibrary.ReloadFrame()
		zzLib_LogoutHooked = true
		orig_CancelLogout(...)
	end

	zzLib_LogoutHooked = true
end
Lib.ReregisterEvents()
zzTable = Table
zzMath = Math
zzString = String
zzClasses = Classes
zzHash = Hash
zzColors = Colors
zzAnim = Anim
zzStory = Story
zzEvent = Event
zzTimer = Timer
zzWidget = Widget
zzConfig = Config

--- The representation of a addon used for print functions.
-- @class table
-- @name PrintSender
-- @field Name The name of the addon sending a message
-- @field Version The version of the addon sending a message
-- @field Debug (optional) The debug flag

--- An array of arrays that template the tooltip contents.<br/>
-- It consits of an array of arrays. An array length of 1 builds a single column line, where as 2 builds a double column line.
-- @class table
-- @name TooltipContents

--- An array that configures a timer.
-- @class table
-- @name TimerDelay
-- @field 1 The initial delay
-- @field 2 The normal delay; If 0 the timer is triggered only once.

--- An array that represents a hexadecimal gradient stop.
-- @class table
-- @name HEXGradientStop
-- @field 1 The value to place the stop at
-- @field 2 The color at this gradient stop

--- An array that represents a hexadecimal gradient stop.
-- @class table
-- @name RGBAGradientStop
-- @field 1 The value to place the stop at
-- @field 2 The red channel of the color at this gradient stop
-- @field 3 The green channel of the color at this gradient stop
-- @field 4 The blue channel of the color at this gradient stop
-- @field 5 The alpha channel of the color at this gradient stop
