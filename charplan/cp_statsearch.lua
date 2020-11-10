--[[
    CharPlan - PimpMe

    Pimp item dialog
    based on ideas of ItemForge and ItemPreview

    So special thanks to:
    - Valacar (Hash calculation)
    - ZhurRunes (ItemForge)
    - Alleris (ItemPreview)
]]

--[[
Item data = {
    -- icon,quality
    id
    bind
    bind_flag
    plus
    rarity    -- == color??
    tier
    dura
    max_dura  --  !! Percent of base-dura !!
    stats[6]
    max_runes
    runes[4]
    unk1      -- unknown itemlink data
}
]]


local CP = _G.Charplan
local StatSearch = {}
CP.StatSearch = StatSearch

local Pimp = CP.Pimp -- TEMP

local STATSEARCH_FIELD=13

function StatSearch.OnShow(this)
    StatSearch.Selection = nil
    StatSearch.initializing = true
    CPStatSearchTitle:SetText(Pimp.GetStatLable(this.slot))

    local is_rune = this.slot > 6
    if is_rune ~= StatSearch.statType then
    	-- dont clear filters between calls
    	StatSearch.statType = is_rune
    	StatSearch.filters = {}
    end

  	for i=1,5 do
  		local edit = getglobal('CPStatSearchSearchBox' .. i)
  		local label = getglobal(edit:GetName() .. 'Back')
  		edit:SetText(StatSearch.filters[i] or "")
  		label:SetText(CP.L['PIMP_FILTER' .. i])
  		if StatSearch.filters[i] then
  			label:Hide()
  		else
  			label:Show()
  		end
  	end

  	StatSearch.initializing = nil
	StatSearch.UpdateList()
end


function StatSearch.UpdateList()
    if StatSearch.initializing then return end

    local trim = function(s)
        if(s and s ~= '') then return s:lower() else return false end
    end

    local filters = StatSearch.filters
    for i=1,5 do
        local val = getglobal('CPStatSearchSearchBox' .. i):GetText()
        filters[i] = trim(val)
    end

    local isrune = (CPStatSearch.slot>6)
    local existing = (isrune and Pimp.data.runes) or Pimp.data.stats
    Pimp.Stats = CP.DB.GetBonusFilteredList(isrune, existing, unpack(filters))

    CPStatSearchItemSB:SetValueStepMode("INT")
    CPStatSearchItemSB:SetMinMaxValues(0,math.max(0,(#Pimp.Stats)-STATSEARCH_FIELD))

    StatSearch.ListUpdate()
end

function StatSearch.FilterFocus(this, got_focus)
    _G[this:GetName().."Back"]:Hide()
    if not got_focus and this:GetText()=="" then
        _G[this:GetName().."Back"]:Show()
    end
end

function StatSearch.ListUpdate()
    for i=1,STATSEARCH_FIELD do
        local d = Pimp.Stats[i + CPStatSearchItemSB:GetValue()]
        local line = "CPStatSearchItem"..i
        if d then
            _G[line.."Name"]:SetText(d[2])
            _G[line.."Value"]:SetText(table.concat(d[3],", "))
            _G[line]:Show()
            _G[line]:SetID(d[1])
            if StatSearch.Selection == d[1] then
                _G[line.."Highlight"]:Show()
            else
                _G[line.."Highlight"]:Hide()
            end
        else
            _G[line]:Hide()
        end
    end
end

function StatSearch.OnHide(this)

    if StatSearch.Selection then
        Pimp.SetStat(CPStatSearch.slot, StatSearch.Selection)
        StatSearch.Selection = nil
    end

    Pimp.Stats = nil
end

function StatSearch.ItemClicked(this,key)
    StatSearch.Selection = this:GetID()
    StatSearch.ListUpdate()
end

function StatSearch.Close()
    CPStatSearch:Hide()
end

function StatSearch.Cancel()
    StatSearch.Selection = nil
    CPStatSearch:Hide()
end

function StatSearch.ItemOnEnter(this)
    GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -10, 0)

    local name,lvl,grp = CP.DB.GetBonusInfo(this:GetID())
    GameTooltip:SetText(name)


    local ids = {{lvl,this:GetID()}}
    if grp then
        ids = CP.DB.GetBonusGroupLevels(grp)
    end

    for _,d in ipairs(ids) do
        local effect = CP.DB.GetBonusEffect(d[2])
        if effect and #effect>0 then
            GameTooltip:AddLine(d[1],1,0.82,0)
            local left={}
            local right={}
            for i=1,#effect,2 do
                table.insert(left, CP.DB.GetEffectName(effect[i]))
                table.insert(right,effect[i+1])
            end
            GameTooltip:AddDoubleLine(" "..table.concat(left,"/"), table.concat(right,"/"))
        end
    end

    GameTooltip:Show()
end

function StatSearch.ItemOnLeave()
    GameTooltip:Hide()
end


