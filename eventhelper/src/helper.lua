local me = {
	vars = {
		lang = string.sub(GetLanguage(),1,2),
		basepath = "./interface/addons/EventHelper/",
		buffs = {},
    }
}

function me.LoadHelper()

end

function me.AddDebugMsg(...)
	ev.debugger.AddMessage(...)
end

function me.ReturnLoca(key, ...)
	local txt = ev.lang[key] or key;
	local argNum = select('#', ...)
	if argNum > 0 then
		for i = 1, argNum do
			local arg = select(i, ...)
			txt = string.gsub(txt, string.format("<arg%d>", i), arg)
		end
	end
	return txt
end

function me.ReadBuffs()
	me.vars.buffs = {}
	for i=1,100 do
		local name, icon, count, id = UnitBuffInfo("player",i);
		if (name or 1)==1 then
			break 
		else
			me.vars.buffs[id]= {count,}
		end
	end
end

function me.GetBuff(id)
	return me.vars.buffs[id]
end

function me.TranslateString(key)
	return GetReplaceSystemKeyword(TEXT(key))
end

function me.TranslateStrings(tbl)
	for a,b in pairs(tbl) do
		tbl[a] = me.TranslateString(b)
	end
	return tbl
end

function me.ReplaceTranslateRegex1(tbl)
	if tbl[2] then tbl[1] = me.TranslateString(tbl[1]) end -- Translate String
	if tbl[3] then tbl[1] = string.gsub(tbl[1], "%[%$VAR%d%]", "(.*)") end -- Replace VarX by (.*)
	if tbl[4] then tbl[1] = string.gsub(string.gsub(tbl[1], "%(", "%%("),"%)","%%)") end -- Replace ( ) by %(%)
	if tbl[5] then tbl[1] = string.gsub(string.gsub(tbl[1], "%(", "%%("),"%)","%%)") end -- Replace [ ] by %[%]
	if tbl[6] then tbl[1] = string.gsub(tbl[1], "%?", "%%?") end -- Replace ? by %?
	if tbl[7] then tbl[1] = string.gsub(tbl[1], "%.", "%%.") end -- Replace . by %.
	return tbl[1]
end

function me.ReplaceTranslateRegex2(tbl) 
	for a, b in pairs(tbl) do
		tbl[a] = me.ReplaceTranslateRegex1(b)
	end
	return tbl
end

function me.PlaySound(name, path)
	local spath = ""
	if path and type(path)=="string" then
		spath = string.format("%s/%s",path, name)
	else
		spath = string.format("%s/sounds/%s/%s",me.vars.basepath,me.vars.lang, name)
		local fn,err=loadfile(spath)
		if string.find(err,"No such file or directory") then
			spath = string.format("%s/sounds/en/%s",me.vars.basepath, name)
		end
	end
	
	PlaySoundByPath(spath)
end

return me
