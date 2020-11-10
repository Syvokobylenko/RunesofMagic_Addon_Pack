--------------------------------------------------------------------------------------------------------------
-- WoWMap
--
-- written by DaKhaa, Dusk03, Mavoc, McBen and PetraAreon
-- additional maps by Lestat
-- released under the GNU General Public License version 3 (GPLv3)
--
-- Get the current version at:   http://rom.curse.com/downloads/rom-addons/details/wowmap.aspx
--------------------------------------------------------------------------------------------------------------
local WoWMap = {}
_G.WoWMap = WoWMap

WoWMapSettings = {}

WoWMap.Data = {
    Version       = "v7.4.1",
	Language	= GetImageLocation("WORLDMAP"):lower(),
	Instances	= false,
	Scale		= 0,

	Defaults = {
		Version   = false,
        DrawAllQuestPOIs = false,
        UseShiftModifier = false,
    --[===[@debug@
        ShowNpcID = false,
    --@end-debug@]===]
        POIs={},
	},
}

local FAKE_MAP = 100
local MAIN_CONTINENTS={9998,9997,9996,9995,9994,9993}

function WoWMap.OnLoad(this)

	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("MAP_CHANGED")
	this:RegisterEvent("MAP_DISABLE")
	this:RegisterEvent("RESET_QUESTBOOK")
	this:RegisterEvent("UNIT_LEVEL")
	this:RegisterEvent("SAVE_VARIABLES")

    WoWMap.Frame = WoWMapFrame

    WorldMapSelectMapMenu.showFunction = WoWMap.WorldMap_SelectMapMenu_OnShow
end

-- Map Selection DropDown
local function MapSelected(button)
    WorldMapFrame_SetWorldMapID( button.value )
end

local function InsertMap(map_id,menu_level)
    local info = {}
	info.text 	= WoWMap.GetZoneNameLocal(map_id)
    --[===[@debug@
    info.text 	= info.text..string.format(" (%i)",map_id)
    --@end-debug@]===]
	info.value	= map_id
	info.checked	= map_id == WoWMap.GetCurrentMapID()
	info.keepShownOnClick = 1
	info.isRadioButton = 1
	info.func 	= MapSelected

	UIDropDownMenu_AddButton( info, menu_level)
end

local function ShowMapGroups()

    local info = {}
    info.text 	= UI_WORLDMAP_SELECT_MAP
    info.isTitle	= 1
    info.value	= 1
    info.notCheckable=true
    UIDropDownMenu_AddButton( info, 1 )

    for mapTypeIndex,mapType in ipairs( g_MapTypes ) do

        local name = TEXT( string.upper("UI_WORLDMAP_"..mapType) )

        if mapTypeIndex==3 then name = TEXT("PB_DROPDOWN_INSTANCE") end

        info = {}
		info.text 	= name
		info.hasArrow	= 1
		info.value	= mapTypeIndex
        info.notCheckable=true
		UIDropDownMenu_AddButton( info, 1 )
    end

    info = {}
    info.text 	= C_CANCEL
    info.func 	= function() end
    info.notCheckable=true
    UIDropDownMenu_AddButton( info, 1 )
end

local function IsMapOnContinent(map_id,continent)
    if map_id==continent then return true end

    local p = WoWMap.MapData.ZoomOutTable[map_id]
    if p and p~=9999 then
        return IsMapOnContinent(p,continent)
    end
end

local function GetMainContinent(map_id)
    for _,continent in ipairs(MAIN_CONTINENTS) do
        if IsMapOnContinent(map_id,continent) then
            return continent
        end
    end
end

local function GetMapsByType(map_type)
    local maps={}
    local is_in={}

    local map_type_str = g_MapTypes[map_type]
    local wcount = WorldMap_GetWorldCount()
	for w = 1, wcount do
        local mapCount = WorldMap_GetMapCount( w, map_type_str )

        for mapIndex = 1 , mapCount do
		    local _,id = WorldMap_GetMap( w, map_type_str, mapIndex )

            if id==80 then id=211 end -- firefortrest
            if id==5 then id=358 end -- Ystra

            if not is_in[id] then
                table.insert(maps,id)
                is_in[id]=1
            end
        end
    end

    for id,data in pairs(WoWMap.MapData.CustomMaps.maps) do
        if data.kind == map_type and not is_in[id] then
            table.insert(maps,id)
            is_in[id]=1
        end
    end

    return maps
end

local function ShowMaps(map_type, continent,menu_level)
    local maps = GetMapsByType(map_type)
    for _,id in ipairs(maps) do
        if IsMapOnContinent(id,continent) then
            InsertMap(id, menu_level)
        end
    end
end

local function ShowContinents(map_type)

    current_map_type = map_type

    local unassigend={}
    local used_continents={}

    local maps = GetMapsByType(map_type)
    for _,id in ipairs(maps) do
        local continent = GetMainContinent(id)
        if continent then
            used_continents[continent] = (used_continents[continent] or 0)+1
        else
            table.insert(unassigend,id)
        end
    end

    if next(used_continents,next(used_continents)) then
        for _,map_id in ipairs( MAIN_CONTINENTS ) do
            local c = used_continents[map_id]
            if c then
                if c==1 then
                    ShowMaps(map_type, map_id,2)
                else
                    info = {}
		            info.text =  WoWMap.GetZoneNameLocal(map_id)
		            info.hasArrow	= 1
                    info.value	= map_id
                    info.notCheckable=true
		            UIDropDownMenu_AddButton( info, 2 )
                end
            end
        end
    else
        local continent = next(used_continents)
        if continent then
            ShowMaps(map_type, continent,2)
        end
    end

    for _,map_id in ipairs( unassigend ) do
        InsertMap(map_id,2)
    end
end

function WoWMap.WorldMap_SelectMapMenu_OnShow()

	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
        ShowMapGroups()
    elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
        ShowContinents(UIDROPDOWNMENU_MENU_VALUE)
    elseif UIDROPDOWNMENU_MENU_LEVEL == 3 then
        ShowMaps(current_map_type, UIDROPDOWNMENU_MENU_VALUE,3)
    end
end

-------------------------
function WoWMap.OnEvent(this, event)
    if WoWMap[event] then WoWMap[event]() end
end

function WoWMap.RESET_QUESTBOOK()
    if WorldMapFrame:IsVisible() then
        WoWMap.UpdateQuestPOIs()
    end
end

function WoWMap.UNIT_LEVEL()
    if arg1 == "player" and WorldMapFrame:IsVisible() then
        WoWMap.UpdateQuestPOIs()
    end
end


function WoWMap.VARIABLES_LOADED()

    UIDropDownMenu_Initialize( WorldMapOptionMenu, WoWMap.WorldMapOptionMenu_Show, "MENU")

    if AddonManager then
        local addon = {
            name = "WoWMap",
            version = WoWMap.Data.Version,
            author = "DaKhaa, Dusk03, Mavoc, McBen, Lestat and PetraAreon",
            description = "Makes the map in Runes of Magic feel more like the map in World of Warcraft for easier handling.",
            icon = "Interface/Addons/WoWMap/Images/icon",
            category = "Map",
            configFrame = nil,
            slashCommand = nil,
            miniButton = nil,
        }
        if AddonManager.RegisterAddonTable then
            AddonManager.RegisterAddonTable(addon)
        else
            AddonManager.RegisterAddon(addon.name, addon.description, addon.icon, addon.category,
            addon.configFrame, addon.slashCommand, addon.miniButton, addon.version, addon.author)
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("WoWMap "..WoWMap.Data.Version.." loaded")
    end

    WoWMap.Hooks()

    WoWMap.UpdateSettings()
    SaveVariables("WoWMapSettings")
    SaveVariablesPerCharacter("WoWMap_LastMap")


    WoWMap.FindNPCTestFunction()

    WoWMap_LastMap = WoWMap_LastMap or GetCurrentWorldMapID()
end

function WoWMap.SAVE_VARIABLES()

	if( not g_WorldMapConfig )then
		g_WorldMapConfig = {};
	end

	if( g_WorldMapConfig.showFinishedQuest == nil )then g_WorldMapConfig.showFinishedQuest = false ; end
	if( g_WorldMapConfig.showNewQuest      == nil )then g_WorldMapConfig.showNewQuest      = false ; end
	if( g_WorldMapConfig.showTrustQuest    == nil )then g_WorldMapConfig.showTrustQuest    = false ; end
	if( g_WorldMapConfig.showUnfinishQuest == nil )then g_WorldMapConfig.showUnfinishQuest = false ; end
	g_WorldMapConfig.hideQuestTrackFrame = MinimapFrameQuestTrackButton:IsChecked()
end

local orig_QuestTracker_OnEvent = QuestTracker_OnEvent

function QuestTracker_OnEvent( this, event )
	orig_QuestTracker_OnEvent(this, event)

	if( event == "VARIABLES_LOADED" )then
		if(g_WorldMapConfig.hideQuestTrackFrame == nil) then
			g_WorldMapConfig.hideQuestTrackFrame = false
		end
		MinimapFrameQuestTrackButton:SetChecked( g_WorldMapConfig.hideQuestTrackFrame );
		if(MinimapFrameQuestTrackButton:IsChecked())then
			QuestTrackerFrame:Hide();
		end
	end
end

function binarySearch(list,value)
    local low = 1
    local high = #list
    local mid = 0
    while low <= high do
        mid = math.floor((low+high)/2)
        assert(list[mid],tostring(mid))
        if list[mid] > value then high = mid - 1
        else if list[mid] < value then low = mid + 1
             else return mid
             end
        end
    end
end

local DN_Npc,DN_Npc_public
function WoWMap.IsNPCDailyQuestGiver(npc_id)
    if not DN_Npc then
        if WoWMapPOI and WoWMapPOI.GetListOfQuestGivers then
            DN_Npc,DN_Npc_public = WoWMapPOI.GetListOfQuestGivers()
        elseif DailyNotes and DailyNotes.GetListOfQuestGivers then
            DN_Npc,DN_Npc_public = DailyNotes.GetListOfQuestGivers()
        else
            return
        end
    end

    if binarySearch(DN_Npc,npc_id) then return 1 end
    if binarySearch(DN_Npc_public,npc_id) then return 2 end
end

function WoWMap.FindNPCTestFunction()
    if (DailyNotes and DailyNotes.GetListOfQuestGivers) or
       (WoWMapPOI and WoWMapPOI.GetListOfQuestGivers) then
        return
    end

    if WoWMapPOI and WoWMapPOI.IsNPCDailyQuestGiver then
        WoWMap.IsNPCDailyQuestGiver = WoWMapPOI.IsNPCDailyQuestGiver
    elseif DailyNotes and DailyNotes.IsQuestGiver then
        WoWMap.IsNPCDailyQuestGiver = DailyNotes.IsQuestGiver
    else
        WoWMap.IsNPCDailyQuestGiver = function() return end
    end
end

function WoWMap.MAP_CHANGED()
    WoWMap_LastMap = GetCurrentWorldMapID()
    WorldMapFrame_SetWorldMapID( WoWMap.GetCurrentWorldMapID() )
end

function WoWMap.MAP_DISABLE()
    UI_WorldMapFrame = WorldMapFrame
end

function WoWMap.UpdateSettings()

    for i, v in pairs(WoWMap.Data.Defaults) do
		if not WoWMapSettings[i] then WoWMapSettings[i] = v end
	end

	for i, v in pairs(WoWMapSettings) do
		if WoWMap.Data.Defaults[i]==nil then WoWMapSettings[i] = nil end
	end

	WoWMapSettings.Version = WoWMap.Data.Version
end

--------------------------
-- Map Alpha
function WoWMap.OnLoadAlphaSlider(this)
    -- prevent call on startup
    local temp = WoWMap.OnAlphaSliderChanged
    WoWMap.OnAlphaSliderChanged = function () end

	this:SetValueStepMode("FLOAT")
	this:SetMinMaxValues(0.2, 1)
	this:SetValue(1.0)

    WoWMap.OnAlphaSliderChanged = temp
end

function WoWMap.OnAlphaSliderChanged(this,arg1)
    WoWMap.SetMapAlpha(arg1 or 1.0)
end

function WoWMap.OnAlphaSliderWheel(this,delta)
    local alpha = this:GetValue()
    alpha = alpha+delta/1600
    WoWMap.SetMapAlpha(alpha)
end

function WoWMap.GetMapAlpha()
    return WorldMapViewFrame_WorldMapTexture_1:GetAlpha()
end

function WoWMap.SetMapAlpha(alpha, complete)
    if alpha<0.2 then alpha=0.2 end
    if alpha>1.0 then alpha=1.0 end
    WoWMapAlphaSlider:SetValue(alpha)

    if alpha<1.0 then
        WoWMapClientVersionWarning:Hide()
    else
        WoWMapClientVersionWarning:Show()
    end

    if alpha<0.9 then
        WorldMapFrame:SetMouseEnable(false)
        WorldMapViewFrame:SetMouseEnable(false)
    else
        WorldMapFrame:SetMouseEnable(true)
        WorldMapViewFrame:SetMouseEnable(true)
    end

    if complete then
        WorldMapFrame:SetAlpha(alpha)
        return
    end

    local fnames={
    	"WorldMapOptionButton",	"WorldMapSelectMapButton",
        "WoWMapUIFrame", "WoWMapOverlayFrame", -- WoWMap
        "yGather_WorldmapButton", "yGather_WorldmapQuickSwitchButton", -- YGatherer
        "QH_MapButton", -- QuestHelper
       	"WorldMapFrameTitle", "WorldMapFrameCloseButton",
        "WorldMapBorderFrame",
        "WorldMapFrame_Bottom",	"WorldMapFrame_Middle",	"WorldMapFrame_Top",	"WorldMapFrame_Left",
	    "WorldMapFrame_Right", "WorldMapFrame_TopLeft","WorldMapFrame_TopRight","WorldMapFrame_BottonLeft",	"WorldMapFrame_BottonRight",
    }

    for _,n in ipairs(fnames) do
        if _G[n] then _G[n]:SetAlpha(alpha) end
    end
    for i=1,12 do _G["WorldMapViewFrame_WorldMapTexture_"..i]:SetAlpha(alpha) end
end

--------------------------
local ori_SetNpcTrackWorldMapZone = SetNpcTrackWorldMapZone
function SetNpcTrackWorldMapZone(ID)
	ori_SetNpcTrackWorldMapZone(ID)

	local FilePath = WoWMap.GetImagePath(ID)

    if FilePath then
        for i = 1, 12 do
            getglobal("NpcTrackWorldMapFrame_WorldMapTexture_"..i):SetFile(FilePath..i)
        end
    end
end

local ori_AreaMapFrame_SetWorldMapID = AreaMapFrame_SetWorldMapID
function AreaMapFrame_SetWorldMapID(ID)
	ori_AreaMapFrame_SetWorldMapID(ID)

	local FilePath = WoWMap.GetImagePath(ID)

    if FilePath then
        for i = 1, 12 do
            getglobal("AreaMapViewFrame_WorldMapTexture_"..i):SetFile(FilePath..i)
        end
    end
end

local ori_WorldMapFrame_OnShow = WorldMapFrame_OnShow
function WorldMapFrame_OnShow( this )
    WoWMap.IsMapDisabled = (GetCurrentWorldMapID()==400 or GetCurrentWorldMapID()==-1)

    WoWMap.CollectQuestPOIs()
    ori_WorldMapFrame_OnShow(this)
	WorldMapFrame_SetWorldMapID( WoWMap.GetCurrentWorldMapID() )
end

function WoWMap.GetCurrentWorldMapID()
    local cur_map = GetCurrentWorldMapID()

    -- RoM Bug Workaround
    if cur_map == 19 then
        local zone = GetZoneID()%1000
        if zone==136 or zone==137 or zone==138 then
            cur_map = 137
        end
    end

    -- our sub zones
    local cust_area = WoWMap.MapData.CustomMaps.parents[cur_map]
    if cust_area then
        local x,y = GetPlayerWorldMapPos()
        if x and y then
            for map_id,area in pairs(cust_area) do
                if WoWMap.IsPointInRect(x,y,area) then
                    return map_id
                end
            end
        else
            return WoWMap_LastMap
        end
    end

    return cur_map
end

-- XBar III workaround #1
local ori_WorldMapFrame_Init = WorldMapFrame_Init
function WorldMapFrame_Init( this )
    ori_WorldMapFrame_Init(this)
    WoWMap.Hook_SetWorldMapID()
end

local ori_WorldMapFrame_SetWorldMapID
function WoWMap.Hook_SetWorldMapID(ID)
    ori_WorldMapFrame_SetWorldMapID = WorldMapFrame_SetWorldMapID
    WorldMapFrame_SetWorldMapID = WoWMap.WoWMap_SetWorldMapID
end

function WoWMap.WoWMap_SetWorldMapID(ID)

    if not WorldMapFrame:IsVisible() then return end

    -- workarounds
    if ID==400 or ID==-1 then ID=9999 end -- no-map zones

    UI_WorldMapFrame = WorldMapFrame

    local fakeID = ID
	if WoWMap.IsCustomMap(ID) then
		fakeID = FAKE_MAP
    end

    ori_WorldMapFrame_SetWorldMapID(fakeID)

    if not WorldMapFrame:IsVisible() then
        -- show map..even if real function hides it
        ShowUIPanel( WorldMapFrame )
        SetWorldMapID(fakeID)
        WorldMapFrame.mapID =fakeID
    end

	WorldMapFrame.WoWMapID = ID

	WorldMapSelectMapButton:SetText(WoWMap.GetZoneNameLocal(ID))

	local FilePath, FileOverlay = WoWMap.GetImagePath(ID)

	WoWMap.UpdateWarning(fakeID, FilePath)

	if FilePath then
	    for i = 1, 12 do
		    _G["WorldMapViewFrame_WorldMapTexture_"..i]:SetFile(FilePath..i)
	    end
    end

    if FileOverlay then
        WoWMapOverlayFrame:Show()
        WoWMapOverlay:SetFile(FileOverlay)
    else
        WoWMapOverlayFrame:Hide()
    end

    WoWMap.ShowPOIs(ID)
end

function WoWMap.GetZoneNameLocal(MAP_ID)
    local data = WoWMap.GetCustomMapData(MAP_ID)
    if data then
        return data.name
    end
	return GetZoneLocalName(MAP_ID)
end

function WoWMap.GetImagePath(MAP_ID)
	local FilePath, FileOverlay

	local ZoneName =GetZoneEnglishName(MAP_ID)
    local cust_map_data = WoWMap.GetCustomMapData(MAP_ID)
	if not ZoneName and not cust_map_data then return end

    -- XBar III workaround #2
    if ZoneName then
        FilePath = "Interface/WorldMap/" .. WoWMap.Data.Language .. "/" .. ZoneName .. "/"
    end

    local overrides = WoWMap.MapData.Overrides[MAP_ID]

	if cust_map_data then
        FilePath, FileOverlay = WoWMap.GetCustomTextures(cust_map_data)
	elseif overrides then
        if overrides.custom then
		    FilePath = overrides.custom
        else
            local use_lang = overrides.uselanguage or WoWMap.Data.Language
            local use_zone = overrides.usezone or ZoneName
            if type(overrides.usezone)=="number" then
                use_zone = GetZoneEnglishName(overrides.usezone)
            end

   		    FilePath = "Interface/WorldMap/"..use_lang.."/"..use_zone.."/"
        end
	end

	return FilePath, FileOverlay
end

local function DirExists(dir)
    local _,err = loadfile(dir)
    return (err and string.find(err,"Permission denied"))
end

function WoWMap.GetCustomTextures(map_data)

    local Path = "Interface/Addons/WoWMap/worldmaps/"..WoWMap.Data.Language.."/"..map_data.dir.."/"

    if not DirExists(Path) then
        Path = "Interface/Addons/WoWMap/worldmaps/eneu/"..map_data.dir.."/"
    end

    local OverlayFile
--~     if map_data.overlay then
--~         local use_lang = lang
--~         if not string.find(map_data.overlay, lang) then
--~             use_lang="eneu"
--~         end
--~         OverlayFile = base_path .. use_lang ..".dds"
--~     end

    return Path, OverlayFile
end

function WoWMap.IsCustomMap(MAP_ID)
    return WoWMap.GetCustomMapData(MAP_ID)~=nil
end

function WoWMap.GetCustomMapData(MAP_ID)
    return WoWMap.MapData.CustomMaps.maps[MAP_ID]
end

function WoWMap.GetCurrentMapID()
    return WorldMapFrame.WoWMapID or WorldMapFrame.mapID or 100
end

function WoWMap.UpdateWarning(ID, FilePath)
    local zoneeng =  "unkown"
    local zonelocal = "unkown"
    if ID then
        local res1 = GetZoneEnglishName(ID)
        local res2 = WoWMap.GetZoneNameLocal(ID)
        zoneeng = tostring(res1)
        zonelocal = tostring(res2)
    end

    FilePath = string.gsub(tostring(FilePath),"\\","/")
	local Info = string.format(
[[|cffffooooDebug Info: Please submit this as a bug with a screenshot|r

Version: %s (%s)
Game Version: %s /%s/%s
Zone: %s/%s
Path: %s
Base: %s]],
    WoWMap.Data.Version,tostring(WoWMap.MapData.Instances),
    GetVersion(),GetLocation(),GetLanguage(),
    ID,zonelocal,
    zoneeng,FilePath)

	WoWMapDebugInfo:SetText(Info)
end

--------------------------------
function WoWMap.IsPointInRect(x,y,rect)
    return x>=rect[1] and x<=rect[3] and y>=rect[2] and y<=rect[4]
end

function WoWMap.Split(str, delim, maxNb)
    -- based on src: http://lua-users.org/wiki/SplitJoin
    if not delim or string.find(str, delim) == nil then
        return { str }
    end
    maxNb = maxNb or 0
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function WoWMap.ReplaceTextTags(desc)
    -- src: based on DailyNotes
    local catcher=20
    while catcher>0 do
        catcher=catcher-1
        local ls,le = desc:find("%[.-%]")
        if not ls then break end

        local newtext= string.match(desc:sub(ls+1,le-1), "^([^|]+)")

        if newtext:find("^<[sS]>") then
            newtext = "|cffb0b0b0"..TEXT("Sys"..string.sub(newtext,4).."_name_plural").."|r"
        elseif tonumber(newtext) then
            newtext = "|cffb0b0b0"..TEXT("Sys"..newtext.."_name").."|r"
        else
            newtext = "|cffb0b0b0"..TEXT(newtext).."|r"
        end

        desc = desc:sub(1,ls-1)..newtext..desc:sub(le+1)
    end

    desc = desc:gsub("</?CP>","")
    return desc
end

--------------------------------
function WoWMap.Hooks()
	WoWMap.OnClick_orig = WorldMapFrame_OnClick
    WorldMapFrame_OnClick = WoWMap.OnClick
end

function WoWMap.OnClick(this, key)

    if WoWMap.Data.CurrentIcon then
        local poi = WoWMap.Data.CurrentIcon.POI
        res = poi:MouseClick(WoWMap.Data.CurrentIcon)
        if res then return end
    end

    if WoWMap.isContextMenuClick() then
        WoWMap.OnClick_orig(this, key)
    else

        if key == "RBUTTON" then
            local zoomout_zone = WoWMap.MapData.ZoomOutTable[WoWMap.GetCurrentMapID()]
            WorldMapFrame_SetWorldMapID(zoomout_zone or 9998)
        end
        if key == "LBUTTON" then
            if WoWMap.Data.ZoneID then
                WorldMapFrame_SetWorldMapID(WoWMap.Data.ZoneID)
            end
        end
    end
end

function WoWMap.isContextMenuClick()
  if WoWMapSettings.UseShiftModifier then
    return not IsShiftKeyDown()
  else
    return IsShiftKeyDown()
  end
end

function WorldMapFrame_OnUpdate(elapsedTime)

	local width,height = WorldMapViewFrame:GetSize()

    -- since the original function is bugged for over 2years there is no reason to keep hook-chain intact
	local x,y = WoWMap.GetPlayerPos()
	if x >= 0 and x <= 1 and y >= 0 and y <= 1 then
        if WoWMap.IsCustomMap(WoWMap.GetCurrentMapID()) then
		    WoWMapPlayerCursorFrame:ClearAllAnchors()
		    WoWMapPlayerCursorFrame:SetAnchor("CENTER", "TOPLEFT", "WorldMapViewFrame", x*width, y*height)

            -- TODO: need alternative: GetCameraUpVector remove
--~             local cx,cy,cz = GetCameraUpVector()
--~             local rotation = (math.atan2(cx, cz))
            WoWMapPlayerCursorTexture:SetRotate(0)
            WoWMapPlayerCursorFrame:Show()
			WorldMapPlayerPos:Show()
        else
            WoWMapPlayerCursorFrame:Hide()
        end

		msg = UI_WORLDMAP_PLAYER_POS
		msg = string.gsub(msg, "<x>", string.format("%.1f" , x * 100) )
		msg = string.gsub(msg, "<y>", string.format("%.1f" , y * 100))

		WorldMapPlayerPos:SetText(msg)
		WorldMapPlayerPos:Show()
	else
        WoWMapPlayerCursorFrame:Hide()
		WorldMapPlayerPos:Hide()
	end


	x,y = GetCursorPos()
	local _x,_y = WorldMapViewFrame:GetPos()
	local _w,_h = WorldMapViewFrame:GetRealSize()
	local msg

	x = (x - _x) / _w
	y = (y - _y) / _h
	if x >= 0 and x <= 1 and y >= 0 and y <= 1 then
		msg = UI_WORLDMAP_CURSOR_POS
		msg = string.gsub(msg, "<x>", string.format("%.1f" , x * 100))
		msg = string.gsub(msg, "<y>", string.format("%.1f" , y * 100))
		WorldMapCursorPos:SetText( msg )
		WorldMapCursorPos:Show()
	else
		WorldMapCursorPos:Hide()
	end


	local file, scale, posX, posY
	WoWMap.Data.ZoneID, file, scale, posX, posY = WoWMap.EvalCursor(x,y)
    if WoWMap.Data.ZoneID then
		WoWMapHighlightFrame:ClearAllAnchors()
		WoWMapHighlightFrame:SetAnchor("CENTER", "TOPLEFT", "WoWMapFrame", posX*width, posY*height)
		WoWMapHighlight:SetTexture("Interface/AddOns/WoWMap/Images/"..file)
		WoWMapHighlight:SetScale(g_WorldMapConfig.size*scale)
		WoWMapHighlight:Show()

        if file == "icon_dgn" then
			WorldMapPlayerPos:SetText(UI_WORLDMAP_INSTANCE..": "..WoWMap.GetZoneNameLocal(WoWMap.Data.ZoneID))
		else
			WorldMapPlayerPos:SetText(UI_WORLDMAP_ZONE..": "..WoWMap.GetZoneNameLocal(WoWMap.Data.ZoneID))
		end

		WorldMapPlayerPos:Show()
	else
		WoWMapHighlight:Hide()
	end

    WoWMap.CheckPOIMouseHit()
end

local ori_UpdateWorldMapFrameSize = UpdateWorldMapFrameSize
function UpdateWorldMapFrameSize()
    ori_UpdateWorldMapFrameSize()

	WoWMap.Data.Scale = g_WorldMapConfig.size
	WoWMapClientVersionWarning:SetScale(g_WorldMapConfig.size/100)
	local a,b,c,d,e = WorldMapFrame:GetAnchor()
	WorldMapFrame:SetAnchor(a,b,c,d+1,e)

    WoWMap.ShowPOIs()
end

function WoWMap.EvalCursor(x,y)
    local links = WoWMap.MapData.LinkTable[WoWMap.GetCurrentMapID()]

    for _,v in ipairs(links or {}) do
        if WoWMap.IsPointInRect(x,y,v) then
			local posX, posY

			if v[8] and v[9] then
				posX = v[8]
				posY = v[9]
			else
				posX = (v[1]+v[3])/2
				posY = (v[2]+v[4])/2
			end

			return v[5], v[6] or "",  (v[7] or 1.0) /100, posX, posY
		end
	end

    return nil
end


function WoWMap.GetPlayerPos(map_id)
    local map_id = map_id or WoWMap.GetCurrentMapID()
    local data = WoWMap.GetCustomMapData(map_id)

    if data then
        if data.coords_transpose then
            local cur_map = GetCurrentWorldMapID()
            local transpose = data.coords_transpose[cur_map]
            if transpose then

                local x,y = GetPlayerWorldMapPos(cur_map)
                if not x or not y then return -1,-1 end
                x = transpose[1] + x*(transpose[3]-transpose[1])
                y = transpose[2] + y*(transpose[4]-transpose[2])

                return x,y
            end
        end

        return -1,-1
    end

	local x,y = GetPlayerWorldMapPos(map_id)
    return x or -1, y or -1
end

local MINIMAP_SHOWQUEST_HIGHERLVL_QUEST = "High-Level Quest"
local MapIconType_TrustQuest = 53
local MapIconType_HigherLvlQuest = 55
local MapIconType_PublicQuest = 70

local orig_OnShow_MiniMap_OptionMenu = MinimapFrameOptionMenu.showFunction

function MinimapFrameOptionMenu.showFunction( this )

	if( UIDROPDOWNMENU_MENU_VALUE == 3 ) then
		-- TrustQuests
		local info = {}
		info.text 	= UI_WORLDMAP_SHOW_TRUST_QUEST
		info.func 	= OnClick_MiniMap_OptionMenu;
		info.value	= MapIconType_TrustQuest
		info.checked= g_MinimapDate[MapIconType_TrustQuest]
		UIDropDownMenu_AddButton( info, 2 )

		-- HigherLvlQuests
		info = {}
		info.text 	= MINIMAP_SHOWQUEST_HIGHERLVL_QUEST
		info.func 	= OnClick_MiniMap_OptionMenu
		info.value	= MapIconType_HigherLvlQuest
		info.checked= g_MinimapDate[MapIconType_HigherLvlQuest]
		UIDropDownMenu_AddButton( info, 2 )

		-- EventQuests
		info = {}
		info.text 	= Q_GROUPNAME_03
		info.func 	= OnClick_MiniMap_OptionMenu
		info.value	= MapIconType_PublicQuest
		info.checked= g_MinimapDate[MapIconType_PublicQuest]
		UIDropDownMenu_AddButton( info, 2 )
	end
	orig_OnShow_MiniMap_OptionMenu(this)
end

function OnClick_MiniMap_OptionMenu( button )

		if button.checked then
			SetMinimapShowOption( button.value, 0 )
			g_MinimapDate[button.value] = nil
		else
			SetMinimapShowOption( button.value, 1 )
			g_MinimapDate[button.value] = 1
		end

end

--local ori_MinimapFramePlayerPosition_OnUpdate = MinimapFramePlayerPosition_OnUpdate
function MinimapFramePlayerPosition_OnUpdate( elapsedTime )
	local x,y = WoWMap.GetPlayerPos(WoWMap.GetCurrentWorldMapID())
	if  x and y then
		local s = string.format( "(%.1f,%.1f)" , x * 100 , y * 100 )
		MinimapFramePlayerPosition_String:SetText( s )
	else
		MinimapFramePlayerPosition_String:SetText( "" )
	end
end

function WoWMap.WorldMapOptionMenu_Show(this)
	local info = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
		info = {}
		info.text = "WoWMap "..WoWMap.Data.Version.." Options"
		info.isTitle = 1
		info.value = 1
		UIDropDownMenu_AddButton(info, 1)

		info = {}
		info.text = "Use Shift-Key to Zoom"
		info.checked = WoWMapSettings.UseShiftModifier
        info.tooltipText = "Hold Shift-Key to activate the zoom function."
        info.func = function()
                WoWMapSettings.UseShiftModifier = not WoWMapSettings.UseShiftModifier
        end
		UIDropDownMenu_AddButton(info, 1)

		info = {}
		info.text = "Draw all Quest-Icons"
		info.checked = WoWMapSettings.DrawAllQuestPOIs
        info.tooltipText = "use only if you've problems with quest-icons"
        info.func = function()
                WoWMapSettings.DrawAllQuestPOIs = not WoWMapSettings.DrawAllQuestPOIs
                WoWMap.UpdateQuestPOIs()
        end
		UIDropDownMenu_AddButton(info, 1)

    --[===[@debug@
		info = {}
		info.text = "Show NPC ID's"
		info.checked = WoWMapSettings.ShowNpcID
        info.func = function()
                WoWMapSettings.ShowNpcID = not WoWMapSettings.ShowNpcID
        end
		UIDropDownMenu_AddButton(info, 1)
    --@end-debug@]===]
	end
    WoWMap.POI_Options(this)

	WorldMapOptionMenu_Show(this)
end

--[===[@debug@
local ori_GameTooltip_OnUpdate = GameTooltip_OnUpdate
function GameTooltip_OnUpdate(this, elapsedTime)
	if (GameTooltip:IsVisible()) then
        WoWMap.ToolTipUpdate()
		ori_GameTooltip_OnUpdate(this, elapsedTime);
	end
end

local lasttip = nil
function WoWMap.ToolTipUpdate()
    if not WoWMapSettings.ShowNpcID or (not UnitExists("mouseover") or UnitCanAttack("player", "mouseover") or UnitIsPlayer("mouseover")) then
        lasttip = nil
        return
    end

    local targetName = UnitName("mouseover")
    if targetName == lasttip then return end
--    lasttip = targetName

    local cur_map = GetCurrentWorldMapID()
    local count = NpcTrack_SearchNpc( targetName )
    local maxout = 0
    for i=1 , count do
		local npcID, name, mapID, x, z = NpcTrack_GetNpc(i)
        if mapID == cur_map and name==targetName then
            if maxout>5 then maxout=99 break end
            GameTooltip:AddLine("id = "..npcID)
            WoWMap.last_npc = npcID
            maxout = maxout+1
        end
	end

    for i=1 , count do
		local npcID, name, mapID, x, z = NpcTrack_GetNpc(i)
        if mapID ~= cur_map and name==targetName then
            if maxout>5 then maxout=99 break end
            GameTooltip:AddLine("wrong map: id = "..npcID)
            maxout = maxout+1
        end
	end

    if maxout>98 then
        GameTooltip:AddLine("...")
    end

end
--@end-debug@]===]




