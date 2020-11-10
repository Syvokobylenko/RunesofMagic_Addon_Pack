---------------
English Readme:
---------------

Advanced Quest Book is a work in progress project with the aim of bringing you accurate
quest information into your game.

With Advanced Quest Book you can see your quest locations on the world map as well as
lookup the quest information for other quests in the game.

If you are in a party with other player who also use Advanced Quest Book you can see
a list of quests they have by using the share button located on the mini-map. This
option is only available when in a party and Quest Share is enabled.

AQB currently supports the following languages (Officially):
English, German, French, Spanish, Japanese, Korean, Taiwan, and Chinese

Currently, the main goal of Advanced Quest Book is to provide data for the languages
listed above. However, other language can be supported if there is a demand for it.

----------------------------------------------
How the DB for Advanced Quest Book is Created:
----------------------------------------------

I currently hold 3 databases on my local machine using MySQL.

The first database is known as the "Master Database". The Master Database contains all quests
I have completed myself while dumping quest data.

The second database is the "User Submitted Database". This database holds quests that are
submitted by players running Advanced Quest Book.

The last database is usually empty, but is known as the "Release Database" read more below.

I have written an application that automates creating the database that is in LUA used by
Advanced Quest Book. How it works is fairly simple, Each time I update the database, I first
rebuild the Release Database. When the Release Database is rebuilt, all completed quests from
the Master Database are added. Next, I then add submitted data. When doing this, the application
then takes any quests that are completed from the User Submitted Database and adds them to the
Release Database, but it only adds a quest if it does not already exist in the freshly rebuilt
Release Database. Finally, after the rebuild of the Release Database is completed, the data
is then exported into LUA formatting by the application in which I simply delete the old data
from my copy of Advanced Quest Book and then I move the newly created database files from the
export folder into Advanced Quest Book's language folder.

The Release Database is emptied after export is complete this way I am sure only fresh data is
created the next time I update!.

Updating the database only takes roughly 10 seconds. (actually quite a bit faster than that, but
I have never timed it.. I suppose I could write in some timers to check it, but pointless...)

Main point, it is quick, easy, and accurate! The only user error that can happen here is I forget
to copy files from export to AQB :P This allows me more time to code and more time to play!

For help with installing AddOns, please see the forum post here:
http://forum.runesofmagic.com/showthread.php?t=40968

-----------------------------------
Readme: (Translation needed for other languages)
-----------------------------------

ä
