-- coding: utf-8

-- update VN.LUA too !
return
{
    DN_F_COUNT = "Count",
    DN_F_TARGET= "Target",
    DN_F_LEVEL = "Level",
    DN_F_NAME  = "Name",
    DN_F_ZONE  = "Zone",
    DN_F_ITEM  = "Item",
    DN_F_REW1  = "XP",
    DN_F_REW2  = "Energy",
    DN_F_DAILIES = "Dailies:",
    DN_F_FINISHED = "to turn in:",
    DN_F_C_ZONE   = "Zone",
    DN_F_Q_TAKE   = "Auto-Quest",
    DN_F_Q_ALL    ="all    <tooltip>mark all quests",
    DN_F_Q_NONE   ="none   <tooltip>clear all marks",
    DN_F_Q_KILL   ="kill   <tooltip>mark kill quest\n(quests where no items are needed)",
    DN_F_Q_GATHER ="gather <tooltip>mark gather Quests\n(quest where the items can only be collected if quest is active)",
    DN_F_Q_OPTIONS="Options<tooltip>Show Option-Dialog",

    DN_CFG_RESET = "reinitialize",

    CFG_TITLE = "DailyNotes - Options",
    F_MAINCHAR="only mainclass",
    F_SECCHAR= "only sec.class",

    ERR_DAILIES = "10 dailies already done.",
    ERR_QUESTS  = "Questbook full.",

    KILLCOUNT = "|cffFCCF00%i for %s",
    QSTART= "Start: %s",
    QEND  = "End: %s",
    QSTARTEND = "Start/End: %s",
    QPOS = "|cff909090(%s: %g/%g)",
    XP = "XP: %i   Gold/Token: %i/%i",
    ENERGY = "Energy: %i",
    DROPSITEM= "Daily-Drop: |cfff0d030%s",
    INVOLVED = "Daily-Quest: |cfffccf00%s",
    COUNT = "%i/%i for %s",
    FIN   = "|cffA0A0FF Enough for: %i time(s)",
    NEED  = "|cffff8080 Need: %i",
    NEEDSOTHER = "|cffff8080 Needs other item",
    PREQUEST = "|cffff0000Req. Quest: ",

    FIND_START= "find start NPC: |cffe0e000",
    FIND_NPC  = "find NPC: |cffe0e000",
    FIND_MOB  = "find |cffe01010",
    FIND_END  = "find reward NPC: |cffe0e000",

    COUNT_FIN  = "only status: Finished",
    COUNT_START= "only status: Started",

    REPEATABLE= "Repeatable quests",
    EPIC= "Epic quests",
    DAILY= "Daily quests",
    PUBLIC=  "Public quests",

    UNDONE= "only not done",

    FILTER_ENERGY= "Energy quests",
    FILTER_XP= "",
    FILTER_CLEAR= "reset filter",

    ZONE_ALL = "All Zones",
    ZONE_CUR = "Current Zone",
    ZONE_YLAB = "Ystra-Lab",

    CFG_CHARLVL= "Show required instead of quest-level",
    DN_CFG_TAKER = "Auto-Accept only with enough items",
    DN_CFG_VERBOSE= "Verbose Infos",
    DN_CFG_COUNTER = "Show item count on loot",
    DN_CFG_DQ_ONLY = "only for DQ items",
    DN_CFG_VERBOSE_QUEST = "include quest text",
    CFG_TT_MOBS   = "Tooltip on monsters",
    CFG_TT_ITEMS  = "Tooltip on items",
    CFG_TT_DIALOG = "Tooltip in dialog",
    CFG_ZBAGHOOK  = "Highlight items",
    CFG_UNDONEQUEST="Display first-time quests",

    CONFIG_CLEAR = "Clear DailyNotes-Entry in Savevariable.lua.\nAre you sure?",
    DAILIES_RESET= "Daily quest available again",
    AAHFILTER = "Daily-Items. With /<min_xp>/<max_level> (optional)",

    -- Tooltips
    T_ZONE    = "Only show quests of current zone.",
    T_COUNT   = "filter by count",
    T_LVL1    = "Show quests in level-range of mainclass",
    T_LVL2    = "Show quests in level-range of secondaryclass",
    T_AUTOQUEST="Every marked quest will be accepted and complete automatical if a NPC or bulletin board is opened.\nCollection quest are only auto accepted if quest conditions are fulfilled.",
    T_CHARLVL = "Switch between quest-level and required player level display.",
    T_TAKER = "(standard) Quests are only auto-accepted\nwhen enough items are in inventory.",
    T_VERBOSE = "Show extra NPC-Positions\n(Item-Tooltips like the Dialog-Tooltips)",
    T_COUNTER = "Display inventory item count in loot message",
    T_DQ_ONLY = "Show count only if item is a daily-quest item",
    T_VERBOSE_QUEST = "Show quest text in tooltip",
    T_TT_MOBS   = "Show in Monster-Tooltips if they are involved in a Daily-Quest.",
    T_TT_ITEMS  = "Show infos in item Tooltips",
    T_TT_DIALOG = "Show full informations in DailyNotes-Dialog",
    T_ZBAGHOOK  = "Highlight Daily-Items in bag (ZBag required)",
    T_UNDONEQUEST="Display first-time quests like a normal quest in NPC-Dialog",
    T_RESET = "Resets all DailyNotes-Settings\n(Option and AutoQuest settings)",
}
