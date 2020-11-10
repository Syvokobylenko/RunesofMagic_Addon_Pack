--[[
File-Author: Pyrrhus
File-Hash: ef56b6a28a4a8da56f9a0f5cd0348e025bed36ca
File-Date: 2017-10-05T17:37:59Z
]]
local lib,name,path = ...

------------------------------------------------------ ui.texture ------------------------------------------------------
local me = {}
--- Init Texture
-- @param frame (table or string) name of Frame
-- @param tbl (table)
--		@params of ui.layout
--		@param AlphaMode (string[DISABLE, BLEND, ALPHAKEY,LUMINANCE, ADD] or nil) Sets the blending mode of a texture.
--		@param Animation (table or nil) Sets Font
--				@param TexImage (string) Filename of Animation
--				@param Speed (number or nil) PlayBack Speed in FPS. default(1)
--				@param FramesPerWidth (number or nil) Number of animation frames spanning the width of the image file. default(1)
--				@param Index (number or nil) Frame index to start animation from. default(1)
--				@param NumFrames (number or nil) Number of frames to play for this animation. default(1)
--		@param Cooldown (table or nil) Sets and begins the cooldown sweep on a texture.
--				@param Duration (number) - Time, in seconds, the cooldown should last for.
--				@param Remaining (number or nil) - Time, in seconds, that remains on the cooldown.
--		@param File (string or nil) Sets the file to use.
--		@param Luminance (bool or nil) Set AlphaMode to Luminance
--		@param MaskFile (string or nil) Set Mask File(background image)
--		@param Rotate (number or nil) - Angle, in radians, to rotate the texture by.
--		@param TexCoord (table or nil) - Sets the offsets into an image to use as a texture.
--				@param Left (number or nil) - Offset into image defining the left side.
--				@param Right (number or nil) - Offset into image defining the right side.
--				@param Top (number or nil) - Offset into image defining the top side.
--				@param Bottom (number or nil) - Offset into image defining the bottom side.
--		@param Texture (string or nil) - Sets the texture image file to use.
--
me.Init=function(frame, tbl)
	if type(frame)=="string" then frame = _G[frame] end
	if type(tbl)~="table" or type(frame)~="table" then return end
	me.InitWidget(frame, "layout", tbl)
	if type(tbl.AlphaMode)=="string" then
		frame:SetAlphaMode(tbl.AlphaMode)
	end
	if type(tbl.Animation)=="table" then
		if type(tbl.Animation.TexImage)=="string" then
			frame:SetAnimation(tbl.Animation.TexImage,
				type(tbl.Animation.Speed)=="number" and tbl.Animation.Speed or 1,
				type(tbl.Animation.FramesPerWidth)=="number" and tbl.Animation.FramesPerWidth or 1,
				type(tbl.Animation.Index)=="number" and tbl.Animation.Index or 1,
				type(tbl.Animation.NumFrames)=="number" and tbl.Animation.NumFrames or 1)
		end
	end
	if type(tbl.Cooldown)=="table" then
		if type(tbl.Cooldown.Duration)=="number" then
			frame:Setcooldown(tbl.Cooldown.Duration,
				type(tbl.Cooldown.Remaining)=="number" and tbl.Cooldown.Remaining or tbl.Cooldown.Duration)
		end
	end
	if type(tbl.File)=="string" then
		frame:SetFile(tbl.File)
	end
	if type(tbl.Luminance)=="boolean" then
		frame:SetLuminance(tbl.Luminance)
	end
	if type(tbl.MaskFile)=="string" then
		frame:SetMaskFile(tbl.MaskFile)
	end
	if type(tbl.Rotate)=="number" then
		frame:SetRotate(tbl.Rotate)
	end
	if type(tbl.TexCoord)=="table" then
		local left = tbl.TexCoord.Left or 0
		local right = tbl.TexCoord.Right or 1
		local top = tbl.TexCoord.Top or 0
		local bottom = tbl.TexCoord.Bottom or 1
		frame:SetTexCoord(left, right, top, bottom);
	end
	if type(tbl.Texture)=="string" then
		frame:SetTexture(tbl.Texture)
	end
end
lib.CreateTable(me,name,path, lib)
