--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.slider ------------------------------------------------------
local me = {}
--- Init
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.frame
--		@param MinValue (number)
--		@param MaxValue (number)
--		@param Value (number)
--		@param Int (bool)
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	me.InitWidget(frame, "frame", tbl)
	if type(tbl.MinValue)=="number" then
		frame:SetMinValue(tbl.MinValue)
	end
	if type(tbl.MaxValue)=="number" then
		frame:SetMaxValue(tbl.MaxValue)
	end
	if type(tbl.Value)=="number" then
		frame:SetValue(tbl.Value)
	end
	if type(tbl.Value)=="string" then
		frame:SetValue(tbl.Value)
	end
	if tbl.Int==true then
		frame:SetValueStepMode("INT")
	elseif tbl.Int==false then
		frame:SetValueStepMode("FLOAT")
	end
end


lib.CreateTable(me,name,path, lib)
