--[[
pbInfo - Libs/lib.ConvertColots.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
do
	--[[
	makeHex (local)
		param: 	integer 	decimal
		return: 	string
	]]
	local function makeHex(decimal)
		local hex = {[10] = "A", [11] = "B", [12] = "C", [13] = "D", [14] = "E", [15] = "F"};
		if (hex[decimal] ~= nil) then
			return hex[decimal];
		end;
		return tostring(decimal);
	end;
	--[[
	HSBtoRGB
		param: 	integer 	hue
				integer 	saturation
				integer 	brightness
		return: 	integer, integer, integer
	]]
	function HSBtoRGB(hue, saturation, brightness) --thx to phreak for the original function
		local hue = math.mod(hue, 360);
		local index, minValue, maxValue, rgb, hex = math.floor(hue / 60) + 1, (brightness / 100) * ((100 - saturation) / 100), brightness / 100, {}, {};
		local conversion = {{"max", "+", "min"}, {"-", "max", "min"}, {"min", "max", "+"}, {"min", "-", "max"}, {"+", "min", "max"}, {"max", "min", "-"}};
		for color = 1, 3 do
			if (conversion[index][color] == "min") then
				rgb[color] = minValue;
			elseif (conversion[index][color] == "max") then
				rgb[color] = maxValue;
			elseif (conversion[index][color] == "+") then
				rgb[color] = minValue + (math.mod(hue, 60) / 60) * (maxValue - minValue);
			else
				rgb[color] = maxValue - (math.mod(hue, 60) / 60) * (maxValue - minValue);
			end;
		end;
		return unpack(rgb);
	end;
	--[[
	RGBtoHEX
		param: 	integer 	r
				integer 	g
				integer 	b
		return: 	string
	]]
	function RGBtoHEX(r, g, b)
		local rgb, hex = {r, g, b}, {};
		for i, v in ipairs(rgb) do
			v = math.ceil(((v > 1 and 1) or v) * 255);
			hex[i] = makeHex(v / 16 - (math.mod(v, 16) / 16)) .. makeHex(math.mod(v, 16));
		end;
		return table.concat(hex);
	end;
	--[[
	HSBtoHEX
		param: 	integer 	hue
				integer 	saturation
				integer 	brightness
		return: 	string
	]]
	function HSBtoHEX(hue, saturation, brightness)
		return RGBtoHEX(HSBtoRGB(hue, saturation, brightness));
	end;
end;