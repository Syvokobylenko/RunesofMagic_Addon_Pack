local scrutinizer = scrutinizer

local _G = _G
local ipairs = ipairs
local string_sub = string.sub

function scrutinizer:BarOnEnter(this)
	local txt = _G[this:GetName().."_Name"]:GetText()
	if txt ~= "" then
	
		if txt == "Pet" then
			if UnitExists(scrutinizer.playerPetID) then
				txt = UnitName(scrutinizer.playerPetID)
			end
		end
		
		GameTooltip:SetOwner(this, "ANCHOR_PRESERVE", 0, 0)
		GameTooltip:SetText(txt)
		if txt ~= "Party" then
			GameTooltip:AddLine("|cff00ff00<click for details>|r")
		end
		GameTooltip:Show()
	end
end

function scrutinizer:SkillOnEnter(this)
	local txt = _G[this:GetParent():GetName().."_Skill"]:GetText()
	if txt ~= "" then
		GameTooltip:SetOwner(this, "ANCHOR_PRESERVE", -15, 0)
		GameTooltip:SetText(txt)
		GameTooltip:Show()
	end
end

function scrutinizer:TypeOnEnter(this)
	local txt = _G[this:GetName().."_Type"]:GetText()
	if txt ~= "" then
		GameTooltip:SetOwner(this, "ANCHOR_PRESERVE", -15, 0)
		GameTooltip:SetText(txt)
		if scrutinizer.currentlylockedskill.name == "ATTACK" and txt == "PARRY" then
			txt = "HALF"
		end
		if scrutinizer.currentlylockedskill.name == "ATTACK" and txt == "CRITICAL" then
			txt = "DOUBLE"
		end
		if txt == "CRITICAL" then
			txt = "CRITIAL"
		end
		if scrutinizer.currentlylockedskill.name ~= "" then
			for k, v in ipairs(scrutinizer.cache.detail.tooltips.types[scrutinizer.currentlylockedskill.name][txt]) do
				GameTooltip:AddDoubleLine(
					k..". "..v.opponent,
					scrutinizer:FormatValue(v.value).." "..
					"\195\184"..scrutinizer:FormatValue(v.average).." "..
					"#"..v.counter.." ("..
					scrutinizer:FormatValue(v.percentage).."%)"
				)
			end			
		end		
		GameTooltip:Show()
	end
end

function scrutinizer:OpponentOnEnter(this)
	local txt = _G[this:GetName().."_Opponent"]:GetText()
	if txt ~= "" then
		GameTooltip:SetOwner(this, "ANCHOR_PRESERVE", -15, 0)
		GameTooltip:SetText(txt)
		txt = string_sub(txt, 11)
		if scrutinizer.cache.detail.tooltips.opponents[txt] then
			for k, v in ipairs(scrutinizer.cache.detail.tooltips.opponents[txt].single) do
				GameTooltip:AddDoubleLine(
					k..". "..v.name,
					scrutinizer:FormatValue(v.value).." ("..
					scrutinizer:FormatValue(v.percentage).."%)"
				)
			end
		end
		GameTooltip:Show()
	end
end