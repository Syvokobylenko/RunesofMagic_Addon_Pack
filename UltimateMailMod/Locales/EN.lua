
-- #############################################################################
-- ##                                                                         ##
-- ##  Language     : English (EN/EU)                                         ##
-- ##  Locale       : EN                                                      ##
-- ##  Last updated : 24 jul 2012                                             ##
-- ##  Origin       : Original default language                               ##
-- ##  Author       : Maxeem of Muinin (DE)                                   ##
-- ##  Credits      : Shardea of Siochain (EN/EU)                             ##
-- ##                                                                         ##
-- #############################################################################

-- General
UMM_TITLE                           = "Ultimate Mail Mod";
UMM_PROMPT                          = "UltimateMailMod";
UMM_LOADED                          = " loaded.";

-- Slash settings
UMM_SLASH_HELP1                     = "Help for commands:";
UMM_SLASH_HELP2                     = "/umm sound : toggles audio warning on/off.";
UMM_SLASH_HELP3                     = "/umm reset : resets the list of own characters.";
UMM_SLASH_AUDIODISABLED             = "Audio warning when receiving new mails is now disabled.";
UMM_SLASH_AUDIOENABLED              = "Audio warning when receiving new mails is now enabled.";
UMM_SLASH_CHARSRESET                = "List of own characters has been reset.";

-- New mail notify
UMM_NOTIFY_NEWMAILARRIVED           = "New mail has arrived";
UMM_NOTIFY_TOOLTIP_TITLE            = "New mail";
UMM_NOTIFY_TOOLTIP_NEWMAIL          = "You have new mail waiting.";
UMM_NOTIFY_TOOLTIP_NEWMAILS         = "You have %d new mails waiting.";
UMM_NOTIFY_TOOLTIP_MOVETIP          = "Shift+Right-mouse: move this icon.";

-- Menu tabs
UMM_MENU_TAB1                       = MAIL_INBOX; -- Game default string
UMM_MENU_TAB2                       = MAIL_SENTMAIL; -- Game default string
UMM_MENU_TAB3                       = "Mass Send Items";
-- UMM_MENU_TAB4                       = "Mass Send Mail";

-- Tooltip specific
UMM_TOOLTIP_BOUND                   = "Bound";

-- Setting
UMM_SETTINGS_AUDIOWARNING           = "Play a sound when I receive new mails.";

-- Inbox
UMM_HELP_INBOX_LINE1                = "You can multi-select mails for :";
UMM_HELP_INBOX_LINE2                = "1) Take items / money /diamonds.";
UMM_HELP_INBOX_LINE3                = "2) Mass return mails.";
UMM_HELP_INBOX_LINE4                = "3) Mass delete mails.";
UMM_HELP_INBOX_LINE5                = "Ctrl + Left-click to tag / untag a mail.";
UMM_HELP_INBOX_RETURNTAGGED         = "Returns all tagged mails.";
UMM_HELP_INBOX_DELETETAGGED         = "Deletes all tagged mails.";

UMM_INBOX_LOADING                   = "Loading inbox - please wait ...";
UMM_INBOX_EMPTY                     = "Your inbox is empty.";

UMM_INBOX_BUTTON_TAGCHARS           = "Chars";
UMM_INBOX_BUTTON_TAGFRIENDS         = "Friends";
UMM_INBOX_BUTTON_TAGGUILDIES        = "Guildies";
UMM_INBOX_BUTTON_TAGOTHER           = "Other";
UMM_INBOX_BUTTON_TAGEMPTY           = "Empty";
UMM_INBOX_BUTTON_TAKE               = "Take";
UMM_INBOX_BUTTON_RETURN             = "Return";
UMM_INBOX_BUTTON_DELETE             = "Delete";

UMM_INBOX_OPTION_1                  = "Everything.";
UMM_INBOX_OPTION_2                  = "Items.";
UMM_INBOX_OPTION_3                  = "Money.";
UMM_INBOX_OPTION_4                  = "Diamonds.";

UMM_INBOX_CHECK_TOOLTIP				= "Enable Tooltip display.";
UMM_INBOX_CHECK_DELETEDONE          = "Delete mails when done taking.";

UMM_INBOX_LABEL_MASSTAG             = "Mass tag mails:";
UMM_INBOX_LABEL_TOTALMONEY          = "Total money in inbox:";
UMM_INBOX_LABEL_TOTALDIAMONDS       = "Total diamonds in inbox:";

UMM_INBOX_STATUS_TAKEALLTAGGED      = "Automatically opening mails - please wait ...";
UMM_INBOX_STATUS_PREPARETAKEDELETE  = "Preparing to delete opened mails - please wait ...";
UMM_INBOX_STATUS_RETURNTAGGED       = "Automatically returning mails - please wait ...";
UMM_INBOX_STATUS_DELETETAGGED       = "Automatically deleting mails - please wait ...";

-- Viewer
UMM_VIEWER_LABEL_FROM               = "From: ";
UMM_VIEWER_LABEL_SUBJECT            = "Subject:";

UMM_VIEWER_BUTTON_REPLY             = "Reply";
UMM_VIEWER_BUTTON_RETURN            = "Return";
UMM_VIEWER_BUTTON_DELETE            = "Delete";
UMM_VIEWER_BUTTON_CLOSE             = "Close";

UMM_VIEWER_ATTACHED                 = "Attached:";
UMM_VIEWER_ATTACHMENTCOD            = "C.O.D. price:";
UMM_VIEWER_ATTACHMENTACCEPT         = "I accept C.O.D.";
UMM_VIEWER_ATTACHMENT_NOT_ACCEPTED  = "Please check accept the C.O.D. and try again.";

-- Composer
UMM_COMPOSER_ADDRESSEE              = "To:";
UMM_COMPOSER_SUBJECT                = "Subject:";
UMM_COMPOSER_BUTTON_RESET           = "Reset";
UMM_COMPOSER_BUTTON_SEND            = "Send";
UMM_COMPOSER_ATTACHMENT             = "Attachment:";
UMM_COMPOSER_AUTOSUBJECT            = "Money: ";
UMM_COMPOSER_SENDGOLD               = "Send Gold";
UMM_COMPOSER_SENDCOD                = "C.O.D.";

UMM_COMPOSER_CONFIRM_TEXT1          = "Are you sure you want to send the amount";
UMM_COMPOSER_CONFIRM_TEXT2          = "shown bellow to %s ?";
UMM_COMPOSER_CONFIRM_YES            = "Yes";
UMM_COMPOSER_CONFIRM_NO             = "No";

UMM_RECIPIENT_OWN                   = "Characters";
UMM_RECIPIENT_FRIEND                = "Friends";
UMM_RECIPIENT_GUILD                 = "Guildies";

-- Mass Send Items
UMM_MSI_MARKBUTTON1                 = "Runes";
UMM_MSI_MARKBUTTON2                 = "F. Stones";
UMM_MSI_MARKBUTTON3                 = "Juwels";
UMM_MSI_MARKBUTTON4                 = "Ores";
UMM_MSI_MARKBUTTON5                 = "Wood";
UMM_MSI_MARKBUTTON6                 = "Herbs";
UMM_MSI_MARKBUTTON7                 = "R. Mats.";
UMM_MSI_MARKBUTTON8                 = "P. Runes";
UMM_MSI_MARKBUTTON9                 = "Foods";
UMM_MSI_MARKBUTTON10                = "Desserts";
UMM_MSI_MARKBUTTON11                = "Potions";
UMM_MSI_MARKBUTTON12                = "White Rec."; -- release 4.0.11.2531
UMM_MSI_MARKBUTTON13                = "Green Rec."; -- release 4.0.11.2531
UMM_MSI_MARKBUTTON14                = "Blue Rec."; -- release 4.0.11.2531
UMM_MSI_MARKBUTTON15                = "Magenta Rec."; -- release 4.0.11.2531
UMM_MSI_MARKBUTTON16                = "Guild"; -- 5.0.0.2545
UMM_MSI_MARKBUTTON17                = "Bag Stats"; -- 6.4.1.2753
UMM_MSI_MARKBUTTON18                = "Rune Pets"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON19                = "Earth Pets"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON20                = "Water Pets"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON21                = "Fire Pets"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON22                = "Wind Pets"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON23                = "Light Pets"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON24                = "Dark Pets"; -- 6.4.1.2769
UMM_MSI_MARKBUTTON25                = "Dyn.. Cen.."; -- Cenedril
UMM_MSI_MARKBUTTON26                = "Std.. Cen.."; -- Cenedril
UMM_MSI_MARKBUTTON27                = "Mys.. Cen.."; -- Cenedril
UMM_MSI_MARKBUTTON28                = "All Above";

UMM_MSI_MARK_LABEL                  = "Mark:";
UMM_MSI_MARK_TOOLTIP1               = "Runes";
UMM_MSI_MARK_TOOLTIP2               = "Fusion Stones";
UMM_MSI_MARK_TOOLTIP3               = "Juwels";
UMM_MSI_MARK_TOOLTIP4               = "Ores";
UMM_MSI_MARK_TOOLTIP5               = "Wood";
UMM_MSI_MARK_TOOLTIP6               = "Herbs";
UMM_MSI_MARK_TOOLTIP7               = "Raw Materials";
UMM_MSI_MARK_TOOLTIP8               = "Production Runes";
UMM_MSI_MARK_TOOLTIP9               = "Foods";
UMM_MSI_MARK_TOOLTIP10              = "Desserts";
UMM_MSI_MARK_TOOLTIP11              = "Potions";
UMM_MSI_MARK_TOOLTIP12              = "White Recipes"; -- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP13              = "Green Recipes"; -- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP14              = "Blue Recipes"; -- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP15              = "Magenta Recipes"; -- release 4.0.11.2531
UMM_MSI_MARK_TOOLTIP16              = "Guild Contribution"; -- 5.0.0.2545
UMM_MSI_MARK_TOOLTIP17              = "Bag Stat Items"; -- 5.0.0.2769
UMM_MSI_MARK_TOOLTIP18              = "Rune Pet Eggs"; -- 6.4.1.2769
UMM_MSI_MARK_TOOLTIP19              = "Earth Pet Eggs"; -- 6.4.1.2769
UMM_MSI_MARK_TOOLTIP20              = "Water Pet Eggs"; -- 6.4.1.2769
UMM_MSI_MARK_TOOLTIP21              = "Fire Pet Eggs"; -- 6.4.1.2769
UMM_MSI_MARK_TOOLTIP22              = "Wind Pet Eggs"; -- 6.4.1.2769
UMM_MSI_MARK_TOOLTIP23              = "Light Pet Eggs"; -- 6.4.1.2769
UMM_MSI_MARK_TOOLTIP24              = "Dark Pet Eggs"; -- 6.4.1.2769
UMM_MSI_MARK_TOOLTIP25              = "Dynamic Cenedril"; -- Cenedril
UMM_MSI_MARK_TOOLTIP26              = "Steadfast Cenedril"; -- Cenedril
UMM_MSI_MARK_TOOLTIP27              = "Mystical Cenedril"; -- Cenedril
UMM_MSI_MARK_TOOLTIPCLICK           = "Click to mark all slots of items in this category.";

UMM_MSI_BUTTON_ADDRESSEE            = "To:";
UMM_MSI_BUTTON_RESET                = "Reset";

UMM_MSI_MAILSTOSEND                 = "Mails to send: %d";
UMM_MSI_ADDRESSEE                   = "To:";
UMM_MSI_SUBJECT                     = "Subject:";
UMM_MSI_COD                         = "C.O.D.";
UMM_MSI_STATUS                      = "Status:";
UMM_MSI_STATUS_SENDING              = "Sending...";
UMM_MSI_STATUS_QUEUED               = "Queued.";
UMM_MSI_BUTTON_SEND                 = "Send";
UMM_MSI_BUTTON_COD                  = "C.O.D.";
UMM_MSI_BUTTON_CANCEL               = "Cancel";
UMM_MSI_SEND_STATUS                 = "Sending %d of %d - please wait ...";
UMM_MSI_SEND_MAILBODY               = "Hi %s\n\nI used Ultimate Mail Mod to send this item to you.\n\nPlease enjoy.\n\nKind regards\n%s\n\n%s";

-- Error messages
UMM_ERROR_CANTSENDSELF              = "You can not send mails to yourself.";
UMM_ERROR_NOSUBJECT                 = "Please enter a subject for this mail.";
UMM_ERROR_CANTSENDBOUND             = "You can not send bound items.";

UMM_ERROR_AUTOMATIONFAILED          = "Automation process failed - process halted.";
UMM_ERROR_NOTHINGTAGGED             = "Please tag one or more mails !";
UMM_ERROR_CANTDELETE                = "Unable to delete mails with attachments !";
UMM_ERROR_CANTRETURN                = "Unable to return mail !";
UMM_ERROR_CANTTAKECOD               = "C.O.D. mails can not be auto-taken !";
UMM_ERROR_CANTTAKE                  = "Tagged mail does not meet required take conditions !";
