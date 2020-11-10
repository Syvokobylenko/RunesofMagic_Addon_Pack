--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.button ------------------------------------------------------
local me = {}
--- Init Button
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.frame
--		@param LockHighlight (boolean or nil) Frame visible
--		@param LockPushed (boolean or nil) Frame visible
--		@param DisabledTexture (template, texture or nil)
--		@param HighlightTexture (template, texture or nil)
--		@param NormalTexture (template, texture or nil)
--		@param PushedTexture (template, texture or nil)
--		@param Text (number, string or nil)
--		@param TextColor(string, table or nil)
--		@param LayerWidth (number or nil)
--
me.CreateTextureTemplate = function (parent, parentname, tbl, typ)
			tbl.Anchors = {
				{
					Point = "TOPLEFT",
					relativePoint = "TOPLEFT",
					relativeTo = parent,
				},
				{
					Point = "BOTTOMRIGHT",
					relativePoint = "BOTTOMRIGHT",
					relativeTo = parent,
				},}
			tbl._parent = parentname ~= "" and parentname
			tbl._name = parentname ~= "" and parentname..((typ==1 and "_Disabled") or (typ==2 and "_Highlight") or (typ==3 and "_Normal") or (typ==4 and "_Pushed") or "unk") or ""
			return tbl
end
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	me.InitWidget(frame, "frame", tbl)
	local frameName = frame:GetName()
	if tbl.LockHighlight==true then
		frame:LockHighlight()
	elseif tbl.LockHighlight==false then
		frame:UnlockHighlight()
	end
	if tbl.LockPushed==true then
		frame:LockPushed()
	elseif tbl.LockPushed==false then
		frame:UnlockPushed()
	end
	if type(tbl.DisabledTexture)=="table" then
		if type(tbl.DisabledTexture.PlayAnimation)=="function" then
			frame:SetDisabledTexture(tbl.DisabledTexture)
		elseif frame:GetDisabledTexture() then
			me.InitWidget(frame:GetDisabledTexture(),"Texture", tbl.DisabledTexture)
		else
			frame:SetDisabledTexture(me.CreateWidget("Texture", me.CreateTextureTemplate(frame, frameName, tbl.DisabledTexture,1) ,false))
		end
	end
	if type(tbl.HighlightTexture)=="table" then
		if type(tbl.HighlightTexture.PlayAnimation)=="function" then
			frame:SetHighlightTexture(tbl.HighlightTexture)
		elseif frame:GetHighlightTexture() then
			me.InitWidget(frame:GetHighlightTexture(),"Texture", tbl.HighlightTexture)
		else
			frame:SetHighlightTexture(me.CreateWidget("Texture", me.CreateTextureTemplate(frame, frameName, tbl.HighlightTexture,2) ,false))
		end
	end
	if type(tbl.NormalTexture)=="table" then
		if type(tbl.NormalTexture.PlayAnimation)=="function" then
			frame:SetNormalTexture(tbl.NormalTexture)
		elseif frame:GetNormalTexture() then
			me.InitWidget(frame:GetNormalTexture(),"Texture", tbl.NormalTexture)
		else
			frame:SetNormalTexture(me.CreateWidget("Texture", me.CreateTextureTemplate(frame, frameName, tbl.NormalTexture,3) ,false))
		end
	end
	if type(tbl.PushedTexture)=="table" then
		if type(tbl.PushedTexture.PlayAnimation)=="function" then
			frame:SetPushedTexture(tbl.PushedTexture)
		elseif frame:GetPushedTexture() then
			me.InitWidget(frame:GetPushedTexture(),"Texture", tbl.PushedTexture)
		else
			frame:SetPushedTexture(me.CreateWidget("Texture", me.CreateTextureTemplate(frame, frameName, tbl.PushedTexture,4) ,false))
		end
	end
	if type(tbl.Text)=="number" or type(tbl.Text)=="string" then
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
	if tbl.LayerWidth then
		local txt = frame:GetNormalText()
		if txt then txt:SetWidth(tbl.LayerWidth)end
		local txt = frame:GetHighlightText()
		if txt then txt:SetWidth(tbl.LayerWidth)end
		local txt = frame:GetDisabledText()
		if txt then txt:SetWidth(tbl.LayerWidth)end
	end
end


lib.CreateTable(me,name,path, lib)
