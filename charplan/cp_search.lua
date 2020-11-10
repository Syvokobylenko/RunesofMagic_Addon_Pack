--[[  coding: utf-8

    CharPlan - Search

    Item search dialog
]]

local CP = _G.Charplan
local Search = {}
CP.Search = Search

local MAX_LINES=10
local HEADER_COUNT=4
local OVERDURA=110

function Search.OnLoad(this)

    UIPanelBackdropFrame_SetTexture( this, "Interface/Common/PanelCommonFrame", 256, 256 )

    CPSearchTitle:SetText(CP.L.SEARCH_TITLE)

    CPSearchHead1:SetText(CP.L.SEARCH_NAME)
    CPSearchHead2:SetText(CP.L.SEARCH_LEVEL)
    CPSearchHead3:SetText(CP.L.SEARCH_BASE_STATS)
    CPSearchHead4:SetText(CP.L.SEARCH_STATS)

    CPSearchFilterNameLabel:SetText(CP.L.SEARCH_NAME)
    CPSearchFilterLevelLabel:SetText(CP.L.SEARCH_LEVEL)
    CPSearchFilterStatsLabel:SetText(CP.L.SEARCH_FILTER_STATS)
    CPSearchFilterFilterText:SetText(CP.L.SEARCH_FILTER)

    CPSearchPimpPlus:SetText(CP.L.PIMP_PLUS)
    CPSearchPimpTier:SetText(CP.L.PIMP_TIER)
    CPSearchPowerModifyText:SetText(string.format(CP.L.SEARCH_POWER_MODIFY , OVERDURA))

    CPSearchTakeIt1:SetText(CP.L.SEARCH_USE_SLOT1)
    CPSearchTakeIt2:SetText(CP.L.SEARCH_USE_SLOT2)

    Search.FilterRaritySetSelection(3) -- purple items by default
end

function Search.ShowSearch(slot_id, item_id)
    if CP.DB.IsSlotType(slot_id) ~= CP.DB.IsSlotType(Search.slot) then
        Search.ClearSettings()
    end
    Search.slot = slot_id
    Search.selection = item_id

    local text = CP.L.SEARCH_FILTER_NIL
    if Search.slot then
        text = TEXT(string.format("SYS_EQWEARPOS_%02i",slot_id))
    end
    UIDropDownMenu_SetText(CPSearchFilterSlot,text)

    if Search.slot == 21 then	-- clear rarity for wings
        Search.FilterRaritySetSelection(nil)
    end

    Search.FindItems()
    CPSearch:Show()
end

function Search.ClearSettings()
    Search.type_filter={}
    for i=0,24 do Search.type_filter[i]=true end
end

function Search.OnShow(this)
    this:ResetFrameOrder()
    Search.UpdateSlotInfo()
end

function Search.OnHide()
    Search.Items=nil
end

function Search.OnTab(this)
    local tab_order={"CPSearchFilterName","CPSearchFilterLevelMin","CPSearchFilterLevelMax",
                     "CPSearchFilterStats","CPSearchFilterStatsMin","CPSearchFilterStatsMax"}

    local idx
    for i,name in ipairs(tab_order) do if this:GetName()==name then idx=i break end end

    if idx then
        if IsShiftKeyDown() then
            idx = idx-1
            if idx<1 then idx = #tab_order end
        else
            idx = idx+1
            if idx>#tab_order then idx=1 end
        end

        _G[tab_order[idx]]:SetFocus()
    end
end

function Search.FilterTypeMenu_OnLoad(this)
    Search.ClearSettings()

    UIDropDownMenu_SetWidth(this, 100)
    UIDropDownMenu_Initialize( this, Search.FilterTypeMenu_OnShow)
    UIDropDownMenu_SetText(this, CP.L.SEARCH_TYPE)
end

function Search.FilterTypeMenu_OnShow(this)
    local slot_type = CP.DB.IsSlotType(Search.slot)

    local filters={
        [1]= { -- Armor
            [TEXT("SYS_ARMORTYPE_00")]=0, -- Plate
            [TEXT("SYS_ARMORTYPE_01")]=1, -- Mail
            [TEXT("SYS_ARMORTYPE_02")]=2, -- Leather
            [TEXT("SYS_ARMORTYPE_03")]=3, -- Cloth
            },
        [2]= { -- Cloak
            [TEXT("SYS_ARMORTYPE_03")]=3, -- Cloth
            },
        [3]= { -- Jewelery
            [TEXT("SYS_ARMORTYPE_07")]=7, -- Jewelery
            },
        [4]= { -- Primary Weapon
            [TEXT("SYS_WEAPON_TYPE01")]=9,  --="Schwert"
            [TEXT("SYS_WEAPON_TYPE02")]=10, --="Dolch"
            [TEXT("SYS_WEAPON_TYPE03")]=11, --="Stab"
            [TEXT("SYS_WEAPON_TYPE04")]=12, --="Axt"
            [TEXT("SYS_WEAPON_TYPE05")]=13, --="Einhandhammer"
            [TEXT("SYS_WEAPON_TYPE06")]=14, --="Zweihandschwert"
            [TEXT("SYS_WEAPON_TYPE07")]=15, --="Zweihandstab"
            [TEXT("SYS_WEAPON_TYPE08")]=16, --="Zweihandaxt"
            [TEXT("SYS_WEAPON_TYPE09")]=17, --="Beidhдndiger Hammer"
            [TEXT("SYS_WEAPON_TYPE10")]=18, --="Stangenwaffe"
            },
        [5]= { -- Secondary Weapon
            [TEXT("SYS_ARMORTYPE_05")]=5,   -- Shield
            [TEXT("SYS_ARMORTYPE_06")]=6,   -- Talisman
            [TEXT("SYS_WEAPON_TYPE01")]=9,  --="Schwert"
            [TEXT("SYS_WEAPON_TYPE02")]=10, --="Dolch"
            [TEXT("SYS_WEAPON_TYPE03")]=11, --="Stab"
            [TEXT("SYS_WEAPON_TYPE04")]=12, --="Axt"
            [TEXT("SYS_WEAPON_TYPE05")]=13, --="Einhandhammer"
            [TEXT("SYS_WEAPON_TYPE10")]=18, --="Stangenwaffe"
            },
        [6]= { -- Ranges Weapon
            [TEXT("SYS_WEAPON_TYPE11")]=19, --="Bogen"
            [TEXT("SYS_WEAPON_TYPE12")]=20, --="Armbrust"
            [TEXT("SYS_WEAPON_TYPE13")]=21, --="Feuerwaffe"
            },
        [7]= { -- Back
            [TEXT("SYS_ARMORTYPE_03")]=3, -- Cloth
            },
    }

    local vals = filters[slot_type] or {}
    if not Search.slot then
        vals = {}
        for _,data in pairs(filters) do
            for name,id in pairs(data) do
                vals[name] = id
            end
        end
    end

    for name,id in pairs(vals) do
        local info={}
        info.text=name
        info.checked = Search.type_filter[id]
        info.value = id
        info.func = Search.FilterTypeMenu_OnSelect
        info.keepShownOnClick = 1
		UIDropDownMenu_AddButton( info, 1 )
    end
end

function Search.FilterTypeMenu_OnSelect(this)
    Search.type_filter[this.value] = not Search.type_filter[this.value]
    Search.FindItems()
end

function Search.FilterSlotMenu_OnLoad(this)
    UIDropDownMenu_SetWidth(this, 100)
    UIDropDownMenu_Initialize( this, Search.FilterSlotMenu_OnShow)
    UIDropDownMenu_Refresh(this)
end

function Search.FilterSlotMenu_OnShow(this)
    local slots={0,1,2,3,4,5,6,7,8,10,11,13,15,16,21}

    local info={
        text=CP.L.SEARCH_FILTER_NIL,
        checked = (Search.slot==nil),
        value = nil,
        func = Search.FilterSlotMenu_OnSelect,
    }
    UIDropDownMenu_AddButton( info, 1 )

    for _,id in ipairs(slots) do
      info.text=TEXT(string.format("SYS_EQWEARPOS_%02i",id))
      info.checked = (Search.slot==id)
      info.value = id
      UIDropDownMenu_AddButton( info, 1 )
    end
end

function Search.FilterSlotMenu_OnSelect(this)
    UIDropDownMenu_SetSelectedID(CPSearchFilterSlot, this:GetID())
    Search.slot=this.value
    Search.FindItems()
end

function Search.PlusMenu_OnLoad(this)
    UIDropDownMenu_SetWidth(this, 40)
    UIDropDownMenu_Initialize(this, Search.PlusMenu_OnShow)
    UIDropDownMenu_SetSelectedValue(this, 0)
end

function Search.PlusMenu_OnShow(button)
    local info={}
    for i=0,CP.MAX_PLUS do
        info.text = "+"..i
        info.value = i
        info.notCheckable=1
        info.func = Search.PlusMenu_OnClicked
        UIDropDownMenu_AddButton(info)
    end
end

function Search.PlusMenu_OnClicked(button)
    UIDropDownMenu_SetSelectedValue(CPSearchFilterPlus, button.value)
    Search.UpdateList()
end

function Search.TierMenu_OnLoad(this)
    UIDropDownMenu_SetWidth(this, 40)
    UIDropDownMenu_Initialize(this, Search.TierMenu_OnShow)
    UIDropDownMenu_SetSelectedValue(this, 0)
end

function Search.TierMenu_OnShow(button)
    local info={}
    for i=0,CP.MAX_TIER do
        info.text = "+"..i
        info.value = i
        info.notCheckable=1
        info.func = Search.TierMenu_OnClicked
        UIDropDownMenu_AddButton(info)
    end
end

function Search.TierMenu_OnClicked(button)
    UIDropDownMenu_SetSelectedValue(CPSearchFilterTier, button.value)
    Search.UpdateList()
end

function Search.FilterRarityMenu_OnLoad(this)
    UIDropDownMenu_SetWidth(this, 100)
    UIDropDownMenu_Initialize(this, Search.FilterRarityMenu_OnShow)
    UIDropDownMenu_SetSelectedValue(this, 0)
end

local function GetRarityName(id)
    if not id then return TEXT("C_ALL") end
    if id==8 then return TEXT("ACCOUNT_SHOP") end
    if id==0 then return TEXT("UNUSUAL_LV0") end

    return TEXT("ITEM_QUALITY"..id.."_DESC")
end

local function AddRarityMenuButton(id)
    local info = {}
    info.text = GetRarityName(id)
    info.textR, info.textG, info.textB = GetItemQualityColor(id or 0)
    info.func = Search.FilterRarityMenu_OnClicked
    info.value=id
    UIDropDownMenu_AddButton(info)
end

function Search.FilterRarityMenu_OnShow(button)

    AddRarityMenuButton(nil)
	for i = 0, 5 do
        AddRarityMenuButton(i)
	end
    AddRarityMenuButton(8)

    UIDropDownMenu_AddSeparator()

    local info = {
        text = CP.L.SEARCH_RARITY_EXACT,
        checked = Search.rarity_single,
        value = true,
        func = Search.FilterRarityMenu_Option_OnClicked
    }
    UIDropDownMenu_AddButton(info)

    info = {
        text = CP.L.SEARCH_RARITY_MINIMUM,
        checked = not Search.rarity_single,
        value = nil,
        func = Search.FilterRarityMenu_Option_OnClicked
    }
    UIDropDownMenu_AddButton(info)
end

function Search.FilterRaritySetSelection(id)
    local name = GetRarityName(id)
    UIDropDownMenu_SetSelectedName(CPSearchFilterRarity, name)
    CPSearchFilterRarityText:SetColor( GetItemQualityColor(id or 0) )
    Search.rarity=id
end

function Search.FilterRarityMenu_OnClicked(button)
    Search.FilterRaritySetSelection(button.value)
    Search.FindItems()
end

function Search.FilterRarityMenu_Option_OnClicked(button)
    Search.rarity_single=button.value
    Search.FindItems()
end

function Search.FilterFilterMenu_OnLoad(this)
    UIDropDownMenu_SetWidth(this, 100)
    UIDropDownMenu_Initialize(this, Search.FilterFilterMenu_OnShow)
end

function Search.FilterFilterMenu_OnShow(button)
    local info = {}
    info.text = CP.L.SEARCH_NOSTATLESS
    info.checked = Search.no_empty_items
    info.func = function()
                    Search.no_empty_items = not Search.no_empty_items
                    Search.FindItems()
                end
    UIDropDownMenu_AddButton(info)

    local info = {}
    info.text = CP.L.SEARCH_ONLYSET
    info.checked = Search.itemset_only
    info.func = function()
        Search.itemset_only = not Search.itemset_only
        Search.FindItems()
    end
    UIDropDownMenu_AddButton(info)

    local info = {}
    info.text = CP.L.SEARCH_UNIQUE_SKINS
    info.checked = Search.unique_skin
    info.func = function()
        Search.unique_skin = not Search.unique_skin
        Search.FindItems()
    end
    UIDropDownMenu_AddButton(info)

    local info = {}
    info.text = CP.L.SEARCH_GENDER
    info.checked = Search.limitsex
    info.func = function()
        Search.limitsex = not Search.limitsex
        Search.FindItems()
    end
    UIDropDownMenu_AddButton(info)

    local info = {}
    info.text = CP.L.SEARCH_UNNAMED
    info.checked = Search.include_unnamed
    info.func = function()
        Search.include_unnamed = not Search.include_unnamed
        Search.FindItems()
    end
    UIDropDownMenu_AddButton(info)

end

local function GetFilterInfo()

    local info={}

    info.slot = Search.slot
    info.name = CPSearchFilterName:GetText()
    info.level_min = tonumber(CPSearchFilterLevelMin:GetText())
    info.level_max = tonumber(CPSearchFilterLevelMax:GetText())
    if info.level_min and info.level_max and info.level_min>info.level_max then
        info.level_min,info.level_max = info.level_max,info.level_min
    end
    info.include_unnamed = Search.include_unnamed
    info.no_empty_items = Search.no_empty_items
    info.itemset_only = Search.itemset_only
    info.unique_skin = Search.unique_skin
    info.stat_name = CPSearchFilterStats:GetText()
    info.stat_min = tonumber(CPSearchFilterStatsMin:GetText())
    info.stat_max = tonumber(CPSearchFilterStatsMax:GetText())
    info.rarity = Search.rarity
    info.rarity_single = Search.rarity_single

    if not Search.limitsex then
        info.limitsex = 1+(UnitSex("player") %2)
    end

    info.types = {}
    for id,v in pairs(CP.Search.type_filter) do
        if v then
            table.insert(info.types,id)
        end
    end

    return info
end

function Search.FindItems()

    local filter_info = GetFilterInfo()

    Search.Items = CP.DB.FindItems(filter_info)

    CPSearchItemsSB:SetValueStepMode("INT")
    CPSearchItemsSB:SetMinMaxValues(0,math.max(0,(#Search.Items)-MAX_LINES))

    if Search.cur_sort then
        Search.DoSort(Search.cur_sort)
    end
    Search.ScrollToSelection()
end

function Search.HeaderClicked(this)
    assert(this:GetID()<=HEADER_COUNT)
    for i=1,HEADER_COUNT do
        _G["CPSearchHead"..i.."SortIcon"]:Hide()
        if _G["CPSearchHead"..i.."SortIcon2"] then _G["CPSearchHead"..i.."SortIcon2"]:Hide() end
    end

    local id = this:GetID()
    if Search.cur_sort == id or Search.cur_sort == -id then
        Search.cur_sort = -Search.cur_sort

        if id==3 and Search.cur_sort>0 then
            Search.cur_sort_sub = not Search.cur_sort_sub
        end
    else
        Search.cur_sort_sub=nil
        Search.cur_sort = id
    end

    local texture = _G[this:GetName() .."SortIcon"]
    local texture2 = _G[this:GetName().."SortIcon2"]
    if Search.cur_sort>0 then
        texture:SetFile("Interface/chatframe/chatframe-scrollbar-buttondown")
        if Search.cur_sort_sub and texture2 then
            texture2:SetFile("Interface/chatframe/chatframe-scrollbar-buttondown")
            texture2:Show()
        end
    else
        texture:SetFile("Interface/chatframe/chatframe-scrollbar-buttonup")
        if Search.cur_sort_sub and texture2 then
            texture2:SetFile("Interface/chatframe/chatframe-scrollbar-buttonup")
            texture2:Show()
        end
    end
        texture:Show()

    Search.DoSort(Search.cur_sort)
end

function Search.DoSort(column)

    local cache={}

    local function GetPriBonus(item_id)
        local cached = cache[item_id]
        if cached then return cached end

        local att1,att2 = CP.DB.PrimarAttributes(item_id)

        local item = CP.DB.GenerateItemDataByID(item_id)
        item.plus= UIDropDownMenu_GetSelectedValue(CPSearchFilterPlus) or 0
        item.tier= UIDropDownMenu_GetSelectedValue(CPSearchFilterTier) or 0
        if CPSearchPowerModify:IsChecked() then
          item.dura = OVERDURA
          item.max_dura = CP.DB.CalcMaxDura(item.id, OVERDURA)
        end

        local effect = CP.Calc.GetItemBonus(item)
        local effect1, effect2 = effect[att1], effect[att2]
        local weapon = att1 == CP.Calc.STATS.PDMG
        local boni
        if weapon then
        	if not Search.cur_sort_sub then
        		-- sort by dps for pdmg-based weapons
        		local speed = CP.DB.GetWeaponSpeed(item_id)
        		if speed and speed ~= 0 then
        			boni = effect1 / speed
        		else
        			boni = effect1
        		end
        	else
        		--or sort by mdmg
        		boni = effect2
        	end
        else
        	-- sort armor by pdef+mdef
        	boni = effect1 + effect2
        end
        cache[item_id] = boni
        return boni
    end

    local function GetNonPriBonus(item_id)
        local cached = cache[item_id]
        if cached then return cached end

        local att1,att2 = CP.DB.PrimarAttributes(item_id)

        local item = CP.DB.GenerateItemDataByID(item_id)
        item.plus= UIDropDownMenu_GetSelectedValue(CPSearchFilterPlus) or 0
        item.tier= UIDropDownMenu_GetSelectedValue(CPSearchFilterTier) or 0
        if CPSearchPowerModify:IsChecked() then
          item.dura = OVERDURA
          item.max_dura = CP.DB.CalcMaxDura(item.id, OVERDURA)
        end
        local boni=0
        local effect = CP.Calc.GetItemBonus(item)
        for id,val in pairs(effect) do
            if id~=att1 and id~=att2 then
                boni = boni + val
            end
        end

        cache[item_id] = boni
        return boni
    end

    local sorts=
    {
        [1] = function (id1,id2)
                return TEXT("Sys"..id1.."_name")<TEXT("Sys"..id2.."_name")
            end,

        [2] = function (id1,id2)
                local l1 = CP.DB.GetItemInfo(id1)
                local l2 = CP.DB.GetItemInfo(id2)
                return l1>l2
            end,

        [3] = function (id1,id2)
                return GetPriBonus(id1) > GetPriBonus(id2)
            end,

        [4] = function (id1,id2)
               return GetNonPriBonus(id1) > GetNonPriBonus(id2)
            end,
    }

    if column>0 then
        table.sort(Search.Items, sorts[column])
    else
        table.sort(Search.Items, function (a,b) return sorts[-column](b,a) end)
    end


    Search.ScrollToSelection()
end

function Search.ScrollToSelection()

    if Search.selection then
        line = 1
        for i,id in ipairs(Search.Items) do
            if id == Search.selection then
                line = i
                break
            end
        end

        local top_pos = CPSearchItemsSB:GetValue()
        if top_pos>line then
            CPSearchItemsSB:SetValue(line-1)
        elseif top_pos+MAX_LINES<line then
            CPSearchItemsSB:SetValue(math.max(line-MAX_LINES))
        end
    end

    Search.UpdateList()
end

function Search.UpdateList()

    local top_pos = CPSearchItemsSB:GetValue()

    for i=1,MAX_LINES do
        local base_name = "CPSearchItem"..i

        local item_id = Search.Items[i+top_pos]

        if item_id then
            local item_data = Search.GetPimpedItemData(item_id)
            Search.UpdateItem(base_name,item_data)

            if item_id == Search.selection then
                _G[base_name.."Highlight"]:Show()
            else
                _G[base_name.."Highlight"]:Hide()
            end
            _G[base_name]:Show()
        else
            _G[base_name]:Hide()
        end
    end
end

function Search.UpdateItem(base_name, item)

    SetItemButtonTexture(_G[base_name.."Item"], item.icon )

    local r,g,b = GetItemQualityColor(GetQualityByGUID( item.id ))
    local col=string.format("|cff%02x%02x%02x",r*255,g*255,b*255)
    _G[base_name.."Name"]:SetText(col..TEXT("Sys"..item.id.."_name"))

    local level, set = CP.DB.GetItemInfo(item.id)
    local setname = set and TEXT("Sys"..set.."_name") or ""
    _G[base_name.."Set"]:SetText(setname)
    _G[base_name.."Level"]:SetText(level or "")


    local boni=CP.Calc.GetItemBonus(item)

    local txt = ""
    local attA,attB = CP.DB.PrimarAttributes(item.id)
    if attA and boni[attA]~=0 then
        -- add DPS
        if attA == CP.Calc.STATS.PDMG then
        	local dps = CP.Calc.WeaponDps(item.id, boni[attA])
        	if dps then
	    		txt = txt..string.format("%s: %.1f\n", CP.L.STAT_SHORTS.DPS, dps)
        	end
        end
        local n = CP.Calc.ID2StatName(attA)
        txt = txt..(CP.L.STAT_SHORTS[n])..": "..boni[attA].."\n"
        boni[attA] = nil
    end
    if attB and boni[attB]~=0 then
        local n = CP.Calc.ID2StatName(attB)
        txt = txt..(CP.L.STAT_SHORTS[n])..": "..boni[attB].."\n"
        boni[attB] = nil
    end
    _G[base_name.."Effect"]:SetText(txt)

    local boni_txt={}
    local i=0
    for eff,value in pairs(boni) do
        if value~=0 then
            local idx = 1+math.floor(i/3)
            local txt = "+"..value.." "..CP.DB.GetEffectName(eff)
            if string.len(txt)>36 then
                txt = string.sub(txt,1,35).."…"
            end
            boni_txt[idx] = (boni_txt[idx] or "")..txt.."\n"
            i=i+1
        end
    end

    _G[base_name.."Boni"]:SetText(boni_txt[1] or "")
    _G[base_name.."Boni2"]:SetText(boni_txt[2] or "")
end

function Search.UpdateSlotInfo()
    local s1,s2
    if Search.selection then
        s1,s2 = CP.DB.GetItemPositions(Search.selection)
    else
        s1 = Search.slot
        if s1==11 or s1==12 then s1,s2=11,12 end
        if s1==13 or s1==14 then s1,s2=13,14 end
    end

    Search.slots = {}
    if s1 then
        CPSearchTakeIt1:Show()
        CPSearchTakeIt1Item:Show()
        SetItemButtonTexture(CPSearchTakeIt1Item, CP.GetSlotTexture(s1))
        Search.slots[1] = CP.Items[s1]
    else
        CPSearchTakeIt1:Hide()
        CPSearchTakeIt1Item:Hide()
    end

    CPSearchTakeIt1:SetText(CP.L.SEARCH_USE_SLOT1)
    if s2 then
        CPSearchTakeIt2:Show()
        CPSearchTakeIt2Item:Show()
        SetItemButtonTexture(CPSearchTakeIt2Item, CP.GetSlotTexture(s2))
        Search.slots[2] = CP.Items[s2]
    else
        CPSearchTakeIt2:Hide()
        CPSearchTakeIt2Item:Hide()
        if Search.slot == 16 then   -- "Slot 2" for right hand
          CPSearchTakeIt1:SetText(CP.L.SEARCH_USE_SLOT2)
        end
    end
end

function Search.SelectItem(item_id)
    if item_id ~= Search.selection then
        Search.selection = item_id
        Search.ScrollToSelection()
        Search.UpdateSlotInfo()
    end
end

function Search.OnItemClick(this, key)

  local top_pos = CPSearchItemsSB:GetValue()
  local new_item = Search.Items[this:GetID()+top_pos]
  if key == "RBUTTON" then
    GameTooltip:Hide()
    CPSearchItemMenu.item_id = new_item
    ToggleDropDownMenu(CPSearchItemMenu, 1,this,"cursor", 1 ,1 )
    return
  elseif key == "LBUTTON" and (IsShiftKeyDown() or IsCtrlKeyDown()) then
    local item_data = Search.GetPimpedItemData(new_item)
    if IsCtrlKeyDown() then
        local link = CP.Pimp.GenerateLink(item_data, CP.Prefix)
        ItemPreviewFrame_SetItemLink(ItemPreviewFrame, link)
    else
        CP.PostItemLink(item_data)
    end
		return
  end
  Search.SelectItem(new_item)
  Search.UpdateList()
end

function Search.OnItemDblClick(this)
    Search.OnItemClick(this)
    Search.OnTakeIt()
end

function Search.OnItemEnter(this)
    local top_pos = CPSearchItemsSB:GetValue()
    local item_id = Search.Items[this:GetID()+top_pos]
    if item_id then
        GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT", 0, 2)

        local item = CP.DB.GenerateItemDataByID(item_id)
        item.plus= UIDropDownMenu_GetSelectedValue(CPSearchFilterPlus) or 0
        item.tier= UIDropDownMenu_GetSelectedValue(CPSearchFilterTier) or 0
		if CPSearchPowerModify:IsChecked() then
		    item.dura = OVERDURA
		    item.max_dura = CP.DB.CalcMaxDura(item_id, OVERDURA)
		end
        GameTooltip:SetHyperLink(CP.Pimp.GenerateLink(item))
        GameTooltip:Show()
        GameTooltip1:Hide()
        GameTooltip2:Hide()
    end
end

function Search.OnItemLeave(this)
    GameTooltip1:Hide()
    GameTooltip2:Hide()
    GameTooltip:Hide()
end

function Search.ShowContextMenu(this)
    local info={notCheckable = 1}

    info.text = CP.L.SEARCH_CONTEXT_TAKE
    info.func = function()
                    Search.ApplyItem(this.item_id)
                end
    UIDropDownMenu_AddButton(info)

    if CP.DB.IsSuitItem(this.item_id) then
      info.text = CP.L.SEARCH_CONTEXT_SUIT
      info.func = function() Search.ApplySuitOfItem(this.item_id) end
      UIDropDownMenu_AddButton(info)
    end

    local skin = CP.DB.ItemSkinPosition(this.item_id)
    if skin then
        info.text = CP.L.SEARCH_CONTEXT_SKIN
        info.func = function()
                    CP.UseSkin(this.item_id,skin)
                end
        UIDropDownMenu_AddButton(info)
    end


    info.text = CP.L.SEARCH_CONTEXT_WEB
    info.func = function()
                    local linkData = string.format(CP.L.SEARCH_WEBSITE,this.item_id)
					--StaticPopupDialogs["OPEN_WEBROWER"].link = linkData
					--StaticPopup_Show("OPEN_WEBROWER")
    				GC_OpenWebRadio(linkData)
                end
    UIDropDownMenu_AddButton(info)

		-- item sources --

		-- 1. Loot
    local res = Search.FindInDungeonLoots(this.item_id)
    for _,data in pairs(res) do
        info.text   = data
        info.func   = function ()
                assert(DungeonLoot_Frame)
                DungeonLoot.var.instance =
                DungeonLoot_Frame:Show()
            end
        UIDropDownMenu_AddButton(info)
    end

    -- 2. Vendor
    res = Search.FindInShops(this.item_id)
    if res then
    	for shop_id,text in pairs(res) do
    		info.arg1 = shop_id
    		info.text = text
    		info.func = function(button)
    			-- print rest of items for this shop
    			local shop_id = button.arg1
    			local res = Search.GetShopContents(shop_id)
   				for id,text in pairs(res) do
   					DEFAULT_CHAT_FRAME:AddMessage(text)
   				end
    		end
    		UIDropDownMenu_AddButton(info)
    	end
    end

    -- 3. Recipes
    res = Search.FindInRecipes(this.item_id)
    if res then
    	info.arg1 = res[2]
    	info.text = res[2]
    	info.func = function(button)
    		DEFAULT_CHAT_FRAME:AddMessage(button.arg1)
			end
			UIDropDownMenu_AddButton(info)
			end
end

function Search.FindInDungeonLoots(item_id)
    local res = {}
    if DungeonLoot and DungeonLoot.tables then
        for _,zone in pairs(DungeonLoot.tables) do
            for bossNum,boss in pairs(zone.Boss or {}) do
                for _,loot in pairs(boss.Loots or {}) do
                    if loot==item_id then
                    		local where = string.format(CP.L.SEARCH_DROPPED,
                                GetZoneLocalName(zone.Zone) or "unknown",
                                TEXT("Sys"..boss.Name.."_name")
                            		);
                        where = where .. string.format(" (%d)", bossNum)
                        table.insert(res, where)
                    end
                end
            end
        end
    end
    return res
end

function Search.FindInShops(item_id)
	local shops = CP.DB.GetShopItemInfo(item_id)
	if shops then
		local res = {}
		for shop_id,info in pairs(shops) do
			local price = info[1]
			local where = string.format(CP.L.SEARCH_SELLED, shop_id) .. string.format(" %s %s", MoneyNormalization(price.cost), CP.DB.GetMoneyName(price.type))
			price = info[2]
			if price then
				where = where .. string.format(", %s %s", MoneyNormalization(price.cost), CP.DB.GetMoneyName(price.type))
			end
			res[shop_id] = where
		end
		return res
	end
end

function Search.GetShopContents(shop_id)
	local shop = CP.DB.GetShopInfo(shop_id)
	if not shop then return nil end
	local res = {}
	for item_id,info in pairs(shop) do
		local price = info[1]
		local what = CP.Pimp.GenerateSimpleLink(item_id)
		local where = string.format("%s %s", MoneyNormalization(price.cost), CP.DB.GetMoneyName(price.type))
		price = info[2]
		if price then
			where = where .. string.format(", %s %s", MoneyNormalization(price.cost), CP.DB.GetMoneyName(price.type))
		end
		res[item_id] = what.." - "..where
	end
	return res
end

function Search.FindInRecipes(item_id)
	local recipe = CP.DB.GetRecipeOfItem(item_id)
	if not recipe then return end
	local where = string.format(CP.L.SEARCH_MADE, CP.Pimp.GenerateSimpleLink(recipe))
	return {recipe,where}
end

function Search.ApplySuitOfItem(item_id)
    local _, suit_id = CP.DB.GetItemInfo(item_id)
    if not suit_id then return end
    Search.ApplySuit(suit_id)
end

function Search.ApplySuit(suit_id)
    local set_items = CP.DB.GetSuitItems(suit_id)
    if not set_items then return end

    for _,item_id in ipairs(set_items) do
        Search.ApplyItem(item_id)
    end

    CPSearch:Hide()
end

function Search.OnTakeIt(slot1or2,dont_close)

    if not Search.selection then return end
    Search.ApplyItem(Search.selection, slot1or2)

    if not dont_close then CPSearch:Hide() end
end

function Search.OnTakeItEnter(this, item_id)
	local item = Search.slots[item_id]
	if item then
		GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -10, 0)
		GameTooltip:SetHyperLink(CP.Pimp.GenerateLink(item))
	end
end

function Search.OnTakeItLeave(item_id)
	GameTooltip1:Hide()
	GameTooltip2:Hide()
	GameTooltip:Hide()
end

function Search.ApplyItem(item_id, slot1or2)

    local slot
    if slot1or2 then
        local s1,s2 = CP.DB.GetItemPositions(item_id)
        slot = slot1or2==2 and s2 or s1
    else
        slot = CP.FindSlotForItem(item_id)
    end

    local item_data = Search.GetPimpedItemData(item_id)
    CP.ApplyItem(item_data, slot, false)
end

function Search.GetPimpedItemData(item_id)

    local item_data = CP.DB.GenerateItemDataByID(item_id)
    item_data.plus = UIDropDownMenu_GetSelectedValue(CPSearchFilterPlus) or 0
    item_data.tier = UIDropDownMenu_GetSelectedValue(CPSearchFilterTier) or 0

    if CPSearchPowerModify:IsChecked() then
        item_data.dura = OVERDURA
        item_data.max_dura = CP.DB.CalcMaxDura(item_data.id, OVERDURA)
    end

    return item_data
end

function Search.OnCancel()
    CPSearch:Hide()
end
