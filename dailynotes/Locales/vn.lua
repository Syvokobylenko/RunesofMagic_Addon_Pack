-- coding: utf-8

return
{
    DN_F_COUNT = "Đếm",
    DN_F_TARGET= "Mục tiêu",
    DN_F_LEVEL = "Level",
    DN_F_NAME  = "Tên",
    DN_F_ZONE  = "Vùng",
    DN_F_ITEM  = "Item",     -- NEEDS TRANSLATION
    DN_F_REW1  = "XP",       -- NEEDS TRANSLATION
    DN_F_REW2  = "Energy",   -- NEEDS TRANSLATION
    DN_F_DAILIES = "Hàng ngày:",
    DN_F_FINISHED = "Hoàn thành:",
    DN_F_C_ZONE   = "Vùng",
    DN_F_Q_TAKE   = "Tự động",
    DN_F_Q_ALL    ="Toàn bộ <tooltip>Đánh dấu tất cả",
    DN_F_Q_NONE   ="Mặc định <tooltip>Xóa tất cả",
    DN_F_Q_KILL   ="Tiêu diệt <tooltip>Đánh dấu Quest tiêu diệt\n(nhiệm vụ không cần vật phẩm)",
    DN_F_Q_GATHER ="Thu thập  <tooltip>Đánh dấu những Quest thu thập\nNhiệm vụ cần vật phẩm mà chỉ thu thập được khi nhận)",
    DN_F_Q_OPTIONS="Tùy chọn<tooltip>Hiển thị bảng tùy chọn",
    DN_CFG_RESET = "Khởi tạo lại",

    CFG_TITLE = "DailyNotes - Tùy chọn",
    F_MAINCHAR="chỉ lớp chính",
    F_SECCHAR= "chỉ lớp phụ",

    ERR_DAILIES = "10 dailies already done.", -- NEEDS TRANSLATION
    ERR_QUESTS  = "Questbook full.",          -- NEEDS TRANSLATION

    KILLCOUNT = "|cffFCCF00%i for %s", -- NEEDS TRANSLATION
    QSTART= "Bắt đầu: %s",
    QEND  = "Kết thúc: %s",
    QSTARTEND = "Bắt đầu/Kết thúc: %s",
    QPOS = "|cff909090(%s: %g/%g)",
    XP = "XP: %i   Vàng/Token: %i/%i",
    ENERGY = "Energy: %i", --  NEED TRANSLATE
    DROPSITEM= "Daily-Drop: |cfff0d030%s", -- NEED TRANS
    INVOLVED ="Nhiệm vụ ngày: |cfffccf00%s",
    COUNT = "\n|cffFCCF00%i/%i for %s", -- NEED TRANS
    FIN   = "|cffA0A0FF Đủ cho: %i lần",
    NEED  = "|cffff8080 Cần: %i",
    NEEDSOTHER = "|cffff8080 Cần các vật phẩm khác",
    PREQUEST = "|cffff0000Req. Quest: ", -- NEED TRANSLATE

    FIND_START= "Bắt đầu tìm NPC: |cffe0e000",
    FIND_NPC  = "Tìm NPC: |cffe0e000",
    FIND_MOB  = "Tìm |cffe01010",
    FIND_END  = "Tìm NPC phần thưởng: |cffe0e000",

    COUNT_FIN  = "only status: Finished", -- NEED TRANSLATE
    COUNT_START= "only status: Started", -- NEED TRANSLATE

    REPEATABLE= "Repeatable quests",
    EPIC= "Epic quests",
    DAILY= "Daily quests",
    PUBLIC=  "Public quests",

    UNDONE= "only not done", -- NEED TRANSLATE

    FILTER_ENERGY= "Energy quests", -- NEED TRANSLATE
    FILTER_XP= "XP quests", -- NEED TRANSLATE
    FILTER_CLEAR= "reset filter", -- NEED TRANSLATE

    ZONE_ALL = "Vùng",
    ZONE_CUR = "Vùng hiện tại",
    ZONE_YLAB = "Mê cung Ystra ",

    CFG_CHARLVL= "Cấp độ nhân vật thay vì cấp nhiệm vụ",
    DN_CFG_TAKER = "Tự động nhận nhiệm vụ",
    DN_CFG_VERBOSE= "Thông tin NPC",
    DN_CFG_COUNTER = "Hiển thị số vật phẩm trên bảng nhặt đồ",
    DN_CFG_DQ_ONLY = "Chỉ dành cho đồ nhiệm vụ Ngày",
    DN_CFG_VERBOSE_QUEST = "Bao gồm cả nội dung của nhiệm vụ",
    CFG_TT_MOBS   = "Tooltip on monsters", -- NEEDS TRANSLATION
    CFG_TT_ITEMS  = "Tooltip on items", -- NEEDS TRANSLATION
    CFG_TT_DIALOG = "Tooltip in dialog", -- NEEDS TRANSLATION
    CFG_ZBAGHOOK  = "Highlight items", -- NEEDS TRANSLATION
    CFG_UNDONEQUEST="Display first-time quests", -- NEEDS TRANSLATION


    CONFIG_CLEAR = "Xóa toàn bộ các chỉ mục trong file Savevariable.lua.\nBạn có chắc chắn không?",
    DAILIES_RESET= "Daily quest available again", -- TRANSLATE
    AAHFILTER = "Daily-Items. With /<min_xp>/<max_level> (optional)", -- TRANSLATE

    -- Tooltips
    T_ZONE    = "Chỉ hiển thị nhiệm vụ của các vùng hiện tại.",
    T_COUNT   =  "filte by count",
    T_LVL1    = "Hiển thị Quest trong phạm vi LV class chính",
    T_LVL2    = "Hiển thị Quest trong phạm vi LV class phụ",
    T_AUTOQUEST="Nhiệm vụ được đánh dấu sẽ được tự động nhận và trả mỗi khi hội thoại của NPC hoặc Bảng thông báo được mở.\nNhiệm vụ thu thập chỉ được nhận tự động nếu đã thu thập đủ vật phẩm.",
    T_CHARLVL = "Sự chuyển đổi cấp nhiệm vụ và hiển thị mức độ lv người chơi cần thiết.",
    T_TAKER = "(standard) Nhiệm vụ chỉ chấp nhận khi đủ vật phẩm trong túi đồ.",
    T_VERBOSE = "Hiển thị thêm vị trí NPC dưới bảng con",
    T_COUNTER = "Hiển thị số vật phẩm trong thông báo nhặt đồ",
    T_DQ_ONLY = "Chỉ hiện thị số đếm nếu là đồ nhiệm vụ Ngày",
    T_VERBOSE_QUEST = "HIển thị nội dung của nhiệm vụ trong chỉ dẫn",
    T_TT_MOBS   = "Show in Monster-Tooltips if they are involved in a Daily-Quest.", -- NEED TRANS
    T_TT_ITEMS  = "Show infos in item Tooltips", -- NEED TRANS
    T_TT_DIALOG = "Show full informations in DailyNotes-Dialog", -- NEED TRANS
    T_ZBAGHOOK  = "Highlight Daily-Items in bag (ZBag required)", -- NEEDS TRANSLATION
    T_RESET = "Thiết lập lại toàn bộ các cài đặt trong DailyNotes-\n(Tùy chọn và các thiết lập Nhiệm vụ tự động)",
    T_UNDONEQUEST="Display first-time quests like a normal quest in NPC-Dialog", -- NEED TRANS
}
