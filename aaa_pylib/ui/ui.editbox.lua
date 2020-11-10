--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.editbox ------------------------------------------------------
local me = {}
--- Init
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.button
--		@param CaretColor (string, table({r,g,b})) Frame visible
--		@param KeyboardInputEnable (boolean)
--		@param PasswordMode (boolean)
--		@param RTL (boolean)
--		@param Text (string, number)
--		@param TextColor (string, table({r,g,b}) ) Frame visible
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	me.InitWidget(frame, "Frame", tbl)
	if tbl.CaretColor then
		local color = tbl.CaretColor
		if type(color)=="string" then
			color = me.GetColorByName(color)
		end
		if type(color)=="table" and #color==3 then
			frame:SetCaretColor(unpack(color))
		end
	end
	if type(tbl.KeyboardInputEnable)=="boolean" then
		frame:SetKeyboardInputEnable(tbl.KeyboardInputEnable)
	end
	if type(tbl.PasswordMode)=="boolean" then
		frame:SetPasswordMode(tbl.PasswordMode)
	end
	if type(tbl.RTL)=="boolean" then
		frame:SetRTL(tbl.RTL)
	end
	if type(tbl.Text)=="string" or type(tbl.Text)=="number" then
		frame:SetText(tbl.Text)
	end
	if tbl.TextColor then
		local color = tbl.TextColor
		if type(color)=="string" then
			color = me.GetColorByName(color)
		end
		if type(color)=="table" and #color==3 then
			frame:SetTextColor(unpack(color))
		end
	end
	frame._ClearFocus = tbl.ClearFocus
end


lib.CreateTable(me,name,path, lib)
