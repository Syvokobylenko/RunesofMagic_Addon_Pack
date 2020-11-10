--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ default lib ------------------------------------------------------
------------------------------------------------------ ui.frame ------------------------------------------------------
local me = {}
--- InitFrame
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.layout
--		@param Enabled (boolean or nil) Sets Frame Enabled or disabled
--		@param Events (numeric table or nil) Register Events
--				@Values (string): http://runesofmagic.gamepedia.com/List_of_Events
--		@param RegisterClicks (numeric table or nil) Register Clicks
--				@Values (string): LeftButton, RightButton, MiddleButton, OtherButton
--		@param RegisterDrag (numeric table or nil) Register Drag
--				@Values (string): LeftButton, RightButton, MiddleButton, OtherButton
--		@param Backdrop (table or nil)
--				@param edgefile = (string) - path and file of border texture;
--				@param bgfile = (string) - path and file to background texture;
--				@param BackgroundInsets = { top = number, left = number, bottom = number, right = number },
--				@param EdgeSize = (number) ,
--				@param TileSize = (number) ,
--		@param BackdropEdgeAlpha (number or nil) Set Backdrop Edge Alpha
--		@param BackdropEdgeColor (string, table({r,g,b}) or nil) Set Backdrop Edge Color
--		@param BackdropTileAlpha (number or nil) Set Backdrop Tile Alpha
--		@param BackdropTileColor (string, table({r,g,b}) or nil) Set Backdrop Tile Color
--		@param FrameLevel (number or nil) Level of Frame
--		@param FrameStrata (string or nil) Strata of Frame
--			@values (string):BACKGROUND, LOW, MEDIUM, HIGH, DIALOG, TOOLTIP
--		@param ID (number or nil)
--		@param KeyBoardEnable (boolean or nil)
--		@param MouseEnable (boolean or nil)
--		@param Parent (frame, string or nil) SetParent of Frame
--		@param Scripts (numeric table or nil)
--			@values(table): {Type=string, Code=string } http://runesofmagic.gamepedia.com/Widget_API_SetScripts
--		@param DelEvent (table or nil) UnRegister Events
--				@Values (string): http://runesofmagic.gamepedia.com/List_of_Events
--
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	me.InitWidget(frame, "layout", tbl)
	if tbl.Enabled==true then
		frame:Enable()
	elseif tbl.Enabled==false then
		frame:Disable()
	end
	for _, val in ipairs(tbl.Events or {}) do
		frame:RegisterEvent(val)
	end
	if type(tbl.RegisterClicks)=="table" then
		frame:RegisterForClicks(unpack(tbl.RegisterClicks))
	end
	if type(tbl.RegisterForDrag)=="table" then
		frame:RegisterForDrag(unpack(tbl.RegisterForDrag))
	end
	if type(tbl.Backdrop)=="table" then
		frame:SetBackdrop(tbl.Backdrop)
	end
	if type(tbl.BackdropEdgeAlpha)=="number" then
		frame:SetBackdropEdgeAlpha(tbl.BackdropEdgeAlpha)
	end
	if tbl.BackdropEdgeColor then
		local color = tbl.BackdropEdgeColor
		if type(color)=="string" then
			color = me.GetColorByName(color)
		end
		if type(color)=="table" and #color==3 then
			frame:SetBackdropEdgeColor(unpack(color))
		end
	end
	if type(tbl.BackdropTileAlpha)=="number" then
		frame:SetBackdropTileAlpha(tbl.BackdropTileAlpha)
	end
	if tbl.BackdropTileColor then
		local color = tbl.BackdropTileColor
		if type(color)=="string" then
			color = me.GetColorByName(color)
		end
		if type(color)=="table" and #color==3 then
			frame:SetBackdropTileColor(unpack(color))
		end
	end
	if type(tbl.FrameLevel)=="number" then
		frame:SetFrameLevel(tbl.FrameLevel)
	end
	if type(tbl.FrameStrata)=="string" then
		frame:SetFrameStrata(tbl.FrameStrata)
	end
	if type(tbl.ID)=="number" then
		frame:SetID(tbl.ID)
	end
	if type(tbl.KeyBoardEnable)=="boolean" then
		frame:SetKeyBoardEnable(tbl.KeyBoardEnable)
	end
	if type(tbl.MouseEnable)=="boolean" then
		frame:SetMouseEnable(tbl.MouseEnable)
	end
	if tbl.Parent then
		if type(tbl.Parent)=="string" then
			tbl.Parent = _G[tbl.Parent]
		end
		if type(tbl.Parent)=="table" and type(tbl.Parent.IsVisible)=="function" then
			frame:SetParent(tbl.Parent)
		end
	end
	for _, val in ipairs(tbl.Scripts or {}) do
		local typ = val[1]
		local script = val[2]
		frame:SetScripts(typ or "", script or [=[ ]=])
	end
	for _, val in ipairs(tbl.DelEvent or {}) do
		frame:UnregisterEvent(val)
	end
end


lib.CreateTable(me,name,path, lib)
