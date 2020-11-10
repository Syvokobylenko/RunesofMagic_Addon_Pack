yaCIt.Locales = {
	description = "Diese Addon erweitert Monsterkarten-Tooltips um Kategorie, Zonen, Beschreibung und ob man diese Karte besitzt. Es erweitert au\195\159erdem das Kompendium mit verbesserten Filtern und Sortierung.",
	cardnumbers = "Es sind insgesamt %s Karten, davon hast Du %s (%s).",
	shorthelp = "Verwende /ci oder /yacit [help] f\195\188r Informationen, [cfg] f\195\188r die Konfiguration.",
	cmdfound = "%d Karten gefunden und aufgelistet",

	cmdhelp = {
		[1] = "/ci [help] [cfg] [<belieb. Text>]",
		[2] = "ohne Parameter: Zeigt den aktuellen Status an",
		[3] = "cfg: Ruft den Konfigurations-Dialog auf",
		[4] = "<Bel. Text>: Kartensuche"
	},

	card = "Karte", -- as in mid sentence e.g. lower for english, upper for german
	nocard = "Karte", -- as above, added for polish due syntax issues
	donthave = "Diese %s hast Du noch nicht.",
	have = "Diese %s hast Du bereits.",
	notfound = "Karte nicht gefunden",
	ambience = "Ambiente-Mob (keine Karte)",

	dracomob = "Erhalten vor den Toren von Varanas.",
	reward = "Diese Karte ist eine Questbelohnung.",
	questmob = "Monster erscheint nur bei aktiver Quest.",
	notobtain = "Karte kann nicht erworben werde.",
	eventmob = "Nicht erwerbbar. Prize for the forum/ingame event.",
	raremob = "Erscheint zuf\195\164llig nach einem Monster.",
	randommob = "Erscheint nur bei aktiven des Zonenereignisses.",

	location = "Zone(n): ", -- mind the : and space at the end
	category = "Kategorie: ", -- mind the : and space at the end
	stat = "Stat-Bonus: ", -- mind the : and space at the end
	resist = "Runen: ", -- mind the : and space at the end
	unknown = "unbekannt",
	update = "Aktualisierung der Zonendaten f\195\188r %s",

	AAHfilterhelp = "im Kompendium fehlende Karten",

	book = {
		titlestats = "- insgesamt %d/%d Karten (%s)", -- mind the leading - and space
		filterboxlabel = "Textfilter eingeben:", -- mind the : at the end
		filtercountlabel = "Ausgew\195\164hlt: ", -- mind the : and space at the end
		chkinvertlabel = "Filter umkehren",
		chkshowdetailslabel = "Weitere Informationen anzeigen",
		category = {
			title = "W\195\164hle Kategorie",
			allcards = "Alle Kategorien"
		},
		zone = {
			title = "W\195\164hle Zone",
			allcards = "Alle Zonen",
			unknown = "Zone unbekannt",
			current = "Aktuelle Zone"
		},
		bonus = {
			title = "W\195\164hle Stat-Bonus",
			allcards = "Alle Stat-Boni",
			unknown = "Kein Stat-Bonus"
		},
		misc = {
			title = "W\195\164hle sonst. Filter",
			allcards = "Alle Karten",
			owned = "Vorhandene Karten bei ...",
			dracomob = "Draco Karten",
			raremob = "Monster Spawn zuf\195\164llig",
			randommob = "Eventabh\195\164ngige Monster",
			reward = "Questbelohnungen",
			questmob = "Questabh\195\164ngiger Monster",
			notobtain = "Nicht erwerbbar",
			eventmob = "Event Karten",
			AAHhistory = "AAH-Historie vorhanden"
		},
		sort = {
			title = "W\195\164hle Sortierung",
			nosort = "Alphabetisch",
			zone = "Nach Zone",
			stat = "Nach Stat-Bonus",
			owned = "Vorhandene zuerst",
			AAHavg = "Nach durchschn. Preis",
			sectavglimit = "Durchs. Preis >= ", -- mind the >= and space at the end
			sectnohist = "ohne AAH-Historie"
		},
		context = {
			title = "W\195\164hle Aktion",
			linkcard = "Karte in Chat einf\195\188gen",
			showmap = "Zonenkarte anzeigen -> " -- mind the -> and space at the end
		},
		statoverlay = {
			title = "Attributbonus (Summen)"
		},
		cardoverlay = {
			title = "Verdeckte Kartendetails",
			altnamelabel = "Zus. Namen:", -- mind the : at the end
			rarelabel = "Seltenheit:", -- mind the : at the end
			resistlabel = "Runen:", -- mind the : at the end
			cardid = "Karten ID:",
			aahlabel = "AAH-Historie:", -- mind the : at the end
			owners = "Andere Besitzer:" -- mind the : at the end
		},
		resistoverlay = {
			empty = "Keine",
			linkRune = "Verbinden (Schreinern) ",
			frostRune = "K�lte (Schmieden) ",
			activateRune = "Aktivierungs (Kochen)",
			disenchantRune = "Entzauberungs (Schneidern)",
			purifyRune = "Reinigungs (R�stschmied)",
			blendRune = "Mischen (Alchemie)"
		}
	},
	config = {
		title = " Konfiguration & Werkzeuge", -- mind the leading " "
		zone = "Aktuelle Zone: ", -- mind the : and space at the end
		version = "Autor: Corgrind \nAktualisierung 3.2 von Zeno (12/2019)",
		global = {
			header = "Global",
			itemTT = "Kartenhinweise anzeigen",
			mobTT = "Monsterhinweise erweitern",
			helpTT = "Hilfehinweise verstecken"
		},
		char = {
			header = "Charakter",
			dontsave = "Diesen Charakter nicht speichern",
			nosums = "Z\195\164hler nicht an Status anh\195\164ngen"
		},
		tools = {
			header = "Werkzeuge",
			savezones = "Speichere",
			savezonestext = "Zonenliste in SaveVariables",
			savelist = "Speichere",
			savelisttext = "Kartenliste in SaveVariables",
			npczones = "Erneuere",
			npczonestext = "Karte/Zone-Verkn\195\188pfungen",
			removechardesc = "Verwende diese Funktion, um \195\188berfl\195\188ssige, evtl. gel\195\182schte Charaktere zu entfernen",
			removechar = "Entferne",
			selectchar = "[Ausw\195\164hlen]",
			done = " OK.", -- mind the leading space
		},
	},
	tthelp = {
		DD_Zone = {
			"Zone ausw�hlen",
			"Es k�nnen nur Zonen mit zugeordneten Karten ausgew�hlt werden."},
		DD_Sort = {
			"Sortierung ausw�hlen",
			"Nach dem Sortieren und Gruppieren werden die Gruppen alphabetisch sortiert. \nEs wird immer aufsteigend sortiert."},
		FilterBox = {
			"Textfilter eingeben",
			"Es werden nur Karten angezeigt, deren Name das angegebene Textteil enth�lt.\nEine g�ltige 5/6-stellige Hex-/Dezimalzahl zeigt die Karte mit dieser Nummer an."},
		ResetFilters = {
			"Filter zur�cksetzen",
			"L�scht alle Filter- und Sortierungsoptionen"},
		Chk_Invert = {
			"Filter umkehren",
			"Negiert den Filter der Auswahlbox links, d.h. w�hlt Karten aus, die das Kriterium NICHT erf�llen."},
		ToggleSummaryButton = {
			"Bonuszusammenfassung anzeigen",
			"Zeigt eine Zusammenfassung der \ngesammelten / verf�gbaren Boni an."},
		Config = {
			"Konfigurationsdialog anzeigen",
			"Zeigt Konfiguration und Werkzeuge an."},
		Chk_ShowDetails = {
			"Verdeckte Informationen",
			"Zeigt zus�tzliche Informationen zur Karte im Popup an."},
		Global_ItemTT = {
			"Kartenhinweise anzeigen",
			"Wenn ausgew�hlt, werden die neuen Kartenhinweise im Rucksack, in der Bank usw. angezeigt. \nAuch der AAH-Filter $notowned ist von dieser Einstellung abh�ngig."},
		Global_MobTT = {
			"Monsterhinweise erweitern",
			"Wenn ausgew�hlt, werden die Monsterhin- weise mit Stat-Bonus und Status erweitert."},
		Global_HelpTT = {
			"Hilfehinweise verstecken",
			"Wenn ausgew�hlt, werden Hilfehinweise wie dieser hier nicht angezeigt."},
		Char_DontSave = {
			"Charakter nicht speichern",
			"Die Liste der vorhandenen Karten wird f�r diesen Charakter nicht in SaveVariables.lua abgespeichert. Andere Charaktere k�nnen sich nicht auf diese Information beziehen."},
		Char_NoSums = {
			"Z�hler nicht anzeigen",
			"Der Z�hler (Num/Chars) wird f�r diesen Charakter nicht dem Status angeh�ngt."},
		Tools_SaveZones = {
			"Zonenliste speichern",
			"Die Zonenliste wird unter \"yaCIt_ZoneList\" in SaveVariables.lua gespeichert."},
		Tools_SaveList = {
			"Kartenliste speichern",
			"Die vollst�ndige Kartenliste wird unter \"yaCIt_CardList\" in Savevariables.lua gespeichert. Der Besitzstatus ist nicht enthalten; dieser findet sich unter \"yaCIt_Persistent\"."},
		Tools_RenewNPCzones = {
			"Karte/Zone-Beziehungen aktualisieren",
			"Benutzt die Weltsuche, um Karten mit Zonen zu verbinden. Das kann mehr als 30 Sekunden dauern!\nDiese Funktion wird normalerweise beim Start automatisch ausgef�hrt, wenn sich die Anzahl der Karten ge�ndert hat."},
		Tools_RemoveChar = {
			"Charakterinformatoinen entfernen",
			"Entfernt die Daten des ausgew�hlten Charakters aus SaveVariables.lua\nDie Z�hler werden beim n�chsten Betreten aktualisiert!"},
	},
	debug = {
		savedfilterlist = "Gefilterte Kartenliste in SaveVariables.lua gespeichert",
	}
}
