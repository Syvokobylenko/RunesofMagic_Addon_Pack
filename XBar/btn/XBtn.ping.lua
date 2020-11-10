local XBar = _G.XBar
local Sys={["update"]=0}
 
function XBar.Ping_OnUpdate(elapsedTime)
	Sys["update"]=Sys["update"]+elapsedTime
	if Sys["update"]>=5 or not Sys["fps"] then
		Sys["update"]=0
		Sys["fps"]=math.floor(GetFramerate())
		Sys["ping"]=GetPing()
		if Sys["fps"]<21 then Sys["fps"]="|cffFF0000"..Sys["fps"].."|r"
		elseif Sys["fps"]<61 then Sys["fps"]="|cffFFAA00"..Sys["fps"].."|r" end
		if Sys["ping"]>150 then Sys["ping"]="|cffFF0000"..Sys["ping"].."|r"
		elseif Sys["ping"]>100 then Sys["ping"]="|cffFFAA00"..Sys["ping"].."|r" end
	--	Output
		local usrtxt={[1]=XBSet["PingV1"],[2]=XBSet["PingV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[MS%]",Sys["ping"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[FPS%]",Sys["fps"])
		end
		if XBSet["PingT1"] then output=usrtxt[1] end
		if XBSet["PingT2"] then
			if XBSet["PingT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarPing_F_S:SetText(output)
	end
end

function XBar.Ping_OnEnter(this)
	XBar.TooltipMod(this)
	GameTooltip:SetText(XBar.Lng["Ttip"]["Ping1"])
	if XAFK and XAFK.version then
		GameTooltip:AddLine(XAFK.Lang["TipX"],0,.7,.9)
	else
		GameTooltip:AddLine(XBar.Lng["Ttip"]["Ping2"],0,.7,.9)
	end
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Ping3"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..UI_TITLE_TYPE_3.."|r", Sys["ping"].."/"..Sys["fps"])
end