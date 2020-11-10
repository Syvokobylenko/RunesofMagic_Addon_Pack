local scrutinizer = scrutinizer

local pairs = pairs

function scrutinizer:SendToOnClick(this)
	local name = _G[this:GetParent():GetName().."_Name"]:GetText()
	local chan = _G[this:GetParent():GetName().."_Channel"]:GetText()
	if (name == "") and (chan == "") then
		return
	end
	if chan == "" then
		scrutinizer:SendTo("WHISPER", name)
	elseif name == "" then
		scrutinizer:SendTo("CHANNEL", chan)
	end
	this:GetParent():Hide()
	_G[this:GetParent():GetName().."_Name"]:SetText("")
	_G[this:GetParent():GetName().."_Channel"]:SetText("")
end

function scrutinizer:SendTo(chattype, pipe)
	local txt = ""
	local i = 1
	if scrutinizer:GetNumTable(scrutinizer.cache.main) > 0 then
		for _, v in pairs(scrutinizer.cache.main) do
			local values = scrutinizer:FormatValue(v.overallvalue).."("..scrutinizer:FormatValue(v.currentps).."/"..scrutinizer:FormatValue(v.overallps)
			if scrutinizer.cache.party.value ~= 0 then
				values = values.." "..scrutinizer:FormatValue((v.overallvalue/scrutinizer.cache.party.value)*(100)).."%"
			end
			values = values..")"
			txt = txt..i..". "..v.name.." "..values.."\n"
			i = i + 1
		end
	end
	
	if scrutinizer.cache.pet.value and (scrutinizer.cache.pet.value > 0) then
		txt = txt .. UnitName("player") .. "'s Pet: " .. scrutinizer:FormatValue(scrutinizer.cache.pet.value).."("..scrutinizer:FormatValue(scrutinizer.cache.pet.psCur).."/"..scrutinizer:FormatValue(scrutinizer.cache.pet.psAll) .. ")" .. "\n"
	end
	
	if txt ~= "" then
		txt = "\n".."scrutinizer: "..scrutinizer.cats[scrutinizer.currentcat].."\n" .. txt

		if not pipe then
			SendChatMessage(txt, chattype)
		else
			SendChatMessage(txt, chattype, _, pipe)
		end

	end
end

function scrutinizer:SendToSay()
	scrutinizer:SendTo("SAY")
end

function scrutinizer:SendToGuild()
	scrutinizer:SendTo("GUILD")
end

function scrutinizer:SendToParty()
	scrutinizer:SendTo("PARTY")
end

function scrutinizer:SendToWhisper()
	scrutinizer_SendTo:Show()
	scrutinizer_SendTo_Name:Show()
	scrutinizer_SendTo_Channel:Hide()
	scrutinizer_SendTo_Text2:SetText(STR_CHAT_SEND..": "..MESSAGE_WHISPER)
end

function scrutinizer:SendToChannel()
	scrutinizer_SendTo:Show()
	scrutinizer_SendTo_Name:Hide()
	scrutinizer_SendTo_Channel:Show()
	scrutinizer_SendTo_Text2:SetText(STR_CHAT_SEND..": "..CHANNEL)
end