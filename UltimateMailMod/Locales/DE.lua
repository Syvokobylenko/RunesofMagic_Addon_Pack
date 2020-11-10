
-- #############################################################################
-- ##                                                                         ##
-- ##  Language     : German (DE)                                             ##
-- ##  Locale       : DE                                                      ##
-- ##  Last updated : 09 aug 2012                                             ##
-- ##  Origin       : Translated                                              ##
-- ##  Author       : Maxeem of Muinin (DE)                                   ##
-- ##  Credits to Necrocrypt of Siochain (EN/EU) and skitey at Curse.         ##
-- ##                                                                         ##
-- #############################################################################

-- General
UMM_TITLE                           = "Ultimate Mail Mod";
UMM_PROMPT                          = "UltimateMailMod";
UMM_LOADED                          = " geladen.";

-- Slash settings
UMM_SLASH_HELP1                     = "Eingabehilfe:";
UMM_SLASH_HELP2                     = "/umm sound : Audio Warnung ein-/ausschalten."; 
UMM_SLASH_HELP3                     = "/umm reset : Setzt die Liste eigener Charaktere zurück.";
UMM_SLASH_AUDIODISABLED             = "Audio Warnung bei eingehender Post ist jetzt ausgeschaltet."; 
UMM_SLASH_AUDIOENABLED              = "Audio Warnung bei eingehender Post ist jetzt eingeschaltet."; 
UMM_SLASH_CHARSRESET                = "Liste der eigenen Charaktere wurde zurückgesetzt.";

-- New mail notify
UMM_NOTIFY_NEWMAILARRIVED           = "Du hast neue Post"; 
UMM_NOTIFY_TOOLTIP_TITLE            = "Neue Post"; 
UMM_NOTIFY_TOOLTIP_NEWMAIL          = "Auf dich wartet neue Post."; 
UMM_NOTIFY_TOOLTIP_NEWMAILS         = "Auf dich warten %d neue Briefe."; 
UMM_NOTIFY_TOOLTIP_MOVETIP          = "Shift+Right-mouse: Icon bewegen."; 

-- Menu tabs
UMM_MENU_TAB1                       = "Eingang";
UMM_MENU_TAB2                       = "Versenden";
UMM_MENU_TAB3                       = "Massenversand Gegenstände";

-- Tooltip specific
UMM_TOOLTIP_BOUND                   = "Gebunden";

-- Setting
UMM_SETTINGS_AUDIOWARNING           = "Sound abspielen, wenn Ich neue Post erhalte.";
UMM_RECIPES_NAME_PREFIX				= "Rezeptur";

-- Inbox
UMM_HELP_INBOX_LINE1                = "Du kannst mehrere Mails markieren:";
UMM_HELP_INBOX_LINE2                = "1) Gegenstand / Geld entnehmen"; -- release 4.0.8.2506
UMM_HELP_INBOX_LINE3                = "2) Mehrere Briefe zurückschicken.";
UMM_HELP_INBOX_LINE4                = "3) Mehrere Briefe löschen.";
UMM_HELP_INBOX_LINE5                = "Strg + Links-click um einen Brief zu markieren / entmarkieren.";
UMM_HELP_INBOX_RETURNTAGGED         = "Alle markierten Briefe zurückschicken.";
UMM_HELP_INBOX_DELETETAGGED         = "Alle markierten Briefe löschen.";

UMM_INBOX_LOADING                   = "Postfach wird geladen - Bitte warten...";
UMM_INBOX_EMPTY                     = "Dein Postfach ist leer.";

UMM_INBOX_BUTTON_TAGCHARS           = "Charaktere"; 
UMM_INBOX_BUTTON_TAGFRIENDS         = "Freunde"; 
UMM_INBOX_BUTTON_TAGGUILDIES        = "Gildenmitglieder"; 
UMM_INBOX_BUTTON_TAGOTHER           = "Andere"; 
UMM_INBOX_BUTTON_TAGEMPTY           = "Leer"; 
UMM_INBOX_BUTTON_TAKE               = "Entnehmen";
UMM_INBOX_BUTTON_RETURN             = "Zurückschicken";
UMM_INBOX_BUTTON_DELETE             = "Löschen";

UMM_INBOX_OPTION_1                  = "Alles.";
UMM_INBOX_OPTION_2                  = "Gegenstände.";
UMM_INBOX_OPTION_3                  = "Geld.";
UMM_INBOX_OPTION_4                  = "Diamanten.";

UMM_INBOX_CHECK_TOOLTIP				= "Tooltips anzeigen.";	-- release 5.0.1.2550
UMM_INBOX_CHECK_DELETEDONE          = "Briefe nach Entnahme löschen.";

UMM_INBOX_LABEL_MASSTAG             = "Mehrere Briefe markieren:"; 
UMM_INBOX_LABEL_TOTALMONEY          = "Gesamtmenge Geld im Postfach:";
UMM_INBOX_LABEL_TOTALDIAMONDS       = "Gesamtmenge Diamanten im Postfach:";

UMM_INBOX_STATUS_TAKEALLTAGGED      = "Automatisches Briefe öffnen - Bitte warten ...";
UMM_INBOX_STATUS_PREPARETAKEDELETE  = "Löschen der Briefe wird vorbereitet - Bitte warten ...";
UMM_INBOX_STATUS_RETURNTAGGED       = "Automatisches Briefe zurückschicken - Bitte warten ...";
UMM_INBOX_STATUS_DELETETAGGED       = "Automatisches Briefe löschen - Bitte warten ...";

-- Viewer
UMM_VIEWER_LABEL_FROM               = "Absender: ";
UMM_VIEWER_LABEL_SUBJECT            = "Betreff:";

UMM_VIEWER_BUTTON_REPLY             = "Antwort:";
UMM_VIEWER_BUTTON_RETURN            = "Zurückschicken";
UMM_VIEWER_BUTTON_DELETE            = "Löschen";
UMM_VIEWER_BUTTON_CLOSE             = "Schließen";

UMM_VIEWER_ATTACHED                 = "Anhang:";
UMM_VIEWER_ATTACHMENTCOD            = "Nachnahmepreis:";
UMM_VIEWER_ATTACHMENTACCEPT         = "Nachnahme akzeptieren";
UMM_VIEWER_ATTACHMENT_NOT_ACCEPTED  = "Bitte Nachnahme akzeptieren auswählen und wiederholen.";

-- Composer
UMM_COMPOSER_ADDRESSEE              = "An:";
UMM_COMPOSER_SUBJECT                = "Betreff:";
UMM_COMPOSER_BUTTON_RESET           = "Zurücksetzen";
UMM_COMPOSER_BUTTON_SEND            = "Senden";
UMM_COMPOSER_ATTACHMENT             = "Anhang:";
UMM_COMPOSER_AUTOSUBJECT            = "Geld: ";
UMM_COMPOSER_SENDGOLD               = "Gold senden";
UMM_COMPOSER_SENDCOD                = "Nachnahme";

UMM_COMPOSER_CONFIRM_TEXT1          = "Sind sie sicher, das sie die angezeigte Anzahl Gold"; -- release 4.0.8.2506
UMM_COMPOSER_CONFIRM_TEXT2          = "an %s schicken wollen?";		-- release 4.0.8.2506
UMM_COMPOSER_CONFIRM_YES            = "Ja";							-- release 4.0.8.2506
UMM_COMPOSER_CONFIRM_NO             = "Nein";						-- release 4.0.8.2506

UMM_RECIPIENT_OWN                   = "Charaktere";
UMM_RECIPIENT_FRIEND                = "Freunde";
UMM_RECIPIENT_GUILD                 = "Gildenmitglieder";

-- Mass Send Items
UMM_MSI_MARKBUTTON1                 = "Runen";
UMM_MSI_MARKBUTTON2                 = "F. Steine";
UMM_MSI_MARKBUTTON3                 = "Juwelen";
UMM_MSI_MARKBUTTON4                 = "Erz";
UMM_MSI_MARKBUTTON5                 = "Holz";
UMM_MSI_MARKBUTTON6                 = "Kräuter";
UMM_MSI_MARKBUTTON7                 = "R. Mats.";
UMM_MSI_MARKBUTTON8                 = "P. Runen";
UMM_MSI_MARKBUTTON9                 = "Nahrung";
UMM_MSI_MARKBUTTON10                = "Nachspeise";			-- release 4.0.8.2506
UMM_MSI_MARKBUTTON11                = "Tränke";
UMM_MSI_MARKBUTTON12                = "Weiße Rez.";			-- release 4.0.11.2531
UMM_MSI_MARKBUTTON13                = "Grüne Rez.";			-- release 4.0.11.2531
UMM_MSI_MARKBUTTON14                = "Blaue Rez.";			-- release 4.0.11.2531
UMM_MSI_MARKBUTTON15                = "Lila Rez.";			-- release 4.0.11.2531
UMM_MSI_MARKBUTTON16                = "Gilde";				-- release 5.0.0.2545
UMM_MSI_MARKBUTTON17                = "Bag Stat"; -- 6.4.1.2753
UMM_MSI_MARKBUTTON18                = "Rune Haustier"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON19                = "Erde Haustier"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON20                = "Wasser Haustier"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON21                = "Feuer Haustier"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON22                = "Wind Haustier"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON23                = "Licht Haustier"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON24                = "Dunkel Haustier"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON25                = "Dyn.. Cen.."; -- Cenedril
UMM_MSI_MARKBUTTON26                = "Std.. Cen.."; -- Cenedril
UMM_MSI_MARKBUTTON27                = "Mys.. Cen.."; -- Cenedril
UMM_MSI_MARKBUTTON28                = "Alle Oben"; -- Cenedril

UMM_MSI_MARK_LABEL                  = "Wähle:";
UMM_MSI_MARK_TOOLTIP1               = "Runen";
UMM_MSI_MARK_TOOLTIP2               = "Fusions Steine";
UMM_MSI_MARK_TOOLTIP3               = "Juwelen";
UMM_MSI_MARK_TOOLTIP4               = "Erz";
UMM_MSI_MARK_TOOLTIP5               = "Holz";
UMM_MSI_MARK_TOOLTIP6               = "Kräuter";
UMM_MSI_MARK_TOOLTIP7               = "Roh-Material";
UMM_MSI_MARK_TOOLTIP8               = "Produktions Runen";
UMM_MSI_MARK_TOOLTIP9               = "Nahrung";
UMM_MSI_MARK_TOOLTIP10              = "Nachspeisen";
UMM_MSI_MARK_TOOLTIP11              = "Tränke";
UMM_MSI_MARK_TOOLTIP12              = "Weisse Rezepte";		-- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP13              = "Grüne Rezepte";		-- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP14              = "Blaue Rezepte";		-- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP15              = "Lila Rezepte";		-- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP16              = "Gildenbeiträge"; 	-- release 5.0.0.2545
UMM_MSI_MARK_TOOLTIPCLICK           = "Klicken um alle Gegenstände dieser Kategorie zu markieren.";

UMM_MSI_BUTTON_ADDRESSEE            = "An:";
UMM_MSI_BUTTON_RESET                = "Zurücksetzen";

UMM_MSI_MAILSTOSEND                 = "Briefe zu versenden: %d";
UMM_MSI_ADDRESSEE                   = "An:";
UMM_MSI_SUBJECT                     = "Betreff:";
UMM_MSI_COD                         = "Nachnahme";
UMM_MSI_STATUS                      = "Status:";
UMM_MSI_STATUS_SENDING              = "Versenden...";
UMM_MSI_STATUS_QUEUED               = "Warteschlange.";
UMM_MSI_BUTTON_SEND                 = "Senden";
UMM_MSI_BUTTON_COD                  = "Nachnahme";
UMM_MSI_BUTTON_CANCEL               = "Abbrechen";
UMM_MSI_SEND_STATUS                 = "Versenden %d von %d - Bitte warten...";
UMM_MSI_SEND_MAILBODY               = "Hallo %s\n\nIch benutze Ultimate Mail Mod um dir diesen Gegenstand zu schicken.\n\nViel Spass und guten Loot.\n\nFreundliche Grüße\n%s\n\n%s"; -- release 4.0.8.2506

-- Error messages
UMM_ERROR_CANTSENDSELF              = "Du kannst dir selbst keine Briefe schicken.";
UMM_ERROR_NOSUBJECT                 = "Bitte einen Betreff angeben.";
UMM_ERROR_CANTSENDBOUND             = "Du kannst keine Gebundenen Gegenstände versenden.";

UMM_ERROR_AUTOMATIONFAILED          = "Automatisierter Prozess fehlgeschlagen - Prozess gestoppt.";
UMM_ERROR_NOTHINGTAGGED             = "Bitte markiere einen oder mehrere Briefe!";
UMM_ERROR_CANTDELETE                = "Briefe mit Anhang konnten nicht gelöscht werden !";
UMM_ERROR_CANTRETURN                = "Zurückschicken des Briefes fehlgeschlagen !";
UMM_ERROR_CANTTAKECOD               = "Nachnahmebriefe konnten nicht automatisch angenommen werden !";
UMM_ERROR_CANTTAKE                  = "Markierter Brief trifft nicht die nötigen Entnahmebedingungen !";
