--[[
	Fix for Guildbank
	Adding right-click to move guildbankitems
]]--


local VERSION = string.match("1.2", "^v?[%d+.]+....$") or DEV_BUILD or "Build: 2014-06-06T12:56:59Z"
local ROOT = "interface/addons/FixforGuildbank"

FixForGuildBank = {
	System = {
		Name = "FixForGuildBank",
		Path = ROOT,
		Icon = "interface/bagframe/magicbox-normal.tga",
		Version = VERSION,
		Author = "Amurilon",
	},
	Vars = {
		slotid = 0,
		moveto = 0,
		maxstack = nil,
		state = 0,
	},
	Hooks = {},
	Core = {},
}

local zzLibrary = ZZLibrary
local zzTable, zzMath, zzString, zzClasses, zzHash, zzColors, zzStory, zzEvent, zzTimer, zzWidget, zzConfig = zzLibrary.GetLibraries()
local System = FixForGuildBank.System
local Vars = FixForGuildBank.Vars
local Core = FixForGuildBank.Core
local Hooks = FixForGuildBank.Hooks

function Core.OnEvent(event,arg1,arg2)
	if event == "GUILDBANK_FIX_ITEM" then
		if Vars.state == 1 then
			Vars.state = 0
			Core.Restack(arg2+((GuildBankFrame.PageIndex-1)*100))
		elseif Vars.state == 2 then
			if Vars.moveto == 0 then
				Vars.moveto = arg2
			else
				Vars.state = 0
				if GuildBank_GetItemInfo(arg2+((GuildBankFrame.PageIndex-1)*100)) ~= nil then
					if Vars.maxstack == nil then
						if getglobal("GuildBankItemButton"..Vars.moveto.."Count"):IsVisible() then
							Vars.maxstack = getglobal("GuildBankItemButton"..Vars.moveto.."Count"):GetText()
							Vars.maxstack = Vars.maxstack~="*" and Vars.maxstack or 1000
						else
							Vars.maxstack = 1
						end
					end
					Vars.moveto = 0
					Core.Restack(arg2+((GuildBankFrame.PageIndex-1)*100),Vars.slotid)
				else
					Vars.maxstack = nil
					Vars.moveto = 0
					Vars.slotid = 0
				end

			end
		end
	elseif event =="WARNING_MESSAGE" then
		if arg1 == TEXT("SYS_GAMEMSGEVENT_802") then
			Vars.state = 0
		end
	elseif event == "VARIABLES_LOADED" then
		Hooks.GuildBankItemButton_OnClick = GuildBankItemButton_OnClick
		Hooks.BagItemButton_OnClick = BagItemButton_OnClick

		GuildBankItemButton_OnClick = Core.GuildBankItemButton_OnClick
		BagItemButton_OnClick = Core.BagItemButton_OnClick

		if getglobal("zBag") then
			Hooks.BagItemButton_OnClick = zBagItem_OnClick
			zBagItem_OnClick = Core.BagItemButton_OnClick
		end
	end
end

function Core.Restack(slotid,begin)
	local currentpage = GuildBankFrame.PageIndex
	local _, name = GuildBank_GetItemInfo(slotid)
	local start = 100*(currentpage-1)+1

	if begin then start = begin end

	for i=start,100*currentpage do
		if i ~= slotid then
			local _, searchname,count = GuildBank_GetItemInfo(i)
			if searchname == name then
				if (Vars.maxstack ~= nil) then
					if count < tonumber(Vars.maxstack) then
						Vars.slotid = i+1
						Vars.state = 2
						GuildBank_PickupItem(slotid)
						GuildBank_PickupItem(i)
						return
					end
				else
					Vars.slotid = i+1
					Vars.state = 2
					GuildBank_PickupItem(slotid)
					GuildBank_PickupItem(i)
					return
				end
			end
		end
	end
	Vars.maxstack = nil
end

function Core.GuildBankItemButton_OnClick(this, button, ignoreShift)
	if button == "RBUTTON" then
		local used,available,_ = GetBagCount()

		if used >= available then
			SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_417"))
		else
			for i = 1,available do
				local slot,itemlink = GetBagItemInfo(i)
				if itemlink == "" then
					GuildBank_PickupItem(this.index)
					PickupBagItem(slot)
					break
				end
			end

		end
	else
		Hooks.GuildBankItemButton_OnClick(this, button, ignoreShift)
	end
end

function Core.BagItemButton_OnClick(this, button, ignoreShift)
	if GuildBankFrame:IsVisible() and button =="RBUTTON" and not(GarbageFrame:IsVisible()) and not(IsShiftKeyDown()) then
		local count = GuildBank_GetPageCount()
		local currentpage = GuildBankFrame.PageIndex

		if GuildBankItemButton1Invalid:IsVisible() then
			SendWarningMsg(TEXT("UI_GUILDBANKCONFIG_CANT_VIEW"))
			return
		end

		for i=100*(currentpage-1)+1,100*currentpage do
			local texture, name, count, locked = GuildBank_GetItemInfo(i)
			if texture == nil then
				PickupBagItem(this.index)
				GuildBank_PickupItem(i)
				Vars.state = 1
				return
			end
		end
		SendWarningMsg(TEXT("SYS_GAMEMSGEVENT_803"))
	else
		Hooks.BagItemButton_OnClick(this, button, ignoreShift)
	end
end

zzEvent.Register("GUILDBANK_FIX_ITEM", Core.OnEvent, System.Name.."_GuildbankFixItem")
zzEvent.Register("VARIABLES_LOADED", Core.OnEvent, System.Name.."_LoadingEnd")
zzEvent.Register("WARNING_MESSAGE", Core.OnEvent, System.Name.."_WarningMsg")
