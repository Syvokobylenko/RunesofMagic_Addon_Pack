local XBar = _G.XBar
local Ammo={}
 
function XBar.Ammo_OnEvent(this,event,tip)
	if event=="LOADED" and not tip then
		XBar.RegEvent(this, "PLAYER_BAG_CHANGED", "COUNT%]", "NAME%]", "BAG%]")
		XBar.RegEvent(this, "PLAYER_INVENTORY_CHANGED", "COUNT%]", "NAME%]", "EQUIP%]")
	end
	local _, _, name = GetInventoryItemDurable("player",9)
	if not name then
		Ammo["name"] = TEXT("SYS_EQWEARPOS_10")
		Ammo["ecount"] = 0
		Ammo["bcount"] = 0
		Ammo["count"] = 0
	elseif name~=Ammo["name"] or GetInventoryItemCount("player",9)~=Ammo["ecount"] or GetCountInBagByName(name)~=Ammo["bcount"] then
		Ammo["name"] = name
		Ammo["ecount"] = GetInventoryItemCount("player",9)
		Ammo["bcount"] = GetCountInBagByName(name)
		Ammo["count"] = Ammo["ecount"] + Ammo["bcount"]
		if GetInventoryItemInvalid("player",9) or GetInventoryItemInvalid("player",10) then
			Ammo["count"]="|cff767676"..Ammo["count"].."|r"
		elseif Ammo["count"]<101 then
			Ammo["count"]="|cffFF0000"..Ammo["count"].."|r"
		elseif Ammo["count"]<501 then
			Ammo["count"]="|cffFFAA00"..Ammo["count"].."|r"
		end
	end
--	Output
	if not tip then
		local usrtxt={[1]=XBSet["AmmoV1"],[2]=XBSet["AmmoV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[COUNT%]",Ammo["count"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[NAME%]",Ammo["name"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[EQUIP%]",Ammo["ecount"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[BAG%]",Ammo["bcount"])
		end
		if XBSet["AmmoT1"] then output=usrtxt[1] end
		if XBSet["AmmoT2"] then
			if XBSet["AmmoT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarAmmo_F_S:SetText(output)
	end
end

function XBar.Ammo_OnEnter(this)
	XBar.Ammo_OnEvent(XBarAmmo,"LOADED",true)
	XBar.TooltipMod(this)
	GameTooltip:SetText(TEXT("SYS_EQWEARPOS_09"))
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Ammo1"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..Ammo["name"].."|r", Ammo["count"])
	GameTooltip:AddDoubleLine("|cffFFE855"..BACKPACK_EQUIP.."|r", Ammo["ecount"])
	GameTooltip:AddDoubleLine("|cffFFE855"..GCF_TEXT_BAG.."|r", Ammo["bcount"])
end