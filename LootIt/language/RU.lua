LI_Transtext = {
	ACTIVE = "активен", -- Needs review
	ADD_BUTTON_TOOLTIP = "Добавляет этот фильтр к личным фильтрам. Чтобы сохранить фильтр для всех персонажей, удерживайте Ctrl.", -- Needs review
	ADD_LINK = "добавить", -- Needs review
	ADD_LINK_HELP = "обучение", -- Needs review
	ADD_MASTERBUTTON_TOOLTIP = "Добавить фильтр в список розыгрыша. Совпадение с фильтром означает, что предмет разыгрывается между членами группы. В противном случае выбор осуществляется вручную.", -- Needs review
	ADDMESSAGE_ADD = "Предмет «%s» добавлен к фильтрам.", -- Needs review
	ADDMESSAGE_REMOVE = "Предмет «%s» удалён из фильтров.", -- Needs review
	ADDONMANAGER_DESCRIPTION = "Автоматизация подбора добычи.",
	ALLOW_DICE = "Можно разыгрывать:", -- Needs review
	AUTOGREED = "АвтоЖадность",
	AUTOLOOT = "АвтоПодбор",
	AUTOPASS = "АвтоОтказ",
	BLACKLIST_ADDED = "This item was added to the blacklist.", -- Requires localization
	BOSSKILL = "Boss kill", -- Requires localization
	CHECK_DATABASE = "Check database", -- Requires localization
	COLLECT = "Взять",
	DEL_BUTTON_TOOLTIP = "Удалить этот фильтр.", -- Needs review
	DESC_RAIDNAME = "Raid name", -- Requires localization
	DESC_SPIN = "sPIN", -- Requires localization
	DESC_SYSTEMID = "System-ID", -- Requires localization
	DISCARD = "Выбросить",
	DKP = "DKP", -- Requires localization
	DKP_FILE_ERROR = "System could not be loaded. Please check the ID and make sure that the file was not renamed or misplaced. Only files in the directory 'interface/DKP/' will be loaded.", -- Requires localization
	DKP_FILE_LOADED = "System successfully loaded. Downloaded data is now available.", -- Requires localization
	EMPTY = "not yet recorded", -- Requires localization
	ENTER_SPIN = "Please enter your currently valid sPIN (from the LootIt! DKP website):", -- Requires localization
	ENTER_SYSTEM = "Please enter the system ID in which the data should be entered:", -- Requires localization
	ENTER_TEXT = "Raid name:", -- Requires localization
	EXAMPLE_FILTER_HELP = "Напечатайте здесь проверяемые фильтры.", -- Needs review
	EXAMPLE_LINK_HELP = "ПКМ на ссылке на предмет в чате или перетащите предмет на это поле, чтобы перейти в обучение.", -- Needs review
	EXPLAIN_5PLUS4 = "Возможно расширение с символом & ", -- Needs review
	EXPLAIN_CLASS = "Текущий основной класс", -- Needs review
	EXPLAIN_FILTER1 = "Возможности:",
	EXPLAIN_FILTER10 = "5) Специальные ключевые слова",
	EXPLAIN_FILTER11 = [=[!mingold 999 - предмет дороже 999 золота.
!maxgold 999 - предмет дешевле 999 золота.]=], -- Needs review
	EXPLAIN_FILTER12 = "Предложения о других фильтрах обсуждаются на Curse.com.", -- Needs review
	EXPLAIN_FILTER13 = [=[!mindura 99 - прочность предмета больше 99.
!maxdura 99 -  прочность предмета меньше 99.]=], -- Needs review
	EXPLAIN_FILTER14 = "Фильтр !$ применяется как $-фильтр", -- Needs review
	EXPLAIN_FILTER15 = [=[!mincharlevel 99 - уровень игрока не ниже 99.
!maxcharlevel 99 - уровень игрока не выше 99.]=], -- Needs review
	EXPLAIN_FILTER16 = [=[!minitemlevel 99 - уровень предмета не менее 99.
!maxitemlevel 99 - уровень предмета не более 99.]=], -- Needs review
	EXPLAIN_FILTER17 = [=[!minstacks 99 Itemname - Не менее 99 стеков предмета в рюкзаке.
 !maxstacks 99 Itemname - Не более 99 стеков предмета в рюкзаке.]=], -- Needs review
	EXPLAIN_FILTER18 = [=[!mincount 99 Itemname - Не менее 99 предметов в рюкзаке.
 !maxcount 99 Itemname - Не более.99 предметов в рюкзаке.]=], -- Needs review
	EXPLAIN_FILTER19 = "Символ | обозначает отрицание.", -- Needs review
	EXPLAIN_FILTER2 = "1) Полное имя предмета:",
	EXPLAIN_FILTER20 = [=[!minstats 9 - the item has min. 9 stats.
!maxstats 9 - the item has max. 9 stats.]=], -- Requires localization
	EXPLAIN_FILTER21 = "Hashtag filter: valid only if the same hashtag was set in the options.", -- Requires localization
	EXPLAIN_FILTER22 = [=[!minbstacks 99 Itemname - !minstacks for the bank.
!maxbstacks 99 Itemname - !maxstacks for the bank.]=], -- Requires localization
	EXPLAIN_FILTER23 = [=[!minbbstacks 99 Itemname - !minstacks for bank + bag.
!maxbbstacks 99 Itemname - !maxstacks for bank + bag.]=], -- Requires localization
	EXPLAIN_FILTER24 = [=[!minbcount 99 Itemname - !mincount for bank.
!maxbcount 99 Itemname - !maxcount for bank.]=], -- Requires localization
	EXPLAIN_FILTER25 = [=[!minbbcount 99 Itemname - !mincount for bank + bag.
!maxbbcount 99 Itemname - !maxcount for bank + bag.]=], -- Requires localization
	EXPLAIN_FILTER26 = "Addition can the %% been used as OR operator.", -- Requires localization
	EXPLAIN_FILTER27 = "With [] logical instructions can been capsuled.", -- Requires localization
	EXPLAIN_FILTER3 = "Обрабатывается только этот конкретный предмет.",
	EXPLAIN_FILTER4 = "2) Часть имени, символ \"маски\" - *",
	EXPLAIN_FILTER5 = "Обрабатываются множество предметов. Символ маски (\"звездочка\") может заменяться произвольным текстом. Полезно для предметов с похожими именами и функциями, например, \"* зелье\".",
	EXPLAIN_FILTER6 = "3) Просмотр свойств предмета в описании (тип, стат и т.п.) - $",
	EXPLAIN_FILTER7 = "Проверяется описание объекта. Например, этот фильтр ищет руны.",
	EXPLAIN_FILTER8 = "4) Поиск нескольких свойств в описании, например тип и стат -$&",
	EXPLAIN_FILTER9 = "Проверяется описание объекта. Этот фильтр, например, находит руны 2 уровня.",
	EXPLAIN_FILTER_BBCOUNT = "number in bank + bag", -- Requires localization
	EXPLAIN_FILTER_BBSTACKS = "stacks in bank + bag", -- Requires localization
	EXPLAIN_FILTER_BCOUNT = "number in the bank", -- Requires localization
	EXPLAIN_FILTER_BSTACKS = "stacks in the bank", -- Requires localization
	EXPLAIN_FILTER_CHARLEVEL = "character level", -- Requires localization
	EXPLAIN_FILTER_COUNT = "number in the bag", -- Requires localization
	EXPLAIN_FILTER_DURA = "durability", -- Requires localization
	EXPLAIN_FILTER_FREEBBSLOTS = "number free slots in bank + bag", -- Requires localization
	EXPLAIN_FILTER_FREEBSLOTS = "number free slots in the bank", -- Requires localization
	EXPLAIN_FILTER_FREESLOTS = "number free slots in the bag", -- Requires localization
	EXPLAIN_FILTER_GOLD = "gold", -- Requires localization
	EXPLAIN_FILTER_ITEMLEVEL = "item level", -- Requires localization
	EXPLAIN_FILTER_MAX = "max. X", -- Requires localization
	EXPLAIN_FILTER_MIN = "min. X", -- Requires localization
	EXPLAIN_FILTER_NAME = "name", -- Requires localization
	EXPLAIN_FILTER_PARA = "number of", -- Requires localization
	EXPLAIN_FILTER_PARALINE = [=[Filter by number:
!min/max filters match with a number e.g. %s
§ filters needs one of these additional commands < > <= >= == ~= and a number e.g. %s
]=], -- Requires localization
	EXPLAIN_FILTER_QUALITY = "rarity", -- Requires localization
	EXPLAIN_FILTER_STACKS = "stacks in the bag", -- Requires localization
	EXPLAIN_FILTER_STATS = "number of stats", -- Requires localization
	EXPLAIN_FILTER_USEDBBSLOTS = "number used slots in bank + bag", -- Requires localization
	EXPLAIN_FILTER_USEDBSLOTS = "number used slots in the bank", -- Requires localization
	EXPLAIN_FILTER_USEDSLOTS = "number used slots in the bag", -- Requires localization
	EXPLAIN_FILTERWARNING = "Удалённые предметы нельзя вернуть!", -- Needs review
	EXPLAIN_PIPE = "С символом | фильтр меняет смысл на противоположный.", -- Needs review
	EXPLAIN_QUALITY = "Редкость: %s", -- Needs review
	GOLDDIGGER_AUTOINACTIVE = "Выкидывать уже нечего, режим жадности отключается.", -- Needs review
	HELP_FILTER = "Проверяемый фильтр", -- Needs review
	HELP_ITEMLINK = "Ссылка", -- Needs review
	INACTIVE = "неактивен",
	ITEMFILTER = "Фильтры",
	ITEMOFFICER = "Управляющий", -- Needs review
	LOADED = "успешно загружен",
	LOADING_MESSAGE = "Tinsus plant, forked from Lootomatic (PetraAreon)", -- Needs review
	LOG_HEADLINE = "Recorded information", -- Requires localization
	LOOT = "подбор", -- Needs review
	LOOT_BUTTON_TOOLTIP = "Что делать при подборе этого предмета?", -- Needs review
	LOOTOMATIC_CONVERTED = "Настройки фильтров Lootomatic успешно загружены.", -- Needs review
	MANUAL = "Выбор",
	MESSAGE_DKP_BROKEN = "The loot settings have been changed. DKP-loot must be confirmed.", -- Requires localization
	MESSAGE_DKP_DONE = "DKP-loot has been accepted.", -- Requires localization
	MESSAGE_DKP_FAIL = "DKP-loot has been rejected.", -- Requires localization
	MESSAGE_DKP_SET = [=[%s should be appointed as the DKP administrator.

Please confirm that you agree to save this run in the DKP system.

The loot threshold is % s.]=], -- Requires localization
	MESSAGE_ITEMADMIN_BROKEN = "Изменились настройки подбора. Подтвердите нового управляющего добычей.", -- Needs review
	MESSAGE_ITEMADMIN_DONE = "Управляющий добычей подтвержден.", -- Needs review
	MESSAGE_ITEMADMIN_FAIL = "Управляющий добычей отвергнут.", -- Needs review
	MESSAGE_ITEMADMIN_SET = [=[%s следует назначить управляющим добычей.

Пожалуйста, подтвердите согласие с назначением данного управляющего.

Распределение начиная с: %s.]=], -- Needs review
	NEVER = "Нет",
	NEXTSTAT = [=[Распределение: этот стат для %s.
(%s)]=], -- Needs review
	NO_BOSSES = "Выкл. на Боссах",
	OPTION_HASHTAG_TITLE = "Hashtag filter", -- Requires localization
	OPTION_HASHTAG_TOOLTIP = "Add a hashtag here. Filters with exactly this added hashtag are valid, any other hashtags at your filters will not work. If you add \"01\" here, all filters with !#01 are valid, but not filters with !#Cookie. If you set \"Cookie\" here the filter validness is inverted. By splitting the input useing ; multiple hashtags can be valid.", -- Requires localization
	OPTION_HEADLINE_ACTIVE = "Включить",
	OPTION_HEADLINE_ADDMESSAGE = "Лог в чат",
	OPTION_HEADLINE_ASKAFTER = "Подтверждать предметы в стопках, начиная с: %s", -- Needs review
	OPTION_HEADLINE_AUTODKP = "Auto confirmation", -- Requires localization
	OPTION_HEADLINE_BAGBUTTON = "Bagbutton", -- Requires localization
	OPTION_HEADLINE_CLOSE = "Закрыть после подбора",
	OPTION_HEADLINE_COUNTAMMO = "%s боеприпасов = 1 предмет", -- Needs review
	OPTION_HEADLINE_CURSOR = "Окно возле мышки",
	OPTION_HEADLINE_DELAY = "Задержка: %s сек.",
	OPTION_HEADLINE_HISTORY = "История ролла",
	OPTION_HEADLINE_HISTORYNUM = "Кол-во отображаемых предметов из истории: %s ", -- Needs review
	OPTION_HEADLINE_IMPROVETOOLTIPS = "Подсказки к розыгрышу", -- Needs review
	OPTION_HEADLINE_MINIMAP = "Кнопка на миникарте",
	OPTION_HEADLINE_NOFILTER = "Отключить фильтры", -- Needs review
	OPTION_HEADLINE_NOSCANTIP = "Спрятать всплывающие подсказки.", -- Needs review
	OPTION_HEADLINE_OTHERSTYLE = "Стиль Lootomatic", -- Needs review
	OPTION_HEADLINE_RANGE = "Диапазон",
	OPTION_HEADLINE_READONLY = "Readonly", -- Requires localization
	OPTION_HEADLINE_REMOVELESSGOLD = "Жадина", -- Needs review
	OPTION_HEADLINE_SAVEQUEST = "Подтверждать особые предметы", -- Needs review
	OPTION_HEADLINE_SECUWAIT = "Отмена через: %s сек.",
	OPTION_HEADLINE_STATROTA = "Распределение статов", -- Needs review
	OPTION_HEADLINE_TESTING = "Проверка фильтров",
	OPTIONS_HEADLINE_MOVEBUTTON = "Переместить ролл",
	OPTIONS_HEADLINE_ROLLBUTTON = "Настройка ролла",
	OPTION_TOOLTIP_ACTIVE = "Активирует LootIt.",
	OPTION_TOOLTIP_ADDMESSAGE = "Показывает в чате изменения в фильтрах.", -- Needs review
	OPTION_TOOLTIP_ASKAFTER = "При выбросе стопки с таким или большим количеством, запрашивается подтверждение.", -- Needs review
	OPTION_TOOLTIP_AUTODKP = "Requests for the loot methods item officer and DKP are automatically accepted.", -- Requires localization
	OPTION_TOOLTIP_BAGBUTTON = "Show/Hide the bag button.", -- Requires localization
	OPTION_TOOLTIP_CLOSE = "Окно добычи закрывается сразу после автоподбора.",
	OPTION_TOOLTIP_COUNTAMMO = "Это количество боеприпасов считается 1 предметом. При удалении запрашивается подтверждение.", -- Needs review
	OPTION_TOOLTIP_CURSOR = "Новое окно добычи открывается прямо под указателем мыши.",
	OPTION_TOOLTIP_DELAY = "Задержка окна розыгрыша перед автоматическим выбором.", -- Needs review
	OPTION_TOOLTIP_HISTORY = "Отображает историю предметов, полученных группой.", -- Needs review
	OPTION_TOOLTIP_HISTORYNUM = "Если история слишком велика Вы можете ограничить количество предметов в этов пункте.", -- Needs review
	OPTION_TOOLTIP_IMPROVETOOLTIPS = "Дополнительная информация по горячим клавишам во всплывающих подсказках в окне розыгрыша.",
	OPTION_TOOLTIP_MINIMAP = "Показать/спрятать кнопку на миникарте.",
	OPTION_TOOLTIP_NOFILTER = "При подборе предметов отключаются фильтры, действуют только настройки АвтоПодбора.", -- Needs review
	OPTION_TOOLTIP_NOSCANTIP = "Если вы заметили, что всплывающая подсказка (или подсказка сравнения) показывает неверную информацию или возникает случайным образом, причина может быть в проверке предметов этим аддоном. С этой опцией открывшиеся подсказки будут убраны.", -- Needs review
	OPTION_TOOLTIP_OTHERSTYLE = "Пишет результаты розыгрыша в чат в стиле Lootomatic.",
	OPTION_TOOLTIP_RANGE = "Позволяет использовать диапазоны в АвтоЖадности, АвтоПодборе и АвтоОтказе. Например, можно отказываться от дешёвых предметов и собирать дорогие.",
	OPTION_TOOLTIP_READONLY = "While this option is active your filters can't been edited.", -- Requires localization
	OPTION_TOOLTIP_REMOVELESSGOLD = "Если в рюкзаке свободно меньше двух ячеек, выбрасываются самые дешёвые предметы, не защищённые другими фильтрами.", -- Needs review
	OPTION_TOOLTIP_SAVEQUEST = "Для удаления предметов для заданий, уникальных и предметов из магазина нужно подтверждение, если фильтр не на конкретно этот предмет.", -- Needs review
	OPTION_TOOLTIP_SECUWAIT = "Ожидать подтверждение удаления указанный период, затем удаление отменяется.", -- Needs review
	OPTION_TOOLTIP_STATROTA = "Если группа получает фиолет с жёлтым статом, мод предлагает, кому его отдать. Предлагается тот, кто получил меньше всех статов. Если несколько человек получили одинаковое количество статов, соблюдается алфавитный порядок. Распределение статов ведётся индивидуально для каждой группы. Информация не хранится и не выводится в чат.", -- Needs review
	OPTION_TOOLTIP_TESTING = "Включает режим \"безопасной\" проверки фильтров. Предметы не выбрасываются, вместо этого в чат выводится сообщение.", -- Needs review
	OTHER_FILTERS = [=[LootIt!

Пожалуйста, проверьте фильтры.

"Выбор" означает, что предметы не подбираются и не разыгрываются.]=], -- Needs review
	PLUGIN_DESC = "Показывать настройки подбора на ZZInfoBar.", -- Needs review
	PLUGIN_NAME = "LootIt!", -- Needs review
	PLUGIN_USER = "ПКМ: контекстное меню.", -- Needs review
	RAID_END = "Raid ending", -- Requires localization
	RAID_START = "Raid start", -- Requires localization
	READONLY_WARNING = "The \"Readonly\"-option is active. Deactivate it in the settings to be able to edit your filters. Your current filters have not been edited.", -- Requires localization
	REMOVE_STACK = "Мусорные стопки", -- Needs review
	REMOVE_STACK_TOOLTIP = "Если в рюкзаке больше заданного количества стопок, выкидывается та, в которой меньше предметов.", -- Needs review
	RESULTWINDOW_HEADLINE = "Показать?", -- Needs review
	ROLL = "розыгрыш", -- Needs review
	ROLL_BUTTON_TOOLTIP = "Что делать при розыгрыше этого предмета?", -- Needs review
	ROLLRESULT_TOOLTIP = "Задаёт, выводятся ли в чат результаты розыгрыша предметов данной редкости.", -- Needs review
	ROLLRESULT_TOOLTIP_LOG = "Задаёт, добавляются ли предметы этой редкости в историю.", -- Needs review
	ROLLRESULT_TOOLTIP_LOOT = "Задаёт, выводятся ли в чат сообщения о подборе предметов данной редкости.", -- Needs review
	ROLLRESULT_TOOLTIP_NOLOG = "Задаёт, удаляются ли предметы этой редкости из истории после автоматического распределения по группе.", -- Needs review
	SEND_TO_WEB = "Transfer data", -- Requires localization
	SPENDGUILD = "Вносить в гильдию", -- Needs review
	START = "Raid starts now", -- Requires localization
	STOP = "Raid was finished", -- Requires localization
	SYSTEM = "System", -- Requires localization
	TESTING_DELETION_MESSAGE = "Предмет «%s» был бы удалён.", -- Needs review
	TICK_CHARSPECIFIC = "Личный", -- Needs review
	TOOLTIP_AUTODICEBUTTON = "Задать АвтоРозыгрыш в зависимости от редкости предмета.", -- Needs review
	TOOLTIP_BAGBUTTON = "Чтобы добавить предмет в фильтр LootIt!, перетащите его сюда.", -- Needs review
	TOOLTIP_DICEALLBUTTON = "Все нераспределённые предметы немедленно оцениваются и распределяются. Пропуск ролла считается отказом.", -- Needs review
	TOOLTIP_HELPBUTTON = "показывать обучение", -- Needs review
	TOOLTIP_RAIDNAME = "Here, a unique raid name has to be deposited. The name can't been changed within a raid, but between different raids/runs.", -- Requires localization
	TOOLTIP_SAVE_ON_ROLL = [=[При удержании Shift, опция добавляется в фильтр предметов.
Если нажат Ctrl, добавляется в этот общий фильтр.]=], -- Needs review
	TOOLTIP_SEND_TO_WEB = "By clicking the recorded information will be sent and stored to the LootIt! DKP website.", -- Requires localization
	TOOLTIP_SPIN = "Here the valid, personal sPIN must be entered, which is displayed after a successful login to the LootIt! DKP website.", -- Requires localization
	TOOLTIP_STARTSTOP = "The beginning or the end of a raid is awarded with one click.", -- Requires localization
	TOOLTIP_SYSTEMID = "Here, the DKP system ID must be specified, in which the data is stored. The system ID will be shown in the system overview. Important: the system data must be downloaded to the '/interface/DKP' dir, so that the loot distribution can been started.", -- Requires localization
	TUTORIAL_ADD_BUTTON = "Добавить фильтр к списку фильтров.", -- Needs review
	TUTORIAL_ALL1 = [=[Просто выберите фильтр. Немедленно будут показаны предложения.
Пробуйте варианты, чтобы понять смысл фильтра.]=], -- Needs review
	TUTORIAL_ALL2 = [=[%s - маска (обозначает любую строку)
%s - поиск в описании предмета
%s - специальный фильтр

%s комбинирует несколько фильтров]=], -- Needs review
	TUTORIAL_COMMUNITY = [=[Многие возможности фильтрации доступны только здесь.
Просто введите имя фильтра и дополнительную информацию.]=], -- Needs review
	TUTORIAL_DOLLER = [=[Указанное слово ищется в описании предмета.
Засчитываются только точные совпадения, если не указан символ маски (*).]=], -- Needs review
	TUTORIAL_FOUND = "Фильтр подходит к предмету!", -- Needs review
	TUTORIAL_NOT_FOUND = "Фильтр НЕ подходит к предмету!", -- Needs review
	TUTORIAL_TOO_SHORT = "Фильтр слишком короткий!", -- Needs review
	TUTORIAL_WILDCARD = "Символ маски (*) заменяет любую последовательность символов.", -- Needs review
	UNKNOWN_COMMAND = "Неизвестная команда", -- Needs review
	UPDATE_MESSAGE = "Обнаружена новая версия!",
	VERSION = "версия", -- Needs review
	WARNING_DKP_CHANGE = "After confirmation of all group members the loot settings are no longer adjustable.", -- Requires localization
	WARNING_ITEMADMIN_CHANGE = "После подтверждения всех членов группы, настройки добычи нельзя будет изменить.", -- Needs review
	ZONENAME = "название области или подземелья", -- Needs review
}

