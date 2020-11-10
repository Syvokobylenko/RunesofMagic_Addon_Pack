-- last changes     by: Tinsus     at: 2016-05-05T15:16:51Z     project-version: v1.9beta1     hash: dbc2c56b08c765c0ba1f897f442100369ffc9e3c

local LI = _G.LI

function LI.io(msg, c1, c2, c3)
	if msg ~= nil then
		DEFAULT_CHAT_FRAME:AddMessage("|cffff0000LootIt!:|r "..LI.Trans(msg), tonumber(c1), tonumber(c2), tonumber(c3))
	end
end

function LI.Log(text)
	if LI.debugmode then
		DEFAULT_CHAT_FRAME:AddMessage("LI DEBUG: '"..tostring(text).."'")
	end
end

function LI.Trans(te)
	te = te or ""

	if LI_Transtext[te] then
		te = LI_Transtext[te]
	else
		for id, text in pairs(LI_Transtext) do
			te = string.gsub(te, "#"..tostring(id).."#", text)

			if not string.find(te, "#") then
				break
			end
		end
	end

	return te or "Error with translation"
end
