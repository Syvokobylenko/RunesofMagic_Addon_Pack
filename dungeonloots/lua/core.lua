local me = {
	tag= "DL",
	name= "Dungeon Loots",
	version= "r78",

	oldzone = 0,
	helper = {
		treasure_cache = {},
	},
	loaddata = {},
	plus = {},
	scripts = {},
	worldmap = {
		tp = {instance={}, porter={}}
	},
	search = {
		result = {},
		
		boss = true,
		item = true,
		instance = true,
		treasure = true,
		bossinstance = true,
		onlyinstance = false,
	},
	tbls = {
		cards = {},
		instance = {},
		npc = {},
		recipe = {},
		special_loots = {},
		treasure = {},
		zone = {},
		armor = {},
		weapon = {},
		zoneoverride = {},
		translate_table = {},
	},
	ui = {
		update = nil,
		FilteredList = {},
		listid = -1, -- 0 instances, 1 Bosses, 2 Items, todo 3 Itemstats
		listtype = -1, -- 0 instances, 1 Bosses, 2 items, 3 search
		instanceid = nil,
		bossid = nil,
		itemid = nil,
		ListSelect = nil,
		ListSelectSearch = nil,
	},
	lang = {},
}

local DEFAULTS = {
	WoWMapInstanceDisabled = true,
	WoWMapTPPOIDisabled = true,
	DLWorldmapEnabled = true,
	DLInstanceEnabled = true,
	DLBossesEnabled = true,
	SortByName = true,
}
function me.SendMemsWarning()
	if GetZoneID() ~= me.oldzone then
		me.oldzone=GetZoneID()
		local data = DL.tbls.instance[me.oldzone]
		if not data then return end
		local num_mems = 0
		for i=1,#data.boss do
			if not data.boss[i].nocount then
				num_mems = num_mems + DL.helper.GetNumMems(data.boss[i].id)
			end
		end
		if num_mems>0 then
			local player_mems, maxcount=GetPlayerPointInfo(2,1,"");
			local txt = ""
			if num_mems == 1 then
				 txt = string.format(DL.lang.instance_memsmsg, num_mems, TEXT("SYS206879_name"))
			else
				 txt = string.format(DL.lang.instance_memsmsg, num_mems, TEXT("SYS_MONEY_TYPE_9"))
			end
			if num_mems+player_mems > maxcount then
				if maxcount-player_mems+num_mems == 1 then
					 txt = txt .. string.format(DL.lang.instance_memswarning,  player_mems+num_mems-maxcount, TEXT("SYS206879_name"))
				else
					 txt =  txt .. string.format(DL.lang.instance_memswarning,  player_mems+num_mems-maxcount, TEXT("SYS_MONEY_TYPE_9"))
				end
			end
			SendSystemMsg(txt)
			for i=1,8 do
				_G["ChatFrame"..i]:AddMessage("|cffff0000"..txt)
			end
		end
	end
end

function me.OnLoad(this)
	me.LoadLang()
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("LOADING_END")
	this:RegisterEvent("TB_UPDATE")
end

function me.LoadLang()
	local fn, err = loadfile(string.format("interface/addons/DungeonLoots/lang/%s.lua", string.sub(GetLanguage(), 1, 2)))
	if err then
		local fn, err = loadfile("interface/addons/DungeonLoots/lang/en.lua")
		if err then
			local fn, err = loadfile("interface/addons/DungeonLoots/lang/de.lua")
			if err then
				ChatFrame1:AddMessage(err)
			else
				me.lang = fn()
			end
		else
			me.lang = fn()
		end
	else
		me.lang = fn()
	end
end

function me.LoadVars()
	if type(DL_Settings)~="table" then
		DL_Settings = DEFAULTS
	else
		for var, val in pairs(DEFAULTS) do
			if type(DL_Settings[var])~=type(val) then
				DL_Settings[var] = val
			end
		end
	end
	SaveVariables("DL_Settings")
end

function me.RegisterWithAddonManager()
	if AddonManager and AddonManager.RegisterAddonTable then
		local addon={
			name = "DungeonLoots",
			description = "",
			author = "Pyrrhus",
			category="Information",
			slashCommands="/dl",
			version = me.version,

			icon = "Interface/playerframe/playerlooterbutton-normal.tga",
			onClickScript= function() ToggleUIFrame(DL_main_frame) end,

			mini_icon = "Interface/playerframe/playerlooterbutton-normal.tga",
			mini_icon_pushed = "Interface/playerframe/playerlooterbutton-depress.tga",
			mini_onClickScript= function() ToggleUIFrame(DL_main_frame) end,
		}
		AddonManager.RegisterAddonTable(addon)

		return true
	end
end

--/run DL.lang = loadfile("interface/addons/DungeonLoots/lang/de.lua")() me.LoadVars() me.ui.Init() me.worldmap.Init()
function me.OnEvent(event)
	if event == "VARIABLES_LOADED" then
		me.LoadVars()
		me.ui.Init()
		me.worldmap.Init()
		me.RegisterWithAddonManager()
	elseif event=="LOADING_END" then
		me.SendMemsWarning(arg1,arg2)
	elseif event == "TB_UPDATE" then
		if not WoWMapPOI or not(WoWMap and WoWMap.Data) then
			DL.worldmap.CollectTransport()
		end
	end
end

SLASH_DL1= "/dl"
SlashCmdList["DL"] = function (editBox, msg)
	if msg == "" then
		ToggleUIFrame(DL_main_frame)
	elseif msg == "romwelten" then
		DL.scripts.ExportCurrentView()
	elseif string.match(msg,"^%s*pos%s*(%d)") then
		DL.scripts.GetPosWithPoint(tonumber(string.match(msg,"pos%s*(%d)") or 1))
	elseif string.match(msg,"^%s*treasure%s*(%d+)") then
		DL.scripts.GetTreasure(tonumber(string.match(msg,"^%s*treasure%s*(%d+)") or 1))
	elseif msg=="loaddata" then
		DL.ui.LoadData()
	end
end
_G[me.tag] = me
