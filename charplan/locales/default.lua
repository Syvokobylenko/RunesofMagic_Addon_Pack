-- coding: utf-8
local default_text={

    TITLE_EMPTY = "<unnamed>",
    MENU_TITLE = "Menu",
    MENU_IMPORT= "Import current equipment…",
    MENU_LOAD= "Load Items",
    MENU_SAVE= "Save Items",
    MENU_SAVEAS= "Save Items as…",
    MENU_COMPARE= "Compare stats",
    MENU_DEL= "Delete saved",
    MENU_CLEARALL = "Clear Items",

    DLG_WAIT_INV= "Please wait while we enumerate your equipment…",
    DLG_SAVENAME= "Enter Name",
    ENUMERATE_CANCELED = "Enumeration canceled!",

    CONTEXT_MENU = "Add to plan",
    CONTEXT_PIMPME= "Pimp",
    CONTEXT_SEARCH= "Search",
    CONTEXT_SHARE = "Copy stats to…",
    CONTEXT_SHARE_STATS = "copy stats",
    CONTEXT_SHARE_RUNES = "copy runes",
    CONTEXT_SHARE_VALUES = "copy base values",
    CONTEXT_CLEAR = "Clear",

    ERROR_NOSLOT = "A free Bag Slot is needed to import your current equipment!",
    ERROR_PICKEDUPITEM = "There was a problem while scanning equipment! Check your current equipment!",
    ERROR_SEARCH_SKIN = "Skin is ambiguous and could be wrong for «%s»!",
    ERROR_NO_VALID_ITEM= "Not a valid equipment.",

    PIMP_TIER = TEXT("_glossary_00703"),
    PIMP_STAT = "Stat %i",
    PIMP_RUNE = "Rune %i",  -- SYS_ITEMTYPE_24
    PIMP_DURA = TEXT("SYS_ITEM_DURABLE"),
    PIMP_PLUS = "Plus",
    PIMP_FILTER1 = "<Name>",
    PIMP_FILTER2 = "<Stat1>",
    PIMP_FILTER3 = "<Stat2>",
    PIMP_FILTER4 = "min",
    PIMP_FILTER5 = "max",
    PIMP_COPY = "Copy to…",
    PIMP_COPY_TO_ALL = "… all items",
    PIMP_CLEAR = "Clear",
    PIMP_CLEAR_TIP = "requires double click",

    SEARCH_TITLE = "Item search",
    SEARCH_NAME = C_NAME,
    SEARCH_LEVEL = C_LEVEL,
    SEARCH_BASE_STATS = "Dmg/Def",
    SEARCH_STATS = "Stats",
    SEARCH_NOSTATLESS = "hide costumes",
    SEARCH_NOSTATLESS_TIP = "Don't show items without attributes (e.g. costumes, wings)",
    SEARCH_ONLYSET = "itemsets only",
    SEARCH_TYPE = "Type",
    SEARCH_POWER_MODIFY = "%i Dura",
    SEARCH_FILTER_NIL = C_ALL,

    SEARCH_USE_SLOT1 = "Put into Slot 1",
    SEARCH_USE_SLOT2 = "Put into Slot 2",
    SEARCH_CONTEXT_TAKE = "Equip Item",
    SEARCH_CONTEXT_SUIT = "Equip Suit",
    SEARCH_CONTEXT_SKIN = "Apply Skin",
    SEARCH_CONTEXT_WEB = "Open in Webbrowser",
    SEARCH_WEBSITE = "http://www.runesdatabase.com/item/%i",
    SEARCH_DROPPED = "Dropped in: %s by %s",
    SEARCH_SELLED  = "Selled at shop id %d for",
    SEARCH_MADE  = "Made by %s",
    SEARCH_UNIQUE_SKINS = "Unique skin",
    SEARCH_FILTER_STATS = "Stats",
    SEARCH_GENDER = "all genders",
    SEARCH_FILTER = "Filter",
    SEARCH_UNNAMED = "unnamed items",

    SEARCH_RARITY_EXACT = "only this rarity",
    SEARCH_RARITY_MINIMUM = "at least this rarity",

    BY_CLASS = "Base",
    BY_SKILL = "Skill",
    BY_CARD = TEXT("AC_ITEMTYPENAME_6"),
    BY_SET = "Sets",
    BY_PET = "Pet",
    BY_TITLE = C_TITLE,

    STAT_SHORTS = {
        PDMG="PDMG",
        PDEF="PDEF",
        MDEF="MDEF",
        MDMG="MDMG",
        DPS="DPS"
        },

    STAT_NAMES= {
        -- categories
        BASE = TEXT("TOOLTIPS_LIMIT_ATTR"),
        MAGIC = TEXT("MAGIC"),
        MELEE = TEXT("MELEE"),
        RANGE = TEXT("RANGE"),
        MAGICDEFENCE = TEXT("MAGIC_DEFENCE"),
        PHYSICALDEFENCE = TEXT("PHYSICAL_DEFENCE"),
		MELEEOFFHAND = (TEXT("MELEE").." - "..TEXT("SYS_EQWEARPOS_16")),

		--Base
        STR =C_STR,
        STA =C_STA,
        DEX =C_AGI,
        INT =C_INT,
        WIS =C_MND,

        HP = TEXT("SYS_HEALTH"),
        MANA = TEXT("SYS_MANA"),

        -- Melee
        PDMG =C_PHYSICAL_DAMAGE,
        PDMGMH =C_PHYSICAL_DAMAGE,
        PDMGOH =C_PHYSICAL_DAMAGE,
        PATK =C_PHYSICAL_ATTACK,
        PCRIT =C_PHYSICAL_CRITICAL,
        PCRITMH =C_PHYSICAL_CRITICAL,
        PCRITOH =C_PHYSICAL_CRITICAL,
        PACCMH =C_PHYSICAL_HIT,
        PACCOH =C_PHYSICAL_HIT,

        --Range
        PDMGR =C_PHYSICAL_DAMAGE,
        PATKR =C_PHYSICAL_ATTACK,
        PCRITR =C_PHYSICAL_CRITICAL,
        PACCR =C_PHYSICAL_HIT,

        --Magic
        MDMG =C_MAGIC_DAMAGE,
        MATK =C_MAGIC_ATTACK,
        MCRIT =C_MAGIC_CRITICAL,
        MHEAL =C_MAGIC_HEAL_POINT,
        MACC =C_MAGIC_HIT ,

        --PDef
        PDEF =C_PHYSICAL_DEFENCE,
        PARRY =C_PHYSICAL_PARRY,
        EVADE =C_PHYSICAL_DODGE,
        PACC =C_PHYSICAL_HIT,

        --MDef
        MDEF =C_MAGIC_DEFENCE,
        MRES =C_MAGIC_DODGE,

        --[[
        PDMGMD =C_PHYSICAL_MAIN_DAMAGE,
        PDMGOD =C_PHYSICAL_OFF_DAMAGE,
        PDMGRD =C_PHYSICAL_DAMAGE,
        ]]--
        PCRITDMG = TEXT("SYS_WEAREQTYPE_19"),
        MCRITDMG = TEXT("SYS_WEAREQTYPE_21"),
    },
}

Charplan.L = Charplan.L or default_text
Charplan.L.STAT_NAMES = Charplan.L.STAT_NAMES or {}
Charplan.L.STAT_SHORTS = Charplan.L.STAT_SHORTS or {}
setmetatable(Charplan.L, {__index = default_text})
setmetatable(Charplan.L.STAT_NAMES, {__index = default_text.STAT_NAMES})
setmetatable(Charplan.L.STAT_SHORTS, {__index = default_text.STAT_SHORTS})

