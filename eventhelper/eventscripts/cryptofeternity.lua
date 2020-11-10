local me = {
	strings = {
		ICE  = {"WY_STRING_Z163_BLUERAY", true}, --/run ev.register.CryptOfEternity.IsActive=function() return true end SendSystemMsg(GetReplaceSystemKeyword(TEXT("WY_STRING_Z163_BLUERAY")))
		FIRE  = {"WY_STRING_Z163_REDRAY", true}, -- 
		ice = {"Sys851363_name", true}, -- 
		fire = {"Sys851361_name", true}, -- 
		
		crossvortex = {"Sys851345_name", true}, -- 
		wingstorm = {"Sys851344_name", true}, -- 
		concentrateddecay = {"Sys851326_name", true}, -- 
	},
	vars= {cast={},},
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
	frame:RegisterEvent("UNIT_CASTINGTIME")
	me.strings = ev.helper.ReplaceTranslateRegex2(me.strings)
end

function me.GetName()
	return GetZoneLocalName(164)
end

function me.IsActive()
	local zone = GetZoneID()
	return zone == 163 or zone == 164 or zone == 165
end

------------------------------------------------
---------------- Hooked Functions --------------
------------------------------------------------

function me.SendSystemMsg(txt)
	local new = nil
	if string.find(txt,me.strings.ICE) then
		ev.SendMessage(ev.helper.ReturnLoca("runaway_message", ev.helper.ReturnLoca("use_message", TEXT("Sys200150_name"), me.strings.ice)), nil, {system=true})
		ev.SendChatMessage(ev.helper.ReturnLoca("buff_message1", UnitName("player"), me.strings.ice), nil, {"PARTY","SAY"})
	elseif string.find(txt, me.strings.FIRE) then
		ev.SendMessage(ev.helper.ReturnLoca("runaway_message", ev.helper.ReturnLoca("use_message", TEXT("Sys200150_name"), me.strings.fire)), nil, {system=true})
		ev.SendChatMessage(ev.helper.ReturnLoca("buff_message1", UnitName("player"), me.strings.fire), nil, {"PARTY","SAY"})
	else
		return txt
	end
end

------------------------------------------------
----------------- Event Handler ----------------
------------------------------------------------

function me.UNIT_CASTINGTIME(this, event, unit, timeORnil)
	if timeORnil==nil then me.vars.cast[UnitGUID(unit)]=nil return end -- if end of cast do delete cast
	name,_,curr = UnitCastingTime(unit);
	if type(me.vars.cast[UnitGUID(unit)])=="table" 
	and me.vars.cast[UnitGUID(unit)][1]==name -- if castname of target == saved cast
	and me.vars.cast[UnitGUID(unit)][2] < GetTime() then -- and the cast isn't finished -> do nothing
		return 
	end;
	me.vars.cast[UnitGUID(unit)] = {name,GetTime()+curr} -- else save the castname and time
	
	if name == me.strings.crossvortex then -- cross vortex
		ev.SendMessage(ev.helper.ReturnLoca("stayaway_message1",  UnitName(unit), me.strings.crossvortex), "stayaway.mp3", {system=true})
	elseif name == me.strings.wingstorm then -- wingstorm
		ev.SendMessage(ev.helper.ReturnLoca("stayaway_message1",  UnitName(unit), me.strings.wingstorm), "stayaway.mp3", {system=true})
	elseif name == me.strings.concentrateddecay then -- concentrated decay
		ev.SendMessage(ev.helper.ReturnLoca("interrupt_message",  UnitName(unit), me.strings.concentrateddecay), "interrupt.mp3", {system=true})
	end
end

return me;
