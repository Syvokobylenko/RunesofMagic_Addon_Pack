--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.radiobutton ------------------------------------------------------
local me = {}
--- Init
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.checkbutton
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	me.InitWidget(frame, "checkbutton", tbl)
end

lib.CreateTable(me,name,path, lib)
