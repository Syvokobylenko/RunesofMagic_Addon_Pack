--[[
pbInfo - Libs/lib.WordWrap.lua
	v0.51-fix
	by p.b. a.k.a. novayuna
	released under the Creative Commons License By-Nc-Sa: http://creativecommons.org/licenses/by-nc-sa/3.0/
	
	original code by Tomi H.: http://shadow.vs-hs.org/library/index.php?page=2&id=48
]]
function WordWrap(strText, intMaxLength)
	local tblOutput = {};
	local intIndex;
	local strBuffer = "";
	local tblLines = Explode(strText, "\n");
	for k, strLine in pairs(tblLines) do
		local tblWords = Explode(strLine, " ");
		if (#tblWords > 0) then
			intIndex = 1;
			while tblWords[intIndex] do
				local strWord = " " .. tblWords[intIndex];
				if (strBuffer:len() >= intMaxLength) then
					table.insert(tblOutput, strBuffer:sub(1, intMaxLength));
					strBuffer = strBuffer:sub(intMaxLength + 1);
				else
					if (strWord:len() > intMaxLength) then
						strBuffer = strBuffer .. strWord;
					elseif (strBuffer:len() + strWord:len() >= intMaxLength) then
						table.insert(tblOutput, strBuffer);
						strBuffer = ""
					else
						if (strBuffer == "") then
							strBuffer = strWord:sub(2);
						else
							strBuffer = strBuffer .. strWord;
						end;
						intIndex = intIndex + 1;
					end;
				end;
			end;
			if (strBuffer != "") then
				table.insert(tblOutput, strBuffer);
				strBuffer = ""
			end;
		end;
	end;
	return tblOutput;
end;

function Explode(strText, strDelimiter)
	local strTemp = "";
	local tblOutput = {};
	for intIndex = 1, strText:len(), 1 do
		if (strText:sub(intIndex, intIndex + strDelimiter:len() - 1) == strDelimiter) then
			table.insert(tblOutput, strTemp);
			strTemp = "";
		else
			strTemp = strTemp .. strText:sub(intIndex, intIndex);
		end;
	end;
	if (strTemp != "") then
		table.insert(tblOutput, strTemp)
	end;
	return tblOutput;
end;