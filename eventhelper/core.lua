
local me = {
	ver = "0.19-beta",
	tag = "ev",
	name = "Event Helper",
	loaded = false,
	active = false,
	fn = {},		-- functions
	register = {},	-- eventscripts
	helper = {},	-- helper functions
	debugger = {},	-- debugger functions
	hooked = {},	-- hooked functions
	ui = {},		-- ui functions
	lang = {}, -- localization
	frame = nil,
}

function me.fn.OnLoad(this)
	me.frame = this;
	local fn, err = loadfile("interface/addons/eventhelper/src/debugger.lua")
	if fn then me.debugger = fn() else print(err) return; end
	local fn, err = loadfile("interface/addons/eventhelper/src/helper.lua")
	if fn then me.helper = fn() else print(err) return; end
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("SAVE_VARIABLES")
	me.loaded = true;
end

function me.fn.LoadLoca()
	local fn, err = loadfile(string.format("interface/addons/Eventhelper/lang/%s.lua", string.sub(GetLanguage(), 1, 2)))
	if err then
		local fn, err = loadfile("interface/addons/Eventhelper/lang/en.lua")
		if err then
			ChatFrame1:AddMessage(err)
		else
			me.lang = fn()
		end
	else
		me.lang = fn()
	end
	local fn, err = loadfile("interface/addons/Eventhelper/lang/en.lua") -- curse workaround
	if err then return end
	if me.lang==nil then me.lang={} end
	for a, b in pairs(fn()) do
		if me.lang[a]==nil then
			me.lang[a]=b;
		end
	end
end

function me.fn.LoadVars()
	local fn, err = loadfile("interface/addons/eventhelper/src/settings.lua")
	if err and type(EventHelper_Settings)~="table" then
		me.Settings = {main={}}
	elseif err then
		me.Settings = EventHelper_Settings;
		return
	end
	
	local tbl = fn();
	if type(EventHelper_Settings)~="table" then
		me.Settings = tbl
	else
		me.Settings = me.fn.LoadVarsRecursive(EventHelper_Settings, tbl, 0)
		for a,b in pairs(me.register) do
			if type(b)=="table" then
				if type(b.GetSettings)=="function" then
					me.Settings[a] = me.fn.LoadVarsRecursive(EventHelper_Settings[a], b.GetSettings(), 0)
				end
				if type(b.GetSettings)=="function" then
					b.SetSettings(me.Settings[a])
				end
			end
		end
	end
end

function me.fn.LoadVarsRecursive(tbl, orig, num)
	if num>10 then return tbl end
	if tbl==nil then return orig end
	for a, b in pairs(orig) do
		if tbl[a] == nil then
			tbl[a] = b 
		elseif type(b) == "table" then
			tbl[a] = me.fn.LoadVarsRecursive(tbl[a], b, num+1)
		end
	end
	return tbl
end

function me.fn.SaveVars()
	EventHelper_Settings = me.Settings;
	for a,b in pairs(me.register) do
		if type(b)=="table" and type(b.GetSettings)=="function" then
			EventHelper_Settings[a] =  b.GetSettings()
		end
	end
	SaveVariables("EventHelper_Settings")
end

----------------- Message Box/Sound Functions -----------------
function me.fn.ToggleMessageMover(val)
	if val then
		EventHelper_Msg_Move:Show()
	else
		EventHelper_Msg_Move:Hide()
	end
end

function me.fn.SetMessageBoxPos(pos)
	print(pos, "todo: Save/Load This")
	if type(pos)=="table" then
		me.Settings.main.msgboxpos=pos
	elseif type(me.Settings.main.msgboxpos)=="table" and #me.Settings.main.msgboxpos==2 then
		EventHelper_Msg:SetPos(me.Settings.main.msgboxpos[1],me.Settings.main.msgboxpos[2])
	end
end

-------------------Send Functions -----------------------
function me.SendChatMessage(txt, sound, pos)
	if txt==nil then return end
	if me.Settings.main.ChatMessages then
		for a,b in pairs(pos) do
			if type(b)=="string" then
				SendChatMessage(txt, b)
			elseif type(b)=="number" then
				SendChatMessage(txt, "CHANNEL", 0, b)
			end
		end
	end
	-- write chat message in private chat
	if me.Settings.main.ChatMessagesToChat then
		if type(me.Settings.main.ChatMessagesToChat_chats)=="table" then
			for a, b in pairs(me.Settings.main.ChatMessagesToChat_chats) do
				if b then
					_G["ChatFrame"..a]:AddMessage(txt)
				end
			end
		end
	end
	me.PlaySound(sound)
end

-- /run ev.SendMessage("test", nil, {system=true, warning=true})
-- /run ev.SendChatMessage("test", nil, {"PARTY"})
function me.SendMessage(txt, sound, pos)
	if txt==nil then return end
	-- write chatmessage in the eventhelper frame
	if me.Settings.main.MessagesToOwn then
		EventHelper_MsgFrame:AddMessage(txt)
	end
	-- write chat message in private chat
	if me.Settings.main.MessagesToChat then
		if type(me.Settings.main.MessagesToChat_chats)=="table" then
			for a, b in pairs(me.Settings.main.MessagesToChat_chats) do
				if b then
					_G["ChatFrame"..a]:AddMessage(txt)
				end
			end
		end
	end

	if type(pos)=="table" then
		-- print messages in the system chat
		if me.Settings.main.MessagesToSystem and pos.system then
			SystemMsgFrame:AddMessage(txt, 1, 0.95, 0.40 );
		end
		-- print messages in the warning chat
		if me.Settings.main.MessagesToWarning and pos.warning then
			WarningFrame:AddMessage(txt, 0.93, 0.11, 0.14);
		end
	end
	me.PlaySound(sound)
end

function me.PlaySound(sound)
	-- sound
	if me.Settings.main.sound then
		if type(sound)=="string" then
			me.helper.PlaySound(sound)
		elseif type(sound)=="table" then
			me.helper.PlaySound(sound[1], sound[2])		
		end
	end
end
----------------- Active Functions -----------------

function me.fn.IsActive()
	if (me.active and me.loaded) then return true end
	return false
end

-- Set Active (addon active y/n)
function me.fn.SetActive(value)
	me.active = value
	for a,b in pairs(me.ui) do
		if type(b.SetActive)=="function" then
			local status, ret = pcall(b.SetActive, me.active)
			if status==false then
				me.debugger.AddMessage(string.format("Error: function %s.%s caused %s", a, "SetActive", tostring(ret)))
			end
		end
	end
end

----------------- UI Forward ---------------------
function me.fn.InitUI()
	for a,b in pairs(me.ui) do
		if type(b.Init)=="function" then
			pcall(b.Init)
		end
	end
end

-- Script Forward
function me.fn.OnEvent(this, event)
	if not me.loaded then return end
	if event=="VARIABLES_LOADED" then
		me.fn.LoadLoca()
		me.fn.LoadEventscripts()
		me.fn.LoadVars()
		me.fn.InitUI()
		me.fn.SetMessageBoxPos()
		me.fn.SetActive(not(ev and ev.Settings and ev.Settings and ev.Settings.main) or ev.Settings.main.active)
	elseif event=="SAVE_VARIABLES" then
		me.fn.SaveVars()
	end
	if not me.active then return end
	for a,b in pairs(me.register) do
		if type(b)=="table" and type(b[event])=="function" then
			if ((type(b.IsActive)=="function" and b.IsActive()) or b.IsActive==nil) and (type(b.GetSettings)~="function" or b.GetSettings().active) then
				local status, ret = pcall(b[event],this, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
				if status==false then
					me.debugger.AddMessage(string.format("Error: function %s.%s caused %s", a, event, ret))
				end
			end
		end
	end
end

function me.fn.OnUpdate()
	if not (me.loaded and me.active) then return end
	for a,b in pairs(me.register) do
		if type(b)=="table" and type(b.OnUpdate)=="function" then
			if ((type(b.IsActive)=="function" and b.IsActive()) or b.IsActive==nil) and (type(b.GetSettings)~="function" or b.GetSettings().active) then
				local status, ret = pcall(b.OnUpdate)
				if status==false then
					me.debugger.AddMessage(string.format("Error: function %s.%s caused %s", a, "OnUpdate", ret))
				end
			end
		end
	end
end

-- Register Scripts
function me.fn.LoadEventscripts()
	local fn, err = loadfile("interface/addons/eventhelper/eventscripts/_ev.lua")
	if err then print(err) return end;
	local tbl = fn()
	if type(tbl)~="table" then
		me.debugger.AddMessage("ev.lua doesn't contain a valid table")
		return;
	end
	for _, file in pairs(tbl) do
		local fn, err = loadfile(string.format("interface/addons/eventhelper/eventscripts/%s.lua", file))
		if err then
			me.register[file] = -1
			me.debugger.AddMessage(err)
		else
			me.fn.RegisterEventHandler(file, fn)
		end
	end
end

function me.fn.RegisterEventHandler(name, loadfn)
	if me.register[name]==nil then
		me.register[name] = loadfn();
		if type(me.register[name])=="table" and
			type(me.register[name].LoadEvent)=="function" then
				local status, ret = pcall(me.register[name].LoadEvent, me.frame)
				if status==false then
					me.debugger.AddMessage(string.format("Error: function %s.%s caused %s", name, "LoadEvent", tostring(ret)))
				end
		end
	else
		me.debugger.AddMessage(string.format("File (%s) duplicated or already loaded", name))
	end
end

-- Register Hooks
function me.fn.AddHook(func)
	if type(func)~="string" then me.debugger.AddMessage("Error: function has to be a string") return end;
	if me.hooked[func]~=nil then return end;
	
	me.hooked[func] = _G[func]
	_G[func] = function(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
		if me.loaded and me.active then
			for a,b in pairs(me.register) do
				if type(b)=="table" and type(b[func])=="function" then
					if ((type(b.IsActive)=="function" and b.IsActive()) or b.IsActive==nil) and (type(b.GetSettings)~="function" or b.GetSettings().active) then
						local status, ret = pcall(b[func],arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9)
						if status==true then
							if ret == nil then 
								return;
							elseif type(ret)=="table" then
								arg1=ret[1];
								arg2=ret[2];
								arg3=ret[3];
								arg4=ret[4];
								arg5=ret[5];
								arg6=ret[6];
								arg7=ret[7];
								arg8=ret[8];
								arg9=ret[9];
							else 
								arg1 = ret;
							end
						else
							me.debugger.AddMessage(string.format("Error: function %s.%s caused %s", a, func, ret))
						end
					end
				end
			end
		end
		me.hooked[func](arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9);
	end
end

SLASH_EV1= "/ev"
SlashCmdList["EV"] = function (editBox, msg)
	EventHelper_Main:Show()
end
_G[me.tag] = me
