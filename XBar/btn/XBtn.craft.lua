local XBar = _G.XBar
local Craft={
	["WoodRE"]=0,["MineRE"]=0,["HerbRE"]=0,
	["WoodL"]=0,["MineL"]=0,["HerbL"]=0,
}
local WoodOld = GetPlayerCurrentSkillValue("LUMBERING")
local MineOld = GetPlayerCurrentSkillValue("MINING")
local HerbOld = GetPlayerCurrentSkillValue("HERBLISM")

function XBar.Craft_OnEvent(this,event,tip)
	if event=="LOADED" and not tip then
		--XBar.RegEvent(this, "PLAYER_LIFESKILL_CHANGED", "LV%]", "XP%]", "RE%]", "L%]")
		this:RegisterEvent("PLAYER_LIFESKILL_CHANGED")
	end
	-- xp=2.3 --> lv=2 --> xp%=(2.3-2)*100 --> left=3-2.3
	Craft["MineLV"] = math.floor(GetPlayerCurrentSkillValue("MINING"))
	Craft["WoodLV"] = math.floor(GetPlayerCurrentSkillValue("LUMBERING"))
	Craft["HerbLV"] = math.floor(GetPlayerCurrentSkillValue("HERBLISM"))
	Craft["MineXP"] = (GetPlayerCurrentSkillValue("MINING")-Craft["MineLV"])*100
	Craft["WoodXP"] = (GetPlayerCurrentSkillValue("LUMBERING")-Craft["WoodLV"])*100
	Craft["HerbXP"] = (GetPlayerCurrentSkillValue("HERBLISM")-Craft["HerbLV"])*100
	local MNew = GetPlayerCurrentSkillValue("MINING")
	if MineOld<MNew then
		local Mlast = MNew - MineOld
		Craft["MineRE"] = math.floor((math.ceil(MNew) - MineOld) / Mlast)
		Craft["MineL"] = Mlast*100
		MineOld = MNew
	end
	local WNew = GetPlayerCurrentSkillValue("LUMBERING")
	if WoodOld<WNew then
		local Wlast = WNew - WoodOld
		Craft["WoodRE"] = math.floor((math.ceil(WNew) - WoodOld) / Wlast)
		Craft["WoodL"] = Wlast*100
		WoodOld = WNew
	end
	local HNew = GetPlayerCurrentSkillValue("HERBLISM")
	if HerbOld<HNew then
		local Hlast = HNew - HerbOld
		Craft["HerbRE"] = math.floor((math.ceil(HNew) - HerbOld) / Hlast)
		Craft["HerbL"] = Hlast*100
		HerbOld = HNew
	end
	if not tip then
		local usrtxt={[1]=XBSet["CraftV1"],[2]=XBSet["CraftV2"]}
		local output=""
		for i=1,2 do
			usrtxt[i],_=string.gsub(usrtxt[i], "%[MINELV%]", Craft["MineLV"])
			usrtxt[i],_=string.gsub(usrtxt[i], "%[MINEXP%]", string.format("%.2f", Craft["MineXP"]))
			usrtxt[i],_=string.gsub(usrtxt[i], "%[MINERE%]", Craft["MineRE"])
			usrtxt[i],_=string.gsub(usrtxt[i], "%[MINEL%]", string.format("%.2f", Craft["MineL"]))
			usrtxt[i],_=string.gsub(usrtxt[i], "%[WOODLV%]",Craft["WoodLV"])
			usrtxt[i],_=string.gsub(usrtxt[i], "%[WOODXP%]", string.format("%.2f",  Craft["WoodXP"]))
			usrtxt[i],_=string.gsub(usrtxt[i], "%[WOODRE%]", Craft["WoodRE"])
			usrtxt[i],_=string.gsub(usrtxt[i], "%[WOODL%]", string.format("%.2f", Craft["WoodL"]))
			usrtxt[i],_=string.gsub(usrtxt[i], "%[HERBLV%]", Craft["HerbLV"])
			usrtxt[i],_=string.gsub(usrtxt[i], "%[HERBXP%]", string.format("%.2f", Craft["HerbXP"]))
			usrtxt[i],_=string.gsub(usrtxt[i], "%[HERBRE%]", Craft["HerbRE"])
			usrtxt[i],_=string.gsub(usrtxt[i], "%[HERBL%]", string.format("%.2f", Craft["HerbL"]))
		end
		if XBSet["CraftT1"] then output=usrtxt[1] end
		if XBSet["CraftT2"] then
			if XBSet["CraftT1"] then output=output.."\n"..usrtxt[2] else output=usrtxt[2] end
		end
		XBarCraft_F_S:SetText(output)
	end
end

function XBar.Craft_OnEnter(this)
	XBar.Craft_OnEvent(XBarCraft,"LOADED",true)
	XBar.TooltipMod(this)
	local MatCount = {
		TEXT("Sys200293_name"), --Ash Wood
		TEXT("Sys200508_name"), --Chime Wood
		TEXT("Sys200295_name"), --Willow Wood
		TEXT("Sys200509_name"), --Stone Rotan Wood
		TEXT("Sys200297_name"), --Maple Wood
		TEXT("Sys200300_name"), --Oak Wood
		TEXT("Sys200326_name"), --Redwood
		TEXT("Sys200304_name"), --Pine Wood
		TEXT("Sys200332_name"), --Dragon Beard Root Wood
		TEXT("Sys200298_name"), --Holly Wood
		TEXT("Sys200306_name"), --Yew Wood
		TEXT("Sys200331_name"), --Sagewood
		TEXT("Sys200307_name"), --Tarslin Demon Wood
		TEXT("Sys200310_name"), --Dragonlair Wood
		TEXT("Sys202317_name"), --Fairywood
		TEXT("Sys200312_name"), --Ancient Spirit Oak Wood
		TEXT("Sys202318_name"), --Aeontree Wood
		TEXT("Sys208240_name"), --Fastan Banyan
		TEXT("Sys240323_name"), --Janost Cypress Wood
		TEXT("Sys241426_name"), --Stone Pine
		TEXT("Sys241420_name"), --Todo Ginkgo Tree

		TEXT("Sys200335_name"), --Mountain Demon Grass
		TEXT("Sys202552_name"), --Rosemary
		TEXT("Sys200334_name"), --Beetroot
		TEXT("Sys202553_name"), --Bison Grass
		TEXT("Sys200333_name"), --Bitterleaf
		TEXT("Sys200338_name"), --Moxa
		TEXT("Sys202554_name"), --Foloin Nut
		TEXT("Sys200343_name"), --Dusk Orchid
		TEXT("Sys202555_name"), --Green Thistle
		TEXT("Sys200342_name"), --Barsaleaf
		TEXT("Sys200345_name"), --Moon Orchid
		TEXT("Sys202556_name"), --Straw Mushroom
		TEXT("Sys200346_name"), --Sinners Palm
		TEXT("Sys200349_name"), --Dragon Mallow
		TEXT("Sys202557_name"), --Mirror Sedge
		TEXT("Sys200350_name"), --Thorn Apple
		TEXT("Sys202558_name"), --Goblin Grass
		TEXT("Sys208246_name"), --Verbena
		TEXT("Sys240329_name"), --Nocturnal Lantern Grass
		TEXT("Sys241414_name"), --Dovetail Flower
		TEXT("Sys241408_name"), --Thunderhoof Grass
		
		TEXT("Sys200230_name"), --Zinc Ore
		TEXT("Sys200507_name"), --Flame Dust
		TEXT("Sys200232_name"), --Tin Ore
		TEXT("Sys200506_name"), --Cyanide
		TEXT("Sys200234_name"), --Iron Ore
		TEXT("Sys200236_name"), --Copper Ore
		TEXT("Sys200249_name"), --Rock Crystal
		TEXT("Sys200238_name"), --Dark Crystal
		TEXT("Sys200269_name"), --Mysticite
		TEXT("Sys200239_name"), --Silver Ore
		TEXT("Sys200242_name"), --Wizard-Iron Ore
		TEXT("Sys200265_name"), --Mithril
		TEXT("Sys200244_name"), --Moon Silver Ore
		TEXT("Sys200264_name"), --Abyss-Mercury
		TEXT("Sys202315_name"), --Frost Crystal
		TEXT("Sys200268_name"), --Rune Obsidian Ore
		TEXT("Sys202316_name"), --Mica
		TEXT("Sys208234_name"), --Olivine
		TEXT("Sys240314_name"), --Purple Agate Crystal
		TEXT("Sys241438_name"), --Rein Crystal
		TEXT("Sys241432_name"), --Olegan Stone
	}
	GameTooltip:SetText(XBar.Lng["Ttip"]["Craft1"])
	GameTooltip:AddLine(XBar.Lng["Ttip"]["Craft2"],0,.7,.9)
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_MINE.."|r", string.format("Lv"..Craft["MineLV"].." / ".."%.2f%%", Craft["MineXP"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_WOOD.."|r", string.format("Lv"..Craft["WoodLV"].." / ".."%.2f%%", Craft["WoodXP"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_HERB.."|r", string.format("Lv"..Craft["HerbLV"].." / ".."%.2f%%", Craft["HerbXP"]))
	GameTooltip:AddSeparator()
	GameTooltip:AddDoubleLine(" ", "|cff8DE668"..XBar.Lng["Ttip"]["Craft3"].."|r")
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_MINE.."|r", string.format("%.2f%%".." / "..Craft["MineRE"], Craft["MineL"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_WOOD.."|r", string.format("%.2f%%".." / "..Craft["WoodRE"], Craft["WoodL"]))
	GameTooltip:AddDoubleLine("|cffFFE855"..LIFESKILL_HERB.."|r", string.format("%.2f%%".." / "..Craft["HerbRE"], Craft["HerbL"]))
	local add = 0
	for _,v in ipairs(MatCount) do
		local c = GetCountInBagByName(v) + GetCountInBankByName(v)
		if c>0 then
			if add==0 then
				GameTooltip:AddSeparator()
				GameTooltip:AddDoubleLine(" ", "|cff8DE668"..XBar.Lng["Ttip"]["Craft4"].."|r")
				add = nil
			end
			GameTooltip:AddDoubleLine("|cffFFE855"..v.."|r", c)
		end
	end
end