--[[
File-Author: Pyrr
File-Hash: 8ff1c09e6901ad8f19e16942bf88c24694ef06fa
File-Date: 2018-01-31T11:48:22Z
]]
local lib,name,path = ...

------------------------------------------------------ lib.helper ------------------------------------------------------
local me = {
	exports= {},
	fuse = nil,
	secureFrame = nil,
}
me.HasBuff_All = function(unit, buffid)
	local name, icon, count, id
	for i=1,100 do
		name, icon, count, id = UnitBuffInfo(unit,i);
		if (name or 1)==1 then
			break
		elseif id==buffid then
			return true
		end
	end
	return false
end
me.GetBagItemIndexByID = function(itemID)
	local index, bagid, itemCount, id
	for i=1, 6 do
		if i<3 or GetBagPageLetTime(i) then
			for j=1,30 do
				index = (i-1)*30+j
				bagid, _, _, itemCount = GetBagItemInfo(index)
				if itemCount > 0 then
					_,id,_ = ParseHyperlink(GetBagItemLink(bagid, true))
					id = tonumber(id,16);
					if id==itemID then
						return bagid, index ,itemCount
					end
				end
			end
		end
	end
	return nil, nil, nil
end
me.FindEmptyBagSlot = function(cnt)
	cnt = tonumber(cnt) or 1
	cnt = cnt>0 and cnt or 1
	local bagid, itemCount
	local lst = {}
	for i=1, 6 do
		if i<3 or GetBagPageLetTime(i) then
			for j=1,30 do
				bagid, _, _, itemCount = GetBagItemInfo((i-1)*30+j)
				if itemCount == 0 then
					table.insert(lst, bagid)
					cnt = cnt - 1
					if cnt==0 then
						return unpack(lst)
					end
				end
			end
		end
	end
	return unpack(lst)
end
me.SwitchBagSlot = function(index1, index2)
	PickupBagItem(index1)
	PickupBagItem(index2)
	PickupBagItem(index1)
	return true
end
me.SplitBagSlot = function(origin, num, target)
	if ((GetBagItemLink(target) or 0)~=0) then
		return false
	end
	SplitBagItem(origin, num)
	PickupBagItem(target)
	return true
end
--[[
Callback Codes:
	0 -> Fusion Suceeded
	1 -> Fusion in progress
	2 -> trying to fuse more than 5 bagslots
	3 -> stacksize of item is too low/ item not found
	4 -> not enough space
	5 -> not enough transmutor energy
	6 -> cant be transmuted
	7 -> Timeout
	8 -> Reset By User
]]

me.ResetFusion = function()
	if me.fuse then
		me.UnRegisterEventHandler("PLAYER_BAG_CHANGED", "PYLIB_HELPER_FUSION")
		me.UnRegisterEventHandler("MAGICBOX_CHANGED", "PYLIB_HELPER_FUSION")
		me.FusionCallback(8)
	end
end
me.FusionTimeout = function()
	if me.fuse then
		me.FusionCallback(7)
	end
end
me.FusionCallback = function(code)
	if me.fuse.secure then me.secureFrame:Hide() end
	local timer = 0
	if me.fuse.time then timer = GetTime()-me.fuse.time end
	me.fuse.callback(code, timer)
	me.fuse = nil
	me.SendEvent("PYLIB_HELPER_FUSION_FINISHED", code, timer)
end
me.FusionStep1 = function(dry)
	if not me.fuse then return end
	ItemClipboard_Clear()
	local free = {me.FindEmptyBagSlot(5)}
	local arcane = {}
	--table.insert(arcane, {51, 2})
	
	for index=51, 55 do
		local link = GetBagItemLink(index, true) or 1
		if index == 51 and link == 1 then link = 2 end -- treat slot 51 always as full
		table.insert(arcane,{index, link})
	end
	local last = nil
	-- Switch different items
	for i=#me.fuse,1,-1 do
		if me.fuse[i].all then
			for j, data in pairs(arcane) do
				local index, link = unpack(data)
				if type(link)~="number" and link~=me.fuse[i].link then
					table.remove(arcane, j)
					local slot = table.remove(me.fuse,i)
					if dry then
						table.insert(me.fuse,i, slot)
					else
						me.SwitchBagSlot(slot.index, index) 
					end
					last = index
					break;
				end
			end
		end
	end
	me.fuse.__empty = {}
	-- remove all items from arcane transmutor, fill empty slots
	for j=#arcane,1,-1 do
		local index, link = unpack(arcane[j])
		if type(link)=="number" then
			table.remove(arcane, j)
			if #me.fuse>0 then
				local dat =  table.remove(me.fuse)
				if dat.all then
					if not dry then me.SwitchBagSlot(dat.index, index) end
				else
					if not dry then me.SplitBagSlot(dat.index, dat.count, index) end
				end
				if dry then table.insert(me.fuse, dat) end
				last = index
			else
				me.fuse.__empty[index] = true
			end
		else
			if #free>0 then
				if not dry then  me.SwitchBagSlot(table.remove(free), index) end
				me.fuse.__empty[index] = true
			else
				me.FusionCallback(4)
				return
			end
		end
	end
	if dry then 
		return me.FusionStep1(false)
	end
	if #me.fuse>0 then
		me.RegisterEventHandler("PLAYER_BAG_CHANGED", "PYLIB_HELPER_FUSION", me.FusionStep2)
	else
		me.fuse.__last = last
		me.RegisterEventHandler("PLAYER_BAG_CHANGED", "PYLIB_HELPER_FUSION", me.FusionStep3)
	end
	return true
end
me.FusionStep2 = function(event, index, ...)
	if not me.fuse then return end
	if not me.fuse.__empty[index] then return end
	local dat =  table.remove(me.fuse)
	if dat.all then
		me.SwitchBagSlot(dat.index, index)
	else
		me.SplitBagSlot(dat.index, dat.count, index)
	end
	if #me.fuse==0 then
		me.fuse.__last = index
		me.RegisterEventHandler("PLAYER_BAG_CHANGED", "PYLIB_HELPER_FUSION", me.FusionStep3)
	end
end
me.FusionStep3 = function(event, index)
	if not me.fuse then return end
	if index==me.fuse.__last then
		me.UnRegisterEventHandler("PLAYER_BAG_CHANGED", "PYLIB_HELPER_FUSION")
		if (GetMagicBoxPreviewResult() or nil) then
			MagicBoxRequest()
			me.RegisterEventHandler("MAGICBOX_CHANGED", "PYLIB_HELPER_FUSION", me.FusionStep4)
		else
			me.FusionCallback(6)
			return
		end
	end
end
me.FusionStep4 = function()
	if not me.fuse then return end
	me.UnRegisterEventHandler("MAGICBOX_CHANGED", "PYLIB_HELPER_FUSION")
	me.FusionCallback(0)
end
--/run pylib.lib.helper.fuse = nil pylib.lib.helper.Fusion(print, false, 1,2)
--/run val = 1 pylib.RegisterEventHandler("PYLIB_HELPER_FUSION_FINISHED", "TEST",  function(event, arg) if arg~=0 then return end val = val +2  pylib.lib.helper.Fusion(print, false, val,val+1) end)
me.Fusion = function(callback, secure, ...)
	if secure then
		if not me.secureFrame then
			me.secureFrame = pylib.ui.CreateWidget("Frame", {
				_name = "PYLIB_BLOCK_FRAME",
				MouseEnable = true,
				FrameStrata="TOOLTIP",
				BackdropTileAlpha = .1,
				FrameLevel=1000,
				Height = UIParent:GetHeight(),
				Width = UIParent:GetWidth(),
				Anchors={{"TOPLEFT", "TOPLEFT", "UIParent", 0, 0},},
				Scripts = {
					{"OnShow", [=[ this.__showtime = GetTime()+5]=]},
					{"OnUpdate", [=[ if this.__showtime and this.__showtime<GetTime() then this:Hide() end if IsCtrlKeyDown() and IsShiftKeyDown() and IsAltKeyDown() then this:Hide() end ]=]},
				},
				Backdrop = {
					--edgeFile="Interface/Tooltips/Tooltip-border",
					edgeFile="",
					bgFile="Interface/Tooltips/Tooltip-Background",
					BackgroundInsets = { top = 0, left = 0, bottom = 0, right = 0 },
					EdgeSize = 16,
					TileSize = 16,
				},
			}, false)
			me.secureFrame:Hide()
		end
	end
	if me.fuse then
		callback(1)
		me.SendEvent("PYLIB_HELPER_FUSION_FINISHED", 1)
		return false
	end
	me.fuse = {callback=callback, secure=secure, time = GetTime()}
	local args = {...}
	if #args>5 then
		me.FusionCallback(2)
		return false
	end
	if GetMagicBoxEnergy()<=0 then
		me.FusionCallback(5)
		return false
	end
	for _, dat in ipairs(args) do
		local new
		if type(dat)=="table" then
			local index, _, _, bag_count = GetBagItemInfo(dat[1])
			
			if (tonumber(dat[2]) and tonumber(dat[2])>bag_count) or bag_count==0 then
				me.FusionCallback(3)
				return false
			else
				local cnt = tonumber(dat[2]) or 0
				new = {index = index, count=cnt, all = (cnt==0 or cnt==bag_count), link = GetBagItemLink(index, true)}
			end
		else
			local index, _, _, bag_count = GetBagItemInfo(dat)
			if bag_count==0 then
				me.FusionCallback(3)
				return false
			end
			new = {index = index, all=true, link = GetBagItemLink(index, true)}
		end
		table.insert(me.fuse, new)
	end
	if secure then me.secureFrame:Show() end
	lib.timer.Add(5, me.FusionTimeout, "PYLIB_HELPER_FUSION_TIMEOUT", 1)
	me.FusionStep1(true)
	return true
end

lib.CreateTable(me,name,path, lib)
