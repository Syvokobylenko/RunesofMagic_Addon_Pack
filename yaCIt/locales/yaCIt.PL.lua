yaCIt.Locales = {
	description = "Ulepszony Bestiariusz. Możliwość, szybkiego zobaczenia, jakie mamy karty, filtry, opisy, wygląd potworów, bez posiadania kart, licznik statystyk.",
	cardnumbers = "Ogólnie w grze jest %s kart, Ty ich masz %s (%s)",
	shorthelp = "Wpisz /ci lub /yacit [help] , aby uzyskać więcej informacji, lub [cfg], aby otworzyć konfigurację.",
	cmdfound = "%d kart znalezionych i wyświetlonych",

	cmdhelp = {
		[1] = "/ci [help] / [cfg] / [<dowolne>]",
		[2] = "<nic>: Wyświetla aktualny status",
		[3] = "<cfg>: Wyświetla okienko konfiguracji",
		[4] = "<dowolne>: Wyszukaj karty i zlinkuj je na chacie"
	},

	card = "kartę", -- as in mid sentence e.g. lower for english, upper for german
	nocard = "karty", -- as in mid sentence e.g. lower for english, upper for german
	donthave = "Nie masz tej %s.",
	have = "Masz tę %s.",
	notfound = "Nie znaleziono karty",
	ambience = "Brak karty",

	dracomob = "Karta za wymianę drakonari u bram Varanas.",
	reward = "Tę kartę można zdobyć za wykonanie misji.",
	questmob = "Potwór dostępny tylko przy wykonywaniu misji.",
	notobtain = "Ta karta nie jest możliwa do zdobycia.",
	eventmob = "Rozdawana podczas eventu, nie do wydropienia.",
	raremob = "Pojawia się losowo po innym potworze.",
	randommob = "Pojawia się tylko podczas wydarzeń strefowych.",
	
	location = "Lokalizacja: ", -- mind the : and space at the end
	category = "Kategoria: ", -- mind the : and space at the end
	stat = "Bonus statowy: ", -- mind the : and space at the end
	resist = "Runy produkcyjne: ", -- mind the : and space at the end
	unknown = "?????",
	update = "Uaktualniono dane dla: %s",
	
	AAHfilterhelp = "karty, których nie masz",

	book = {
		titlestats = "- łącznie %d/%d kart (%s)", -- mind the leading - and space
		filterboxlabel = "Filtr:", -- mind the : at the end
		filtercountlabel = "Karty z podanymi filtrami: ", -- mind the : and space at the end
		chkinvertlabel = "Odwrotność filtrów",
		chkshowdetailslabel = "Pokaż dodatkowe informacje",
		category = {
			title = "Wybierz kategorie",
			allcards = "Wszystkie kategorie"
		},
		zone = {
			title = "Wybierz strefę",
			allcards = "Wszystkie strefy",
			unknown = "Nieznana strefa",
			current = "Aktualna strefa"
		},
		bonus = {
			title = "Wybierz bonusy",
			allcards = "Wszystkie bonusy",
			unknown = "Bez bonusów"
		},
		misc = {
			title = "Wybierz filtry",
			allcards = "Wszystkie karty",
			owned = "Karty posiadane przez...",
			dracomob = "Karty Drako",
			raremob = "Losowy rzadki potwór",
			randommob = "Karty potworów z wydarzeń strefowych",
			reward = "Nagroda za wykonanie misji",
			questmob = "Potwór dostępny tylko przy misji",
			notobtain = "Niemożliwe do zdobycia",
			eventmob = "Nagroda podczas eventu",
			AAHhistory = "Karty, które były sprzedane w Domu Aukcyjnym"
		},
		sort = {
			title = "Wybierz kolejność sortowania",
			nosort = "Sortuj alfabetycznie",
			zone = "Sortuj według strefy",
			stat = "Sortuj według bonusów",
			owned = "Sortuj według uzyskania",
			AAHavg = "Sortuj według wartości",
			sectavglimit = "Wartość >= ", -- mind the >= and space at the end
			sectnohist = "bez historii Domu Aukcyjnego"
		},
		context = {
			title = "Wybierz akcję",
			linkcard = "Zlinkuj kartę na chacie",
			showmap = "Pokaż mapę -> " -- mind the -> and space at the end
		},
		statoverlay = {
			title = "Twoje bonusy z kart"
		},
		cardoverlay = {
			title = "Dodatkowe informacje:", -- mind the : at the end
			altnamelabel = "Alternatywna nazwa:", -- mind the : at the end
			rarelabel = "Ranga:", -- mind the : at the end
			resistlabel = "Runy:", -- mind the : at the end
			cardid = "ID Karty:",
			aahlabel = "Historia Domu Aukcyjnego:", -- mind the : at the end
			owners = "Inni posiadacze:" -- mind the : at the end
		},
		resistoverlay = {
			empty = "Brak",
			linkRune = "Wiążące (Stolarstwo)",
			frostRune = "Mrozu (Kowalstwo)",
			activateRune = "Aktywacyjne (Gotowanie)",
			disenchantRune = "Odczarowania (Krawiectwo)",
			purifyRune = "Oczyszczenia (Płatnerstwo)",
			blendRune = "Łączące (Alchemia)"
		}
		
	},
	config = {
		title = " Konfiguracja i narzędzia", -- mind the leading " "
		zone = "Aktualna strefa: ", -- mind the : and space at the end
		version = "Autor: Corgrind \nAktualizacja 3.2 by Zeno (12/2019)",
		global = {
			header = "Globalne",
			itemTT = "Ulepszone okienka przedmiotów",
			mobTT = "Ulepszone okienka potworów",
			helpTT = "Ukryj okienka informacyjne"
		},
		char = {
			header = "Dla postaci",
			dontsave = "Nie zapisuj dla tej postaci",
			nosums = "Nie dodawaj do stanu licznika"
		},
		tools = {
			header = "Narzędzia",
			savezones = "Zapisz",
			savezonestext = "listę stref do SaveVariables",
			savelist = "Zapisz",
			savelisttext = "listę kart do SaveVariables",
			npczones = "Odnów",
			npczonestext = "powiązania kart do stref",
			removechardesc = "Użyj tego do usunięcia nieaktualnych danych z usuniętych postaci.",
			removechar = "Usuń",
			selectchar = "[wybierz postać]",
			done = " ukończono", -- mind the leading space
		},
	},
	tthelp = {
		DD_Zone = {
			"Wybierz strefę",
			"Zostaną pokazane karty tylko z danej strefy."},
		DD_Sort = {
			"Wybierz kolejność sortowania",
			"Wybierz według jakich danych mają być posortowane karty. \nZawsze rosnąco."},
		FilterBox = {
			"Wpisz filtr",
			"Tylko karty zawierające daną frazę zostaną pokazane. \nMożesz również wpisać 'ID'."},
		ResetFilters = {
			"Zresetuj",
			"Usuń wszystkie ustawione opcje sortowania i filtry."},
		Chk_Invert = {
			"Odwrócone filtry",
			"Wyświetl karty, których dane są odwrotne ( np. posiadane karty )"},
		ToggleSummaryButton = {
			"Pokaż / ukryj zsumowane bonusy",
			"Pokaż listę posiadanych / ogólnych bonusów statystyk"},
		Config = {
			"Pokaż / ukryj okienko konfiguracji",
			"Wyświetl opcje konfiguracji oraz narzędzia."},
		Chk_ShowDetails = {
			"Pokaż dodatkowe informacje",
			"Pokaż mniej istotne informacje dotyczące karty."},
		Global_ItemTT = {
			"Ulepszone okienka przedmiotów",
			"Rozbudowywuje okienka dotyczące np. kart. Sprawia, że filtr AAH $notowned zostaje naruszony."},
		Global_MobTT = {
			"Ulepszone okienka potworów",
			"Rozbudowywuje okienka potworów o informacje o kartach."},
		Global_HelpTT = {
			"Ukryj okienka informacyjne",
			"Ukrywa okienka informacyjne takie jak to."},
		Char_DontSave = {
			"Nie zapisuj",
			"Informacje o posiadanych kartach tej postaci nie zostaną zapisane w SaveVariables"},
		Char_NoSums = {
			"Nie pokazuj licznika",
			"Informacje licznika (liczba/znaki) nie będą dodawane do statusu tej postaci."},
		Tools_SaveZones = {
			"Zapisuj listę stref",
			"Lista stref będzie zapisywana do SaveVariables.lua jako \"yaCIt_ZoneList\"."},
		Tools_SaveList = {
			"Zapisuj listę kart",
			"Lista kart będzie zapisywana do SaveVariables.lua jako \"yaCIt_CardList\". Informacje o statusie nie są wliczane; je można znaleźć pod \"yaCIt_Persistent\" i pod powiązaną postacią."},
		Tools_RenewNPCzones = {
			"Odnów powiązania kart do stref",
			"Używa Wyszukiwania w Świecie, aby przypisać karty do stref. Może to trwać ponad 30 sekund!\nJest to zwykle wykonywane przy zmianie liczby kart."},
		Tools_RemoveChar = {
			"Usuń dane postaci",
			"Usuwa dane wybranej postaci z SaveVariables.lua\nLiczniki zostaną zaktualizowane przy kolejnym ładowaniu!"},
	},
	debug = {
		savedfilterlist = "Filtry są zapisywane w SaveVariables.lua",
	}
}

