local me = {
	strings = {
		undeadworship = {"Sys851605_name", true}, -- Undead Worship
		sabrestrike = {"Sys851572_name", true}, -- Sabre Strike
		pinpointsoulstrike = {"Sys490155_name", true}, -- Pinpoint Soulstrike
	},
	vars= {cast={},},
	Settings = {
		active = true,
	},
}

function me.LoadEvent(frame)
	frame:RegisterEvent("UNIT_CASTINGTIME")
	me.strings = ev.helper.ReplaceTranslateRegex2(me.strings)
end

function me.GetSettings()
	return me.Settings
end

function me.SetSettings(tbl)
	if type(tbl)=="table" then
		me.Settings=tbl
	end
end

function me.GetName()
	return GetZoneLocalName(170)
end

function me.IsActive()
	local zone = GetZoneID()
	return zone == 169 or zone == 170 or zone == 171
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
	
	if name == me.strings.undeadworship then -- Undead Worship
		ev.SendMessage(ev.helper.ReturnLoca("stayaway_message1", UnitName(unit), me.strings.undeadworship), "stayaway.mp3", {system=true})
	elseif name == me.strings.sabrestrike then -- Sabre Strike
		ev.SendMessage(ev.helper.ReturnLoca("stayaway_message1", UnitName(unit), me.strings.sabrestrike), "stayaway.mp3", {system=true})
	elseif name == me.strings.pinpointsoulstrike then -- Pinpoint Soulstrike
		ev.SendMessage(ev.helper.ReturnLoca("interrupt_message", UnitName(unit), me.strings.pinpointsoulstrike), "interrupt.mp3", {system=true})
	end
end

return me;
