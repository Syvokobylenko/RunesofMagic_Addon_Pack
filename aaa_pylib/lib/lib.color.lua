--[[
File-Author: Pyrr
File-Hash: 7d854c80b8da104d80127c2e9eec1db83cd3fa31
File-Date: 2018-03-30T22:15:20Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.color ------------------------------------------------------
local me = {
	exports = {"GetColorByName", "GetColorByItemRarity","RGBtoHEX","RGBAtoHEX","HEXtoRGBA"},
}
me.colors = {
	red = {{1,0,0}, {0.7,0.7,1}},
	yellow = {{1,1,0},},
	orange = {{1,0.5,0}, {1,1,1}},
	green = {{0,1,0}, {0.3,0.3,1}},
	cyan = {{0,1,1}},
	blue = {{0,0,1}},
	lightblue = {{0.4,0.4,1}},
	magenta = {{1,0,1},{1,1,1}},
	white = {{1,1,1}},
	lightgray = {{0.75,0.75,0.75}},
	gray = {{0.5,0.5,0.5}},
	darkgray = {{0.25,0.25,0.25}},
	black = {{0,0,0}},
	-- rarity colors:
	[0] = {{GetItemQualityColor(0)}},
	[1] = {{GetItemQualityColor(1)}},
	[2] = {{GetItemQualityColor(2)}},
	[3] = {{GetItemQualityColor(3)}},
	[4] = {{GetItemQualityColor(4)}},
	[5] = {{GetItemQualityColor(5)}},
	[6] = {{GetItemQualityColor(6)}},
	[7] = {{GetItemQualityColor(7)}},
	[8] = {{GetItemQualityColor(8)}},
	[9] = {{GetItemQualityColor(9)}},
	[10] = {{1, 0, 0}},--physical skill
	[11] = {{0, 1, 0}}, --magical skill
	[12] = {{0.1, 0.68, 0.21}}, --passive skill
	[13] = {{1, 0, 0}},--red stat
	[14] = {{0, 1, 0}},--green stat
	[15] = {{1, 1, 0}},--yellow stat
	[16] = {{0.94, 0.38, 0.05}},-- orange stat
	[17] = {{0.94, 0.08, 0.88}},-- purple stat
}

me._Init = function(val)
	if val then return end
	me.Settings = me:GetTableRoot().Settings
end

me.ToggleColorblind = function()
	me.Settings.Colorblind = not me.Settings.Colorblind
	printf("Colorblind Mode: %s", me.Settings.Colorblind and "Enabled" or "Disabled")
	me.SendEvent("PYLIB_TOGGLE_COLORBLIND", me.Settings.Colorblind)
end
me.GetColorByName = function(name)
	name = name or "";
	name = me.colors[name] or me.colors[string.lower(name)]
	if not name then return {1,1,1} end
	if me.Settings.Colorblind then
		return name[2] or name[1] or {1,1,1}
	end
	return name[1] or {1,1,1}
end
me.GetColorByItemRarity = function(num)
	return unpack(me.GetColorByName(num or 0))
end
me.GetColorListByItemRarity = function(num)
	return me.GetColorByName(num or 0)
end
me.RGBtoHEX = function(r,g,b)
	r=math.floor(math.max(math.min(type(r)=="number" and r or 0,1),0)*255+0.5)
	g=math.floor(math.max(math.min(type(g)=="number" and g or 0,1),0)*255+0.5)
	b=math.floor(math.max(math.min(type(b)=="number" and b or 0,1),0)*255+0.5)
	return string.format("%02x%02x%02x",r,g,b)
end
me.RGBAtoHEX = function(r,g,b,a)
	local rgb = me.RGBtoHEX(r,g,b)
	a=math.floor(math.max(math.min(type(a)=="number" and a or 1,1),0)*255+0.5)
	return string.format("%02x%s",a,rgb)
end
me.HEXtoRGBA = function(str)
	local a,r,g,b = string.match(str,"^(%x%x)(%x%x)(%x%x)(%x%x)$")
	if not a then
		r,g,b = string.match(str,"^(%x%x)(%x%x)(%x%x)$")
		a = 1
	end
	if not r then return 0,0,0,0 end
	return tonumber(r,16)/255,tonumber(g,16)/255,tonumber(b,16)/255,tonumber(a,16)/255
end
lib.CreateTable(me, name,path, lib)
