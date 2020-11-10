--[[
pbInfo - Libs/lib.pbTools.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
do
	--[[
	pbLoadFile
		param: 	string 	filename
		return: 	true
			or	false, error
	]]
	function pbLoadFile(filename)
		local func, err = loadfile(filename);
		if (err) then
			return false, err;
		end;
		dofile(filename);
		return true;
	end;
	--[[
	pbColor
		param:	string 	text
				string 	color
				string 	alpha
		return: 	string
	]]
	function pbColor(text, color, alpha)
		if (alpha == nil or alpha == "") then
			alpha = "FF";
		end;
		if (color == nil or color == "") then
			color = "FFFFFF";
		end;
		return "|c" .. alpha .. color .. text .. "|r";
	end;
	--[[
	pbIsEmpty
		param: 	string 	str
		return: 	boolean
	]]
	function pbIsEmpty(str, zero)
		if (type(str) == "nil" or str == "" or (zero == true and str == 0)) then
			return true;
		end;
		return false;
	end;
	--[[
	pbCleanUpUnitNamePlayer
		param: 	string 	str
		return: 	string
	]]
	function pbCleanUpUnitNamePlayer(str)
		local name = str;
		if (string.find(name, "-") ~= nil) then
			beginn, ende = string.find(name, "-");
			name = string.sub(name, (beginn + 1));
		end;
		return name;
	end;
	--[[
	pbAddThousandsSeparator
		param: 	string 	str
		return: 	string
	]]
	function pbAddThousandsSeparator(str)
		local formatted = str;
		while true do
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1' .. pbInfoSettings["ThousandsSeparatorFormat"] .. '%2');
			if (k == 0) then
				break;
			end;
		end;
		return formatted;
	end;
end;