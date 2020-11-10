local CP = _G.Charplan
local Unit= {}
CP.Unit = Unit


--[[ data fields:
    title_id
    title_count
    name
    level
    sec_level
    class
    sec_class
    skills
]]

function Unit.ClampLevel(level)
    level = tonumber(level) or 1
    if level<1 then return 1 end
    if level>CP.MAX_LEVEL then return CP.MAX_LEVEL end

    return level
end

local function _GetTitleCount()
    local count = GetTitleCount()-1
    local tc = 0
	for i = 0, count do
		local _,_,getted = GetTitleInfoByIndex(i)
        if getted then tc=tc+1 end
    end
    return tc
end


function Unit.ReadCurrent()
    Unit.title_id = GetCurrentTitle()
    Unit.title_count = _GetTitleCount()
    Unit.name = UnitName("player")
    Unit.level, Unit.sec_level=UnitLevel("player")
    Unit.class, Unit.sec_class=UnitClassToken("player")

    Unit.skills = Unit.GetListOfSkills()
end

function Unit.Store(data_tab)
    data_tab.name = Unit.name
    data_tab.title_id = Unit.title_id
    data_tab.title_count = Unit.title_count
    data_tab.level = Unit.level
    data_tab.sec_level = Unit.sec_level
    data_tab.class = Unit.class
    data_tab.sec_class = Unit.sec_class
    data_tab.skills = Unit.skills
end

function Unit.Load(data_tab)
    Unit.name = data_tab.name
    Unit.title_id = data_tab.title_id
    Unit.title_count = data_tab.title_count or 0
    Unit.level = data_tab.level
    Unit.sec_level = data_tab.sec_level
    Unit.class = data_tab.class
    Unit.sec_class = data_tab.sec_class
    Unit.skills = data_tab.skills or {}
end

function Unit.GetCurrentTitle()
    local count = GetTitleCount()
	for i = 1 , count do
        local name,id = GetTitleInfoByIndex( i - 1 )
        if id == Unit.title_id then
            return id,name
        end
    end

    if Unit.title_id~=0 then
        CP.Debug("title not found: id="..tostring(Unit.title_id))
    end

    return 0,C_TITLE_NIL
end

function Unit.Init(this)
    CP.RegisterEvent("PLAYER_TITLE_ID_CHANGED", Unit.Updated)
    CP.RegisterEvent("SKILL_UPDATE", Unit.Updated)
    CP.RegisterEvent("CARDBOOKFRAME_UPDATE", Unit.Updated)
    CP.RegisterEvent("PLAYER_LEVEL_UP", Unit.Updated)
end

function Unit.Updated()
    if CPFrame:IsVisible() then
        Unit.ReadCurrent()
        CP.Calc.ReadCards()
        CP.Calc.ReadSkills()
        CP.PlayerTitle()
        CP.UpdatePoints()
    end
end

function Unit.GetListOfSkills()

    local skills = {}

    for page=2,4 do

        local count = GetNumSkill( page ) or 0
        for index = 1,count do
            local _, _, _, _, PLV, _, _, _bLearned  = GetSkillDetail( page,  index )
            if _bLearned then
                local link = GetSkillHyperLink( page, index )
                local id, lvl = link:match(":(%d+) (%d+)")
                if PLV~=tonumber(lvl) then
                    --assert(PLV==tonumber(lvl))
                    CP.Debug("Warning: skill level diff:"..id.."->"..tostring(PLV).."/"..tostring(lvl))
                end
                if tonumber(id)~=nil then
                    skills[tonumber(id)] = PLV
                end
            end
        end
    end

    return skills
end

function Unit.GetClassNameByToken(token)
    for i=1,GetClassCount() do
        local name, class_token = GetClassInfoByID(GetClassID(i))
        if token == class_token then
            return name
        end
    end
end

function Unit.GetClassIDByToken(token)
    for i=1,GetClassCount() do
        local name, class_token = GetClassInfoByID(GetClassID(i))
        if token == class_token then
            return i
        end
    end
end

function Unit.GetClassName()
    return Unit.GetClassNameByToken(Unit.class), Unit.GetClassNameByToken(Unit.sec_class)
end

function Unit.SetClass(c1,c2)
    assert(c1)
    if c1==c2 then c2=nil end

    Unit.class=c1
    Unit.sec_class=c2
    Unit.skills={}

    local cc1,cc2=UnitClassToken("player")
    if c1==cc1 and c2==cc2 then
        Unit.skills = Unit.GetListOfSkills()
    end
end

function Unit.GetPet()
    return Unit.pet_id
end

function Unit.SetPet(pet_id)
    Unit.pet_id = pet_id
end

function Unit.GetSummonedPet()
	for i = 1,PET_FRAME_NUM_ITEMS do
		if IsPetSummoned(i) then
			return i
		end
	end
end

--[[ [ DataBase Format ]]
    -- Spells
    local S_LVL=1
    local S_ID=2
    local S_PRE_SKILL=3
    local S_PRE_SKILL_LVL=4
    local S_PRE_FLAG=5
    local S_GROUP=6
--[[ ] ]]

local function IsParentIncluded(all, find_skill)
    local id = find_skill[S_PRE_SKILL]
    if id<=0 then
        return true
    end
    for line,ldata in pairs(all) do
        for _,skill in ipairs(ldata) do
            if skill[S_ID]==id then
                return IsParentIncluded(all, skill)
            end
        end
    end
end

local function FindGroup(line, group)
    if group==0 then return end

    for idx,skill in ipairs(line) do
        if skill[9]==group then
            return idx, skill[S_ID]
        end
    end
end

function Unit.GetAllSkills()

    local c1 = CP.Unit.GetClassIDByToken(Unit.class)
    local c2 = CP.Unit.GetClassIDByToken(Unit.sec_class)

    local pre_res = {
        [DF_SkillType_MainJob] = CP.DB.GetSkillList(c1,1),
        [DF_SkillType_SP] = CP.DB.GetSkillList(c1,2)}

    if c2 and c2>0 then
        pre_res[DF_SkillType_SubJob] = CP.DB.GetSkillList(c2,1)
    end

    local skills={}
    local flags={}
    for line,ldata in pairs(pre_res) do
        skills[line]={}

        local level = Unit.level
        if line==DF_SkillType_SubJob then
            level = math.min(Unit.level,Unit.sec_level)
        end

        for _,skill in ipairs(ldata) do
            if IsParentIncluded(pre_res, skill) then

                local id = skill[S_ID]
                local skill_level = skill[S_LVL]

                -- req. level
                local available = skill_level<=level
                local condition_missing = nil

                -- req. flag
                if skill[S_PRE_FLAG]>0 then
                    if not Unit.skills[id] or Unit.skills[id]<1 then
                        table.insert(flags,skill[S_PRE_FLAG])
                        if CheckFlag(skill[S_PRE_FLAG])<1 then
                            condition_missing = "Flag:"..skill[S_PRE_FLAG]
                        end
                    end
                end

                -- req. pre-skill
                if skill[S_PRE_SKILL]>0 then

                    local pre_lvl = Unit.skills[skill[S_PRE_SKILL]] or 0
                    local cur_skill = Unit.skills[id]

                    if  pre_lvl<skill[S_PRE_SKILL_LVL] and not cur_skill then
                        condition_missing = TEXT("Sys"..skill[S_PRE_SKILL].."_name").." lvl"..skill[S_PRE_SKILL_LVL]
                    end
                end

                -- replace other skill (incl. moving skill level)
                local rep_idx, rep_id = FindGroup(skills[line], skill[S_GROUP])
                if rep_idx then
                    if available and not condition_missing then
                        Unit.skills[ id ] = Unit.skills[id] or Unit.skills[ rep_id ]
                        Unit.skills[ rep_id ] = nil
                        skill_level = skills[line][rep_idx][1]
                        table.remove(skills[line],rep_idx)
                    else
                        Unit.skills[rep_id] = Unit.skills[ rep_id ] or Unit.skills[id]
                        Unit.skills[skill[S_ID]]=nil
                    end
                end

                local max_level = (CP.DB.skills[id] and CP.DB.skills[id][4]) or 0
                if max_level >CP.MAX_LEVEL then max_level=CP.MAX_LEVEL end

                --if not condition_missing then
                local name = TEXT("Sys"..id.."_name")
                if condition_missing then
                    name = condition_missing.." > "..name
                    available = false
                end

                    table.insert(skills[line],
                    {   skill_level, id,
                        name,
                        available, condition_missing,
                        CP.DB.skills[id] and CP.DB.skills[id][1],
                        max_level,
                        skill[S_PRE_FLAG]>0,
                        skill[S_GROUP]
                        } )
                --end
            end
        end
    end

    -- sort
    for line,ldata in pairs(skills) do
        table.sort(ldata, function (a,b)
                if a[5]==b[5] then return a[1]<b[1] end
                return (a[5] and 1 or 2)<(b[5] and 1 or 2)
            end
        )
    end

    return skills, flags
end

function Unit.GetSkillTPSum()
    local sum=0
    for id,lvl in pairs(Unit.skills) do
        sum = sum + CP.DB.GetTPTotalCosts(id,lvl)
    end
    return sum
end
