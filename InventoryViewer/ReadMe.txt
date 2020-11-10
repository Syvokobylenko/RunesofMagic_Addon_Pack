Inventory Viewer (by The Gooch, with help from Adie/Fortunis).

Description: 
-----------------
Have you ever wanted to know what items you had in various storage locations across multiple accounts and characters without having to visit your house or switch accounts/characters?
Have you ever wanted to know the total count of an item you had with a breakdown of which characters have it and where they stored it all in the item's tooltip?
Have you ever wanted to compare those items with what you're currently wearing?
Have you ever wanted to send other people a link to any of those items?
Well, now you can.  


Installation:
-------------
UnZip the InventoryViewer.zip file to your Runes of Magic AddOns folder and re-login to the game.  
When you UnZip it you should end up with a folder similar to this:
C:\Program Files\Runes of Magic\Interface\AddOns\InventoryViewer


Commands:
---------
/iv		Open Inventory Viewer user interface (/inventoryviewer also works)
/iv options	Display Inventory Viewer options panel
/iv WipeAccount	AccountName Wipes out all Inventory Viewer data for the specified account 
/iv [itemLink]	Get Inventory Viewer info on a specific item (how many you have and where they are stored)


Quick Notes:
------------
- You must log in as each character to populate the AddOn with initial data for each character.  Don't forget to open the House Chest/Clothes Rack/Weapon Rack/Furniture for each character as this is the only way for the AddOn to record the items in there.
- Hover the mouse over items to see Inventory Viewer's enhanced tooltips (How many of this item you have, and where it is stored).
- To change the order of your characters in Inventory Viewer, hold down the SHIFT key and drag & drop the tab with the characters name to the position you want to insert it.
- To delete a character from Inventory Viewer, simply right-click on the tab with that characters name and choose "Delete".  If you accidently delete the wrong character from Inventory Viewer, just log back into that character (and visit his house chest/clothes rack/weapon rack) again.
- To delete an account from Inventory Viewer, use the "/iv WipeAccount AccountName" command.
- To see all your house chests/racks/furniture, click the left or right arrow in the Inventory Viewer "Furniture" tab to flip through them.
- To save your equipped items into Inventory Viewer, open your Character frame ('C' by default) and click on the Inventory Viewer icon in the top-right (beside the necklage slot).  Then switch equipment sets (1 or 2) and do it again.


Binding a key to Inventory Viewer:
----------------------------------
If you want to bind a key the IV user interface, you will need to:

  1) Create the following macro: "/run ToggleUIFrame(IVFrame)" without the quotes.
  2) Put the macro icon on an action Bar (I put it on the hidden "Left Action Bar")
  3) Bind it to your key of choice in the RoM Key Bindings menu.  I am using "V" as my binding as it is beside the "B" key which I use often to open my backpack.

  The above assumes you are familiar with "Macros" and "Key Bindings" options in the main menu (when you hit the ESC key).
  Warning: Steps 2 & 3 need to be repeated for each character and to make things worse, again after a class swap since the action bars change per account/character/class.


Enjoy!
The Gooch



Changes:
--------------
v1.9:
- Added Phirius Token support (shows in the IV UI where the gold, rubies, diamonds, and AT charges are listed.  Note, this needs better placement but will do the trick for now.
- Fixed Japanese translations, Thanks to TBDjp.
- Fixed Taiwanese translations, Thanks to matif.
- Fixed German translation, Thanks to Chemos, Fliewatuet, and C3YRoM
- Added enhanced tooltip for Crafting (Ingredients and Item you are creating)
- Added House Servant's equipment/tools
- Changed the default search result to show a more detailed display (do "/run iv token" to search for any items with "token" in the name and see what I mean)
- Searches in IV_GetListOfItemsByNameOrItemLink() are now case-insensitive
- Changed default tab from Equipment I to Furniture/House Maid items

v1.8:
- When scanning/saving equipped items, IV will no longer use the hidden Arcane Transmutor slots as temporary storage while getting the itemLink.  Now it will only use the visible Arcane Transmutor slots and the Backpack.  This should get the RoM staff to remove their suggestion of not using Inventory Viewer since users will be able to get their items back if something goes wrong.
- IV can now get itemLinks for equipped items when you equip them from your Backpack, ItemShop bag, or Arcane Transmutor. This means you don't need to use the button in the character frame to Scan/Save all of your equipped items any more, but You still may want to the first time to populate the IV database without having to manually un-equip/re-equip all of your items.
  Note: Un-equipping and re-equipping items quickly may cause IV not to detect the change and be out of sync with what is really equipped.
  Note: Equipping a two-hander when you had a one-hander and a shield results in IV not knowing the shield was un-equipped (only notices the 1-hander being un-equipped).
  Note: Projectile counts aren't updated automatically in IV as you use them.
  Note: RoM dev really needs to add itemLink support for equipped items, trying to work around that is such a hassle and not perfect.
- Added warning to tooltip for the IV scanning/saving button in the character frame to warn users that clicking this button un-equips/re-equips items and if the re-equip fails to go find the item in the Arcane Transmutor or Backpack and re-equip it manually.
- Added tooltip over character tabs showing classes/levels of each character.
- Fixed bug when processing equipped items and AT slots were full.  IV tried to use an empty backpack slot but failed.
- Fixed bug where function hooks were never removed.  When logging out and back in as another character then 2 copies of function hooks were installed (one per login), leading to weird update behavior and inefficiencies.
- Fixed refresh issue when furniture items or equipped items change while the IV user interface is open (it wasn't showing in the UI right away, had to close/open the IV user interface or change tabs to see the change).
- Updated some tooltips to normalize the numbers (example: now showing 1,000,000 instead of 1000000).
- Added optimization: Don't scan bank pages 2,3,4,5 or backpack pages 3,4,5,6 if they aren't being rented at the moment.
- Reworked some of the Settings panel logic to make future settings easier to manage.
- Added Taiwan translations, thanks to matif.
- Updated French translations, thanks to snoopycurse.
- Removed info in this readme about using the 5 hidden Arcane Transmutor slots as this is considered a bug/exploit.  See German thread: http://forum.runesofmagic.com/showthread.php?p=1630606#post1630606

v1.7:
- Added support for saving equipped items into the IV database.  You must manually do this from the character frame.  Select the set you want to save (the 1 or 2 button) then click the IV bag icon to the right of the necklace slot.  Note, this takes time as it moves each item to an available slot in your AT or backpack, then grabs the item info, then re-equips it.  I know this sucks, but until RoM supports an API to get the itemLinks from equipped items this is what we're stuck with.  Sorry.  It's prone to error, so don't mess with your inventory while IV is saving these.
- Added support for saving changes when adding/removing items from an alts house furniture, thanks to Brumfodel for handing me the code.
- Furniture left/right buttons will now wrap-around (same logic as the account left/right buttons).
- Fixed Japanese translations, thanks to TBDjp.
- Fixed German translations, thanks to C3YRoM, Chemos, and Fliewatuet.

v1.6:
Warning: This version will wipe out your Inventory Viewer data, so you will need to visit all you characters and chests/racks/furniture/etc again.  Sorry.

- Added support for showing the following Gold/Diamonds/Rubies/Arcane Transmutor Charges:
  (Note: You will need to log into each character of each account once for the totals to be correct)
	Character Gold (total from currently selected character)
	Account Gold (total from all characters on selected account)
	Realm Gold (total from all characters of all accounts on this realm)
	Character Arcane Transmutor Charges (total from currently selected character)
	Account Arcane Transmutor Charges (total from all characters on selected account)
	Realm Arcane Transmutor Charges (total from all characters of all accounts on this realm)
	Account Diamonds (total from selected account)
	Realm Diamonds (total from all accounts on this realm)
	Account Rubies (total from selected account)
	Realm Rubies (total from all accounts on this realm)
- Added support for showing contents of all furniture (chests/racks/cabinets, etc).  They will all show up where the Chests did.  This should also resolve all issues where some chests aren't seen (usually on different languages).
- Added support for Arcane Transmutor items (you can store 10 items in there if you're tight on space).
- Added support for showing the ItemShop bag items in the UI (Thank You Brumfodel for the idea of where to show it!)
- Added performance enhancements during the bag change events.
- Fixed problem where you open a clothes/weapon rack or Chest in your friends house and IV thinks it's yours.  Now it will only record your house items.
- Added option to Show/Hide white borders (defaults to hidden).
- Added "/iv options" command to toggle the IV options panel
- Added "/iv WipeAccount AccountName" command to wipe out the Inventory Viewer database for the specified account without having to manually edit the SaveVariables.lua file.
- Removed the following slash commands as we have an options panel for them now:
	/iv tooltips
	/iv minimap
	/iv iconborders
- Fixed issue where a player may get "Inventory Viewer Error: All DisplayOrder numbers are taken!" followed by script errors.  This is caused by 1) having 8 characters on an account then 2) deleting a character from that RoM account, and then 3) creating a new character and logging in with that character.  IV see's it as 9 characters because it wasn't there to see the deletion of a character but detects the addition of the new character.  Thanks to Fortunis for troubleshooting this and helping with the fix.
- Updated this ReadMe to explain (above this "Changes" Section) how to bind Inventory Viewer to a key.
- Updated this ReadMe to explain (above this "Changes" Section) how to use all 10 slots of the Arcane Transmutor (Thanks Brumfodel!)

v1.5:
- Added Multi-Account support (Thanks for the help and the push from Adie/Fortunis)
- Added colored borders around icons to show item quality color (so you don't need to mouse-over every icon to see its quality color in the tooltip).
- Added Options panel, which currently supports toggling the Minimap icon, Colored item borders, and Enhanced Tooltips (Adie/Fortunis wrote most of this feature).
- Added detection of a 2 House Chests (Topaz Carved Treasure Box and Black Sail Treasure Box) - not sure if French is correct, but I think German is.
- Added French localization (Thanks to snoopycurse for doing the work and adding it to a message)
- Fixed bug where Inventory Viewer didn't notice items being moved around in the House Chest (Frogster now correctly sends the HOUSES_STORAGE_CHANGED event for these changes and stopped incorrectly sending the HOUSES_STORAGE_SHOW event for these changes but IV was still expecting the old incorrect event).
- Added event monitor for the BANK_OPEN and BANK_CLOSE events.  This will help (a little) with the issue where IV doesn't notice items being moved around in your bank.  The real fix is Frogster needs to support a BANK_CHANGED event (like they finally fixed for House Chests).
- Added public function "IV_GetListOfItemsByName(Name)" for pbInfo or other AddOns that want IV data.  "IV_GetListOfItems(itemLink)" is still available.  This was a request from a ticket posted on curse
- Changed GetLocation() to GetLanguage() as per Zilvermoons forum message.  He made a custom build for someone with this fix and I haven't heard any complaints.
- Fixed script error when you mouse-over the List of upgrades in your house (Elegant Two-Storied House, for example).
- Fixed missing detection of German "Schwarzsegel-Schatzkiste" (Black Sail Treasure Box) Chest.


v1.4:
- Changed some of the House Chest detection code, should help with German clients.
- More German translations.
- Fixed bug where IV icon moved around in the AddOn Manager's mini icon tray.

v1.3:
- Added support for all rental Bank pages.
- Added support for all rental Backpack pages.
- Added new registration method for the new AddOnManager.
- Fixed bug where /iv minimap didn't save its setting.
- Fixed bug where Lionhead Treasure Chest wasn't found on German client (untested, hopefully it works).
- Fixed bug where Magnificent Footstool Chest wasn't found on German client (untested, hopefully it works).
- Fixed bug where changing character tabs from someone who has a house chest to someone who doesn't still showed the name of the previous characters house chest.
- Fixed script error "Attempt to index field ? (a number value)".  This was caused by an old upgrade from v0.5 that didn't delete the old "Internal" sub-table.

v1.2:
- Added support for plugging into Alleris's AddOn Manager.
- Added Minimap frame icon (use "/iv minimap" to toggle it on/off).  It is on by default.
- Added support for multiple chests (8 different types being sold in the item shop).  Use the left/right arrows in the IV user interface to flip through all your chests.
- Fixed issue where some people's free house Chest wasnt DBID 0 and Inventory Viewer couldn't see it.
- Added support for recording Item Shop Backpack items.  Unfortunately there's no room in the UI to show them yet.  However, the enhanced tooltips will count Item Shop backpack items, so it's still useful.
- Added command to toggle enhanced tooltips (use "/iv tooltips" to toggle on/off).  It is on by default.
- *Warning*: You will need to re-visit all of your house chests after upgrading to this version, sorry for the inconvenience.  All other bags/racks don't need to be revisited, just house chests.

v1.1:
- Added support for passing an [itemLink] on the /iv command line.  This will log the results to the chat frame (how many of these you have, on which characters, where they are stored).  Usage: /iv [itemLink]
- Fixed bug where separator line in tooltip was too high (was not taking UIScale into consideration)
- Switched from GameTooltipHyperLink to GameTooltip for showing tooltips in the Inventory Viewer user interface.  The GameTooltipHyperLink shows an x in the top-right corner which is the wrong tooltip to use.
- Now showing IV info in the following Tooltips as well as the IV user interface: 
	Bank
	House Chest
	Backpack
	Item Shop Backpack
	Arcane Transmutor
	Auction House Browse items
	Booty (Loot)
	Chat Window item links
	Trash Bin
	Clothes Rack
	Weapon Rack

- I can't Add info to these tooltips as there's no way to get itemLinks for them:
	Mail
	Quest Log
	ActionBar items
	Merchant
	Crafting
	GuildBank

v1.0:
- Added support for counting the items Inventory Viewer knows about and showing the breakdown all in the item's tooltip from the Inventory Viewer UI.
- Note: Tooltips from anywhere else will not show this information, you must be viewing (mouse over) the item from the Inventory Viewer user interface to see the additional info in the tooltip.

v0.9:
- Added support for German clients to see the Clothes/Weapon Rack items.
- Note: I don't have a German client, so I couldn't test this but it should work.

v0.8:
- Added support for a Weapon Rack
- Optimization: Removed old Hanger tables introduced in v0.7.
- Fixed Clothes Rack detection bug for v0.7
- Fixed a bug where v0.7 data files could be set as v0.6 data files
- Note: The Weapons Rack and Clothes Rack will only work on the English client for now.  Sorry.

v0.7:
- Added support for one Clothes Rack.  I tested with one Mens Clothes Rack, not sure what will happen if user has two clothes racks or a Womans Clothes Rack.
- Fixed a possible issue when attempting to display another characters House Chest when that other character never initialized an empty house chest in a previous version of Inventory Viewer.

v0.6:
- Optimization: Inventory Viewer v0.6 data is almost 3 times smaller in size than it was with v0.5.
- Inventory viewer v0.4 and v0.5 data will automatically be imported and converted to v0.6 format.
- Fixed AddOn so it works with RoM 2.0.1.1812.

v0.5:
- Added support for moving the Inventory Viewer tabs (characters) around to any order the user wants.  Just hold SHIFT and drag the tabs to change their order.
- Optimization: Moved some duplicate code into functions.
- Optimization: Removed some variables that weren't needed.
- Fixed bug (since v0.3) where new users of the AddOn would see a warning in red about deleting old incompatible Inventory Viewer data.
- Fixed bug where calling ReloadUI() while the Inventory Viewer window was open resulted in not being able to open it again (unless you logged out/in).
- Fixed bug where Inventory Viewer would show the previously selected characters House Chest if the selected character didn't have one.
- Note: House chest is still broken in the game (build 1811) but this AddOn is doing the best it can to handle it.  Write-up is here: http://forum.runesofmagic.com/showthread.php?t=39567
- *Warning*: All Inventory Viewer data from v0.3 or less will be wiped out.  You will need to log in as each character (and open your House Chest if you have one) to re-populate the Inventory Viewer database.  Sorry.  (If you had v0.4, you're ok!)

v0.4:
- Added support for closing the window using the Escape key.
- Added version info to the data file so future versions can do special handling when upgrading older versions instead of requiring the user to do it.
- Optimization: No longer storing item name as the itemLink has it embedded
- Optimization: Calling RoM API only once to get the Account name and Player Name instead of each time we need it.
- Fixed bug where Inventory Viewer might not run (until ReloadUI() is called) due to GetCurrentRealm() being called too early with v0.3.
- *Warning*: All Inventory Viewer data from previous versions will be wiped out.  You will need to log in as each character (and open your House Chest if you have one) to re-populate the Inventory Viewer database.  Sorry.

v0.3:
- Switched back to the logic of each character having their own house chest, no longer shared per account. You will need to open your house chest on each character after updating this AddOn for the Inventory Viewer to record the items in there.
- Optimization: Calling RoM API only once to get the Realm Name instead of each time we need it.
- *Warning*: The Realm name will be stripped of colors which will make this incompatible with previous versions.  To save memory, please exit the game and delete your InventoryViewer(Account).ini file before using this version.  After upgrading you will need to log in to each character again (and open your House Chest if you have one) to populate the Inventory viewer with initial data (sorry).

v0.2:
- Added support for removing characters from the Inventory Viewer database.  Just right-click on the tab you want to remove and choose "Delete".
- Added ability to keep characters from different accounts separated.  Now each account has its own data file.
- Fixed a bug where the items didn't always match up with the selected tab.
- Fixed bug to handle /script ReloadUI()
- Fixed bug to handle users that don't have a house chest (some like to drop it on the floor and lose it)

v0.1:
- Original Release