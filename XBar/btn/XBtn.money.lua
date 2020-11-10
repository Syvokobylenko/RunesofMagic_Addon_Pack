local XBar = _G.XBar
local Money={["total"]=GetPlayerMoney("copper"),["session"]=0,["spent"]=0}
local oldMem
local function Balance(count)
	if count>0 then
		count = "|cff8DE668+"..count
	elseif count<0 then
		count = "|cffE66868"..count
	end
	return count
end

function XBar.Money_OnEvent(this,event,tip)
	if event=="LOADED" and not tip then
		--XBar.RegEvent(this, "PLAYER_MONEY", "GOLD%]", "DIAS%]", "RUBY%]", "COIN%]")
		this:RegisterEvent("PLAYER_MONEY")
		XBar.RegEvent(this, "PLAYER_BAG_CHANGED", "%[AM", "PS%]", "EJ%]", "PM%]", "DS%]", "BT%]")
		XBar.RegEvent(this, "PLAYER_HONOR_CHANGED", "HP%]")
		if not oldMem then oldMem = GetBagItemCount(206879) + GetCountInBankByName(TEXT("Sys206879_name")) + GetPlayerPointInfo(2, 1, " ") end
	end
	if (event=="PLAYER_MONEY" or event=="LOADED") and Money["total"]~=GetPlayerMoney("copper") then 
		local temp=Money["total"]
		Money["total"]=GetPlayerMoney("copper")
		if temp<Money["total"] then
			Money["session"]=Money["session"]+math.ceil(Money["total"]-temp)
		else
			Money["spent"]=Money["spent"]+math.ceil(temp-Money["total"])
		end
	end
	if event=="PLAYER_BAG_CHANGED" or event=="LOADED" then
		Money["AMCount"] = GetBagItemCount(206879) + GetCountInBankByName(TEXT("Sys206879_name")) + GetPlayerPointInfo(2, 1, " ")
		Money["AMChange"] = Balance(Money["AMCount"] - oldMem)
		Money["PSCount"] = GetBagItemCount(240181) + GetCountInBankByName(TEXT("Sys240181_name")) + GetPlayerPointInfo(1, 1, " ")
		Money["EJCount"] = GetBagItemCount(201545) + GetCountInBankByName(TEXT("Sys201545_name")) + GetPlayerPointInfo(1, 2, " ")
		Money["PMCount"] = GetBagItemCount(241706) + GetCountInBankByName(TEXT("Sys241706_name")) + GetPlayerPointInfo(2, 2, " ")
		Money["DSCount"] = GetBagItemCount(208681) + GetCountInBankByName(TEXT("Sys208681_name")) + GetPlayerPointInfo(1, 3, " ")
		Money["BTCount"] = GetBagItemCount(206686) + GetCountInBankByName(TEXT("Sys206686_name")) + GetPlayerPointInfo(3, 2, " ")
	end
	if event=="PLAYER_HONOR_CHANGED" or event=="LOADED" then
		Money["HPCount"] = GetPlayerHonorPoint()
	end
-- Output
	if not tip then
		local usrtxt={[1]=XBSet["MoneyV1"],[2]=XBSet["MoneyV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[GOLD%]","|cffFFEE80"..XBar.Dec(Money["total"]).."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DIAS%]","|cffC7C7FF"..XBar.Dec(GetPlayerMoney("account")).."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[RUBY%]","|cffFFC7C7"..XBar.Dec(GetPlayerMoney("bonus")).."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[COIN%]","|cffC7C7C7"..XBar.Dec(GetPlayerMoney("billdin")).."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[AM%]", "|cffC7FFC7"..Money["AMCount"].."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[AMC%]", Money["AMChange"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[PS%]", "|cffC7FFC7"..Money["PSCount"].."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[EJ%]", "|cffC7FFC7"..Money["EJCount"].."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[PM%]", "|cffC7FFC7"..Money["PMCount"].."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DS%]", "|cffC7FFC7"..Money["DSCount"].."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[BT%]", "|cffC7FFC7"..Money["BTCount"].."|r")
			usrtxt[i],_=string.gsub(usrtxt[i],"%[HP%]", "|cffC7FFC7"..Money["HPCount"].."|r")
		end
		if XBSet["MoneyT1"] then output=usrtxt[1] end
		if XBSet["MoneyT2"] then
			if XBSet["MoneyT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarMoney_F_S:SetText(output)
	end
end

function XBar.Money_OnEnter(this)
	XBar.Money_OnEvent(XBarMoney,"LOADED",true)
	XBar.TooltipMod(this)
	GameTooltip:SetText(TEXT("SYS_ITEMTYPE_23"))
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Money1"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cff8DE668"..XBar.Lng["Ttip"]["Money2"].."|r",XBar.Dec(Money["session"]))
	GameTooltip:AddDoubleLine("|cffE66868"..XBar.Lng["Ttip"]["Money3"].."|r",XBar.Dec(Money["spent"]))
	GameTooltip:AddDoubleLine(XBar.Lng["Ttip"]["Money4"],XBar.Dec(math.ceil(Money["session"]-Money["spent"])))
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys206879_name").."|r", Money["AMChange"])
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..MONEY_GOLD.."|r", XBar.Dec(GetPlayerMoney("copper")))
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys206879_name").."|r", Money["AMCount"])
	GameTooltip:AddDoubleLine("|cffFFE855"..MONEY_RUNE.."|r", XBar.Dec(GetPlayerMoney("account")))
	GameTooltip:AddDoubleLine("|cffFFE855"..MONEY_RUBY.."|r", XBar.Dec(GetPlayerMoney("bonus")))
	GameTooltip:AddDoubleLine("|cffFFE855".._glossary_00844.."|r", XBar.Dec(GetPlayerMoney("billdin")))
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys240181_name").."|r", Money["PSCount"])
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys201545_name").."|r", Money["EJCount"])
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys241706_name").."|r", Money["PMCount"])
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys208681_name").."|r", Money["DSCount"])
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys206686_name").."|r", Money["BTCount"])
	GameTooltip:AddDoubleLine("|cffFFE855"..TEXT("Sys203944_name").."|r", Money["HPCount"])
end