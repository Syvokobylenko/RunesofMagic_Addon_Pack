AAHLocale = {}
AAHLocale.Commands = {
	BARGAIN = "$перепродажа,$скидка", -- Needs review
	DURA = "$проча,$проч,$прочные,$прочность", -- Needs review
	EGGAPTITUDE = "$навыкяйца,$янав", -- Needs review
	EGGLEVEL = "$уровеньяйца,$яур", -- Needs review
	FIVE = "$пять,$5",
	FOUR = "$четыре,$4",
	GREEN = "$зеленое,$зелень,$зеленка,$зел", -- Needs review
	ONE = "$один,$1",
	ORANGE = "$оранжевое,$оранж", -- Needs review
	PLUS = "$плюс,$+", -- Needs review
	SIX = "$шесть,$6",
	THREE = "$три,$3",
	TIER = "$тир",
	TWO = "$два,$2",
	VENDOR = "$вендор",
	YELLOW = "$желтый,$жел", -- Needs review
	ZERO = "$пустой,$чистый,$0", -- Needs review
}
AAHLocale.Messages = {
	ADDON_MANAGER_DESCRIPTION = [=[Advanced AuctionHouse изменяет стандартное окно аукционного дома. Он добавляет несколько новых полезных функций, чтобы сделать просмотр и аукционную торговлю проще и удобнее.

Все функциональные возможности непосредственно встроены в окно аукциона, так что Вы не должны делать ничего, лишь открыть аукционный дом, и Вы можете использовать новые функции немедленно.]=],
	AUCTION_EXCHANGE_RATE = "Обменный курс",
	AUCTION_FORUMS_BUTTON = "Форумы",
	AUCTION_FORUMS_BUTTON_TOOLTIP_HEADER = "Веб-ссылка на форумы Advanced AuctionHouse",
	AUCTION_FORUMS_BUTTON_TOOLTIP_TEXT = "Это откроет ваш браузер по умолчанию на форумы Advanced AuctionHouse",
	AUCTION_FRAME_TITLE = "Advanced AuctionHouse <VERSION> от Mavoc (RU) - Переведено SilverWF, user313, adamich", -- Needs review
	AUCTION_LOADED_MESSAGE = "Аддон загружен: Advanced AuctionHouse <VERSION> от Mavoc (RU) - Переведено SilverWF, user313, adamich", -- Needs review
	BROWSE_CANCELLING = "Отмена предыдущего поиска",
	BROWSE_CLEAR_BUTTON = "Очистить",
	BROWSE_CLEAR_BUTTON_TOOLTIP_HEADER = "Очистить поиск и фильтры",
	BROWSE_CLEAR_BUTTON_TOOLTIP_TEXT = "Нажмите эту кнопку для сброса всех параметров поиска и фильтрации, примененных к Вашему поиску. Это не сбросит результаты самого поиска.",
	BROWSE_CREATE_FOLDER_POPUP = "Создать папку с именем",
	BROWSE_FILTER = "Фильтры",
	BROWSE_FILTER_OR_TOOLTIP_HEADER = "Свяжите ключевые слова логическим ИЛИ",
	BROWSE_FILTER_OR_TOOLTIP_TEXT = [=[Отметьте, чтобы связать ключевые слова логическим ИЛИ вместо И.
(Фильтр№1 и/или Фильтр№2) и/или Фильтр№3]=],
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_HEADER = "Фильтрация по цене ставок",
	BROWSE_FILTER_PRICERANGE_BID_TOOLTIP_TEXT = "Отметьте здесь для фильтрации предметов, основанной на цене ставок, вместо цены выкупа.",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_HEADER = "Фильтрация по максимальной цене",
	BROWSE_FILTER_PRICERANGE_MAX_TOOLTIP_TEXT = "Введите максимальную цену для фильтрации предметов.",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_HEADER = "Фильтрация по минимальной цене",
	BROWSE_FILTER_PRICERANGE_MIN_TOOLTIP_TEXT = "Введите минимальную цену для фильтрации предметов.",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_HEADER = "Фильтрация по цене за единицу",
	BROWSE_FILTER_PRICERANGE_PPU_TOOLTIP_TEXT = "Отметьте здесь для фильтрации предметов, основанной на цене за единицу, вместо общей цены.",
	BROWSE_FILTER_TOOLTIP_HEADER = "Фильтр по ключевому слову №",
	BROWSE_FILTER_TOOLTIP_TEXT1 = [=[Введите ключевое слово здесь, чтобы фильтровать результаты поиска. Чтобы инвертировать фильтр, наберите ! перед ключевым словом. Использование ключевых слов в нескольких полях ввода будет связывать их логическим И по умолчанию.

Следующие специальные фильтры могут быть использованы:]=], -- Needs review
	BROWSE_FILTER_TOOLTIP_TEXT2 = [=[|cffffd200$зеленый|r или |cffffd200$green|r - предметы с зелеными статами
|cffffd200$желтый|r или |cffffd200$yellow|r - предметы с желтыми статами
|cffffd200$оранжевый|r или |cffffd200$orange|r - предметы с оранжевыми статами
|cffffd200$чистая|r или |cffffd200$zero|r - предметы без статов
|cffffd200$один|r или |cffffd200$one|r - предметы с одним статом
|cffffd200$два|r или |cffffd200$two|r - предметы с двумя статами
|cffffd200$три|r или |cffffd200$three|r - предметы с тремя статами
|cffffd200$четыре|r или|cffffd200$four|r - предметы с четырьмя статами
|cffffd200$пять|r или |cffffd200$five|r - предметы с пятью статами
|cffffd200$шесть|r или |cffffd200$six|r - предметы с шестью статами]=],
	BROWSE_FILTER_TOOLTIP_TEXT3 = [=[|cffffd200$прочн|r или |cffffd200$dura|r - предметы с прочностью >= 101
--($dura110 устанавливает минимальную прочность в 110)
|cffffd200$тир|r или |cffffd200$tier|r - предметы с тиром >= 1
--($tier3 устанавливает минимальный тир в 3)
|cffffd200$яйцоуров|r или |cffffd200$egglvl|r - яйца питомцев с уровнем >= 1
--($egglvl30 устанавливает минимальный уровень в 30)
|cffffd200$яйцоскл|r - яйца питомцев со склонностью >= 1
--($eggapt80 устанавливает минимальную склонность в 80)
|cffffd200$вендор|r или |cffffd200$vendor|r - продажа вендору для получения прибыли
--(смотрите curse.com для использования)
|cffffd200$скидка|r или |cffffd200$bargain|r - перепродайте на аукционе для получения прибыли
--(смотрите curse.com для использования)]=],
	BROWSE_HEADER_CUSTOM_TITLE = "Выберите тип данных аукциона:", -- Needs review
	BROWSE_INFO_LABEL = "Найдено: <MAXITEMS> - Загружено: <SCANPERCENT>% - Совпадений: <FILTEREDITEMS> - Отфильтровано: <FILTERPERCENT>%",
	BROWSE_INFO_LABEL_TOOLTIP_HEADER = "Ход кэширования и фильтрации",
	BROWSE_INFO_LABEL_TOOLTIP_TEXT = [=[Отображает следующую информацию:

- все результаты поиска (максимум 500)
- ход самого поиска
- количество предметов, соответствующих Вашим ключевым словам
- ход процесса фильтрации]=],
	BROWSE_MAX = "Макс.",
	BROWSE_MIN = "Мин.",
	BROWSE_NAME_SEARCH_POPUP = "Назвать Ваш сохраненный поиск",
	BROWSE_NO_RESULTS = "По Вашему поиску ничего не было найдено",
	BROWSE_OR = "или",
	BROWSE_PPU = "За 1",
	BROWSE_RENAME = "Переименовать",
	BROWSE_RENAME_SAVED_SEARCH_POPUP = "Переименовать Ваш сохраненный поиск",
	BROWSE_SAVED_SEARCH_TITLE = "Сохраненные поиски",
	BROWSE_SEARCHING = "Идет поиск ... пожалуйста, подождите.",
	BROWSE_SEARCH_PARAMETERS = "Параметры поиска",
	BROWSE_USABLE = "Пригодные",
	COMMAND_BARGAIN_DESCRIPTION = "Перепродать на аукционе для получения дохода", -- Needs review
	COMMAND_DURA_DESCRIPTION = "предметы с прочностью >= 101; добавьте '/123' для прочности >= 123", -- Needs review
	COMMAND_EGGAPTITUDE_DESCRIPTION = "яйца питомцев с способностями >= 1; добавьте '/80' для мин. способностей 80", -- Needs review
	COMMAND_EGGLEVEL_DESCRIPTION = "яйца питомцев с уровнем >= 1; добавьте '/30' для мин. уровня 30", -- Needs review
	COMMAND_FIVE_DESCRIPTION = "предметы с пятью статами", -- Needs review
	COMMAND_FOUR_DESCRIPTION = "предметы с четырьмя статами", -- Needs review
	COMMAND_GREEN_DESCRIPTION = "предметы с зелеными статами", -- Needs review
	COMMAND_ONE_DESCRIPTION = "предметы с одним статом", -- Needs review
	COMMAND_ORANGE_DESCRIPTION = "предметы с оранжевыми статами", -- Needs review
	COMMAND_PLUS_DESCRIPTION = "предметы с плюсом >= 1; добавьте '/6' для установки минимального плюса в 6", -- Needs review
	COMMAND_SIX_DESCRIPTION = "предметы с шестью статами", -- Needs review
	COMMAND_THREE_DESCRIPTION = "предметы с тремя статами", -- Needs review
	COMMAND_TIER_DESCRIPTION = "предметы с тиром >= 1; добавьте '/6' для установки минимального тира в 6", -- Needs review
	COMMAND_TWO_DESCRIPTION = "предметы с двумя статами", -- Needs review
	COMMAND_VENDOR_DESCRIPTION = "продайте торговцу для получения прибыли", -- Needs review
	COMMAND_YELLOW_DESCRIPTION = "предметы с желтыми статами", -- Needs review
	COMMAND_ZERO_DESCRIPTION = "предметы без статов", -- Needs review
	GENERAL_ATTRIBUTES = "Атрибуты", -- Needs review
	GENERAL_AVERAGE = "Средняя",
	GENERAL_AVERAGE_PRICE_PER_UNIT = "Средняя цена за единицу:",
	GENERAL_CUSTOM_HEADER_TOOLTIP_HEADER = "Свои колонки", -- Needs review
	GENERAL_CUSTOM_HEADER_TOOLTIP_TEXT = [=[Левый клик: сортировка колонок
Правый клик: изменить колонку]=], -- Needs review
	GENERAL_DECIMAL_POINT = ",",
	GENERAL_DEX_HEADER = "Лов.", -- Needs review
	GENERAL_DPS_HEADER = "Урон/сек", -- Needs review
	GENERAL_DURA_HEADER = "Прочн.", -- Needs review
	GENERAL_GENERAL = "Основной",
	GENERAL_HEAL_HEADER = "Лечение", -- Needs review
	GENERAL_HP_HEADER = "ХП",
	GENERAL_INTEL_HEADER = "Инт.", -- Needs review
	GENERAL_MACC_HEADER = "Маг. точн.", -- Needs review
	GENERAL_MATT_HEADER = "Маг. атака", -- Needs review
	GENERAL_MCRIT_HEADER = "Маг. крит", -- Needs review
	GENERAL_MDAM_HEADER = "Маг. урон", -- Needs review
	GENERAL_MDEF_HEADER = "Маг. защ.", -- Needs review
	GENERAL_MEDIAN_PRICE_PER_UNIT = "Среднестатистическая цена за единицу:",
	GENERAL_MP_HEADER = "МП",
	GENERAL_OTHER = "Другой", -- Needs review
	GENERAL_PACC_HEADER = "Физ. точн.", -- Needs review
	GENERAL_PARRY_HEADER = "Парирование", -- Needs review
	GENERAL_PATT_HEADER = "Физ. атака", -- Needs review
	GENERAL_PCRIT_HEADER = "Физ. крит", -- Needs review
	GENERAL_PDAM_HEADER = "Физ. урон", -- Needs review
	GENERAL_PDEF_HEADER = "Физ. защ.", -- Needs review
	GENERAL_PDOD_HEADER = "Уклонение", -- Needs review
	GENERAL_PLUS_HEADER = "Плюс",
	GENERAL_PRICE_PER_UNIT_HEADER = "Цена за единицу",
	GENERAL_SPEED_HEADER = "Ск. атаки",
	GENERAL_STAM_HEADER = "Вын.", -- Needs review
	GENERAL_STATS = "Параметры", -- Needs review
	GENERAL_STR_HEADER = "Сила",
	GENERAL_TIER_HEADER = "Тир",
	GENERAL_UNITS_PER_PRICE_HEADER = "Единицы/Цена", -- Needs review
	GENERAL_WIS_HEADER = "Мудр.", -- Needs review
	GENERAL_WORTH_HEADER = "Цена", -- Needs review
	HISTORY_NO_DATA = "Этот предмет не имеет ценовой истории!",
	HISTORY_SUMMARY_AVERAGE = [=[Среднестатистическая цена: <MEDIAN>
Среднеарифметическая цена: <AVERAGE>]=],
	HISTORY_SUMMARY_MINMAX = [=[Минимальная цена: <MINIMUM>
Максимальная цена: <MAXIMUM>]=],
	HISTORY_SUMMARY_NUMHISTORY = "(аукционов: <NUMHISTORY>)",
	LUNA_NEW_VERSION_FOUND = "Доступна новая версия Advanced AuctionHouse от rom.curse.com",
	LUNA_NOT_FOUND = "Для работы этой возможности необходим аддон Luna. Он может быть найден на rom.curse.com.",
	SELL_AUTO_BID_PRICE_TOOLTIP_HEADER = "Режим автозаполнения цены лота",
	SELL_AUTO_BID_PRICE_TOOLTIP_TEXT = [=[Здесь может быть выбран режим для автозаполнения стоимости лота. Режимы:

|cffffd200Нет|r - цена не будет введена

та же цена, по которой |cffffd200последний|r раз этот предмет был продан с аукциона (если имеется)

|cffffd200средняя|r цена, по которой продается этот предмет

определить особую |cffffd200формулу|r автозаполнения]=],
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_HEADER = "Режим автозаполнения цены выкупа",
	SELL_AUTO_BUYOUT_PRICE_TOOLTIP_TEXT = [=[Здесь может быть выбран режим для автозаполнения стоимости выкупа. Режимы:

|cffffd200Нет|r - цена не будет введена

та же цена, по которой |cffffd200последний|r раз этот предмет был продан с аукциона (если имеется)

|cffffd200средняя|r цена, по которой продается этот предмет

определить особую |cffffd200формулу|r автозаполнения]=],
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_HEADER = "Особая формула цены",
	SELL_AUTO_PRICE_FORMULA_TOOLTIP_TEXT = [=[Определяет особую формулу, которая будет использоваться для расчета автоматически заполняемой цены. Следующие заполнители могут быть использованы

AVG - Среднеарифметическая цена
MEDIAN - Среднестатистическая цена
MIN - Минимальная цена
MAX - Максимальная цена

Пример: AVG - ((AVG - MIN) / 3)]=],
	SELL_AUTO_PRICE_HEADER = "Настройки автоматической цены",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_HEADER = "Процент среднего",
	SELL_AUTO_PRICE_PERCENT_TOOLTIP_TEXT = "Автоматическая цена предмета, основанная на истории % от среднего",
	SELL_FORMULA = "Формула",
	SELL_LAST = "Последняя",
	SELL_NONE = "Нет",
	SELL_NUM_AUCTION = "Количество аукционов:",
	SELL_PERCENT = "% от среднего",
	SELL_PER_UNIT = "за единицу",
	SETTINGS_AVG_DEFAULT_LAST_PRICE = "Без последней цены предлагать среднюю", -- Needs review
	SETTINGS_AVG_DEFAULT_LAST_PRICE_HEADER = "Без последней цены предлагать среднюю", -- Needs review
	SETTINGS_AVG_DEFAULT_LAST_PRICE_TEXT = [=[Активно: Вводит среднюю цену при продаже предмета без последней цены продажи.
Неактивно: Поле цены продажи должно быть оставлено пустым.]=], -- Needs review
	SETTINGS_BROWSE = "Настройки просмотра", -- Needs review
	SETTINGS_CLEAR_ALL_SUCCESS = "Успешно очищены все данные ценовой истории.",
	SETTINGS_CLEAR_SUCCESS = "Успешно очищена ценовая история для: |cffffffff",
	SETTINGS_FILTER_SPEED = "Скорость фильтра",
	SETTINGS_FILTER_SPEED_HEADER = "Скорость фильтра",
	SETTINGS_FILTER_SPEED_TEXT = [=[Устанавливает количество вещей, отбираемых за обновление. Чем выше настройка, тем быстрее скорость, но тем выше задержка, вызванная отбором.
Поддерживается прокрутка колесиком мыши]=], -- Needs review
	SETTINGS_GENERAL = "Основные настройки",
	SETTINGS_HISTORY = "Настройки истории",
	SETTINGS_MAX_SAVED_HISTORY = "Максимум сохраненной истории (дефолт)", -- Needs review
	SETTINGS_MAX_SAVED_HISTORY_HEADER = "Максимум сохраненной истории (дефолт)", -- Needs review
	SETTINGS_MAX_SAVED_HISTORY_TEXT = [=[Установите максимальное количество сохраненной истории на каждую вещь.
Поддерживается прокрутка колесиком мыши]=], -- Needs review
	SETTINGS_MAX_SAVED_HISTORY_RESET_BUTTON = "Установить все по умолчанию",
	SETTINGS_MAX_SAVED_HISTORY_RESET_HEADER = "Установить все по умолчанию",
	SETTINGS_MAX_SAVED_HISTORY_RESET_TEXT = "Нажмите эту кнопку, чтобы установить по умолчанию максимальное количество сохраненных записей истории для всех элементов.",
	SETTINGS_MIN_WARNING_PRICE = "Минимальная цена для подтверждения ставки", -- Needs review
	SETTINGS_MIN_WARNING_PRICE_HEADER = "Минимальная цена для подтверждения ставки", -- Needs review
	SETTINGS_MIN_WARNING_PRICE_TEXT = "Устанавливает минимальную сумму денег, которая отображается в диалоге подтверждения ставки.", -- Needs review
	SETTINGS_MISSING_PARAMETER = "Отсутствует параметр для очистки данных истории.",
	SETTINGS_PRICE_HISTORY_TOOLTIP = "Всегда показывать историю цен",
	SETTINGS_PRICE_HISTORY_TOOLTIP_HEADER = "Показывать историю цен",
	SETTINGS_PRICE_HISTORY_TOOLTIP_TEXT = [=[Отмечено: Показывать подсказки. Нажмите ALT для скрытия
Не отмечено: Показывать подсказки только по нажатию ALT]=], -- Needs review
	SETTINGS_PRICE_PER_UNIT_PER_WHITE = "Цена базовой единицы для материалов", -- Needs review
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_HEADER = "Цена базовой единицы", -- Needs review
	SETTINGS_PRICE_PER_UNIT_PER_WHITE_TEXT = [=[Включение вызовет отображение для материалов цены за единицу базового материала. Это позволит легче сравнивать цены материалов на разных уровнях обработки. Применяется ко всем полям, отображающим цену за единицу, включая цены продажи.
Зеленый = 2x Белый материал
Синий = 12x Белый материал
Фиолетовый = 72x Белый материал
Пример
100x |cff0072bc[Цинковый слиток]|r по 120 000 за стек
Цена за единицу = 1,200
Цена за базовую единицу = 100]=], -- Needs review
	TOOLS_DAY_ABV = "д",
	TOOLS_GOLD_BASED = "(Основано на <SCANNED> просмотренных аукционах, проданных за золото)",
	TOOLS_HOUR_ABV = "ч",
	TOOLS_ITEM_NOT_FOUND = "Не найдены данные истории для: |cffffffff",
	TOOLS_MIN_ABV = "м",
	TOOLS_NO_HISTORY_DATA = "Нет доступных данных.",
	TOOLS_POWERED_BY = "(используется Advanced AuctionHouse)",
	TOOLS_PRICE_HISTORY = "Ценовая история",
	TOOLS_UNKNOWN_COMMAND = [=[Неизвестная команда. Команды:
|cffffffff/aah numhistory <максимум записей истории, сохраняемых на предмет>|r
|cffffffff/aah clear <предмет>|r
|cffffffff/aah clearall|r
|cffffffff/aah pricehistory|r]=],
}
