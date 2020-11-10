local me = {
  itemList = {}, --
  debug = false,
}

function me.onLoad(this)
  this:RegisterEvent('HOUSES_STORAGE_SHOW');
  this:RegisterEvent('HOUSES_FURNITURE_CHANGED');
  this:RegisterEvent('HOUSES_STORAGE_CHANGED')
  this:RegisterEvent('HOUSES_SERVANT_ITEM_CHANGED');
end

function me.onShow()
  me.updateList()
end

function me.onEvent(this, event)
  if not this:IsVisible() then
    return
  end
  me.updateList()
end

function me.getSlotTex(name)
  if type(name) == 'string' then
    local items = {
      [TEXT('Sys201285_name')] = 2, -- Gestell für Männerkleidung
      [TEXT('Sys201286_name')] = 2, -- Gestell für Frauenkleidung
      [TEXT('Sys201292_name')] = 3, -- Schildförmiges Waffenregal
      [TEXT('Sys201293_name')] = 3, -- Kreuzförmiges Waffenregal
      [TEXT('Sys201294_name')] = 3, -- Luxus-Waffenregal
      [TEXT('Sys206228_name')] = 2,
    }
    name = items[name]
  end

  if not name then
    return nil
  end
  local slots = {
    [2] = {
      'Head', 'Hands', 'Feet', 'Chest', --
      'Legs', 'Back', 'Waist', 'Shoulder', --
    }, --
    [3] = { -- weapons
      'MainHand', 'SecondaryHand',
    }, --
    [5] = { -- maid
      'Head', 'Hands', 'Feet', 'Chest', --
      'Legs', 'Back', 'Waist', 'Shoulder', --
      [22] = 'Adornment'
    },
  }
  if not slots[name] then
    return nil
  end
  local slotTex = {}
  for _, name in pairs(slots[name]) do
    local id, texture = GetInventorySlotInfo(name .. 'Slot')
    if id then
      slotTex[id + 1] = texture
    end
  end
  if name==5 then
    for i=31,40 do
      slotTex[i] = ''
    end
  end
  return slotTex
end

function me.getItems(name, id, isMaid)
  local tmp = {}
  if id then
    local itemCount, _, index = Houses_GetItemInfo(id, -1)

    local put = Houses_GetFriendPut(id)
    local get = Houses_GetFriendGet(id)
    local view = Houses_GetFriendView(id)

    if me.debug or Houses_IsOwner() or (Houses_IsFriend() and view) then
      local slotTex = me.getSlotTex(isMaid and 5 or name)
      for j = 1, itemCount do
        if slotTex == nil or slotTex[j] then
          local itemIcon, itemName, itemCount, itemLocked, itemQuality = Houses_GetItemInfo(id, j)
          table.insert(tmp, {
            chestID = id, --
            itemIndex = j, --
            furnitureIndex = i, --
            furnitureName = name or 'unk', --
            --
            name = itemName or '', --
            count = itemCount or 0, --
            icon = itemIcon or (slotTex and slotTex[j]) or '', --
            quality = itemQuality or 0, --
            rightPut = put, --
            rightGet = get, --
            rightView = view, --
          })
          if isMaid and #tmp==9 then -- add spacer
            table.insert(tmp, {hidden=true})
          end
        end
      end
    end
  end
  return tmp
end
function me.updateList()
  local count = Houses_GetFurnitureItemInfo(-1) or 0
  local tmp = {}
  for i = 1, count do
    local isActive, name, icon, placed, id = Houses_GetFurnitureItemInfo(i)
    table.insert(tmp, me.getItems(name, id, false))
  end
  for i = 1, Houses_GetServantCount() or 0 do
    local id, name = Houses_GetServantInfo(i)
    table.insert(tmp, me.getItems(name, id, true))
  end
  me.itemList = {}
  local hidden = {hidden = true}
  for _, chest in ipairs(tmp) do
    for _, data in ipairs(chest) do
      table.insert(me.itemList, data)
    end
    if #chest % 10 ~= 0 then
      for i = 1, 10 - (#chest % 10) do
        table.insert(me.itemList, hidden)
      end
    end
  end
  me.updateScrollBar()
  me.redrawList()
end
function me.updateScrollBar()
  local list = AdvancedHouseFrameChest
  local scroll = AdvancedHouseFrameChest_scroll
  scroll:SetMinMaxValues(1, math.max(1, math.ceil(#me.itemList / 10) - math.ceil((list.numRow or 0) / 10) + 1))
end
function me.redrawList()
  local scroll = AdvancedHouseFrameChest_scroll
  local list = AdvancedHouseFrameChest
  for i = 1, list.numRow or 0 do
    local btnName = 'AdvancedHouseFrameChest_' .. i
    local index = i + (scroll:GetValue() - 1) * 10
    local data = me.itemList[index]
    local btn = _G[btnName]
    if data and not data.hidden then
      local quality = _G[btnName .. 'Quality']
      if data.quality > 0 then
        quality:SetColor(GetItemQualityColor(data.quality))
        quality:Show()
      else
        quality:Hide()
      end
      local bg = _G[btnName .. 'Overlay']
      if data.rightPut or data.rightGet or data.rightView then
        bg:Show()
        bg:SetColor(data.rightPut and 1 or 0, data.rightGet and 1 or 0, data.rightView and 1 or 0)
      else
        bg:Hide()
      end
      SetItemButtonTexture(btn, data.icon or '');
      SetItemButtonCount(btn, data.count or 0);
      SetItemButtonLuminance(btn, data.locked or false);
      btn.data = data
      btn:Show()
    else
      btn:Hide()
    end
  end
end

function me.onClick(this, key, ignoreShift)
  local chestID = this.data.chestID
  local furnitureIndex = this.data.furnitureIndex
  local itemIndex = this.data.itemIndex
  if key == 'LBUTTON' then
    if IsShiftKeyDown() then
      local itemLink = Houses_GetItemLink(chestID, itemIndex);
      if (ChatEdit_AddItemLink(itemLink)) then
        return;
      end
    elseif (IsCtrlKeyDown()) then
      local itemLink = Houses_GetItemLink(chestID, itemIndex);
      ItemPreviewFrame_SetItemLink(ItemPreviewFrame, itemLink);
      return
    end
    Houses_PickupItem(chestID, itemIndex)
  else
    Houses_DrawItem(chestID, itemIndex)
  end
end
function me.onEnter(this)
  GameTooltip:SetOwner(this, 'ANCHOR_TOPLEFT', -5, 0);
  local data = this.data
  if data.name == '' then
    GameTooltip:SetText('Empty...')
  else
    GameTooltip:SetHouseItem(data.chestID, data.itemIndex);
  end

  GameTooltip:AddSeparator()
  if data.furnitureName ~= '' then
    GameTooltip:AddLine(data.furnitureName)
  end
  if me.debug  then
    GameTooltip:AddLine(string.format('%d - %d', data.chestID, data.itemIndex))
  end
  GameTooltip:AddLine(string.format('%s: %s', HOUSEFRIEND_SET_VIEW_TIPS, data.rightView and C_YES or C_NO))
  GameTooltip:AddLine(string.format('%s: %s', HOUSEFRIEND_SET_GET_TIPS, data.rightGet and C_YES or C_NO))
  GameTooltip:AddLine(string.format('%s: %s', HOUSEFRIEND_SET_PUT_TIPS, data.rightPut and C_YES or C_NO))

  if me.debug  then
    local val = Houses_CanWearObject(data.chestID, data.itemIndex)
    GameTooltip:AddLine(val == true and 1 or val == false and 2 or 3)
  end

  GameTooltip1:Hide()
  GameTooltip2:Hide()
end

function me.onLeave(this)
  GameTooltip:Hide();
end

AdvancedHouse.chest = me
