-----------------------------------------------------------------------------
-- Nyx
--  by McBen
--  A collection of random function I usually need
--  feedback to: viertelvor12@gmx.net
--
--
--  License: MIT/X
-----------------------------------------------------------------------------

local Nyx = LibStub:NewLibrary("Nyx", 18)
if not Nyx then return end


------------------------------
-- locales
------------------------------
local function TableMerge(dest, src)
    for k,v in pairs(src) do
        if type(v)=="table" then
            dest[k]=dest[k] or {}
            TableMerge(dest[k], v)
        else
            dest[k]=dest[k] or v
        end
    end
end

-- Example: Nyx.LoadLocalesAuto("Interface/Addons/dailynotes/Locales/")
-- Example: Nyx.LoadLocalesAuto("Interface/Addons/dailynotes/Locales/","default")
function Nyx.LoadLocalesAuto(directory, default)
    local func, err = loadfile(directory..string.sub(GetLanguage(),1,2)..".lua")
    local lang
    if not err then
        lang = func()
    end

    if default then
        local lang2 = Nyx.LoadFile(directory..default..".lua")
        lang = lang or lang2
        if not err and lang2 then
            TableMerge(lang, lang2)
        end
    end

    return lang
end

function Nyx.LoadLocales(directory, locales)
    local func, err = loadfile(directory..locales..".lua")
    if err then
        Nyx.LoadFile(directory.."en.lua")
        return
    end
    return func()
end

function Nyx.LoadFile(filename)
    local func, err = loadfile(filename)
    if err then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Error loading: "..filename.." -> "..tostring(err))
        return
    end
    return func()
end

------------------------------
function Nyx.GetBagItemCounts()
    local items={}
    for i = 51, 240 do
        local bagitemid, bagitemcount = Nyx.GetBagItem(i)
        if bagitemid then
            items[bagitemid] = (items[bagitemid] or 0) + bagitemcount
        end
    end
    return items
end

function Nyx.GetBagItem(index)
    local icon, _, itemCount, _ = GetGoodsItemInfo( index )
    if ( icon~="" ) then
        return Nyx.GetItemID(GetBagItemLink( index )), itemCount
    end
end

function Nyx.GetItemID( itemLk )

  if not itemLk then return end

  local ret = "";
  local _, _data = ParseHyperlink(itemLk)

  if ( _data and _data ~= "" ) then
    _,_,ret = string.find(_data, "(%x+)")
    ret =  tonumber(ret, 16)
  end

  return ret
end


function Nyx.CreateItemLink( item_id )
    assert(type(item_id)=="number")

    local r,g,b = GetItemQualityColor(GetQualityByGUID( item_id ))
    return string.format('|Hitem:%6x|h|cff%02x%02x%02x[dummy]|r|h',item_id,r*256,g*256,b*256)
end

function Nyx.FindBagIndex(m_name,m_icon)
    local inventoryIndex, icon, name
    local _,bagcount=GetBagCount()
    for i=1,bagcount do
        inventoryIndex, icon, name= GetBagItemInfo ( i )
        if name==m_name and icon==m_icon then
            return inventoryIndex
        end
    end
end

------------------------------
function Nyx.GetCurrentRealm()
  local realm = string.match((GetCurrentRealm() or ""),"(%w*)$")
  return realm or ""
end

function Nyx.GetUniqueCharname()
  local realm = Nyx.GetCurrentRealm()
  local player= UnitName("player") or ""
  return string.format("%s:%s",realm,player)
end

function Nyx.GetNPCInfo(npc_id)-- return: Name,map,pos_x,pos_y

    if NpcTrack_SearchNpcByDBID( npc_id ) <1 then
        return
    end

    local _, name, map, posx, posy = NpcTrack_GetNpc(1)
    return name,map,posx,posy

end

function Nyx.GetPlayerLevel() -- (secondary not depending on current main-class)

    mainClass, secondClass = UnitClass( "player" )

    local mlvl=0
    local slvl=0

    local numClasses = GetNumClasses()
    for i = 1, numClasses do
        local class, token, level, currExp, maxExp = GetPlayerClassInfo(i)
        if mainClass and   mainClass==class then mlvl = level end
        if secondClass and secondClass==class then slvl = level end
    end

    return mlvl,slvl
end

------------------------------
function Nyx.IsInMyGuild(name)
    local numGuildNodes = GetNumGuildMembers()

	for i = 1,numGuildNodes do
	    if name == GetGuildRosterInfo(i) then
            return true
        end
    end
end

------------------------------
local function ReplaceTags(desc, fct_on_id_tag, fct_on_name_tag, fct_on_color_tag)

    desc = string.gsub(desc,"%[(.-)%]",
        function (tag)
            nothing_found=false

            local _,_,res = string.find(tag,".*|(.+)")
            if res then
                return fct_on_name_tag(res)
            end

            if tag:find("^<[sS]>") then
                return fct_on_id_tag(string.sub(tag,4),true)
            elseif tonumber(tag) then
                return fct_on_id_tag(tag)
            else
                return fct_on_name_tag(TEXT(tag))
            end
        end
    )

    if fct_on_color_tag then
        desc = desc:gsub("<(/?)C(.-)>",fct_on_color_tag)
    else
        desc = desc:gsub("</?C.->","")
    end

    desc = desc:gsub("$PLAYERNAME",UnitName("player"))
    desc = desc:gsub("$playername",UnitName("player"))

    return desc
end

local function FullFunctionTags(text)

   return ReplaceTags(text,

        function (id,plural)
            local postfix = "_name"
            if plural then postfix = postfix.."_plural" end

            id = tonumber(id)
            if id>199999 then
                -- ITEM
                return string.format("|Hitem:%x|h%s[%s]|r|h",
                    id, TEXT("SYS_COLOR_ITEM"), TEXT("Sys"..id..postfix))
            else
                -- NPC
                return string.format("|Hnpc:%s|h%s[%s]|r|h",
                    id, TEXT("SYS_COLOR_NPC"), TEXT("Sys"..id..postfix))
            end
        end,

        function (text)
            return TEXT("SYS_COLOR_ZONE")..text.."|r"
        end,

        function (closed_text,id)
            if closed_text~="" then
                return "|r"
            end

            return "|cffff0000"
        end
    )
end

local function SmallFunctionTags(text)
    return ReplaceTags(text,

        function (id,plural)
            local postfix = "_name"
            if plural then postfix = postfix.."_plural" end

            return "|cffb0b0b0"..TEXT("Sys"..id..postfix).."|r"
        end,

        function (text)
            return "|cffb0b0b0"..text.."|r"
        end
    )
end

function Nyx.GetQuestBookText(Quest_ID)
    return SmallFunctionTags(TEXT("Sys"..Quest_ID.."_szquest_desc"))
end

function Nyx.GetFullQuestBookText(Quest_ID)
    return SmallFunctionTags(TEXT("Sys"..Quest_ID.."_szquest_accept_detail"))
end

function Nyx.GetQuestBookTextWithLinks(Quest_ID)
   return FullFunctionTags(TEXT("Sys"..Quest_ID.."_szquest_desc") )
end

function Nyx.GetFullQuestBookTextWithLinks(Quest_ID)
   return FullFunctionTags(TEXT("Sys"..Quest_ID.."_szquest_accept_detail") )
end
------------------------------
function Nyx.TableSize(tab)
    local s = 0
    for _,_ in pairs(tab) do s=s+1 end
    return s
end

function Nyx.VersionToNumber(text) --ex.: "v1"=10000  "1.2.3.4" = 10203.04
  local version=0
  local n=10000
  (text or "0"):gsub("%d+", function(c) if n>0 then version=version+(tonumber(c))*n; n=n/100 end end)
  return version
end

-- src: http://lua-users.org/wiki/SplitJoin
function Nyx.Split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
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
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end
