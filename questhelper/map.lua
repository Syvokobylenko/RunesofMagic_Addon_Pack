-------------------------------------------------------
-- QuestHelper
--
-- file: MAP
-- desc: map coordinates
--      * General world/map informations
--      * Parent/Child map relations for dungeons or subzones
--      * Teleporter position & connections
--      * Distance & Path calculation
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2014-09-16T3:38:49Z
-------------------------------------------------------
local Nyx = LibStub("Nyx")

local Map = {}
_G.QH.Map=Map

local MapData=nil
local TOO_FAR_AWAY=20000000
--[[ [ Data index -  const ]]
local L_SRC_PORTER = 1
local L_DST_MAP = 2
local L_DST_PORTER = 3
local L_TYPE = 4
local L_COSTS = 5
local L_NAME = 6
local L_SRC_MAP = 7 -- filled by prg

local P_POS_X = 1
local P_POS_Y = 2
local P_FLAG = 3
local P_NAME = 4
local P_DISTANCE = 5
local P_PREV_LINK = 6
local P_LINK_COUNT = 7
local P_DISTANCE_TO_PORTERS = 8
--[[ ] ]]

function Map.Init()
    MapData = Nyx.LoadFile("Interface/Addons/QuestHelper/data/mapcoords.lua")

    Map.BuildPorterGraph()
end

-------------------------------------------------------
local function GetPorter(map, id)
    --[===[@debug@
        assert(map)
        assert(MapData[map],"map="..map)
        assert(MapData[map] and MapData[map].porter)
    --@end-debug@]===]
    return MapData[map].porter[id]
end

local function GetPorterSrc(link)
    return GetPorter(link[L_SRC_MAP], link[L_SRC_PORTER] )
end

local function GetPorterDst(link)
    return GetPorter(link[L_DST_MAP], link[L_DST_PORTER] )
end

-------------------------------------------------------
local function ReplaceTags(desc)
    local max_loops=20
    local ls,le=1,0
    repeat
        ls,le = desc:find("%[.-%]",ls)
        if not ls then break end

        local newtext= string.match(desc:sub(ls+1,le-1), "^([^|]+)")

        if newtext:find("^<[sS]>") then
            newtext = TEXT("Sys"..string.sub(newtext,4).."_plural")
        elseif tonumber(newtext) then
            newtext = TEXT("Sys"..newtext.."_name")
        else
            newtext = TEXT(newtext)
        end

        desc = desc:sub(1,ls-1)..newtext..desc:sub(le+1)
        ls = ls + newtext:len()

        max_loops=max_loops-1
    until max_loops<0

    return desc
end

local function GetLinkText(link)

    local res={}
    if link[L_SRC_MAP]~=link[L_DST_MAP] then
        table.insert(res,TEXT("SC_TRANSTO")..GetZoneLocalName(link[L_DST_MAP]))
        local t2 = string.gsub(TEXT("SC_TRANSFER_OPTION_MEG"),"%[%$VAR1%]",GetZoneLocalName(link[L_DST_MAP]))
        table.insert(res,t2)
    end

    if link[L_NAME]~=0 then
        table.insert(res,ReplaceTags(TEXT(link[L_NAME])))
    else
        local ptext = GetPorterDst(link)[P_NAME]
        if ptext~=0 then
            table.insert(res,ReplaceTags(TEXT(ptext)))
        end
    end

    return res
end

local function GetLinkInfo(link)

    local porter_text = GetLinkText(link)

    local explain_text
    local ltype = link[L_TYPE]
    if ltype==0 then
        local tmap = GetZoneLocalName(link[L_DST_MAP]) or QH.L.Name_Error
        explain_text=string.format(QH.L.Path_GoTo ,tmap)
    elseif ltype==1 then
        local tmap = GetZoneLocalName(link[L_DST_MAP]) or QH.L.Name_Error
        explain_text=string.format(QH.L.Path_Porter ,tmap, link[L_COSTS])
    elseif ltype==2 then
        explain_text=string.format(QH.L.Path_PorterInCity, porter_text[0] or QH.L.Name_Error)
    elseif ltype==3 then
        local dest = GetPorterDst(link)
        local p = string.format("%g/%g" ,dest[P_POS_X]*100,dest[P_POS_Y]*100)
        local tmap = GetZoneLocalName(link[L_DST_MAP]) or QH.L.Name_Error
        explain_text=string.format(QH.L.Path_GoTo ,tmap)
    end

    local porter = GetPorterSrc(link)
    return porter[P_POS_X],porter[P_POS_Y],explain_text,porter_text
end

-------------------------------------------------------
-- Test map data (connections)
local function TestParentChildRelation()
    for map_id, m_data in pairs(MapData) do
        if m_data.parent and (not MapData[m_data.parent] or not MapData[m_data.parent].childs[map_id]) then
            QH.API.DebugErr("child not defined in Map: "..m_data.parent.." SubZone:"..map_id..")")
        end

        if map_id < 9900 then
            for sub_id,_ in pairs(m_data.childs or {}) do
                if MapData[sub_id].parent ~= map_id then
                    if sub_id~=10001 and map_id~=10 then --obsidian: scalia & dust-devil
                        QH.API.DebugErr("child has wrong parent Map: "..sub_id.." should be:"..map_id..")")
                    end
                end
            end
        end
    end
end

local function TestSubZones()
    local zone_def = {}
    for map_id, m_data in pairs(MapData) do
        if not m_data.zones then
            QH.API.DebugErr("map has no zone data: "..map_id)
            m_data.zones={}
        end
        for zone_id,_ in pairs(m_data.zones) do
            if zone_def[zone_id] then
                QH.API.DebugErr("zone "..zone_id.." defined in "..map_id.." and in "..zone_def[zone_id])
            end
            zone_def[zone_id] = map_id

            local n = GetQuestCatalogInfo(zone_id)
            if not n or n=="" then
                QH.API.DebugErr("zone has no valid name: "..zone_id)
            end
        end
    end
end

local function TestLinkData()
    for map_id, mdata in pairs(MapData) do
        for i, link in ipairs(mdata.link or {}) do
            if not mdata.porter or not mdata.porter[link[L_SRC_PORTER]] then
                QH.API.DebugErr("unkown porter (map:"..map_id.." p:"..link[L_SRC_PORTER]..")")
            end

            if not GetPorterDst(link) then
                QH.API.DebugErr("unkown target porter (map:"..map_id.." target map:"..link[L_DST_MAP].."/"..link[L_DST_PORTER]..")")
            end

            if link[L_NAME] and ReplaceTags(TEXT(link[L_NAME]))==link[L_NAME] then
                QH.API.DebugErr("unkown link text map:"..map_id.." text="..link[L_NAME].."="..ReplaceTags(TEXT(link[L_NAME])).." (target map:"..link[L_DST_MAP].."/"..link[L_DST_PORTER]..")")
            end

            if link[L_TYPE]==2 and #GetLinkText(link)==0 then
                QH.API.DebugErr("in-city-porter has no text (map:"..map_id.." target map:"..link[L_DST_MAP].."/"..link[L_DST_PORTER]..")")
            end
        end
    end
end

local function TestPorterData()
    for map_id, mdata in pairs(MapData) do
        for i, porter in ipairs(mdata.porter or {}) do

            if porter[P_NAME] and ReplaceTags(TEXT(porter[P_NAME]))==porter[P_NAME] then
                QH.API.DebugErr("unkown link text map:"..map_id.." text="..porter[P_NAME].."="..ReplaceTags(TEXT(porter[P_NAME])).." (porter:"..i..")")
            end

        end
    end
end

local function TestPorterConnections()
    local function FindLinkForPorter(link_list, porterid)
        for _,v in pairs(link_list or {}) do
            if v[L_SRC_PORTER]==porterid then return true end
        end
    end

    local function FindLink(link_list, map,porter)
        for _,v in pairs(link_list or {}) do
            if v[L_DST_MAP]==map and v[L_DST_PORTER]==porter then return true end
        end
    end

    local function IsOneWay(from_map, link)
        local specials =
        { {5,7,202,1}, {5,7,203,1}, {5,7,204,1}, {5,7,205,1}, {5,7,206,1}, {5,7,207,1}, -- Ystra Lab walk-in
          {207,3,206,1}, {206,3,207,1},
        }
        for _,v in pairs(specials) do
            if v[1]==from_map and v[2]==link[1] and v[3]==link[2] and v[4]==link[3] then return true end
        end
    end

    for map_id, mdata in pairs(MapData) do
        for i, link in ipairs(mdata.link or {}) do
            if not IsOneWay(map_id,link) and not FindLink(MapData[link[L_DST_MAP]].link, map_id, link[L_SRC_PORTER]) then
            --    QH.API.DebugErr("porter is oneway (map:"..map_id.." target map:"..link[L_DST_MAP].."/"..link[3]..")")
            end
        end

        local porter_count = mdata.porter and #mdata.porter or 0
        for i=1,porter_count do
            if not FindLinkForPorter(mdata.link, i) then
                if (map_id~=10 or i~=2) and (map_id~=10001 or i~=1) and (map_id~=10001 or i~=10)
                   then
                    QH.API.DebugErr("porter doesn't have a link (map:"..map_id.." porter:"..i..")")
                end
            end
        end
    end
end

function Map.Test()
    TestParentChildRelation()
    TestSubZones()
    TestLinkData()
    TestPorterData()
    TestPorterConnections()
end

function Map.IsValidMap(map_id)
    return MapData[map_id]
end

function Map.MakeSureMapExists(mp)
    if not MapData[mp] then
        QH.API.Print("|cffff0000QH: found unknown map: "..tostring(mp).." /"..tostring(raised_by))
        MapData[mp] = {porter={},link={}}
    end
end

-------------------------------------------------------
local missingSubzones = {}
local function SubZoneNotFound(zone_id)

    local mis=missingSubzones[zone_id]
    if mis then
        return mis[1],mis[2],mis[3]
    end

    local str = tostring(GetQuestCatalogInfo(zone_id))

    local mp,px,py = QH.Map.GetPlayerPos()
    if not mp then return end

    QH.API.DebugErr("Unknown zone: " ..zone_id.."/"..str)
    missingSubzones[zone_id] = {mp,px,py}

    return mp,px,py
end

-------------------------------------------------------
-- Get position of a subzone
-- param: subzone id
-- return: map,x,y
function Map.GetSubZonePos(cat_id)
    for map_id,list in pairs(MapData) do
        for cat,v in pairs(list.zones or {}) do
            if cat == cat_id then

                if not v[1] then
                    SubZoneNotFound(cat_id)
                    return map_id,0.5,0.5
                end

                return map_id,v[1],v[2]
            end
        end
    end

    return SubZoneNotFound(cat_id)
end

-------------------------------------------------------
function Map.GetParentMap(map_id)
    return MapData[map_id] and MapData[map_id].parent
end

function Map.IsInZone(zone, parent)
    if zone==parent then return true end

    zone = Map.GetParentMap(zone)
    if zone then
        return Map.IsInZone(zone, parent)
    end
end

function Map.GetChildPos(map_id,child_id)
    local cluster = MapData[map_id].childs[child_id]
    assert(cluster, "QH: no valid cluster defined")
    return cluster
end

----------------------------------
local function AreSpezialPorters(map, p1, p2)
    -- dustdevil canyon: porter 1&2 are not connected to rest
    if p1>p2 then p1,p2=p2,p1 end
    return map==6 and p1<3 and p2>2
end

----------------------------------
-- Build graph
-- Does map precalcualtion:
--   * fills link[L_SRC_MAP]
--   * calulates porter[P_DISTANCE_TO_PORTERS] = {}
function Map.BuildPorterGraph()

    for map,md in pairs(MapData) do

        md.porter = md.porter or {}
        for p_id,d in ipairs(md.porter) do
            -- allocate memory for 'BuildDistances'
            while #d<P_DISTANCE_TO_PORTERS do
                table.insert(d,0)
            end

            -- precalc distances
            d[P_DISTANCE_TO_PORTERS]={}
            for i,dest in ipairs(md.porter) do

                local a= dest[P_POS_X] - d[P_POS_X]
                local b= dest[P_POS_Y] - d[P_POS_Y]
                local dist= math.sqrt(a*a+b*b)
                d[P_DISTANCE_TO_PORTERS][i]=dist

                -- Note: distance to node itself is stored to save memory (array instead dictionary)
                if i== p_id or AreSpezialPorters(map, p_id,i) then
                    d[P_DISTANCE_TO_PORTERS][i]=TOO_FAR_AWAY
                end
            end
        end

        -- store src map in link
        md.link = md.link or {}
        for _,link in ipairs(md.link) do
            while #link<L_SRC_MAP do
                table.insert(link,0)
            end
            link[L_SRC_MAP] = map
            --link[L_SRC_MAP] = md.porter[ link[L_SRC_PORTER] ] --- <-- won't work..will destroy porter list..lua-bug?
        end
    end
end

----------------------------------
-- Recalculate graph distances
local function IsPorterActive(porter)
    return porter[P_FLAG]==0 or CheckFlag(porter[P_FLAG])>0
end

local TELEPORT_COST = 0.001 -- to prevent additional hopps; must be>0; higher values=mo
local ZONECHANGE_COST = 10  -- to prevent zone-changes

local no_links_error={}

--- RingBuffer
local ring_buffer={0}
local rb_start,rb_stop=1,1

local function rb_push(d)
    ring_buffer[rb_stop]=d
    rb_stop = (rb_stop%(#ring_buffer))+1
    if rb_start==rb_stop then
        if rb_stop==#ring_buffer then
            rb_stop = rb_stop+1
        else
            rb_start= rb_start+1
            table.insert(ring_buffer,rb_stop,0)
        end
    end
end

local function rb_pop()
    local res = ring_buffer[rb_start]
    rb_start= (rb_start%(#ring_buffer))+1
    return res
end

local function rb_has_data()
    return rb_start~=rb_stop
end

local function rb_reset()
    rb_start,rb_stop=1,1
end
---

function Map.BuildDistances(cur_map, cur_x, cur_y)

    -- clear all distances
    for _,md in pairs(MapData) do
        for _,porter in ipairs(md.porter) do
            porter[P_DISTANCE] = TOO_FAR_AWAY
        end
    end

    -- src map has no links/is unkown
    if not MapData[cur_map] then
        if not no_links_error[cur_map] then
            QH.API.DebugErr("Map: "..cur_map.." has no links")
            no_links_error[cur_map]=true
        end
        return
    end

    -- calculate distance to porters in current map
    for porter_id,porter in ipairs(MapData[cur_map].porter) do
        local a= porter[P_POS_X] - cur_x
        local b= porter[P_POS_Y] - cur_y
        local dist= math.sqrt(a*a+b*b)
        porter[P_DISTANCE]=dist
        porter[P_PREV_LINK]=0
        porter[P_LINK_COUNT]=0
    end



    -- put all connections of current zone into queue
    rb_reset()
    for i,link in ipairs(MapData[cur_map].link) do
        local destination = GetPorterDst(link)
        if IsPorterActive(destination) then
            rb_push(link)
        end
    end

    -- step deeper
    while rb_has_data() do

        local cur_link  = rb_pop()
        local cur_porter= GetPorterSrc(cur_link)
        local dest_porter = GetPorterDst(cur_link)
        local map = cur_link[L_DST_MAP]

        -- modify distance by porter type
        local base_dist = cur_porter[P_DISTANCE]+TELEPORT_COST
        if cur_link[L_SRC_MAP]~=cur_link[L_DST_MAP] then
            base_dist = base_dist + ZONECHANGE_COST
        end
        if cur_link[L_TYPE]==0 then base_dist=base_dist+cur_link[L_COSTS] -- walkway additional distance
        end

        -- only process if this link is better then the previously stored
        if base_dist < dest_porter[P_DISTANCE] then
            dest_porter[P_DISTANCE]=base_dist
            dest_porter[P_PREV_LINK]=cur_link
            dest_porter[P_LINK_COUNT]=cur_porter[P_LINK_COUNT]+1

            -- recalc all links from that porter
            local dest_porter_id = cur_link[L_DST_PORTER]
            for i,link in ipairs(MapData[map].link) do
                if link[L_SRC_PORTER] == dest_porter_id then
                    if IsPorterActive(GetPorterDst(link)) then
                        rb_push(link)
                    end
                end
            end

            -- check all 'walk' connection to porters
            for porter_id,porter in ipairs(MapData[map].porter) do

                -- skip current start porter
                if dest_porter~=porter then

                    local dist= dest_porter[P_DISTANCE_TO_PORTERS][porter_id] + base_dist

                    if dist < porter[P_DISTANCE] then
                        porter[P_DISTANCE]=dist

                        -- a dummy link .. this is okay 'cause it should be a rare case
                        -- TODO: check this, ATM it is created 199times
                        porter[P_PREV_LINK]={
                                [L_SRC_PORTER] = dest_porter_id,
                                [L_DST_MAP] = map,
                                [L_DST_PORTER] = porter_id,
                                [L_TYPE] = 3,
                                [L_COSTS] = 0,
                                [L_NAME] = 0,
                                [L_SRC_MAP]=map
                            }
                        porter[P_LINK_COUNT]=dest_porter[P_LINK_COUNT]+1

                        -- recalc all links from that porter
                        for i,link in ipairs(MapData[map].link) do
                            if link[L_SRC_PORTER]==porter_id then
                                if IsPorterActive(GetPorterDst(link)) then
                                    rb_push(link)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--------------------------------
-- Calculate path to goal
-- return {distance,target={},path={}}
--  where target is the final position = { m,x,y }
--  and path is the list of all link's
-- TODO: (this is an old routine) the full path isn't used anymore..usually only the first pos on a specific map is needed (usually the first path pos)
function Map.CalculatePath(src, goal)

    -- a global goal
    if goal[0] and goal[0].g then
        return {distance=0,target=nil,path={}}
    end

    -- result
    local res_path={distance=TOO_FAR_AWAY,target={},path={}}

    -- find best distance
    for map,allgoals in pairs(goal) do

        if map~=0 then

            -- direct way (player in same map)
            if map==src.m then
                for _,gd in ipairs(allgoals) do
                    local a=src.x-gd[1]
                    local b=src.y-gd[2]
                    local n=math.sqrt(a*a+b*b) - (gd[3] or 0)
                    if n<res_path.distance then
                        res_path.distance=n
                        res_path.target={ m=map,x=gd[1]*100,y=gd[2]*100 }
                        res_path.path ={}
                    end
                end
            end

            -- ports
            if not MapData[map] then
                QH.API.DebugErr("illegal goal pos: m="..tostring(map))
                QH.Map.MakeSureMapExists(map)
            end

            for _, porter in ipairs(MapData[map].porter or {}) do
                for gi,gd in ipairs(allgoals) do
                    local a=porter[P_POS_X]-gd[1]
                    local b=porter[P_POS_Y]-gd[2]
                    local n=math.sqrt(a*a+b*b) + porter[P_DISTANCE] - (gd[3] or 0)
                    if n<res_path.distance then
                        res_path.distance=n
                        res_path.target={ m=map,x=gd[1]*100,y=gd[2]*100 }

                        res_path.path = {}
                        local l = porter[P_PREV_LINK]
                        while l~=0 do
                            table.insert(res_path.path,1,l)
                            l = GetPorterSrc(l)[P_PREV_LINK]
                        end
                    end
                end
            end
        end
    end

    return res_path
end

-- Calculate distance and target pos of goal
function Map.CalculateDistance(src, goal)

    -- a global goal
    if goal[0] and goal[0].g then
        return 0,nil
    end

    -- result
    local distance = TOO_FAR_AWAY
    local target_map=nil

    -- find best distance
    for map,allgoals in pairs(goal) do

        if map~=0 then

            -- direct way (player in same map)
            if map==src.m then
                for _,gd in ipairs(allgoals) do
                    local a=src.x-gd[1]
                    local b=src.y-gd[2]
                    local n=math.sqrt(a*a+b*b) - (gd[3] or 0)
                    if n<distance then
                        distance=n
                        target_map=map
                    end
                end
            end

            -- ports
            if not MapData[map] then
                -- TODO: remove this debug code
                QH.API.Print("illegal goal pos: m="..tostring(map))
                QH.Map.MakeSureMapExists(map)
            end

            for _, porter in ipairs(MapData[map].porter or {}) do
                for _,gd in ipairs(allgoals) do
                    local a=porter[P_POS_X]-gd[1]
                    local b=porter[P_POS_Y]-gd[2]
                    local n=math.sqrt(a*a+b*b) + porter[P_DISTANCE] - (gd[3] or 0)
                    if n<distance then
                        distance=n
                        target_map=map
                    end
                end
            end
        end
    end

    return distance,target_map
end

--------------------------------
-- Find path position on map
-- return x,y,msg,path_type
function Map.GetPathInfoForMap(path, map)
    if not path then return end

    for _,link in ipairs(path) do
        if link[L_SRC_MAP] == map then
            return GetLinkInfo(link)
        end
    end
end

--------------------------------
-- return target_map, porter_id
function Map.GetPathStepTarget(path_step)
    return path_step[L_SRC_MAP], path_step[L_SRC_PORTER]
end

------------------------------------------------------
-- Get NPC information
-- param: id: NPC-ID
function Map.GetNPCInfo(id)
  if not id then
    QH.API.DebugErr("illegal call to Map.GetNPCInfo (id=nil)")
    return nil,"Unknown",10000,0.5,0.5
  end

  local count = NpcTrack_SearchNpcByDBID( id )

  if count < 1 then
    return nil,"Unknown",10000,0.5,0.5
  end

  assert(count==1, "multiple results")
  return NpcTrack_GetNpc(1)
end

function Map.GetPorterPos(map, id)
    local porter = GetPorter(map, id)
    return porter[P_POS_X],porter[P_POS_Y],porter[P_DISTANCE]
end

function Map.GetListOfNotActivatedPorters()

    local res={}

    for map, mdata in pairs(MapData) do
        for _, porter in ipairs(mdata.porter or {}) do
            if porter[P_FLAG] and CheckFlag(porter[P_FLAG])==0 then
                table.insert(res, {m=map, x=porter[P_POS_X], y=porter[P_POS_Y]})
            end
        end
    end

    return res
end

function Map.GetCurrentWorldMapID()
    local cur_map = GetCurrentWorldMapID()

    if cur_map==358 then return 5 end -- Ystra clone
    return cur_map
end

function Map.GetPlayerPos()
    local mp = Map.GetCurrentWorldMapID()
    local px, py = GetPlayerWorldMapPos()

    if not px or not py or not mp then return end

    return mp,px,py
end

-- for DEBUG only
function Map.GetData()
    return MapData
end


------------------------------------------------------
--[===[@debug@
local function CreateWoWMapPOIs(title)
    assert(WoWMap and WoWMap.RegisterPOIs, "WoWMap 4.0+ required")
    if not Map.dbg_pois then
        local poi_struct = { name="QH-DEBUG",
            textures={"interface/minimap/minimapborder_objicons.tga", 0/4,0/4,1/4,1/4},
            size={24,24},
            priority=100,
            maps={}
        }

        Map.dbg_pois = WoWMap.RegisterPOIs(poi_struct)
    end

    Map.dbg_pois.name = title
    return Map.dbg_pois.maps
end

function Map.DumpDistanceNodes()

    local poi = CreateWoWMapPOIs("QH Distance Nodes")

    for map, d in pairs(MapData) do
        poi[map] = {}

        for id,porter in pairs(d.porter or {}) do

            local text = string.format("%i. %g/%g d=%g\n",id,porter[P_POS_X]*100,porter[P_POS_Y]*100,porter[P_DISTANCE])

            if porter[P_FLAG]>0 and CheckFlag(porter[P_FLAG])==0 then
                text=text.."|cffff4040Porter not activated\n"
            end

            local path = {}
            local l = porter[P_PREV_LINK]
            while l~=0 do
                table.insert(path,1,l)
                l = GetPorterSrc(l)[P_PREV_LINK]
            end

            local curd=0
            for  i,link in pairs(path) do

                local x,y,desc = GetLinkInfo(link)
                local dist = GetPorterSrc(link)[P_DISTANCE]

                text=text..string.format("%i. go to %g/%g d=+%g\n",i*2-1, x*100,y*100,dist-curd)
                text=text..string.format("%i. %s\n",i*2, desc)

                curd=dist
            end

            table.insert(poi[map], {x=porter[P_POS_X],y=porter[P_POS_Y],tip=text} )
        end
    end

    WorldMapFrame_OnShow()
end

function Map.DumpNodes()

    local poi = CreateWoWMapPOIs("QH Nodes")

    for map, d in pairs(MapData) do
        poi[map] = {}

        for id,porter in pairs(d.porter or {}) do
            local text = {string.format("%i. %g/%g d=%g",id,porter[P_POS_X]*100,porter[P_POS_Y]*100,porter[P_DISTANCE])}

            for i,link in pairs(d.link or {}) do
                if link[L_SRC_PORTER]==id then

                    local zone=""
                    if link[L_DST_MAP]~=map then
                        zone="/"..GetZoneLocalName(link[L_DST_MAP])
                    end

                    local x,y,dist = Map.GetPorterPos(link[L_DST_MAP], link[L_DST_PORTER])

                    table.insert(text, string.format("%i%s %g/%g d=%i",link[L_DST_PORTER],zone,x,y,dist ))
                end
            end

            table.insert(poi[map], {x=porter[P_POS_X],y=porter[P_POS_Y],tip=table.concat(text,"\n")} )
        end
    end

    WorldMapFrame_OnShow()
end

-- /run QH.Map.DumpCatalogs()
function Map.DumpCatalogs()
    local function isZoneUnknown(cat_id)
        for map_id,list in pairs(MapData) do
            for cat,v in pairs(list.zones or {}) do
                if cat == cat_id then
                    return false
                end
            end
        end
        return true
    end

    SaveVariables("_catalogids")
    _catalogids={}
    for cat_id=1,400 do
        local c=GetQuestCatalogInfo(cat_id)
        if c~="" and isZoneUnknown(cat_id) then
            _catalogids[cat_id]=c
            DEFAULT_CHAT_FRAME:AddMessage(cat_id.."="..c)
        end
    end
end

--@end-debug@]===]
