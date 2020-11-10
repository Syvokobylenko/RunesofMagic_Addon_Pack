-- Version: r41
-- Last modified: 2010-05-01T04:45:02Z
-- Last modified by: joselucas

local function print(value)
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(value);
	end

	if SELECTED_CHAT_FRAME and SELECTED_CHAT_FRAME ~= DEFAULT_CHAT_FRAME then
		SELECTED_CHAT_FRAME:AddMessage(value);
	end
end;

local function printf(stringFormat,  ...)
	print(string.format(stringFormat,  ...));
end;

local function stringJoin(separator, ...)
	local result = "";

	for i = 1, arg.n do
		local value = arg[i];

		if value ~= nil and value ~= "" then
			if #result > 0 then
				result = result .. separator .. value;
			else
				result = value;
			end
		end
	end

	return result;
end

local function formatNumber(n)
	local left, num, right = string.match(n,'^([^%d]*%d)(%d*)(.-)$');
	return left .. (num:reverse():gsub('(%d%d%d)','%1,'):reverse()) .. right;
end

local function dec2hex(dec)
	return string.format("%x", dec);
end

local function percentToHex(percent)
	local value = percent * 255;
	if (value >= 255) then return "FF"; end
	if (value == 0) then return "00";	end
	local c1 = dec2hex(math.floor(value / 16));
	local c2 = dec2hex(math.floor(value % 16));
	if (c1 == "") then c1 = "0"; end
	return c1 .. c2;
end

local function colorText(text, r, g, b)
	local hexColor = percentToHex(r) .. percentToHex(g) .. percentToHex(b);
	return string.format("|cff%s%s|r", hexColor, text);
end

---------------------------------------------
---------------------------------------------

local me = {
	name = "SimpleDamageLog",
	version = "r41",
	author = "Aulid",
	description = "", -- localized
	slashCommand = "/sdl",
	debug = false,
	settingsName = nil,
	config = nil,
	playerName = nil,
	frame = nil,
	isEventsRegistered = false,

	colors = {
		Skill =        { r = 0.2, g = 1.0, b = 1.0 },
		DamageSource = { r = 1.0, g = 1.0, b = 0.3 },
		HealSource =   { r = 1.0, g = 1.0, b = 0.3 },

		["DAMAGE"] = {
			MISS =     { r = 0.5, g = 0.5, b = 0.5 },
			DODGE =    { r = 0.5, g = 0.5, b = 0.5 },
			ABSORB =   { r = 0.5, g = 0.5, b = 0.5 },

			HALF =     { r = 1.0, g = 0.6, b = 0.6 },
			NORMAL =   { r = 1.0, g = 0.4, b = 0.4 },
			DOUBLE =   { r = 1.0, g = 0.2, b = 0.2 },
			CRITIAL =  { r = 1.0, g = 0.1, b = 0.1 }, -- note the typo
		},

		["HEAL"] = {
			HALF =     { r = 0.6, g = 1.0, b = 0.6 },
			NORMAL =   { r = 0.4, g = 1.0, b = 0.4 },
			DOUBLE =   { r = 0.2, g = 1.0, b = 0.2 },
			CRITIAL =  { r = 0.1, g = 1.0, b = 0.1 }, -- note the typo
		}
	},
	guiFrame = "SimpleDamageLogConfigFrame",
	
	checkboxes = {
		"Enable",
		"Lock",
		"OutgoingDamage",
		"OutgoingHeals",
		"IncomingDamage",
		"IncomingHeals",
		"ShowDamageSource",
		"ShowHealSource",
	},
	
	ABSORB = TEXT("FIGHT_ABORB"),
	DODGE = TEXT("FIGHT_DODGE"),
	HALF = TEXT("FIGHT_PARRY"),
	MISS = TEXT("FIGHT_MISS"),
	CRITIAL = string.sub(C_PHYSICAL_CRITICAL, 1, 8).."!",
	DOUBLE = string.sub(C_PHYSICAL_CRITICAL, 1, 8),
};

function me.PopClick(this, key)
	if key=="LBUTTON" then
		XAddon_ShowPage(me.guiFrame);
	else
		if me.config.Enable then
			me.Disable();
		else
			me.Enable();
		end
		me.LockFrames(me.config.Lock);
	end
end

function me.PopText()
	if me.config.Enable then
		return me.name.." - "..ON;
	else
		return me.name.." - "..C_OFF;
	end
end

function me.OnLoad(this)
	me.frame = this;
	
	if not me.isEventsRegistered then
		me.frame:RegisterEvent("VARIABLES_LOADED");
		me.frame:RegisterEvent("COMBATMETER_DAMAGE");
		me.frame:RegisterEvent("COMBATMETER_HEAL");
		me.isEventsRegistered = true;
	end

	me.settingsName = me.name .. "_Settings";

	-- set slash commands
	SLASH_SimpleDamageLog1 = me.slashCommand;
	
	SlashCmdList["SimpleDamageLog"] = function(frame, txt)
		if XBARVERSION and XBARVERSION>=1.51 then
			XAddon_ShowPage(me.guiFrame);
		else
			ToggleUIFrame(getglobal("SimpleDamageLogConfigFrame"));
		end
	end
end

function me.OnEvent(this, event, arg1)
	if me.config and me.config.Enable and (event == "COMBATMETER_DAMAGE" or event == "COMBATMETER_HEAL") then
		-- globals: _source, _target, _damage or _heal, _skill, _type
		if me.playerName == nil then
			me.playerName = UnitName("player");
		end

		-- only process player's events
		if _source == me.playerName or _target == me.playerName then
			local dmgOrHeal = string.sub(event, 13); -- #"COMBATMETER_" + 1
			me.OnCombatMeter(dmgOrHeal, _source, _target, _damage, _heal, _skill, _type);
		end
	elseif event == "VARIABLES_LOADED" then
		me.description = XBar.Lng.SDL.AddOnDescription;
		me.CheckSettings();
		me.Init();
		if not g_UIPanelAnchorFrameOptions.SimpleDamageLogFrameDmgIn then
			SimpleDamageLogFrameDmgIn:ClearAllAnchors();
			SimpleDamageLogFrameDmgIn:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", "UIParent", -300, -200);
			SimpleDamageLogFrameDmgOut:ClearAllAnchors();
			SimpleDamageLogFrameDmgOut:SetAnchor("BOTTOMLEFT", "BOTTOMLEFT", "UIParent", 300, -200);
		end
		SimpleDamageLogFrameDmgInMoveLabel:SetText(XBar.Lng.SDL.In);
		SimpleDamageLogFrameDmgOutMoveLabel:SetText(XBar.Lng.SDL.Out);
		SimpleDamageLogFrameDmgInMessages:SetHeight(me.config.Height*15);
		SimpleDamageLogFrameDmgOutMessages:SetHeight(me.config.Height*15);
		if XBARVERSION and XBARVERSION>=1.51 then
			XAddon_Register({
				gui={{
					name = "DamageLog",
					version = me.version,
					window = me.guiFrame,
				}},
				popup={{
					GetText = function() return me.PopText(); end,
					GetTooltip = function() return me.slashCommand.."\n"..me.description.."\n\nL: GUI".."\nR: On/Off"; end,
					OnClick = function(this, key) me.PopClick(this, key); end,
			}}});
		end
	end
end

function me.Init()
	if me.config.Enable then
		me.Enable();
	else
		me.Disable();
	end
	
	me.LockFrames(me.config.Lock);
end

function me.CheckSettings()
	local tempConfig = _G[me.settingsName];

	if tempConfig == nil then
		tempConfig = {};
	end

	local defaultConfig = me.GetDefaultConfig();
	me.config = {};

	-- use defaults for missing settings, and remove unused settings
	for name, value in pairs(defaultConfig) do
		if tempConfig[name] == nil then
			me.config[name] = value;
		else
			me.config[name] = tempConfig[name];
		end
	end

	_G[me.settingsName] = me.config;
	SaveVariables(me.settingsName);
end

function me.GetDefaultConfig()
	local defaultConfig = {
		Enable = true,
		Lock = false,
		OutgoingDamage = true,
		OutgoingHeals = true,
		IncomingDamage = true,
		IncomingHeals = true,
		ShowDamageSource = false,
		ShowHealSource = false,
		Height = 12,--*15
	};

	return defaultConfig;
end

function me.OnCombatMeter(dmgOrHeal, source, target, damage, heal, skill, dmgType)
	if target == me.playerName then
		-- incoming
		if dmgOrHeal == "DAMAGE" and me.config.IncomingDamage then
			me.WriteIn(dmgOrHeal, damage, skill, dmgType, source);
		elseif dmgOrHeal == "HEAL" and me.config.IncomingHeals then
			me.WriteIn(dmgOrHeal, heal, skill, dmgType, source);
		end
	elseif source == me.playerName then
		-- outgoing
		if dmgOrHeal == "DAMAGE" and me.config.OutgoingDamage then
			me.WriteOut(dmgOrHeal, damage, skill, dmgType, target);
		elseif dmgOrHeal == "HEAL" and me.config.OutgoingHeals then
			me.WriteOut(dmgOrHeal, heal, skill, dmgType, target);
		end
	end
end

function me.WriteIn(dmgOrHeal, hitPoints, skill, dmgType, source)
	local msg = me.GetCombatEventMessage(dmgOrHeal, hitPoints, skill, dmgType, source);
	local dmgInFrame = getglobal("SimpleDamageLogFrameDmgInMessages");
	dmgInFrame:AddMessage(msg);
end

function me.WriteOut(dmgOrHeal, hitPoints, skill, dmgType)
	local msg = me.GetCombatEventMessage(dmgOrHeal, hitPoints, skill, dmgType);
	local dmgOutFrame = getglobal("SimpleDamageLogFrameDmgOutMessages");
	dmgOutFrame:AddMessage(msg);
end

function me.GetCombatEventMessage(dmgOrHeal, hitPoints, skill, dmgType, source)
	local hitPointText = formatNumber(tonumber(hitPoints));
	local color = me.colors[dmgOrHeal][dmgType];
	local dmgTypeText;

	if dmgType == "NORMAL" then
		dmgTypeText = "";
	else
		dmgTypeText = me[dmgType].." " or dmgType.." ";
	end

	if color ~= nil then
		hitPointText = colorText(hitPointText, color.r, color.g, color.b);
		dmgTypeText = colorText(dmgTypeText, color.r, color.g, color.b);
	end

	if skill == "ATTACK" then
		skill = "";
	else
		local skillColor = me.colors.Skill;
		skill = colorText(skill.." ", skillColor.r, skillColor.g, skillColor.b);
	end

	if source then
		if dmgOrHeal == "DAMAGE" and me.config.ShowDamageSource then
			local sourceColor = me.colors.DamageSource;
			source = colorText(source.." ", sourceColor.r, sourceColor.g, sourceColor.b);
		elseif dmgOrHeal == "HEAL" and me.config.ShowHealSource then
			local sourceColor = me.colors.HealSource;
			source = colorText(source.." ", sourceColor.r, sourceColor.g, sourceColor.b);
		else
			source = "";
		end
	end

	return stringJoin("", source, sourceOrTarget, skill, dmgTypeText, hitPointText);
end

function me.Enable()
	getglobal("SimpleDamageLogFrameDmgOut"):Show();
	getglobal("SimpleDamageLogFrameDmgIn"):Show();
	me.config.Enable = true;

	if not me.isEventsRegistered then
		me.frame:RegisterEvent("COMBATMETER_DAMAGE");
		me.frame:RegisterEvent("COMBATMETER_HEAL");
		me.isEventsRegistered = true;
	end
end

function me.Disable()
	getglobal("SimpleDamageLogFrameDmgOut"):Hide();
	getglobal("SimpleDamageLogFrameDmgIn"):Hide();
	me.config.Enable = false;

	if me.isEventsRegistered then
		me.frame:UnregisterEvent("COMBATMETER_DAMAGE");
		me.frame:UnregisterEvent("COMBATMETER_HEAL");
		me.isEventsRegistered = false;
	end
end

function me.LockFrames(lock)
	if lock then
		getglobal("SimpleDamageLogFrameDmgOutMove"):Hide();
		getglobal("SimpleDamageLogFrameDmgInMove"):Hide();
	else
		getglobal("SimpleDamageLogFrameDmgOutMove"):Show();
		getglobal("SimpleDamageLogFrameDmgInMove"):Show();
	end

	me.config.Lock = lock;
end

function me.guiOnShow(this)
	-- set localized text on all widgets
	local titleText = string.format("%s %s", me.name, me.version);
	getglobal(me.guiFrame .. "TitleText"):SetText(titleText);

	for _, checkbox in ipairs(me.checkboxes) do
		local controlName = me.guiFrame .. checkbox .. "Text";
		getglobal(controlName):SetText(XBar.Lng.SDL[checkbox]);
	end
	
	for _, checkbox in ipairs(me.checkboxes) do
		local controlName = me.guiFrame .. checkbox;
		getglobal(controlName):SetChecked(me.config[checkbox]);
	end
	
	_G[me.guiFrame.."HeightText"]:SetText(" "..RAIDFRAME_PARTYSPACINGX)
	_G[me.guiFrame.."Height"]:SetText(me.config.Height)
	
	me.guiOnEnable(me.config.Enable);
	if XBARVERSION and XBARVERSION>=1.51 then
		XAddon_Page(this);
		XAddon_HideBack1(this);
		getglobal(me.guiFrame .. "TitleText"):SetText("");
	end
end

function me.guiOnApplySettings()
	for _, checkbox in ipairs(me.checkboxes) do
		local controlName = me.guiFrame .. checkbox;
		me.config[checkbox] = getglobal(controlName):IsChecked();
	end
	me.config.Height = _G[me.guiFrame.."Height"]:GetText()
	SimpleDamageLogFrameDmgInMessages:SetHeight(me.config.Height*15);
	SimpleDamageLogFrameDmgOutMessages:SetHeight(me.config.Height*15);
	
	me.Init();
end

function me.guiOnEnable(enabled)
	for _, checkbox in ipairs(me.checkboxes) do
		if checkbox ~= "Enable" then
			local controlName = me.guiFrame .. checkbox;
			
			if not enabled then
				getglobal(controlName):Disable();
			else
				getglobal(controlName):Enable();
			end
		end
	end
end

function me.guiOnIncomingDamage(checkbox)
	if checkbox:IsChecked() then
		getglobal(me.guiFrame .. "ShowDamageSource"):Enable();
	else
		getglobal(me.guiFrame .. "ShowDamageSource"):Disable();
	end
end

function me.guiOnIncomingHeals(checkbox)
	if checkbox:IsChecked() then
		getglobal(me.guiFrame .. "ShowHealSource"):Enable();
	else
		getglobal(me.guiFrame .. "ShowHealSource"):Disable();
	end
end

_G[me.name] = me;


