--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.timer ------------------------------------------------------
local me = {
	exports= {
		"Add","GetRemainingTime","Remove","Clear"
	},
	TimerList = {},
}

me._Init = function(val)
	if val then return end
	me.RegisterOnUpdateHandler("PYLIB_TIMER", me.Update)
end

me.Clear = function()
	me.TimerList = {}
end

me.Update = function(frame, elapsedTime)
	for key, timer in pairs(me.TimerList) do
		timer.Time = timer.Time - elapsedTime
		if timer.Time <= 0 then
			if not timer.Delay or timer.Delay <= 0 then
				me.Remove(key)
			else
				timer.Time = timer.Time + timer.Delay
				timer.NumFired = timer.NumFired + 1
				if timer.MaxNum and timer.NumFired>=timer.MaxNum then
					me.Remove(key)
				end
			end
			local Success, Error = pcall(RunScript2, timer.Script, timer, timer.Args)
			if not Success and Error then
				me.Error(me:GetFullTableName()..".Update",3, "Error while processing timer '%s: %s", key, tostring(Error))
			end
		end
	end
end
--- Registers a new me.
-- @param delay (number, table) Measured in seconds. For numbers: Synchronous delay.
-- @param script (string, functions) The script that gets executed each tick
-- @param key (string) A identifer for the timer
--
me.Add = function(delay, script, key, num, noOverride, ...)
	AssertType(delay, "delay", me:GetFullTableName()..".Add", "table", "number");
	AssertType(script, "script", me:GetFullTableName()..".Add", "function", "string");
	AssertType(key, "key", me:GetFullTableName()..".Add", "string");
	AssertType(num, "num", me:GetFullTableName()..".Add", "number","nil");
	if noOverride and me.TimerList[key] then
		return
	end
	local initdelay
	if type(delay) == "table" then
		initdelay = delay[1]
		delay = delay[2]
	else
		initdelay = delay
	end
	me.TimerList[key] = {
		Time = initdelay,
		Delay = delay,
		NumFired = 0,
		MaxNum = num,
		Script = script,
		Args = {...},
	}
end
--- Removes and stops a me.
-- @param key The timer to be removed
--
function me.Remove(key)
	AssertType(key, "key", me:GetFullTableName()..".Remove", "string");
	me.Error(me:GetFullTableName()..".Remove", 0, string.format("del timer: |cff00ff00%s|r", key))
	me.TimerList[key] = nil
end
--- Returns the remaining time after which the callback is executed
-- @param key (string) The timers identifer
--
function me.GetRemainingTime(key)
	AssertType(key, "key", me:GetFullTableName()..".GetRemainingTime", "string");
	if me.TimerList[key] then
		return me.TimerList[key].Time
	end
end
lib.CreateTable(me,name,path, lib)
