local scrutinizer = {}
_G.scrutinizer = scrutinizer

local pairs = pairs
local table_insert = table.insert
local unpack = unpack
local _G = _G
local table_sort = table.sort
local math_abs = math.abs
local UnitName = UnitName
local GetNumPartyMembers = GetNumPartyMembers
local UnitClassToken = UnitClassToken
local UnitClass = UnitClass
local UnitLevel = UnitLevel
local GetTime = GetTime

local loaded = false
local maxbarwidth = 230
local updateinterval = 0.7

local hasPet = false

scrutinizer.version = "3.9"
scrutinizer.addon = "scrutinizer"
scrutinizer.author = "NashaRiochtDE"

scrutinizer.cats = {
	[1] = "Damage done",
	[2] = "Damage taken",
	[3] = "Healing done",
	[4] = "Healing taken",
}
scrutinizer.currentcat = 1
scrutinizer.combatants = {}
scrutinizer.updateneeded = true
scrutinizer.currentpartynum = 0
scrutinizer.cache = {
	main = {},
	detail = {},
	party = {},
	pet = {}
}
scrutinizer.currentlylockedskill = {
	button = 0,
	skill = 0,
	name = "",
}
scrutinizer.cfg = {}
scrutinizer.default = {
	resetjoin = false,
	cat = 1,
	x = 10,
	y = 10,
	scale = 0,
	alpha = 7,
	shown = true,
	autoreset = false,
	showpartybar = false,
	pinned = false,
	showpetbar = true,
}

function scrutinizer:Reset()
	scrutinizer.combatants = {}
	scrutinizer:UpdateMainFrame()
	scrutinizer_DetailFrame:Hide()
	scrutinizer:DetailFrameOnHide()
end

function scrutinizer:GetMainFramePos(x, y)
	scrutinizer.cfg.x, scrutinizer.cfg.y = x, y
end

function scrutinizer:NextCat()
	if scrutinizer.currentcat < #scrutinizer.cats then
		scrutinizer.currentcat = scrutinizer.currentcat + 1
	else
		scrutinizer.currentcat = 1
	end
	scrutinizer:SetCat()
end

function scrutinizer:SetCat()
	scrutinizer_MainFrame_Head_Text:SetText(scrutinizer.cats[scrutinizer.currentcat])
	scrutinizer.cfg.cat = scrutinizer.currentcat
	scrutinizer:UpdateMainFrame()
end

function scrutinizer:Init()
	scrutinizer.currentcat = scrutinizer.cfg.cat
	scrutinizer:SetCat()
	scrutinizer:ScaleFrames(scrutinizer.cfg.scale)
	scrutinizer:SetAlpha(scrutinizer.cfg.alpha)
	scrutinizer_MainFrame:ClearAllAnchors()
	local uiscale = GetUIScale()
	local realvalue = 1
	if scrutinizer.cfg.scale < 0 then
		realvalue = 1 - math_abs(scrutinizer.cfg.scale)/10
	else
		realvalue = 1 + (scrutinizer.cfg.scale/10)
	end
	scrutinizer_MainFrame:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", (scrutinizer.cfg.x/uiscale)/realvalue, (scrutinizer.cfg.y/uiscale)/realvalue)
	if scrutinizer.cfg.shown == nil then
		scrutinizer.cfg.shown = scrutinizer.default.shown
	end
	if not scrutinizer.cfg.shown then
		scrutinizer_MainFrame:Hide()
	else
		scrutinizer_MainFrame:Show()
	end
	if scrutinizer.cfg.autoreset == nil then
		scrutinizer.cfg.autoreset = scrutinizer.default.autoreset
	end
	if scrutinizer.cfg.autoreset then
		scrutinizer.cfg.resetjoin = false
	end
	if scrutinizer.cfg.resetjoin then
		scrutinizer.cfg.autoreset = false
	end
	if scrutinizer.cfg.showpartybar == nil then
		scrutinizer.cfg.showpartybar = scrutinizer.default.showpartybar
	end
	if scrutinizer.cfg.showpartybar then
		scrutinizer_MainFrame_Group:Show()
	else
		scrutinizer_MainFrame_Group:Hide()
	end
	if scrutinizer.cfg.pinned == nil then
		scrutinizer.cfg.pinned = scrutinizer.default.pinned
	end
	if scrutinizer.cfg.pinned then
		scrutinizer_MainFrame_Head_MoveButton:Hide()
	else
		scrutinizer_MainFrame_Head_MoveButton:Show()
	end
	
	
end

function scrutinizer:OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("SAVE_VARIABLES")
	this:RegisterEvent("PARTY_MEMBER_CHANGED")
	this:RegisterEvent("COMBATMETER_DAMAGE")
	this:RegisterEvent("COMBATMETER_HEAL")
	this:RegisterEvent("EXCHANGECLASS_SUCCESS")
	this:RegisterEvent("LOADING_END")
	this:RegisterEvent("MAP_CHANGED")
	this:RegisterEvent("ZONE_CHANGED")
	this:RegisterEvent("UNIT_PET_CHANGED")
	SaveVariablesPerCharacter("scrutinizerSVARS")
	SaveVariablesPerCharacter("scrutinizerDB")
end

function scrutinizer:OnEvent(this, event, ...)
	if event == "VARIABLES_LOADED" then
		scrutinizer.cfg = scrutinizerSVARS or scrutinizer.default
		scrutinizer:Print("scrutinizer [|cff00ff00"..ON.."|r]")
		scrutinizer:Print("/scrutinizer")
		scrutinizer:Init()
		scrutinizer:PartyInfo()
		scrutinizer:PartyChanged()
		
		scrutinizer:UpdatePet()
		scrutinizer:UpdateAnchors()
		
		loaded = true
		this:Show()
	elseif event == "SAVE_VARIABLES" then
		scrutinizerSVARS = scrutinizer.cfg
	end
	if not loaded then
		return
	end
	if event == "PARTY_MEMBER_CHANGED" then
		scrutinizer:PartyInfo()
		scrutinizer:PartyChanged()
		
		scrutinizer:UpdateAnchors()
		
		scrutinizer.updateneeded = true
	elseif event == "COMBATMETER_DAMAGE" then
		if scrutinizer:IsPartyMemberByName(_source) and (_source ~= _target) then
			scrutinizer:AddCombatData(GetTime(), 1, _source, _damage, _target, _skill, _type)
		end
		if scrutinizer:IsPartyMemberByName(_target) then
			scrutinizer:AddCombatData(GetTime(), 2, _target, _damage, _source, _skill, _type)
		end
		scrutinizer.updateneeded = true
	elseif event == "COMBATMETER_HEAL" then
		if scrutinizer:IsPartyMemberByName(_source) then
			scrutinizer:AddCombatData(GetTime(), 3, _source, _heal, _target, _skill, _type)
		end
		if scrutinizer:IsPartyMemberByName(_target) then
			scrutinizer:AddCombatData(GetTime(), 4, _target, _heal, _source, _skill, _type)
		end
		scrutinizer.updateneeded = true
	else
		if 	event == "EXCHANGECLASS_SUCCESS" or
			event == "LOADING_END" or
			event == "MAP_CHANGED" or
			event == "ZONE_CHANGED" then
			scrutinizer.updateneeded = true
		end
		if event == "UNIT_PET_CHANGED" then
			scrutinizer:UpdatePet()
			scrutinizer:UpdateAnchors()
		end
	end
end

function scrutinizer:UpdatePet()
	if UnitExists(scrutinizer.playerPetID) then
		hasPet = true
		if not _G["scrutinizer_MainFrame_Pet"]:IsVisible() then
			_G["scrutinizer_MainFrame_Pet"]:Show()
		end
	else
		hasPet = false
		_G["scrutinizer_MainFrame_Pet"]:Hide()
	end
end

function scrutinizer:PartyChanged()
	local c = 0
	for i = 1, 5 do
		if UnitName(scrutinizer.partyID[i]) then
			c = c + 1
		end
	end
	if scrutinizer.currentpartynum ~= c then
		if (scrutinizer.currentpartynum == 0) and (c > 0) then
			if loaded then
				if scrutinizer.cfg.autoreset then
					scrutinizer:Reset()
				elseif scrutinizer.cfg.resetjoin then
					scrutinizer:ShowSubmitButton()
				end
			end
		end
	end
	scrutinizer.currentpartynum = c
end

function scrutinizer:OnUpdate(this, elapsedTime)
	if not this.timer then
		this.timer = 0
	end
	this.timer = this.timer + elapsedTime
	if this.timer > updateinterval then
		if scrutinizer.updateneeded and this:IsVisible() then
			scrutinizer:UpdateMainFrame()
		end
		this.timer = 0
	end
end

function scrutinizer:AddCombatData(t, cat, name, val, opponent, skill, stype)
	if not scrutinizer.combatants[name] then
		scrutinizer.combatants[name] = {}
		scrutinizer:UpdateCombatant(name)
	end
	if not scrutinizer.combatants[name][cat] then
		scrutinizer.combatants[name][cat] = {
			overallvalue = 0,
			currentvalue = 0,
			starttime = 0,
			lasttime = 0,
			overalltime = 0,
			overallps = 0,
			currentps = 0,
			logger = {},
		}
	end
	table_insert(scrutinizer.combatants[name][cat].logger, {
		val = val,
		opponent = opponent,
		skill = skill,
		stype = stype,
	})
	local tbl = scrutinizer.combatants[name][cat]
	local diff = t - tbl.lasttime
	if diff > 5 then
		tbl.currentvalue = 0
		tbl.starttime = t
	else
		tbl.overalltime = tbl.overalltime + diff
	end
	tbl.overallvalue = tbl.overallvalue + val
	tbl.currentvalue = tbl.currentvalue + val
	tbl.lasttime = t
	if tbl.overalltime ~= 0 then
		tbl.overallps = tbl.overallvalue/tbl.overalltime
	else
		tbl.overallps = tbl.overallvalue
	end
	if tbl.lasttime > tbl.starttime then
		tbl.currentps = tbl.currentvalue/(tbl.lasttime - tbl.starttime)
	else
		tbl.currentps = tbl.currentvalue
	end
end

function scrutinizer:PartyInfo()
	scrutinizer:UpdateCombatant(UnitName(scrutinizer.playerID))
	if GetNumPartyMembers() > 0 then
		for i = 1, GetNumPartyMembers() do
			scrutinizer:UpdateCombatant(UnitName(scrutinizer.partyID[i]))
		end
	end
end

function scrutinizer:UpdateCombatant(name)
	if not scrutinizer.combatants[name] then
		return
	end
	local uid = scrutinizer:GetUID(name)
	local classtoken, subclasstoken = "", ""
	local r, g, b = 1, 1, 1
	local class, subclass = "", ""
	local level, sublevel = 0, 0
	if uid then
		classtoken, subclasstoken = UnitClassToken(uid)
		r, g, b = unpack(scrutinizer.colors.classes[classtoken])
		class, subclass = UnitClass(uid)
		level, sublevel = UnitLevel(uid)
	end
	scrutinizer.combatants[name].r = r or 1
	scrutinizer.combatants[name].g = g or 1
	scrutinizer.combatants[name].b = b or 1
	scrutinizer.combatants[name].class = class or "UNKNOWN"
	scrutinizer.combatants[name].subclass = subclass or "UNKNOWN"
	scrutinizer.combatants[name].level = level or 0
	scrutinizer.combatants[name].sublevel = sublevel or 0
end

function scrutinizer:UpdateBar(f, name, values, width, r, g, b)
	_G[f.."_Name"]:SetText(name)
	_G[f.."_Values"]:SetText(values)
	_G[f.."_Texture"]:SetColor(r, g, b)
	_G[f.."_Texture"]:SetWidth(width)
end

function scrutinizer:UpdateBarAnchor(f, onSelf, onParent, parentFrame, x, y)
	_G[f]:ClearAllAnchors()
	_G[f]:SetAnchor(onSelf, onParent, parentFrame or "UIParent", x or 0, y or 0)
	return true
end

function scrutinizer:UpdateAnchors()
	
	scrutinizer:UpdateBarAnchor("scrutinizer_MainFrame_Bar1", "TOPLEFT", "BOTTOMLEFT", scrutinizer_MainFrame_Head)
	
	for i = 2, 6 do
		scrutinizer:UpdateBarAnchor("scrutinizer_MainFrame_Bar" .. i, "TOPLEFT", "BOTTOMLEFT", _G["scrutinizer_MainFrame_Bar" .. (i - 1)])
	end

	if scrutinizer_MainFrame_Group:IsVisible() then
		scrutinizer:UpdateBarAnchor("scrutinizer_MainFrame_Group", "TOPLEFT", "BOTTOMLEFT", scrutinizer_MainFrame_Bar6)
		if scrutinizer_MainFrame_Pet:IsVisible() then
			scrutinizer:UpdateBarAnchor("scrutinizer_MainFrame_Pet", "TOPLEFT", "BOTTOMLEFT", scrutinizer_MainFrame_Group)
		end
	else
		if scrutinizer_MainFrame_Pet:IsVisible() then
			scrutinizer:UpdateBarAnchor("scrutinizer_MainFrame_Pet", "TOPLEFT", "BOTTOMLEFT", scrutinizer_MainFrame_Bar6)
		end
	end
	
	scrutinizer.updateneeded = true
	
end

function scrutinizer:UpdateMainFrame()
	local sorted = {}
	local partyvalue = 0
	local partycurrentps = 0
	local partyoverallps = 0
	local partynum = 0
	
	local petValue = 0
	local petPsCur = 0
	local petPsAll = 0
	
	for name, v in pairs(scrutinizer.combatants) do
		if v[scrutinizer.currentcat] then
			if scrutinizer:IsPartyMemberByName(name) and not scrutinizer:IsPlayerPet(name) then
				table_insert(sorted, {
					name = name,
					overallvalue = v[scrutinizer.currentcat].overallvalue,
					currentps = v[scrutinizer.currentcat].currentps,
					overallps = v[scrutinizer.currentcat].overallps,
				})
				partyvalue = partyvalue + v[scrutinizer.currentcat].overallvalue
				partycurrentps = partycurrentps + v[scrutinizer.currentcat].currentps
				partyoverallps = partyoverallps + v[scrutinizer.currentcat].overallps
				partynum = partynum + 1
			elseif scrutinizer:IsPlayerPet(name) then
				petValue = v[scrutinizer.currentcat].overallvalue
				petPsCur = v[scrutinizer.currentcat].currentps
				petPsAll = v[scrutinizer.currentcat].overallps
				scrutinizer.cache.pet.value = petValue
				scrutinizer.cache.pet.psCur = petPsCur
				scrutinizer.cache.pet.psAll = petPsAll
			end
			
		end
	end
	table_sort(sorted, function(a, b)
		if a.overallvalue > b.overallvalue then
			return true
		end
	end)
	scrutinizer.cache.main = sorted
	scrutinizer.cache.party.value = partyvalue
	local highestvalue = 0
	if #sorted > 0 then
		highestvalue = sorted[1].overallvalue
	end
	local i = 1
	for _, v in pairs(sorted) do
		if i > 6 then
			break
		end
		local values = scrutinizer:FormatValue(v.overallvalue).." ("..scrutinizer:FormatValue(v.currentps).."/"..scrutinizer:FormatValue(v.overallps)
		if (partyvalue ~= 0) and (partynum > 1) then
			values = values..", "..scrutinizer:FormatValue((v.overallvalue/partyvalue)*(100)).."%"
		end
		values = values..")"
		local width = maxbarwidth
		if highestvalue > 0 then
			width = (v.overallvalue/highestvalue)*(width)
		end
		scrutinizer:UpdateBar("scrutinizer_MainFrame_Bar"..i, v.name, values, width, scrutinizer.combatants[v.name].r, scrutinizer.combatants[v.name].g, scrutinizer.combatants[v.name].b)
		i = i + 1
	end
	for j = i, 6 do
		scrutinizer:UpdateBar("scrutinizer_MainFrame_Bar"..j, "", "", 0, 0, 0, 0)
	end
	
	if scrutinizer.cfg.showpartybar then
		local pvalues = ""
		if (partyvalue ~= 0) and (partynum > 1) then
			pvalues = scrutinizer:FormatValue(partyvalue).." ("..scrutinizer:FormatValue(partycurrentps).."/"..scrutinizer:FormatValue(partyoverallps)..")"
		end
		scrutinizer:UpdateBar("scrutinizer_MainFrame_Group", BINDING_NAME_CHAT_PARTY, pvalues, 0, 1, 1, 1)
	end
	
	if hasPet then
		local petValues = ""
		if petPsAll ~= 0 then
			petValues = scrutinizer:FormatValue(petValue).." ("..scrutinizer:FormatValue(petPsCur).."/"..scrutinizer:FormatValue(petPsAll)..")"
		end
		scrutinizer:UpdateBar("scrutinizer_MainFrame_Pet", "Pet", petValues, 0, 1, 1, 1)
		
	end
	
	scrutinizer.updateneeded = false
end

function scrutinizer:ScaleFrames(value)
	local realvalue = 1
	if value < 0 then
		realvalue = 1 - math_abs(value)/10
	else
		realvalue = 1 + (value/10)
	end
	scrutinizer_MainFrame:SetScale(realvalue)
	scrutinizer_DetailFrame:SetScale(realvalue)
	scrutinizer_Submit:SetScale(realvalue)
	scrutinizer_SendTo:SetScale(realvalue)
end

function scrutinizer:SetAlpha(value)
	local realvalue = value/10
	scrutinizer_MainFrame_Head:SetBackdropTileAlpha(realvalue)
	for i = 1, 6 do
		_G["scrutinizer_MainFrame_Bar"..i]:SetBackdropTileAlpha(realvalue)
	end
	scrutinizer_MainFrame_Group:SetBackdropTileAlpha(realvalue)
	scrutinizer_MainFrame_Pet:SetBackdropTileAlpha(realvalue)
	if value < 2 then
		realvalue = 2/10
	end
	scrutinizer_DetailFrame:SetBackdropTileAlpha(realvalue)
	scrutinizer_DetailFrame_Types:SetBackdropTileAlpha(realvalue)
	scrutinizer_DetailFrame_Opponents:SetBackdropTileAlpha(realvalue)
end

function scrutinizer:ShowSubmitButton()
	scrutinizer_Submit:Show()
end