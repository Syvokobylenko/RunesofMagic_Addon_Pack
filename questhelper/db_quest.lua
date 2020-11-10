------------------------------------------------------
-- QuestHelper
--
-- file: db_quest
-- desc: quest detail database
--
-- Author: McBen
-- ver:  v7.4.5
-- date: 2020-01-19T8:48:21Z
------------------------------------------------------

local QDB = {}
_G.QH.QDB = QDB

local Nyx = LibStub("Nyx")

--[[ [ DataBase Format ]]
    local Q_LEVEL=1
    local Q_LEVEL_MIN=2
    local Q_LEVEL_MAX=3
    local Q_CATALOG=4
    local Q_ZONE=5
    local Q_REWARD_EXP=6
    local Q_REWARD_MONEY=7
    local Q_START_NPCS=8
    local Q_GOAL_PREFIX_TEXT=9
    local Q_GOAL_ID=10
    local Q_GOAL_COUNT=11
    local Q_PRE_QUEST=12
    local Q_POST_QUEST=13
    local Q_REWARD_ITEMS=14
    local Q_REWARD_ITEM_COUNT=15
    local Q_REWARD_NPC=16
    local Q_LOOPABLE=17
    local Q_RELATED_MOBS=18
    local Q_RELATED_ITEMS=19
    local Q_PRE_FLAGS=20
--[[ ] ]]
local DB
local Images
local UNKOWN_ICON = "item_orz_card.dds"

function QDB.Load()
    if QDB.ref_count then
        QDB.ref_count = QDB.ref_count + 1
        return
    end

    QDB.ref_count = 1

    local fn, err = loadfile("interface/addons/questhelper/data/questdb.luc")
    assert(fn, err)
    DB = fn()

    local fn, err = loadfile("interface/addons/questhelper/data/images.luc")
    assert(fn, err)
    Images = fn()
end

function QDB.IsDBLoaded()
    return DB ~= nil
end

function QDB.Release()
    QDB.ref_count = QDB.ref_count - 1
    if QDB.ref_count > 0 then
        return
    end

    QDB.ref_count = nil
    DB = nil
    Images = nil

    collectgarbage("collect")
end

function QDB.GetQuest(QID)
    return DB[QID]
end

function QDB.GetDB()
    return DB
end

function QDB.GetQuestCount()
    return Nyx.TableSize(DB)
end

function QDB.GetName(QID)
    return TEXT(string.format("Sys%06i_name", QID))
end

function QDB.GetRewardNPCPos(QID)
    local id, name, npc_mapID, x, y

    if QH.QB.IsIn(QID) then
        id, name, npc_mapID, x, y = QH.QB.GetRewardNPC(QID)
    else
        if QDB.IsDBLoaded() then
            local npc = QDB.GetRewardNPC(QH.QDB.GetQuest(QID))
            id, name, npc_mapID, x, y = QH.Map.GetNPCInfo(npc)
        end

        if not id then
            npc_mapID, x, y = QH.DB.GetStoredRewardNPC(QID)
        end
    end

    return id, (name or "unknown"), npc_mapID, x, y
end

function QDB.isStartNPC(QID, npc)
    local npcs = QDB.GetStartNPC(QDB.GetQuest(QID))

    for n = 1, #npcs do
        if npcs[n] == npc then
            return true
        end
    end
end
----------------------------
local function Value2Array(a)
    if type(a) == "table" then
        return a
    end

    if type(a) == "nil" then
        return {}
    end

    return {a}
end

function QDB.GetQuestGoals(qdata)
    return Value2Array(qdata[Q_GOAL_ID]), Value2Array(qdata[Q_GOAL_COUNT]), Value2Array(qdata[Q_GOAL_PREFIX_TEXT])
end

function QDB.GetLevel(qdata)
    return qdata[Q_LEVEL], qdata[Q_LEVEL_MIN], qdata[Q_LEVEL_MAX]
end

function QDB.GetZone(qdata)
    return qdata[Q_ZONE]
end

function QDB.GetZoneName(qdata)
    return GetZoneLocalName(qdata[Q_ZONE])
end

function QDB.IsInZone(qdata, zone)
    return QH.Map.IsInZone(qdata[Q_ZONE], zone)
end

function QDB.GetCatalogName(qdata)
    return GetQuestCatalogInfo(qdata[Q_CATALOG])
end

function QDB.GetPreQuest(qdata)
    return Value2Array(qdata[Q_PRE_QUEST])
end

function QDB.GetPostQuest(qdata)
    return Value2Array(qdata[Q_POST_QUEST])
end

function QDB.HasPreQuest(qdata)
    return qdata[Q_PRE_QUEST]
end

function QDB.HasPostQuest(qdata)
    return qdata[Q_POST_QUEST]
end

function QDB.IsLoopable(qdata)
    return qdata[Q_LOOPABLE]
end

function QDB.GetReward(qdata)
    return qdata[Q_REWARD_EXP], math.floor(qdata[Q_REWARD_EXP] / 10), qdata[Q_REWARD_MONEY]
end

function QDB.GetRewardItemsCount(qdata, chooseabel)
    local ch = chooseabel and -1 or 1

    local count = 0
    for _, c in ipairs(Value2Array(qdata[Q_REWARD_ITEM_COUNT])) do
        if c * ch > 0 then
            count = count + 1
        end
    end
    return count
end

function QDB.GetRewardItem(qdata, chooseabel, idx)
    local ch = chooseabel and -1 or 1

    for i, c in ipairs(Value2Array(qdata[Q_REWARD_ITEM_COUNT])) do
        if c * ch > 0 then
            idx = idx - 1
            if idx <= 0 then
                local item = Value2Array(qdata[Q_REWARD_ITEMS])[i]
                local image_name = Images[item] or UNKOWN_ICON
                local image = "interface/icons/" .. image_name

                return item, c * ch, image
            end
        end
    end
end

function QDB.GetRewardNPC(qdata)
    return qdata[Q_REWARD_NPC] or Value2Array(qdata[Q_START_NPCS])[1]
end

function QDB.GetStartNPC(qdata)
    return Value2Array(qdata and qdata[Q_START_NPCS])
end

function QDB.GetPrerequisits(qdata)
    return Value2Array(qdata[Q_PRE_QUEST]), Value2Array(qdata[Q_PRE_FLAGS])
end

function QDB.HasMissingPrequest(qdata)
    local pquest = QDB.GetPreQuest(qdata)
    for _, QID in ipairs(pquest) do
        if CheckQuest(QID)~=2 then
            return true
        end
    end
end

function QDB.AreAllFlagsValid(qdata)
    local value = qdata[Q_PRE_FLAGS]
    if value then
        local tab = Value2Array(value)
        for _, id in ipairs(tab) do
            if CheckFlag(id) ~= 1 then
                return false
            end
        end
    end

    return true
end

local function GetRelated(related)
    if not related then
        return {}
    end

    local res = {}
    for i = 1, #related, 4 do
        local i = {
            use = related[i],
            percent = related[i + 1],
            item = related[i + 2],
            count = related[i + 3]
        }
        table.insert(res, i)
    end

    return res
end

function QDB.GetRelatedItems(qdata)
    return GetRelated(qdata[Q_RELATED_ITEMS])
end

function QDB.GetRelatedMobs(qdata)
    return GetRelated(qdata[Q_RELATED_MOBS])
end
