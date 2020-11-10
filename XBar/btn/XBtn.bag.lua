local XBar = _G.XBar
local Bag={}
local function UsedColor(color)
	if color>89 then return "|cffFF0000"
	elseif color>69 then return "|cffFFAA00"
	else return "|cffFFFFFF" end
end

function XBar.Bag_OnEvent(this,event,tip)
	if event=="LOADED" and not tip then
		XBar.RegEvent(this, "PLAYER_BAG_CHANGED", "USED%]", "TOTAL%]", "LOAD%]")
	end
	local sused = 0
	for i = 1, 50 do
		local _, _, count = GetGoodsItemInfo(i)
		if count>0 then
			sused = sused + 1
		end
	end
	local aused = 0
	for i = 51, 60 do
		local _, _, count = GetGoodsItemInfo(i)
		if count>0 then
			aused = aused + 1
		end
	end
	local sload = math.ceil((sused / 50) * 100)
	Bag["sload"] = UsedColor(sload)..sload.."|r"
	Bag["sused"] = UsedColor(sload)..sused.."/50|r"
	Bag["aused"] = aused.."/5|r"
	local used,total=GetBagCount()
	local bload=math.ceil((used/total)*100)
	Bag["load"] = UsedColor(bload)..bload.."|r"
	Bag["used"] = UsedColor(bload)..used.."|r"
	Bag["total"] = UsedColor(bload)..total.."|r"
--	Output
	if not tip then
		local usrtxt={[1]=XBSet["BagV1"],[2]=XBSet["BagV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i],"%[USED%]",Bag["used"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[TOTAL%]",Bag["total"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[LOAD%]", Bag["load"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SUSED%]",Bag["sused"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[SLOAD%]", Bag["sload"])
			usrtxt[i],_=string.gsub(usrtxt[i],"%[AUSED%]", Bag["aused"])
		end
		if XBSet["BagT1"] then output=usrtxt[1] end
		if XBSet["BagT2"] then
			if XBSet["BagT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarBag_F_S:SetText(output)
	end
end

function XBar.Bag_OnEnter(this)
	XBar.Bag_OnEvent(XBarBag,"LOADED",true)
	XBar.TooltipMod(this)
	GameTooltip:SetText(BACKPACK)
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Bag1"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..BACKPACK.."|r", Bag["used"].."/"..Bag["total"])
	GameTooltip:AddDoubleLine("|cffFFE855"..GOODSPACK.."|r", Bag["sused"])
	GameTooltip:AddDoubleLine("|cffFFE855"..MAGICBOX_TITLE.."|r", Bag["aused"])
end

function XBar.Bag_OnClick(key)
	if key=="LBUTTON" then
		XBar.ToggleUI(BagFrame)
		MainMenuBagHasNewItem:Hide()
	elseif not IsShiftKeyDown() then
		if BankFrame:IsVisible() then
			BankFrame:Hide()
		elseif TimeLet_GetLetTime("BankLet")>=0 then
			OpenBank()
		else
			BankFrame:Show()
		end
	end
	PlaySoundByPath("sound/interface/ui_generic_click.mp3")
end