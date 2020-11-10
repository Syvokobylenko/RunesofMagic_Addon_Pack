local XBar = _G.XBar
local class
local Exp={
	["xpold"]=GetPlayerExp("player"),["xpmold"]=GetPlayerMaxExp("player"),["tpold"]=GetTpExp("Tp"),
	["xplast"]=0,["tplast"]=0,["xpse"]=0,["tpse"]=0,["xpre"]=NONE,
	["sc"]=NONE,["sl"]=0,["sExp"]=NONE,["smExp"]=NONE,["sExpd"]=NONE,["sTpd"]=NONE,["sPer"]=0,
	["tc"]=NONE,["tl"]=0,["tExp"]=NONE,["tmExp"]=NONE,["tExpd"]=NONE,["tPer"]=0
}

function XBar.Exp_OnEvent(this,event,tip)
	if event=="LOADED" then
		if not tip then
			XBar.RegEvent(this, "UNIT_CLASS_CHANGED", "%[S", "%[TX", "%[TM", "%[TPER", "%[TC", "%[TL")
			--XBar.RegEvent(this, "TP_EXP_UPDATE", "%[TP")
			--XBar.RegEvent(this, "PLAYER_EXP_CHANGED", "%[XP", "%[PER", "RE%]")
			this:RegisterEvent("TP_EXP_UPDATE")
			this:RegisterEvent("PLAYER_EXP_CHANGED")
		end
		class=UnitClass("player")
	end
	if event=="TP_EXP_UPDATE" or event=="PLAYER_EXP_CHANGED" or event=="LOADED" then
		Exp["xpbonus"], Exp["tpbonus"] = GetPlayerExtraPoint()
		Exp["xpdebt"], Exp["tpdebt"] = GetPlayerExpDebt()
		if Exp["xpdebt"]<0 or Exp["tpdebt"]<0 then
			XBarExp_Debt:Show()
		else
			XBarExp_Debt:Hide()
		end
	end
	if (event=="TP_EXP_UPDATE" or event=="LOADED") and Exp["tpold"]~=GetTpExp("Tp") then
		local tp = GetTpExp("Tp")
		Exp["tplast"]=tp-Exp["tpold"]
		Exp["tpold"]=tp
		Exp["tpse"]=Exp["tpse"]+Exp["tplast"]
	end
	if (event=="PLAYER_EXP_CHANGED" or event=="LOADED") and Exp["xpold"]~=GetPlayerExp("player") then
		local xp = GetPlayerExp("player")
		local mxp = GetPlayerMaxExp("player")
		if class~=UnitClass("player") then
			class=UnitClass("player")
			Exp["tpold"]=GetTpExp("Tp")
			Exp["xpmold"]=mxp
		else
			if mxp~=Exp["xpmold"] then
				Exp["xplast"]=xp+(Exp["xpmold"]-Exp["xpold"]) -- level up
				Exp["xpmold"]=mxp
			else Exp["xplast"]=xp-Exp["xpold"] end
			Exp["xpse"]=Exp["xpse"]+Exp["xplast"]
			Exp["xpre"]=math.ceil((mxp-xp)/Exp["xplast"])
		end
		Exp["xpold"]=xp
	end
	if (event=="UNIT_CLASS_CHANGED" and arg1=="player") or event=="LOADED" then
		local sload = 0
		local mainC, subC = UnitClass("player")
		local count = GetPlayerNumClasses()
		for i = 1, count do
			local class, _, level, currExp, maxExp, debt = GetPlayerClassInfo(i, true)
			if class~=nil and class~=mainC then
				if class==subC or (subC=="" and sload==0) then
					Exp["sc"] = XBar.ClassColor(class)..class
					Exp["sl"] = level
					Exp["sExp"] = XBar.Dec(currExp)
					Exp["smExp"] = XBar.Dec(maxExp)
					Exp["sPer"] = string.format("%.2f", currExp/maxExp*100)
					Exp["sExpd"] = XBar.Dec(debt)
					Exp["sTpd"] = NONE
					sload = nil
				end
				if count==3 then
					if (subC~="" and class~=subC) or subC=="" then
						Exp["tc"] = XBar.ClassColor(class)..class
						Exp["tl"] = level
						Exp["tExp"] = XBar.Dec(currExp)
						Exp["tmExp"] = XBar.Dec(maxExp)
						Exp["tPer"] = string.format("%.2f", currExp/maxExp*100)
						Exp["tExpd"] = XBar.Dec(debt)
					end
				end
			end
		end
		if subC~="" and subC~=nil then _, _, Exp["sExpd"], Exp["sTpd"] = GetPlayerExpDebt() end
	end
--	Output
	if not tip then
		local usrtxt={[1]=XBSet["ExpV1"],[2]=XBSet["ExpV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[XP%]",XBar.Dec(Exp["xpold"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TP%]",XBar.Dec(Exp["tpold"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[XPN%]",XBar.Dec(Exp["xpmold"]-Exp["xpold"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[XPM%]",XBar.Dec(Exp["xpmold"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[PER%]",string.format("%.2f",(Exp["xpold"]/Exp["xpmold"])*100))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[PERN%]",string.format("%.2f",((Exp["xpmold"]-Exp["xpold"])/Exp["xpmold"])*100))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TPA%]",XBar.Dec(GetTotalTpExp()))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TPU%]",XBar.Dec(GetTotalTpExp()-Exp["tpold"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[XPB%]",XBar.Dec(Exp["xpbonus"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TPB%]",XBar.Dec(Exp["tpbonus"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[XPD%]",XBar.Dec(Exp["xpdebt"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TPD%]",XBar.Dec(Exp["tpdebt"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[XPL%]",XBar.Dec(Exp["xplast"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TPL%]",XBar.Dec(Exp["tplast"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[XPS%]",XBar.Dec(Exp["xpse"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TPS%]",XBar.Dec(Exp["tpse"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[RE%]",XBar.Dec(Exp["xpre"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SCLASS%]",XBar.Dec(Exp["sc"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SLVL%]",XBar.Dec(Exp["sl"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SXP%]",XBar.Dec(Exp["sExp"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SMXP%]",XBar.Dec(Exp["smExp"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SPER%]",Exp["sPer"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SXPD%]",XBar.Dec(Exp["sExpd"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[STPD%]",XBar.Dec(Exp["sTpd"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TCLASS%]",XBar.Dec(Exp["tc"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TLVL%]",XBar.Dec(Exp["tl"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TXP%]",XBar.Dec(Exp["tExp"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TMXP%]",XBar.Dec(Exp["tmExp"]))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TPER%]",Exp["tPer"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TXPD%]",XBar.Dec(Exp["tExpd"]))
		end
		if XBSet["ExpT1"] then output=usrtxt[1] end
		if XBSet["ExpT2"] then
			if XBSet["ExpT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarExp_F_S:SetText(output)
	end
end

function XBar.Exp_OnEnter(this)
	XBar.Exp_OnEvent(XBarExp,"LOADED",true)
	XBar.TooltipMod(this)
	GameTooltip:SetText(XBar.Lng["Ttip"]["Exp1"])
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Exp2"].."\n"..XBar.Lng["Ttip"]["CR_REST"]..XBar.Lng["Ttip"]["Exp1"]..".",0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["Exp3"].."|r",XBar.Dec(Exp["xpold"]).." / "..string.format("%.2f",(Exp["xpold"]/Exp["xpmold"])*100).."%")
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["Exp4"].."|r",XBar.Dec(Exp["xpmold"]-Exp["xpold"]).." / "..string.format("%.2f",((Exp["xpmold"]-Exp["xpold"])/Exp["xpmold"])*100).."%")
	GameTooltip:AddDoubleLine("|cffFFE855"..GUILDCONTRIBUTION_TOTAL_RESOURCE.."|r",XBar.Dec(Exp["xpmold"]))
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["Exp5"].."|r",string.format("XP: %s (TP: %s)",XBar.Dec(Exp["xplast"]),XBar.Dec(Exp["tplast"])))
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["Exp6"].."|r",XBar.Dec(Exp["xpre"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..GUILDCONTRIBUTION_TOTAL_RESOURCE.."|r",string.format("XP: %s (TP: %s)",XBar.Dec(Exp["xpse"]),XBar.Dec(Exp["tpse"])))
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["Exp7"].."|r",XBar.Dec(Exp["tpold"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp8"].."|r",XBar.Dec(GetTotalTpExp()))
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp9"].."|r",XBar.Dec(GetTotalTpExp()-Exp["tpold"]))
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp10"]:format(_glossary_02634).."|r",XBar.Dec(Exp["xpbonus"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp10"]:format(_glossary_02635).."|r",XBar.Dec(Exp["tpbonus"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp11"]:format(_glossary_02634).."|r",XBar.Dec(Exp["xpdebt"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp11"]:format(_glossary_02635).."|r",XBar.Dec(Exp["tpdebt"]))
	if Exp["sc"]~=NONE then
		GameTooltip:AddSeparator()
		GameTooltip:AddDoubleLine(" ", Exp["sc"].." "..Exp["sl"])
		GameTooltip:AddDoubleLine("|cffFFE855"..PET_EXP.."|r", Exp["sExp"].." / "..Exp["smExp"])
		GameTooltip:AddDoubleLine(" ", Exp["sPer"].."%")
		GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp11"]:format(_glossary_02634).."|r", Exp["sExpd"])
		GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp11"]:format(_glossary_02635).."|r", Exp["sTpd"])
	end
	if Exp["tc"]~=NONE then
		GameTooltip:AddSeparator()
		GameTooltip:AddDoubleLine(" ", Exp["tc"].." "..Exp["tl"])
		GameTooltip:AddDoubleLine("|cffFFE855"..PET_EXP.."|r", Exp["tExp"].." / "..Exp["tmExp"])
		GameTooltip:AddDoubleLine(" ", Exp["tPer"].."%")
		GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Exp11"]:format(_glossary_02634).."|r", Exp["tExpd"])
	end
end
