
 ¤#####################################################¤
 #                                                     #
 #  Ultimate Mail Mod (continued)                      #
 #                                                     #
 #  Version: 6.5.6.2774.008                            #
 #  By Jagodragon                                      #
 #                                                     #
 #     Maxeem of Muinin                                #
 #     maxeem@silverlights-muinin.de                   #
 #                                                     #
 #  Thanks to Ultak                                    #
 #                                                     #
 #  Credits to:                                        #
 #    Shardea of Siochain (EN/EU)                      #
 #                                                     #
 ¤#####################################################¤

 
CHANGELOG:

#Known issues
   *  Sending more than 60 mails at one time, can cause some Glitchyness with the interface.
   *  having item preview turned on while statrating is installed will cause the time on new mail to set for 3days on mousover

Version: 7.0.1.2787.001
Release date: Oct 9 2016
# Changes
	*Added All Above option to mass send selection buttons
  *Updated and fixed DB issues (this is a work in progress and will continue as things are found)
  *Added missed translations for other languages (please verify them and let me know)
   
Version: 6.5.6.2774.009
Release date: May 8 2016
# Changes
	*Temporarily set item preview to off by default
	
Version: 6.5.6.2774.008
Release date: May 7 2016
# Changes
	*minor changes to backend
	*added pet eggs buttons to mass send tab
	*added Cenedril items to db separated by type
	*added buttons for cenedril items to the mass send tab

Version: 6.4.2.2769.007
Release date: May 7 2016
# Changes
	*minor changes to backend
	*added pet eggs to the db (separated by element not rarity)

Version: 6.4.2.2758.005-6
Release date: December 2 2015
# Changes
	*Updated: Updated Database adding several missing items

Version: 6.4.2.2755.004
Release date: November 8 2015
# Changes
	*Updated: Updated Blue Raw materials up to lvl 96 

Version: 6.4.2.2754.003
Release date: November 1 2015
# Changes
	*Fixed: Duplicate item Id's in the item db
	*Updated: Added Todo Ginkgo to item db
   
Version: 6.4.1.2752.002
Release date: October 17 2015
#  Changes
   * Fixed: Fixed an error in the code for item id's Thanks goe sout to ztrek from Curse!
   * Fixed: versioning number to include umm rev number 
#  Changes
   *  Updated:  Updated Ore/Wood/Herbs/GuildMats buttons. (Credits to Ultak)
   *  Added:  Improved on the database. (Credits to Ultak)
   *  Added:  Button and back-end for Bag Stat selection and mailing. (Credits to Ultak)

Version: 6.4.1.2752.001
Release date: October 9th 2015
#  Known issues
   *  Sending more than 60 mails at one time, can cause some Glitchyness with the interface.
 
-------------------------------------------------------
 
 
 
 


Ultimate Mail Mod is an extension to the existing mail system.
The original interface is "hidden" and "replaced" by the UMM interface.

Features:

Inbox
-=-=-
* Lists up to 18 mails in the inbox.
* The sender's name of each mail is color coded by reference type:
  * Red/orange: One of your own characters.
  * Bluish: Friend
  * Green: Guildie
  * Yellow: Anyone not on the above lists.
* Alternative icons displayed for mails depending on their read/unread status.
* Displays mails inside the UMM window on the right hand side of the window.
* Displays total amount of gold / diamonds on all visible mails in the inbox.
* Inbox offers automatic opening and grabbing of attachments. Can be filtered by items, gold, diamonds or all.
* Inbox offers automatic mass-return / mass-delete of mails. Ctrl+Left-mouse to toggle tags.

Composer
-=-=-=-=
* Mail Composer adds lists of "Characters", "Friends" and "Guildies" (if guilded) for easy recipient selection.
* Automatic subject creation if you only attach money.

UMM automatically logs and saves the names of all the characters you use on your computer.

Mass Send Items
-=-=-=-=-=-=-=-
* Like the Composer you can quick select from "Characters", "Friends" and "Guildies" (if guilded)
* Full backpack (all 6 tabs) display of items.
* Click an item slot to toggle that slot for sending. Will display a yellow border around the slot if it's marked for sending.
* Click one of the 16 buttons in the bottom of the window for category tagging of items. (Runes/Herbs/Wood/etc.)
* If filled in, the Receipient will be selected while clicking one of the 16 buttons of the window.
* Choose to either just send all the items right away or set up C.O.D. values for each slot of items sent.
* Display of current send status - mails listed and status displayed: "sending" or "queued". Top-most mail is the one being sent.

UMM has a complex set of checks to prevent accidental deletion of mails containing items aswell as built in checks to stop
automation in case of any failures.

Memory Cleanup
-=-=-=-=-=-=-=
Every 15 minutes UMM will call a memory cleanup function which is built into the scripting language. This function clears up
any unused variables and left overs from addon data handling and thereby lowers the total addon memory usage for all addons
which in turn increases performance. This cleanup is not automatically performed by the scripting language but must be called.
The game currently has some crash issues which usually result in loss of settings in addons - the cleanup has nothing to do with
the loss of settings. Other addons that don't store their settings correctly may be affected by the cleanup.

Usage
-=-=-

Simply open any mailbox to have the UMM window displayed. All the features of UMM are enclosed in the UMM window.

There are two chat commands aswell:

/umm sound : This command will toggle the audio warning played when receiving new mails.
             This setting can also be found at the bottom of the UMM window.

/umm reset : This command will reset the automatic character name log.
             Note that names placed in the hardwired own characters list will not be deleted - only the names automatically
             logged which don't appear on the hardwire list.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

[#] Known Issues [#]
====================

* 30 mail limit pr. time visiting the mailbox
The server currently has a limit of 30 mail topics pr. time you open the mailbox. The standard mail interface has this limit
aswell. Currently no function exists to refresh the inbox mail list so the only way to get the inbox table of contents refreshed
is to close the mailbox and open it again. A call to the open mailbox function has no effect.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Hardwiring and sorting own characters
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

A preselection can be done for tagged items mass send function.
For more details see  characters.lua.

As of build 1675 you can hardwire the names of your own characters. Note that UMM will still auto-log and save any other
characters you load however these names will be added to the bottom of the hardwire list. In the "Recipient" folder you'll
find a file called "Characters.lua". This file can be edited to hold your hardwired characters.

Recipient\Characters.lua

Open this file using any plain text editor. The file contains and empty variable and instructions on how to
create the list but I'll repeat the instructions here aswell for reference.

You can add any number of names to the list but be sure to enter the names correctly as the mail system sometimes appears to be
case sensitive and sometimes not.

Sample of how the list MUST be created:

UMM_OwnCharacters = {
  [1] = "CharFive",
  [2] = "CharOne",
  [3] = "CharThree",
  [4] = "CharFour",
  [5] = "CharTwo",
};

Be sure to enclose the numbers in brackets as shown above and be sure to keep the numbers incremental. Character names MUST be
enclosed in quotes just as shown above.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

For those wishing to tweak the speed of UMM
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

WARNING! Changing the speed of UMM may result in automation stalls or lost items !! I can not stress the importance of this enough!!

Should you despite of this warning still wish to tweak the speed settings you can do so in:
Library\Tools.lua

Values specified are in seconds.

UMM_GLOBAL_AUTOMATION_WAITTIME
Changes the global delay between each automated action. This value defines the wait time between each action. The value is set
to prevent the server from getting flooded - if the server gets flooded it simply stops responding which stalls the automation
process.

UMM_GLOBAL_AUTOMATION_WAITTIMEOUT
This value is the time allowed for any automation process to complete it's current task. You should NOT tamper with this setting
however you can increase this value to allow for more time before stopping automation processes if you are on a high-lag server.

UMM_AUTOMATION_DELETE_WAITTIME
This value is the time spent waiting between each delete command. It's default setting is 1/4 of a second and seems to be the
"right" setting on my server. If the auto-delete process stalls too often on your server you can increase this value to allow
more time to pass between each delete command.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

[#] Change-log [#]
==================

Release version: 5.0.9
Release date   : 14 august 2014

fixed implumentation of lib stub
fixed interfearence with some other addons



Release version: 5.0.3.2579
Release date   : 8 October 2012


Fixes
-=-=-

* Item collection will not stop anymore if the "Bagslots full" warning message appears and there are still free slots left.

Changes
-=-=-=-

* Item-DB updates - new materials inserted
* New localizations inserted - French (FR) and Spanish (ES)

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

[#] Change-log [#]
==================

Release version: 5.0.1.2553
Release date   : 5 August 2012


Fixes
-=-=-

* Recipes-Buttons will now work as required.
* Tweek the WAITTIME to work faster on medium sized workstations.

Changes
-=-=-=-

* Item-DB updates.
* Inbox received a mailcount (e.g. Inbox (30)) in the Tab-Description


¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

[#] Change-log [#]
==================

Release version: 5.0.1.2550
Release date   : 24 July 2012


Fixes
-=-=-

* Fixed the single item attachment problem

Changes
-=-=-=-

* Added a new button to enable/disable the Inbox Mail Tooltip display function. The default is set to disabled the tooltip display.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

[#] Change-log [#]
==================

Release version: 5.0.0.2545
Release date   : 04 July 2012


Changes
-=-=-=-

* Changes to update the in-game runes at start of chapter 5 
* Added a new button to handel guild contribution items

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

[#] Change-log [#]
==================

Release version: 4.0.8.2506
Release date   : 8 March 2012

Fixes
-=-=-

* Fixed a few missing item declarations in the german localization file, which are needed to send money attached to a mail.

Changes
-=-=-=-

* Changed the release version reflecting now the tested version of RoM Client
* Changed the UMM_GLOBAL_AUTOMATION_WAITTIME to default 0.5 of a second. This seems to be a suitable/workable value.
* Changed the seperator symbole for money from "," to "."

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Release version: 1.6.5.1676
Release date   : 7 dec 2009

Fixes
-=-=-

* Fixed a bug that popped an error message in the Mass Send Items tab while not in the mailbox.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Release version: 1.6.5.1675
Release date   : 7 dec 2009

Fixes
-=-=-

* Escape key stops working: changed the event order and handling of the windows - escape key works now.
* MailViewer - subject texts expanded across the border of the window: fixed the size of the label.
* Sometimes settings and list of own characters may be lost: changed the way UMM saves settings and this list.
* "New mail" icon / button missing. Fixed the button to be detached from the minimap frame to allow for UI-change addons.
* Fixed a bug that prevented the "New mails" button from updating when returning mails.
* Added extra attachment checks on mails to further secure mails against accidental deletes of mails containing
  attachments/currencies.
* Fixed a bug that prevented the tabs from disabling while automatically sending items in the Mass Send Items tab.
* Mass Send Items didn't cancel and return to default view if the automation stopped because of server lag.
  This should be fixed now.

Changes
-=-=-=-

* Memory cleanup chat prompt has been removed.
* Mass Send Items - mark border was changed from white to yellow.
* Delete delay was reduced from one second to a quarter of a second.

New additions
-=-=-=-=-=-=-

* Tooltips added to the "New mail" icon / button.
* "New mail" icon / button is now movable like any other minimap button.
* A "New mail has arrived" message will be displayed on-screen when new mails arrive.
* Two chat commands have been added for control outside the UMM window.
* If AddonManager is installed UMM will suppress the initial chat prompt stating it's loaded.
* Inbox tool panel now has 5 extra buttons for mass-tagging: chars, friends, guildies, others and empty mails.
* Composer / MSI characters lists: added online/offline status display for friends and guildies.
  Offline names will display in grey.
* Composer / MSI characters lists: added a hardwire file for own characters - see: Recipient\Characters.lua for further info.
* Composer now has a confirm box when sending gold to another player.
* Mass Send Items - item slots now have item rarity borders displayed.

Languages
-=-=-=-=-

* EN - English (EU / USA)
* DE - German

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Release version: 1.0.1.1578
Release date   : 24 nov 2009

Fixes
-=-=-

* Fixed localization load function that failed on german clients.
* Corrected german language file.
* Fixed a bug that hid the "Send" button on the Mass Send Items tab after using C.O.D.
* Fix a bug that displayed the "Guildies" column even tho the character was not guilded.

Changes
-=-=-=-

* Changed the timing a little to make automation a bit faster.

New additions
-=-=-=-=-=-=-

* Added Traditional Chinese language file. Revision number got upped one notch.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Release version: 1.0.0.1575
Release date   : 20 nov 2009

Fixes
-=-=-

* The three columns on the "Mass Send Items" has been fixed.
* The bug that caused UMM to fail when opening mails while the backpack is full has been fixed.

New additions
-=-=-=-=-=-=-

* A 15 minute memory cleanup timer has been added - will perform a memory cleanup every 15 minutes - out of combat only.
* German locale texts have been added thanks to Necrocrypt - you've been credited in the locale file.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Release version: 1.0.0.1565 beta
Release date   : 15 nov 2009
Release notes  : This version was only released in-guild (International guild TheAzureOrder on Siochain - www.azureorder.dk)

This release contains a major rewrite of all the automation code in the addon.

Fixes
-=-=-

* UMM should no longer "hang" when certain events don't trigger. Complete re-write of the handling code.
* Correct color coding of own characters before guildies in the table of contents.
* Bag display in "Mass Send Items" no longer fails.
* Inbox now correctly sorts between gold and diamonds when counting totals.
* Bound items can no longer be selected / sent.
* Sending mails now has 3 extra security checks to ensure mails are valid before sending is attempted.

Changes
-=-=-=-

* The two tabs "Group Mail" and "Settings" have been removed.
* The sound warning setting is now at the bottom of the window.

New additions
-=-=-=-=-=-=-

* "You have new mail" icon will be displayed near the minimap.
* Current version number is shown at the bottom-right of the window.
* Inbox now has an additional help panel.
* Inbox now allows multi-selection of mails.
* Inbox multi-selected mails can be mass-returned / mass-deleted.
* Mails with Cash On Delivery (C.O.D.) amounts have yellow subjects - all other mails have white / grey subjects.
* Inbox displays total gold / total diamonds seperately.
* "Mass Send Items" now has 11 different groups of items for quick selection.
* The new automation handler includes a new proper cancel action if the window is closed while automation is running.
* The automation cancel handler inclused a max of 10 seconds before it automatically cancels automation that failed.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Release version: 1.0.0.1282 beta
Release date   : 10 nov 2009
Release notes  : This version was only released in-guild (International guild TheAzureOrder on Siochain - www.azureorder.dk)

The inbox table of contents has been changed:

I've changed the inbox view a little to make room for attached money display for each mail. Result is a slightly smaller
subject text which is moved up a bit and to the right I've put in a small money display on the same line. The subject and
money display are slightly shiftet to allow for long subjects without conflicting with each other.

In the bottom right hand corner of the window I've placed a total attached gold amount display which will only be displayed if
at least one mail has money attached to it.

I have also changed the subject color from white/grey to yellow for mails that have a C.O.D. (Cash On Delivery) amount attached.
The subject will stay yellow as long as the C.O.D. value has not been sent back to the sender. Once the C.O.D. value has been
payed the mail changes to an "empty" (text-only) mail and reverts back to the normal mail status.

¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤#¤

Release version: 1.0.0.1239 beta
Release date   : 9 nov 2009
Release notes  : This version was only released in-guild (International guild TheAzureOrder on Siochain - www.azureorder.dk)

