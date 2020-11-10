--[[
    CharPlan

    Mangament for stored item collections
]]

local Storage = {}
local CP = _G.Charplan
CP.Storage = Storage

CP_Storage={}

local WaitTimer = LibStub("WaitTimer")


function Storage.Init()
    SaveVariablesPerCharacter("CP_Storage")
end


function Storage.GetSavedList()
    local list = {}
    for name,_ in pairs(CP_Storage) do
        table.insert(list,name)
    end
    return list
end


function Storage.GetLoadedName()
    return Storage.LoadedItems
end


local function DefaultsClear(items)
end

local function DefaultsRestore(items)
end

function Storage.SaveItems(name)
    if not name then
        StaticPopupDialogs["CP_INPUT_SAVE_NAME"] = {
            text = CP.L.DLG_SAVENAME,
            button1 = TEXT("ACCEPT"),
            button2 = TEXT("CANCEL"),
            OnShow = function(this)
                _G[this:GetName().."EditBox"]:SetText(Storage.SaveSuggestion())
                _G[this:GetName().."EditBox"]:HighlightText()
            end,
            OnAccept = function(this)
                local name = getglobal(this:GetName().."EditBox"):GetText()
                CP.Storage.SaveItems(name)
            end,
            EditBoxOnEnterPressed = StaticPopup_EnterPressed,
            hasEditBox = 1,
            hideOnEscape = 1
        }
        StaticPopup_Show("CP_INPUT_SAVE_NAME")
        return
    end

    Storage.LoadedItems = name
    CP_Storage[name]={}
    CP.Utils.TableCopy(CP.Items,CP_Storage[name])
    DefaultsClear(CP_Storage[name])
    CP_Storage[name].unit={}
    CP.Unit.Store(CP_Storage[name].unit)

    CP.UpdateFrameTitle()
end

function Storage.SaveSuggestion()
    local name = CP.Unit.name
    local i = 1
    while CP_Storage[name] do
        name = CP.Unit.name.."_"..i
        i = i +1
    end

    return name
end

function StoreageVersionUpdate()
    for _,data in pairs(CP.Items) do
        if data.rune_slots then
            data.max_runes = data.rune_slots
            data.rune_slots=nil
        end
    end

    if not CP.Unit.name then
        CP.Unit.ReadCurrent()
    end
end

function Storage.LoadItems(name)
    assert(CP_Storage[name])

    Storage.LoadedItems = name
    CP.Utils.TableCopy(CP_Storage[name], CP.Items)
    DefaultsRestore(CP.Items)
    CP.Items.unit=nil
    CP.Unit.Load(CP_Storage[name].unit)
    StoreageVersionUpdate()

    CP.UpdateFrameTitle()
    CP.UpdateEquipment()
end

function Storage.DeleteItems(name)
    assert(CP_Storage[name])

    if Storage.LoadedItems == name then
        Storage.LoadedItems = nil
    end

    CP_Storage[name] = nil
end

function Storage.CalcStatsOf(name)
    local temp_items = CP.Utils.TableCopy(CP.Items)
    local temp_unit={}
    CP.Unit.Store(temp_unit)

    CP.Utils.TableCopy(CP_Storage[name], CP.Items)
    CP.Items.unit=nil
    CP.Unit.Load(CP_Storage[name].unit)

    local res = CP.Calc.Calculate()

    CP.Utils.TableCopy(temp_items, CP.Items)
    CP.Unit.Load(temp_unit)

    return res
end
-----------------------------------
-- Inventory getter
function Storage.LoadCurrentEquipment()
    if Storage.InvGetPhase then
        return
    end

    Storage.StripSlot = Storage.FindFreeSlot()

    if not Storage.StripSlot then
        DEFAULT_CHAT_FRAME:AddMessage(CP.L.ERROR_NOSLOT)
        return
    end

    Storage.InvGetPhase=0
    Storage.InvLastItem=-1
    Storage.MaxDelay = 2

    StaticPopupDialogs["CP_LOADS_INV"] = {
	    text = CP.L.DLG_WAIT_INV,
        button1 = TEXT("CANCEL"),
        OnAccept = function(this)
            CP.Storage.InvGetCancel = true
        end,
        exclusive = 1,
	    hideOnEscape = 1,
    }
    StaticPopup_Show("CP_LOADS_INV")

    CP.Items={}

    Storage.Timer = WaitTimer.Delay(0.1, Storage.OnUpdate)

    CP.Unit.SetPet(CP.Unit.GetSummonedPet())
    CP.PetButtonUpdate()
end


function Storage.FindFreeSlot()
    local _, availableSlots, totalSlots = GetBagCount()
    if availableSlots==0 then return end

    for bagIndex=1,totalSlots  do
        local slot_idx, icon = GetBagItemInfo ( bagIndex )
        if icon == "" then
          local let, letTime = GetBagPageLetTime(math.ceil(bagIndex/30));
          if not let or letTime > -1 then
            return slot_idx
          end
        end
    end
end

function Storage.InventoryStopStrip(msg)
    assert(Storage.InvGetPhase)

    if msg then
        DEFAULT_CHAT_FRAME:AddMessage(msg,1,0,0)
    end

    StaticPopup_Hide("CP_LOADS_INV")

    WaitTimer.Stop(Storage.Timer)

    Storage.InvGetPhase=nil
    Storage.StripSlot=nil
    Storage.InvLastItem=nil
    Storage.InvGetCancel=nil

    CP.UpdateEquipment()
end


function Storage.OnUpdate()
    Storage.MaxDelay = Storage.MaxDelay-0.1

    if Storage.MaxDelay<0 then
        Storage.InventoryStopStrip(CP.L.ERROR_PICKEDUPITEM)
        return
    end

    local phases={Storage.InvPickInv, Storage.InvDropInv, Storage.InvPickBag, Storage.InvDropBag}
    if phases[Storage.InvGetPhase+1]() then
        Storage.InvGetPhase = (Storage.InvGetPhase +1)%4
        Storage.MaxDelay = 2
    end

    return 0.1
end


function Storage.InvPickInv()
    if Storage.InvGetCancel then
        Storage.InventoryStopStrip(CP.L.ENUMERATE_CANCELED)
        return
    end

    Storage.InvLastItem = Storage.InvLastItem+1
    while not CP.EquipButtons[Storage.InvLastItem] or
        GetInventoryItemInvalid("player",Storage.InvLastItem) or
        not GetInventoryItemTexture("player",Storage.InvLastItem)
            do
        Storage.InvLastItem = Storage.InvLastItem+1
        if Storage.InvLastItem > 21 then
            Storage.InventoryStopStrip()
            return
        end
    end

    EquipItem(Storage.InvLastItem+1,Storage.StripSlot)
    return true
end

function Storage.InvDropInv()
    local texture = GetGoodsItemInfo(Storage.StripSlot)
    if texture == "" then return end

    return true
end

function Storage.InvPickBag()
    CP.ApplyBagItem(Storage.InvLastItem, Storage.StripSlot, true)

    EquipItem(Storage.InvLastItem+1,Storage.StripSlot)
    return true
end

function Storage.InvDropBag()
    local texture = GetGoodsItemInfo(Storage.StripSlot)
    if texture ~= "" then return end

    return true
end



