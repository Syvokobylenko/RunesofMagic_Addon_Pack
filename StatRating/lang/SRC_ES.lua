--[[ language file for: ES
   Translater: snoopycurse
   Licence: http://creativecommons.org/licenses/by-nc-sa/3.0/
   $Rev: 134 $
   Credits to: Tschuss
]]

SRC_Texts = {};

SRC_Texts = {
  ["Stats"] = {
    ["DEX_TO_DPS"] = "destreza a DPS",
    ["DEX_TO_PHYDEF"] = "destreza a defensa física",
    ["DEX_TO_PHYATT"] = "destreza a daño físico",
    ["DEX_TO_PHYDOD"] = "destreza al regate físico",
    ["DEX_TO_PHYACC"] = "destreza a la exactitud física",
  
    ["INT_TO_MAGATT"] = "inteligencia a daño mágico",
    ["INT_TO_MP"] = "inteligencia a PM",
    ["INT_TO_PHYATT"] = "inteligencia a daño físico",
    
    ["PHYDEF_TO_MAGDEF"] = "defensa física a defensa mágica",
    
    ["STA_TO_LIFE"] = "vitalidad a puntos de vida",
    ["STA_TO_PHYDEF"] = "vitalidad a defensa física",
    ["STA_TO_HP5"] = "vitalidad a regeneración de vida",
    
    ["STR_TO_DPS"] = "fuerza a DPS",
    ["STR_TO_HP"] = "fuerza a PV",
    ["STR_TO_PHYATT"] = "fuerza a defensa física",
    
    ["WIS_TO_MAGDEF"] = "sabiduría a defensa mágica",
    ["WIS_TO_MP"] = "sabiduría a PM",
    ["WIS_TO_MP5"] = "sabiduría a regeneracion de mana",
    ["WIS_TO_PHYDEF"] = "sabiduría a defensa física"
  },
  ["general"] = {
    ["char"] = "personaje",
    ["commit"] = "Guardar configuración",
    ["Durability"] = "Durabilidad",
    ["Food"] = "Alimente",
    ["Dessert"] = "Postre",
    ["Receipe"] = "Receta",    
    ["Stat_summary"] = "\226\136\145 Somario:",
    ["isLoaded"] = "cargado. (/src)",
    ["Short_Descr"] = "Muestra los efectos físicos y mágicos de las estadísticas.",
    ["Description"] = "	StatRating agrega a la descripción de las armas y armaduras, una visión general de los efectos que participan varios bonos. Los partidos son sólo estimaciones, los valores exactos no se conocen y puede cambiar rápidamente sobre las versiones."
  },
  ["Tabs"] = {
    ["common"] = "General",
    ["stats"] = "Efectos",
    ["summary"] = "Resumen"
  },
  ["Common"] = {
    ["rate"] = "evaluar objetos",
    ["rateOnALTPressed"] = "evaluar sólo pulsando ALT",
    ["show_summary"] = "muestra el resumen",
    ["color_fix"] = "Corregir colores",
    ["dura_Mod"] = "cambiar data cuando durabilidad mas que 100",
    ["dura_ModAllways"] = "y tambien cando solo durabilidad max es mas que 100",
    ["EstimatedDPS"] = "	El mínimo daño estimado el arma equipada en el objetivo actual: ", 
    ["EstimatedDPSranged"] = "Daño mínimo estimado de arma a distancia equipada en el objetivo actual: ", 
    ["EstimatedDPSmagic"]  = "TODO! ",    
    ["Heal_word"] = " curacion)",    
    ["PowerMod_word"] = "Modificador de poder"  
  },
  ["Summary"] = {
    ["Title"] = "Los siguientes campos se muestran en el resumen",    
    ["TitleEff"] = "Los efectos de las características siguientes serán fijados",
    ["Int"] = "Inteligencia",
    ["Sta"] = "Vitalidad",
    ["Str"] = "Fuerza",
    ["Wis"] = "Sabiduría",
    ["Dex"] = "Destreza",
    ["MP"] = { "PM", "Máximo PM" },
    ["HP"] = { "PV", "Máximo PV" },
    ["MDef"] = "Defensa mágica",
    ["PDef"] = {"Defensa física","Defensa física"},
    ["HP5"] = "Regeneración de vida",
    ["MP5"] = "Regeneracion de mana",
    ["MDmg"] = "Daño mágico",
    ["PDmg"] = {"Daño físico","Daño físico"},
    ["DPS"] = "Daño por segundo",
    ["AA"] = "Todos los atributos",
    ["HEAL"] = "Bono de curación",
    ["PAtt"] = "Ataque físico",
    ["PCrit"] = "Critico físico",
    ["PHit"] = "Golpear físico",
    ["MAtt"] = "Ataque mágico",
    ["MCrit"] = "Crítico mágico",
    ["MHit"] = "Golpear  mágico",
    ["PCritRes"] = "Resintencia a críticos físicos",
    ["Parry"] = "Indice de parada",
    ["PDod"] = "Esquiva física",
    ["MDod"] = "Esquiva mágica",
    ["MCritRes"] = "Resistencia a críticos mágicos",
    ["EFFD"] = "TODO!",
    ["PAcc"] = "Exactitud física",
    ["CritDmg"] = "Critical Damage",
    ["Dmg"] = "Damage",
    ["Speed"] = "Velocidad de ataque"
  },
  ["Skills"] = {
    ["s02"] = "Espada",
    ["s03"] = "Daga",
    ["s04"] = "Varita m\195\161gica",
    ["s05"] = "Hacha",
    ["s06"] = "Porra",    
    ["s07"] = "Espada 2 manos",
    ["s08"] = "Bast\195\179n",
    ["s09"] = "Hacha 2 manos",
    ["s10"] = "Martillo 2 manos",
    ["s11"] = "lanza",
    ["s12"] = "Arco",  
    ["s13"] = "Ballesta",
    ["s14"] = "Pistola"    
  }
}
