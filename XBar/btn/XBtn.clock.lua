local XBar = _G.XBar
local setDate, setOnline, setFormat
local Clock={
	["start"]=GetTime(),["hour"]=0,["mins"]=0,["game"]="00:00",["total"]="00:00",["update"]=0,
}

local function Indicator(duration,remaining)
	if remaining>0 then
		XBarClock_B_Icon:SetCooldown(duration,remaining)
	end
end

local function TimeFormat(m, total)
	local h = math.floor(m/60)
	if total then
		return string.format("%d %s %02d:%02d", math.floor(h/24), DAYS, h%24, m%60)
	else
		return string.format("%02d:%02d", h, m%60)
	end
end

function XBar.Clock_OnUpdate(elapsedTime)
	Clock["update"]=Clock["update"]+elapsedTime
	if Clock["update"]>=1 then
		Clock["update"]=0
		Indicator(60,60-tonumber(os.date("%S")))
		Clock["time"]=GetTime()-Clock["start"]
		if not Clock["date"] then Clock["date"]=GetLanguage()=="ENUS" and os.date("%a %m-%d-%Y") or os.date("%a-%d.%m.%Y") end
		if Clock["mins"]<math.floor(Clock["time"]%3600/60) then
			XBSet["PlayedMins"]=XBSet["PlayedMins"]+1
			Clock["mins"]=math.floor(Clock["time"]%3600/60)
			Clock["game"]=TimeFormat(Clock["mins"])
			Clock["total"]=TimeFormat(XBSet["PlayedMins"], true)
		end
		-- Output
		local usrtxt={[1]=XBSet["ClockV1"],[2]=XBSet["ClockV2"],[3]=XBSet["ClockV3"],[4]=XBSet["ClockV4"],[5]=XBSet["ClockV5"]}
		local output=""
		for i=1,5 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TIME24%]",os.date("%H:%M.%S"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TIME12%]",os.date("%I:%M.%S %p"))
			usrtxt[i],_=string.gsub(usrtxt[i],"%[DATE%]",Clock["date"] or NONE)
			usrtxt[i],_=string.gsub(usrtxt[i],"%[ONLINE%]",Clock["game"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TOTALONLINE%]",Clock["total"])
		end
		if XBSet["ClockT1"] then
			if setDate==1 then output=usrtxt[3] elseif setFormat==12 then output=usrtxt[2] else output=usrtxt[1] end
		end
		if XBSet["ClockT2"] then
			if setOnline==1 then if XBSet["ClockT1"] then output=output.."\n"..usrtxt[5] else output=usrtxt[5] end
			else if XBSet["ClockT1"] then output=output.."\n"..usrtxt[4] else output=usrtxt[4] end end
		end
		XBarClock_F_S:SetText(output)
	end
end

function XBar.Clock_OnClick(key)
	if key=="RBUTTON" and not IsShiftKeyDown() then if setDate==1 then setDate=0 else setDate=1 end
	elseif key=="LBUTTON" and IsShiftKeyDown() then if setOnline==1 then setOnline=0 else setOnline=1 end
	elseif key=="LBUTTON" then if setFormat==12 then setFormat=24 else setFormat=12 end end
end

function XBar.Clock_OnEnter(this)
	Clock["date"]=GetLanguage()=="ENUS" and os.date("%a %m-%d-%Y") or os.date("%a-%d.%m.%Y")
	XBarClock_B_Icon:SetTexture("interface/icons/Skill_ran54-1")
	XBar.TooltipMod(this)
	GameTooltip:SetText(TIMEFLAG_STATE.." / "..GUILD_RESOURCE_DATE)
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Clock1"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..GUILD_RESOURCE_DATE.."|r", Clock["date"] or NONE)
	GameTooltip:AddDoubleLine("|cffFFE855"..TIMEFLAG_STATE.."|r", os.date("%H:%M.%S"))
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Config"]["Clock1"].."|r", Clock["game"])
	GameTooltip:AddDoubleLine("|cffFFE855"..XBar.Lng["Ttip"]["Clock2"].."|r", Clock["total"])
end

if d303Fix then d303Fix.Strings.WeekDaysShort = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"} end
