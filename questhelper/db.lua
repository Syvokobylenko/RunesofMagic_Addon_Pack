-------------------------------------------------------
-- QuestHelper
--
-- file: DB
-- desc: Quest-Positions-Management
--   * Internal DB managment (data/qwdata.lua)
--   * User generate Questdata
--   * DB integrity test
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2017-08-20T7:43:08Z
-------------------------------------------------------

--[[
 DB-Format:
  Data_QID: - Quest Goals
    [QID]=GID,
    [QID]={GID1,GID2,...}

  Data_GID: - Goal Positions
    [GID] = {[map]={ {x,y},...
     in map=0:
      f = preqisite function (ex: get level 38)
      g = goal can be archived everywhere (no other maps needed)

  Data_NPC: - reward npc position
    [QID] = {map,x,y}
]]


--[[
-- QH_DynData format
-- [ClientVersion] = { [QID]={[GID] = {[map]={ {x,y} ...
--   special:
--    map = 0 -> ="g" -> goal can be archived everywhere
--    map = 0 -> ="r" -> reward npc position
--    if position has parameter 'd' -> delete position
--------------------------------------------
]]

local DB = {}
_G.QH.DB=DB

local Nyx = LibStub("Nyx")

QH_DynData = {} -- SaveVar - new quest data
local dyndata   -- current dyn.data block
local Data_GID  -- Goal/Position DB
local Data_QID  -- Quest-Goals DB
local Data_NPC  -- Reward NPC DB


-------------------------------------------------------
-- Init
function DB.Init()
    SaveVariables("QH_DynData")

    Data_GID = Nyx.LoadFile("Interface/Addons/QuestHelper/data/GID.luc")
    Data_QID = Nyx.LoadFile("Interface/Addons/QuestHelper/data/QID.luc")
    Data_NPC = Nyx.LoadFile("Interface/Addons/QuestHelper/data/NPC.luc")
    Data_GID = Data_GID or {}
    Data_QID = Data_QID or {}
    Data_NPC = Data_NPC or {}

    DB.InitDynData()
end

function DB.InitDynData()
    local client_ver = GetVersion()
    client_ver = string.match(client_ver, "^(%d+%.%d+%.%d+%.%d+)")

    QH_DynData[client_ver] = QH_DynData[client_ver] or {}
    dyndata = QH_DynData[client_ver]
end

-------------------------------------------------------
-- do integrity check
function DB.Test()

    -- check for unknown map
    for QID, ogoals in pairs(Data_QID) do

        local questname = TEXT("Sys"..QID.."_name")
        if not questname or questname=="" or string.find(questname,"^sys%d") then
            QH.API.DebugErr("unkown quest:"..QID.." name: "..tostring(questname))
        end

        local goals = ogoals
        if type(ogoals)=="number" then goals={ogoals} end
        for _,GID in pairs(goals) do

            local gdata = Data_GID[GID] or {}

            local goalname = TEXT("Sys"..GID.."_name")
            if not goalname or goalname=="" or string.find(goalname,"^sys%d") then
                QH.API.DebugErr("unkown goal:"..GID.." name: "..tostring(goalname).." Quest:"..questname.." "..QID)
            end

            for map,map_data in pairs(gdata) do
                if map~=0 then
                    if not QH.Map.IsValidMap(map) then
                        QH.API.DebugErr("unknown map:"..map.." for quest "..QID)
                    end

                    local i=0
                    for idx,pos in pairs(map_data) do
                        i=i+1
                    end
                    if i~=#map_data then
                        QH.API.DebugErr("Position list is not an number array (QID="..QID..") i="..i.."~="..(#map_data))
                    end
                end
            end
        end
    end
end

-------------------------------------------------------
function DB.DBStatistic()
    local quest_count = Nyx.TableSize(Data_QID)
    local goal_count = Nyx.TableSize(Data_GID)

    -- dyn data
    local dyn_quest_count = 0
    local dyn_goal_count = 0
    for _, dyndata in pairs(QH_DynData) do
        for QID,qd in pairs(dyndata) do
            dyn_quest_count = dyn_quest_count +1

            for GID,gd in pairs(qd) do
                dyn_goal_count = dyn_goal_count +1
            end
        end
    end

    return quest_count,dyn_quest_count, goal_count, dyn_goal_count
end

-------------------------------------------------------
function DB.IsPositionKnown(GID,mp,x,y)

    local gdata = DB.GetMaps(GID)
    if not gdata then return end

    if DB.IsGoalGlobal(gdata) then
        return -1
    end

    if not gdata[mp] then
        return nil
    end

    for i,p in ipairs(gdata[mp]) do
        local dist = (p[3] or 0.0009)
        local a,b = p[1]-x,p[2]-y
        if a*a+b*b<dist*dist then
            return i
        end
    end

    return nil
end

-------------------------------------------------------
local function getDynBlockVersions(dyndata)
  local versions = {}
  for ver,_ in pairs(dyndata) do
      table.insert(versions,ver)
  end

  local function VerToNum(v)
      local n1,n2,n3,n4 = string.match(v,"^(%d+)[%._](%d+)[%._](%d+)[%._](%d+)$")
      assert(n1, "not version="..tostring(v))
      return tonumber(n1)*10000+tonumber(n2)*100+tonumber(n3)*1+tonumber(n4)/10000
  end

  table.sort(versions, function (a,b)  return VerToNum(a)<VerToNum(b) end )

  return versions
end

local function clearEmptyFields(block)
  for key, vdata in pairs(block) do
    if next(vdata)==nil then
      block[key]=nil
    end
  end
end

function DB.MergeDynDataBlock(inc_data)

    -- add dyn info and do clean ups
    local data_worth=0
    for QID,qd in pairs(inc_data) do

        if qd[0] then

            if qd[0].r then
                local m,x,y = qd[0].r[1],qd[0].r[2],qd[0].r[3]
                local rm,rx,ry= DB.GetStoredRewardNPC(QID)
                local equal = (m==rm and math.abs(x-rx)<0.01 and math.abs(y-ry)<0.01)
                if equal or m==-1 then
                    qd[0].r=nil
                else
                    DB.StoredRewardNPC(QID, m,x,y)
                    data_worth = data_worth+5
                end
            end
        end

        for GID,gd in pairs(qd) do

            if GID~=0 then
                -- process specials
                if gd[0] then

                    DB.MakeSureQuestIsInDB(QID,GID)

                    if gd[0].g then
                        if DB.IsGoalGlobal(DB.GetMaps(GID)) then
                            gd[0]=nil
                        else
                            DB.MarkGoalAsGlobal(QID,GID)
                            data_worth = data_worth+10
                        end
                    end

                end

                -- append rest of data
                for mp,md in pairs(gd) do
                    if mp~=0 then

                        DB.MakeSureQuestIsInDB(QID,GID)
                        QH.Map.MakeSureMapExists(mp)

                        for k,v in pairs(md) do
                            local px = math.floor((v.x+0.0001)*1000)/1000
                            local py = math.floor((v.y+0.0001)*1000)/1000
                            local index = DB.IsPositionKnown(GID,mp,px,py)

                            if v.d then
                                if index then
                                    table.remove(Data_GID[GID][mp],index)
                                    data_worth = data_worth+7
                                else
                                    table.remove(inc_data[QID][GID][mp],k)
                                end
                            else
                                if not index then
                                    QH.Map.MakeSureMapExists(mp)
                                    Data_GID[GID] = Data_GID[GID] or {}
                                    Data_GID[GID][mp] = Data_GID[GID][mp] or {}
                                    table.insert(Data_GID[GID][mp], {v.x,v.y} )

                                    data_worth = data_worth+ (5/#Data_GID[GID][mp])
                                else
                                    table.remove(inc_data[QID][GID][mp],k)
                                end
                            end
                        end
                    end
                end
            end
        end
    end


    -- delete empty entries
    for QID,qd in pairs(inc_data) do
        for GID,gd in pairs(qd) do
            for mp,md in pairs(gd) do
                if next(md)==nil then inc_data[QID][GID][mp]=nil end
            end
            if next(gd)==nil then inc_data[QID][GID]=nil end
        end
        if next(qd)==nil then inc_data[QID]=nil end
    end

    return data_worth
end

function DB.MergeDynData()

  local versions = getDynBlockVersions(QH_DynData)

    QH.QDB.Load()

  local worth = 0
  for _, ver in ipairs(versions) do
      worth =  worth + DB.MergeDynDataBlock(QH_DynData[ver])
  end

  clearEmptyFields(QH_DynData)

  QH.QDB.Release()

  DB.InitDynData()

  return worth
end


function DB.cleanupDynDataBlockStarter(inc_data)

    for QID,qd in pairs(inc_data) do
      if qd[0] and qd[0].s then
        for i,npc in pairs(qd[0].s) do

          local qdata = QH.QDB.GetQuest(QID)
          if not qdata then
            QH.API.DebugErr("Dyn-Data: contains starter npc for unkown quest ID:"..QID)
          end

          if QH.QDB.isStartNPC(QID,npc) then
            table.remove(qd[0].s,i)
          end
        end

        if next(qd[0].s)==nil then qd[0].s=nil end
        if next(qd[0])==nil then inc_data[QID][0]=nil end
      end
    end

    for QID,qd in pairs(inc_data) do
        if next(qd)==nil then inc_data[QID]=nil end
    end
end

function DB.cleanupDynDataStarter()

    QH.QDB.Load()

    local versions = getDynBlockVersions(QH_DynData)

    for _, ver in ipairs(versions) do
        DB.cleanupDynDataBlockStarter(QH_DynData[ver])
    end

    clearEmptyFields(QH_DynData)

    QH.QDB.Release()
end

-------------------------------------------------------
-- Store a current player position as quest-target
function DB.AddNewQuestPos(QID,GID)

  local MAP,px,py = QH.Map.GetPlayerPos()
  if not MAP then
    QH.API.DebugErr("AddNewQuestPos -> no player pos for q="..tostring(QID).."g="..tostring(GID))
    return
  end

  if DB.IsPositionKnown(GID,MAP,px,py) then return end

  QH.Map.MakeSureMapExists(MAP)

  px = math.floor((px+0.0001)*1000)/1000
  py = math.floor((py+0.0001)*1000)/1000


  DB.QuestFound(QID,GID)
  Data_GID[GID] = Data_GID[GID] or {}
  Data_GID[GID][MAP] = Data_GID[GID][MAP] or {}
  dyndata[QID][GID][MAP] = dyndata[QID][GID][MAP] or {}

  table.insert(dyndata[QID][GID][MAP], {x = px, y = py})
  table.insert(Data_GID[GID][MAP], {px, py})

  return true
end

-------------------------------------------------------
-- Remove a goal permanent from quest-db
function DB.RemovePositionNear(QID,GID,map,x,y)

    local map_data = DB.GetPosition(GID,map)
    if not map_data then return end

    local index=nil
    local dist=0.0005
    for k,v in pairs(map_data) do
        local dx = (v[1]-x)*(v[1]-x) + (v[2]-y)*(v[2]-y)
        if dx < dist then
            dist = dx
            index = k
        end
    end
    if not index then return end

    x = map_data[index][1]
    y = map_data[index][2]
    table.remove(map_data,index)

    -- set Update data
    local is_in_dyntable = nil
    if dyndata[QID] and dyndata[QID][GID] and dyndata[QID][GID][map] then
            for k,v in pairs(dyndata[QID][GID][map]) do
                if v[1]==x and v[2]==y then
                    dyndata[QID][GID][map][k].d=1
                    is_in_dyntable = true
                end
            end
    end
    if not is_in_dyntable then
        dyndata[QID] = dyndata[QID] or {}
        dyndata[QID][GID] = dyndata[QID][GID] or {}
        dyndata[QID][GID][map] = dyndata[QID][GID][map] or {}
        table.insert(dyndata[QID][GID][map],{["x"]=x,["y"]=y,["d"]=1})
    end

    return true
end

-------------------------------------------------------
function DB.MarkGoalAsGlobal(QID,GID)
    DB.QuestFound(QID,GID)

    dyndata[QID][GID]={[0]={g=true}}

    Data_GID[GID] = Data_GID[GID] or {}
    Data_GID[GID][0] = Data_GID[GID][0] or {}
    Data_GID[GID][0].g = true
end

function DB.IsGoalGlobal(goal_maps)
    return goal_maps[0] and goal_maps[0].g
end

-------------------------------------------------------
-- Insert a new quest into the DB
function DB.QuestFound(QID,GID)
    DB.MakeSureQuestIsInDB(QID,GID)

    dyndata = dyndata or {}
    dyndata[QID] = dyndata[QID] or {}
    dyndata[QID][GID] = dyndata[QID][GID] or {}
end

function DB.MakeSureQuestIsInDB(QID,GID)
    Data_QID[QID] = Data_QID[QID] or {}
    if not DB.IsQuestGoal(QID,GID) then
        if type(Data_QID[QID])=="number" then
            Data_QID[QID] = {Data_QID[QID] }
        end
        table.insert(Data_QID[QID],GID)
    end
    Data_GID[GID] = Data_GID[GID] or {}
end

function DB.IsQuestGoal(QID,GID)
    local tab = Data_QID[QID]
    if type(tab)=="number" then
        return tab==GID
    end

    return Nyx.TableIndexOf(tab,GID)
end

-------------------------------------------------------
-- Test if any data is stored for a Quest-Goal
function DB.HasData(GID)
    local maps = DB.GetMaps(GID)
    return maps and next(maps) -- atleast one map is stored
end

-------------------------------------------------------
-- Get Priority function for the goal
function DB.GetGoalFunction(GID)
    local maps = DB.GetMaps(GID)
    return maps and maps[0] and maps[0].p
end

-------------------------------------------------------
-- return: goal target list => {[map_id]={ {x,y},....}, [map_id]=...}
function DB.GetMaps(GID)
    return Data_GID[GID]
end

-------------------------------------------------------
-- return: {gid1,gid2,...}
function DB.GetGoals(QID)
    local res=Data_QID[QID]
    if type(res)=="number" then
        return {res}
    elseif type(res)=="table" then
        return res
    end

    return {}
end

-- Note: expensive
function DB.GetQIDs()
    local res = {}
    for QID,_ in pairs(Data_QID) do
        table.insert(res,QID)
    end

    return res
end

-------------------------------------------------------
-- return: goal position-list => {{x,y},.... }
function DB.GetPosition(GID,MAP)

    local  maps = DB.GetMaps(GID)
    return maps and maps[MAP]
end

function QH.DB.GetBestPosition(GID)

    local maps = DB.GetMaps(GID)
    if maps then

        local best_map,best_x,best_y
        local best_size=-1

        for map,mdata in pairs(maps) do
            if map~=0 and mdata[1] then
                if best_size < (mdata[1][3] or 0.0075) then
                    best_size = mdata[1][3] or 0.0075
                    best_map = map
                    best_x= mdata[1][1]
                    best_y= mdata[1][2]
                end
            end
        end

        return best_map,best_x,best_y
    end
end

-------------------------------------------------------
function DB.GetStoredRewardNPC(QID)
    if Data_NPC[QID] then
        return unpack(Data_NPC[QID])
    end
end

function DB.StoredRewardNPCCurPos(QID)

    local mp,px,py = QH.Map.GetPlayerPos()
    DB.StoredRewardNPC(QID,mp,px,py)
end

function DB.StoredRewardNPC(QID,mp,px,py)

    if not mp or mp==-1 then
        QH.API.DebugErr("storing illegal position")
    end
    QH.Map.MakeSureMapExists(mp)

    DB.ClearRewardNPC(QID)

    Data_NPC[QID] = {mp,px,py}

    dyndata[QID] = dyndata[QID] or {}
    dyndata[QID][0] = dyndata[QID][0] or {}
    dyndata[QID][0].r = {mp,px,py}
end

function DB.ClearRewardNPC(QID)

    Data_NPC[QID] = nil

    if dyndata[QID] and dyndata[QID][0] then
        dyndata[QID][0].r = nil
        if next(dyndata[QID][0])==nil then
            dyndata[QID][0] = nil
        end
    end
end


function DB.StoreStartNPC(QID, npc_id)
  if not npc_id then return end

  if QH.QDB.IsDBLoaded() and QH.QDB.isStartNPC(QID,npc_id)  then return end


  dyndata[QID] = dyndata[QID] or {}
  dyndata[QID][0] = dyndata[QID][0] or {}

  local starters = dyndata[QID][0].s or {}
  for n=1,#starters do
    if starters[n]==npc_id then
      return
    end
  end

  table.insert(starters,npc_id)
  dyndata[QID][0].s = starters
end
