XBtnDps={}
local XBar = _G.XBar
local DuraA = NONE
local DuraL
local Dps={["DPS"]=0,["Dmg"]=0,["HPS"]=0,["Heal"]=0}

function XBar.Dps_OnUpdate()
	if Dps["DCurTime"]~=nil then
		if GetTime()-Dps["DCurTime"]>5 then
			Dps["DActive"]=false
			Dps["DPS"]=0
			Dps["DCurTime"]=nil
		end
	end
	if Dps["HCurTime"]~=nil then
		if GetTime()-Dps["HCurTime"]>5 then
			Dps["HActive"]=false
			Dps["HPS"]=0
			Dps["HCurTime"]=nil
		end
	end
end
 
function XBar.Dps_OnEvent(this,event,tip)
	local name = UnitName("player")
	if event=="LOADED" and not tip then
		this:RegisterEvent("UNIT_HEALTH")
		XBar.RegEvent(this, "COMBATMETER_DAMAGE", "DPS%]", "DMG%]")
		XBar.RegEvent(this, "COMBATMETER_HEAL", "HPS%]", "HEAL%]")
		XBar.RegEvent(this, "PLAYER_INVENTORY_CHANGED", "%[DURA")
		if not XBtnDps[name] then XBtnDps[name] = 0 end
	end
	if event=="UNIT_HEALTH" and arg1=="target" then
		if UnitHealth("target")==0 and UnitExists("target") then
			XBtnDps[name] = XBtnDps[name] + 1
		end
	end
	if event=="COMBATMETER_DAMAGE" then
		if _source==UnitName("player") then
			if not Dps["DActive"] then
				Dps["DActive"]=true
				Dps["DStartTime"]=(GetTime()-1)
				Dps["TotalDmg"]=0
				Dps["DPS"]=0
			end
			Dps["DCurTime"]=GetTime()
			Dps["DTotalTime"]=Dps["DCurTime"]-Dps["DStartTime"]
			Dps["Dmg"]=XBar.Dec(_damage)
			Dps["TotalDmg"]=Dps["TotalDmg"]+_damage
			Dps["DPS"]=XBar.Dec(math.floor(Dps["TotalDmg"]/Dps["DTotalTime"]))
		else
			return
		end
	end
	if event=="COMBATMETER_HEAL" then
		if _source==UnitName("player") then
			if not Dps["HActive"] then
				Dps["HActive"]=true
				Dps["HStartTime"]=(GetTime()-1)
				Dps["TotalHeal"]=0
				Dps["HPS"]=0
			end
			Dps["HCurTime"]=GetTime()
			Dps["HTotalTime"]=Dps["HCurTime"]-Dps["HStartTime"]
			Dps["Heal"]=XBar.Dec(_heal)
			Dps["TotalHeal"]=Dps["TotalHeal"]+_heal
			Dps["HPS"]=XBar.Dec(math.floor(Dps["TotalHeal"]/Dps["HTotalTime"]))
		else
			return
		end
	end
	if event=="PLAYER_INVENTORY_CHANGED" or event=="LOADED" then
		XBar.EQDmg_OnEvent("PLAYER_INVENTORY_CHANGED")
	end
--	Output
	if not tip then
		local usrtxt={[1]=XBSet["DpsV1"],[2]=XBSet["DpsV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DPS%]",Dps["DPS"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DMG%]",Dps["Dmg"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[HPS%]",Dps["HPS"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[HEAL%]",Dps["Heal"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[KILLS%]",XBar.Dec(XBtnDps[name]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DURAL%]",DuraL)
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DURA%]",DuraA)
		end
		if XBSet["DpsT1"] then output=usrtxt[1] end
		if XBSet["DpsT2"] then
			if XBSet["DpsT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarDps_F_S:SetText(output)
	end
end

function XBar.Dps_OnClick(key)
	if key=="LBUTTON" then
		XBar.ToggleUI(XBarEQDmg)
	elseif IsCtrlKeyDown() then
		XBtnDps[UnitName("player")] = 0
		XBar.Dps_OnEvent()
	elseif not IsShiftKeyDown() then
		GameTooltip:Hide()
		local n = GetEuipmentNumber()
		if CharactFrame_GetEquipSlotCount()==n then n = 0 end
		SwapEquipmentItem(n)
	end
end

function XBar.Dps_OnEnter(this)
	XBar.EQDmg_OnEvent("PLAYER_INVENTORY_CHANGED")
	XBar.TooltipMod(this)
	local abtext = {
		C_STR,
		C_AGI,
		C_STA,
		C_INT,
		C_MND,
		C_DPS,
		MELEE.." "..C_PHYSICAL_DAMAGE,
		MELEE.." "..C_PHYSICAL_ATTACK,
		MELEE.." "..C_PHYSICAL_CRITICAL,
		" ",
		" ",
		MELEE.." "..C_PHYSICAL_HIT,
		PHYSICAL_HIT_RATE,
		RANGE.." "..C_PHYSICAL_DAMAGE,
		RANGE.." "..C_PHYSICAL_ATTACK,
		RANGE.." "..C_PHYSICAL_CRITICAL,
		MAGIC.." "..C_MAGIC_DAMAGE,
		MAGIC.." "..C_MAGIC_ATTACK,
		MAGIC.." "..C_MAGIC_CRITICAL,
		MAGIC.." "..C_MAGIC_HEAL_POINT,
		MAGIC.." "..C_MAGIC_HIT,
		DEFENCE,
		C_PHYSICAL_PARRY,
		C_PHYSICAL_DODGE,
		C_PHYSICAL_RESIST_CRITICAL,
		MAGIC.." "..C_MAGIC_DEFENCE,
		MAGIC.." "..C_MAGIC_DODGE,
		MAGIC.." "..C_MAGIC_RESIST_CRITICAL,
	}
	local ability = {
		"STR",
		"AGI",
		"STA",
		"INT",
		"MND",
		"DPS",
		"MELEE_MAIN_DAMAGE",
		"MELEE_ATTACK",
		"MELEE_CRITICAL",
		"MELEE_MAIN_CRITICAL",
		"MELEE_OFF_CRITICAL",
		"PHYSICAL_MAIN_HIT",
		"PHYSICAL_HIT_RATE",
		"RANGE_DAMAGE",
		"RANGE_ATTACK",
		"RANGE_CRITICAL",
		"MAGIC_DAMAGE",
		"MAGIC_ATTACK",
		"MAGIC_CRITICAL",
		"MAGIC_HEAL",
		"MAGIC_HIT",
		"PHYSICAL_DEFENCE",
		"PHYSICAL_PARRY",
		"PHYSICAL_DODGE",
		"PHYSICAL_RESIST_CRITICAL",
		"MAGIC_DEFENCE",
		"MAGIC_DODGE",
		"MAGIC_RESIST_CRITICAL",
	}
	GameTooltip:SetText(XBar.Lng["Ttip"]["Dps1"])
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Dps2"].."\n"..XBar.Lng["Ttip"]["CR_REST"]..XBar.Lng["Config"]["Dps3"]..".",0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["LowDur"].."|r", DuraL)
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["AvgDur"].."|r", DuraA)
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Dps3"].."|r", XBar.Dec(XBtnDps[UnitName("player")]))
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(" ", "|cffFFE855"..C_ABILITY.."|r")
	for i, v in ipairs(ability) do
		local base, extra, per = GetPlayerAbility(v)
		local value
		if i==6 then
			value=string.format("%.2f", base+extra)
		elseif i==10 or i==11 then
			value=string.format("%.2f%%", per)
		elseif i==13 then
			value=base+extra.."%"
		else
			if extra>0 then
				value="|cff8DE668"..XBar.Dec(base+extra).."|r / "..XBar.Dec(base).."|cff8DE668+"..XBar.Dec(extra)
			elseif extra<0 then
				value="|cffE66868"..XBar.Dec(base+extra).."|r / "..XBar.Dec(base).."|cffE66868"..XBar.Dec(extra)
			else
				value=XBar.Dec(base)
			end
		end
		if i==6 or i==14 or i==17 or i==22 or i==26 then GameTooltip:AddSeparator() end
		if i==16 or i==19 or i==23 then
			GameTooltip:AddDoubleLine(abtext[i], value)
			GameTooltip:AddDoubleLine(" ", string.format("%.2f%%", per))
		else
			GameTooltip:AddDoubleLine(abtext[i], value)
		end
	end
end

local function DuraColor(color)
	if color<41 then return "|cffFF0000"
	elseif color<86 then return "|cffFFAA00"
	else return "|cffFFFFFF" end
end

local function BagHammer(button, item, icon, name, index)
	local num = tonumber(button:GetName():sub(-1))
	for i = 1, num do
		if _G["XBarEQDmg_Repair"..i].name==name then return button end
	end
	for j = 1, 9 do
		if name==TEXT("Sys"..item[j].."_name") then
			button:Show()
			button.id = index
			button.name = name
			_G[button:GetName().."_Icon"]:SetTexture(icon)
			_G[button:GetName().."_Text"]:SetText(GetCountInBagByName(name))
			if num<7 then
				if XBarEQDmg:GetWidth()~=250 then XBarEQDmg:SetWidth(250) end
			else
				if XBarEQDmg:GetWidth()~=282 then XBarEQDmg:SetWidth(282) end
			end
			if num<9 then
				button = _G["XBarEQDmg_Repair"..num + 1]
			end
			break
		end
	end
	return button
end

function XBar.EQDmg_OnEvent(event, this)
	if event=="LOADED" then
		this:RegisterEvent("PLAYER_INVENTORY_CHANGED")
		this:RegisterEvent("PLAYER_BAG_CHANGED")
		this:ClearAllAnchors()
		this:SetAnchor("BOTTOMRIGHT","BOTTOMRIGHT","UIParent",XBSet["EQDmg_X"],XBSet["EQDmg_Y"])
		for i = 1, 6 do
			if i>CharactFrame_GetEquipSlotCount() then
				_G["XBarEQDmg_Swap"..i]:Hide()
			end
		end
	end
	if event=="PLAYER_INVENTORY_CHANGED" or event=="LOADED" then
		local TDur, itemCount, LOW_DUR = 0, 0, 100
		local ID = XBarEQDmg:IsVisible() and {}
		DuraL = NONE
		for i=0,21 do
			if XBarEQDmg:IsVisible() then
				if GetInventoryItemTexture("player",i) then
					_G["XBarEQDmg_Slot"..i.."_Icon"]:SetTexture(GetInventoryItemTexture("player",i))
				else
					_G["XBarEQDmg_Slot"..i.."_Icon"]:SetTexture("Interface/Icons/Geq") 
					_G["XBarEQDmg_Slot"..i.."_Text"]:SetText("")
				end
				_G["XBarEQDmg_Slot"..i]:SetID(i)
				if _G["XBarEQDmg_Slot"..i.."_Low"]:IsVisible() then _G["XBarEQDmg_Slot"..i.."_Low"]:Hide() end
			end
			local curD,maxD=GetInventoryItemDurable("player",i)
			if maxD~=0 and i~=18 and i~=19 and i~=20 and i~=9 then
				local TEMP=math.ceil((curD/maxD)*1000)/10
				itemCount=itemCount+1
				TDur=TDur+TEMP
				if TEMP<LOW_DUR then
					LOW_DUR = TEMP
					DuraL = curD.."/"..maxD
					if XBarEQDmg:IsVisible() then
						ID = {}
						ID[1] = i
					end
				end
				if XBarEQDmg:IsVisible() then
					if TEMP==LOW_DUR and ID[1] then
						table.insert(ID, i)
					end
					if maxD>100 then
						maxD = "|cff00FF00"..maxD.."|r"
					end
					if XBSet["EQDmg_C"]==false then
						if curD>100 then
							_G["XBarEQDmg_Slot"..i.."_Text"]:SetText("|cff00FF00"..TEMP.."%|r")
						else
							_G["XBarEQDmg_Slot"..i.."_Text"]:SetText(DuraColor(TEMP)..TEMP.."%|r")
						end
					else
						if curD>100 then
							_G["XBarEQDmg_Slot"..i.."_Text"]:SetText("|cff00FF00"..curD.."/|r"..maxD)
						else
							_G["XBarEQDmg_Slot"..i.."_Text"]:SetText(DuraColor(TEMP)..curD.."/"..maxD.."|r")
						end
					end
				end
			end
		end
		if itemCount==0 then return end
		DuraA=math.ceil((TDur/itemCount)*10)/10
		if XBarEQDmg:IsVisible() then
			for i = 1, CharactFrame_GetEquipSlotCount() do
				if GetEuipmentNumber()==i then
					_G["XBarEQDmg_Swap"..i]:Disable()
				else
					_G["XBarEQDmg_Swap"..i]:Enable()
				end
			end
			for i = 1, #ID do
				_G["XBarEQDmg_Slot"..ID[i].."_Low"]:Show()
			end
			XBarEQDmg_AvgName:SetText(XBar.Lng["Ttip"]["AvgDur"])
			XBarEQDmg_AvgDura:SetText(DuraColor(DuraA)..DuraA.."%|r")
		end
	end
	if event=="PLAYER_BAG_CHANGED" or event=="LOADED" then
		local _, bmax = GetBagCount()
		local btn = XBarEQDmg_Repair1
		if XBarEQDmg:GetWidth()~=200 then XBarEQDmg:SetWidth(200) end
		for i = 1, 9 do
			_G["XBarEQDmg_Repair"..i]:Hide()
			_G["XBarEQDmg_Repair"..i].name = nil
		end
		local item = {"201014", "201307", "201308", "201309", "201310", "201967", "202506", "203576", "207263"}
		for i = 1, 50 do
			local icon, name = GetGoodsItemInfo(i)
			btn = BagHammer(btn, item, icon, name, i)
			if btn==XBarEQDmg_Repair9 then break end
		end
		for i = 1, bmax do
			if btn==XBarEQDmg_Repair9 then break end
			local index, icon, name = GetBagItemInfo(i)
			btn = BagHammer(btn, item, icon, name, index)
		end
	end
end
