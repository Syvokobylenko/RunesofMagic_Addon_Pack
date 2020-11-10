local me = {
	strings = {
		FORMATION1 = {"LUA_106256_AI_FORMATION_1", true}, -- Boss 1
		FORMATION2 = {"LUA_106256_AI_FORMATION_2", true}, -- Boss 1
		FORMATION3 = {"LUA_106256_AI_FORMATION_3", true}, -- Boss 1
		FORMATION4 = {"LUA_106256_AI_FORMATION_4", true}, -- Boss 1
		TERRORSPREAD = {"LUA_109310_AI_SPREADFEAR",  true, true}, -- Terrorspread Message - Marrisha(4)
		SEVERINGBOMB = {"LUA_106193_AI_BOMB_CAST", true, true}, -- severing bomb message - Nex of Tasuq(2)
		FOOTSOLDIER = {"LUA_106193_AI_PACE_CAST", true, true}, -- foot soldier of perdition message - Nex of Tasuq(2)
		
		
		blackabyss = { "Sys491580_name", true},-- Black Abyss Terror - Mazzren (5)
		severingbomb = {"Sys492919_name", true}, -- severing bomb - Nex of Tasuq(2)
		footsoldier = {"Sys503558_name", true}, -- foot soldier of perdition - Nex of Tasuq(2)
		terrorspread = {"Sys499138_name", true}, -- Terrorspread id - Marrisha(4)
		targetchange = {"Sys501891_name", true}, -- targetchange id - Nex of Tasuq(2)
		targeticon = {"Sys502913_name", true}, -- target icon id - Mazzren (5)
		
	},
	vars = {
		Boss1_timer = false,
		timerstate = {[0]=10,[1]=20,[2]=26,[3]=27,[4]=28,[5]=29,[6]=30},
		buffs = {TargetChange=false,TargetIcon=false,},
		cast={},
	},
	Settings = {
		active = true,
	},
}


function me.GetSettings()
	return me.Settings
end

function me.SetSettings(tbl)
	if type(tbl)=="table" then
		me.Settings=tbl
	end
end

function me.LoadEvent(frame)
	ev.fn.AddHook("SendSystemMsg")
	frame:RegisterEvent("CHAT_MSG_PARTY")
	frame:RegisterEvent("UNIT_BUFF_CHANGED")
	frame:RegisterEvent("UNIT_CASTINGTIME")
	me.strings = ev.helper.ReplaceTranslateRegex2(me.strings)
end

function me.GetName()
	return GetZoneLocalName(179)
end

function me.IsActive()
	local zone = GetZoneID()
	return zone == 178 or zone == 179 or zone == 180
end

function me.OnUpdate()
	if me.vars.Boss1_timer then -- PhaseChange timer; Boss 1
		local tmr = GetTime() - me.vars.Boss1_timer.time
		local state = me.vars.Boss1_timer.state
		if tmr > me.vars.timerstate[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("phasechange_time_message", 31-tmr), nil, {warning=true})
			me.vars.Boss1_timer.state = state + 1
			if #me.vars.timerstate==state then me.vars.Boss1_timer=false end
		end
	end
end

------------------------------------------------
---------------- Hooked Functions --------------
------------------------------------------------

function me.SendSystemMsg(txt)
	local playername = UnitName("player")
	if  string.find(txt, me.strings.FORMATION1) or  -- Change formation: lightning! - Boss 1
		string.find(txt, me.strings.FORMATION2) or  -- Change formation: traction! - Boss 1
		string.find(txt, me.strings.FORMATION3) or  -- Change formation: hammer!  - Boss 1
		string.find(txt, me.strings.FORMATION4) then -- Change formation: wedge! - Boss 1
		me.vars.Boss1_timer = {time=GetTime(), state=0}
	elseif string.find(string.match(txt, me.strings.TERRORSPREAD), playername) then -- Fear - Marrisha(4)
		ev.SendMessage(ev.helper.ReturnLoca("runaway_message", me.strings.terrorspread), "moveoutofgroup.mp3", {system=true})
		ev.SendChatMessage(ev.helper.ReturnLoca("fear_message", playername), nil, {"PARTY", "SAY"})
	elseif string.match(txt, me.strings.SEVERINGBOMB)==playername then -- Severing Bomb - Nex of Tasuq(2)
		ev.SendMessage(ev.helper.ReturnLoca("runaway_message", me.strings.severingbomb), "moveoutofgroup.mp3", {system=true})
		ev.SendChatMessage(ev.helper.ReturnLoca("stayaway_message1", playername, me.strings.severingbomb), nil, {"PARTY", "SAY"})
	elseif string.match(txt, me.strings.FOOTSOLDIER)==playername then -- Foot Soldier of Perdition - Nex of Tasuq(2)
		ev.SendMessage(ev.helper.ReturnLoca("donotmove_message", me.strings.footsoldier), "dontmove.mp3", {system=true})
	else
		return txt;
	end
end

------------------------------------------------
----------------- Event Handler ----------------
------------------------------------------------

function me.CHAT_MSG_PARTY(this, event, arg1,arg2,arg3,arg4)
	if arg4~=UnitName("player") then
		local id = string.match(arg1, "|Hev:(%d+)|h|h")
		if id == "501891" then
			ev.SendMessage(ev.helper.ReturnLoca("damagereflect_message2", string.format("%s %s",me.strings.targetchange, arg4)), "stopattack.mp3", {system=true})
		end
	end
end

function me.UNIT_CASTINGTIME(this, event, unit, timeORnil)
	if timeORnil==nil then me.vars.cast[UnitGUID(unit)]=nil return end -- if end of cast do delete cast
	name,_,curr = UnitCastingTime(unit);
	if type(me.vars.cast[UnitGUID(unit)])=="table" 
	and me.vars.cast[UnitGUID(unit)][1]==name -- if castname of target == saved cast
	and me.vars.cast[UnitGUID(unit)][2] < GetTime() then -- and the cast isn't finished -> do nothing
		return 
	end;
	me.vars.cast[UnitGUID(unit)] = {name,GetTime()+curr} -- else save the castname and time
	if name == me.strings.blackabyss then -- Black Abyss Terror - Mazzren (5)
		ev.SendMessage(ev.helper.ReturnLoca("interrupt_message", UnitName(unit), me.strings.blackabyss), "interrupt.mp3", {system=true})
	end
end

function me.UNIT_BUFF_CHANGED(this, event, arg1)
	if arg1=="player" then
		ev.helper.ReadBuffs()
		me.HandleBuffs()
	end
end

function me.HandleBuffs() 
	if ev.helper.GetBuff(501891) then -- Target Change - Nex of Tasuq (2)
		if not me.vars.buffs.TargetChange then
			me.vars.buffs.TargetChange=true;
			
			ev.SendMessage(ev.helper.ReturnLoca("damagereflect_message1",  me.strings.targetchange), "rip.mp3", {system=true})
			ev.SendChatMessage(ev.helper.ReturnLoca("buff_message1", UnitName("player"),  me.strings.targetchange).."|Hev:501891|h|h", nil, {"PARTY"})
		end
	else
		me.vars.buffs.TargetChange=false;
	end

	if ev.helper.GetBuff(502913) then -- Target Icon - Mazzren (5)
		if not me.vars.buffs.TargetIcon then
			me.vars.buffs.TargetIcon=true;
			
			ev.SendMessage(ev.helper.ReturnLoca("stayaway_message2",  me.strings.targeticon), "runawaymonster.mp3", {system=true})
			ev.SendChatMessage(ev.helper.ReturnLoca("buff_message1", UnitName("player"),  me.strings.targeticon).."|Hev:502913|h|h", nil, {"PARTY"})
		end
	else
		me.vars.buffs.TargetIcon=false;
	end
end

return me;
