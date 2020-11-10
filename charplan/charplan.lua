--[[
    CharPlan

Notes:
- gibt es items die auf rassen/geschlecht begrenzt sind, oder z.B. ein minimum an STR brauchen?
   (gibt es in der DB..die frage ist ob ich die besser rausschmeisse)
]]


local CP = {}
_G.Charplan = CP

CP.version       = "v7.4.0"
CP.Prefix = "CP: "

-- some constances
CP.MAX_PLUS=30
CP.MAX_TIER=20
CP.MAX_LEVEL=102

------------------------------
SLASH_charplan1="/cp"
SLASH_charplan2="/charplan"
SlashCmdList["charplan"] = function(_,msg)

    ToggleUIFrame(CPFrame)
end

------------------------------

local WaitTimer = LibStub("WaitTimer")
local Nyx = LibStub("Nyx")

Nyx.LoadLocalesAuto("interface/addons/charplan/locales/")
Nyx.LoadFile("interface/addons/charplan/locales/default.lua")

function CP.Debug(txt)
    --[===[@debug@
    DEFAULT_CHAT_FRAME:AddMessage("CP: "..txt,1,0.5,0.5)
    --@end-debug@]===]
end

function CP.Output(txt)
    DEFAULT_CHAT_FRAME:AddMessage(txt,1,0.5,0.5)
end

function CP.OnLoad(this)
    UIPanelBackdropFrame_SetTexture( this, "Interface/Common/PanelCommonFrame", 256 , 256 )

    CP.Unit.Init(this)
    CP.RegisterEvent("VARIABLES_LOADED", CP.VARIABLES_LOADED)
 end

function CP.RegisterEvent(event, fct)
    CP.events = CP.events or {}
    assert(not CP.events[event]) -- rework if required
    CP.events[event]=fct
    CPFrame:RegisterEvent(event)
end

function CP.OnEvent(this,event)
    assert(CP.events[event])
    CP.events[event](this)
end

function CP.OnShow(this)

    CP.Unit.ReadCurrent()

    CPFrameMenuBtn:SetText(CP.L.MENU_TITLE)
    CP.UpdateClassBotton()
    CP.UpdateFrameTitle()

    CP.DB.Load()
    CP.Calc.Init()

    CP.UpdateEquipment()
    CP.ModelShow()

	CP.PlayerTitle()

    local att=CP.Calc.STATS
    for id,frame in pairs(CP.AttributeFields) do
        assert(att[id], "stat:"..id.." not defined "..frame:GetName())
    end
end

function CP.PlayerTitle()
	local _, szTitle = CP.Unit.GetCurrentTitle()
    CPAttributePlayerTitle:SetText(szTitle)
end

function CP.UpdateFrameTitle()
    local stored = CP.Storage.GetLoadedName()
    local name = "CharPlan "..CP.version.." - " .. (stored or CP.L.TITLE_EMPTY)

    CPFrameTitle:SetText(name)
end

function CP.OnHide()
    CP.DB.Release()
    CP.Calc.Release()

    CP.Stats=nil
end

function CP.VARIABLES_LOADED()
    CP.Items = {}

    CP.ori_Hyperlink_Assign = Hyperlink_Assign
    Hyperlink_Assign = CP.Hooked_Hyperlink_Assign

    CP.Storage.Init()

    CP.Register3rdParty()

end

function CP.Register3rdParty()
    if AddonManager then
        local addon = {
            name         = "CharPlan",
            description  = "Plan&Pimp your toon equipment",
            author       = "McBen, 19Lestat88",
            icon         = "interface/AddOns/charplan/icon.dds",
            category     = "Inventory",
            slashCommands= "/cp",
            version      = CP.version,
            configFrame  = CPFrame,
            miniButton   = CharplanMiniButton,
        }
        AddonManager.RegisterAddonTable(addon)
    end

    if XBARVERSION and XBARVERSION>=1.51 then
        XAddon_Register({
            popup={{
                icon = "interface/AddOns/charplan/icon.dds",
                GetText = function() return "CharPlan" end,
                GetTooltip = function() return "Plan&Pimp your toon equipment" end,
                OnClick = function(this, key) ToggleUIFrame(CPFrame) end,
        }}});
    end
end

local function FindSkin(path, id)
    local skins = CP.DB.FindItemsOfIcon(path)
    for _, skin in ipairs(skins) do
        if skin == id then return nil end
    end
    if #skins>1 then
        CP.Output(string.format(CP.L.ERROR_SEARCH_SKIN, CP.DB.GetItemName(id)))
    end
    return skins[1]
end

function CP.ApplyBagItem(inv_slot, bag_slot, hidden)

    local icon = GetGoodsItemInfo( bag_slot )
    local link = GetBagItemLink( bag_slot )
    assert(icon~="" and link)

    local item_data = CP.Pimp.ExtractLink(link)
    item_data.icon = icon
    item_data.skin = FindSkin(icon, item_data.id)

    CP.ApplyItem(item_data, inv_slot, hidden)
end


function CP.ApplyLinkItem(link, inv_slot, hidden)
    local item_data = CP.Pimp.ExtractLink(link)

    inv_slot = inv_slot or CP.FindSlotForItem(item_data.id)
    CP.ApplyItem(item_data, inv_slot, hidden)
end


function CP.ApplyItem(item_data, inv_slot, hidden)
    assert(CP.EquipButtons[inv_slot])

    if not CP.DB.IsItemAllowedInSlot(item_data.id, inv_slot) then
        CP.Debug(string.format("item not allowed in that slot: %i - %s slot:%i",item_data.id,CP.DB.GetItemName(item_data.id),inv_slot))
        return
    end

    if CP.DB.IsWeapon2Hand(item_data.id) then
        CP.Items[16]=nil
        if inv_slot==16 then inv_slot=15 end
    end

    local old_data = CP.Items[inv_slot]
    if old_data and CP.Pimp.IsItemPimped(old_data) and not CP.Pimp.IsItemPimped(item_data) then
        CP.Pimp.CopyItemEnchancement(CP.Items[inv_slot], item_data)
    end

    CP.Items[inv_slot] = item_data

    if not hidden then
        CP.UpdateEquipment()
    end
end

function CP.UseSkin(item_id, inv_slot)
    if not CP.Items[inv_slot] then
        return
    end

    if CP.Items[inv_slot].id == item_id then
        CP.Items[inv_slot].skin = nil
    else
        CP.Items[inv_slot].skin = item_id
    end

    CP.UpdateModel()
end

function CP.ClearItem(inv_slot, hidden)
    CP.Items[inv_slot]=nil

    if not hidden then
        CP.UpdateEquipment()
    end
end

function CP.HasItems()
    for slot=0,21  do
        if CP.Items[slot] then return true end
    end
end

function CP.FindSlotForItem(item_id)
    local s1,s2, force1 = CP.DB.GetItemPositions(item_id)

    if not force1 and CP.Items[s1] and s2 and not CP.Items[s2] then
        return s2
    end

    return s1
end


function CP.UpdateEquipment()
    for id, button in pairs(CP.EquipButtons) do
       SetItemButtonTexture(button, CP.GetSlotTexture(id))
    end

    CP.UpdateModel()
    CP.UpdatePoints()
end

function CP.GetSlotTexture(slot)
    local item = CP.Items[slot]
    if item and item.icon then
        return item.icon
    else
        return  CP.EquipButtons[slot].backgroundTextureName
    end
end

function CP.UpdatePoints()

    CP.Stats = CP.Calc.Calculate()


    for id,frame in pairs(CP.AttributeFields) do
        ctrl1 = _G[frame:GetName().."Value"]
        ctrl1:SetText(math.floor(CP.Stats[id]))

        ctrl2 = _G[frame:GetName().."DifValue"]
        if CP.compare_stats then
            local dif = CP.Stats[id]-CP.compare_stats[id]

            if dif<0 then
                ctrl2:SetText(math.floor(dif))
                ctrl2:SetColor(1,0.2,0.2)
                ctrl2:Show()
            elseif dif>0 then
                ctrl2:SetText("+"..math.floor(dif))
                ctrl2:SetColor(0.0,0.9,0.0)
                ctrl2:Show()
            else
                ctrl2:Hide()
            end
        else
            ctrl2:Hide()
        end
    end
end

function CP.PimpStart(slot)
    local data = CP.Items[CPEquipButtonMenu.Slot]
    assert(data)
    CP.Pimp.PimpItem( data )
end

function CP.PimpFinished()
    CP.UpdatePoints()
end

function CP.PimpUpdate()

    new_vals = CP.Calc.Calculate()

    local att=CP.Calc.STATS

    for id,frame in pairs(CP.AttributeFields) do
        ctrl = _G[frame:GetName().."Value"]

        local old, new = CP.Stats[att[id]] or 0 , new_vals[att[id]]  or 0
        if old > new then
            ctrl:SetText("|cffff2020"..math.floor(new))
        elseif old < new then
            ctrl:SetText("|cff20ff20"..math.floor(new))
        else
            ctrl:SetText(math.floor(new))
        end
    end
end


local ModelParts={
        [0]="helmet",
        [1]="hand",
        [2]="foot",
        [3]="torso",
        [4]="leg",
        [5]="back",
        [6]="belt",
        [7]="shoulder"
}

function CP.ColorEdit(slot, base_color)

    assert(ModelParts[slot])

    local name = TEXT(string.format("SYS_EQWEARPOS_%02i",slot)) .. " - "
    local cidx = 1
    local col = CP.Items[slot].color or {}

    if base_color then
        name = name .. C_MAIN_COLOR
    else
        name = name .. C_SUB_COLOR
        cidx = 4
    end

    local info={
        parent = CPFrame,
        titleText = name,
        alphaMode = nil,
        r = col[cidx] or 1,
        g = col[cidx+1] or 1,
        b = col[cidx+2] or 1,

        callbackFuncUpdate = function ()
            	local r=ColorPickerFrame.r
	            local g=ColorPickerFrame.g
	            local b=ColorPickerFrame.b
                if base_color then
                    CPEquipmentFrameModel:SetComponentColors(ModelParts[slot],r,g,b,col[4] or 1,col[5] or 1,col[6] or 1)
                else
                    CPEquipmentFrameModel:SetComponentColors(ModelParts[slot],col[1] or 1,col[2] or 1,col[3] or 1,r,g,b)
                end
                CPEquipmentFrameModel:Build()
            end,

        callbackFuncOkay = function ()
            col[cidx],col[cidx+1],col[cidx+2]=ColorPickerFrame.r, ColorPickerFrame.g, ColorPickerFrame.b
            CP.Items[slot].color = col
        end,

        callbackFuncCancel = CP.UpdateModel,
    }

	ColorPickerFrame:ClearAllAnchors()
	ColorPickerFrame:SetAnchor("LEFT", "RIGHT",CPFrame:GetName(), -20,0)

    OpenColorPickerFrameEx( info )
end

function CP.OnModelLoad(this)
    CommonModel_OnLoad(this)

    this.top = "p_top";
    this.bottom = "p_down";
    this.bias_default   = 0.5;
    this.scale_default  = 0.44;

    this.bias_max       = 1.50;
    this.bias_min       = -0.50;
end

function CP.ModelShow()
  local model = CPEquipmentFrameModel
  model:SetUnit("player")
  model:InserLinkFrame("p_top",0,20,0)
  model:InserLinkFrame("p_down",0,0,0)
  model:Show()

  model:SetCameraPosition(0, 0.10, -1.2)
  model:SetTargetRotate(0)
  CP.UpdateModel()
end

function CP.UpdateModel()
    local model = CPEquipmentFrameModel

    model:TakeOffAll()
    model:TakeOffWeapon()
    for _,slot in ipairs({0,1,2,3,4,5,6,7,21,10,15,16}) do
        if CP.Items[slot] then
            local link
            if CP.Items[slot].skin then
                link = CP.Pimp.GenerateLinkByID(CP.Items[slot].skin)
            else
                link = CP.Pimp.GenerateLink(CP.Items[slot])
            end
            model:SetItemLink(link)

            local col = CP.Items[slot].color
            if col then
                CPEquipmentFrameModel:SetComponentColors(ModelParts[slot],col[1] or 1,col[2] or 1,col[3] or 1,col[4] or 1,col[5] or 1,col[6] or 1)
            end
        end
    end

    --model:Build()
end


-----------------------------------
-- Menu
function CP.OnMenuLoad(this)
    UIDropDownMenu_Initialize( this, CP.OnMenuShow, "MENU")
end

function CP.OnMenuShow(this)
	local info
    local save_list = CP.Storage.GetSavedList()
    local loaded_name = CP.Storage.GetLoadedName()
    local is_empty = not CP.HasItems()

	if( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then

		info = {notCheckable = 1}
		info.text = CP.L.MENU_IMPORT
        info.func = function() CP.Storage.LoadCurrentEquipment() end
		UIDropDownMenu_AddButton( info, 1 )

        info = {notCheckable = 1, hasArrow = 1}
        info.text = CP.L.MENU_LOAD
        info.disabled = (#save_list==0)
        info.value="load"
        UIDropDownMenu_AddButton( info, 1 )

        info = {notCheckable = 1, hasArrow = 1}
        info.text = CP.L.MENU_COMPARE
        info.disabled = (#save_list==0)
        info.value="compare"
        UIDropDownMenu_AddButton( info, 1 )

        info = {notCheckable = 1}
        info.text = CP.L.MENU_SAVE
        info.disabled = is_empty
        info.func = function() CP.Storage.SaveItems(loaded_name) end
        UIDropDownMenu_AddButton( info, 1 )

        info = {notCheckable = 1}
        info.text = CP.L.MENU_SAVEAS
        info.disabled = (is_empty or loaded_name==nil)
        info.func = function() CP.Storage.SaveItems() end
        UIDropDownMenu_AddButton( info, 1 )

        info = {notCheckable = 1, hasArrow = 1}
        info.text = CP.L.MENU_DEL
        info.disabled = (#save_list==0)
        info.value="del"
        UIDropDownMenu_AddButton( info, 1 )

		info = {notCheckable = 1}
		info.text = CP.L.MENU_CLEARALL
        info.disabled = is_empty
		info.func = function()
                CP.Items={}
                CP.UpdateEquipment()
			end
		UIDropDownMenu_AddButton( info, 1 )

    elseif( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then

        for _,name in ipairs(save_list) do
            info = {notCheckable = 1}
            info.text = name

            if UIDROPDOWNMENU_MENU_VALUE=="load" then
                info.func = function() CP.Storage.LoadItems(name) CloseDropDownMenus() end
            elseif UIDROPDOWNMENU_MENU_VALUE=="compare" then
                info.notCheckable=nil
                if name==CP.compare_equipname then
                    info.checked=1
                    info.func = function() CP.CompareEquipClear() CloseDropDownMenus() end
                else
                    info.func = function() CP.CompareEquipSet(name) CloseDropDownMenus() end
                end
            elseif UIDROPDOWNMENU_MENU_VALUE=="del" then
                info.func = function() CP.Storage.DeleteItems(name) CloseDropDownMenus() end
            end
            UIDropDownMenu_AddButton( info, 2 )
        end
    end
end

function CP.CompareEquipClear(name)
    CP.compare_equipname=nil
    CP.compare_stats=nil
    CP.UpdatePoints()
end

function CP.CompareEquipSet(name)
    CP.compare_equipname=name
    CP.compare_stats=CP.Storage.CalcStatsOf(name)
    CP.UpdatePoints()
end

function CP.Hooked_Hyperlink_Assign(link, key)
	CP.ori_Hyperlink_Assign(link, key)
	if (key ~= "RBUTTON" ) then return 	end

	local _type, _data, _ = ParseHyperlink(link)
	if _type ~= 'item' then
        return
    end

    local itemID = tonumber(_data:match("^(%x+)") or '', 16)

    -- prevent adding menu to unacceptable items
    if not (itemID and itemID > 210000 and itemID < 240000) then
        return
	end

    local menu_label = "|cffb0b030[CharPlan]|r " .. CP.L.CONTEXT_MENU;
    if not CP.DB.IsLoaded() then
        -- a simple method if dialog is not open (performance)
        local info = {}
        info.text = menu_label
        info.notCheckable = 1
        info.func = function()
            CP.DB.Load()
            local item_data = CP.Pimp.ExtractLink(link)
            local inv_pos = CP.FindSlotForItem(item_data.id)
            if inv_pos then
                CP.ApplyItem(item_data, inv_pos,true)
            else
                CP.Output(CP.L.ERROR_NO_VALID_ITEM)
            end
            CP.DB.Release()
        end
        UIDropDownMenu_AddButton(info, 1)

    else

        local item_data = CP.Pimp.ExtractLink(link)
        local s1,s2, force1 = CP.DB.GetItemPositions(item_data.id)
        if force1 then s2=nil end

        if s1 then
            local info = {}
            info.notCheckable = 1
            info.text = menu_label
            if s2 then info.text = menu_label .. " - "..CP.L.SEARCH_USE_SLOT1 end
            info.func = function()
                CP.DB.Load()
                CP.ApplyItem(item_data, s1)
                CP.DB.Release()
            end
            UIDropDownMenu_AddButton(info, 1)
        end

        if s2 then
            local info = {}
            info.notCheckable = 1
            info.text = menu_label .. " - "..CP.L.SEARCH_USE_SLOT2
            info.func = function()
                CP.DB.Load()
                CP.ApplyItem(item_data, s2)
                CP.DB.Release()
            end
            UIDropDownMenu_AddButton(info, 1)
        end
    end

    -- show drop source
    -- CP possible not loaded, so delay item search
    local info = {}
    info.notCheckable = 1
    info.text = "|cffb0b030[CharPlan]|r " .. "from..."
    info.func = function(button)
        local drop = CP.Search.FindInDungeonLoots(itemID) or {}
        for _,text in pairs(drop) do
            DEFAULT_CHAT_FRAME:AddMessage(link .. ' ' .. text)
        end
        -- do not show rest of sources?
        if drop and #drop > 0 then return end
        CP.DB.Load()
        drop = CP.Search.FindInShops(itemID) or {}
        for _,text in pairs(drop) do
            DEFAULT_CHAT_FRAME:AddMessage(link .. ' ' .. text)
        end
        drop = CP.Search.FindInRecipes(itemID)
        if drop then
            local text = drop[2]
            DEFAULT_CHAT_FRAME:AddMessage(text)
        end
        CP.DB.Release()
    end
    UIDropDownMenu_AddButton(info, 1)

    UIDropDownMenu_Refresh(ChatFrameDropDown)
end

function CP.PostItemLink(item_data)
    local link = item_data
    if type(item_data) == 'table' then
        link = CP.Pimp.GenerateLink(item_data, CP.Prefix)
    end
    if not ChatEdit_AddItemLink(link) and not DEFAULT_CHAT_EDITBOX:IsVisible() then
        DEFAULT_CHAT_FRAME:AddMessage(link)
    end
end

-----------------------------------
-- EquipItem Buttons
function CP.EquipItem_OnLoad(this)
    CP.EquipButtons = CP.EquipButtons or {}

    this:RegisterForClicks("LeftButton", "RightButton")

    local slotName = string.sub(this:GetName(), string.len("CPEquipmentFrameEquip")+1)
	local slotId
    slotId, this.backgroundTextureName = GetInventorySlotInfo(slotName)
    assert(slotId,slotName..":"..tostring(slotId))
    this:SetID(slotId)
    CP.EquipButtons[slotId]=this
end


function CP.EquipItem_OnEnter(this)
    local item = CP.Items[this:GetID()]

    if item then
        GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -10, 0)
        GameTooltip:SetHyperLink(CP.Pimp.GenerateLink(item))
    end
end


function CP.EquipItem_OnLeave(this)
    GameTooltip1:Hide()
    GameTooltip2:Hide()
    GameTooltip:Hide()
end


function CP.EquipItem_OnReceiveDrag( this )

    local from = CursorItemType()
    local pos=GetCursorItemInfo()
    if not from or not pos then return end

    if from~="bag" and from~="bank" then
        CP.Debug("Drag from '"..from.."' not supported")
        return
    end

    local data=
    {
        from = from,
        pos = pos,
        slot = this:GetID()
    }

    WaitTimer.Delay(0.1, CP.WaitForItemLink,"CP_ITEMDROPER", data )
    ItemClipboard_Clear()
end


function CP.WaitForItemLink(data)

    local link
    if data.from == "bag" then      link = GetBagItemLink(data.pos)
    elseif data.from == "bank" then link = GetBankItemLink(data.pos)
    else
        CP.Debug("Illegal WaitForItemLink data")
        return
    end

    if not link then return 0.1 end

	CP.ApplyLinkItem(link, data.slot)
end



function CP.EquipItem_OnClick(this, key)

    if CursorItemType() then
        CP.EquipItem_OnReceiveDrag( this )
        return
    end

    if( key == "RBUTTON") then
        GameTooltip:Hide()
        CPEquipButtonMenu.Slot = this:GetID()
        ToggleDropDownMenu(CPEquipButtonMenu, 1,nil,"cursor", 1 ,1 )
    else
        local item_data = CP.Items[this:GetID()]
        if item_data then
			if( IsShiftKeyDown() ) then
                CP.PostItemLink(item_data)
			elseif(IsCtrlKeyDown()) then
				CP.Search.ShowSearch(this:GetID(),item_data.id)
			else
				CP.Pimp.PimpItem(item_data)
			end
        else
            CP.Search.ShowSearch(this:GetID())
        end
     end
end

function CP.EquipItem_ShowMenu( this )

    local info = {}
    info.notCheckable = 1

    if( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
        local data = CP.Items[CPEquipButtonMenu.Slot]

        info.text = CP.L.CONTEXT_PIMPME
        info.func = function() CP.PimpStart(CPEquipButtonMenu.Slot) end
        info.disabled = not data
        UIDropDownMenu_AddButton(info)

        info.text = CP.L.CONTEXT_SEARCH
        info.func = function() CP.Search.ShowSearch(CPEquipButtonMenu.Slot) end
        info.disabled = nil
        UIDropDownMenu_AddButton(info)

        info.text = CP.L.CONTEXT_SHARE
        info.disabled = not data or CP.DB.IsWeaponSlot(CPEquipButtonMenu.Slot)
        info.hasArrow = not info.disabled
        UIDropDownMenu_AddButton(info)

        info.text = C_MAIN_COLOR
        info.hasArrow = nil
        info.func = function() CP.ColorEdit(CPEquipButtonMenu.Slot,true) end
        info.disabled = not data or not ModelParts[CPEquipButtonMenu.Slot]
        UIDropDownMenu_AddButton(info)

        info.text = C_SUB_COLOR
        info.func = function() CP.ColorEdit(CPEquipButtonMenu.Slot,false) end
        info.disabled = not data or not ModelParts[CPEquipButtonMenu.Slot]
        UIDropDownMenu_AddButton(info)

        UIDropDownMenu_AddSeparator()

        info.text = CP.L.CONTEXT_CLEAR
        info.func = function() CP.ClearItem(CPEquipButtonMenu.Slot) end
        info.disabled = not data
        UIDropDownMenu_AddButton(info)

    elseif( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
        local data = CP.Items[CPEquipButtonMenu.Slot]
        CP.Pimp.FillCopyMenu(2, data)
    end
end

-----------------------------------
-- Attribute fields
function CP.Attribute_OnLoad( this )
    CP.AttributeFields=CP.AttributeFields or {}

    local name = string.sub(this:GetName(), string.len("CPAttributeFrameValue")+1)
    CP.AttributeFields[name]= this
    this:SetID(CP.Calc.STATS[name])

    _G[this:GetName().."Label"]:SetText(CP.L.STAT_NAMES[name])
end


function CP.Attribute_OnEnter(this)
    GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT", -10, 0)

    local stat_id = this:GetID()
    local stat = CP.Calc.ID2StatName(stat_id)

    local txt = string.format("%s%s%s (%i)", NORMAL_FONT_COLOR_CODE,
    CP.L.STAT_NAMES[stat], FONT_COLOR_CODE_CLOSE, CP.Stats[stat_id] or 0)

	GameTooltip:SetText(txt)
    local left,right = CP.Calc.Explain(stat_id)
    for i=1,#(left) do
        if left[i]~="" then
            GameTooltip:AddDoubleLine(left[i], right[i])
        else
            GameTooltip:AddSeparator()
        end
    end

	GameTooltip:Show()
end


function CP.AttributeTitle_OnLoad( this )

    local name = string.sub(this:GetName(), string.len("CPAttributeTitle")+1)
    _G[this:GetName().."Label"]:SetText(CP.L.STAT_NAMES[name])

end






-----------------------------------
-- Pet Button
function CP.PetButtonUpdate()

    if CP.Unit.GetPet() then
        CPFramePetEggButtonIcon:SetTexture("Interface\\PetFrame\\PetEggButton-Type01")
        CPFramePetEggButton:LockHighlight()
    else
		CPFramePetEggButtonIcon:SetTexture("Interface\\PetFrame\\PetEggButton-Empty")
        CPFramePetEggButton:UnlockHighlight()
    end
end

function CP.PetButton_OnEnter(this)
    local pet = CP.Unit.GetPet()
    if pet then
		local name = GetPetItemName(pet)
		local propText = PET_PROPERTY_TEXT[ GetPetItemProperty(pet) ]

		local petlv = GetPetItemLevel( pet )

		if name then
			local temp = "|cfffff482"..name.."|r |cff0EBFff( "..propText.." ) |r".."("..petlv..")"
			GameTooltip:SetOwner( this, "ANCHOR_TOPRIGHT", 0, 0 )
			GameTooltip:SetText( temp )
		end
    end
end

function CP.OnEggMenuLoad(this)
    UIDropDownMenu_Initialize( this, CP.OnEggMenuShow, "MENU")
end

function CP.OnEggMenuShow(this)
    local info = {}

    info.text = "no Pet"
    info.func = function() CP.Unit.SetPet() CP.PetButtonUpdate() CP.UpdatePoints() end
    UIDropDownMenu_AddButton( info, 1 )

    local cur_pet = CP.Unit.GetPet()
    for id = 1,PET_FRAME_NUM_ITEMS do

        if HasPetItem(id) then
    		local name = GetPetItemName(id)
	    	local propText = PET_PROPERTY_TEXT[ GetPetItemProperty(id) ]
    		local petlv = GetPetItemLevel( id )

            info.text = name.." lvl "..petlv.." |cff0EBFff("..propText..")|r"
            info.checked = (id==cur_pet)
            info.func = function() CP.Unit.SetPet(id) CP.PetButtonUpdate() CP.UpdatePoints() end
            UIDropDownMenu_AddButton( info, 1 )
        end
	end

end
