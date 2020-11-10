yaCIt.Locales = {
	description = "Extends monster card tooltip so it shows the monster category, description, location, and whether you already have the card or not. It also replaces the compendium with a version supplying filter and sort options.",
	cardnumbers = "There are %s cards in total, you have %s (%s)",
	shorthelp = "Use /ci or /yacit [help] for information, [cfg] for configuration.",
	cmdfound = "%d cards found and linked",

	cmdhelp = {
		[1] = "/ci [help] [cfg] [<any string>]",
		[2] = "no param: Displays the current status",
		[3] = "cfg: show configuration dialog",
		[4] = "<any string>: Search cards and link them to chat"
	},

	card = "card", -- as in mid sentence e.g. lower for english, upper for german
	nocard = "card", -- as above, added for polish due syntax issues
	donthave = "You don't have this %s.",
	have = "You have this %s.",
	notfound = "Card not found",
	ambience = "Mob for ambience (no card)",

	dracomob = "Obtained at the gates of Varanas.",
	reward = "This card is a quest reward.",
	questmob = "Mob only appears on active quest.",
	notobtain = "This card cannot be obtained.",
	eventmob = "Not obtainable. Award for a forum/ingame event.",
	raremob = "Appears randomly after monster.",
	randommob = "Appears only on active zone event.",
	
	location = "Location: ", -- mind the : and space at the end
	category = "Category: ", -- mind the : and space at the end
	stat = "Stat bonus: ", -- mind the : and space at the end
	resist = "Runes: ", -- mind the : and space at the end
	unknown = "unknown",
	update = "Updating zone data for %s",
	
	AAHfilterhelp = "cards which are not owned",

	book = {
		titlestats = "- total %d/%d cards (%s)", -- mind the leading - and space
		filterboxlabel = "Enter text filter:", -- mind the : at the end
		filtercountlabel = "Filtered cards: ", -- mind the : and space at the end
		chkinvertlabel = "Invert misc. filter",
		chkshowdetailslabel = "Show additional details",
		category = {
			title = "Select category",
			allcards = "All categories"
		},
		zone = {
			title = "Select zone",
			allcards = "All zones",
			unknown = "Unknown zone",
			current = "Current zone"
		},
		bonus = {
			title = "Select stat bonus",
			allcards = "All stat bonus",
			unknown = "No stat bonus"
		},
		misc = {
			title = "Select filter",
			allcards = "All cards",
			owned = "Cards owned by ...",
			dracomob = "Draco cards",
			raremob = "Monster spawn random",
			randommob = "Event related monster",
			reward = "Quest rewards",
			questmob = "Quest related mob",
			notobtain = "Not obtainable",
			eventmob = "Event cards",
			AAHhistory = "Card has AAH history"
		},
		sort = {
			title = "Select sort order",
			nosort = "Sort alphabetic",
			zone = "Sort by zone",
			stat = "Sort by stat bonus",
			owned = "Sort owned first",
			AAHavg = "Sort by avg. price",
			sectavglimit = "Avg. price >= ", -- mind the >= and space at the end
			sectnohist = "without AAH history"
		},
		context = {
			title = "Select action",
			linkcard = "Link card to chat",
			showmap = "show map -> ", -- mind the -> and space at the end
		},
		statoverlay = {
			title = "Summary - stat bonuses"
		},
		cardoverlay = {
			title = "Hidden card details",
			altnamelabel = "Alt. names:", -- mind the : at the end
			rarelabel = "Rarity level:", -- mind the : at the end
			resistlabel = "Runes:", -- mind the : at the end
			cardid = "Cards ID:",
			aahlabel = "AAH history:", -- mind the : at the end
			owners = "Other owners:" -- mind the : at the end
		},
		resistoverlay = {
			empty = "None",
			linkRune = "Link (Carpentry)",
			frostRune = "Frost (Blacksmithing)",
			activateRune = "Activate (Cooking)",
			disenchantRune = "Disenchant (Tailoring)",
			purifyRune = "Purify (Armorcrafting)",
			blendRune = "Blend (Alchemy)"
		}
	},
	config = {
		title = " Configuration & Tools", -- mind the leading " "
		zone = "Current zone: ", -- mind the : and space at the end
		version = "Author: Corgrind \nUpdate 3.2 by Zeno (12/2019)",
		global = {
			header = "Global",
			itemTT = "Show item tooltips",
			mobTT = "Expand mob tooltips",
			helpTT = "Hide help tooltips"
		},
		char = {
			header = "Character",
			dontsave = "Don't save this character",
			nosums = "Don't add counter to status"
		},
		tools = {
			header = "Tools",
			savezones = "Save",
			savezonestext = "zone list to SaveVariables",
			savelist = "Save",
			savelisttext = "full card list to SaveVariables",
			npczones = "Renew",
			npczonestext = "card/zone associations",
			removechardesc = "Use this to remove obsolete informations of old, possibly deleted characters",
			removechar = "Remove",
			selectchar = "[select char]",
			done = " Done.", -- mind the leading space
		},
	},
	tthelp = {
		DD_Zone = {
			"Select zone",
			"Only zones with associated \ncards can be selected"},
		DD_Sort = {
			"Select sorting order",
			"After sorting and grouping each group is sorted alphabetically. \nIt's always sorted ascending"},
		FilterBox = {
			"Enter text filter",
			"Only cards with a name containing the entered text fragment are selected. \nA 5/6-digit hex/decimal number will select the card with that object number"},
		ResetFilters = {
			"Reset all filters",
			"Clears all filters and sorting options"},
		Chk_Invert = {
			"Check to invert filter",
			"Negates the misc filter dropdown (left), selects cards which NOT meet the criteria"},
		ToggleSummaryButton = {
			"Show / Hide stats summary",
			"Shows a list with already acquired / total available stat bonuses"},
		Config = {
			"Show / Hide config dialog",
			"Show configuration options and tools."},
		Chk_ShowDetails = {
			"Show additional details",
			"Displays not so important informations about the selected card in a popup"},
		Global_ItemTT = {
			"Show Item tooltips",
			"If checked the new tooltip will be displayed on cards in bag, bank and else. Also the AAH filter $notowned is affected."},
		Global_MobTT = {
			"Expand mob tooltips",
			"If checked the tooltips on mobs will be expanded."},
		Global_HelpTT = {
			"Hide help tooltips",
			"If checked help tooltips like this are not displayed."},
		Char_DontSave = {
			"Don't save",
			"The owned status of this character is not saved in SaveVariables.lua. Other characters cannot refer to this information"},
		Char_NoSums = {
			"Don't show counter",
			"The counter information (Num/Chars) is not added to the status for this character."},
		Tools_SaveZones = {
			"Save zone list",
			"Zone list is saved to SaveVariables.lua as \"yaCIt_ZoneList\"."},
		Tools_SaveList = {
			"Save card list",
			"Full card list is saved to SaveVariables.lua as \"yaCIt_CardList\". Status information is not included; this can be found beneath \"yaCIt_Persistent\" and the related character."},
		Tools_RenewNPCzones = {
			"Renew card/zone associations",
			"Uses NPC world search to associate cards with zones. This takes more than 30 seconds!\nThis normally happens at load time when the number of cards has changed."},
		Tools_RemoveChar = {
			"Remove Character information",
			"This removes the informations of the selected character from SaveVariables.lua\nCounters will be updated on next load!"},
	},
	debug = {
		savedfilterlist = "Filtered list saved to SaveVariables.lua",
	}
}

