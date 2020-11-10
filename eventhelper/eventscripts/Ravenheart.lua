local me = {
	strings = {
		TonaMessage = {"LUA_703146_AI_TONA_GREETING", true},
		Tona = {"Sys108819_name", true},
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

-- /run SendSystemMsg(GetReplaceSystemKeyword(TEXT("LUA_703146_AI_TONA_GREETING")))
function me.LoadEvent(frame)
	ev.fn.AddHook("SendSystemMsg")
	me.strings = ev.helper.ReplaceTranslateRegex2(me.strings)
end

function me.GetName()
	return GetZoneLocalName(176)
end

function me.IsActive()
	local zone = GetZoneID()
	return zone == 175 or zone == 176 or zone == 177
end

------------------------------------------------
---------------- Hooked Functions --------------
------------------------------------------------

function me.SendSystemMsg(txt)
	if string.find(txt, me.strings.TonaMessage) then --Tona Greeting
		ev.SendMessage(ev.helper.ReturnLoca("aggro_message2", me.strings.Tona), "runawayboss.mp3", {system=true})
		ev.SendChatMessage(ev.helper.ReturnLoca("aggro_message1", UnitName("player"), me.strings.Tona), nil, {"SAY","PARTY"})
	else
		return txt
	end
end

return me;
