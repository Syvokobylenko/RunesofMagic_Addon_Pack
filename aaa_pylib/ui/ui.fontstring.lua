--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.fontstring ------------------------------------------------------
local me = {}
--- Init Fontstring
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.layout
--		@param HideDot (boolean or nil) Hides Last Dot
--		@param Font (table or nil) Sets Font
--				@param File (string) Filename of font file
--				@param Size (number or nil) FontSize (default 11)
--				@param Weight (string [THIN, NORMAL, BOLD] or nil) Weight of text.	(default NORMAL)
--				@param Outline (string [NONE,NORMAL,THICK] or nil) Type of shadow outline on text.	(default NORMAL)
--		@param FontSize (number or nil) Sets Fontsize
--		@param JustifyHType ("LEFT", "CENTER", "RIGHT" or nil) Sets the horizontal justification for FontStrings.
--		@param RTL (boolean or nil) Sets whether a text direction is right to left or left to right
--		@param Text (string, number or nil) Sets Text
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	if tbl.HideDot==true then
		frame:HideLastDot()
	end
	if type(tbl.Font)=="table" then
		if type(tbl.Font.File)=="string" then
			local font = tbl.Font
			frame:SetFont(font.File,
				type(font.Size)=="number" and font.Size or 11,
				type(font.Weight)=="string" and font.Weight or "NORMAL",
				type(font.Outline)=="string" and font.Outline or "NORMAL")
		end
	end
	if type(tbl.FontSize)=="number" then
		frame:SetFontSize(tbl.FontSize)
	end
	if type(tbl.JustifyHType)=="string" then
		frame:SetJustifyHType(tbl.JustifyHType)
	end
	if type(tbl.RTL)=="boolean" then
		frame:SetRTL(tbl.RTL)
	end
	if type(tbl.Text)=="string" or type(tbl.Text)=="number" then
		frame:SetText(tbl.Text)
	end
	me.InitWidget(frame, "layout", tbl)
end
lib.CreateTable(me,name,path, lib)
