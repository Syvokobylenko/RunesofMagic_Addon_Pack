--[[ StatDB
   Stores all  attibute <-> effects conversions values
   Coder: Venor, snoopycurse
   Licence: http://creativecommons.org/licenses/by-nc-sa/3.0/
   DataBase revision number: see below.
]]

SR_numb_revision = "141";

-- local p = function(text) DEFAULT_CHAT_FRAME:AddMessage(text); end;

local SR = _G["StatRating"];
function SR.initDB(firstClass)
  local db = { };
  if (firstClass == C_AUGUR) then
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 0;
	  db[SR.constants.DEX_TO_PHYACC.effect] = 0.15;
	  db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13;
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1;
    db[SR.constants.INT_TO_PHYATT.effect] = 0.5;
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 0;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05;
    db[SR.constants.STA_TO_LIFE.effect]   = 5;
    db[SR.constants.STA_TO_PHYDEF.effect] = 1.5;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0;
    db[SR.constants.STR_TO_HP.effect]     = 0.2;
    db[SR.constants.STR_TO_PHYATT.effect] = 3/4;-- or 0.8 ?
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 3.2;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;
    
  elseif (firstClass == C_MAGE) then
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 0;
	  db[SR.constants.DEX_TO_PHYACC.effect] = 0.15;
	  db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13;
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1;
    db[SR.constants.INT_TO_PHYATT.effect] = 0.5;
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 0;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05;
    db[SR.constants.STA_TO_LIFE.effect]   = 5.0;
    db[SR.constants.STA_TO_PHYDEF.effect] = 1.5;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0;
    db[SR.constants.STR_TO_HP.effect]     = 0.2;
    db[SR.constants.STR_TO_PHYATT.effect] = 3/4;-- or 0.8 ?
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 3;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;
    
  elseif (firstClass == C_DRUID) then
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 0;
	  db[SR.constants.DEX_TO_PHYACC.effect] = 0.15;
	  db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13;
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1;
    db[SR.constants.INT_TO_PHYATT.effect] = 0.5;
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 0;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05;
    db[SR.constants.STA_TO_LIFE.effect]   = 5;
    db[SR.constants.STA_TO_PHYDEF.effect] = 1.5;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0;
    db[SR.constants.STR_TO_HP.effect]     = 0.2;
    db[SR.constants.STR_TO_PHYATT.effect] = 1;
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 2.3;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;

  elseif (firstClass == C_RANGER)  or (firstClass == "Eclaireur") then
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 1;
    db[SR.constants.DEX_TO_PHYACC.effect] = 0.15;
    db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13;
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1;
    db[SR.constants.INT_TO_PHYATT.effect] = 0;
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 0;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05; 
    db[SR.constants.STA_TO_LIFE.effect]   = 5;
    db[SR.constants.STA_TO_PHYDEF.effect] = 1.8;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0;        
    db[SR.constants.STR_TO_HP.effect]     = 0.2;
    db[SR.constants.STR_TO_PHYATT.effect] = 1;
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 2.6;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;
    
  elseif (firstClass == C_KNIGHT) then
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 0;
    db[SR.constants.DEX_TO_PHYACC.effect] = 0.15; 
    db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13; 
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1;
    db[SR.constants.INT_TO_PHYATT.effect] = 0.5; 
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 0;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05;
    db[SR.constants.STA_TO_LIFE.effect]   = 5.0;
    db[SR.constants.STA_TO_PHYDEF.effect] = 3;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0; 
    db[SR.constants.STR_TO_HP.effect]     = 0.2;
    db[SR.constants.STR_TO_PHYATT.effect] = 1.5;
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 2.4;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;
  
  elseif (firstClass == C_WARDEN) or (firstClass == "Gardien") then 
    -- Translation bug in french, Client returns Gardien but C_WARDEN returns Sentinelle
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 0;
    db[SR.constants.DEX_TO_PHYACC.effect] = 0.15;
    db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13;
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1;
    db[SR.constants.INT_TO_PHYATT.effect] = 0.5;
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 1;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05;
    db[SR.constants.STA_TO_LIFE.effect]   = 5;
    db[SR.constants.STA_TO_PHYDEF.effect] = 2;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0; 
    db[SR.constants.STR_TO_HP.effect]     = 0.2;
    db[SR.constants.STR_TO_PHYATT.effect] = 1.5;
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 2.4;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;
    
  elseif (firstClass == C_THIEF) then
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 1.3;
	  db[SR.constants.DEX_TO_PHYACC.effect] = 0.15;
	  db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13;
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1;
    db[SR.constants.INT_TO_PHYATT.effect] = 0;
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 0;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05;
    db[SR.constants.STA_TO_LIFE.effect]   = 5;
    db[SR.constants.STA_TO_PHYDEF.effect] = 1.8;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0;
    db[SR.constants.STR_TO_HP.effect]     = 0.2;
    db[SR.constants.STR_TO_PHYATT.effect] = 1.2;
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 2.3;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;    
    
  elseif (firstClass == C_WARRIOR) then
    db[SR.constants.DEX_TO_DPS.effect]    = 0;
    db[SR.constants.DEX_TO_PHYDEF.effect] = 0;
    db[SR.constants.DEX_TO_PHYATT.effect] = 0;
    db[SR.constants.DEX_TO_PHYACC.effect] = 0.15;
    db[SR.constants.DEX_TO_PHYDOD.effect] = 0.13;
    
    db[SR.constants.INT_TO_MAGATT.effect] = 2;
    db[SR.constants.INT_TO_MP.effect]     = 1; 
    db[SR.constants.INT_TO_PHYATT.effect] = 0;
    
    db[SR.constants.PHYDEF_TO_MAGDEF.effect] = 1;
    
    db[SR.constants.STA_TO_HP5.effect]    = 0.05;
    db[SR.constants.STA_TO_LIFE.effect]   = 5;
    db[SR.constants.STA_TO_PHYDEF.effect] = 2.3;
    
    db[SR.constants.STR_TO_DPS.effect]    = 0; 
    db[SR.constants.STR_TO_HP.effect]     = 0.5;
    db[SR.constants.STR_TO_PHYATT.effect] = 2;
    
    db[SR.constants.WIS_TO_MP.effect]     = 5;
    db[SR.constants.WIS_TO_MP5.effect]    = 0.1;
    db[SR.constants.WIS_TO_MAGDEF.effect] = 2.2;
    db[SR.constants.WIS_TO_PHYDEF.effect] = 0;
  end;
  
  return db;
end;

