--[[
File-Author: Pyrr
File-Hash: 721f84fb9a18e42b9211590d4fcd63ef519c8efb
File-Date: 2020-04-30T22:04:46Z
]]
local BUILD = tonumber("20200430220446") or 0

if not ptl then ChatFrame1:AddMessage("|cffff0000OS-Fix error: ptl not found: PyLib required (https://rom.curseforge.com/projects/aa_pylib)")return end
if not pylib then ChatFrame1:AddMessage("|cffff0000OS-Fix  error: pylib not found: PyLib required (https://rom.curseforge.com/projects/aa_pylib)")return end
local py_lib, py_timer, py_string, py_table, py_num, py_hash, py_color, py_hook, py_callback, py_item, py_helper = pylib.GetLibraries()

OS_BASETIME = OS_BASETIME or 0
local me = {
	name = "pyos",
	build = BUILD,
	version = "1.1.2",
	startTime = math.floor(GetTime()),
	osFunctionNames = { "print", "clock", "time", "difftime", "date",
		"exit", "execute", "getenv", "remove", "rename", "setlocale", "tmpname" },
	secondsInMonth = {	2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400,
						2678400, 2505600, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400, },
	secondsRepresentation = {	second	= 1,		min		= 60,		hour	= 3600,
								day		= 86400,	year	= 31536000,	lyear	= 31622400, },
	config = {
		usechat = true,
	}
}
_G[me.name] = me
me.patterns = {
		["%a"]	= function (str,key,t) return string.gsub(str, "%"..key, me.GetDay(tonumber(t.wday), true)) end,
		["%A"]	= function (str,key,t) return string.gsub(str, "%"..key, me.GetDay(tonumber(t.wday), false)) end,
		["%b"]	= function (str,key,t) return string.gsub(str, "%"..key, me.GetMonth(tonumber(t.month), true)) end,
		["%B"]	= function (str,key,t) return string.gsub(str, "%"..key, me.GetMonth(tonumber(t.month), false)) end,
		["%c"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%04d-%02d-%02d %02d:%02d:%02d", t.year, t.month, t.day, t.hour, t.min, t.sec)) end,
		["%d"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%02d", t.day)) end,
		["%H"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%02d", t.hour)) end,
		["%I"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%02d", ((t.hour == 0) and (t.hour+12) or ((t.hour>12) and (t.hour-12) or (t.hour))))) end,
		["%M"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%02d", t.min)) end,
		["%m"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%02d", t.month)) end,
		["%p"]	= function (str,key,t) return string.gsub(str, "%"..key, (((t.hour / 12) >= 1) and "pm" or "am")) end,
		["%S"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%02d", t.sec)) end,
		["%w"]	= function (str,key,t) return string.gsub(str, "%"..key, me.GetDay(tonumber(t.wday), false)) end,
		["%x"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%04d-%02d-%02d", t.year, t.month, t.day)) end,
		["%X"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)) end,
		["%Y"]	= function (str,key,t) return string.gsub(str, "%"..key, string.format("%04d", t.year)) end,
		["%y"]	= function (str,key,t) return string.gsub(str, "%"..key, string.sub(string.format("%04d", t.year), 3)) end,
	}

function me.RegisterWithAddonManager()
	if AddonManager and AddonManager.RegisterAddonTable then
		local addon={
			name = "osFix", -- todo name
			description = "",
			author = "Pyrrhus",
			category="Development",
			slashCommands="/os",
			version = me.version,
			icon = "interface\\icons\\boss_skill\\skill_boss_skill_380",
		}
		AddonManager.RegisterAddonTable(addon)
		return true
	else
		printf("|cffff9a00%s loaded!", "osFix") -- todo name
	end
end
--[[ [ Morphclockworkaround by TellTod]]
local MORPHCLOCK_FULL_REPLACEMENT= true
local function ReplaceMorphClock()
	if MorphClock then
		if MorphClock.vars and MorphClock.vars.registeredfuncs then
			for _,v in ipairs(MorphClock.vars.registeredfuncs) do
				local funcpt=_G[v]
				if not funcpt and type(v)=="string" then
					local tab,mfunc = string.match(v,"(.+)%.(.+)")
					if type(_G[tab])=="table" then
						funcpt=_G[tab][mfunc]
					end
				end
				if type(funcpt)=="function" then
					funcpt(time)
				end
			end
		end
		if MORPHCLOCK_FULL_REPLACEMENT then
			MorphClock =
			{
				VERSION="99999",
				date = function(self,...) return os.date(...) end,
				time = function(self,...) return os.time(...) end,
				difftime = function(self,...) return os.difftime(...) end,
				-- helpers - for those using it as library
				IsLeapYear = function (self,year) return me.IsLeapYear(year) end,
				GetDaythisYear = function (self,day,month,year) return me.GetDaythisYear(day,month,year) end,
				GetDaysSinceBegin = function (self,year) return me.GetDaysSinceBegin(year) end,
				GetWeekday = function (self,day,month,year) return me.GetWeekday(day,month,year) end,
				IsSummerTime = function (self,day,month,year,hour) return me.IsSummerTime(day,month,year,hour) end,
				UTCToLocale = function(self,time) if time then return time else return 0 end end,
				-- clock ready
				RegisterClockReady = function(self,fct) _G[fct](nil) end,
				IsValid = function(self) if OS_BASETIME~=0 then return true else return false end end,
				-- unused
				UnregisterClockReady = function(self,fct) end,
				OnTimerUpdate = function() end,
				OnTimerLoad = function() end,
				OnTimerEvent = function() end,
				About = function(self) end,
				Restart = function(self) end,
				Handler = function() end,
				PromptItemshopID = function(self) end,
				GetFirstDailyOfferGUID = function(self) end,
				-- and finally the ZZInfoBar special
				vars={},
			}
		else
			-- just function fixing
			MorphClock.date = function(self,...) return os.date(...) end
			MorphClock.time = function(self,...) return os.time(...) end
			MorphClock.difftime = function(self,...) return os.difftime(...) end
			MorphClock.RegisterClockReady = function(self,fct) _G[fct](nil) end
			MorphClock.IsValid = function(self) if OS_BASETIME~=0 then return true else return false end end
		end
		-- stop morphclock updates
		if MorphClockTimerFrame then MorphClockTimerFrame:Hide() end
	end
end
--[[ ] ]]
---------------------------------------
-- Determines if given time is within the summertime or not.
-- Works with the rules for summertime in germany.
-- last sunday in march and last sunday in october
--@param day the day of the date 1-31
--@param month the month of the date 1-12
--@param year the year of the date 1970-
--@param hour the hour of the time 0-23
--@return true if the given time is within the summertime  else false<br><hr>
function me.IsSummerTime(day,month,year,hour)
	local result=false;
	if (tonumber(month) and tonumber(day) and tonumber(year)) then
		month=tonumber(month);
		year=tonumber(year);
		day=tonumber(day);
		if month>3 and month<10 then
			result=true;
		elseif month==3 then
			local wday=me.GetWeekday(31,3,year);
			local keyday=31-wday+1;
			if day>keyday then
				result=true;
			elseif day==keyday and hour>=2 then
				result=true;
			end;
		elseif month==10 then
			local wday=me.GetWeekday(31,10,year);
			local keyday=31-wday+1;
			if day<keyday then --there will be an error of one hour in the night of the timeshift
				result=true;
			elseif day==keyday and hour<=2 then
				result=true;
			end;
		end
	end
	return result;
end
-------------------------------------------------------------------------------
-- Returns Weekday for a given date
--@param day 1-31
--@param month 1-12
--@param year 1970-
--@return weekday from Sunday 1 to Saturday 7 <br><hr>
function me.GetWeekday(day,month,year)
	local result=-1;
	local days=me.GetDaythisYear(day,month,year);
	days=days+ me.GetDaysSinceBegin(year);
	--01.01.1970 was a Thursday
	result=math.mod(days-1,7);
	if result<=2 then
		result=result+5;
	else
		result=result-2;
	end;
	return result;
end
------------------------------------------------------------------------------
-- returns the days fom 1.1.1970 till 1.1 of the given year
--@param year 1970-
--@return days from 1.1.1970 till 1.1.year<br><hr>
function me.GetDaysSinceBegin(year)
	local result=0;
	if tonumber(year) and tonumber(year)>=1970 then
		year=tonumber(year);
		if year>1970 then
			for i=1970,year-1 do
				result=result+365;
				if me.IsLeapYear(i) then
					result=result+1;
				end;
			end
		end
	end
	return result;
end
---------------------------------------------------------------------
-- returns the yearday for a given date
--@param day 1-31
--@param month 1-12
--@param year 1970-
--@return day of the year for the given date or 0 for errors or unknown dates.e.g. 2.Januar.2010 would be the 2 day of the year<br><hr>
function me.GetDaythisYear(day,month,year)
	local result=0;
	if tonumber(day) and tonumber(month) and tonumber(year) then
		month=tonumber(month);
		day=tonumber(day);
		if month>1 then
			for i=1,month-1 do
				result=result+me.secondsInMonth[i]/86400
				if i==2 and me.IsLeapYear(year) then
					result=result+1;
				end;
			end
		end
		result=result+day;
	end
	return result;
end
me.GetMonth = function(num, short)
	local MonthsFull = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", }
	local month = MonthsFull[num] or "err"
	if short then
		month=string.sub(month,1,3)
	end
	return month
end
me.GetDay = function(num, short)
	local WeekDaysFull = { "WEEKINSTANCE_SUN", "WEEKINSTANCE_MON", "WEEKINSTANCE_TUE", "WEEKINSTANCE_WED", "WEEKINSTANCE_THUR", "WEEKINSTANCE_FRI", "WEEKINSTANCE_SAT", }
	local day = TEXT(WeekDaysFull[num] or "err")
	if short then
		day=string.sub(day,1,GetLanguage()=="DE" and 2 or 3)
	end
	return day
end
me._Init = function(var)
	if not var then return end --after load of children
	py_lib.RegisterEventHandler("CHAT_MSG_GUILD", "OS_FIX", me.OnEvent)
	py_lib.RegisterEventHandler("CHAT_MSG_SAY", "OS_FIX", me.OnEvent)
	py_lib.RegisterEventHandler("CHAT_MSG_ZONE", "OS_FIX", me.OnEvent)
	py_lib.RegisterEventHandler("CHAT_MSG_WHISPER", "OS_FIX", me.OnEvent)
	py_lib.RegisterEventHandler("CHAT_MSG_PARTY", "OS_FIX", me.OnEvent)
	py_lib.RegisterEventHandler("CHAT_MSG_YELL", "OS_FIX", me.OnEvent)
	py_lib.RegisterEventHandler("CHAT_MSG_CHANNEL", "OS_FIX", me.OnEvent)
	py_lib.RegisterEventHandler("VARIABLES_LOADED", "OS_FIX", me.LoadVars)
	py_lib.RegisterEventHandler("REGISTER_HOOKS", "OS_FIX", me.SetHook)
end
me.OnEvent=function(event, arg1, ...)
	if me.config.usechat then
		if OS_BASETIME==0 then
			me.parseTime(arg1)
		end
	end
end
me.LoadVars = function()
	os = nil
	os = {}
	for _,v in ipairs(me.osFunctionNames) do
		os[v] = me[v]
	end
	-- override osfix
	if osfix then
		SlashCmdList["osfix"] = nil
		osfix.var.baseTime = 0
		osfix.OnEvent = function() end
	end
	ReplaceMorphClock()
	me.RegisterWithAddonManager()
	-- Save Vars
	PY_OSFIX_SETTINGS = PY_OSFIX_SETTINGS or {}
	for a,b in pairs(PY_OSFIX_SETTINGS) do
		me.config[a] = b
	end
	PY_OSFIX_SETTINGS = me.config
	SaveVariables("PY_OSFIX_SETTINGS")
end
me.SetHook = function()
	py_hook.AddHook("SendChatMessage", "OS_FIX", me.SendChatMessage)
end
me.SendChatMessage = function(next_fn, arg1,arg2,...)
	if me.config.usechat then
		if arg2~="GM" and type(arg1)=="string" and OS_BASETIME > 0 then
			if string.len(arg1)<200 then
				arg1=arg1.." |Hos:"..math.floor(OS_BASETIME+GetTime()).."|h|h"
			end
		end
	end
	next_fn(arg1, arg2, ...)
end
function me.parseTime(txt)
	if string.find(txt, "(%d%d)/(%d%d)/(%d%d) (%d%d):(%d%d)") then
		 local _,_,m, d, y, h, M = string.find(txt, "(%d%d)/(%d%d)/(%d%d) (%d%d):(%d%d)");
		 OS_BASETIME=me.time({year=tonumber("20"..y),month=tonumber(m),day=tonumber(d),hour=tonumber(h),min=tonumber(M),sec=0})-GetTime();
	elseif string.match(txt,"|Hos:%d+|h|h") then
		local base=string.match(txt,"|Hos:(%d+)|h|h")
		OS_BASETIME=base-GetTime();
	end
	if OS_BASETIME<=1324512000 then OS_BASETIME=0 end
end
function me.IsLeapYear(year)
	return ((year % 4 == 0) and (year  % 100 ~= 0) or (year % 400 == 0 and year % 1000 ~= 0))
end
function me.clock()
	return math.floor(GetTime() - me.startTime)
end
function me.time(param)
	local t = {};
	if (type(param) == "table") then
		t = param;
		t.isLeap = me.IsLeapYear(t.year or 0);
	else
		-- Avoid loop date -> time -> date :D
		return OS_BASETIME + GetTime();
	end;
	-- Calculate from days, hours, minutes and seconds
	tm = tonumber(t.sec or 0) + (tonumber(t.min or 0) * me.secondsRepresentation.min) + (tonumber(t.hour or 12) * me.secondsRepresentation.hour) + (((tonumber(t.day or 1) - 1) * me.secondsRepresentation.day));
	-- Add Month
	m = tonumber(t.month or 1)
	while m > 1 do
		tm = tm + me.secondsInMonth[t.isLeap and m + 11 or m - 1]
		m = m - 1;
	end;
	-- Add year
	y = tonumber(t.year or 1970);
	while y > 1970 do
		tm = tm + me.secondsRepresentation[me.IsLeapYear(y - 1) and "lyear" or "year"];
		y = y - 1;
	end
	return tm;
end
function me.difftime(x, y)
	return ((type(x) == "table") and me.time(x) or x) - ((type(y) == "table") and me.time(y) or y)
end
function me.date(fmt, param)
	local t = {};
	local tm = OS_BASETIME + GetTime();
	if param then
		-- Set time from param
		tm = (type(param) == "table") and me.time(param) or param;
		-- If time is from parameter than get UTC time
		if fmt and fmt:find("!") == 1 then
			fmt = string.sub(fmt, 2)
		end;
	else
		-- Get Game time if requested
		if fmt and fmt:find("!") == 1 then
			-- Few people tried to fix that, this is not an error, in RoM '!' means Game Time not UTC time
			tm = ((86400 * GetCurrentGameTime()) / 240) + 16200;
			while (tm > 86400) do
				tm = tm - 86400;
			end;
			fmt = string.sub(fmt, 2)
		end;
	end
	-- Set UNIX Base date
	t = {
		year	= 1970,		month	= 1,	day		= 1,
		hour	= 0,		min		= 0,	sec		= 0,
		isLeap	= false,	isdst	= true,
	}
	-- Calculate week day
	t.wday = 1 + (( 4 + math.ceil(tm / me.secondsRepresentation.day)) % 7);
	-- Calculate year
	y = me.secondsRepresentation[me.IsLeapYear(t.year) and "lyear" or "year"];
	while tm >= y do
		tm = tm - y;
		t.year = t.year + 1;
		y = me.secondsRepresentation[me.IsLeapYear(t.year) and "lyear" or "year"];
	end
	t.isLeap = y == me.secondsRepresentation.lyear;
	-- Calculate day of the year
	t.yday = math.floor(tm / 86400) + 1;
	-- Calculate month
	while tm >= me.secondsInMonth[t.isLeap and t.month + 12 or t.month] do
		tm = tm - me.secondsInMonth[t.isLeap and t.month + 12 or t.month];
		t.month = t.month + 1;
	end
	-- Calculate day, hour, minute and seconds
	t.day	= math.floor(tm / me.secondsRepresentation.day)+1;	tm = tm % me.secondsRepresentation.day;
	t.hour	= math.floor(tm / me.secondsRepresentation.hour);	tm = tm % me.secondsRepresentation.hour;
	t.min	= math.floor(tm / me.secondsRepresentation.min);		tm = tm % me.secondsRepresentation.min;
	t.sec	= math.floor(tm);
	if fmt and fmt == "*t" or fmt == "!*t" then
		return t;
	elseif fmt == nil then
		fmt = "%c"
	end;
	-- Apply patterns
	for key,fn in pairs(me.patterns) do
		if fmt and fmt:find("%"..key) then
			fmt = fn(fmt, key, t)
		end
	end
	-- Fix % char
	if fmt and fmt:find("%%") then
		fmt = string.gsub(fmt, "%%", "%")
	end;
	-- return formatted string (splall trick for nill value)
	return (fmt == nil) and "nil" or tostring(fmt)
end
function me.exit() end
function me.execute() end
function me.getenv() end
function me.remove() end
function me.rename() end
function me.setlocale() end
function me.tmpname() end
SLASH_pyos1 ="/os"
SlashCmdList["pyos"] = function(editBox, msg)
	if msg=="reset" then
		OS_BASETIME=0;
	elseif string.find(msg,"settime") then
		if string.find(msg, "(%d%d)/(%d%d)/(%d%d) (%d%d):(%d%d)") then
			local _,_,m, d, y, h, M = string.find(msg, "(%d%d)/(%d%d)/(%d%d) (%d%d):(%d%d)");
			OS_BASETIME=me.time({year=tonumber("20"..y),month=tonumber(m),day=tonumber(d),hour=tonumber(h),min=tonumber(M),sec=0})-GetTime();
		end
	elseif msg=="chat" then
		me.config.usechat = not me.config.usechat
		printf("osFix: Use Chat %s", me.config.usechat and "enabled" or "disabled")
	else
		print("osFix help:\n /os settime mm/dd/yy hh:mm\n/os reset\n/os chat [enables/disables sync with chat]");
	end
end;
ptl.CreateTable(me, me.name, nil, _G) --Create Parent
