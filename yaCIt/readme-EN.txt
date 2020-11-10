yaCIt 2.0

This addon replaces the original monster card (item) tooltips and shows 
additional informations using an own tooltip:
 - mob description taken from the compendium
 - category of the mob (humanoid etc.)
 - where to find the mob (zones)
 - the stat bonus
 - card is owned (or not) and on how many of your chars on the current server 
 - card is a quest reward
 - mob is only available with a dedicated quest active
 - card is not obtainable
 
The new tooltip is shown on any valid position for a card except the gray 
placeholder when a card is object of an action.
The tool also modifies the hidden tooltip used by Advanced Auctionhouse 
to filter the browse list. This make filters on card properties possible. 
A special filter ($notowned) is added to AAH's special filters, requiring AAH 2.7+

yaCIt works correctly with pbInfo.
Support for ExtraTip has been removed because that code has been changed 
and hooking is not possible anymore

If the mouse hovers over a mob that tooltip is expanded with the 
information if the card exists and if it is owned or not.
If the mobs name is known in the cardlist but the current zone is not 
assigned it will added to a global fix list which is saved.

Unfortunately in some cases it is not possible to retrieve the item number
and as result the item must be determined using its name. Because some cards
have identical names it is possible to fetch the wrong item code. This may 
happen on tooltip in mailbox, trade window and auctionhouse (except browse 
list). In case of the monster tooltip the current zone is taken into account
so the chance to fetch the wrong item is significantly lower.

If playing in PvP environments a player pet has the same name as a card the 
current zone may be registered for this card. For all pets card search is 
deactivated. Also I deactivated the tooltip fuction for PvP zones.

The card compendium has been replaced. Just look around and don't forget
the card list's context menu.
Abd there is a summary of the availaable and acquired stat bonuses

Command line:

/ci [help] [cfg] [<any string>]
/yacit [help] [cfg] [<any string>]

no param
  Displays the current status

help
  Display an extended help

cfg
  Displays the configuration dialog

<any string>
  A search on the list of cardnames is executed and any card 
  where all given words are part of the name is listed in the 
  default chat frame as link
  "/ci naga" will list all Naga cards
  "/ci kobold maraud" will list Kobold Marauder and Kobold Marauders' Leader

Thanks to odie2 for the polish translation. This gave me some headache due to language constrains ;)

Thanks to all coders of vyCardInfo (vaily), Zzabur's Compendium (DarkAnge-
Omega) and MonsterCardTooltip (joselucas): I learned much about addon / UI 
programming and especially access to card informations 
A great thanks goes to the programmer of Adv. Auctionhouse for providing 
such a useful tool; a real swiss army knife in that area
And more thanks go to Pyrr for showing how to 'steal' the 3D model into my 
new frame (which is obsolete with the new frame handling in v1.4)
I recycled some of lootomatics templates for my config dialog, 
so thanks to KingDefrost / PetraAreon for designing them

============================================================
Technical informations

The first time the addon is loaded and anytime the addon is loaded after an 
update of RoM's list of cards, the addon needs about 30 sec (on my PC) to 
update the zone associations. You will notice that as prolonged time showing
the loading screen. Please make sure that the client can save the settings 
(e.g. does not crash before logout) otherwise the update will occur again.

Note: On correct load yaCIt should show the following messages in the chat
  yaCIt: 2.0 by Corgrind
  yaCIt: There are 1156 cards in total, you have XX (XX%)
  yaCIt: Use /ci or /yacit [help] for information, [cfg] for config

When I started I had a look at vyCardInfo. Most obvious for that is the 
split of the code files for core and compendium. In the process the complete
code has been redesigned. vyCardInfo acts a little 'brute force' resulting 
in several time waste at runtime; a thing I don't like. Another flaw is the 
way the compendium is replaced; There is something in the event handler 
creating side effects (ESC key not working). 
Here I got the idea from Zzaburs about an alternative to call the compendium

I switched back to using the vyCardInfo way to open the compendium since I 
got a hint how to get the 3D image running (I still hate that ESC does not 
work to close the frame ^^)

That was again changed in v1.4: This version uses a modified version of the
original frame. Finally got rid of that annoying hook into the global update 
loop.

Ideas I got from the other Compendium addos:
vyCardInfo:         All the basics about Lua, UI programming and access to 
                    card informations
MonsterCardTooltip: The idea that strict OO design is possible in Lua and 
                    that you should think a little about memory usage in Lua
                    to get things fast. Also copied the idea to create card
                    links in the chat frame using the slash command
Zzaburs Compendium: The idea to retrieve zone associations from the NPC 
                    search, the tooltip hooks which don't have a related 
                    'GetLink' function, the idea to supply additional infor-
                    mations, and idea to overwrite the original compendium 
                    in worldxml to get some things working
Adv. AuctionHouse:  The reason to not meddle with auctions, since there is 
                    something better out there. And the source for the price history
Lootomatic:         I copied the nice group template for the config dialogs 

There are 3 lists of hardcoded additional information:
  in the file data/yaCItData.lua:
    - The table SpecialProps contains the informations about quest reward, 
      quest related and not obtainable cards. (Simple coding since only one 
      of the 3 properties can be valid for one card)
    - The table MobZones contains zone associations which cannot retrieved 
      using  NPC search. It's also used to suppress invalid results from NPC
      search (value -1) 
    - The table MobNamePatch links additional mob names to several cards. 
      Because the mob names depend on the client language I fetch the names
      from the active language database. That information is only used for 
      the mouseover tooltip on mobs and is onl ydisplayed in the 'hidden info'
      tooltip.

The code filters empty and placeholder names from the card list resulting in
a number of cards less than Zzaburs and vyCardInfo

It is read as 'yet another CardInfo tool' ;)
