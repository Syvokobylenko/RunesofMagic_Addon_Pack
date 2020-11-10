------------------------------------------------------
-- QuestHelper
--
-- file: ui_map
-- desc: world map interface
--      * WorldMap display
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2015-09-18T8:24:56Z
------------------------------------------------------

local CPColor = LibStub("CPColor")

local UI_map = {}
_G.QH.UI_map = UI_map

local MAX_SUB_ICONS = 32

-----------------------------------
-- Hook WorldMap display functions
UI_map.ori_WorldMapFrame_OnShow = WorldMapFrame_OnShow
UI_map.ori_WorldMapFrame_OnHide = WorldMapFrame_OnHide
UI_map.ori_WorldMapFrame_SetWorldMapID = WorldMapFrame_SetWorldMapID

local ORI_WorldMapOptionMenu_Click = WorldMapOptionMenu_Click
ORI_SEARCH_QUEST_NPC = ORI_SEARCH_QUEST_NPC or WorldMap_SearchQuestNpc

function WorldMapOptionMenu_Click(button)
	ORI_WorldMapOptionMenu_Click(button)
	if( button.arg1 == "showFinishedQuest"  or button.arg1 == "SHOWQUESTNPC" ) then
		UI_map.ShowMapIcons()
	end
end

function WorldMap_SearchQuestNpc( hideLowQuest, showFinishedQuest, showNewQuest, showTrustQuest, showUnfinishQuest )
	ORI_SEARCH_QUEST_NPC( hideLowQuest, false, showNewQuest, showTrustQuest, showUnfinishQuest )
	UI_map.ShowMapIcons()
end


function WorldMapFrame_SetWorldMapID(_MapID)
    UI_map.ori_WorldMapFrame_SetWorldMapID(_MapID)
    if WorldMapFrame:IsVisible() then
        UI_map.ShowMapIcons()
    end
end

function WorldMapFrame_OnShow(this)
    WorldMapPlayerCursorFrame:SetFrameLevel(10)
    UI_map.ori_WorldMapFrame_OnShow(this)
    UI_map.ShowMapIcons()
end

function WorldMapFrame_OnHide(this)
    UI_map.ori_WorldMapFrame_OnHide(this)
    UI_map.hilit_QID = nil
    UI_map.hilit_GID = nil
end

-----------------------------------
local ICON_END_NPC = -DF_IconType_FinishedQuest
local ICON_END_NPC_PUBLIC = -71
local ICON_END_NPC_DAILY = -DF_IconType_RepeatQuestDone
local ICON_MAIN_GOAL = 1
local ICON_SUB_GOAL = 2
local ICON_UNKNOWN_NPC = 3
local ICON_UNKNOWN_GOAL = 4

local icon_textures= {
    [ICON_MAIN_GOAL]= {file="Interface/gameicon/gameicon", scale=0.9, top=0.125, left=0.875, right=1, bottom=0.25},
    [ICON_SUB_GOAL] = {file="Interface/gameicon/gameicon", scale=0.7, top=0.125, left=0.750, right=0.875, bottom=0.25},
    [ICON_UNKNOWN_NPC] = {file="Interface/addons/questhelper/textures/map2", scale=1, top=0, left=0.5, right=1, bottom=1},
    [ICON_UNKNOWN_GOAL]= {file="Interface/addons/questhelper/textures/map2", scale=0.9, top=0, left=0, right=0.5, bottom=1},
}

local iconframes={}
local function GetIcon()
    for _,p in ipairs(iconframes) do
        if not p:IsVisible() then
            return p
        end
    end

    local tempname = "QH_Texture"..(#iconframes)
    local tempname2= tempname.."icon"
    local icon = CreateUIComponent("Frame",tempname, "WorldMapViewFrame")
    icon:SetSize(13, 13)

    icon.mtexture = CreateUIComponent("Texture",tempname2, tempname)
    icon.mtexture:SetSize(13, 13)
    icon.mtexture:SetColor(1.0, 1.0, 1.0)
    icon.mtexture:SetAlpha(1.0)
    icon.mtexture:ClearAllAnchors()
    icon.mtexture:SetAnchor("CENTER", "CENTER", icon, 0, 0)
    icon:SetLayers(1, icon.mtexture)

    icon:SetMouseEnable(true)
    icon:SetScripts("OnEnter","QH.UI_map.OnEnter(this)")
    icon:SetScripts("OnLeave","QH.UI_map.OnLeave(this)")
    icon:RegisterForClicks("LeftButton", "RightButton")
    icon:SetScripts("OnClick","QH.UI_map.OnClick(this, key)")

    _G[tempname]=nil
    _G[tempname2]=nil

    table.insert(iconframes,icon)
    return icon
end

local function ShowIcon(x,y,icon_id)

    local icon = GetIcon()

    local width = WorldMapViewFrame:GetWidth()
    local height = WorldMapViewFrame:GetHeight()
    icon:ClearAllAnchors()
    icon:SetAnchor("CENTER", "TOPLEFT", WorldMapViewFrame, x*width, y*height)

    icon:SetFrameLevel(2)

    if icon_id<0 then
        Common_SetIconTexture(icon.mtexture,-icon_id)
        icon.mtexture:SetScale(1)
    else
        local tx = icon_textures[icon_id] or icon_textures[ICON_UNKNOWN_GOAL]
        icon.mtexture:SetFile(tx.file)
        icon.mtexture:SetTexCoord(tx.left,tx.right,tx.top,tx.bottom)
        icon.mtexture:SetScale(tx.scale)
    end

    icon:Show()
    return icon
end

local function HideAllIcons()
    for _,p in ipairs(iconframes) do
        if p:IsVisible() then
           p:Hide()
        end
    end
end

--------------------------------------------------
local base_layer=nil
local base_layer_icons={}
local layer_color=0
local function CreateBaseLayer()
    assert(not base_layer)
    local tempname = "QHMapBaseLayer"
    base_layer = CreateUIComponent("Frame",tempname, "WorldMapViewFrame")
    base_layer:ClearAllAnchors()
    base_layer:SetAnchor("TOPLEFT", "TOPLEFT", WorldMapViewFrame, 0, 0)
    base_layer:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", WorldMapViewFrame, 0, 0)
    base_layer:SetAlpha(0.7)
    base_layer:SetFrameLevel(1000)
    --_G[tempname]=nil
end

local function GetLayerIcon()
    if not base_layer then
        CreateBaseLayer()
    end

    for _,p in ipairs(base_layer_icons) do
        if not p:IsVisible() then
            return p
        end
    end

    local tempname = "QHMapLayerIcon"..(#base_layer_icons)
    local tempname2= tempname.."Texture"
    local icon = CreateUIComponent("Frame",tempname, "QHMapBaseLayer")
    icon:SetSize(64, 64)
    icon:SetAlpha(1.0)

    icon.mtexture = CreateUIComponent("Texture",tempname2, tempname)
    icon.mtexture:SetSize(64, 64)
    icon.mtexture:SetColor(1.0, 0.2, 0.2)
    icon.mtexture:SetAlpha(1.0)
    icon.mtexture:ClearAllAnchors()
    icon.mtexture:SetAnchor("CENTER", "CENTER", icon, 0, 0)
    icon.mtexture:SetFile("interface/common/round64x64")
    --icon.mtexture:SetFile("interface/addons/questhelper/textures/circle")
    icon:SetLayers(1, icon.mtexture)

    icon:SetMouseEnable(true)
    icon:SetScripts("OnEnter","QH.UI_map.OnEnter(this)")
    icon:SetScripts("OnLeave","QH.UI_map.OnLeave(this)")

    icon:Hide()

    _G[tempname]=nil
    _G[tempname2]=nil

    table.insert(base_layer_icons,icon)
    return icon
end

local function ShowLayerIcon(x,y,diameter,col)

    local icon = GetLayerIcon()

    local width = base_layer:GetWidth()
    local height = base_layer:GetHeight()
    icon:ClearAllAnchors()
    icon:SetAnchor("CENTER", "TOPLEFT", base_layer, x*width, y*height)
    --icon.mtexture:SetScale(scale*width/30)
    icon:SetSize(diameter*width, diameter*height)
    icon.mtexture:SetSize(diameter*width, diameter*height)
    if col then
        icon.mtexture:SetColor(col:Get())
    end

    -- calc intersections
    local alpha = 1-diameter/2
    for _,p in ipairs(base_layer_icons) do
        if p:IsVisible() then

            local px,py = p:GetAnchorOffset()
            local ps,_ = p:GetSize()

            local a,b,c=px-x*width ,py-y*height, (ps+diameter*width)/2
            local d2 = a*a+b*b
            local overlap= (c-math.sqrt(d2))/(diameter*width)
            if overlap>0 then
                if overlap>1 then overlap=1 end
                local proportion = diameter*width/ps

                alpha = alpha -0.15*overlap*proportion
                if alpha < 0.2 then
                    alpha = 0.2
                    break
                end
            end
        end
    end

    icon.mtexture:SetAlpha(alpha)

    icon:Show()
    base_layer:Show()
    return icon
end

local function HideAllLayerIcons()
    layer_color=0
    for _,p in ipairs(base_layer_icons) do
        if p:IsVisible() then
           p:Hide()
        end
    end

    if base_layer then
        base_layer:Hide()
    end
end

local function ShowLayerGoals(QID, GID)
    local positions = QH.DB.GetPosition(GID, UI_map.GetMapID())
    if not positions then return end

    local col = CPColor.New()
    col:FromHSV((359-layer_color*6)%360, 1-(layer_color%4)/6, 1-(layer_color%3)/6)
    layer_color=layer_color+1

    for i=#positions,1,-1 do
    --for _,pos in pairs(optimized_pos) do
        local pos = positions[i]
        local icon = ShowLayerIcon(pos[1],pos[2],pos[3] or 0.0075,col)
        icon.QID = QID
        icon.GID = GID
    end
end

-----------------------------------
local function ShowNearestGoals(QID, GID)

    local pmap,px,py = QH.Map.GetPlayerPos()
    local map = UI_map.GetMapID()
    if not px or not py or pmap~=map then
        px = 0.5
        py = 0.5
    end

    local x,y, guess = UI_map.GetNearestMapPos(QID,GID,map,px,py)
    if x then
        local i = (guess) and ICON_UNKNOWN_GOAL or ICON_MAIN_GOAL
        local icon = ShowIcon(x,y,i)
        icon.QID = QID
        icon.GID = GID
    end
end

local function ShowRewardNPC(QID)

	if (not g_WorldMapConfig.showQuestNpc) or (not g_WorldMapConfig.showFinishedQuest) then
		return
	end

    local id,name,npc_mapID,x,y = QH.QDB.GetRewardNPCPos(QID)

    x,y = UI_map.TransformPosForMap(UI_map.GetMapID(), x,y, npc_mapID)
    if x then

        local icon = ICON_END_NPC
        if id then
            if QH.QB.IsPublic(QID) then icon = ICON_END_NPC_PUBLIC
            elseif QH.QB.IsDaily(QID) then icon = ICON_END_NPC_DAILY
            end
        else
            icon = ICON_UNKNOWN_NPC
        end

        local icon = ShowIcon(x,y,icon)
        icon.QID = QID
        icon.GID = nil
    end

end

local function ShowActiveQuests()
    QH.QB.ForEachGoal(
        function (QID,GID)

            if GID then
                ShowNearestGoals(QID, GID)

                if QH_Options.map_all_points then
                    ShowLayerGoals(QID,GID)
                end
            else
                ShowRewardNPC(QID)
            end

        end
    )
end

local function ShowQuest(QID,GID)

    if GID then
        ShowLayerGoals(QID,GID)
    else
        local all_gids = DB.GetGoals(QID)
        for _,GID in ipairs(all_gids) do
            ShowLayerGoals(QID,GID)
        end
    end

    ShowRewardNPC(QID)
end

-----------------------------------
--Show tooltip when mouse hovers over an icon
function UI_map.OnEnter(this)

    local QID = this.QID
    local GID = this.GID

    if not QID then return end

    if not QH_Options.map_all_points then

        if GID and GID~=UI_map.hilit_GID then
            ShowLayerGoals(QID,GID,true)
        end
    end

    if QH.QB.IsIn(QID,GID) and QH_Options.map_full_info then
        GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
        QH.QB.ShowToolTip(QID)
        return
    end

    if not GID then
        -- REWARD NPC INFO
        GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
        GameTooltip:SetText(QH.QB.GetQuestTitle(QID),1,1,1)

        local _,npcname,_,x,y = QH.QDB.GetRewardNPCPos(QID)
        GameTooltip:AddLine(string.format("%s (%2.1f, %2.1f)",tostring(npcname), (x or 0)*100,(y or 0)*100))
        GameTooltip:Show()

    else
        -- GOAL INFO
        GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
        GameTooltip:SetText(QH.QB.GetQuestTitle(QID) ,1,1,1)

        if QH.QB.IsIn(QID,GID) then
            local gtext =  QH.QB.GetGoalText(QID, GID)
            GameTooltip:AddLine(gtext)
        else
            local text = TEXT("Sys"..GID.."_name")
            GameTooltip:AddLine(text)
        end

        GameTooltip:Show()
    end

end

function UI_map.OnLeave()
    GameTooltip:Hide()
    if not QH_Options.map_all_points and not UI_map.hilit_QID then
        HideAllLayerIcons()
    end
end

function UI_map.OnClick(this,key)
    local QID = this.QID
    local GID = this.GID

    local npcid,name = QH.QB.GetRewardNPC(QID)
    if not GID and npcid then
        --  RoM uses spezial globales for comunication
        NpcID = npcid  -- in event
        NpcName = name -- in menu
        WorldMapFrame_OnEvent(WorldMapViewFrame,"WORLDMAP_ICONCLICK")
    else
        WorldMapFrame_OnClick( this , key )
    end
end

-----------------------------------
function UI_map.GetMapID()
    if WorldMapFrame.mapID==358 then return 5 end -- Ystra clone
    return WorldMapFrame.mapID
end

function UI_map.ShowMapIcons()
    HideAllIcons()
    HideAllLayerIcons()
    if UI_map.hilit_QID then
        ShowQuest(UI_map.hilit_QID, UI_map.hilit_GID)
    else
        ShowActiveQuests()
    end


end

-------------------------------------------------------
-- find nearest position
function UI_map.GetNearestMapPos(QID,GID,MAP,px,py)

    local maps = QH.DB.GetMaps(GID)
    if not maps then return end

    -- find nearest
    local distance = 400000
    local found_entry=nil
    local no_data = true

    for map_id,mdata in pairs(maps) do
        if map_id ~= 0 then
            no_data = false
            for _,pos in ipairs(mdata) do
                local x,y = UI_map.TransformPosForMap( MAP, pos[1], pos[2], map_id)
                if x then
                    local new_dist = (px-x)*(px-x) + (py-y)*(py-y)
                    if new_dist < distance then
                        distance    = new_dist
                        found_entry = {x,y}
                    end
                end
            end
        end
    end

    if found_entry then
        return found_entry[1],found_entry[2]
    end

    if no_data then
        local m,_x,_y = QH.QB.GetCatalogPos(QID)
        local x,y = UI_map.TransformPosForMap( MAP, _x, _y, m)
        if x then
            return x,y,true
        end
    end
end

-----------------------------------
--returns relative width and height and origin of an area on its parent map
function UI_map.TransformPosForMap(target_map, x,y, cur_map)
    if not x or not y then return end

    if target_map == cur_map then
        if x<0 then x=0 elseif x>1 then x=1 end
        if y<0 then y=0 elseif y>1 then y=1 end
        return x,y
    end

    local parent = QH.Map.GetParentMap(cur_map)
    if not parent then return end

    local cluster = QH.Map.GetChildPos(parent,cur_map)

    local relWidth = cluster.right  - cluster.left
    local relHeight= cluster.bottom - cluster.top
    x = cluster.left + relWidth*x
    y = cluster.top + relHeight*y

    return UI_map.TransformPosForMap(target_map, x,y, parent)
end

function UI_map.HighlightQuest(QID,GID)

    UI_map.hilit_QID = QID
    UI_map.hilit_GID = GID

    if WorldMapFrame:IsVisible() then
        UI_map.ShowMapIcons()
    end
end

