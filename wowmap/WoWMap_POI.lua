local WoWMap = _G.WoWMap

--[[
 To add you own map icons call:
    WoWMap.RegisterPOIs(poi_struct)

 The struct has the following format
    poi_struct= {
        name= "my name",         -- name in menu
        category = "menu_entry", -- (or nil)
        basetip = "text",        -- tool tip (or nil)

        --[=[
            textures="file"
            textures={ "file",x1,y1,x2,y2 } -- with texture coords
            textures={ {"file",x1,y1,x2,y2}, ... } -- multiple textures
            ]=]
        textures={ "interface/minimap/minimapicon.tga", 1/128,0,2/128,1},
        size={16,16},
        priority=0, -- priority=0:lower and may move priority=100: top most and don't move

        maps={
            -- [map_id]={ {x,y},... },
            -- optional: "icon" if you use multiple textures
            -- optional: "tip" = the tooltip
            -- optional: "npc" = a npc ID - it's name will be added to the tooltip
            [1]={ {x=0.528,y=0.422, icon=1, tip="tooltip text", npc=id} },
            },

        npcs={
            ...
            },
        }
]]

-----POI_CLASS---------------------
local POI_CLASS={
    name=nil,
    description=nil,
    iconnr=1,
    maps={},
    textures = {},
    size_x=16,
    size_y=16,
    priority=0,
    default_active=true,
}
POI_CLASS.__index = POI_CLASS

function POI_CLASS.New(name,desc)
    local newpoi={}
    setmetatable(newpoi,POI_CLASS)
    newpoi.name = name
    newpoi.description = desc
    newpoi.textures = {}
    return newpoi
end

function POI_CLASS:AddTexture(filename ,x1,y1,x2,y2)
    self:SetTexture((#self.textures)+1, filename ,x1,y1,x2,y2)
end

function POI_CLASS:SetTexture(index, filename ,x1,y1,x2,y2)
    assert(index<=(#self.textures)+1,"invalid texture index")
    self.textures[index]={filename ,x1,y1,x2,y2}
end

function POI_CLASS:GetTextureData(index)
    index = 1+ ( (index-1) % (#self.textures))
    local texture = self.textures[index]

    if not texture then
        texture = {"interface/minimap/minimapicon.tga",526/2048,1,0,543/2048,0}
    end

    return texture
end

function POI_CLASS:IsActive()
    local setting_stored = self.name and WoWMapSettings.POIs and WoWMapSettings.POIs[self.name]~=nil
    if setting_stored then
        return WoWMapSettings.POIs[self.name]
    else
        return self.default_active
    end
end

function POI_CLASS:SetActive(active)
    if self.name then
        assert(active==true or active==false)

        WoWMapSettings.POIs = WoWMapSettings.POIs or {}
        if (active == self.default_active) then
            WoWMapSettings.POIs[self.name] = nil
        else
            WoWMapSettings.POIs[self.name] = active
        end
    end
end


function POI_CLASS:MouseEnter(icon)
    if icon.data then

        local lines={}

        if icon.data.tip then
            icon.data.tip = WoWMap.ReplaceTextTags(icon.data.tip)
            lines = WoWMap.Split(icon.data.tip, "\n")
        end

        if icon.data.npc then
            local count = NpcTrack_SearchNpcByDBID( icon.data.npc )
            local tooltip
            for i=1,count do
                local _, name, mapID, x, y = NpcTrack_GetNpc(i)
                if mapID == icon.map then
                    tooltip = string.format("%s (%.1f,%.1f)",name or "",x*100,y*100)
                    table.insert(lines,1,tooltip)
                    break
                end
            end

            if not tooltip then
                local name = TEXT("Sys"..icon.data.npc.."_name")
                if name then
                    tooltip = string.format("%s (%.1f,%.1f)",name,icon.data.x*100,icon.data.y*100)
                    table.insert(lines,1,tooltip)
                end
            end
        end

        if self.basetip then
            self.basetip = WoWMap.ReplaceTextTags(self.basetip)
            table.insert(lines,self.basetip)
        end

        if #lines>0 then
            GameTooltip:SetOwner(WorldMapViewFrame, "ANCHOR_BOTTOMRIGHT")
            GameTooltip:ClearAllAnchors()
            GameTooltip:SetAnchor("BOTTOMRIGHT", "BOTTOMRIGHT", WorldMapViewFrame, 0, 0)
            GameTooltip:SetText(lines[1])
            for i = 2,#lines do
                local fields = WoWMap.Split(lines[i], "\t",2)
                if #fields>1 then
                    GameTooltip:AddDoubleLine(fields[1],fields[2])
                else
                    GameTooltip:AddLine(fields[1])
                end
            end

            GameTooltip:Show()
        end
    end
end

function POI_CLASS:MouseLeave(icon)
    GameTooltip:Hide()
end

function POI_CLASS:MouseClick(icon)
end


-----POIs----------------------
WoWMap.Data.IconFrames={}
WoWMap.Data.POIs={}
WoWMap.Data.CurrentIcon = nil

function WoWMap.RegisterPOIs(poi_struct)
    assert(poi_struct)
    local newpoi = POI_CLASS.New(poi_struct.name , poi_struct.description)

    if (poi_struct.textures) then
        WoWMap.ParseTextureStruct(newpoi, poi_struct.textures)
    end

    if type(poi_struct.size)=="table" then
        newpoi.size_x = poi_struct.size[1] or 16
        newpoi.size_y = poi_struct.size[2] or 16
    end

    newpoi.maps = poi_struct.maps or {}
    newpoi.npcs = poi_struct.npcs or {}
    newpoi.basetip = poi_struct.basetip
    newpoi.category = poi_struct.category
    newpoi.MouseClick = poi_struct.MouseClick or POI_CLASS.MouseClick
    newpoi.ShowInParent = poi_struct.ShowInParent
    newpoi.default_active = true
    newpoi.priority = poi_struct.priority or 0
    if poi_struct.default_active==false or poi_struct.default_active==true then
        newpoi.default_active = poi_struct.default_active
    end

    table.insert(WoWMap.Data.POIs, newpoi)
    return newpoi
end

function WoWMap.ParseTextureStruct(poi, textures)

    if type(textures)=="string" then
        poi:AddTexture(textures,0,0,1,1)
        return
    end

    assert(type(textures)=="table", "textures must be string or table")

    if (type(textures[2])=="number") then
        poi:AddTexture(textures[1],textures[2],textures[3],textures[4],textures[5])
        return
    end

    for _,pt in pairs(textures) do
        if type(pt)=="string" then
            poi:AddTexture(pt,0,0,1,1)
        else
            assert(type(pt)=="table","textures must be string or table")
            poi:AddTexture(pt[1],pt[2] or 0,pt[3] or 0,pt[4] or 1,pt[5] or 1)
        end
    end
end

function WoWMap.GetIcon()
    for _,p in ipairs(WoWMap.Data.IconFrames) do
        if not p:IsVisible() then
            return p
        end
    end

    local tempname = "WoWMapnewicon_Texture"..(#WoWMap.Data.IconFrames)
    local newicon = CreateUIComponent("Texture",tempname, "WorldMapViewFrame")
    _G[tempname]=nil

    newicon:SetColor(1.0, 1.0, 1.0)
    newicon:SetAlpha(1.0)
    WorldMapViewFrame:SetLayers(5, newicon)

    table.insert(WoWMap.Data.IconFrames,newicon)
    return newicon
end

function WoWMap.FindIconAt(pos_x,pos_y)
    local res = nil
    for _,icon in ipairs(WoWMap.Data.IconFrames) do
        if icon:IsVisible() then
            local x,y = icon:GetPos()

            if pos_x>=x and pos_y>=y then
                local w,h = icon:GetSize()
                if pos_x<=x+w and pos_y<=y+h then
                    if not res or res.POI.priority < icon.POI.priority then
                        res = icon
                    end
                end
            end
        end
    end

    return res
end

function WoWMap.ShowPOIs(map_id)
    for _,p in ipairs(WoWMap.Data.IconFrames) do
        p:Hide()
    end

    local width,height = WorldMapViewFrame:GetSize()
    local scale = (g_WorldMapConfig.size or 100)/100
    map_id = map_id or WoWMap.GetCurrentMapID()

    for _,poi_cat in ipairs(WoWMap.Data.POIs) do
        if (poi_cat:IsActive()) then

            local size_x = (poi_cat.size_x or 16)*scale
            local size_y = (poi_cat.size_y or 16)*scale

            for _,poi in ipairs(poi_cat.maps[map_id] or {}) do
                if poi.x and poi.y then
                    local icon = WoWMap.GetIcon()
                    icon:SetSize(size_x, size_y)

                    local texture_id = poi.icon or 1
                    local texture = poi_cat:GetTextureData(texture_id)
                    icon:SetTexture(texture[1])
                    icon:SetTexCoord(texture[2] or 0.0, texture[4] or 0.0, texture[3] or 1.0, texture[5] or 1.0)

                    icon:ClearAllAnchors();
                    icon:SetAnchor("CENTER", "TOPLEFT", WorldMapViewFrame, poi.x*width,poi.y*height)
                    icon:Show()

                    icon.POI = poi_cat
                    icon.map = map_id
                    icon.data= poi
                end
            end

            local mapID2= (map_id==358) and 5
            for _,npc_poi in ipairs(poi_cat.npcs) do
                if npc_poi.npc then
                    local count = NpcTrack_SearchNpcByDBID( npc_poi.npc )
                    for i=1,count do
                        local _, _, mapID, x, y = NpcTrack_GetNpc(i)
                        if mapID == map_id or mapID==mapID2 then

                            local icon = WoWMap.GetIcon()
                            icon:SetSize(size_x, size_y)

                            local texture_id = npc_poi.icon or 1
                            local texture = poi_cat:GetTextureData(texture_id)
                            icon:SetTexture(texture[1])
                            icon:SetTexCoord(texture[2] or 0.0, texture[4] or 0.0, texture[3] or 1.0, texture[5] or 1.0)

                            icon:ClearAllAnchors();
                            icon:SetAnchor("CENTER", "TOPLEFT", WorldMapViewFrame, x*width,y*height)
                            icon:Show()

                            icon.POI = poi_cat
                            icon.map = mapID
                            icon.data= npc_poi
                        end
                    end
                end
            end
        end
    end

    WoWMap.ArrangePOIs()
end

function WoWMap.ArrangePOIs()

    if WoWMapSettings.NoArrangIcons then return end


    local icons = WoWMap.Data.IconFrames

    for i=1,10 do
        local nothing_moved = true

        for pin,p in ipairs(icons) do
            if p:IsVisible() then

                local max_priority = math.min(p.POI.priority,99)
                local px,py = p:GetPos()

                for pin2=pin+1,#icons do
                    local p2 = icons[pin2]
                    if p2:IsVisible() and p2.POI.priority<=max_priority then
                        local p2x,p2y = p2:GetPos()
                        local vx = p2x-px
                        local vy = p2y-py
                        local d2 = vx*vx+vy*vy
                        if d2<8*8 then
                           local d2 = math.sqrt(d2)
                           local f = ((8-d2)/2+1)/d2

                           p2x = p2x + vx*f
                           p2y = p2y + vy*f

                           p2:SetPos(p2x,p2y)

                           nothing_moved = false
                        end
                    end
                end
            end
        end

        if nothing_moved then break end
    end
end



function WoWMap.CheckPOIMouseHit()

    local x,y = GetCursorPos()
    local icon = WoWMap.FindIconAt(x,y)

    if WoWMap.Data.CurrentIcon and (icon==nil or WoWMap.Data.CurrentIcon~=icon) then
        local poi = WoWMap.Data.CurrentIcon.POI
        poi:MouseLeave(WoWMap.Data.CurrentIcon)
    end

    WoWMap.Data.CurrentIcon = icon
    if icon then
        local poi = icon.POI
        poi:MouseEnter(icon)
    end
end

function WoWMap.POI_Options(this)

	local info = {}
	if UIDROPDOWNMENU_MENU_LEVEL == 1 then
        local is_in_list={}
        for _,poi_cat in ipairs(WoWMap.Data.POIs) do
            if poi_cat.category then
                if not is_in_list[poi_cat.category] then
                    info = {}
                    info.text = poi_cat.category
                    info.hasArrow = 1
                    info.value = poi_cat.category
                    UIDropDownMenu_AddButton(info, 1)
                    is_in_list[poi_cat.category]=true
                end
            else
                WoWMap.POI_Options_Insert(this,poi_cat,1)
            end
        end

	elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
        for _,poi_cat in ipairs(WoWMap.Data.POIs) do
            if poi_cat.category and poi_cat.category==UIDROPDOWNMENU_MENU_VALUE then
                WoWMap.POI_Options_Insert(this,poi_cat,2)
            end
        end
    end
end

function WoWMap.POI_Options_Insert(this,poi_cat,level)
    if not poi_cat.name then return end

    info = {}
    info.text = poi_cat.name.."     "
    info.tooltipTitle = poi_cat.name
    info.tooltipText = poi_cat.description
    info.checked = poi_cat:IsActive()
    info.keepShownOnClick = true

    info.func = function()
                poi_cat:SetActive( not poi_cat:IsActive() )
                WoWMap.ShowPOIs()
                end
    UIDropDownMenu_AddButton(info, level, poi_cat:GetTextureData( poi_cat.iconnr ))
end

-----Quest---------------
local Quests = {
    name=nil,
    textures={  {"interface/minimap/minimapicon.tga", 424/2048, 0,441/2048,1}, -- new quest
                {"interface/minimap/minimapicon.tga", 441/2048, 0,458/2048,1}, -- finished quest
                {"interface/minimap/minimapicon.tga", 458/2048, 0,475/2048,1}, -- unfinished quest
                {"interface/minimap/minimapicon.tga", 493/2048, 0,509/2048,1}, -- daily quest
                {"interface/minimap/minimapicon.tga", 475/2048, 0,493/2048,1}, -- finished daily quest
                {"interface/minimap/minimapicon.tga", 951/2048, 0,966/2048,1}, -- public quest
                {"interface/minimap/minimapicon.tga", 968/2048, 0,983/2048,1}, -- finished public quest
            },
    size={16,16},
    priority=100,
    maps={}
}

local Quest_POI = WoWMap.RegisterPOIs(Quests)

function Quest_POI:IsActive()
    return g_WorldMapConfig.showQuestNpc
end

function Quest_POI:SetActive(active)
    g_WorldMapConfig.showQuestNpc = active and 1 or nil
end

function WoWMap.UpdateQuestPOIs()
    WoWMap.CollectQuestPOIs()
    WoWMap.ShowPOIs()
end

function WoWMap.CollectQuestPOIs()
    Quest_POI.maps={}

    -- Get from QuestBook
    if (g_WorldMapConfig.showFinishedQuest or g_WorldMapConfig.showUnfinishQuest) then
        local numQuests = GetNumQuestBookButton_QuestBook()
        for i=1, numQuests do
            local _, _, _, _, _, _Daily, _, iQuestType, _, _Finished = GetQuestInfo( i )

            ViewQuest_QuestBook(i)
            local _npcID = QuestDetail_GetRequestQuestNPC()
            if _npcID then
                count = NpcTrack_SearchNpcByDBID( _npcID )
                if (count >0) then
                    local _, name, mapID, _x, _y = NpcTrack_GetNpc(1)
                    --[===[@debug@
                    mapID=DEBUG_FORCE_QUEST_MAP or mapID
                    --@end-debug@]===]

                    if _Finished then
                        if g_WorldMapConfig.showFinishedQuest then
                            WoWMap.InsertQuestNPC(_npcID,mapID,_x,_y, _Daily and 5 or 2)
                        end
                    else
                        if g_WorldMapConfig.showUnfinishQuest then
                            WoWMap.InsertQuestNPC(_npcID,mapID,_x,_y,3)
                        end
                    end
                end
            end
        end
    end

    -- Get from WorldSearch (Note: it's limited to 100 entries!)
    if (g_WorldMapConfig.showNewQuest or g_WorldMapConfig.showTrustQuest) then
        local bIgnoreLV = not g_WorldMapConfig.hideLowQuest
        local count = NpcTrack_SearchQuestNpc( bIgnoreLV , false )
        for i=1 , count do
            local npcID, name, mapID, _x, _y = NpcTrack_GetNpc(i)
            --[===[@debug@
            mapID=DEBUG_FORCE_QUEST_MAP or mapID
            --@end-debug@]===]

            local is_daily = WoWMap.IsNPCDailyQuestGiver(npcID)
            if is_daily then
                if g_WorldMapConfig.showTrustQuest then
                    if is_daily==2 then
                        WoWMap.InsertQuestNPC(npcID,mapID,_x,_y,6)
                    else
                        WoWMap.InsertQuestNPC(npcID,mapID,_x,_y,4)
                    end
                end
            else
                if g_WorldMapConfig.showNewQuest then
                    WoWMap.InsertQuestNPC(npcID,mapID,_x,_y)
                end
            end
        end
    end
end

function WoWMap.InsertQuestNPC(npcid, map,x,y,iconid)
    for thismap,data in pairs(WoWMap.MapData.CustomMaps.maps) do
        local transpose = data.coords_transpose and data.coords_transpose[map]
        if transpose then
            local _x= transpose[1] + x*(transpose[3]-transpose[1])
            local _y= transpose[2] + y*(transpose[4]-transpose[2])

            -- WoWMap.InsertQuestNPC(npcid, thismap,_x,_y,iconid) -- to display in parent zone too

            if _x>=0 and _x<=1 and _y>=0 and _y<=1 then
                Quest_POI.maps[thismap] = Quest_POI.maps[thismap] or {}
                table.insert(Quest_POI.maps[thismap], {x=_x,y=_y,icon=iconid,npc=npcid})
            end
        end
    end

    if WoWMapSettings.DrawAllQuestPOIs or WoWMap.IsMapDisabled then
        Quest_POI.maps[map] = Quest_POI.maps[map] or {}
        table.insert(Quest_POI.maps[map], {x=x,y=y,icon=iconid,npc=npcid})
    end
end

local ori_WorldMapOptionMenu_Click = WorldMapOptionMenu_Click
function WorldMapOptionMenu_Click( button )
    ori_WorldMapOptionMenu_Click(button)
    if( button.arg1 == "SHOWQUESTNPC"  or button.arg1 == "HIDELOWQUEST" or
        button.arg1 == "showFinishedQuest" or button.arg1 == "showUnfinishQuest" or
        button.arg1 == "showNewQuest" or button.arg1 == "showTrustQuest"
         ) then
        WoWMap.UpdateQuestPOIs()
    end
end

local ori_UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
function UIDropDownMenu_AddButton(info, level, texture)

    ori_UIDropDownMenu_AddButton(info, level)

    if (info.markNumber or texture) then
        level = level or 1

    	local listFrame = _G["DropDownList"..level]
    	local index = listFrame.numButtons
    	local button = _G[listFrame:GetName().."Button"..index]
		local markTexture = _G[button:GetName().."MarkTexture"]

	    if ( index > UIDROPDOWNMENU_MAXBUTTONS or level > UIDROPDOWNMENU_MAXLEVELS) then
		    return
	    end

        if ( info.markNumber ) then
            markTexture:SetTexture("interface/Common/RaidTarget")
        else

            if type(texture)=="table" then
                markTexture:SetTexture(texture[1])
                markTexture:SetTexCoord(texture[2] or 0.0, texture[4] or 0.0, texture[3] or 1.0, texture[5] or 1.0)
                markTexture:Show()
            else
                markTexture:Hide()
            end
        end
    end

end
