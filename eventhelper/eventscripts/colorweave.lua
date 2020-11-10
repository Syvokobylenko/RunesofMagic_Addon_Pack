local me = {
	strings = {
		shuttle = {"SC_2012LOOM_01", true},
		thread = {"SC_2012LOOM_02", true},
		scissor = {"SC_2012LOOM_03", true},
		message = {"SC_2012LOOM_MES04", true},
		matrix = {"SC_2012LOOM_MES05", true},
		message_matrix = {"SC_2012LOOM_MES06", true},
	},
	vars = {
		blockNextMessage = false,
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
	ev.fn.AddHook("SendWarningMsg")
	me.strings = ev.helper.ReplaceTranslateRegex2(me.strings)
end

function me.GetName()
	return TEXT("_glossary_02636") -- Colorweave Festival
end

function me.IsActive()
	local zone = GetZoneID()
	return zone == 2
end

------------------------------------------------
---------------- Hooked Functions --------------
------------------------------------------------

function me.SendWarningMsg(txt)
	-- Weaving Machine // Webmaschine
	if (txt==me.strings.message) then
		me.vars.blockNextMessage = true;
		txt= string.format("|cfff7fe2e%s", ev.helper.ReturnLoca("colorweave_lookmatrix")) --
	elseif (txt==me.strings.matrix ) then
		txt= string.format("|cfff7fe2e%s", ev.helper.ReturnLoca("colorweave_lookmessage"))
	elseif (txt==me.strings.message_matrix)  then
		txt= string.format("|cfffe2ef7%s", ev.helper.ReturnLoca("colorweave_bothwrong"))
	else
		return txt
	end
	ev.SendMessage(txt, nil, {warning=true})
end

function me.SendSystemMsg(txt)
	-- Weaving Machine // Webmaschine
	local found = nil
	if (txt:find(me.strings.shuttle)) then
		found = string.format("|cffff0000%s", ev.helper.ReturnLoca("colorweave_shuttle"))-- "rot: Schiffchen",
	elseif (txt==me.strings.thread) then
		found = string.format("|cff0040ff%s",  ev.helper.ReturnLoca("colorweave_thread")) -- "blau: Garn",
	elseif (txt==me.strings.scissor) then
		found = string.format("|cff00ff00%s", ev.helper.ReturnLoca("colorweave_scissor")) -- "gruen: Schere",
	end

	if me.vars.blockNextMessage and found then
		me.vars.blockNextMessage = false;
		return nil
	elseif found then
		ev.SendMessage(found, nil, {system=true})
	else
		return txt
	end
end

return me;
