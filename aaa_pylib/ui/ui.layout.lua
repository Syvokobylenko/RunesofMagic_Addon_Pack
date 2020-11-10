--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.layout ------------------------------------------------------
local me = {}
-- @param frame (table or string) name of widget
-- @param tbl (table)
--		@param Alpha (number [0,1] or nil) Alpha of Frame
--		@param Visible (boolean or nil) Frame visible
--		@param Color (string, table({r,g,b}) or nil) Frame visible
--		@param Anchors (table or nil) Anchors
--				@param Point (string[LEFT,RIGHT,TOP,BOTTOM,CENTER,TOPLEFT,TOPRIGHT,BOTTOMLEFT,BOTTOMRIGHT] or nil) Anchor
--				@param relativePoint (string[LEFT,RIGHT,TOP,BOTTOM,CENTER,TOPLEFT,TOPRIGHT,BOTTOMLEFT,BOTTOMRIGHT] or nil) Anchor
--				@param relativeTo (string, table or nil) Name of parent frame
--				@param X (number or nil) X offset
--				@param Y (number or nil) Y offset
--		@param Size (table or nil) Size of Frame
--		@param Height (number or nil) Height of Frame
--		@param Width (number or nil) Width of Frame
--		@param Pos (table or nil) Width of Frame
--		@param Scale (number or nil) Width of Frame
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	frame:SetAlpha(type(tbl.Alpha)=="number" and tbl.Alpha or 1)
	if tbl.Visible==true then
		frame:Show()
	elseif tbl.Visible==false then
		frame:Hide()
	end
	if tbl.Color then
		local color = tbl.Color
		if type(color)=="string" then
			frame:SetColor(unpack(me.GetColorByName(color)))
		end
	end
	if type(tbl.Anchors)=="table" then
		if #tbl.Anchors>=1 then frame:ClearAllAnchors() end
		local point, relativePoint, relativeTo, offsetX, offsetY
		for _, values in ipairs(tbl.Anchors) do
			point = values.Point or "TOPLEFT"
			relativePoint= values.relativePoint or point
			relativeTo = values.relativeTo or "$parent"
			offsetX = values.X or 0
			offsetY = values.Y or 0
			frame:SetAnchor(point, relativePoint, relativeTo, offsetX, offsetY);
		end
	end
	if type(tbl.Size)=="table" then
		frame:SetSize(tbl.Size.X or 0, tbl.Size.Y or 0)
	end
	if type(tbl.Height)=="number" then
		frame:SetHeight(tbl.Height)
	end
	if type(tbl.Width)=="number" then
		frame:SetWidth(tbl.Width)
	end
	if type(tbl.Pos)=="table" then
		frame:SetPos(tbl.Pos.X or 0, tbl.Pos.Y or 0)
	end
	if type(tbl.Scale)=="number" then
		frame:SetScale(tbl.Scale)
	end
end
lib.CreateTable(me,name,path, lib)
