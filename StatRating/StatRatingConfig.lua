--[[ StatRatingConfig
   Config dialog for StatRating
   Coder: snoopycurse, nachtgold
   Licence: http://creativecommons.org/licenses/by-nc-sa/3.0/
]]

SR_numb_Sub_Version = "02";

-- Load StatsDB to fetch revision number.
dofile("Interface/Addons/StatRating/StatsDB.lua");

local addon_name, addon_version = "StatRating", "v1."..SR_numb_Sub_Version.."."..SR_numb_revision;
_G['ADDON_'..addon_name] = addon_version;
local SR = _G["StatRating"];
local p = function(text) DEFAULT_CHAT_FRAME:AddMessage(text); end;


local MAXTABSIZE = 5;
local MAXEFFECTSTATS = 19;

dofile("Interface/Addons/StatRating/lang/SRC_"..string.sub(GetLanguage(),1,2)..".lua");

local isInitialised = false;

local defaultProfile = {
  profileVersion = 6,

  characterID = 0,
  
  
  -- Allgemeine Addonsparameter
  rate = true,
  rateOnAltPressed = false,
  statSummary = true,
  colorFix = false,
  duraMod = true,
  duraModAllways = true,
  
  -- Base stat conversions
  showSTA_TO_LIFE = true,
  showSTA_TO_PHYDEF = true,
  showSTA_TO_HP5 = true,   
  showSTR_TO_HP = true,
  showSTR_TO_PHYATT = true,  
  showDEX_TO_PHYDOD = true,
  showDEX_TO_PHYACC = true,  
  showDEX_TO_PHYDEF = true,
  showDEX_TO_PHYATT = true,  
  showINT_TO_MP = true,
  showINT_TO_MAGATT = true,
  showINT_TO_PHYATT = true,  
  showWIS_TO_MP = true,
  showWIS_TO_MP5 = true,
  showWIS_TO_MAGDEF = true,  
  showDEX_TO_DPS = false,
  showSTR_TO_DPS = false,  
  showWIS_TO_PHYDEF = false,
  showPHYDEF_TO_MAGDEF = false,
  
  ------------------
  -- Stat Summary --
  ------------------
  showSumSta = true,
  showSumStr = true,
  showSumDex = true,
  showSumInt = true,
  showSumWis = true,
  
  showSumHP = true,
  showSumHP5 = true,
  showSumMP = true,
  showSumMP5 = true,
  
  showSumPDef = true,
  showSumPDod = true,
  showSumMDef = true,
  
  showSumPAtt = true,
  showSumPAcc = true,
  showSumMAtt = true,
    
  showSumDPS  = true,
  showSumEFFD = true,
  
  showSumMDmg = false,
  showSumPDmg = false,
  showSumHEAL = false
  
  ----------------------------------------------------
  -- müssen noch irgendwie in die Config --
  ----------------------------------------------------
  --showMAX_HP,
  --showMAX_MP
  
}


--- Experimental function to catch current weapon's skill
function SR_DPS_readTooltip() 
	local level = "1";
	local s = "";
	local text = "";
	local result = 0;
	for i = 2, 8 do
		leftLine = getglobal("SRGetDataTooltipTextLeft" .. i);
		rightLine = getglobal("SRGetDataTooltipTextRight" .. i);
		left, right = "", "";
		if leftLine:IsVisible() then left = leftLine:GetText() end
		if rightLine:IsVisible() then right = rightLine:GetText() end
		if left~="" or right~="" then
			if left == nil then
				left = "";
			end
			if right == nil then
				right = "";
			end
			if left ~= nil then
				if string.find(left, SRC_Texts.Skills.s07) ~= nil then
					result = 7;
				elseif string.find(left, SRC_Texts.Skills.s09) ~= nil then
					result = 9;
				elseif string.find(left, SRC_Texts.Skills.s10) ~= nil then
					result = 10;
				elseif string.find(left, SRC_Texts.Skills.s02) ~= nil then
					result = 2; 
				elseif string.find(left, SRC_Texts.Skills.s03) ~= nil then
					result = 3; 
				elseif string.find(left, SRC_Texts.Skills.s04) ~= nil then
					result = 4;  
				elseif string.find(left, SRC_Texts.Skills.s05) ~= nil then
					result = 5;
				elseif string.find(left, SRC_Texts.Skills.s06) ~= nil then
					result = 6;
				elseif string.find(left, SRC_Texts.Skills.s08) ~= nil then
					result = 8;
				elseif string.find(left, SRC_Texts.Skills.s11) ~= nil then
					result = 11;
				elseif string.find(left, SRC_Texts.Skills.s12) ~= nil then
					result = 12; 
				elseif string.find(left, SRC_Texts.Skills.s13) ~= nil then
					result = 13;
				elseif string.find(left, SRC_Texts.Skills.s14) ~= nil then
					result = 14;
				end				
        if result >0 then
          for k,v in pairs(PRACTICEDFRAME_ITEMS) do
            if k == result then
              local level,exlevel,max = GetPlayerSkilled(v);
if debug then p("SR_DPS_readTooltip Skill"..k..": "..tostring(level).."  max: ".. max);	end;
              return level + exlevel, max;    
            end  
          end
        end	    
			end
		end  
	end		
	return 0,0;
end

--- Experimental function to compute a theoric base damage for current weapon.
function SRC_guess_dps(showit)
    local sr_PlayerDamage, sr_PlayerAttack, sr_TargetLevel, sr_PlayerSkill, sr_PlayerMaxSkill, sr_PlayerLevel, sr_PlayerAccuracy;  
    local damagetype = 1; -- 1: Melee, 2:Ranged, and TODO: 3:Magic, 4:Heal   
-- Catch character level
    local mainClass, subClass = UnitClass("player");
    local mainLevel = 0;
    for i = 1,GetPlayerNumClasses() do
      local class, _, level,current,max = GetPlayerClassInfo(i,true);
      if class == mainClass then
        mainLevel = level;
      end
    end      
    sr_PlayerLevel = mainLevel; 
    if debug then p("Char level: "..tostring(sr_PlayerLevel)); end;
    
    sr_PlayerAccuracy = GetPlayerAbility("PHYSICAL_HIT"); 
    if debug then p("Char accuracy: "..tostring(sr_PlayerAccuracy)); end;


-- catch opponent level ( defaut formula is for knight mob )
    sr_TargetLevel = UnitLevel("target")   
    if sr_TargetLevel == nil then sr_TargetLevel = sr_PlayerLevel; end;
    if debug then p("Mob lvl: "..tostring(sr_TargetLevel)); end;
    
-- catch current equiped weapon skill level and current Melee/Ranged atk and damage stas      
    local id,id2,id3;
    local num_attrib_value, num_enchanted_value;  
    -- p("Class: "..mainClass);
    if (mainClass == C_AUGUR) or (mainClass == C_MAGE) or (mainClass == C_DRUID) then
      id,id2,id3=GetInventorySlotInfo("MainHandSlot");
      -- Temporary Phy Melee DPS 
      -- damagetype = 3;      
      num_attrib_value, num_enchanted_value = GetPlayerAbility("MELEE_MAIN_DAMAGE"); 
      sr_PlayerDamage = num_attrib_value + num_enchanted_value; 
      num_attrib_value, num_enchanted_value = GetPlayerAbility("MELEE_ATTACK"); 
      sr_PlayerAttack = num_attrib_value + num_enchanted_value;   
      if debug then p("Char MELEE_MAIN_DAMAGE: "..tostring(sr_PlayerDamage)); end;
      if debug then p("Char MELEE_ATTACK: "..tostring(sr_PlayerAttack)); end;
      
    elseif (mainClass == C_RANGER)  or (mainClass == "Eclaireur") then
      id,id2,id3=GetInventorySlotInfo("RangedSlot");       
      damagetype = 2;
      num_attrib_value, num_enchanted_value = GetPlayerAbility("RANGE_DAMAGE"); 
      sr_PlayerDamage = num_attrib_value + num_enchanted_value;
      num_attrib_value, num_enchanted_value = GetPlayerAbility("RANGE_ATTACK"); 
      sr_PlayerAttack = num_attrib_value + num_enchanted_value;
      
      -- p("GetInventorySlotInfo: "..tostring(id));             
      -- If no ranged weapon equiped, computes melee
      if id == nil or GetInventoryItemTexture("player",id)==nil then
        id,id2,id3=GetInventorySlotInfo("MainHandSlot");   
        num_attrib_value, num_enchanted_value = GetPlayerAbility("MELEE_MAIN_DAMAGE"); 
        sr_PlayerDamage = num_attrib_value + num_enchanted_value; 
        num_attrib_value, num_enchanted_value = GetPlayerAbility("MELEE_ATTACK"); 
        sr_PlayerAttack = num_attrib_value + num_enchanted_value;    
        if debug then p("Char MELEE_MAIN_DAMAGE: "..tostring(sr_PlayerDamage)); end;
        if debug then p("Char MELEE_ATTACK: "..tostring(sr_PlayerAttack)); end;   
      else
        if debug then p("Char RANGE_DAMAGE: "..tostring(sr_PlayerDamage)); end; 
        if debug then p("Char RANGE_ATTACK: "..tostring(sr_PlayerAttack)); end;              
      end;
    
    else -- Melee DPS
      id,id2,id3=GetInventorySlotInfo("MainHandSlot");   
      num_attrib_value, num_enchanted_value = GetPlayerAbility("MELEE_MAIN_DAMAGE"); 
      sr_PlayerDamage = num_attrib_value + num_enchanted_value; 
      num_attrib_value, num_enchanted_value = GetPlayerAbility("MELEE_ATTACK"); 
      sr_PlayerAttack = num_attrib_value + num_enchanted_value;    
      if debug then p("Char MELEE_MAIN_DAMAGE: "..tostring(sr_PlayerDamage)); end;
      if debug then p("Char MELEE_ATTACK: "..tostring(sr_PlayerAttack)); end;         
    end;
		--local id,id2,id3=GetInventorySlotInfo("MainHandSlot")
		if id ~= nil and GetInventoryItemTexture("player",id) then
			SRGetDataTooltip:SetInventoryItem("player", id);
			SRGetDataTooltip:Hide();
			sr_PlayerSkill, sr_PlayerMaxSkill = SR_DPS_readTooltip();
		else -- Open hand
      for k,v in pairs(PRACTICEDFRAME_ITEMS) do
        if k == 1 then
          local level,exlevel,max = GetPlayerSkilled(v);
          if debug then p("Open hand Skill"..k..": "..tostring(level).."  max: ".. max);	end;
          sr_PlayerSkill = level + exlevel;  
          sr_PlayerMaxSkill =  max;
        end  
      end		
		end  
    if sr_TargetLevel == 0 then sr_PlayerSkill = sr_PlayerLevel; end;
    local armor = 1.65*(sr_TargetLevel*sr_TargetLevel + 5*sr_PlayerLevel + sr_TargetLevel +100);    
    local result = sr_PlayerDamage * (sr_PlayerAttack + 160/sr_TargetLevel + sr_PlayerMaxSkill/2 + (sr_PlayerSkill*((sr_PlayerLevel+5)/11)));  
    if debug then p("Attaque totale: "..tostring(result));  end;
    
    if showit == 1 or debug then -- Called by command line
      p("Effective DPS on mob Lvl:"..sr_TargetLevel.." (Knight type), computed defense: ".. string.format("%.1f",armor));
      p("by character lvl: "..sr_PlayerLevel.." Skill:"..string.format("%.1f",sr_PlayerSkill)..", Dam Atk:"..sr_PlayerDamage.." "..sr_PlayerAttack);
      p("Resulting theoric white damage: "..string.format("%.1f",result/armor));
    end;
    
    if showit == 2 then           -- Called for Config panel
        local stringdps = "|cffEBDF90"..SRC_Texts.Common.EstimatedDPS.."|cf00ff00 "..string.format("%.1f",result/armor).."|r ";    
      if damagetype == 2 then
        stringdps = "|cffEBDF90"..SRC_Texts.Common.EstimatedDPSranged.."|cf00ff00 "..string.format("%.1f",result/armor).."|r ";
      elseif damagetype == 3 then
        -- stringdps = "Not available for magic damage.";
        -- SRC_Texts.Common.EstimatedDPSmagic..string.format("%.1f",result/armor);            
      elseif damagetype == 4 then
        --local stringdps = "Not available for Healing.";
        -- SRC_Texts.Common.EstimatedDPSmagic..string.format("%.1f",result/armor);  
      end;       
      stringdps = stringdps.." ( Only approximation, to be continued... )";
      if debug then p(stringdps); end;
      StatRatingConfigTabGeneralDPS:SetText(stringdps);
    end;   
     
    return damagetype, result/armor;
end

function StatRatingConfigTab_OnClick(buttonID)

  local i = 1;
  while i < MAXTABSIZE do
    local tab = getglobal('StatRatingConfigTab'..i);
    if tab then
    
      if buttonID == 1 then
        StatRatingConfigTabGeneral:Show();
        StatRatingConfigTabEffects:Hide();
        StatRatingConfigTabSummary:Hide();  
        SRC_guess_dps(2);  -- Actualise guess_dps
      elseif buttonID == 2 then
        StatRatingConfigTabEffects:Show();
        StatRatingConfigTabGeneral:Hide();
        StatRatingConfigTabSummary:Hide();
      elseif buttonID == 3 then
        StatRatingConfigTabSummary:Show();
        StatRatingConfigTabGeneral:Hide();
        StatRatingConfigTabEffects:Hide();
      end;
      
      if buttonID == i then
        UIPanelTab_SetActiveState(tab, true);
      else
        UIPanelTab_SetActiveState(tab, false);
      end;
    end;
    i=i+1;
  end;
end;

function StatRatingConfig_GetPickedColor()
  local this=ColorPickerFrame.call;
	
	local parent=this:GetParent();
	local r=ColorPickerFrame.r;
	local g=ColorPickerFrame.g;
	local b=ColorPickerFrame.b;
	local a=ColorPickerFrame.a;	
	
	local isOkay=ColorPickerFrame.isOkay;
	local isCancel=ColorPickerFrame.isCancel;
  
  if isOkay then
    local texture=getglobal(this:GetName().."Texture");
    if (isOkay or isCancel ) then
      texture:SetColor(r,g,b);
    end;
	end;
end;

function StatRatingConfig_OpenColorPicker(this)

	if( ColorPickerFrame:IsVisible() )then
		ColorPickerCancelButton_OnClick();
	end

	--CallBack data
	ColorPickerFrame.call=this;

	local r,g,b=getglobal(this:GetName().."Texture"):GetColor();
  
	if (r==0 and g==0 and b==0) then
		r=1;
		g=1;
		b=1;
	end
 
 local info = {};
	info.parent    = this;
	info.titleText = nil;
	info.alphaMode = nil;
	info.r         = r;
	info.g         = g;
	info.b         = b;
	info.a         = 1;
	info.brightnessUp   = 1;
	info.brightnessDown = 0.2;
	info.callbackFuncOkay   = StatRatingConfig_GetPickedColor;
	info.callbackFuncUpdate =StatRatingConfig_GetPickedColor;
	info.callbackFuncCancel = StatRatingConfig_GetPickedColor;
	
	OpenColorPickerFrameEx( info );
end;

local function getCharacterSequenceNextVal()
  local maxID = -1;
  for k, _ in pairs(SRC_VARS.character) do
    if SRC_VARS.character[k].characterID ~= nil and SRC_VARS.character[k].characterID > maxID then
      maxID = SRC_VARS.character[k].characterID;
    end;
  end;
  
  return (maxID + 1);
end;

local function checkPlayerConfig(playerName)
  if SRC_VARS.character[playerName] then
    if (SRC_VARS.character[playerName].profileVersion == nil or tonumber(defaultProfile.profileVersion) > tonumber(SRC_VARS.character[playerName].profileVersion)) then
      local charID = SRC_VARS.character[playerName].characterID;
      
      for k,v in pairs(defaultProfile) do
        if SRC_VARS.character[playerName][k] == nil then
          SRC_VARS.character[playerName][k] = defaultProfile[k];
        end;
      end;
      
      SRC_VARS.character[playerName].profileVersion = defaultProfile.profileVersion;
      
      --SRC_VARS.character[playerName] = nil;
      --SRC_VARS.character[playerName] = {};
      --SRC_VARS.character[playerName] = defaultProfile;
      --SRC_VARS.character[playerName].characterID = charID;
    end;
  else
    SRC_VARS.character[playerName] = {}
    SRC_VARS.character[playerName] = defaultProfile;
    SRC_VARS.character[playerName].characterID = getCharacterSequenceNextVal();
  end;
end;

local function StatRatingConfig_LoadConfig()
  local playerName = UnitName("player");
  
  if not SRC_VARS then
    SRC_VARS = {};
  end;
  
  if not SRC_VARS.character then
    SRC_VARS["character"] = {};
  end;
  checkPlayerConfig(playerName);
  
  SR.config = SRC_VARS.character[playerName];

  SaveVariables("SRC_VARS");
end;

function SRC_GetCharacterID(name)
    return SRC_VARS.character[name].characterID;
end;

function SRC_GetCharacterName(CBVid)
    for k, _ in pairs(SRC_VARS.character) do
      if SRC_VARS.character[k].characterID == CBVid then
        return k;
      end;
    end;
    
    return nil;
end;

function SRC_DropDownShow()
    local info
    
    for k, _ in pairs(SRC_VARS.character) do
      info = {};
      info.text = k;
      info.func = SRC_DropDownClick;
      UIDropDownMenu_AddButton(info);
    end;
end;

local function SetSRC_Initalize(playerName)
  checkPlayerConfig(playerName);
  
  -- Tab 1 Allgemeines
  StatRatingConfigTabGeneralActiveRate:SetChecked(SRC_VARS.character[playerName].rate);
  StatRatingConfigTabGeneralActiveRateOnALTPressed:SetChecked(SRC_VARS.character[playerName].rateOnAltPressed);
  StatRatingConfigTabGeneralShowSummary:SetChecked(SRC_VARS.character[playerName].statSummary);
  StatRatingConfigTabGeneralColorFix:SetChecked(SRC_VARS.character[playerName].colorFix);
  StatRatingConfigTabGeneralDuraMod:SetChecked(SRC_VARS.character[playerName].duraMod);
  StatRatingConfigTabGeneralDuraModAllways:SetChecked(SRC_VARS.character[playerName].duraModAllways);

  -- Tab 2 Effets & Texte, detailled to keep a logic order
--[[  local i = 1;
  for k, v in pairs(SRC_VARS.character[playerName]) do
    if i <= MAXEFFECTSTATS and string.find(k, 'show') ~= nil and string.find(k, 'Sum') == nil then
      local add = string.sub(k, 5);
      local chkBox = getglobal('StatRatingConfigTabEffectsAbility'..tostring(i));
      chkBox:SetChecked(v);
      getglobal(chkBox:GetName()..'Text'):SetText(SRC_Texts.Stats[add]);
      chkBox.Stat = add;
      i = i + 1;
    end;
  end;]]
  StatRatingConfigTabEffectsAbility1:SetChecked(SRC_VARS.character[playerName].showSTA_TO_LIFE);
  StatRatingConfigTabEffectsAbility1Text:SetText(SRC_Texts.Stats.STA_TO_LIFE);     
  StatRatingConfigTabEffectsAbility1.Stat = "STA_TO_LIFE";     
  StatRatingConfigTabEffectsAbility2:SetChecked(SRC_VARS.character[playerName].showSTA_TO_PHYDEF);
  StatRatingConfigTabEffectsAbility2Text:SetText(SRC_Texts.Stats.STA_TO_PHYDEF);    
  StatRatingConfigTabEffectsAbility2.Stat = "STA_TO_PHYDEF";     
  StatRatingConfigTabEffectsAbility3:SetChecked(SRC_VARS.character[playerName].showSTA_TO_HP5);
  StatRatingConfigTabEffectsAbility3Text:SetText(SRC_Texts.Stats.STA_TO_HP5);     
  StatRatingConfigTabEffectsAbility3.Stat = "STA_TO_HP5";     
  StatRatingConfigTabEffectsAbility4:SetChecked(SRC_VARS.character[playerName].showSTR_TO_HP);
  StatRatingConfigTabEffectsAbility4Text:SetText(SRC_Texts.Stats.STR_TO_HP);     
  StatRatingConfigTabEffectsAbility4.Stat = "STR_TO_HP";     
  StatRatingConfigTabEffectsAbility5:SetChecked(SRC_VARS.character[playerName].showSTR_TO_PHYATT);
  StatRatingConfigTabEffectsAbility5Text:SetText(SRC_Texts.Stats.STR_TO_PHYATT);    
  StatRatingConfigTabEffectsAbility5.Stat = "STR_TO_PHYATT";      
  StatRatingConfigTabEffectsAbility6:SetChecked(SRC_VARS.character[playerName].showDEX_TO_PHYDOD);
  StatRatingConfigTabEffectsAbility6Text:SetText(SRC_Texts.Stats.DEX_TO_PHYDOD);     
  StatRatingConfigTabEffectsAbility6.Stat = "DEX_TO_PHYDOD";     
  StatRatingConfigTabEffectsAbility7:SetChecked(SRC_VARS.character[playerName].showDEX_TO_PHYACC);
  StatRatingConfigTabEffectsAbility7Text:SetText(SRC_Texts.Stats.DEX_TO_PHYACC);     
  StatRatingConfigTabEffectsAbility7.Stat = "DEX_TO_PHYACC";     
  StatRatingConfigTabEffectsAbility8:SetChecked(SRC_VARS.character[playerName].showDEX_TO_PHYDEF);
  StatRatingConfigTabEffectsAbility8Text:SetText(SRC_Texts.Stats.DEX_TO_PHYDEF);    
  StatRatingConfigTabEffectsAbility8.Stat = "DEX_TO_PHYDEF";      
  StatRatingConfigTabEffectsAbility9:SetChecked(SRC_VARS.character[playerName].showDEX_TO_PHYATT);
  StatRatingConfigTabEffectsAbility9Text:SetText(SRC_Texts.Stats.DEX_TO_PHYATT);     
  StatRatingConfigTabEffectsAbility9.Stat = "DEX_TO_PHYATT";     
  StatRatingConfigTabEffectsAbility10:SetChecked(SRC_VARS.character[playerName].showINT_TO_MP);
  StatRatingConfigTabEffectsAbility10Text:SetText(SRC_Texts.Stats.INT_TO_MP);     
  StatRatingConfigTabEffectsAbility10.Stat = "INT_TO_MP";     
  StatRatingConfigTabEffectsAbility11:SetChecked(SRC_VARS.character[playerName].showINT_TO_MAGATT);
  StatRatingConfigTabEffectsAbility11Text:SetText(SRC_Texts.Stats.INT_TO_MAGATT);     
  StatRatingConfigTabEffectsAbility11.Stat = "INT_TO_MAGATT";     
  StatRatingConfigTabEffectsAbility12:SetChecked(SRC_VARS.character[playerName].showINT_TO_PHYATT);
  StatRatingConfigTabEffectsAbility12Text:SetText(SRC_Texts.Stats.INT_TO_PHYATT);     
  StatRatingConfigTabEffectsAbility12.Stat = "INT_TO_PHYATT";     
  StatRatingConfigTabEffectsAbility13:SetChecked(SRC_VARS.character[playerName].showWIS_TO_MP);
  StatRatingConfigTabEffectsAbility13Text:SetText(SRC_Texts.Stats.WIS_TO_MP);     
  StatRatingConfigTabEffectsAbility13.Stat = "WIS_TO_MP";     
  StatRatingConfigTabEffectsAbility14:SetChecked(SRC_VARS.character[playerName].showWIS_TO_MP5);
  StatRatingConfigTabEffectsAbility14Text:SetText(SRC_Texts.Stats.WIS_TO_MP5);     
  StatRatingConfigTabEffectsAbility14.Stat = "WIS_TO_MP5";     
  StatRatingConfigTabEffectsAbility15:SetChecked(SRC_VARS.character[playerName].showWIS_TO_MAGDEF);
  StatRatingConfigTabEffectsAbility15Text:SetText(SRC_Texts.Stats.WIS_TO_MAGDEF);    
  StatRatingConfigTabEffectsAbility15.Stat = "WIS_TO_MAGDEF";     
   
  -- hidden useless checkboxes, may be used in later clients, as was used in older versions.
  StatRatingConfigTabEffectsAbility16:SetChecked(false);
  StatRatingConfigTabEffectsAbility16Text:SetText(SRC_Texts.Stats.DEX_TO_DPS);    
  StatRatingConfigTabEffectsAbility16:Hide();     
  StatRatingConfigTabEffectsAbility16.Stat = "DEX_TO_DPS";     
  StatRatingConfigTabEffectsAbility17:SetChecked(false);
  StatRatingConfigTabEffectsAbility17Text:SetText(SRC_Texts.Stats.STR_TO_DPS);    
  StatRatingConfigTabEffectsAbility17:Hide();     
  StatRatingConfigTabEffectsAbility17.Stat = "STR_TO_DPS";     
  StatRatingConfigTabEffectsAbility18:SetChecked(false);
  StatRatingConfigTabEffectsAbility18Text:SetText(SRC_Texts.Stats.WIS_TO_PHYDEF);    
  StatRatingConfigTabEffectsAbility18:Hide();     
  StatRatingConfigTabEffectsAbility18.Stat = "WIS_TO_PHYDEF";     
  StatRatingConfigTabEffectsAbility19:SetChecked(false);
  StatRatingConfigTabEffectsAbility19Text:SetText(SRC_Texts.Stats.PHYDEF_TO_MAGDEF);    
  StatRatingConfigTabEffectsAbility19:Hide();   
  StatRatingConfigTabEffectsAbility19.Stat = "PHYDEF_TO_MAGDEF";     
  
  -- Tab 3 Zusammenfassung
  StatRatingConfigTabSummaryAbilityStamina:SetChecked(SRC_VARS.character[playerName].showSumSta);
  StatRatingConfigTabSummaryAbilityStrength:SetChecked(SRC_VARS.character[playerName].showSumStr);
  StatRatingConfigTabSummaryAbilityDexterity:SetChecked(SRC_VARS.character[playerName].showSumDex);
  StatRatingConfigTabSummaryAbilityIntelligence:SetChecked(SRC_VARS.character[playerName].showSumInt);
  StatRatingConfigTabSummaryAbilityWisdom:SetChecked(SRC_VARS.character[playerName].showSumWis);
  
  StatRatingConfigTabSummaryAbilityHP:SetChecked(SRC_VARS.character[playerName].showSumHP);
  StatRatingConfigTabSummaryAbilityHP5:SetChecked(SRC_VARS.character[playerName].showSumHP5);  
  StatRatingConfigTabSummaryAbilityMP:SetChecked(SRC_VARS.character[playerName].showSumMP);
  StatRatingConfigTabSummaryAbilityMP5:SetChecked(SRC_VARS.character[playerName].showSumMP5);
  
  StatRatingConfigTabSummaryAbilityPDef:SetChecked(SRC_VARS.character[playerName].showSumPDef);
  StatRatingConfigTabSummaryAbilityPDod:SetChecked(SRC_VARS.character[playerName].showSumPDod);
  StatRatingConfigTabSummaryAbilityMDef:SetChecked(SRC_VARS.character[playerName].showSumMDef);
  
  StatRatingConfigTabSummaryAbilityPAtt:SetChecked(SRC_VARS.character[playerName].showSumPAtt);
  StatRatingConfigTabSummaryAbilityPDmg:SetChecked(SRC_VARS.character[playerName].showSumPDmg);
  StatRatingConfigTabSummaryAbilityPAcc:SetChecked(SRC_VARS.character[playerName].showSumPAcc);
  StatRatingConfigTabSummaryAbilityMAtt:SetChecked(SRC_VARS.character[playerName].showSumMAtt);  
  StatRatingConfigTabSummaryAbilityMDmg:SetChecked(SRC_VARS.character[playerName].showSumMDmg);
  StatRatingConfigTabSummaryAbilityHeal:SetChecked(SRC_VARS.character[playerName].showSumHEAL);  
  
  --StatRatingConfigTabSummaryAbilityDPS:SetChecked(SRC_VARS.character[playerName].showSumDPS);
  StatRatingConfigTabSummaryAbilityEFFD:SetChecked(false);
  StatRatingConfigTabSummaryAbilityEFFD:Hide();
end;

function StatRatingConfig_SaveConfig(playerName)
  
  -- Tab 1 Allgemeines
  SRC_VARS.character[playerName].rate = StatRatingConfigTabGeneralActiveRate:IsChecked();
  SRC_VARS.character[playerName].rateOnAltPressed = StatRatingConfigTabGeneralActiveRateOnALTPressed:IsChecked();
  SRC_VARS.character[playerName].statSummary = StatRatingConfigTabGeneralShowSummary:IsChecked();
  SRC_VARS.character[playerName].colorFix = StatRatingConfigTabGeneralColorFix:IsChecked();
  SRC_VARS.character[playerName].duraMod = StatRatingConfigTabGeneralDuraMod:IsChecked();
  SRC_VARS.character[playerName].duraModAllways = StatRatingConfigTabGeneralDuraModAllways:IsChecked();

  -- Tab 2 Effekte
  for i = 1, MAXEFFECTSTATS, 1 do
    local chkBox = getglobal('StatRatingConfigTabEffectsAbility'..tostring(i));
    if chkBox:IsVisible() then
    
      SRC_VARS.character[playerName]['show'..chkBox.Stat] = chkBox:IsChecked();
    end;
  end;
  
  -- Tab 3 Zusammenfassung
  SRC_VARS.character[playerName].showSumSta = StatRatingConfigTabSummaryAbilityStamina:IsChecked();
  SRC_VARS.character[playerName].showSumStr = StatRatingConfigTabSummaryAbilityStrength:IsChecked();
  SRC_VARS.character[playerName].showSumDex = StatRatingConfigTabSummaryAbilityDexterity:IsChecked();
  SRC_VARS.character[playerName].showSumInt = StatRatingConfigTabSummaryAbilityIntelligence:IsChecked();
  SRC_VARS.character[playerName].showSumWis = StatRatingConfigTabSummaryAbilityWisdom:IsChecked();
  
  SRC_VARS.character[playerName].showSumHP  = StatRatingConfigTabSummaryAbilityHP:IsChecked();
  SRC_VARS.character[playerName].showSumMP5 = StatRatingConfigTabSummaryAbilityMP5:IsChecked();
  SRC_VARS.character[playerName].showSumMP  = StatRatingConfigTabSummaryAbilityMP:IsChecked();
  SRC_VARS.character[playerName].showSumHP5 = StatRatingConfigTabSummaryAbilityHP5:IsChecked();
  
  SRC_VARS.character[playerName].showSumPDef = StatRatingConfigTabSummaryAbilityPDef:IsChecked();
  SRC_VARS.character[playerName].showSumPDod = StatRatingConfigTabSummaryAbilityPDod:IsChecked();  
  SRC_VARS.character[playerName].showSumMDef = StatRatingConfigTabSummaryAbilityMDef:IsChecked();

  SRC_VARS.character[playerName].showSumPAtt = StatRatingConfigTabSummaryAbilityPAtt:IsChecked();
  SRC_VARS.character[playerName].showSumPDmg = StatRatingConfigTabSummaryAbilityPDmg:IsChecked();
  SRC_VARS.character[playerName].showSumPAcc = StatRatingConfigTabSummaryAbilityPAcc:IsChecked();  
  SRC_VARS.character[playerName].showSumMAtt = StatRatingConfigTabSummaryAbilityMAtt:IsChecked();  
  SRC_VARS.character[playerName].showSumMDmg = StatRatingConfigTabSummaryAbilityMDmg:IsChecked();
  SRC_VARS.character[playerName].showSumHEAL = StatRatingConfigTabSummaryAbilityHeal:IsChecked();
  
  SRC_VARS.character[playerName].showSumDPS  = StatRatingConfigTabSummaryAbilityDPS:IsChecked();
  SRC_VARS.character[playerName].showSumEFFD = StatRatingConfigTabSummaryAbilityEFFD:IsChecked();
    
  SaveVariables("SRC_VARS");  
  SR.config = SRC_VARS.character[playerName];
end;

function StatRatingConfig_OnLoad(this)
  
  -- Tabreiter
  StatRatingConfigTab1:SetText(SRC_Texts.Tabs.common);
  StatRatingConfigTab2:SetText(SRC_Texts.Tabs.stats);
  StatRatingConfigTab3:SetText(SRC_Texts.Tabs.summary);
  
  local i = 1;
  while i < MAXTABSIZE do
    local tab = getglobal('StatRatingConfigTab'..i);
    if tab then
      tab:Show();
      UIPanelTab_SetActiveState(tab, false);
    end;
    i=i+1;
  end;

  -- Übersichtsteil (immer sichtbar)
  StatRatingConfigCharacterNameDropDownDesc:SetText(SRC_Texts.general.char);
  StatRatingConfigSaveConfig:SetText(SRC_Texts.general.commit);
  
  -- Tab 1 General
  StatRatingConfigTabGeneralActiveRateText:SetText(SRC_Texts.Common.rate);
  StatRatingConfigTabGeneralActiveRateOnALTPressedText:SetText(SRC_Texts.Common.rateOnALTPressed);
  StatRatingConfigTabGeneralShowSummaryText:SetText(SRC_Texts.Common.show_summary);
  StatRatingConfigTabGeneralColorFixText:SetText(SRC_Texts.Common.color_fix);
  StatRatingConfigTabGeneralDuraModText:SetText(SRC_Texts.Common.dura_Mod);
  StatRatingConfigTabGeneralDuraModAllwaysText:SetText(SRC_Texts.Common.dura_ModAllways);
  
  StatRatingConfigTabGeneralCredits:SetText(SRC_Texts.general.Description);
  
  -- Tab 2 Effects    
  StatRatingConfigTabEffectsTitleEff:SetText(SRC_Texts.Summary.TitleEff);

  -- Tab 3 Summary
  StatRatingConfigTabSummaryTitle:SetText(SRC_Texts.Summary.Title);
  
  StatRatingConfigTabSummaryAbilityStaminaText:SetText(SRC_Texts.Summary.Sta);
  StatRatingConfigTabSummaryAbilityStrengthText:SetText(SRC_Texts.Summary.Str);
  StatRatingConfigTabSummaryAbilityDexterityText:SetText(SRC_Texts.Summary.Dex);
  StatRatingConfigTabSummaryAbilityIntelligenceText:SetText(SRC_Texts.Summary.Int);
  StatRatingConfigTabSummaryAbilityWisdomText:SetText(SRC_Texts.Summary.Wis);
  
  StatRatingConfigTabSummaryAbilityHPText:SetText(SRC_Texts.Summary.HP[1]);
  StatRatingConfigTabSummaryAbilityHP5Text:SetText(SRC_Texts.Summary.HP5);
  StatRatingConfigTabSummaryAbilityMPText:SetText(SRC_Texts.Summary.MP[1]);
  StatRatingConfigTabSummaryAbilityMP5Text:SetText(SRC_Texts.Summary.MP5);
  
  StatRatingConfigTabSummaryAbilityPDefText:SetText(SRC_Texts.Summary.PDef[1]);
  StatRatingConfigTabSummaryAbilityPDodText:SetText(SRC_Texts.Summary.PDod);  
  StatRatingConfigTabSummaryAbilityMDefText:SetText(SRC_Texts.Summary.MDef);
  
  StatRatingConfigTabSummaryAbilityPAttText:SetText(SRC_Texts.Summary.PAtt);
  StatRatingConfigTabSummaryAbilityPDmgText:SetText(SRC_Texts.Summary.PDmg[1]);
  StatRatingConfigTabSummaryAbilityPAccText:SetText(SRC_Texts.Summary.PAcc);
  StatRatingConfigTabSummaryAbilityMAttText:SetText(SRC_Texts.Summary.MAtt);  
  StatRatingConfigTabSummaryAbilityMDmgText:SetText(SRC_Texts.Summary.MDmg);
  StatRatingConfigTabSummaryAbilityHealText:SetText(SRC_Texts.Summary.HEAL);
  
  StatRatingConfigTabSummaryAbilityDPSText:SetText(SRC_Texts.Summary.DPS);
  StatRatingConfigTabSummaryAbilityEFFDText:SetText(SRC_Texts.Summary.EFFD);
  
  StatRatingConfigTitle:SetText(addon_name.." "..addon_version);
end;
    
function SRC_DropDownClick(button)
  SetSRC_Initalize(button:GetText());
  UIDropDownMenu_SetSelectedName(StatRatingConfigCharacterNameDropDown, button:GetText());
end;

function StatRatingConfig_Initialise()
  if isInitialised == false then
    StatRatingConfig_LoadConfig();
    UIDropDownMenu_SetWidth(StatRatingConfigCharacterNameDropDown, 120);
    UIDropDownMenu_Initialize(StatRatingConfigCharacterNameDropDown, SRC_DropDownShow);
    
    if SRC_VARS["window"] then
      StatRatingConfig:SetPos(SRC_VARS["window"]["x"], SRC_VARS["window"]["y"]);
    end;
    SetSRC_Initalize(UnitName('player'));
    UIDropDownMenu_SetSelectedName(StatRatingConfigCharacterNameDropDown, UnitName('player'));
    UIDropDownMenu_SetText(StatRatingConfigCharacterNameDropDown, UnitName('player'));
    isInitialised = true;
  end;
end;

function StatRatingConfig_AM_Toogle()
StatRatingConfig_Toogle(this, "")
end;

function StatRatingConfig_Toogle(editBox, msg)
  StatRatingConfig_Initialise();
  if StatRatingConfig:IsVisible() then
    StatRatingConfig:Hide();
  else
    StatRatingConfigTab_OnClick(1);
    StatRatingConfig:Show();
  end;
end;

local function addSlashList()
  SlashCmdList["STATRATINGCONFIG"] = StatRatingConfig_Toogle;
  _G["SLASH_STATRATINGCONFIG1"] = "/src";
end;

addSlashList();
--p("|cff8db9d4"..addon_name.." "..addon_version.." recached.|r");