--[[ StatRatingConfig
   Constants
   Coder: nachtgold snoopycurse
   Licence: http://creativecommons.org/licenses/by-nc-sa/3.0/
   Ver 1.02.xxx
]]

local SR = _G["StatRating"];

--- Auswirkungen von Geschicklichkeit
SR.constants.DEX_TO_DPS = { effect = "dexToDPS", result = "DPS"};
SR.constants.DEX_TO_PHYATT = { effect = "dexToPhyatt", result = "PAtt"};
SR.constants.DEX_TO_PHYDEF = { effect = "dexToPhydef", result = "PDef"};
SR.constants.DEX_TO_PHYDOD = { effect = "dexToPhydod", result = "PDod"};
SR.constants.DEX_TO_PHYACC = { effect = "dexToPhyacc", result = "PAcc"};

-- Auswirkungen von Intelligenz
SR.constants.INT_TO_MAGATT = { effect = "intToMagatt", result = "MAtt"};
SR.constants.INT_TO_MP = { effect = "intToMP", result = "MP"};
SR.constants.INT_TO_PHYATT = { effect = "intToPhyatt", result = "PAtt"};

-- Auswirkungen von Physischer Verteidigung
SR.constants.PHYDEF_TO_MAGDEF = { effect = "phydefToMagdef", result = "MDef"};

-- Auswirkungen von Ausdauer
SR.constants.STA_TO_LIFE = { effect = "staToHP", result = "HP"};
SR.constants.STA_TO_PHYDEF = { effect = "staToPhydef", result = "PDef"};
SR.constants.STA_TO_HP5 = { effect = "staToHP5", result = "HP5"};

-- Auswirkungen von Stärke
SR.constants.STR_TO_DPS = { effect = "strToDPS", result = "DPS"};
SR.constants.STR_TO_HP = { effect = "strToHP", result = "HP"};
SR.constants.STR_TO_PHYATT = { effect = "strToPhyatt", result = "PAtt"};

-- Auswirkungen von Weisheit
SR.constants.WIS_TO_MAGDEF = { effect = "wisToMagdef", result = "MDef"};
SR.constants.WIS_TO_MP = { effect = "wisToMP", result = "MP"};
SR.constants.WIS_TO_MP5 = { effect = "wisToMP5", result = "MP5"};
SR.constants.WIS_TO_PHYDEF = { effect = "wisToPhydef", result = "PDef"};

-- Auswrikungen von einfachen Stats
SR.constants.MAX_HP = { effect = "maxHp", result = "HP"};
SR.constants.MAX_MP = { effect = "maxMp", result = "MP"};

SR.constants.bodySlots = {
  ["FeetSlot"] = { "Füße", "Feet", "Pieds", "Pies", "Stopy" },
  ["HandsSlot"] = { "Hände", "Hands", "Mains", "Manos", "Dłonie" },
  ["BackSlot"] = { "Rücken", "Cape", "Capa", "Peleryna" },
  ["LegsSlot"] = { "Unterkörper", "Lower Body","Bas du corps", "Parte inferior del cuerpo", "Nogi" },
  ["MainHandSlot"] = { "Einhand", "1-H", "Haupthand", "2-H","\195\160 une main", "\195\160 deux mains", "Haupthand", "Mano principal", "Ręka główna" },
  ["RangedSlot"] = { "Fernkampfwaffe", "Ranged weapon", "Arme \195\160 distance", "Arma a distancia", "Broń Dystansowa" },
  ["ShoulderSlot"] = { "Schulter", "Shoulder", "\195\137paule", "Hombro", "Ramiona" },
  ["AmmoSlot"] = { "Munition", "Ammunation", "Munitions", "Munici\195\179n", "Amunicja" },
  ["AdornmentSlot"] = { "Schmuckstück", "Trinket", "breloque", "Breloque", "Baratija", "Ozdoba" },
  ["SecondaryHandSlot"] = { "Sekundär", "Off-hand", "2-H", "Main secondaire", "Mano segundaria", "Druga Ręka" },
  ["WaistSlot"] = { "Hüfte", "Waist", "taille", "Taille", "Cintura" , "Pas" },
  ["ChestSlot"] = { "Oberkörper", "Upper Body", "Haut du corps", "Parte superior del cuerpo", "Tułów" },
  ["HeadSlot"] = { "Kopf", "Head", "T\195\170te", "Cabeza", "Głowa" },
  --["Talisman2Slot"] = { "Füße", "Feet" }, -- noch keine Lösung
  --["Talisman1Slot"] = { "Füße", "Feet" }, -- noch keine Lösung
  ["Talisman0Slot"] = { "Talisman", "Talisman" , "Talizman" },
  ["NecklaceSlot"] = { "Halskette", "Necklace", "collier", "Collier", "Collar", "Naszyjnik" },
  ["Earring1Slot"] = { "Ohrring", "Earrings", "Boucles d'oreilles", "Pendientes", "Kolczyki" },
  ["Earring0Slot"] = { "Ohrring", "Earrings", "Boucles d'oreilles", "Pendientes", "Kolczyki" },
  ["Ring1Slot"] = { "Ring", "Ring", "Anneau", "Anillo", "Pierścień" },
  ["Ring0Slot"] = { "Ring", "Ring", "Anneau", "Anillo", "Pierścień" }
}
  
  
  
  