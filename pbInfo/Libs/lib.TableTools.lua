--[[
pbInfo - Libs/lib.TableTools.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]
do
	--[[
	parseTable (local)
		param: 	table 	array
				integer 	depth
		return: 	table
	]]
	local function parseTable(array, depth)
		local data, tabs = "", "";
		if (pbIsEmpty(depth) or depth < 1) then depth = 1 end;
		for i = 1, depth, 1 do
			tabs = tabs .. "\t";
		end;
		for k, v in pairs(array) do
			data = data .. tabs .. "[" .. (((type(k) == "number") and k) or '"' .. tostring(k) .. '"') .. "] = ";
			if (type(v) == "number") then
				data = data .. v .. ",\n";
			elseif (type(v) == "table") then
				data = data .. "{\n" .. parseTable(v, depth + 1) .. tabs .. "},\n";
			else
				data = data .. '"' .. tostring(v) .. '",\n';
			end;
		end;
		return data;
	end;

	TableTools = {}
	--[[
	TableTools.saveTable
		param: 	table 	array
				string 	filename
		return: 	true
			or	false, error
	]]
	function TableTools.saveTable(array, filename)
		local file, err = io.open(filename, "w");
		if (err) then
			return false, err;
		end;
		file:write("return {\n" .. parseTable(array, 1) .. "};");
		file:close();
		return true;
	end;
	--[[
	TableTools.loadTable
		param: 	string 	filename
		return: 	table
			or	false, error
	]]
	function TableTools.loadTable(filename)
		local array, err = loadfile(filename);
		if (err) then
			return false, err;
		end;
		return dofile(filename);
	end;
	--[[
	TableTools.getTableString
		param: 	table		array
		return: 	string
	]]
	function TableTools.getTableString(array)
		return string.gsub(parseTable(array, 1), "\n", "");
	end;
end;