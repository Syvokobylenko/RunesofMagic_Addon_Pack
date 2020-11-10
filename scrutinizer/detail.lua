local scrutinizer = scrutinizer

local ipairs = ipairs
local pairs = pairs
local _G = _G
local table_insert = table.insert
local table_sort = table.sort

local detailskillsslidermax = 10
local detailtypesslidermax = 3
local detailopponentsslidermax = 20
local maxdetailskills = 10
local maxdetailtypes = 6
local maxdetailopponents = 6

function scrutinizer:BarOnClick(this)
	local name = _G[this:GetName().."_Name"]:GetText()
	if name == "" then
		return
	end
	
	if name == "Pet" then
		if UnitExists(scrutinizer.playerPetID) then
			name = UnitName(scrutinizer.playerPetID)
		end
	end
	
	if not scrutinizer.combatants[name] or (name == BINDING_NAME_CHAT_PARTY) then
		return
	end
	if scrutinizer_DetailFrame:IsVisible() then
		scrutinizer_DetailFrame:Hide()
		scrutinizer:DetailFrameOnHide()
		return
	end
	local headline = name.." "..scrutinizer.combatants[name].class.."("..scrutinizer.combatants[name].level..")"
	if scrutinizer.combatants[name].sublevel > 0 then
		headline = headline.." "..scrutinizer.combatants[name].subclass.."("..scrutinizer.combatants[name].sublevel..")"
	end
	if not scrutinizer.combatants[name] or not scrutinizer.combatants[name][scrutinizer.currentcat] or not scrutinizer.combatants[name][scrutinizer.currentcat].overallvalue then
		return
	end
	local tbl = scrutinizer.combatants[name][scrutinizer.currentcat]
	local overall = tbl.overallvalue
	if overall == 0 then
		return
	end	
	local result = {}
	for _, v in ipairs(tbl.logger) do
		local value = v.val
		local skill = v.skill
		local stype = v.stype
		if not result[skill] then
			result[skill] = {
				counter = 1,
				value = value,
			}
		else
			result[skill].counter = result[skill].counter + 1
			result[skill].value = result[skill].value + value			
		end
		result[skill].average = result[skill].value/result[skill].counter
		result[skill].percentage = (result[skill].value/overall)*(100)
	end
	for _, v in ipairs(tbl.logger) do
		local value = v.val
		local skill = v.skill
		local stype = v.stype
		if not result[skill].types then
			result[skill].types = {}
		end
		if not result[skill].types[stype] then
			result[skill].types[stype] = {
				counter = 1,
				value = value,
			}
		else
			result[skill].types[stype].counter = result[skill].types[stype].counter + 1
			result[skill].types[stype].value = result[skill].types[stype].value + value
		end
		result[skill].types[stype].average = result[skill].types[stype].value/result[skill].types[stype].counter
		if result[skill].counter > 0 then
			result[skill].types[stype].percentage = (result[skill].types[stype].counter/result[skill].counter)*(100)
		else
			result[skill].types[stype].percentage = 0
		end
	end
	for _, v in ipairs(tbl.logger) do
		local value = v.val
		local skill = v.skill
		local stype = v.stype
		local opponent = v.opponent
		if not result[skill].opponents then
			result[skill].opponents = {}
		end
		if not result[skill].opponents[opponent] then
			result[skill].opponents[opponent] = {
				counter = 1,
				value = value,
				maxvalue = value,
				minvalue = value,
			}
		else
			result[skill].opponents[opponent].counter = result[skill].opponents[opponent].counter + 1
			result[skill].opponents[opponent].value = result[skill].opponents[opponent].value + value
			if result[skill].opponents[opponent].maxvalue < value then
				result[skill].opponents[opponent].maxvalue = value
			end
			if result[skill].opponents[opponent].minvalue > value then
				result[skill].opponents[opponent].minvalue = value
			end
		end
		result[skill].opponents[opponent].average = result[skill].opponents[opponent].value/result[skill].opponents[opponent].counter
		if (result[skill].opponents[opponent].minvalue == 0) and (result[skill].opponents[opponent].average > 0) and (result[skill].opponents[opponent].maxvalue > result[skill].opponents[opponent].average) then
			result[skill].opponents[opponent].minvalue = result[skill].opponents[opponent].average
			result[skill].opponents[opponent].average = (result[skill].opponents[opponent].average + result[skill].opponents[opponent].maxvalue) / 2
		end
	end
	scrutinizer.cache.detail = {
		skills = {},
		headline = headline,
		tooltips = {},
	}
	local i = 1
	for skill, v in pairs(result) do
		scrutinizer.cache.detail.skills[i] = {
			skill = skill,
			counter = v.counter,
			value = v.value,
			average = v.average,
			percentage = v.percentage,
			types = {},
			opponents = {},
		}
		for stype, u in pairs(result[skill].types) do
			table_insert(scrutinizer.cache.detail.skills[i].types, {
				stype = stype,
				value = u.value,
				counter = u.counter,
				average = u.average,
				percentage = u.percentage,
			})
		end
		for opponent, u in pairs(result[skill].opponents) do
			table_insert(scrutinizer.cache.detail.skills[i].opponents, {
				opponent = opponent,
				value = u.value,
				counter = u.counter,
				average = u.average,
				minvalue = u.minvalue,
				maxvalue = u.maxvalue,
			})
		end
		i = i + 1
	end
	table_sort(scrutinizer.cache.detail.skills, function(a, b)
		if a.value > b.value then
			return true
		end
	end)
	for i = 1, #scrutinizer.cache.detail.skills do
		table_sort(scrutinizer.cache.detail.skills[i].types, function(a, b)
			if a.percentage > b.percentage then
				return true
			end
		end)
		local bossopponents = {}
		local normalopponents = {}
		for k, v in ipairs (scrutinizer.cache.detail.skills[i].opponents) do
			if scrutinizer:IsBossByName(v.opponent) then
				table_insert(bossopponents, {
					opponent = scrutinizer.colors.detail.boss..v.opponent .. "|r",
					value = v.value,
					counter = v.counter,
					average = v.average,
					minvalue = v.minvalue,
					maxvalue = v.maxvalue,
				})
			else
				table_insert(normalopponents, {
					opponent = scrutinizer.colors.detail.normal..v.opponent,
					value = v.value,
					counter = v.counter,
					average = v.average,
					minvalue = v.minvalue,
					maxvalue = v.maxvalue,
				})				
			end
		end
		table_sort(bossopponents, function(a, b)
			if a.value > b.value then
				return true
			end
		end)
		table_sort(normalopponents, function(a, b)
			if a.value > b.value then
				return true
			end
		end)
		scrutinizer.cache.detail.skills[i].opponents = {}
		for k, v in ipairs(bossopponents) do
			table_insert(scrutinizer.cache.detail.skills[i].opponents, {
				opponent = v.opponent,
				value = v.value,
				counter = v.counter,
				average = v.average,
				minvalue = v.minvalue,
				maxvalue = v.maxvalue,
			})
		end
		for k, v in ipairs(normalopponents) do
			table_insert(scrutinizer.cache.detail.skills[i].opponents, {
				opponent = v.opponent,
				value = v.value,
				counter = v.counter,
				average = v.average,
				minvalue = v.minvalue,
				maxvalue = v.maxvalue,
			})
		end
	end
	scrutinizer.cache.detail.tooltips.types = {}
	for _, v in ipairs(tbl.logger) do
		if not scrutinizer.cache.detail.tooltips.types[v.skill] then
			scrutinizer.cache.detail.tooltips.types[v.skill] = {
				counter = {},
				single = {},
			}
		end
		if not scrutinizer.cache.detail.tooltips.types[v.skill].counter[v.opponent] then
			scrutinizer.cache.detail.tooltips.types[v.skill].counter[v.opponent] = 1
		else
			scrutinizer.cache.detail.tooltips.types[v.skill].counter[v.opponent] = scrutinizer.cache.detail.tooltips.types[v.skill].counter[v.opponent] + 1
		end
		if not scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype] then
			scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype] = {}
		end
		local tinsertid = 0
		for m, n in ipairs(scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype]) do
			if n.opponent and (n.opponent == v.opponent) then
				tinsertid = m
			end
		end
		if tinsertid == 0 then
			table_insert(scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype], {
				opponent = v.opponent,
				counter = 1,
				value = v.val,
				minvalue = v.val,
				maxvalue = v.val,
				average = v.val,
				percentage = 0,
			})
		else
			scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].counter = scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].counter + 1
			scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].value = scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].value + v.val
			if scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].minvalue > v.val then
				scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].minvalue = v.val
			end
			if scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].maxvalue < v.val then
				scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].maxvalue = v.val
			end
			scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].average = scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].value/scrutinizer.cache.detail.tooltips.types[v.skill].single[v.stype][tinsertid].counter
		end
	end
	for e, x in pairs(scrutinizer.cache.detail.tooltips.types) do
		for f, y in pairs(x.single) do
			for g, z in ipairs(y) do
				z.percentage = (z.counter/x.counter[z.opponent])*(100)
			end
		end
	end
	local bosstypes = {}
	local normaltypes = {}
	for a, x in pairs(scrutinizer.cache.detail.tooltips.types) do
		for b, y in pairs(x.single) do
			for _, z in ipairs(y) do
				if scrutinizer:IsBossByName(z.opponent) then
					if not bosstypes[a] then
						bosstypes[a] = {}
					end
					if not bosstypes[a][b] then
						bosstypes[a][b] = {}
					end
					table_insert(bosstypes[a][b], {
						opponent = scrutinizer.colors.detail.boss..z.opponent,
						counter = z.counter,
						value = z.value,
						minvalue = z.minvalue,
						maxvalue = z.maxvalue,
						average = z.average,
						percentage = z.percentage,
					})
				else
					if not normaltypes[a] then
						normaltypes[a] = {}
					end
					if not normaltypes[a][b] then
						normaltypes[a][b] = {}
					end
					table_insert(normaltypes[a][b], {
						opponent = scrutinizer.colors.detail.normal..z.opponent,
						counter = z.counter,
						value = z.value,
						minvalue = z.minvalue,
						maxvalue = z.maxvalue,
						average = z.average,
						percentage = z.percentage,
					})
				end
			end
		end
	end
	for _, x in pairs(bosstypes) do
		for _, y in pairs(x) do
			table_sort(y, function(a, b)
				if a.value > b.value then
					return true
				end
			end)
		end
	end
	for _, x in pairs(normaltypes) do
		for _, y in pairs(x) do
			table_sort(y, function(a, b)
				if a.value > b.value then
					return true
				end
			end)
		end
	end
	scrutinizer.cache.detail.tooltips.types = {}
	for k, v in pairs(bosstypes) do
		for i, j in pairs(v) do
			if not scrutinizer.cache.detail.tooltips.types[k] then
				scrutinizer.cache.detail.tooltips.types[k] = {}
			end
			if not scrutinizer.cache.detail.tooltips.types[k][i] then
				scrutinizer.cache.detail.tooltips.types[k][i] = {}
			end
		end
	end
	for k, v in pairs(normaltypes) do
		for i, j in pairs(v) do
			if not scrutinizer.cache.detail.tooltips.types[k] then
				scrutinizer.cache.detail.tooltips.types[k] = {}
			end
			if not scrutinizer.cache.detail.tooltips.types[k][i] then
				scrutinizer.cache.detail.tooltips.types[k][i] = {}
			end
		end
	end	
	for a, x in pairs(bosstypes) do
		for b, y in pairs(x) do
			for k, v in ipairs(y) do
				table_insert(scrutinizer.cache.detail.tooltips.types[a][b], {
					opponent = v.opponent,
					counter = v.counter,
					value = v.value,
					minvalue = v.minvalue,
					maxvalue = v.maxvalue,
					average = v.average,
					percentage = v.percentage,
				})
			end
		end
	end
	for a, x in pairs(normaltypes) do
		for b, y in pairs(x) do
			for k, v in ipairs(y) do
				table_insert(scrutinizer.cache.detail.tooltips.types[a][b], {
					opponent = v.opponent,
					counter = v.counter,
					value = v.value,
					minvalue = v.minvalue,
					maxvalue = v.maxvalue,
					average = v.average,
					percentage = v.percentage,
				})
			end
		end
	end
	scrutinizer.cache.detail.tooltips.opponents = {}
	for _, v in ipairs(tbl.logger) do
		if not scrutinizer.cache.detail.tooltips.opponents[v.opponent] then
			scrutinizer.cache.detail.tooltips.opponents[v.opponent] = {
				value = 0,
				single = {},
			}
		end
	end
	for oopponent in pairs(scrutinizer.cache.detail.tooltips.opponents) do
		for cname, b in pairs(scrutinizer.combatants) do
			if not scrutinizer:IsPartyMemberByName(cname) then
				if b[scrutinizer.currentcat] then
					for _, c in ipairs(b[scrutinizer.currentcat].logger) do
						if c.opponent == oopponent then
							local oinsertid = 0
							for id, d in ipairs(scrutinizer.cache.detail.tooltips.opponents[oopponent].single) do
								if d.name == cname then
									oinsertid = id
									break
								end					
							end
							if oinsertid == 0 then
								table_insert(scrutinizer.cache.detail.tooltips.opponents[oopponent].single, {
									name = cname,
									value = c.val,
									percentage = 0,
								})
							else
								scrutinizer.cache.detail.tooltips.opponents[oopponent].single[oinsertid].value = scrutinizer.cache.detail.tooltips.opponents[oopponent].single[oinsertid].value + c.val
							end
							scrutinizer.cache.detail.tooltips.opponents[oopponent].value = scrutinizer.cache.detail.tooltips.opponents[oopponent].value + c.val
						end
					end
				end
			end
		end
	end
	for _, v in pairs(scrutinizer.cache.detail.tooltips.opponents) do
		for _, w in ipairs(v.single) do
			if v.value > 0 then
				w.percentage = (w.value/v.value)*(100)
			end
		end
	end
	for _, v in pairs(scrutinizer.cache.detail.tooltips.opponents) do
		table_sort(v.single, function(a, b)
			if a.percentage > b.percentage then
				return true
			end
		end)
	end
	scrutinizer_DetailFrame:Show()
end

function scrutinizer:ModifyDetailSkills(id, skill, counter, value, average, percentage)
	value = scrutinizer:FormatValue(value)
	average = scrutinizer:FormatValue(average)
	percentage = scrutinizer:FormatValue(percentage)
	if skill == "" then
		_G["scrutinizer_DetailFrame_Skills"..id.."_Button"]:Hide()
	else
		_G["scrutinizer_DetailFrame_Skills"..id.."_Button"]:Show()
		_G["scrutinizer_DetailFrame_Skills"..id.."_Button"]:UnlockHighlight()
		counter = "#"..counter
		average = "\195\184"..average
		percentage = percentage.."%"
	end
	_G["scrutinizer_DetailFrame_Skills"..id.."_Skill"]:SetText(skill)
	_G["scrutinizer_DetailFrame_Skills"..id.."_Counter"]:SetText(counter)
	_G["scrutinizer_DetailFrame_Skills"..id.."_Value"]:SetText(value)
	_G["scrutinizer_DetailFrame_Skills"..id.."_Average"]:SetText(average)
	_G["scrutinizer_DetailFrame_Skills"..id.."_Percentage"]:SetText(percentage)
end

function scrutinizer:DetailFrameOnShow()
	scrutinizer_DetailFrame_Text:SetText(scrutinizer.cache.detail.headline)
	if #scrutinizer.cache.detail.skills > 0 then
		local i = 1
		for _, v in ipairs(scrutinizer.cache.detail.skills) do
			if i > maxdetailskills then
				break
			end
			scrutinizer:ModifyDetailSkills(i, v.skill, v.counter, v.value, v.average, v.percentage)
			i = i + 1
		end
		for j = i, maxdetailskills do
			scrutinizer:ModifyDetailSkills(j, "", "", "", "", "")
		end
	end
end

function scrutinizer:DetailFrameOnHide()
	scrutinizer:UnlockHighlightAllSkills()
	scrutinizer:ResetSkillsSlider()
	scrutinizer:ResetTypesSlider()
	scrutinizer:ClearTypes()
	scrutinizer:ResetOpponentsSlider()
	scrutinizer:ClearOpponents()
	scrutinizer.currentlylockedskill.button = 0
	scrutinizer.currentlylockedskill.skill = 0
	scrutinizer.currentlylockedskill.name = ""
	scrutinizer.cache.detail = {}
end

function scrutinizer:InitSkillsSlider(this)
	this:SetValueStepMode("INT")
	this:SetMinMaxValues(1, detailskillsslidermax)
end

function scrutinizer:InitTypesSlider(this)
	this:SetValueStepMode("INT")
	this:SetMinMaxValues(1, detailtypesslidermax)
end

function scrutinizer:InitOpponentsSlider(this)
	this:SetValueStepMode("INT")
	this:SetMinMaxValues(1, detailopponentsslidermax)
end

function scrutinizer:ResetSkillsSlider()
	_G["scrutinizer_DetailFrame_Slider"]:SetValue(1)
end

function scrutinizer:ResetTypesSlider()
	_G["scrutinizer_DetailFrame_Types_Slider"]:SetValue(1)
end

function scrutinizer:ResetOpponentsSlider()
	_G["scrutinizer_DetailFrame_Opponents_Slider"]:SetValue(1)
end

function scrutinizer:SkillOnClick(this)
	scrutinizer:UnlockHighlightAllSkills()
	local skill = _G[this:GetParent():GetName().."_Skill"]:GetText()
	if skill == "" then
		return
	end
	local id = _G[this:GetParent():GetName()]:GetID()
	scrutinizer:LockHighlightSkillButton(id)
	scrutinizer.currentlylockedskill.button = id
	scrutinizer.currentlylockedskill.name = skill
	scrutinizer:ResetTypesSlider()
	scrutinizer:ResetOpponentsSlider()
	for k, v in ipairs(scrutinizer.cache.detail.skills) do
		if skill == v.skill then
			scrutinizer.currentlylockedskill.skill = k
			local i = 1
			for _, w in ipairs(scrutinizer.cache.detail.skills[k].types) do
				if i > maxdetailtypes then
					break
				end
				scrutinizer:ModifyDetailTypes(i, w.stype, w.counter, w.value, w.average, w.percentage)
				i = i + 1
			end
			for j = i, maxdetailtypes do
				scrutinizer:ModifyDetailTypes(j, "", "", "", "", "")
			end
			local y = 1
			for _, w in ipairs(scrutinizer.cache.detail.skills[k].opponents) do
				if y > maxdetailopponents then
					break
				end
				scrutinizer:ModifyDetailOpponents(y, w.opponent, w.value, w.counter, w.average, w.minvalue, w.maxvalue)
				y = y + 1
			end
			for z = y, maxdetailopponents do
				scrutinizer:ModifyDetailOpponents(z, "", "", "", "", "", "")
			end			
		end
	end
end

function scrutinizer:LockHighlightSkillButton(id)
	_G["scrutinizer_DetailFrame_Skills"..id.."_Button"]:LockHighlight()
end

function scrutinizer:UnlockHighlightAllSkills()
	for id = 1, maxdetailskills do
		_G["scrutinizer_DetailFrame_Skills"..id.."_Button"]:UnlockHighlight()
	end
end

function scrutinizer:SkillsOnValueChanged(this)
	scrutinizer:UnlockHighlightAllSkills()
	local value = this:GetValue()
	local detailid = (value * maxdetailskills) - (maxdetailskills - 1)
	local i = 1
	if scrutinizer.cache.detail.skills then
		for k, v in ipairs(scrutinizer.cache.detail.skills) do
			if i > maxdetailskills then
				break
			end
			if k >= detailid then
				scrutinizer:ModifyDetailSkills(i, v.skill, v.counter, v.value, v.average, v.percentage)
				if scrutinizer.currentlylockedskill.button > 0 then
					if i == scrutinizer.currentlylockedskill.button and k == scrutinizer.currentlylockedskill.skill then
						scrutinizer:LockHighlightSkillButton(i)
					end
				end
				i = i + 1
			end
		end
		for j = i, maxdetailskills do
			scrutinizer:ModifyDetailSkills(j, "", "", "", "", "")
		end
	end
end

function scrutinizer:ModifyDetailTypes(id, stype, counter, value, average, percentage)
	value = scrutinizer:FormatValue(value)
	average = scrutinizer:FormatValue(average)
	percentage = scrutinizer:FormatValue(percentage)
	if stype == "CRITIAL" then
		stype = "CRITICAL"
	end
	if (scrutinizer.currentlylockedskill.name == "ATTACK") and (stype == "HALF") then
		stype = "PARRY"
	end
	if (scrutinizer.currentlylockedskill.name == "ATTACK") and (stype == "DOUBLE") then
		stype = "CRITICAL"
	end
	_G["scrutinizer_DetailFrame_Types_Type"..id.."_Tooltipframe_Type"]:SetText(stype)
	if stype ~= "" then
		counter = "#"..counter
		average = "\195\184"..(average)
		percentage = (percentage).."%"
	end
	_G["scrutinizer_DetailFrame_Types_Type"..id.."_Counter"]:SetText(counter)
	_G["scrutinizer_DetailFrame_Types_Type"..id.."_Value"]:SetText((value))
	_G["scrutinizer_DetailFrame_Types_Type"..id.."_Average"]:SetText(average)
	_G["scrutinizer_DetailFrame_Types_Type"..id.."_Percentage"]:SetText(percentage)
end

function scrutinizer:TypesOnValueChanged(this)
	local value = this:GetValue()
	local detailid = (value * maxdetailtypes) - (maxdetailtypes - 1)
	local i = 1
	if scrutinizer.cache.detail.skills and scrutinizer.currentlylockedskill.skill > 0 then
		for k, v in ipairs(scrutinizer.cache.detail.skills[scrutinizer.currentlylockedskill.skill].types) do
			if i > maxdetailtypes then
				break
			end
			if k >= detailid then
				scrutinizer:ModifyDetailTypes(i, v.stype, v.counter, v.value, v.average, v.percentage)
				i = i + 1
			end
		end
		for j = i, maxdetailtypes do
			scrutinizer:ModifyDetailTypes(j, "", "", "", "", "")
		end
	end
end

function scrutinizer:ClearTypes()
	for i = 1, maxdetailtypes do
		scrutinizer:ModifyDetailTypes(i, "", "", "", "", "")
	end
end

function scrutinizer:ModifyDetailOpponents(id, opponent, value, counter, average, minvalue, maxvalue)
	value = scrutinizer:FormatValue(value)
	average = scrutinizer:FormatValue(average)
	minvalue = scrutinizer:FormatValue(minvalue)
	maxvalue = scrutinizer:FormatValue(maxvalue)
	_G["scrutinizer_DetailFrame_Opponents_Opponent"..id.."_Tooltipframe_Opponent"]:SetText(opponent)
	if opponent ~= "" then
		counter = "#"..counter
		minvalue = (minvalue).."<"
		maxvalue = "<"..(maxvalue)
		average = "\195\184"..(average)
	end
	_G["scrutinizer_DetailFrame_Opponents_Opponent"..id.."_Counter"]:SetText(counter)
	_G["scrutinizer_DetailFrame_Opponents_Opponent"..id.."_Value"]:SetText((value))
	_G["scrutinizer_DetailFrame_Opponents_Opponent"..id.."_MinValue"]:SetText(minvalue)
	_G["scrutinizer_DetailFrame_Opponents_Opponent"..id.."_Average"]:SetText(average)
	_G["scrutinizer_DetailFrame_Opponents_Opponent"..id.."_MaxValue"]:SetText(maxvalue)
end

function scrutinizer:OpponentsOnValueChanged(this)
	local value = this:GetValue()
	local detailid = (value * maxdetailopponents) - (maxdetailopponents - 1)
	local i = 1
	if scrutinizer.cache.detail.skills and scrutinizer.currentlylockedskill.skill > 0 then
		for k, v in ipairs(scrutinizer.cache.detail.skills[scrutinizer.currentlylockedskill.skill].opponents) do
			if i > maxdetailopponents then
				break
			end
			if k >= detailid then
				scrutinizer:ModifyDetailOpponents(i, v.opponent, v.value, v.counter, v.average, v.minvalue, v.maxvalue)
				i = i + 1
			end
		end
		for j = i, maxdetailopponents do
			scrutinizer:ModifyDetailOpponents(j, "", "", "", "", "", "")
		end
	end	
end

function scrutinizer:ClearOpponents()
	for i = 1, maxdetailopponents do
		scrutinizer:ModifyDetailOpponents(i, "", "", "", "", "", "")
	end
end