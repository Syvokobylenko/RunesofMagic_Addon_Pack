local ChestFix = {}
_G.ChestFix = ChestFix

ChestFix_Toggle = {}
ChestFix_NotStackableItems = {}

ChestFix_ForOther = true
ChestFix.Events = {}
ChestFix.EmptySlot = {}
ChestFix.TransferPhase = false
ChestFix.TransferPicked = false
ChestFix.SplitDBID = nil
ChestFix.SplitChestSlot = nil
ChestFix.SplitInvSlot = nil
ChestFix.SplitBagSlot = nil
ChestFix.SplitNumber = nil
ChestFix.SplitNextSlot = nil
ChestFix.SplitNextInvSlot = nil
ChestFix.SplitPhase = false
ChestFix.SplitPlace = false
ChestFix.SplitChestPhase = false
ChestFix.SplitPickupAgain = false
ChestFix.ForeignPlace = false
ChestFix.ForeignInBag = false
ChestFix.ForeignDBID = nil
ChestFix.ForeignChestSlot = nil
ChestFix.Stacking = {
	Done = false,
	Furn = nil,
	ItemSlot = nil,
	OldAmount = nil,
	ItemID = nil,
}

function ChestFix.OnLoad(this)
	this:RegisterEvent("HOUSES_STORAGE_SHOW")
	this:RegisterEvent("HOUSES_STORAGE_CHANGED")
	this:RegisterEvent("BAG_ITEM_UPDATE")
	this:RegisterEvent("VARIABLES_LOADED")
	SaveVariables("ChestFix_NotStackableItems")
	SaveVariablesPerCharacter("ChestFix_Toggle")
	SaveVariablesPerCharacter("ChestFix_ForOther")
end

function ChestFix.Events.VARIABLES_LOADED()
	ChestFix.Init()
end

function ChestFix.Init()
	if not ChestFix_Toggle then ChestFix_Toggle = {} end
	if not ChestFix_NotStackableItems then ChestFix_NotStackableItems = {} end
	if ChestFix_ForOther == nil then ChestFix_ForOther = true end
end

function ChestFix.Events.HOUSES_STORAGE_SHOW()
   	ChestFix.ChestInit()
end

function ChestFix.Events.HOUSES_STORAGE_CHANGED()
	if ChestFix.SplitPickupAgain then
		local NextSlot = ChestFix.SplitNextSlot
		ChestFix.SplitDBID = nil
		ChestFix.SplitChestSlot = nil
		ChestFix.SplitInvSlot = nil
		ChestFix.SplitBagSlot = nil
		ChestFix.SplitNumber = nil
		ChestFix.SplitNextSlot = nil
		ChestFix.SplitNextInvSlot = nil
		ChestFix.SplitPhase = false
		ChestFix.SplitPlace = false
		ChestFix.SplitChestPhase = false
		ChestFix.SplitPickupAgain = false
		PickupBagItem(NextSlot)
		ChestFix.ChestInit()
		return
	end
	if ChestFix.TransferPhase and ChestFix.TransferToBag then
		ChestFix.TransferToBag = false
		return
	elseif ChestFix.TransferPhase and ChestFix.TransferPicked then 
		ChestFix.TransferPhase = false 
		ChestFix.TransferPicked = false
		ChestFix.Stacking.Done = true
		return
	end
	if ChestFix.Stacking.Done then
		local _, _, NewAmount = Houses_GetItemInfo(ChestFix.Stacking.Furn,ChestFix.Stacking.ItemSlot)
		if NewAmount == ChestFix.Stacking.OldAmount and NewAmount == 1 then
			ChestFix_NotStackableItems[ChestFix.Stacking.ItemID] = true
		end
		ChestFix.Stacking.Done = false
		ChestFix.Stacking.Furn = nil
		ChestFix.Stacking.ItemSlot = nil
		ChestFix.Stacking.OldAmount = nil
		ChestFix.Stacking.ItemID = nil
		ChestFix.ChestInit()
	elseif Houses_IsOwner() or ChestFix_ForOther then
		ChestFix.ChestStack()
	end
end

function ChestFix.Events.BAG_ITEM_UPDATE(arg1)
	if ChestFix.TransferPhase and not ChestFix.TransferPicked then
		local FurID = ChestFix.Stacking.Furn
		local Slot = ChestFix.Stacking.ItemSlot
		ChestFix.TransferPicked = true
		PickupBagItem(arg1)
		Houses_PickupItem(FurID,Slot)
	elseif ChestFix.ForeignInBag then
		ChestFix.ForeignInBag = false
		ChestFix.ForeignPlace = true
		PickupBagItem(ChestFix.ForeignBagSlot)
	elseif ChestFix.ForeignPlace then
		ChestFix.ForeignPlace = false
		ChestFix.ForeignInBag = false
		Houses_PickupItem(ChestFix.ForeignDBID, ChestFix.ForeignChestSlot)
		ChestFix.ForeignDBID = nil
		ChestFix.ForeignChestSlot = nil
	elseif ChestFix.SplitPhase then
		ChestFix.SplitNextSlot,ChestFix.SplitNextInvSlot = ChestFix.NextFreeBagSlot()
		ChestFix.SplitPhase = false
		SplitBagItem(arg1, ChestFix.SplitNumber)
	elseif ChestFix.SplitDBID and ChestFix.SplitChestSlot and ChestFix.SplitBagSlot 
			and ChestFix.SplitInvSlot and ChestFix.SplitNumber and ChestFix.SplitNextSlot then
		if ChestFix.SplitPlace then 
			ChestFix.SplitPlace = false
			PickupBagItem(ChestFix.SplitNextSlot)
			return 
		end
		local _,_,_,Count,Locked = GetBagItemInfo(ChestFix.SplitBagSlot)
		if Count == 0 or Locked then return end
		local ID = ChestFix.SplitDBID 
		local ChestSlot = ChestFix.SplitChestSlot
		local NextSlot = ChestFix.SplitNextSlot
		local BagSlot = ChestFix.SplitInvSlot 
		local Number = ChestFix.SplitNumber
		if ChestFix.SplitChestPhase then
			ChestFix.SplitChestPhase = false
			ChestFix.SplitPickupAgain = true
			Houses_PickupItem(ID, ChestSlot)
			return
		end
		ChestFix.SplitChestPhase = true
		PickupBagItem(BagSlot)
	end
end

function ChestFix.ChestInit()
	for m = 1, 100 do
		ChestFix.EmptySlot[m] = {}
	end
	local HouseSpace = Houses_GetSpaceInfo()
	for i = 1, HouseSpace do
	local SlotEnabled, _, _, FurPlaced, FurID = Houses_GetFurnitureItemInfo(i)
		if SlotEnabled and FurPlaced then
			local MaxSlots = Houses_GetItemInfo(FurID,-1)
			if MaxSlots >= 1 then
				for j = 1, MaxSlots do
				local _, ItemName1 = Houses_GetItemInfo(FurID,j)
					if ItemName1 == nil then table.insert(ChestFix.EmptySlot[i],j) end
				end
			end
		end
	end
end

function ChestFix.ChestStack()
	local HouseSpace = Houses_GetSpaceInfo()
	for i = 1, HouseSpace do
		if ChestFix.EmptySlot[i] and next(ChestFix.EmptySlot[i]) then
			local SlotEnabled, _, _, FurPlaced, FurID = Houses_GetFurnitureItemInfo(i)
			if not ChestFix_Toggle[FurID] then ChestFix_Toggle[FurID] = 1 end
			if SlotEnabled and FurPlaced and ChestFix_Toggle[FurID] == 1 then
				local MaxSlots = Houses_GetItemInfo(FurID,-1)
				for k = 1, #ChestFix.EmptySlot[i] do
					if MaxSlots >= 1 and ChestFix.EmptySlot[i][k] and Houses_GetItemLink(FurID,ChestFix.EmptySlot[i][k]) then 	
						local _, ItemCode1 = ParseHyperlink(Houses_GetItemLink(FurID,ChestFix.EmptySlot[i][k]))
						local ItemID1 = string.sub(ItemCode1, 1, 5)
						if ItemID1 ~= nil and not ChestFix_NotStackableItems[ItemID1] then
							for j = 1, MaxSlots do
								local _, ItemName2, AmountBefore = Houses_GetItemInfo(FurID,j)
								if ItemName2 ~= nil and Houses_GetItemLink(FurID,j) then
									local _, ItemCode2 = ParseHyperlink(Houses_GetItemLink(FurID,j))
									local ItemID2 = string.sub(ItemCode2, 1, 5)								
									if ItemID1 == ItemID2 and j ~= ChestFix.EmptySlot[i][k] then
										ChestFix.Stacking.Furn = FurID
										ChestFix.Stacking.ItemSlot = j
										ChestFix.Stacking.OldAmount = AmountBefore
										ChestFix.Stacking.ItemID = ItemID1
										Houses_PickupItem(FurID,ChestFix.EmptySlot[i][k])
										if not Houses_IsOwner() then
											local _,BagPlace = GetBagCount()
											for b = 1, BagPlace do
												local BagInvSlot,_,_,BagItemCount = GetBagItemInfo(b)
												if BagItemCount == 0 then 
													ChestFix.TransferPhase = true
													ChestFix.TransferToBag = true
													PickupBagItem(BagInvSlot)
													break
												end
											end
										else
											Houses_PickupItem(FurID,j)
											ChestFix.Stacking.Done = true
										end
										break
									end
								end
							end
							break
						end
					end
				end
			end
		end
	end
	ChestFix.ChestInit()
end

ChestFix.HouseStorageFrame_OnShow = HouseStorageFrame_OnShow
function HouseStorageFrame_OnShow(this)
	ChestFix.HouseStorageFrame_OnShow(this)
	local FrameName = this:GetName()
	local AutoStackButton = CreateUIComponent("Button", FrameName.."Button_AutoStack",FrameName)
	AutoStackButton:SetSize(32, 32)
	AutoStackButton:ClearAllAnchors()
	AutoStackButton:SetAnchor("LEFT", "RIGHT", FrameName.."Button_FriendGet", 5, 0)
	local IconHighlight = CreateUIComponent("Texture",FrameName.."Button_AutoStackIconHighlight",FrameName.."Button_AutoStack")
	local IconOff = CreateUIComponent("Texture",FrameName.."Button_AutoStackIconOff",FrameName.."Button_AutoStack")
	local IconDepress = CreateUIComponent("Texture",FrameName.."Button_AutoStackIconDepress",FrameName.."Button_AutoStack")
	local IconOn = CreateUIComponent("Texture",FrameName.."Button_AutoStackIconOn",FrameName.."Button_AutoStack")
	IconHighlight:SetFile("Interface\\Buttons\\PanelSmallButtonHighlight")
	IconHighlight:SetSize(32, 32)
	IconHighlight:SetAlphaMode("ADD")
	IconOff:SetFile("Interface\\addons\\ChestFix\\img\\AutoStack-off")
	IconOff:SetSize(32, 32)
	IconDepress:SetFile("Interface\\addons\\ChestFix\\img\\AutoStack-depress")
	IconDepress:SetSize(32, 32)
	IconOn:SetFile("Interface\\addons\\ChestFix\\img\\AutoStack-on")
	IconOn:SetSize(32, 32)
	AutoStackButton:SetHighlightTexture(IconHighlight)
	AutoStackButton:SetPushedTexture(IconDepress)
	AutoStackButton:SetNormalTexture(IconOn)
	AutoStackButton:SetScripts("OnClick", [=[ ChestFix.AutoStackOnClick(this) ]=])
	AutoStackButton:SetScripts("OnEnter", [=[ GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT") GameTooltip:SetText("Toggle AutoStack", 1, 1, 1 ) GameTooltip:Show() ]=])
	AutoStackButton:SetScripts("OnLeave", [=[ GameTooltip:Hide() ]=])
	ChestFix.AutoStackOnClick(AutoStackButton, true)
end

ChestFix.HouseStorageItemButton_OnClick = HouseStorageItemButton_OnClick
function HouseStorageItemButton_OnClick(this, button, ignoreShift)
	if ( button == "LBUTTON" ) then
		if( IsShiftKeyDown() ) then
			local itemLink = Houses_GetItemLink(this.ParentDBID, this:GetID())
			if ChatEdit_AddItemLink(itemLink) then
				return;
			end
			local file, name, itemCount, locked = Houses_GetItemInfo(this.ParentDBID ,this:GetID());
			itemCount = itemCount or 0;
			if (locked or itemCount <= 1)then
				return;
			end
			this.AskNumberFrameCallBack = function(button, Number)
											local InvSlot,BagSlot = ChestFix.NextFreeBagSlot()			
											Houses_PickupItem(this.ParentDBID, this:GetID())
											ChestFix.SplitDBID = this.ParentDBID
											ChestFix.SplitChestSlot = this:GetID()
											ChestFix.SplitInvSlot = InvSlot
											ChestFix.SplitBagSlot = BagSlot
											ChestFix.SplitNumber = Number
											ChestFix.SplitPhase = true
											ChestFix.SplitPlace = true
											PickupBagItem(InvSlot)
										end
			OpenAskNumberFrame(1,itemCount, this, "BOTTOMRIGHT", "TOPRIGHT")
			return
		elseif not IsCtrlKeyDown() and not Houses_IsOwner() and CursorHasItem() and CursorItemType() == "house" then
			local Slot = ChestFix.NextFreeBagSlot()
			ChestFix.ForeignInBag = true
			ChestFix.ForeignBagSlot = Slot
			ChestFix.ForeignDBID = this.ParentDBID
			ChestFix.ForeignChestSlot = this:GetID()
			PickupBagItem(Slot)
			return
		end
	end
	ChestFix.HouseStorageItemButton_OnClick(this, button, ignoreShift)
end

function ChestFix.NextFreeBagSlot()
	local _,BagPlace = GetBagCount()
	for b = 1, BagPlace do
		local BagInvSlot,_,_,BagItemCount = GetBagItemInfo(b)
		if BagItemCount == 0 then 
			return BagInvSlot,b
		end
	end
end

function ChestFix.AutoStackOnClick(this, CheckState)
	local ID = this:GetParent().DBID
	if not CheckState then ChestFix.ToggleAutoStack(ID) end
	if ChestFix_Toggle[ID] == 0 or (not Houses_IsOwner() and not ChestFix_ForOther) then
		this:GetNormalTexture():SetFile("Interface\\addons\\ChestFix\\img\\AutoStack-off")
	else
		this:GetNormalTexture():SetFile("Interface\\addons\\ChestFix\\img\\AutoStack-on")
	end
end

function ChestFix.ToggleAutoStack(DBID)
	if not Houses_IsOwner() then
		ChestFix_ForOther = not ChestFix_ForOther
		for i=1, DF_HouseStorageFrameMax do 
			if _G["HouseStorageFrame_"..i] and _G["HouseStorageFrame_"..i]:IsVisible() then 
				ChestFix.AutoStackOnClick(_G["HouseStorageFrame_"..i.."Button_AutoStack"], true)				
			end
		end
		local ToggleMsg = ""
		if ChestFix_ForOther then ToggleMsg = "on" else ToggleMsg = "off" end
		DEFAULT_CHAT_FRAME:AddMessage("ChestFix turned "..ToggleMsg.." for furnitures of other players.", 1, 1, 1)
		return 
	end
	if DBID and Houses_GetItemInfo(DBID,-1) >= 1 then
		if not ChestFix_Toggle[DBID] then ChestFix_Toggle[DBID] = 1 end
		if ChestFix_Toggle[DBID] == 1 then ChestFix_Toggle[DBID] = 0
		elseif ChestFix_Toggle[DBID] == 0 then ChestFix_Toggle[DBID] = 1
		end
	end
end
