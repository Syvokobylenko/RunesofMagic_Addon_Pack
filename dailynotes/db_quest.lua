-- coding: utf-8

-- Description:
-- typ:  1=collect,2=kill,3=not daily but repeatable,4=gather,5=rest,6=epic; +10=1perday; +20=untested
-- lvl:  quest level
-- rlvl: minimum level to get quest
-- zone: zone-id (see wow-map for example..or GetCurrentWorldMapID() )
-- items: list of [item_id]=required_count
-- giver: list of npc-ids (or single number) where to get the quest
-- taker: npc-id of quest-taker (only required if not equal first giver)
-- rew: reward in {xp,gold,token}
-- mobs: for Kill-Quest  -> list of [mob_id]=mob_count
--       for other Quests-> list of [mob_id]=item_id (item_id is only required if there are multiple items in this quests)
-- preq: required prequisit quest (single number or table)
--
-- please send any suggestions/corrections to: viertelvor12@gmx.net


DailyNotes.DB_Quests ={
--[[ [ Unknown / Unbekannt (-1) ]]
[422343]={typ= 3, lvl= 1, rlvl= 1, zone= -1, items={[204787]= 10}, giver=110789, rew={12,25,0}}, -- Sweet Milk // Süße Milch
[422386]={typ= 3, lvl= 1, rlvl= 1, zone= -1, items={[204795]= 10}, giver=114930, rew={12,25,0}}, -- An Easy Lay? // Eine einfache Aufgabe?
[422549]={typ=25, lvl=40, rlvl=40, zone= -1, items={[542941]=  1,[542942]=  1,[542943]=  1}, giver=113328, rew={16665,1861,10}}, -- Day of Glory // Tag des Ruhms
--[[ ] ]]

--[[ [ Howling Mountains / Heulende Berge (1) ]]
[420466]={typ= 1, lvl= 3, rlvl= 1, zone=  1, items={[201168]= 10}, giver=110583, taker=110482, rew={57,59,10}, mobs={[100052]=  0}}, -- Need More Fungus Stems // Die anhaltende Ausrottung der Fungi
[420467]={typ= 1, lvl= 4, rlvl= 2, zone=  1, items={[201169]= 10}, giver=110583, taker=110482, rew={79,94,10}, mobs={[100054]=  0}}, -- Control the Wolf Population // Verringerung des Jungwolf-Nachwuchses
[420417]={typ= 1, lvl= 7, rlvl= 5, zone=  1, items={[200616]=  5}, giver=110584, taker=110051, rew={132,192,10}, mobs={[100118]=  0}}, -- Spider Venom // Spinnengift
[420435]={typ= 2, lvl= 7, rlvl= 5, zone=  1, mobs={[100146]= 20}, giver=110584, taker=110078, rew={132,192,10}}, -- Annoying Beetles // Lästige Käfer
[420457]={typ= 1, lvl= 7, rlvl= 5, zone=  1, items={[201173]= 10}, giver=110583, taker=110482, rew={132,192,10}, mobs={[100458]=  0}}, -- Reduce the Cave Crab Population // Reduzierung der Rotscheren-Höhlenkrebspopulation
[420419]={typ= 2, lvl= 8, rlvl= 6, zone=  1, mobs={[100156]= 20}, giver=110584, taker=110078, rew={171,222,10}}, -- Drive Off the Bats // Vertreibt die Fledermäuse
[420420]={typ= 2, lvl= 9, rlvl= 7, zone=  1, mobs={[100203]= 20}, giver=110584, taker=110078, rew={212,250,10}}, -- The Kobold Rampage // Raserei der Kobolde
[420059]={typ= 1, lvl=10, rlvl= 7, zone=  1, items={[200619]= 10}, giver=110584, taker=110078, rew={292,302,10}, mobs={[100053]=  0,[100152]=  0,[100153]=  0,[100203]=  0}}, -- Stolen Tools // Die gestohlenen Werkzeuge
[420111]={typ= 2, lvl=10, rlvl= 8, zone=  1, mobs={[100055]= 20}, giver=110584, taker=110078, rew={292,302,10}}, -- Starving Wolves // Die hungrigen Wölfe
[420112]={typ= 1, lvl=10, rlvl= 8, zone=  1, items={[200624]=  5}, giver=110584, taker=110052, rew={292,302,10}, mobs={[100061]=  0}}, -- Collect Boar Tusks // Keiler-Hauer sammeln
[420129]={typ= 1, lvl=10, rlvl= 8, zone=  1, items={[200609]=  5}, giver=110584, taker=110497, rew={292,302,10}, mobs={[100056]=  0,[100063]=  0}}, -- Sharp Bear Claw // Scharfe Bärenklauen
[421347]={typ= 1, lvl=10, rlvl= 7, zone=  1, items={[200188]=  1}, giver=110584, taker=110078, rew={585,604,10}, mobs={[100905]=  1}}, -- Wanted: The Ravenous Kalod // Gesucht: Gefräßiger Kalod
[421448]={typ= 1, lvl=10, rlvl= 7, zone=  1, items={[200203]=  1}, giver=110584, taker=110060, rew={585,604,10}, mobs={[100904]=  1}}, -- Wanted: Pirlanok Servant // Gesucht: Pirlanok-Diener
[421449]={typ= 1, lvl=10, rlvl= 7, zone=  1, items={[200211]=  1}, giver=110584, taker=110491, rew={585,604,10}, mobs={[100906]=  1}}, -- Wanted: Lost Soul of Tifka // Gesucht: Verlorene Seele von Tifka
--[[ ] ]]

--[[ [ Silverspring / Silberquell (2) ]]
[420233]={typ= 1, lvl=10, rlvl= 8, zone=  2, items={[201109]= 10}, giver={110585,110969}, taker=110022, rew={292,302,10}, mobs={[100132]=  0,[100280]=  0}}, -- Beetle Legs // Käferbeine
[420234]={typ= 1, lvl=10, rlvl= 8, zone=  2, items={[201110]= 10}, giver={110585,110969}, taker=110020, rew={292,302,10}, mobs={[100294]=  0,[100819]=  0}}, -- Shabby Shoes // Abgetragene Schuhe
[420229]={typ= 1, lvl=11, rlvl= 9, zone=  2, items={[201108]= 10}, giver={110585,110969}, taker=110611, rew={378,384,10}, mobs={[100212]=  0,[100397]=  0}}, -- Stable Request // Anfrage aus den Ställen
[420264]={typ= 1, lvl=12, rlvl=10, zone=  2, items={[201111]= 10}, giver={110585,110969}, taker=110210, rew={442,422,10}, mobs={[100082]=  0,[100083]=  0}}, -- Disease Cure // Heilung der Krankheit
[420612]={typ= 1, lvl=17, rlvl=14, zone=  2, items={[200406]=  9}, giver={110585,110969}, taker=110067, rew={800,662,10}, mobs={[100297]=  0}}, -- Bat Saliva // Fledermausspeichel
[420290]={typ= 1, lvl=18, rlvl=16, zone=  2, items={[201113]= 12}, giver={110585,110969}, taker=110021, rew={942,762,10}, mobs={[100195]=  0,[100210]=  0}}, -- Bird Feather Jewelry // Vogelfederschmuck
[420218]={typ= 1, lvl=19, rlvl=17, zone=  2, items={[200670]= 10}, giver={110585,110969}, taker=110173, rew={1101,858,10}, mobs={[100195]=  0,[100210]=  0}}, -- Chef's Worries // Sorgen des Kochs
[420284]={typ= 1, lvl=19, rlvl=17, zone=  2, items={[201112]= 10}, giver={110585,110969}, taker=110021, rew={1101,858,10}, mobs={[100064]=  0,[100065]=  0}}, -- An Ancient Inheritance // Ein uraltes Erbe
--[[ ] ]]

--[[ [ Ravenfell / Rabenfeld (3) ]]
[420450]={typ= 2, lvl=46, rlvl=45, zone=  3, mobs={[101566]=  6,[101567]=  6,[101573]=  6}, giver=112262, taker=112233, rew={41888,2067,10}, preq=421807}, -- If The Road Won't Turn, Change Your Path // Ändert Euren Weg, wenn die Straße nicht abzweigt ...
[420451]={typ=14, lvl=46, rlvl=45, zone=  3, items={[203645]= 10}, giver=112262, taker=112140, rew={41888,2067,10}, preq=421751}, -- Silent Concern // Stilles Gedenken
[420618]={typ=14, lvl=46, rlvl=45, zone=  3, items={[203620]= 10}, giver=112262, taker=112126, rew={41888,2067,10}, preq=421691}, -- Is it so Tasty? // Ist das so schmackhaft?
[420622]={typ= 1, lvl=46, rlvl=45, zone=  3, items={[202005]= 10}, giver=112262, taker=112198, rew={41888,2067,10}, mobs={[101571]=  0}}, -- Folk Medicine Prescription // Naturmedizin
[420453]={typ=12, lvl=47, rlvl=46, zone=  3, mobs={[101583]= 10}, giver=112264, rew={44207,2106,10}}, -- They Deserve It // Sie haben es verdient!
[420454]={typ= 1, lvl=47, rlvl=46, zone=  3, items={[201994]= 10}, giver=112262, taker=112240, rew={44207,2106,10}, mobs={[100334]=  0,[100335]=  0,[100336]=  0}}, -- Steal Anything // Alles geklaut
[420455]={typ= 1, lvl=47, rlvl=46, zone=  3, items={[201995]= 10}, giver=112262, taker=112155, rew={44207,2106,10}, mobs={[100343]=  0,[101578]=  0}, preq=421722}, -- Cosmetic Materials // Kosmetik
[420456]={typ= 1, lvl=47, rlvl=46, zone=  3, items={[201996]= 10}, giver=112262, taker=112125, rew={44207,2106,10}, mobs={[100595]=  0}, preq=421700}, -- Peculiar Eating Habits // Merkwürdige Essgewohnheiten
[420615]={typ= 1, lvl=47, rlvl=46, zone=  3, items={[201997]= 10}, giver=112262, taker=112149, rew={44207,2106,10}, mobs={[100328]=  0}}, -- Hard on the Outside, Soft on the Inside // Harte Schale, weicher Kern
[420623]={typ= 1, lvl=47, rlvl=46, zone=  3, items={[202011]= 10}, giver=112262, taker=112198, rew={44207,2106,10}, mobs={[100573]=  0}}, -- Equipment Cleaner // Ausrüstungsreinigung
[420452]={typ=11, lvl=48, rlvl=47, zone=  3, items={[201993]=  5}, giver=112264, rew={46498,2198,10}}, -- Powerless // Machtlos
[420616]={typ= 4, lvl=48, rlvl=47, zone=  3, items={[201998]=  5}, giver=112262, taker=112192, rew={46498,2198,10}}, -- Pirate Superstition // Piraten-Aberglaube
[420619]={typ=21, lvl=48, rlvl=47, zone=  3, items={[202002]=  5,[203709]=  5}, giver=112262, taker=112267, rew={46498,2198,10}, preq=421796}, -- Ailic's Community // Ailics Gemeinschaft
[420617]={typ= 1, lvl=50, rlvl=47, zone=  3, items={[201999]= 10}, giver=112262, taker=112158, rew={79832,2249,10}, mobs={[100341]=  0}}, -- Unforgettably Delicious // Unvergesslich köstlich
--[[ ] ]]

--[[ [ Aslan Valley / Aslan-Tal (4) ]]
[420599]={typ= 1, lvl=20, rlvl=18, zone=  4, items={[201256]=  6}, giver=110711, taker=110036, rew={1502,975,10}, mobs={[100601]=  0}}, -- Continuing Research // Weitere Forschungen
[420598]={typ= 1, lvl=21, rlvl=19, zone=  4, items={[201267]=  8}, giver=110711, taker=110036, rew={1959,1005,10}}, -- Material Gathering // Materialsammlung
[420424]={typ= 1, lvl=22, rlvl=20, zone=  4, items={[201119]= 10}, giver=110711, taker=110691, rew={2256,1082,10}, mobs={[100087]=  0,[100088]=  0,[100089]=  0,[100094]=  0}}, -- Enduring Armor // Beständige Rüstung
[420425]={typ= 1, lvl=22, rlvl=20, zone=  4, items={[201120]= 10}, giver=110711, taker=110724, rew={2256,1082,10}, mobs={[100222]=  0,[100223]=  0,[100224]=  0}}, -- Ent's Dead Branches // Abgestorbene Äste eines Ents
[420600]={typ= 1, lvl=22, rlvl=20, zone=  4, items={[201258]= 10}, giver=110711, taker=110716, rew={2256,1082,10}, mobs={[100571]=  0}}, -- Another Type of Meat! // Eine weitere Fleischsorte!
[420427]={typ= 1, lvl=23, rlvl=21, zone=  4, items={[201122]=  5}, giver=110711, taker=110035, rew={2641,1098,10}}, -- Report after report // Ein Bericht nach dem anderen
[420428]={typ= 1, lvl=26, rlvl=24, zone=  4, items={[201266]=  6}, giver=110711, taker=110033, rew={3863,1288,10}, mobs={[100090]=  0,[100091]=  0,[100099]=  0}}, -- Weird Wild Boar // Seltsamer wilder Keiler
[420426]={typ= 1, lvl=27, rlvl=24, zone=  4, items={[201121]= 10}, giver=110711, taker=110036, rew={4325,1377,10}, mobs={[100229]=  0,[100230]=  0}}, -- Demon Vine // Dämonenranken
[420601]={typ= 1, lvl=28, rlvl=26, zone=  4, items={[201259]=  5,[201260]=  5}, giver=110711, taker=110035, rew={4890,1408,10}, mobs={[100226]= 201259,[100227]= 201260}}, -- Animal Control // Kontrolle des Tierbestands
--[[ ] ]]

--[[ [ Dust Devil Canyon / Staubteufel-Canyon (6) ]]
[420444]={typ= 1, lvl=40, rlvl=40, zone=  6, items={[201126]= 15}, giver=110806, taker=110841, rew={33331,1861,10}, mobs={[100439]=  0,[100444]=  0}}, -- Scorpion // Skorpion
[420446]={typ= 1, lvl=40, rlvl=40, zone=  6, items={[201127]= 15}, giver=110806, taker=110836, rew={33331,1861,10}, mobs={[100445]=  0}}, -- Ancient Magical Medicine // Alte magische Medizin
[420795]={typ= 1, lvl=40, rlvl=40, zone=  6, items={[201432]= 15}, giver=110806, taker=110839, rew={33331,1861,10}, mobs={[100658]=  0}}, -- Cactus Fruit // Kaktusfrucht
[420796]={typ= 1, lvl=40, rlvl=40, zone=  6, items={[201433]= 15}, giver=110806, taker=110839, rew={33331,1861,10}, mobs={[100659]=  0}}, -- Cactus Flower // Kaktusblüte
[420797]={typ= 1, lvl=40, rlvl=40, zone=  6, items={[201434]= 15}, giver=110806, taker=110839, rew={33331,1861,10}, mobs={[100660]=  0}}, -- Cactus Thorn // Kaktusstachel
[420791]={typ= 1, lvl=42, rlvl=40, zone=  6, items={[201429]= 15}, giver=110806, taker=110847, rew={38260,1926,10}, mobs={[100427]=  0}}, -- Heat-Powered Battle Drug // Wärme als Waffe
[420792]={typ= 1, lvl=42, rlvl=40, zone=  6, items={[201430]= 15}, giver=110806, taker=110325, rew={38260,1926,10}, mobs={[100426]=  0}}, -- Lack of Fuel // Brennstoffmangel
[420794]={typ= 1, lvl=42, rlvl=40, zone=  6, items={[204355]= 20}, giver=110806, taker=110344, rew={38260,1926,10}, mobs={[100665]=  0}}, -- Protecting Fun // Spaß muss sein
[420788]={typ= 1, lvl=43, rlvl=40, zone=  6, items={[201427]= 15}, giver=110806, taker=110901, rew={40772,1958,10}, mobs={[100440]=  0}}, -- Never Too Late to Mend // Alles noch zu retten
[420789]={typ= 1, lvl=43, rlvl=40, zone=  6, items={[201428]= 25}, giver=110806, taker=110898, rew={40772,1958,10}, mobs={[100441]=  0}}, -- Highly Efficient Investment // Lohnende Investition
[420787]={typ= 1, lvl=44, rlvl=42, zone=  6, items={[201426]= 15}, giver=110806, taker=110827, rew={45248,1991,10}, mobs={[100422]=  0}}, -- High Quality Meat Stew // Hochwertiger Fleischeintopf
[420793]={typ= 1, lvl=45, rlvl=40, zone=  6, items={[201431]= 30}, giver=110806, taker=110939, rew={51754,1996,10}, mobs={[100447]=  0,[100448]=  0,[100449]=  0}}, -- Smuggling Businessman // Schmuggelnder Geschäftsmann
[420790]={typ= 1, lvl=47, rlvl=43, zone=  6, items={[204354]= 20}, giver=110806, taker=110835, rew={58943,2106,10}, mobs={[100434]=  0}}, -- A Nightmare // Ein Albtraum
--[[ ] ]]

--[[ [ Weeping Coast / Küste der Wehklagen (7) ]]
[422229]={typ= 1, lvl=50, rlvl=48, zone=  7, items={[204437]= 10}, giver=112610, rew={90476,2249,10}, mobs={[101779]=  0}}, -- Selling Like Hot Cakes // Das geht wie geschnitten Brot
[422238]={typ= 1, lvl=50, rlvl=48, zone=  7, items={[204446]= 10}, giver=112680, taker=112603, rew={79832,2249,10}, mobs={[101856]=  0}}, -- Trade Relations // Handelsbeziehungen
[422225]={typ= 1, lvl=51, rlvl=49, zone=  7, items={[204448]= 10}, giver=112510, rew={85420,2251,10}, mobs={[101854]=  0}, preq=422055}, -- When Vengeance is the Only Road // Wenn Rache der einzige Weg ist
[422226]={typ= 1, lvl=51, rlvl=49, zone=  7, items={[204434]= 10}, giver=112680, taker=112609, rew={85420,2251,10}, mobs={[101739]=  0}}, -- Hardworking Sous Chef // Hart arbeitender Küchenmeister
[422227]={typ= 1, lvl=51, rlvl=49, zone=  7, items={[204435]= 10}, giver=112680, taker=112624, rew={85420,2251,10}, mobs={[101738]=  0}}, -- Tasty Cuisine // Köstliche Küche
[422228]={typ= 1, lvl=51, rlvl=49, zone=  7, items={[204436]= 10}, giver=112623, rew={96809,2251,10}, mobs={[101776]=  0}}, -- Fresh Bait // Frische Köder
[422230]={typ= 1, lvl=51, rlvl=49, zone=  7, items={[204438]= 10}, giver=112611, rew={85420,2251,10}, mobs={[101747]=  0}}, -- Fighting Fire with Fire // Feuer mit Feuer bekämpfen
[422231]={typ= 1, lvl=51, rlvl=49, zone=  7, items={[204439]= 10}, giver=112516, rew={85420,2251,10}, mobs={[101777]=  0}}, -- Supply Officer's Angst // Die Angst des Nachschuboffiziers
[422232]={typ= 1, lvl=51, rlvl=49, zone=  7, items={[204440]= 10}, giver=112680, taker=112612, rew={85420,2251,10}, mobs={[101780]=  0}}, -- Wings to Fly // Flügel zum Fliegen
[422233]={typ= 1, lvl=52, rlvl=49, zone=  7, items={[204441]= 10}, giver=112680, taker=112605, rew={91399,2265,10}, mobs={[101794]=  0}}, -- Handicraft Supplies // Handwerkermaterial
[422234]={typ= 1, lvl=52, rlvl=49, zone=  7, items={[204442]= 10}, giver=112615, rew={103586,2265,10}, mobs={[101786]=  0}}, -- Lovely Leathers // Liebliches Leder
[422235]={typ= 1, lvl=52, rlvl=50, zone=  7, items={[204443]= 10}, giver=112615, rew={103586,2265,10}, mobs={[101792]=  0}}, -- Giant Wolf Claws // Riesenwolfkrallen
[422236]={typ= 1, lvl=52, rlvl=50, zone=  7, items={[204444]= 10}, giver=112616, rew={103586,2265,10}, mobs={[101760]=  0,[101761]=  0,[101762]=  0,[101763]=  0}}, -- A Difficult Mission // Eine schwere Mission
[422237]={typ= 1, lvl=52, rlvl=50, zone=  7, items={[204445]= 10}, giver=112615, rew={103586,2265,10}, mobs={[101735]=  0,[101753]=  0}}, -- Bunga Beastology // Bungabestien-Forschung
[422831]={typ= 2, lvl=53, rlvl=51, zone=  7, items={[206015]=  1}, taker=112533, rew={110836,2291,10}, mobs={[101772]=  1}}, -- Proof of Defeating the Commander // Beweis des Sieges über den Kommandanten
--[[ ] ]]

--[[ [ Savage Lands / Wilde Lande (8) ]]
[422608]={typ= 1, lvl=53, rlvl=51, zone=  8, items={[205661]= 12}, giver=113178, rew={110836,2291,10}, mobs={[102259]=  0}, preq=422453}, -- Deer Leg Provisions // Hirschbein-Vorräte
[422609]={typ= 1, lvl=53, rlvl=51, zone=  8, items={[205667]= 15}, giver=113177, rew={110836,2291,10}, mobs={[102248]=  0,[102250]=  0,[102251]=  0,[102252]=  0}}, -- Trap Parts // Fallenkomponenten
[422610]={typ= 1, lvl=53, rlvl=51, zone=  8, items={[205662]= 12}, giver=113177, rew={97797,2291,10}, mobs={[102211]=  0}, preq=422440}, -- Frozen Crystal Ore // Wiederverwertetes Kristallerz
[422611]={typ= 1, lvl=53, rlvl=51, zone=  8, items={[205666]= 12}, giver=113278, rew={110836,2291,10}, mobs={[102217]=  0}, preq=422560}, -- Great Ape Wound Hair // Das Wundenhaar der Riesenaffen
[422614]={typ= 1, lvl=53, rlvl=51, zone=  8, items={[205663]= 15}, giver=113180, rew={110836,2291,10}, mobs={[102245]=  0,[102246]=  0,[102247]=  0}, preq=422448}, -- Ruin Guardian Energy Source // Die Energiequelle der Ruinenhüter
[422612]={typ= 2, lvl=54, rlvl=52, zone=  8, mobs={[102275]= 15}, giver=113325, rew={113052,2272,10}}, -- Fear of Shadows // Angst vor dem Schatten
[422613]={typ= 1, lvl=54, rlvl=52, zone=  8, items={[205668]= 12}, giver=113325, rew={113052,2272,10}, mobs={[102256]=  0}}, -- Beautiful Poisonous Mandibles // Wunderschöne Giftzähne
[422617]={typ= 1, lvl=54, rlvl=52, zone=  8, items={[205665]= 12}, giver=113170, rew={113052,2272,10}, mobs={[102249]=  0}}, -- Ooze Fertilizer // Düngschlamm
[422615]={typ= 2, lvl=56, rlvl=54, zone=  8, mobs={[102263]= 15}, giver=113326, rew={117619,2331,10}}, -- Kaa Marchers Must Die // Tod den Mitgliedern der Kaa-Expedition!
[422616]={typ= 1, lvl=56, rlvl=54, zone=  8, items={[205664]= 12}, giver=113326, rew={117619,2331,10}, mobs={[102265]=  0}}, -- Glory and Dishonor // Ruhm und Ehrlosigkeit
--[[ ] ]]

--[[ [ Aotulia Volcano / Aotulia-Vulkan (9) ]]
[422618]={typ= 1, lvl=55, rlvl=53, zone=  9, items={[205954]= 10}, giver={113475,113482}, rew={115313,2284,10}, mobs={[102494]=  0}}, -- Plunder Research Data // Forschungsdaten plündern
[422619]={typ= 4, lvl=55, rlvl=53, zone=  9, items={[205727]= 20}, giver=113476, rew={115313,2284,10}}, -- Volcanic Mud Skin Balm // Hautbalsam aus vulkanischem Schlamm
[422620]={typ= 1, lvl=55, rlvl=53, zone=  9, items={[205833]= 10}, giver=113477, rew={115313,2284,10}, mobs={[102495]=  0}}, -- Claw of Death // Klaue des Todes
[422621]={typ= 2, lvl=55, rlvl=53, zone=  9, mobs={[102498]= 12}, giver=113478, rew={115313,2284,10}}, -- Killing the Hunter // Den Jäger töten
[422662]={typ= 1, lvl=55, rlvl=53, zone=  9, items={[205915]=  5}, giver=113481, rew={115313,2284,10}, mobs={[102542]=  0}}, -- Giant Caterpillar Steaks // Riesenraupen-Steaks
[422622]={typ=21, lvl=56, rlvl=54, zone=  9, items={[205834]=  7}, giver=113479, rew={117619,2331,10}, mobs={[102543]=  0}}, -- Flame Feathers // Flammenfedern
[422661]={typ=22, lvl=56, rlvl=54, zone=  9, mobs={[102518]=  6,[102519]=  6,[102520]=  6}, giver=113500, rew={117619,2331,10}}, -- Lava Goblin Armageddon // Schlacht gegen die Lava-Goblins
[422663]={typ=31, lvl=56, rlvl=54, zone=  9, items={[205916]=  1}, giver=113482, rew={117619,2331,15}, mobs={[102511]=  0}}, -- The Study of Demon Soldiers' Weak Points // Erforschung der Schwachpunkte der Dämonensoldaten
[422664]={typ=21, lvl=56, rlvl=54, zone=  9, items={[205917]= 10}, giver=113483, rew={117619,2331,10}, mobs={[102535]=  0}}, -- Fever and Bristles // Fieber und Borsten
[422665]={typ=21, lvl=56, rlvl=54, zone=  9, items={[205918]= 10}, taker=113480, rew={117619,2331,10}}, -- Plundering Supplies // Vorräte plündern
--[[ ] ]]

--[[ [ Sascilia Steppes / Sascilia-Steppe (10) ]]
[420562]={typ= 2, lvl= 1, rlvl= 1, zone= 10, mobs={[100804]= 10}, giver=111382, taker=111034, rew={18,25,10}}, -- Peace in the Camp // Frieden im Lager
[420563]={typ= 1, lvl= 3, rlvl= 1, zone= 10, items={[202969]= 12}, giver=111382, taker=111045, rew={57,59,10}, mobs={[100750]=  0}}, -- Bargain Purchase // Ein günstiges Angebot
[420564]={typ= 1, lvl= 5, rlvl= 3, zone= 10, items={[202970]= 10}, giver=111382, taker=111082, rew={93,130,10}, mobs={[100740]=  0}}, -- The Business of Poison // Giftgeschäfte
[420565]={typ= 2, lvl= 7, rlvl= 5, zone= 10, mobs={[100752]= 10}, giver=111383, taker=111082, rew={132,192,10}}, -- Increase Production Volume // Ertragssteigerung
[420566]={typ= 1, lvl= 7, rlvl= 5, zone= 10, items={[202971]=  8}, giver=111383, taker=111384, rew={132,192,10}, mobs={[100741]=  0}}, -- Preservation Act // Konservierungsmethode
[420567]={typ= 2, lvl= 9, rlvl= 7, zone= 10, mobs={[100820]= 10}, giver=111587, rew={212,250,10}}, -- Crawlers // Kriecher
[420568]={typ= 2, lvl= 9, rlvl= 7, zone= 10, mobs={[100771]= 10}, giver=111587, rew={212,250,10}}, -- Flyers // Flieger
[420569]={typ= 2, lvl= 9, rlvl= 7, zone= 10, mobs={[100755]= 10}, giver=111088, rew={212,250,10}, preq=421102}, -- Savage Revenge // Zeigt keine Gnade
[420085]={typ= 4, lvl=10, rlvl= 9, zone= 10, items={[202974]= 15}, giver=111385, taker=111056, rew={292,302,10}}, -- Ancient Stone Tablets // Alte Steintafeln
[420570]={typ= 1, lvl=16, rlvl=13, zone= 10, items={[202975]= 10}, giver=111386, taker=111022, rew={732,585,10}, mobs={[100747]=  0}}, -- Refreshing the Mind // Erfrischung für den Geist
[420571]={typ= 1, lvl=16, rlvl=13, zone= 10, items={[202976]= 10}, giver=111386, taker=111022, rew={732,585,10}, mobs={[100766]=  0,[100768]=  0}}, -- Ancient Energy Cores // Antike Energiekerne
[420573]={typ= 1, lvl=16, rlvl=14, zone= 10, items={[202978]= 10}, giver=111387, taker=111388, rew={732,585,10}, mobs={[100004]=  0}}, -- Art Materials // Kunstmaterialien
[420572]={typ= 1, lvl=17, rlvl=15, zone= 10, items={[202977]= 10}, giver=111387, taker=111388, rew={800,662,10}, mobs={[100753]=  0}}, -- Beautify Art // Farbe für das Kunstwerk
[420574]={typ= 1, lvl=18, rlvl=16, zone= 10, items={[202979]= 10}, giver=111387, taker=111388, rew={942,762,10}, mobs={[100775]=  0}}, -- Artistic Decoration // Künstlerische Dekoration
[422959]={typ= 3, lvl=23, rlvl=21, zone= 10, items={[206422]=  5}, giver=113689, rew={2641,1647,0}, preq=422958}, -- Gather Stone Totem Fragments // Sammelt Steintotemfragmente
--[[ ] ]]

--[[ [ Dragonfang Ridge / Drachenzahngebirge (11) ]]
[421615]={typ= 1, lvl=21, rlvl=19, zone= 11, items={[203344]= 10}, giver=111640, taker=111122, rew={1959,1005,10}, mobs={[100822]=  0}}, -- Tusk Research // Hauer-Forschung
[421616]={typ= 1, lvl=22, rlvl=20, zone= 11, items={[203345]= 10}, giver=111640, taker=111163, rew={2256,1082,10}, mobs={[100824]=  0}}, -- Bear Paw Stew // Bärenprankeneintopf
[421617]={typ= 1, lvl=23, rlvl=21, zone= 11, items={[203346]= 10}, giver=111640, taker=111162, rew={2641,1098,10}, mobs={[100825]=  0}}, -- Warm Clothing // Warme Kleidung
[421619]={typ= 1, lvl=24, rlvl=21, zone= 11, items={[203348]= 10}, giver=111296, rew={3092,1109,10}, mobs={[100827]=  0}}, -- Valuable Pearls // Wertvolle Perlen
[421618]={typ= 1, lvl=25, rlvl=23, zone= 11, items={[203347]= 10}, giver=111296, rew={3469,1241,10}, mobs={[100828]=  0,[101006]=  0}}, -- The Amulet of Fortune // Das Amulett des Schicksals
[421620]={typ= 1, lvl=27, rlvl=25, zone= 11, items={[203349]= 10}, giver=111296, rew={4325,1377,10}, mobs={[100831]=  0,[100832]=  0,[100833]=  0,[100838]=  0,[101245]=  0}}, -- Special Bracelets // Besondere Armreifen
[421621]={typ= 1, lvl=28, rlvl=26, zone= 11, items={[203350]= 10}, giver=111296, rew={4890,1408,10}, mobs={[100739]=  0,[100742]=  0,[100841]=  0,[100843]=  0,[100844]=  0}}, -- Mysterious Necklaces // Geheimnisvolle Halskette
[421622]={typ= 1, lvl=30, rlvl=28, zone= 11, items={[203351]= 10}, giver=111296, rew={5941,1536,10}, mobs={[100848]=  0,[100849]=  0,[100852]=  0,[100853]=  0}}, -- Gnoll's Stones // Gnollsteine
[421623]={typ= 1, lvl=32, rlvl=30, zone= 11, items={[203360]= 10}, giver=111730, taker=111729, rew={7166,1601,10}, mobs={[100865]=  0}}, -- The Origin of the Bizarre Scent // Die Quelle des absonderlichen Geruchs
[421624]={typ= 1, lvl=33, rlvl=31, zone= 11, items={[203359]= 10}, giver=111730, taker=111607, rew={8048,1633,10}, mobs={[100872]=  0}}, -- A Horn's Uses // Verwendungsarten eines Horns
[421625]={typ= 1, lvl=33, rlvl=30, zone= 11, items={[203353]= 10}, giver=111730, taker=111211, rew={8048,1633,10}, mobs={[100862]=  0}}, -- Shana's Sweet Spot // Shanas Schwäche
[421627]={typ= 1, lvl=33, rlvl=31, zone= 11, items={[203361]= 10}, giver=111730, taker=111300, rew={8048,1633,10}, mobs={[100857]=  0}}, -- Revive the Economy! // Wirtschaftsaufschwung
[421626]={typ= 1, lvl=34, rlvl=31, zone= 11, items={[203352]= 10}, giver=111730, taker=111170, rew={10174,1666,10}, mobs={[100859]=  0,[100860]=  0,[100861]=  0}}, -- Product Development // Produktforschung und -entwicklung
--[[ ] ]]

--[[ [ Elven Island / Elfeninsel (12) ]]
[422030]={typ= 1, lvl= 4, rlvl= 2, zone= 12, items={[204834]=  5}, giver=112847, rew={79,94,10}, preq=422263}, -- Alchemy Trouble // Alchemie-Probleme
[422221]={typ= 1, lvl= 4, rlvl= 2, zone= 12, items={[204836]=  1}, giver=112950, taker=112860, rew={79,94,10}, preq=422263}, -- Save Plant Seeds // Rettet Pflanzensamen
[422339]={typ= 4, lvl= 4, rlvl= 2, zone= 12, items={[204842]=  1,[204843]=  1,[204844]=  1}, giver=112950, taker=112868, rew={79,94,10}, preq=422263}, -- Where the Hell are They? // Wo zum Henker sind sie nur?
[422340]={typ= 4, lvl= 4, rlvl= 2, zone= 12, items={[204840]=  1}, giver=112794, rew={79,94,10}, preq=422263}, -- Helping Them Grow // Wachstumshilfe
[422344]={typ= 4, lvl= 4, rlvl= 2, zone= 12, items={[204841]= 10}, giver=112950, taker=112846, rew={79,94,10}, preq=422263}, -- Transcendence Beach // Strand der Transzendenz
[422338]={typ= 2, lvl= 5, rlvl= 3, zone= 12, mobs={[101933]= 10}, giver=112950, taker=112844, rew={93,130,10}, preq=422263}, -- Spore Mage's Peculiarity // Die Eigentümlichkeiten des Sporenmeisters
[422239]={typ= 4, lvl= 6, rlvl= 4, zone= 12, items={[204623]=  5,[204671]=  5}, giver=112950, taker=112968, rew={112,166,10}, preq={422263,422304,422293,422335}}, -- Poison Mushrooms // Giftpilze
[422240]={typ= 1, lvl= 7, rlvl= 5, zone= 12, items={[204837]=  5,[204838]=  5}, giver=112950, taker=112965, rew={132,192,10}, preq=422263}, -- Special Flowers // Besondere Blumen
[422219]={typ= 1, lvl= 8, rlvl= 6, zone= 12, items={[204835]=  1}, giver=112950, taker=112965, rew={171,222,10}, preq=422263}, -- Those Bears Again! // Schon wieder diese Bären!
[422341]={typ= 4, lvl= 8, rlvl= 6, zone= 12, items={[204644]=  1,[204645]=  5}, giver=112886, rew={171,222,10}, preq={422300,422263}}, -- Even More Sabinean Food Samples // Noch mehr Nahrungsproben der Sabineaner
--[[ ] ]]

--[[ [ Coast of Opportunity / Küste der Gelegenheit (13) ]]
[423775]={typ=21, lvl= 3, rlvl= 1, zone= 13, items={[208979]=  3,[208980]=  3}, giver=117379, rew={207,89,10}, mobs={[105390]= 208979,[117282]= 208980}}, -- The New Land's Delicious Food // Das köstliche Essen des Neuen Landes
[423772]={typ=21, lvl= 4, rlvl= 2, zone= 13, items={[208981]=  5}, giver=117380, rew={296,141,10}}, -- My Skin Is Suffering // Meine Haut leidet
[423776]={typ=25, lvl= 5, rlvl= 3, zone= 13, mobs={[117546]=  3}, giver=117410, rew={322,195,10}}, -- Earn a Reputation // Sich einen Ruf erarbeiten
[423953]={typ= 6, lvl= 7, rlvl= 5, zone= 13, giver=117420, rew={141,154,0}}, -- Invaders from the Sea // Meeresinvasoren
[423902]={typ=21, lvl= 9, rlvl= 7, zone= 13, items={[208984]=  6}, giver=117378, rew={707,375,10}}, -- Even The Kulang Are Bullies! // Selbst die Kulangs sind Rabauken!
[423931]={typ=22, lvl=10, rlvl= 8, zone= 13, mobs={[105141]= 10}, giver=117386, rew={975,453,10}}, -- Heroic Defense // Heldenhafte Verteidigung
[423929]={typ=21, lvl=11, rlvl= 9, zone= 13, items={[208982]=  5}, giver=117381, rew={1260,576,10}}, -- Crustacean Research Assistance // Hilfe bei der Schalentierforschung
[423826]={typ= 1, lvl=13, rlvl=11, zone= 13, items={[208985]= 10}, giver=117383, rew={1592,663,10}}, -- Even Heat Needed // Gleichmäßige Temperatur benötigt
[423930]={typ= 1, lvl=13, rlvl=11, zone= 13, items={[208986]=  5}, giver=117378, rew={1592,663,10}, mobs={[105145]=  0}}, -- Garbage Can't Be Recycled // Müll kann nicht wiederverwertet werden.
[423932]={typ= 1, lvl=16, rlvl=14, zone= 13, items={[209081]= 10}, giver=117384, rew={2440,878,10}, mobs={[105151]=  0}}, -- Big Fish Eat Big Worms // Große Fische fressen große Würmer
[423933]={typ=22, lvl=18, rlvl=16, zone= 13, mobs={[105287]=  5,[117387]=  1}, giver=117388, rew={3142,1143,10}}, -- Dismantle the Traps // Fallen abbauen
[423934]={typ=21, lvl=18, rlvl=16, zone= 13, items={[209005]=  5}, giver=117497, rew={3142,1143,10}, preq=423798}, -- Taste of Home // Der Geschmack von Heimat
[423935]={typ= 1, lvl=21, rlvl=19, zone= 13, items={[209006]= 10}, giver=117519, rew={6532,1508,10}, mobs={[105153]=  0}}, -- Don't Eat Gazelle Meat for Now // Esst jetzt kein Gazellenfleisch
[423937]={typ=21, lvl=24, rlvl=22, zone= 13, items={[209007]= 10}, giver=115399, rew={10307,1664,10}}, -- A Tortoise Strong on the Inside // Eine Schildkröte von innerer Stärke
[423936]={typ=21, lvl=25, rlvl=23, zone= 13, items={[208996]= 10}, giver=117586, rew={11565,1862,10}}, -- Perfectly Matched Spices // Perfekt harmonierende Gewürze
[423938]={typ=21, lvl=25, rlvl=23, zone= 13, items={[209008]= 10}, giver=117523, rew={11565,1862,10}}, -- Simple Self-Defense Tool // Einfaches Mittel zur Selbstverteidigung
[423940]={typ=21, lvl=26, rlvl=24, zone= 13, items={[209100]= 10}, giver=118014, rew={12877,1932,10}, mobs={[117513]=  0}}, -- Sacred Soil // Heilige Erde
[423966]={typ=26, lvl=27, rlvl=25, zone= 13, giver=117495, rew={4613,1377,0}}, -- Attack of the Raging Snakes // Angriff der rasenden Schlangen
[423939]={typ=21, lvl=28, rlvl=26, zone= 13, items={[209060]=  5,[209061]=  5}, giver=117587, rew={16302,2112,10}}, -- Beautiful Jewelry // Herrlicher Schmuck
[423941]={typ=21, lvl=28, rlvl=26, zone= 13, items={[209062]= 10}, giver=117521, rew={16302,2112,10}}, -- Leather of \"Weighty\" Importance // \"Gewichtiges\" Leder
[423942]={typ=21, lvl=29, rlvl=27, zone= 13, items={[209063]= 10}, giver=117522, rew={17697,2255,10}}, -- Ugly Stomach // Hässlicher Magen
[423943]={typ=22, lvl=31, rlvl=29, zone= 13, mobs={[105342]= 10}, giver=117639, rew={21057,2258,10}}, -- Chase Off the Troublemakers // Vertreibt die Unruhestifter
[423944]={typ=21, lvl=31, rlvl=29, zone= 13, items={[209078]= 10}, giver=117517, rew={21057,2258,10}}, -- Cute and Slimy // Niedlich und glitschig
[423945]={typ=21, lvl=32, rlvl=30, zone= 13, items={[208921]= 10}, giver=117264, rew={23887,2305,10}}, -- Crimson Scorpion Shell Filled with Energy // Scharlachroter Skorpionpanzer voller Energie
[423946]={typ= 1, lvl=32, rlvl=30, zone= 13, items={[208993]= 10}, giver=117215, rew={23887,2305,10}, mobs={[105172]=  0}}, -- Barbecue Feast // Grillfest
[423948]={typ=21, lvl=32, rlvl=30, zone= 13, items={[209080]= 10}, giver=117641, rew={23887,2305,10}}, -- Determination Like a Flower // Entschlossen wie eine Blume
[424036]={typ=21, lvl=32, rlvl=30, zone= 13, items={[209192]= 10}, giver=117588, rew={23887,2305,10}}, -- Replanting // Neu bepflanzen
[423947]={typ=21, lvl=33, rlvl=31, zone= 13, items={[209053]= 10}, giver=117525, rew={26827,2417,10}}, -- Warm Pelts // Warme Pelze
[423949]={typ=21, lvl=33, rlvl=31, zone= 13, items={[208956]=  5}, giver=117376, rew={26827,2417,10}}, -- Unearthing Research // Ausgrabungen
[423957]={typ=25, lvl=35, rlvl=33, zone= 13, giver=117281, rew={40465,2581,10}, preq=423792}, -- Power for a Thousand Miles // Energie für tausend Meilen
[423950]={typ=21, lvl=36, rlvl=34, zone= 13, items={[208920]= 10}, giver=117524, rew={47260,2734,10}}, -- Sweet Juice // Süßer Saft
[423958]={typ=21, lvl=38, rlvl=36, zone= 13, items={[209101]= 10}, giver=117588, rew={61555,2981,10}}, -- Life Hormone // Lebenshormon
[423962]={typ= 5, lvl=38, rlvl=36, zone= 13, items={[544799]=  1,[544809]=  1,[544810]=  1}, giver=117589, rew={61555,2981,10}}, -- Important Patrol Work // Wichtige Patrouillenarbeit
[423963]={typ=21, lvl=40, rlvl=38, zone= 13, items={[209082]=  5,[209084]=  5}, giver=117609, rew={83327,3163,10}}, -- Weapon Inspection // Waffeninspektion
[423964]={typ=21, lvl=40, rlvl=38, zone= 13, items={[209083]=  5,[209086]=  5}, giver=117609, rew={83327,3163,10}, mobs={[105179]=  0,[105180]=  0}, preq=423963}, -- Weapon Inspection II // Waffeninspektion II
[423959]={typ= 1, lvl=41, rlvl=39, zone= 13, items={[208977]= 10}, giver=117590, rew={89442,3143,10}, mobs={[105183]=  0}}, -- Another Drink // Ein weiteres Getränk
[423967]={typ= 6, lvl=41, rlvl=39, zone= 13, giver=117585, rew={28621,1893,0}}, -- Problems Inside and Outside Fanger's Camp // Probleme innerhalb und außerhalb von Fangers Lager
[423960]={typ=21, lvl=42, rlvl=40, zone= 13, items={[209079]=  8}, giver=117590, rew={95650,3120,10}, mobs={[105182]=  0}}, -- Dragon Horn Ingredients // Drachenhorn-Zutat
[423961]={typ= 1, lvl=42, rlvl=40, zone= 13, items={[208995]= 10}, giver=117589, rew={95650,3120,10}, mobs={[105187]=  0}}, -- A Juicy Fruit // Eine saftige Frucht
[424037]={typ=21, lvl=42, rlvl=40, zone= 13, items={[209193]= 10}, giver=117590, rew={95650,3120,10}, mobs={[105186]=  0}}, -- Heat Reduction Recipe // Rezeptur zur Reduzierung von Hitze
--[[ ] ]]

--[[ [ Xaviera / Xaviera (14) ]]
[424151]={typ=14, lvl=43, rlvl=41, zone= 14, items={[209455]=  5}, giver=118056, rew={142702,5875,10}, mobs={[118046]=  0}}, -- Calm the Fury // Die Wut besänftigen
[424152]={typ= 4, lvl=43, rlvl=41, zone= 14, items={[209456]=  5}, giver=118056, rew={101930,3917,10}}, -- Water Demand // Bedarf an Wasser
[424153]={typ= 1, lvl=43, rlvl=41, zone= 14, items={[209427]= 10}, giver=118056, rew={101930,3917,10}, mobs={[105477]=  0}}, -- Soft Brush // Weicher Pinsel
[424154]={typ= 4, lvl=43, rlvl=41, zone= 14, items={[209428]=  5}, giver=118057, rew={101930,3917,10}, mobs={[118048]=  0}}, -- Moving Fragile Artifacts // Zerbrechliche Artefakte bewegen
[424054]={typ= 6, lvl=44, rlvl=42, zone= 14, giver=117751, rew={45248,2986,0}}, -- Strongholds, Morale and Rumors // Festungen, Gerüchte und die Moral
[424066]={typ= 6, lvl=44, rlvl=42, zone= 14, giver=117782, rew={45248,2986,0}}, -- The Secret Plan of the Eye of Wisdom // Der geheime Plan des Auges der Weisheit
[424155]={typ= 1, lvl=44, rlvl=42, zone= 14, items={[209429]=  5,[209430]=  5}, giver=118057, rew={113120,3982,10}, mobs={[105444]= 209430,[105450]= 209429}}, -- Dig Site Safety // Schutz der Ausgrabungsstätte
[424156]={typ=24, lvl=44, rlvl=42, zone= 14, items={[209431]=  5}, giver=118056, rew={113120,3982,10}, mobs={[118049]=  0}}, -- The Stolen Artifacts // Die gestohlenen Artefakte
[424157]={typ= 1, lvl=44, rlvl=42, zone= 14, items={[209432]=  5}, giver=118057, rew={113120,3982,10}, mobs={[105446]=  0}}, -- Artifact Restoration Materials // Material für die Artefaktrestauration
[424158]={typ= 1, lvl=44, rlvl=42, zone= 14, items={[209457]=  5}, giver=118058, rew={113120,3982,10}, mobs={[105449]=  0}}, -- Living Cultural Relics // Lebende kulturelle Relikte
[424207]={typ= 6, lvl=44, rlvl=42, zone= 14, giver=118204, taker=117448, rew={45248,2986,0}}, -- Charge! // Angriff!
[424208]={typ= 6, lvl=44, rlvl=42, zone= 14, mobs={[105395]=  0,[105396]=  0,[105397]=  0}, giver=117532, taker=117480, rew={45248,2986,0}}, -- Charge! // Angriff!
[424159]={typ= 1, lvl=45, rlvl=43, zone= 14, items={[209434]=  5}, giver=117776, rew={129385,3993,10}, mobs={[105420]=  0}}, -- Danger's Sweet Taste // Der süße Geschmack der Gefahr
[424160]={typ= 1, lvl=45, rlvl=43, zone= 14, items={[209435]=  5}, giver=117776, rew={129385,3993,10}, mobs={[105417]=  0}}, -- Wild Taste // Wilder Geschmack
[424161]={typ= 1, lvl=45, rlvl=43, zone= 14, items={[209436]=  5}, giver=117776, rew={129385,3993,10}, mobs={[105354]=  0}}, -- Crucial Ingredient for a Legendary Recipe // Entscheidende Zutat für ein legendäres Rezept
[424162]={typ= 1, lvl=45, rlvl=43, zone= 14, items={[209437]= 10}, giver=118059, rew={129385,3993,10}, mobs={[105419]=  0}}, -- Miraculous Bloodclotting Effect // Wunderbarer Blutgerinnungseffekt
[424163]={typ= 4, lvl=46, rlvl=44, zone= 14, items={[209438]=  5}, giver=118059, rew={139627,4135,10}}, -- Flu? Poisoned! // Grippe? Vergiftet!
[424164]={typ= 4, lvl=46, rlvl=44, zone= 14, items={[209458]=  5}, giver=118059, rew={139627,4135,10}, mobs={[118191]=  0}}, -- Retrieve the Loot // Die Beute wiederbeschaffen
[424165]={typ= 2, lvl=46, rlvl=44, zone= 14, mobs={[105483]=  5}, giver=118060, rew={139627,4135,10}}, -- Shut Them Up // Sie zum Schweigen bringen
[424166]={typ=11, lvl=46, rlvl=44, zone= 14, items={[209439]=  5}, giver=118061, rew={195478,6202,10}, mobs={[105501]=  0}}, -- Magic Coloring // Magische Farbe
[424167]={typ= 1, lvl=47, rlvl=45, zone= 14, items={[209440]= 10}, giver=118062, rew={147357,4213,10}, mobs={[105486]=  0}}, -- Ah! One Bear, Three Dishes // Ah! Ein Bär, drei Gerichte
[424169]={typ= 1, lvl=47, rlvl=45, zone= 14, items={[209441]= 10}, giver=118064, rew={147357,4213,10}, mobs={[105505]=  0}}, -- Purchase Spider Silk // Spinnenseide kaufen
[424170]={typ= 2, lvl=47, rlvl=45, zone= 14, mobs={[105500]= 10}, giver=118065, rew={147357,4213,10}}, -- Kill the Worms // Die Würmer töten
[424171]={typ= 2, lvl=47, rlvl=45, zone= 14, mobs={[105395]=  5,[105396]=  5,[105397]=  2}, giver=118066, rew={147357,4213,10}}, -- Cause of a Nightmare // Ursache des Albtraums
[424172]={typ= 4, lvl=48, rlvl=46, zone= 14, items={[209444]=  5}, giver=118067, rew={154995,4397,10}, mobs={[118052]=  0}}, -- Dangerous Worm Eggs // Gefährliche Wurmeier
[424173]={typ= 1, lvl=48, rlvl=46, zone= 14, items={[209447]= 10}, giver=118067, rew={154995,4397,10}, mobs={[105510]=  0,[105525]=  0}}, -- The Harpies can't resist... // Die Harpyien können nicht widerstehen ...
[424174]={typ= 1, lvl=48, rlvl=46, zone= 14, items={[209445]= 10}, giver=118068, rew={154995,4397,10}, mobs={[105489]=  0,[105490]=  0,[105511]=  0,[105512]=  0,[105513]=  0}}, -- Feathers of a Harpy // Federn einer Harpyie
[424182]={typ= 1, lvl=48, rlvl=46, zone= 14, items={[209446]=  5}, giver=118068, rew={154995,4397,10}, mobs={[105506]=  0}}, -- Turned into Ashes // In Asche verwandelt
[424175]={typ= 1, lvl=49, rlvl=47, zone= 14, items={[209448]=  5}, giver=118069, rew={166317,4477,10}, mobs={[105491]=  0,[105492]=  0}}, -- Rebirth // Wiedergeburt
[424176]={typ= 4, lvl=49, rlvl=47, zone= 14, items={[209459]=  5}, giver=118070, rew={166317,4477,10}, mobs={[118193]=  0}}, -- The Elves' Defenses // Die Verteidigung der Elfen
[424177]={typ= 1, lvl=49, rlvl=47, zone= 14, items={[209450]=  5,[209451]=  5}, giver=118070, rew={166317,4477,10}, mobs={[105433]= 209451,[105434]= 209450}}, -- Deal with the Hard Bones // Mit den harten Knochen fertigwerden
[424178]={typ= 4, lvl=49, rlvl=47, zone= 14, items={[209452]=  5}, giver=118069, rew={166317,4477,10}, mobs={[118194]=  0}}, -- Soft and Cozy // Weich und flauschig
[424179]={typ= 2, lvl=50, rlvl=48, zone= 14, mobs={[105415]=  5}, giver=118071, rew={266107,4498,10}}, -- Twisted Soul // Gequälte Seele
[424180]={typ=21, lvl=50, rlvl=48, zone= 14, items={[209453]= 10}, giver=118072, rew={266107,4498,10}, mobs={[105408]=  0}}, -- Difficult Supply Situation // Schwierige Vorratssituation
[424181]={typ= 2, lvl=50, rlvl=48, zone= 14, mobs={[105413]=  5}, giver=118072, rew={266107,4498,10}}, -- Catch Butterflies // Schmetterlinge fangen
[424205]={typ= 2, lvl=50, rlvl=48, zone= 14, items={[209454]=  5}, giver=118071, rew={266107,4498,10}, mobs={[105407]=  5}}, -- Support the Front Lines: Eliminate the Gargoyles // Unterstützung der Front: Eliminierung der Gargoyles
--[[ ] ]]

--[[ [ Thunderhoof Hills / Donnerhufhügel (15) ]]
[421028]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206752]=  5}, giver=114417, rew={119971,2384,10}, mobs={[103499]=  0}}, -- Throw a Pango on the Spit // Wirf einen Pango auf den Grill!
[421030]={typ= 4, lvl=57, rlvl=55, zone= 15, items={[206753]= 10}, giver=114417, rew={119971,2384,10}}, -- Pig in a Pond's Helper // Ein Helfer für das \"Schwein im Teich\"
[421031]={typ= 4, lvl=57, rlvl=55, zone= 15, items={[206754]= 10}, giver=114417, rew={119971,2384,10}}, -- Special Barbecue Spices // Spezielle Grillgewürze
[421032]={typ= 4, lvl=57, rlvl=55, zone= 15, items={[206756]= 10}, giver=114418, rew={119971,2384,10}}, -- Collect Scattered Wood // Sammelt verstreutes Holz
[421033]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206757]=  5}, giver=114419, rew={119971,2384,10}, mobs={[103537]=  0}}, -- Brain Eraser // Hirnputzer
[421034]={typ= 4, lvl=57, rlvl=55, zone= 15, items={[206759]= 10}, giver=114419, rew={119971,2384,10}}, -- Dragonslayer Pub Helper // Gehilfe in der Drachentöter-Bar
[421039]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206188]=  5}, giver=114419, rew={119971,2384,10}, mobs={[103534]=  0}}, -- Carrion helper // Aas-Gehilfe
[421210]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206189]= 10}, giver=114419, rew={119971,2384,10}, mobs={[103537]=  0}}, -- Mysterious sobering liquid ingredients // Sonderbare Ausnüchterungstrank-Bestandteile
[421273]={typ= 4, lvl=57, rlvl=55, zone= 15, items={[543687]=  1,[543688]=  1,[543689]=  1,[543690]=  1}, giver=114420, rew={119971,2384,10}, preq=422984}, -- Daily Patrol // Tägliche Streife
[421274]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206392]=  5}, giver=114420, rew={119971,2384,10}, mobs={[103526]=  0}, preq=422984}, -- Lost Wallets // Die verlorenen Brieftaschen
[421275]={typ= 2, lvl=57, rlvl=55, zone= 15, mobs={[103527]= 10}, giver=114420, rew={119971,2384,10}, preq=422984}, -- Eliminate Evil Bandits // Schaltet die bösen Banditen aus.
[421276]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206393]=  5}, giver=114420, rew={119971,2384,10}, mobs={[103533]=  0}, preq=422984}, -- Ferocious Giant Sewer Rats // Fürchterliche Riesen-Kanalratten
[421277]={typ= 2, lvl=57, rlvl=55, zone= 15, mobs={[103534]=  5}, giver=114420, rew={119971,2384,10}, preq=422984}, -- Eliminate the Source of Sewer Odor // Die Quelle des Kanalisationsgeruchs ausschalten
[421590]={typ=22, lvl=57, rlvl=55, zone= 15, mobs={[103104]= 10}, giver=114744, rew={119971,2384,10}}, -- Damn Marauding Bandits // Verdammte plündernde Banditen
[421591]={typ=22, lvl=57, rlvl=55, zone= 15, mobs={[103105]= 10}, giver=114744, rew={119971,2384,10}}, -- Leaving Hope // Hoffnung zurücklassen
[421592]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206758]= 10}, giver=114755, rew={119971,2384,10}, mobs={[103539]=  0,[103541]=  0}}, -- A Disgrace to the Armor of the Knights // Ein Frevel gegenüber der Ritterrüstung
[421593]={typ= 2, lvl=57, rlvl=55, zone= 15, mobs={[103539]=  5}, giver=114755, rew={119971,2384,10}}, -- Untainted Memory // Unbefleckte Erinnerungen
[421595]={typ=24, lvl=57, rlvl=55, zone= 15, items={[206408]=  8}, giver=114421, rew={119971,2384,0}}, -- Favorite of Lady and Miss // Renner bei den Damen
[421614]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206394]=  5}, giver=114421, rew={119971,2384,10}, mobs={[103533]=  0}}, -- Giant Rat Pouch // Riesenrattenmägen
[422048]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206395]=  5}, giver=114421, rew={119971,2384,10}, mobs={[103532]=  0}}, -- Hard Insect Wings // Harte Insektenflügel
[422049]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206167]=  5}, giver=114421, rew={119971,2384,10}, mobs={[103531]=  0}}, -- Take the Eggs // Beschaffen der Eier
[422051]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206400]=  5}, giver=114423, rew={119971,2384,10}, mobs={[103540]=  0}}, -- Steal Antidote // Gegengift stehlen
[422052]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206401]=  5,[206402]=  5}, giver=114423, rew={119971,2384,10}, mobs={[103539]= 206401,[103541]= 206402}}, -- Stolen Memory // Gestohlene Erinnerung
[422053]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[206404]=  5,[206405]=  5}, giver=114424, rew={119971,2384,10}, mobs={[103503]= 206404,[103548]= 206405,[103549]= 206404}}, -- Pie Filling // Pastetenfüllung
[422112]={typ= 4, lvl=57, rlvl=55, zone= 15, items={[206406]=  1}, giver={112613,114424}, taker=114744, rew={119971,2384,10}}, -- Love Pie Delivery // Liebespastetenlieferung
[422113]={typ=11, lvl=57, rlvl=55, zone= 15, items={[206407]=  5}, giver=114425, rew={119971,2384,10}, mobs={[103498]=  0}}, -- Cutest Chupura // Die niedlichste Chupura
[422857]={typ= 4, lvl=57, rlvl=55, zone= 15, items={[206868]= 10}, giver=114426, rew={119971,2384,10}}, -- Collect Centaur Fortune Stones // Sammelt Zentauren-Glückssteine
[422858]={typ= 2, lvl=57, rlvl=55, zone= 15, mobs={[103501]=  5,[103549]=  5}, giver=114426, rew={119971,2384,10}}, -- Centaur Hunting // Zentaurenjagd
[422859]={typ= 1, lvl=57, rlvl=55, zone= 15, items={[204016]=  5}, giver=114426, rew={119971,2384,10}, mobs={[103501]=  0,[103502]=  0}}, -- Beautiful Feathers // Schöne Federn
--[[ ] ]]

--[[ [ Southern Janost Forest / Südlicher Janostwald (16) ]]
[422935]={typ= 4, lvl=58, rlvl=56, zone= 16, items={[207158]= 10}, giver=115027, rew={122793,2409,10}}, -- Recipe for Jasmini No.5 // Rezept für Jasmini Nr.5
[422938]={typ= 1, lvl=58, rlvl=56, zone= 16, items={[207171]= 10}, giver=115036, rew={122793,2409,10}, mobs={[103833]=  0}}, -- Deadly Poison // Tödliches Gift
[422939]={typ= 4, lvl=58, rlvl=56, zone= 16, items={[207167]= 10}, giver=115039, rew={122793,2409,10}}, -- Misty Grove's White Zoysia // Weißer Zoysia des Nebelhains
[422940]={typ= 1, lvl=58, rlvl=56, zone= 16, items={[207165]= 10}, giver=115028, rew={122793,2409,10}, mobs={[103609]=  0}}, -- Expensive Leather Clothes // Teure Lederbekleidung
[422941]={typ= 1, lvl=58, rlvl=56, zone= 16, items={[207166]= 10}, giver=115040, rew={122793,2409,10}, mobs={[103843]=  0}}, -- Magnork Gold Coins // Magnork-Goldmünzen
[422942]={typ= 1, lvl=58, rlvl=56, zone= 16, items={[207275]= 10}, giver=115037, rew={122793,2409,10}, mobs={[103604]=  0,[103605]=  0}}, -- The Unbearable Attack // Der unerträgliche Angriff
[422943]={typ= 4, lvl=58, rlvl=56, zone= 16, items={[207170]= 10}, giver=115037, rew={122793,2409,10}}, -- Scattered Timber // Verstreutes Rohholz
[422944]={typ= 1, lvl=58, rlvl=56, zone= 16, items={[207163]= 10}, giver=115038, rew={122793,2409,10}, mobs={[103600]=  0,[103601]=  0}}, -- Hard Shells // Harte Schalen
[423215]={typ= 4, lvl=58, rlvl=56, zone= 16, items={[207168]= 10}, giver=115039, rew={122793,2409,10}}, -- The Staple Food Is Kado Taro // Kado-Taro ist das Grundnahrungsmittel.
[423216]={typ= 1, lvl=58, rlvl=56, zone= 16, items={[207169]= 10}, giver=115039, rew={122793,2409,10}, mobs={[103599]=  0}}, -- Sharptooth Meat Preparation // Scharfzahnfleisch-Zubereitung
[423217]={typ= 4, lvl=58, rlvl=56, zone= 16, items={[207187]= 10}, giver=115041, rew={122793,2409,10}}, -- The Lost Kingdom // Das verlorene Königreich
[423218]={typ= 4, lvl=58, rlvl=56, zone= 16, items={[207164]= 10}, giver=115039, rew={122793,2409,10}}, -- Fishing // Angeln
[423219]={typ= 2, lvl=58, rlvl=56, zone= 16, mobs={[103843]= 10}, giver=115041, rew={122793,2409,10}}, -- Graverobber's Punishment // Die Bestrafung der Grabräuber
[423221]={typ= 5, lvl=58, rlvl=56, zone= 16, giver=115042, rew={229215,4819,10}}, -- Rescue // Rettung
[423223]={typ= 5, lvl=58, rlvl=56, zone= 16, giver=115042, rew={147352,2409,10}}, -- Redemption // Erlösung
[423224]={typ= 1, lvl=58, rlvl=56, zone= 16, items={[207190]= 10}, giver=115042, rew={122793,2409,10}, mobs={[103837]=  0,[103838]=  0,[103850]=  0}}, -- Heartless Demons // Grausame Dämonen
[423297]={typ=21, lvl=58, rlvl=56, zone= 16, items={[207417]= 10}, giver=115300, rew={122793,2409,10}, mobs={[103846]=  0}}, -- Even More Lavender Sprigs // Noch mehr Lavendelblüten
[423298]={typ=21, lvl=58, rlvl=56, zone= 16, items={[207418]= 10}, giver=115300, rew={122793,2409,10}, mobs={[103847]=  0}}, -- More Clothes Lines // Mehr Wäscheleinen
[423299]={typ=21, lvl=58, rlvl=56, zone= 16, items={[207419]= 10}, giver=115300, rew={122793,2409,10}, mobs={[103848]=  0}}, -- Get Rid of Even More Disgusting Insects // Noch mehr widerliche Insekten loswerden
--[[ ] ]]

--[[ [ Northern Janost Forest / Nördlicher Janostwald (17) ]]
[422079]={typ= 2, lvl=59, rlvl=57, zone= 17, mobs={[103988]=  5}, giver=115613, rew={127754,2424,10}}, -- Pest Control Op // Schädlingsbekämpfungseinsatz
[422080]={typ=24, lvl=59, rlvl=57, zone= 17, items={[207432]=  7}, giver=115610, rew={127754,2424,10}, preq=423302}, -- Poisonous Frog Spawn Are Nutritious // Giftfroschlaich ist nahrhaft
[422081]={typ=24, lvl=59, rlvl=57, zone= 17, items={[207433]=  6}, giver=115610, rew={127754,2424,10}, preq=423302}, -- Incubation Is the Key // Das Ausbrüten ist der Schlüssel
[422898]={typ= 4, lvl=59, rlvl=57, zone= 17, items={[207434]=  5}, giver=115611, rew={127754,2424,10}, mobs={[103997]=  0}}, -- Tasty Bloodwing Fruit Bats // Schmackhafte Blutschwingen-Fruchtfledermäuse
[422899]={typ= 4, lvl=59, rlvl=57, zone= 17, items={[207435]=  5}, giver=115611, rew={127754,2424,10}}, -- Effective Deterrent // Effektive Abschreckung
[422900]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207436]=  5,[207443]=  5}, giver=115611, rew={127754,2424,10}, mobs={[103983]= 207443}}, -- Effective Anti-Itching Lotion // Wirksame Anti-Juckreiz-Lotion
[422901]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207438]=  6}, giver=115612, rew={127754,2424,10}, mobs={[103981]=  0}}, -- Chewy Thighs // Zähe Oberschenkel
[422902]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207439]=  5}, giver=115612, rew={127754,2424,10}, mobs={[103984]=  0}}, -- Pukari Fur // Fell der Pukari
[422903]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207440]=  5}, giver=115612, rew={127754,2424,10}, mobs={[103986]=  0}}, -- The Grotesque Mask // Groteske Maske
[422904]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207446]= 10}, giver=115613, rew={127754,2424,10}, mobs={[103998]=  0}}, -- Sharptooth Hunt // Jagd auf Scharlach-Scharfzähne
[422905]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207441]=  6}, giver=115613, rew={127754,2424,10}, mobs={[104000]=  0}}, -- Delicious Python Meat // Köstliches Pythonfleisch
[422906]={typ= 4, lvl=59, rlvl=57, zone= 17, items={[207444]= 10}, giver=115613, rew={127754,2424,10}}, -- Sparkly Moon Breath Grass // Funkelndes Mondatemgras
[422907]={typ= 4, lvl=59, rlvl=57, zone= 17, items={[207445]=  5}, giver=115614, rew={127754,2424,10}}, -- Rare Orchid of Beauty // Seltene Orchidee der Schönheit
[422908]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207442]=  5}, giver=115614, rew={127754,2424,10}, mobs={[103988]=  0}}, -- Rotwood Bug Acid // Säure des Faulholzkäfers
[422909]={typ= 1, lvl=59, rlvl=57, zone= 17, items={[207437]=  8}, giver=115614, rew={127754,2424,10}, mobs={[103980]=  0}}, -- Dimstar Bolmu Poison // Dämmerstern-Bolmu-Gift
[422910]={typ=32, lvl=59, rlvl=57, zone= 17, mobs={[104010]=  1}, giver=115613, rew={170339,3636,10}}, -- Kill The Giant Sharptooth // Tötet den Riesenscharfzahn
[422911]={typ=22, lvl=59, rlvl=57, zone= 17, mobs={[104149]= 10}, giver=115613, rew={127754,2424,10}}, -- Never-ending Blaze Weed // Feuerkraut ohne Ende
--[[ ] ]]

--[[ [ Limo Desert / Wüste Limo (18) ]]
[423161]={typ=24, lvl=61, rlvl=59, zone= 18, items={[208089]=  8}, giver=116151, rew={138284,2445,10}, mobs={[116762]=  0}}, -- Incubation Plan // Brutplan
[423162]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208090]=  6}, giver=116151, rew={156722,2934,10}, mobs={[104286]=  0}}, -- Source of High Nutrition // Reichhaltige Ernährung
[423163]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208091]=  6}, giver=116151, rew={193597,3912,10}, mobs={[104296]=  0}}, -- King of the Desert Ecosystem // Wüstenkönig-Ökosystem
[423164]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208082]=  8}, giver=116148, rew={156722,2934,10}, mobs={[104274]=  0}}, -- Thief Hunter // Diebesjagd
[423165]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208083]=  6}, giver=116148, rew={138284,2445,10}, mobs={[104273]=  0}}, -- Not Simple Rock Salt // Nicht einfach nur Steinsalz
[423166]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208084]=  8}, giver=116740, rew={147503,2690,10}, mobs={[104272]=  0}}, -- Sandstorm Protection // Schutz gegen Sandstürme
[423167]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208085]=  8}, giver=116149, rew={156722,2934,10}, mobs={[104278]=  0}}, -- Dragon and the Maiden // Der Drache und das Mädchen
[423168]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208086]=  6}, giver=116150, rew={138284,2445,10}, mobs={[104282]=  0}}, -- Road to the Sky // Weg in den Himmel
[423169]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208087]=  6}, giver=116152, rew={175160,3423,10}, mobs={[104289]=  0}}, -- Secret of the Ruins // Das Geheimnis der Ruinen
[423170]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208088]=  6}, giver=116152, rew={156722,2934,10}, mobs={[104293]=  0}}, -- Mark of the Damned // Zeichen der Verdammten
[423171]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208080]=  8}, giver=116146, rew={147503,2934,10}, mobs={[104263]=  0}}, -- Water Saving Method // Wassersparmaßnahme
[423172]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208081]=  6}, giver=116147, rew={175160,3423,10}, mobs={[104264]=  0}}, -- Too Hungry to Move // Regungslos vor Hunger
[423173]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208092]=  6}, giver=116153, rew={138284,2445,10}, mobs={[104488]=  0}, preq=423547}, -- In Hot Springs // In heißen Quellen
[423174]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208093]=  8}, giver=116760, rew={147503,2934,10}, mobs={[104310]=  0}}, -- Witness a Miracle // Erlebt ein Wunder
[423175]={typ=21, lvl=61, rlvl=59, zone= 18, items={[208094]=  6}, giver=116153, rew={138284,2445,10}, mobs={[104314]=  0}, preq=423542}, -- Enviable Strength // Beneidenswerte Stärke
[423486]={typ=24, lvl=61, rlvl=59, zone= 18, items={[208199]= 10}, giver=116398, taker=116400, rew={165941,2934,10}, mobs={[104286]= 10}}, -- Meat in the Sand is Especially Delicious // Besonders köstliches Fleisch im Sand
[423487]={typ=32, lvl=61, rlvl=59, zone= 18, mobs={[104487]=  1}, giver=116640, rew={368758,9782,15}}, -- Red Demon of the Desert // Roter Dämon der Wüste
[423674]={typ=22, lvl=61, rlvl=59, zone= 18, mobs={[104262]= 10}, giver=116608, rew={138284,2445,10}}, -- A Lesson // Eine Lektion
--[[ ] ]]

--[[ [ Land of Malevolence / Land des Unheils (19) ]]
[423708]={typ= 5, lvl=64, rlvl=62, zone= 19, items={[208551]=  8}, giver=117092, rew={218019,3915,10}, mobs={[104696]=  0,[104736]=  0,[104738]=  0}, preq=423707}, -- Perseverance // Beharrlichkeit
[423710]={typ= 2, lvl=64, rlvl=62, zone= 19, mobs={[104756]= 10}, giver=116993, rew={166110,2610,10}, preq=423709}, -- Scarecrow // Vogelscheuche
[423718]={typ= 4, lvl=64, rlvl=62, zone= 19, items={[208487]= 10}, giver=117003, rew={207638,3915,10}, preq=423717}, -- Herbal Supplies // Kräutervorräte
[423720]={typ= 1, lvl=64, rlvl=62, zone= 19, items={[208489]= 10}, giver=117003, rew={176492,2871,10}, mobs={[104704]=  0}, preq=423719}, -- Spirit of Experimentation // Experimentiergeist
[423722]={typ=25, lvl=64, rlvl=62, zone= 19, items={[208547]= 10,[208548]=  5}, giver=116530, rew={290693,4698,10}, mobs={[104721]= 208548}, preq=423721}, -- If I Persevere // Wenn ich durchhalte
[423724]={typ=24, lvl=64, rlvl=62, zone= 19, items={[208546]= 10}, giver=117018, rew={207638,3915,10}, preq=423723}, -- Second Aid // Zweite Hilfe
[423727]={typ= 2, lvl=64, rlvl=62, zone= 19, mobs={[104861]= 10}, giver=116990, rew={166110,2610,10}, preq=423726}, -- The Mind is Willing but the Flesh is Weak // Der Geist ist willig, doch das Fleisch ist schwach
[423730]={typ=22, lvl=64, rlvl=62, zone= 19, mobs={[104724]= 10}, giver=117017, rew={166110,2610,10}, preq=423729}, -- The Threat Persists // Die Bedrohung besteht weiter
[423732]={typ=24, lvl=64, rlvl=62, zone= 19, items={[208545]= 10}, giver=117017, rew={207638,3915,10}, preq=423731}, -- Not Too Late to Fix Mistakes // Zum Fehlerbeheben ist es nie zu spät
[423736]={typ=21, lvl=64, rlvl=62, zone= 19, items={[544661]=  1}, giver=116978, rew={166110,2610,10}, mobs={[104861]=  1}, preq=423735}, -- Capture One \"Alive\" // Ihr müsst einen fangen, der noch \"lebt\".
[423738]={typ= 4, lvl=64, rlvl=62, zone= 19, items={[208549]= 10}, giver=116648, rew={207638,3915,10}, preq=423737}, -- Unexpected Discovery // Eine unerwartete Entdeckung
[423753]={typ= 1, lvl=64, rlvl=62, zone= 19, items={[208576]= 10}, giver=116834, rew={176492,2610,10}, mobs={[104701]=  0}, preq=423752}, -- Food for Your Health // Heilnahrung
[423754]={typ= 1, lvl=64, rlvl=62, zone= 19, items={[208550]= 10}, giver=117055, rew={166110,2610,10}, mobs={[104710]=  0}, preq=423691}, -- Right-hand Man // Der rechte Mann
[423756]={typ=21, lvl=64, rlvl=62, zone= 19, items={[208522]=  5,[208548]=  5}, giver=116484, rew={176492,2871,10}, mobs={[104709]= 208522,[104721]= 208548}}, -- Meals for the Animals // Futter für die Tiere
[423763]={typ=12, lvl=64, rlvl=62, zone= 19, mobs={[104852]=  1}, giver=117188, rew={726733,7831,15}, preq=423762}, -- Endless Night // Endlose Nacht
[423764]={typ=24, lvl=64, rlvl=62, zone= 19, items={[208488]= 10}, giver=116484, rew={207638,3915,10}}, -- Provide Comfort // Trost spenden
[423767]={typ=22, lvl=64, rlvl=62, zone= 19, mobs={[104722]= 10}, giver=116932, rew={176492,2610,10}, preq=423640}, -- If at that time... // Wenn zu diesem Zeitpunkt ...
[423768]={typ=22, lvl=64, rlvl=62, zone= 19, mobs={[104733]=  5,[104734]=  5}, giver=117018, rew={166110,2610,10}, preq={423723,423729,423731}}, -- Someone Who Knows The Deal // Jemand, der sich auskennt
[423769]={typ=22, lvl=64, rlvl=62, zone= 19, mobs={[104729]=  5,[104730]=  5}, giver=116487, rew={166110,2610,10}, preq={423619,423770}}, -- Unsettled Anger // Offene Rechnung
[423770]={typ=22, lvl=64, rlvl=62, zone= 19, mobs={[104726]= 10}, giver=116487, rew={166110,2610,10}}, -- Irritable Mood // Gereizte Stimmung
--[[ ] ]]

--[[ [ Redhill Mountains / Rothügelberge (20) ]]
[424245]={typ=22, lvl=65, rlvl=63, zone= 20, mobs={[105668]=  3}, giver=118377, rew={172820,2665,10}, preq=424234}, -- Drive off the Doomsayers // Vertreibt die Unheilkünder
[424278]={typ=21, lvl=65, rlvl=63, zone= 20, items={[209637]= 10}, giver=118324, rew={216026,3998,10}, mobs={[105672]=  0}}, -- A Young Fireboot's Dream // Der Traum eines jungen Feuerstiefels
[424279]={typ=24, lvl=65, rlvl=63, zone= 20, items={[209639]= 10}, giver=118325, rew={172820,2665,10}}, -- A Beard Must be Maintained // Ein Bart muss gepflegt werden
[424280]={typ= 1, lvl=65, rlvl=63, zone= 20, items={[209641]=  1}, giver=118325, rew={216026,3998,10}, mobs={[105673]=  0}}, -- The Treasures of Redwood // Die Schätze des Sequoiawaldes
[424281]={typ=24, lvl=65, rlvl=63, zone= 20, items={[209640]= 10}, giver=118339, rew={172820,2665,10}}, -- Emergency Fuel // Notbrennmaterial
[424282]={typ=21, lvl=65, rlvl=63, zone= 20, items={[209636]=  5}, giver=118328, rew={194423,3198,10}, preq=424267}, -- Master Craftsman's Helper // Des Handwerksmeisters Gehilfe
[424283]={typ=21, lvl=65, rlvl=63, zone= 20, items={[209635]=  5}, giver=118537, rew={194423,3198,10}, preq=424270}, -- Forever Winner // Ewiger Gewinner
[424284]={typ=22, lvl=65, rlvl=63, zone= 20, mobs={[105676]= 10}, giver=118464, rew={194423,1172,10}, preq=424269}, -- Continue cleaning out the Rock Galiduns // Beseitigt weiter die Felsgalidune.
[424285]={typ=21, lvl=65, rlvl=63, zone= 20, items={[240293]= 10}, giver=118333, rew={216026,3998,10}, mobs={[105675]= 10}, preq=424277}, -- Allan's Potion Recipe // Allans Trankrezept
[424288]={typ=21, lvl=65, rlvl=63, zone= 20, items={[209071]= 10}, giver=118257, rew={216026,3998,10}, mobs={[105699]=  0}}, -- Food Supply // Versorgung mit Lebensmitteln
[424289]={typ=21, lvl=65, rlvl=63, zone= 20, items={[209072]=  5}, giver=118274, rew={194423,3198,10}, mobs={[105698]=  0}}, -- The Road to Wealth // Der Weg zum Reichtum
[424316]={typ=22, lvl=65, rlvl=63, zone= 20, mobs={[105766]=  5}, giver=118315, rew={172820,3998,10}}, -- Calm the Spirit's Complaints // Besänftigt den klagenden Geist
[424317]={typ=21, lvl=65, rlvl=63, zone= 20, items={[240292]= 10}, giver=118478, rew={216026,3998,10}, mobs={[105667]=  0,[105756]=  0,[105763]=  0,[118492]=  0}}, -- Tame the Hunting Dogs // Zähmt die Jagdhunde
[424318]={typ=21, lvl=65, rlvl=63, zone= 20, items={[240281]= 10}, giver=118319, rew={216026,3998,10}, mobs={[105765]=  0,[105850]=  0}}, -- Valuable Prescription // Ein wertvolles Rezept
[424319]={typ=24, lvl=65, rlvl=63, zone= 20, items={[240280]= 10}, giver=118371, rew={172820,2665,10}}, -- Pain-Relief Method // Schmerzmittel
[424342]={typ=21, lvl=65, rlvl=63, zone= 20, items={[240028]= 10}, giver=118301, rew={216026,3998,10}, preq=424330}, -- Horn of a Proud Buck // Horn eines stolzen Bocks
[424343]={typ=21, lvl=65, rlvl=63, zone= 20, items={[240029]= 10}, giver=118801, rew={216026,3998,10}, preq=424330}, -- Doe Leg Meat // Beinfleisch einer weiblichen Antilope
[424344]={typ=21, lvl=65, rlvl=63, zone= 20, items={[240030]= 10}, giver=118755, rew={216026,3998,10}, mobs={[105675]= 10}, preq=424262}, -- Large Claw Soup // Großklauensuppe
[424347]={typ=22, lvl=66, rlvl=64, zone= 20, mobs={[105590]=  5}, giver=118293, rew={224753,4080,10}, preq=424249}, -- Drive off the returned monsters // Vertreibt die zurückgekehrten Monster
[424348]={typ=24, lvl=66, rlvl=64, zone= 20, items={[240280]= 10}, giver=118293, rew={179802,2720,10}, preq=424249}, -- Clean up the garbage // Beseitigt den Müll.
[424349]={typ=25, lvl=66, rlvl=64, zone= 20, items={[545094]=  1}, giver=118290, rew={134851,1904,10}, preq=424248}, -- Repeat Salt Distribution // Wiederholte Salzverteilung
[424360]={typ=21, lvl=66, rlvl=64, zone= 20, items={[240011]=  5,[240012]=  3}, giver=118597, rew={179802,2720,10}, preq=424359}, -- Gather cotton and flax // Sammelt Baumwolle und Flachs
[424381]={typ=25, lvl=66, rlvl=64, zone= 20, items={[544996]=  1}, giver=118608, rew={78663,1088,10}, preq=424361}, -- Continue to Clear Out the Dead // Fahrt mit der Beseitigung der Leichen fort
--[[ ] ]]

--[[ [ Tergothen Bay / Tergothenbucht (21) ]]
[424432]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240550]= 10,[240551]=  6}, giver=118981, rew={187066,3330,10}, preq=424431}, -- Amden's Request // Amdens Forderung
[424457]={typ=22, lvl=67, rlvl=65, zone= 21, mobs={[105902]=  3,[105903]=  3}, giver=119197, rew={0,0,0,210}, preq=424515}, -- Drive off the Ragemanes // Vertreibt die Wutmähnen
[424458]={typ=22, lvl=67, rlvl=65, zone= 21, mobs={[106104]=  6}, giver=119197, rew={0,0,0,210}, preq=424515}, -- Rescue the Villagers // Rettet die Dorfbewohner
[424459]={typ=22, lvl=67, rlvl=65, zone= 21, mobs={[105904]=  1}, giver=119197, rew={0,0,0,210}, preq=424515}, -- Attack the Head // Der Kopf der Schlange
[424460]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240603]=  1}, giver=119199, rew={0,0,0,400}, preq=424431}, -- Effective Cough Medicine // Wirksames Hustenmittel
[424462]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240566]= 10}, giver=119202, rew={0,0,0,350}}, -- Night Banquet // Nachtmenü
[424463]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240567]= 10}, giver=119201, rew={0,0,0,200}}, -- Tanya's Distress // Tanyas Kummer
[424464]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240568]=  1}, giver=119199, taker=118905, rew={0,0,0,100}}, -- Weapon Advance // Waffenlieferung
[424465]={typ=21, lvl=67, rlvl=65, zone= 21, items={[545520]=  1}, giver=119197, rew={0,0,0,350}}, -- Shadow Threat // Drohende Schatten
[424466]={typ=21, lvl=67, rlvl=65, zone= 21, items={[545532]=  1,[545533]=  1,[545534]=  1,[545535]=  1}, giver=119202, rew={0,0,0,150}}, -- Allotted Supply // Rationen
[424503]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240622]= 10}, giver=119122, rew={0,0,0,300}, preq=424467}, -- Numbing Powder Ingredients // Betäubungspulver-Zutaten
[424504]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240625]= 10}, giver=119160, rew={0,0,0,300}, preq=424467}, -- Sound Imitation Flute // Imitationsflöte
[424505]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240587]=  5,[240588]=  5}, giver=119122, rew={0,0,0,300}, preq=424467}, -- Armored Protection // Rüstungsschutz
[424506]={typ=21, lvl=67, rlvl=65, zone= 21, items={[240228]= 10}, giver=118905, rew={0,0,0,70}, preq=424472}, -- In Vino Veritas // In Vino Veritas
[424507]={typ=21, lvl=67, rlvl=65, zone= 21, items={[545477]=  1}, giver=119052, taker=119074, rew={0,0,0,150}, preq=424467}, -- People with information control the direction of things // Wer Informationen kontrolliert, kontrolliert das Geschehen
[424604]={typ=21, lvl=67, rlvl=65, zone= 21, items={[545578]=  1}, giver=119215, rew={0,0,0,70}, preq=424467}, -- Battle Tactics: Enemy Confusion // Kampftaktik: Verwirrung des Feindes
[424502]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240590]= 10}, giver=119158, rew={0,0,0,70}, preq={424467,424501}}, -- The Secret of the Copied Key // Das Geheimnis des kopierten Schlüssels
[424600]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240626]= 10}, giver=119213, rew={0,0,0,300}, preq=424495}, -- Didola's Pearls // Didolas Perlen
[424601]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240627]= 15}, giver=119214, rew={0,0,0,150}, preq=424467}, -- False Countercharge // Falscher Gegenschlag
[424602]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240635]= 10}, giver=119214, rew={0,0,0,300}, preq=424472}, -- Thief's Small Knives // Die Messer des kleinen Diebs
[424603]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240640]= 10}, giver=119052, rew={0,0,0,70}, preq=424477}, -- Refreshing Mint Tea // Erfrischender Minztee
[424610]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[105999]=  5}, giver=119053, rew={0,0,0,280}}, -- Maintain Safety on the Trade Routes // Sorgt für Sicherheit auf den Handelsrouten
[424611]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[106122]=  5}, giver=119053, rew={0,0,0,330}}, -- Rescue the Plundered Merchants // Rettet die Geplünderten Händler
[424612]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240571]=  5}, giver=119053, rew={0,0,0,175}}, -- Find the Lost Materials // Findet die Verlorenen Materialien
[424613]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[106000]=  5}, giver=119055, rew={0,0,0,175}}, -- Threat of a Rebel Informant // Drohung eines Rebelleninformanten
[424614]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[106057]=  5}, giver=119057, rew={0,0,0,175}}, -- The Galidun's Hindrance // Das Galidun-Problem
[424615]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[105994]=  5}, giver=119054, rew={0,0,0,175}}, -- Extend a Hand of Friendship // Zeichen der Freundschaft
[424616]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[105995]=  5}, giver=119063, rew={0,0,0,250}}, -- Battle Training for the Watch Team // Kampftraining für die Wachmannschaft
[424617]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240579]=  5}, giver=119063, rew={0,0,0,370}}, -- Second Stage of the Training // Die zweite Trainingsphase
[424618]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240572]=  5}, giver=119063, rew={0,0,0,420}}, -- Requirements to become part of the Rebel Army // Voraussetzungen für die Rebellenarmee
[424619]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240573]= 10}, giver=119065, rew={0,0,0,410}}, -- Otto's Secret Research // Ottos geheime Forschungen
[424620]={typ=21, lvl=68, rlvl=66, zone= 21, items={[240578]=  1}, giver=119065, rew={0,0,0,500}}, -- Take Back Otto's Research Report // Bringt Otto seinen Forschungsbericht zurück
[424621]={typ=25, lvl=68, rlvl=66, zone= 21, giver=119065, taker=119060, rew={0,0,0,50}}, -- Otto's Warning // Ottos Warnung
[424622]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[106158]=  1}, giver=119060, rew={0,0,0,300}}, -- Destroy The Imperial Army's Mysterious Device // Mysteriöse Ausrüstung der Imperialen Armee zerstören
[424623]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[106001]=  5}, giver=119061, rew={0,0,0,300}}, -- Continue to Clean up the Threats to the Fishing Village // Beseitigt weitere Gefahren für das Fischerdorf
[424624]={typ=22, lvl=68, rlvl=66, zone= 21, mobs={[106191]=  5}, giver=119061, rew={0,0,0,400}}, -- Immediate Relief // Sofortige Hilfe
[424424]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106073]=  5,[106074]=  5}, giver=119230, rew={189830,3462,10}, preq=424423}, -- Ease of Delivery // Einfache Lieferung
[424428]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240548]= 10}, giver=118980, rew={177174,3462,10}, preq=424427}, -- Collecting More Corn // Mehr Korn
[424430]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[105908]= 10}, giver=118980, rew={189830,3462,10}, preq=424429}, -- Get Rid of Even More Mutant Tree Frogs // Vernichtet mehr Mutierte Baumfrösche
[424434]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240340]= 10}, giver=119494, rew={177174,3462,10}}, -- A Rare Taste // Ein seltener Genuss
[424436]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106061]=  7,[106062]=  7}, giver=118980, rew={189830,3462,10}, preq=424435}, -- Eradicate the Frog Nests! // Beseitigt die Froschnester!
[424437]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240562]=  1}, taker=118981, rew={177174,3462,10}}, -- Giant Frog // Riesenfrosch
[424438]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240431]= 10}, giver=119449, rew={177174,3462,10}}, -- Pick Up the Pieces // Die Guten ins Töpfchen ...
[424443]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240558]= 10}, giver=119190, rew={189830,3462,10}, preq=424442}, -- Explore more Inscriptions // Untersucht weitere Inschriften
[424446]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240560]= 10}, giver=119191, rew={177174,3462,10}, preq=424445}, -- Placate the Tergothen Female Horned Beast // Besänftigt das Tergothen-Hornbestienweibchen
[424447]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240596]= 10}, giver=119193, rew={177174,3462,10}}, -- Growth Potion for the Frogs Polluting Tergothen // Wachstumstrank für die Frösche von Tergothen
[424448]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240598]= 10}, giver=119192, rew={189830,3462,10}, preq=424427}, -- Polk Corn Research // Kermesmaisforschung
[424449]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240597]= 10}, giver=119081, taker=119086, rew={177174,3462,10}, preq=424514}, -- Unspeakable // Unaussprechlich
[424481]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[105957]= 10}, giver=118906, rew={189830,3462,10}}, -- Ruined Fish Net // Zerstörtes Fischernetz
[424482]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240229]= 10}, giver=118907, rew={202485,3462,10}}, -- Consequence of Stealing Fish // Mit gestohlenem Fisch handeln
[424483]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240526]= 10}, giver=118908, rew={202485,3462,10}}, -- Fish's Favorite // Was der Fisch am liebsten hat
[424484]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240527]= 10}, giver=119120, rew={177174,3462,10}}, -- The Spirit of Food // Die Seele des Essens
[424485]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[105971]= 10}, giver=119048, rew={177174,3462,10}}, -- Cleaning the Fishing Boats is a Difficult Job // Fischerboote zu reinigen ist nicht leicht
[424486]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240543]= 10,[240606]= 10}, giver=119076, rew={202485,3462,10}, preq=424498}, -- Obtain Analysis Samples // Besorgt Analyseproben
[424487]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240542]= 10}, giver=119045, rew={177174,3462,10}, preq=424493}, -- Favorite Food // Lieblingsspeise
[424488]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240591]= 10}, giver=119153, rew={202485,3462,10}, preq=424476}, -- The Other Side of the Cave // Auf der anderen Seite des Käfigs
[424489]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240594]= 10}, giver=119157, rew={202485,3462,10}, preq=424501}, -- Beacon of Light // Leuchtfeuer
[424490]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240592]= 10}, giver=119168, rew={177174,3462,10}}, -- Rush of Beach Treasures // Jagd nach Strandschätzen
[424539]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[103002]=  3}, giver=119416, rew={0,0,0,150}}, -- Delivery of Rebel Information // Übergabe der Informationen über die Rebellen
[424540]={typ=21, lvl=69, rlvl=67, zone= 21, items={[545596]=  1,[545597]=  1,[545598]=  1}, giver=119417, rew={0,0,0,110}}, -- Steal the False Flyers // Stehlt die falschen Flugblätter
[424541]={typ=21, lvl=69, rlvl=67, zone= 21, items={[545599]=  1,[545600]=  1,[545601]=  1}, giver=119418, rew={0,0,0,180}}, -- Spread Rumors // Gerüchte streuen
[424542]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[103003]=  3}, giver=119417, rew={0,0,0,340}}, -- Deliver to the Residents // Die Bewohner beliefern
[424543]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240642]= 10}, giver=119419, rew={0,0,0,180}}, -- Scavenge for Weapon Boxes! // Sammelt Waffenkisten!
[424544]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106067]= 10}, giver=119416, rew={0,0,0,180}}, -- Exterminate Those Vermin! // Vernichtet dieses Ungeziefer!
[424563]={typ=21, lvl=69, rlvl=67, zone= 21, items={[545536]=  1}, giver=119231, rew={177174,3462,10}, preq=424425}, -- Bodyguard of Fishing Goods // Wächter der Fischwaren
[424565]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106079]= 10}, giver=119233, rew={189830,3462,10}, preq=424564}, -- Maintain Privacy // Schutz der Privatsphäre
[424581]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240653]= 10}, giver=119053, rew={202485,3462,10}, preq=424569}, -- An Even More Mysterious Power // Eine noch mysteriösere Macht
[424582]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240654]= 10}, giver=119131, rew={202485,3462,10}, preq=424567}, -- For More Materials // Für mehr Rohstoffe
[424583]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240655]= 20}, giver=119132, rew={202485,3462,10}, preq=424479}, -- Ekan Nors' Gift // Ekan Nors' Geschenk
[424584]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240656]=  5}, giver=119055, rew={202485,3462,10}, preq=424568}, -- Bart's Commission // Barts Auftrag
[424585]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240282]= 10}, giver=119065, rew={202485,3462,10}, preq=424620}, -- Reason for the Animal Mutations // Die Ursache für die mutierten Tiere
[424586]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240657]= 10}, giver=119133, rew={202485,3462,10}, preq=424572}, -- Dangerous Dye // Gefährlicher Farbstoff
[424587]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106060]= 10}, giver=119059, rew={189830,3462,10}, preq=424572}, -- Annoying Noise // Lärmbelästigung
[424588]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240658]= 10}, giver=119134, rew={202485,3462,10}, preq=424572}, -- Troublesome Building Materials // Viel Mühe um Baumaterial
[424589]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240659]= 10}, giver=119064, rew={202485,3462,10}, preq=424572}, -- The Best Tonic // Das beste Tonikum
[424590]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[105996]= 10,[105997]=  5}, giver=119149, rew={189830,3462,10}, preq=424572}, -- The Fishermen's Trouble // Das Problem der Fischer
[424591]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240629]= 10}, giver=119234, rew={202485,3462,10}, preq=424566}, -- Heart of the Ocean // Herz des Ozeans
[424593]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106079]= 10}, giver=119235, rew={189830,3462,10}, preq=424592}, -- A Father's Concern // Die Sorge eines Vaters
[424625]={typ=24, lvl=69, rlvl=67, zone= 21, items={[240634]=  1}, giver=119236, rew={189830,3462,10}, mobs={[106117]= 10}, preq=424594}, -- Being Prepared // Seid vorbereitet
[424627]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106118]= 10}, giver=119237, rew={202485,3462,10}, preq=424626}, -- Using Natural Enemies // Benutzt natürliche Feinde
[424629]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106075]= 10}, giver=119238, rew={189830,3462,10}, preq=424628}, -- Pets Forbidden Inside // Haustiere verboten
[424631]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240636]=  5}, giver=119238, rew={202485,3462,10}, preq=424630}, -- Pick up a Nest Crystal... // Den Nest-Kristall aufheben ...
[424633]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106121]=  5}, giver=119241, rew={202485,3462,10}, preq=424632}, -- Equipment Replacement // Ersatzapparat
[424635]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240630]=  5}, giver=119234, rew={189830,3462,10}, preq=424634}, -- Acting Props // Requisiten
[424636]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106073]=  3,[106074]=  3}, giver=119230, rew={0,0,0,250}, preq=424423}, -- Hope for Safe Delivery // Hoffnung auf eine sichere Lieferung
[424637]={typ=21, lvl=69, rlvl=67, zone= 21, items={[545536]=  1}, giver=119231, rew={0,0,0,150}, preq=424425}, -- Special Secluded Valley Cart // Ein besonderer Transport für das Abgeschiedene Tal
[424638]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106079]= 10}, giver=119233, rew={0,0,0,150}, preq=424564}, -- Maintain Long-Term Privacy // Langfristiger Schutz der Privatsphäre
[424639]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240629]= 10}, giver=119234, rew={0,0,0,200}, preq=424566}, -- More Hearts of the Ocean // Mehr Herzen des Ozeans
[424640]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106079]=  6}, giver=119235, rew={0,0,0,200}, preq=424592}, -- A Father's Constant Protection // Der ständige eifrige Schutz eines Vaters
[424641]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106117]= 10}, giver=119236, rew={0,0,0,70}, preq=424594}, -- Always Prepared // Allzeit bereit
[424642]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106118]=  8}, giver=119237, rew={0,0,0,250}, preq=424626}, -- Further Use of Natural Enemies // Der weitere Nutzen natürlicher Feinde
[424643]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106075]=  6}, giver=119238, rew={0,0,0,150}, preq=424628}, -- Pets Extremely Prohibited Inside // Haustiere strengstens verboten
[424644]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240636]=  4}, giver=119238, rew={0,0,0,250}, preq=424630}, -- Collect more Nest Crystals... // Mehr Nest-Kristalle ...
[424645]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[106121]=  5}, giver=119241, rew={0,0,0,200}, preq=424632}, -- Equipment Upgrade // Der neuste Apparat
[424646]={typ=21, lvl=69, rlvl=67, zone= 21, items={[240630]=  5}, giver=119234, rew={0,0,0,200}, preq=424634}, -- More Acting Props // Mehr Requisiten
[424666]={typ=22, lvl=69, rlvl=67, zone= 21, mobs={[103003]=  3}, rew={0,0,0,340}}, -- Deliver to the Residents // Die Bewohner beliefern
--[[ ] ]]

--[[ [ Ancient Kingdom of Rorazan / Altes Königreich von Rorazan (22) ]]
[424863]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240297]= 10}, giver=119680, rew={0,0,0,100}, preq=424812}, -- Fire Flower // Feuerblume
[424878]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240032]=  5}, giver=119635, rew={0,0,0,100}, preq=424871}, -- Secret Worries of the Forest // Geheime Sorgen des Waldes
[424879]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240754]= 10}, giver=119635, rew={0,0,0,55}, preq=424872}, -- Self-Sufficiency // Selbstversorgung
[424880]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240786]=  5}, giver=119646, rew={0,0,0,90}, preq=424873}, -- Calm Heart // Gelassenheit
[424881]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106368]=  3}, giver=119647, rew={0,0,0,100}, preq=424874}, -- Suffering Spirits // Notleidende Geister
[424882]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240790]=  1}, giver=119634, rew={0,0,0,150}, preq=424875}, -- Affected Earth // Betroffene Erde
[425141]={typ=21, lvl=70, rlvl=68, zone= 22, items={[545795]=  1}, giver=119872, rew={0,0,0,80}, preq=425101}, -- Standard Procedure // Standardverfahren
[425142]={typ=21, lvl=70, rlvl=68, zone= 22, items={[545791]=  1}, giver=119872, rew={0,0,0,100}, preq=425102}, -- Mission Delivery // Missionserfüllung
[425143]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106478]= 10}, giver=119857, rew={0,0,0,330}, preq=425103}, -- Unique Environment // Einzigartige Umgebung
[425144]={typ=23, lvl=70, rlvl=68, zone= 22, items={[545792]=  1}, rew={0,0,0,25}, preq=425104}, -- Demonstration Battle // Schaukampf
[425145]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106423]= 10}, giver=119862, rew={0,0,0,120}, preq=425105}, -- Another Battlefield // Ein anderes Schlachtfeld
[425146]={typ=21, lvl=70, rlvl=68, zone= 22, items={[545793]=  1}, giver=119860, rew={0,0,0,150}, preq=425106}, -- The Real Situation // Die wahre Lage
[425147]={typ=21, lvl=70, rlvl=68, zone= 22, items={[545794]=  1}, giver=119862, rew={0,0,0,100}, preq=425107}, -- Too Busy To Eat or Sleep // Keine Zeit zum Essen und Schlafen
[425148]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106424]= 10}, giver=120071, rew={0,0,0,75}, preq=425108}, -- Unbearable Heat // Unerträgliche Hitze
[425149]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106501]= 10}, giver=120072, rew={0,0,0,160}, preq=425109}, -- Take Good Care // Gute Pflege
[425150]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106502]= 10}, giver=120073, rew={0,0,0,80}, preq=425110}, -- Air Raid Warning // Luftalarm
[425151]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106503]= 10}, giver=119858, rew={0,0,0,150}, preq=425111}, -- Seed of Life // Samen des Lebens
[425152]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106504]= 10}, giver=119858, rew={0,0,0,100}, preq=425112}, -- Moderation // Mäßigung
[425153]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240909]= 10}, giver=119873, rew={0,0,0,100}, preq=425113}, -- Water of Blessing // Segenswasser
[425154]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106505]= 10}, giver=119858, rew={0,0,0,150}, preq=425114}, -- Camp Security // Sicherheit des Lagers
[425155]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240955]= 10}, giver=119732, rew={0,0,0,330}, preq=425115}, -- Prisoner Battle // Kampf der Gefangenen
[425156]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106466]= 10}, giver=119946, taker=119871, rew={0,0,0,330}, preq=425116}, -- Next Time Will Be Better // Nächstes Mal wird es besser
[425157]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106506]= 10}, giver=119733, rew={0,0,0,150}, preq=425117}, -- Prison // Gefängnis
[425158]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240967]= 10}, giver=119871, rew={0,0,0,83}, preq=425118}, -- Self Reliance // Eigenständigkeit
[425178]={typ=21, lvl=70, rlvl=68, zone= 22, items={[545835]=  1}, giver=119731, rew={0,0,0,25}, preq=424782}, -- Find an Ailic's Researcher // Einen Ailics Forscher finden
[425179]={typ=21, lvl=70, rlvl=68, zone= 22, items={[240757]=  1,[240758]=  1,[240760]=  2,[240761]=  2}, giver=119732, rew={0,0,0,100}, preq=424783}, -- Further Rune Study // Weiteres Runenstudium
[425180]={typ=21, lvl=70, rlvl=68, zone= 22, items={[545787]=  1}, giver=119946, rew={0,0,0,160}, preq=424784}, -- Sleepwalk Again // Wieder schlafwandeln
[425181]={typ=22, lvl=70, rlvl=68, zone= 22, mobs={[106457]=  3,[106458]=  3}, giver=119733, rew={0,0,0,50}, preq=424785}, -- Heart of Nature and Life // Das Herz der Natur und des Lebens
[425182]={typ= 4, lvl=70, rlvl=68, zone= 22, mobs={[106454]=  3}, giver=119733, rew={0,0,0,100}, preq=424786}, -- Extinguish More Flames // Löscht mehr Flammen
[424605]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240847]= 10}, giver=119360, rew={0,0,0,100}}, -- Elf Medicine // Elfenmedizin
[424606]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240851]= 10}, giver=119363, rew={0,0,0,235}}, -- Guardian Energy Core // Wächter-Energiekern
[424607]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240853]=  1,[240854]=  1,[240855]=  1}, giver=119726, rew={0,0,0,150}, preq=424930}, -- Investigator's Report // Bericht des Ermittlers
[424608]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240856]= 10}, giver=119917, rew={0,0,0,50}, preq=424957}, -- Resource Disappearance // Ressourcenschwund
[424609]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545867]=  1}, giver=119917, rew={0,0,0,350}}, -- Energy Detection // Energie-Entdeckung
[424768]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240766]=  1}, giver=119727, rew={0,0,0,300}}, -- Reinstallation of Recording Equipment // Neuinstallation der Messgeräte
[424769]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106377]= 10}, giver=119923, rew={0,0,0,230}}, -- Keep Slowing Down the Production Process // Verlangsamt weiterhin den Herstellungsprozess
[424770]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240825]=  5,[240978]=  5,[240979]=  5}, giver=119616, rew={0,0,0,230}}, -- Research the Strange Ore // Erforscht das seltsame Erz
[424771]={typ=25, lvl=71, rlvl=69, zone= 22, giver={119617,119618}, rew={0,0,0,100}}, -- Tired Guard // Müde Wache
[424772]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240751]=  5,[240752]=  5}, giver=119727, taker=119613, rew={0,0,0,150}, preq=424768}, -- Piping Hot Lunch // Kochend heißes Mittagessen
[424778]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240755]=  1,[240756]=  1,[545876]=  1,[545877]=  1}, giver=119605, rew={301367,2995,10}, preq=424775}, -- Experiment Materials // Experiment-Materialien
[424779]={typ=21, lvl=71, rlvl=69, zone= 22, items={[546247]=  1}, giver=119606, taker=119605, rew={287668,2995,10}, preq=424774}, -- Massive Guard // Gewaltiger Wächter
[424780]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240297]= 10}, giver=119680, rew={273970,2995,10}, preq=424812}, -- Fire Flower // Feuerblume
[424781]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240296]=  1}, giver=119680, taker=119612, rew={273970,2995,10}, preq=424780}, -- Fireproof Potion // Feuerbeständiger Trank
[424825]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545798]=  1}, giver=119650, taker=119651, rew={273970,2995,10}, preq=424824}, -- Continue to Escort the Injured // Weiterhin sicheres Geleit für die Verletzten
[424826]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545798]=  1}, giver=119650, taker=119651, rew={0,0,0,300}, preq=424824}, -- Continue to Escort the Injured // Weiterhin sicheres Geleit für die Verletzten
[424838]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106438]=  5}, giver=119652, rew={0,0,0,20}, preq=424827}, -- Continue to Save the Wounded // Mehr Verletzte retten
[424839]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240877]=  5,[240878]=  5}, giver=119653, rew={0,0,0,330}, preq=424828}, -- Accelerated Speed // Erhöhte Geschwindigkeit
[424840]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240879]=  5}, giver=119656, rew={0,0,0,150}, preq=424829}, -- Even More Red Flame Grass // Noch mehr Rotflammengras
[424841]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240880]=  5}, giver=119664, rew={0,0,0,60}, preq=424830}, -- Bring some more fresh ones! // Bringt noch ein paar frische Fische!
[424842]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545799]=  1,[545800]=  1,[545801]=  1,[545802]=  1}, giver=119682, rew={0,0,0,130}, preq=424831}, -- Be More Vigilant // Noch wachsamer sein
[424843]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106439]= 10}, giver=119928, rew={0,0,0,300}, preq=424832}, -- Still a Mess // Immer noch Chaos
[424844]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106440]=  5,[106472]=  5}, giver=119666, rew={0,0,0,55}, preq=424833}, -- Help Again with Equipment Repair // Noch einmal bei der Reparatur der Ausrüstung helfen
[424845]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240885]= 10}, giver=119666, rew={0,0,0,150}, preq=424834}, -- Even More Sturdy Wood // Noch stabileres Holz
[424846]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106510]= 10}, giver=119934, rew={0,0,0,300}, preq=424835}, -- Continue to Consolidate Forces // Die Kräfte weiter bündeln
[424847]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106441]=  5}, giver=119730, rew={0,0,0,100}, preq=424836}, -- Secret Weapon Modification // Modifikation der Geheimwaffe
[424848]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240887]= 10}, giver=119730, rew={0,0,0,55}, preq=424837}, -- More Mutual Benefits // Weiterer gegenseitiger Nutzen
[424849]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240886]=  1}, giver=119730, taker=119937, rew={0,0,0,120}, preq=424850}, -- Continue to Meet Each Other's Needs // Weiter gegenseitig Bedürfnisse erfüllen
[424860]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240338]=  1}, giver=119605, rew={0,0,0,360}, preq=424777}, -- More Magical Feathers // Mehr magische Federn
[424861]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240755]=  1,[240756]=  1,[546252]=  1,[546253]=  1}, giver=119605, rew={0,0,0,260}, preq=424775}, -- Experiment Materials // Experiment-Materialien
[424862]={typ=21, lvl=71, rlvl=69, zone= 22, items={[546254]=  1}, giver=119606, taker=119605, rew={0,0,0,160}, preq=424774}, -- Massive Guard // Gewaltiger Wächter
[424864]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240296]=  1}, giver=119680, taker=119612, rew={0,0,0,250}, preq=424863}, -- Fireproof Potion // Feuerbeständiger Trank
[424865]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240337]=  1}, giver=119605, rew={315065,2995,10}, preq=424777}, -- More Magical Feathers // Mehr magische Federn
[424866]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240766]=  1}, giver=119727, rew={273970,2995,10}}, -- Setup of Recording Equipment // Aufstellen der Aufzeichnungsinstrumente
[424867]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106377]= 10}, giver=119923, rew={273970,2995,10}}, -- Slowing Down the Production Process // Verlangsamt den Herstellungsprozess
[424868]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240825]=  5,[240978]=  5,[240979]=  5}, giver=119616, rew={273970,2995,10}}, -- Research the Strange Ore // Erforscht das seltsame Erz
[424869]={typ=25, lvl=71, rlvl=69, zone= 22, giver={119617,119618}, rew={273970,2995,10}}, -- Tired Guard // Müde Wache
[424870]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240751]=  5,[240752]=  5}, giver=119727, taker=119613, rew={273970,2995,10}, preq=424866}, -- Piping Hot Lunch // Kochend heißes Mittagessen
[424884]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240032]=  5}, giver=119635, rew={273970,2995,10}, preq=424871}, -- Secret Worries of the Forest // Geheime Sorgen des Waldes
[424885]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240754]= 10}, giver=119635, rew={273970,2995,10}, preq=424872}, -- Self-Sufficiency // Selbstversorgung
[424886]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240786]=  5}, giver=119646, rew={273970,2995,10}, preq=424873}, -- Calm Heart // Gelassenheit
[424887]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106368]=  3}, giver=119647, rew={273970,2995,10}, preq=424874}, -- Suffering Spirits // Notleidende Geister
[424888]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240790]=  1}, giver=119634, rew={273970,2995,10}, preq=424875}, -- Affected Earth // Betroffene Erde
[424907]={typ=21, lvl=71, rlvl=68, zone= 22, items={[241030]= 10}, giver=119625, rew={273970,2995,10}, preq=424894}, -- Starting With Food // Mit dem Essen beginnen
[424908]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106402]=  5}, giver=119625, rew={273970,2995,10}, preq=424894}, -- Provide Calming Power // Beruhigende Energie liefern
[424909]={typ=21, lvl=71, rlvl=68, zone= 22, items={[241031]=  5}, giver=119625, rew={273970,2995,10}, preq=424894}, -- Scorched Earth // Verbrannte Erde
[424910]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[100394]=  5}, giver=119625, rew={273970,2995,10}, preq=424894}, -- Random Fires // Willkürliche Feuer
[424911]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106637]=  3}, giver=119625, rew={273970,2995,10}, preq=424894}, -- Boundaries // Schneise
[424912]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106415]= 10}, giver=119627, rew={273970,2995,10}, preq=424899}, -- Affected Spirits // Betroffene Geister
[424913]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106420]= 10}, giver=119627, rew={273970,2995,10}, preq=424899}, -- The Spirits' Way Out // Der Ausweg der Geister
[424914]={typ=21, lvl=71, rlvl=68, zone= 22, items={[241024]= 10}, giver=119627, rew={273970,2995,10}, preq=424899}, -- Flame Messenger // Flammenbote
[424915]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106398]= 10}, giver=119631, rew={273970,2995,10}, preq=424906}, -- Clean the Gatefront // Reinigt die Front des Tores
[424916]={typ=21, lvl=71, rlvl=68, zone= 22, items={[241032]=  1,[241033]=  1,[241034]=  1}, giver=119631, rew={273970,2995,10}, preq=424906}, -- Investigate the Great Gate // Untersuchung des Großen Tors
[424917]={typ=21, lvl=71, rlvl=68, zone= 22, items={[241027]=  5}, giver=119631, rew={273970,2995,10}, preq=424906}, -- Rock Samples // Gesteinsproben
[424918]={typ=21, lvl=71, rlvl=68, zone= 22, items={[241028]= 10}, giver=119631, rew={273970,2995,10}, preq=424906}, -- Energy Source // Energiequelle
[424919]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545835]=  1}, giver=119731, rew={273970,2995,10}, preq=424782}, -- Find an Ailic's Researcher // Einen Ailics Forscher finden
[424931]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106375]=  5,[106376]=  5}, giver=119727, rew={0,0,0,235}, preq=424930}, -- Clean Up Operations // Reinigungsmaßnahmen
[424932]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240857]=  5}, giver=119950, rew={0,0,0,150}, preq=424957}, -- Components Scavenger // Teilesammler
[424933]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106426]=  5,[106452]=  5}, giver=119951, rew={0,0,0,200}, preq=424921}, -- Keep on Wrecking // Weitere Zerstörung
[424934]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106374]= 10}, giver=119951, rew={0,0,0,235}, preq=424923}, -- Disrupting Energy Supply // Unterbrochene Energieversorgung
[424935]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240891]=  5,[240892]=  5}, giver=119923, rew={0,0,0,200}}, -- Components War // Krieg um Bauteile
[424936]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106425]= 10}, giver=119951, rew={0,0,0,200}, preq=424924}, -- Cutting Repair Lines // Reparaturnachschub verhindern
[424937]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240893]= 10}, giver=119950, rew={0,0,0,235}, preq=424957}, -- Interceptor Plans // Abfängerpläne
[424938]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240860]=  1,[240861]=  1,[240862]=  1}, giver=119950, rew={0,0,0,150}, preq=424957}, -- Rejected Blueprints // Abgelehnte Pläne
[424942]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240817]= 10}, giver=119360, rew={273970,2995,10}}, -- For the Forest's Future // Für die Zukunft des Waldes
[424943]={typ=11, lvl=71, rlvl=69, zone= 22, items={[240818]=  5,[240819]=  5}, giver=119362, rew={273970,2995,10}}, -- Spell Components // Komponenten des Zaubers
[424944]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545807]=  1}, giver=119363, taker=119730, rew={273970,2995,10}}, -- Energy Transfer // Energietransfer
[424945]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240821]= 10}, giver=119364, rew={273970,2995,10}}, -- Adventurer's Little Helper // Kleiner Helfer für Abenteurer
[424946]={typ=11, lvl=71, rlvl=69, zone= 22, items={[240822]= 10}, giver=119362, rew={273970,2995,10}}, -- Ingredients Sweep // Zutatensuche
[424947]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240823]= 10}, giver=119725, rew={273970,2995,10}}, -- Detoxifying Smelly Fish Grass // Entgiftendes Stinkefischgras
[424948]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240824]= 10}, giver=119721, rew={273970,2995,10}}, -- Maintaining Camp Security // Sorge um die Sicherheit des Lagers
[424949]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240825]= 10}, giver=119722, rew={273970,2995,10}}, -- Using Minerals // Verwendung von Mineralien
[424950]={typ=31, lvl=71, rlvl=69, zone= 22, items={[545808]=  1,[545809]=  1,[545810]=  1,[545811]=  1,[545812]=  1}, giver=119722, rew={273970,2995,10}, preq=424930}, -- The Hrodnor List // Die Hrodnor-Liste
[424985]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106518]= 10}, giver=119682, rew={273970,2995,10}, preq=424995}, -- Concerned Note // Besorgte Notiz
[424986]={typ=22, lvl=71, rlvl= 1, zone= 22, mobs={[106364]= 10}, giver=120042, rew={273970,2995,10}, preq=424996}, -- Pulling Weeds // Unkraut jäten
[424990]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106518]= 10}, giver=119682, rew={0,0,0,150}, preq=424995}, -- Concerned Note // Besorgte Notiz
[424991]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106364]= 10}, giver=120042, rew={0,0,0,250}, preq=424996}, -- Pulling Weeds // Unkraut jäten
[425001]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106438]=  5}, giver=119652, rew={273970,2995,10}, preq=424827}, -- Continue to Save the Wounded // Mehr Verletzte retten
[425002]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240877]=  5,[240878]=  5}, giver=119653, rew={273970,2995,10}, preq=424828}, -- Accelerated Speed // Erhöhte Geschwindigkeit
[425003]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240879]=  5}, giver=119656, rew={273970,2995,10}, preq=424829}, -- Even More Red Flame Grass // Noch mehr Rotflammengras
[425004]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240880]=  5}, giver=119664, rew={273970,2995,10}, preq=424830}, -- Bring some more fresh ones! // Bringt noch ein paar frische Fische!
[425005]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545799]=  1,[545800]=  1,[545801]=  1,[545802]=  1}, giver=119682, rew={273970,2995,10}, preq=424831}, -- Be More Vigilant // Noch wachsamer sein
[425006]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106439]= 10}, giver=119928, rew={273970,2995,10}, preq=424832}, -- Still a Mess // Immer noch Chaos
[425007]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106440]=  5,[106472]=  5}, giver=119666, rew={273970,2995,10}, preq=424833}, -- Help Again with Equipment Repair // Noch einmal bei der Reparatur der Ausrüstung helfen
[425008]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240885]= 10}, giver=119666, rew={273970,2995,10}, preq=424834}, -- Even More Sturdy Wood // Noch stabileres Holz
[425009]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106510]= 10}, giver=119934, rew={273970,2995,10}, preq=424835}, -- Continue to Consolidate Forces // Die Kräfte weiter bündeln
[425010]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106441]=  5}, giver=119730, rew={273970,2995,10}, preq=424836}, -- Secret Weapon Modifications // Modifikation der Geheimwaffe
[425011]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240887]= 10}, giver=119730, rew={273970,2995,10}, preq=424837}, -- More Mutual Benefits // Weiterer gegenseitiger Nutzen
[425012]={typ=25, lvl=71, rlvl=69, zone= 22, giver=119730, taker=119937, rew={273970,2995,10}, preq=424850}, -- Continue to Meet Each Other's Needs // Weiter gegenseitig Bedürfnisse erfüllen
[425121]={typ=21, lvl=71, rlvl=68, zone= 22, items={[545795]=  1}, giver=119872, rew={273970,2995,10}, preq=425101}, -- Standard Procedure // Standardverfahren
[425122]={typ=21, lvl=71, rlvl=68, zone= 22, items={[545791]=  1}, giver=119872, rew={273970,2995,10}, preq=425102}, -- Mission Delivery // Missionserfüllung
[425123]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106478]= 10}, giver=119857, rew={273970,2995,10}, preq=425103}, -- Unique Environment // Einzigartige Umgebung
[425124]={typ=23, lvl=71, rlvl=68, zone= 22, items={[545792]=  1}, giver=119856, rew={273970,2995,10}, preq=425104}, -- Demonstration Battle // Schaukampf
[425125]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106423]= 10}, giver=119862, rew={273970,2995,10}, preq=425105}, -- Another Battlefield // Ein anderes Schlachtfeld
[425126]={typ=21, lvl=71, rlvl=68, zone= 22, items={[545793]=  1}, giver=119860, rew={273970,2995,10}, preq=425106}, -- The Real Situation // Die wahre Lage
[425127]={typ=21, lvl=71, rlvl=68, zone= 22, items={[545794]=  1}, giver=119862, rew={273970,2995,10}, preq=425107}, -- Too Busy To Eat or Sleep // Keine Zeit zum Essen und Schlafen
[425128]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106424]= 10}, giver=120071, rew={273970,2995,10}, preq=425108}, -- Unbearable Heat // Unerträgliche Hitze
[425129]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106501]= 10}, giver=120072, rew={273970,2995,10}, preq=425109}, -- Take Good Care // Gute Pflege
[425130]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106502]= 10}, giver=120073, rew={273970,2995,10}, preq=425110}, -- Air Raid Warning // Luftalarm
[425131]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106503]= 10}, giver=119858, rew={273970,2995,10}, preq=425111}, -- Seed of Life // Samen des Lebens
[425132]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106504]= 10}, giver=119858, rew={273970,2995,10}, preq=425112}, -- Moderation // Mäßigung
[425133]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240909]= 10}, giver=119873, rew={273970,2995,10}, preq=425113}, -- Water of Blessing // Segenswasser
[425134]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106505]= 10}, giver=119858, rew={273970,2995,10}, preq=425114}, -- Camp Security // Sicherheit des Lagers
[425135]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240955]= 10}, giver=119732, rew={273970,2995,10}, preq=425115}, -- Prisoner Battle // Kampf der Gefangenen
[425136]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106466]= 10}, giver=119946, taker=119871, rew={273970,2995,10}, preq=425116}, -- Next Time Will Be Better // Nächstes Mal wird es besser
[425137]={typ=22, lvl=71, rlvl=68, zone= 22, mobs={[106506]= 10}, giver=119733, rew={273970,2995,10}, preq=425117}, -- Prison // Gefängnis
[425138]={typ=21, lvl=71, rlvl=68, zone= 22, items={[240967]= 10}, giver=119871, rew={273970,2995,10}, preq=425118}, -- Self Reliance // Eigenständigkeit
[425183]={typ=21, lvl=71, rlvl=69, zone= 22, items={[240757]=  1,[240758]=  1,[240760]=  2,[240761]=  2}, giver=119732, rew={273970,2995,10}, preq=424783}, -- Further Rune Study // Weiteres Runenstudium
[425184]={typ=21, lvl=71, rlvl=69, zone= 22, items={[545787]=  1}, giver=119946, rew={273970,2995,10}, preq=424784}, -- Sleepwalk Again // Wieder schlafwandeln
[425185]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106457]=  3,[106458]=  3}, giver=119733, rew={273970,2995,10}, preq=424785}, -- Heart of Nature and Life // Das Herz der Natur und des Lebens
[425186]={typ= 4, lvl=71, rlvl=69, zone= 22, mobs={[106454]=  3}, giver=119733, rew={273970,2995,10}, preq=424786}, -- Extinguish More Flames // Löscht mehr Flammen
[425190]={typ=21, lvl=71, rlvl=69, zone= 22, items={[241030]= 10}, giver=119625, rew={0,0,0,70}, preq=424894}, -- Starting With Food // Mit dem Essen beginnen
[425191]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106402]= 10}, giver=119625, rew={0,0,0,70}, preq=424894}, -- Provide Calming Power // Beruhigende Energie liefern
[425192]={typ=21, lvl=71, rlvl=69, zone= 22, items={[241031]=  5}, giver=119625, rew={0,0,0,80}, preq=424894}, -- Scorched Earth // Verbrannte Erde
[425193]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[100394]=  5}, giver=119625, rew={0,0,0,70}, preq=424894}, -- Random Fires // Willkürliche Feuer
[425194]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106637]=  3}, giver=119625, rew={0,0,0,50}, preq=424894}, -- Boundaries // Schneise
[425195]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106415]= 10}, giver=119627, rew={0,0,0,100}, preq=424899}, -- Affected Spirits // Betroffene Geister
[425196]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106420]= 10}, giver=119627, rew={0,0,0,100}, preq=424899}, -- The Spirits' Way Out // Der Ausweg der Geister
[425197]={typ=21, lvl=71, rlvl=69, zone= 22, items={[241024]= 10}, giver=119627, rew={0,0,0,110}, preq=424899}, -- Flame Messenger // Flammenbote
[425198]={typ=22, lvl=71, rlvl=69, zone= 22, mobs={[106398]= 10}, giver=119631, rew={0,0,0,100}, preq=424906}, -- Clean the Gatefront // Reinigt die Front des Tores
[425199]={typ=21, lvl=71, rlvl=69, zone= 22, items={[241032]=  1,[241033]=  1,[241034]=  1}, giver=119631, rew={0,0,0,90}, preq=424906}, -- Investigate the Great Gate // Untersuchung des Großen Tors
[425200]={typ=21, lvl=71, rlvl=69, zone= 22, items={[241027]=  5}, giver=119631, rew={0,0,0,80}, preq=424906}, -- Rock Samples // Gesteinsproben
[425201]={typ=21, lvl=71, rlvl=69, zone= 22, items={[241028]= 10}, giver=119631, rew={0,0,0,100}, preq=424906}, -- Energy Source // Energiequelle
--[[ ] ]]

--[[ [ Chrysalia / Chrysalia (23) ]]
[422924]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241288]= 10}, giver=120489, taker=120475, rew={0,0,0,50}, preq=425426}, -- Wing and a Prayer // Hals- und Beinbruch
[425258]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546230]=  1,[546269]=  1,[546270]=  1}, giver=120276, rew={0,0,0,90}, preq=425243}, -- Secret Herbs and Spices // Geheime Kräuter und Gewürze
[425259]={typ=24, lvl=72, rlvl=70, zone= 23, items={[241190]= 10}, giver=120277, taker=120276, rew={0,0,0,80}, mobs={[106613]= 10}, preq=425244}, -- Eliminate Remodeled Beasts // Vernichtung der umgeformten Bestien
[425260]={typ=24, lvl=72, rlvl=70, zone= 23, items={[241191]= 10}, giver=120277, taker=120276, rew={0,0,0,200}, mobs={[106611]= 10}, preq=425244}, -- Eliminate Enhanced Remodeled Soldiers // Vernichtung der verbesserten umgeformten Soldaten
[425261]={typ=24, lvl=72, rlvl=70, zone= 23, items={[241192]= 10}, giver=120277, taker=120276, rew={0,0,0,280}, mobs={[106612]= 10}, preq=425244}, -- Eliminate Elite Remodeled Soldiers // Vernichtung der umgeformten Elitesoldaten
[425262]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241205]= 10}, giver=120280, rew={0,0,0,80}, preq=425245}, -- The Waterfall's Secret // Das Geheimnis des Wasserfalls
[425263]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546143]=  1,[546144]=  1,[546145]=  1}, giver=120280, rew={0,0,0,95}, preq={425245,425246}}, -- Treating the Oriel Brothers // Die Oriel-Brüder versorgen
[425264]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106614]= 10}, giver=120277, rew={0,0,0,90}, preq=425247}, -- Out of the Frying Pan // Vom Regen in die Traufe
[425282]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241293]= 10}, giver=120762, rew={0,0,0,70}}, -- The Treasure Within // Der Schatz im Inneren
[425288]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241290]= 10}, giver=120489, taker=120790, rew={0,0,0,50}, preq=425442}, -- Chunky Lizard Skin Armor // Grobe Echsenhaut-Rüstung
[425289]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241291]= 10}, giver=120790, rew={0,0,0,50}, preq=425445}, -- Custom-made Armor // Maßgefertigte Rüstung
[425290]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106798]= 10}, giver=120489, taker=120791, rew={0,0,0,70}}, -- Beetle Control // Käferbekämpfung
[425291]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241287]= 10}, giver=120489, taker=120473, rew={0,0,0,50}, preq=425443}, -- Greeny Yellow // Grünliches Gelb
[425292]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241296]= 10}, giver=120717, rew={0,0,0,70}, preq=425431}, -- Trade // Handel
[425416]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546724]=  1}, taker=120281, rew={0,0,0,50}}, -- Memory of Hope // Erinnerung der Hoffnung
[425417]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546724]=  1}, taker=120281, rew={0,0,0,50}}, -- Memory of Bravery // Erinnerung der Tapferkeit
[425418]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546724]=  1}, taker=120281, rew={0,0,0,50}}, -- Memory of Justice // Erinnerung der Gerechtigkeit
[425419]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546724]=  1}, taker=120281, rew={0,0,0,50}}, -- Memory of Wisdom // Erinnerung der Weisheit
[425420]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546724]=  1}, taker=120281, rew={0,0,0,50}}, -- Memory of Love // Erinnerung der Liebe
[425508]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546724]=  1}, taker=120281, rew={0,0,0,50}}, -- Memory of Tolerance // Erinnerung an Toleranz
[425509]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546724]=  1}, taker=120281, rew={0,0,0,50}}, -- Memory of Loyalty // Erinnerung an Loyalität
[425511]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106515]=  5,[106533]=  5}, giver=120673, rew={0,0,0,150}, preq=425265}, -- Cleaning Plan // Reinigungsplan
[425512]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241297]= 10}, giver=120717, rew={0,0,0,70}, preq=425432}, -- Trade II // Handel II
[425513]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241298]= 10}, giver=120717, rew={0,0,0,70}, preq=425433}, -- Trade III // Handel III
[425514]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106801]= 10}, giver=120842, rew={0,0,0,70}, preq=425438}, -- Dangerous Yasheedees // Gefährliche Yasheedees
[425515]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[101238]= 10}, giver=120792, rew={0,0,0,70}, preq=425440}, -- Myrmex Observation Records // Myrmex-Beobachtungsaufzeichnungen
[425516]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241285]=  7,[241286]=  2}, giver=120714, rew={0,0,0,50}, preq=425435}, -- Heaven and Earth Dragon Banquet // Himmlisches Drachenbankett
[425585]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106473]= 10}, giver=120284, rew={0,0,0,100}, preq={425395,425396,425397}}, -- Instant Interception // Sofortige Intervention
[425586]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106805]= 10}, giver=120284, rew={0,0,0,100}, preq={425396,425585}}, -- Watertight // Wasserdicht
[425587]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546290]=  1}, taker=119857, rew={0,0,0,150}, preq={425397,425586}}, -- Accidental Reception // Zufälliger Empfang
[425588]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241322]= 10}, giver=120281, rew={0,0,0,100}, preq={425398,425399}}, -- Ruins Research // Ruinenforschungen
[425589]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241323]=  5}, giver=120281, rew={0,0,0,100}, preq={425399,425588}}, -- Research Obstruction // Behinderung der Untersuchung
[425590]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546298]=  1,[546710]=  1,[546711]=  1}, giver=120722, rew={0,0,0,100}, preq={425402,425403,425404}}, -- Support the Front Lines // Die Front unterstützen
[425591]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106611]= 10}, giver=120722, rew={0,0,0,100}, preq={425403,425590}}, -- Hold Ground // Standortverteidigung
[425592]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106613]= 10}, giver=120722, rew={0,0,0,100}, preq={425404,425591}}, -- Fireline Mission // Mission in der Schusslinie
[425593]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106808]= 10}, giver=120736, rew={0,0,0,100}, preq={425405,425406,425407,425408}}, -- Immediate Treatment // Sofortige Behandlung
[425594]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241280]= 10}, giver=120736, rew={0,0,0,100}, preq={425406,425593}}, -- Special Medicine // Spezialmedikament
[425595]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106619]= 10}, giver=120736, rew={0,0,0,200}, preq={425407,425594}}, -- Wonderful Effect // Wunderbarer Effekt
[425596]={typ=25, lvl=72, rlvl=70, zone= 23, taker=119857, rew={0,0,0,150}, preq={425408,425595}}, -- Healer's Heart // Herz eines Heilers
[425597]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241324]=  1}, giver=120273, rew={0,0,0,100}, preq={425409,425410,425411,425412}}, -- Unknown Energy // Unbekannte Energie
[425598]={typ=21, lvl=72, rlvl=70, zone= 23, items={[546297]=  1}, giver=120273, taker=120281, rew={0,0,0,50}, preq={425410,425597}}, -- Final Analysis // Finale Analyse
[425599]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241325]= 10}, giver=120281, rew={0,0,0,100}, preq={425411,425598}}, -- Local Resources // Lokale Ressourcen
[425600]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106807]=  5}, giver=120281, taker=120273, rew={0,0,0,200}, preq={425412,425599}}, -- Crush the Conspiracy // Die Verschwörung zerschlagen
[425601]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106612]= 10}, giver=120273, rew={0,0,0,100}, preq={425413,425414}}, -- Key Moment // Schlüsselmoment
[425602]={typ=21, lvl=72, rlvl=70, zone= 23, items={[241279]= 10}, giver=120273, rew={0,0,0,100}, preq={425414,425601}}, -- Potential Threat // Potenzielle Bedrohung
[425603]={typ=22, lvl=72, rlvl=70, zone= 23, mobs={[106620]=  1}, giver=120273, rew={0,0,0,530}, preq=425415}, -- Decapitation // Enthauptung
[422919]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241293]= 10}, giver=120762, rew={296553,3222,10}}, -- The Treasure Within // Der Schatz im Inneren
[425298]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241227]=  3,[241228]=  3}, giver=120771, rew={0,0,0,100}, preq=425297}, -- Local Supplement Supplies // Lokale Vorratsaufstockung
[425299]={typ=22, lvl=73, rlvl=71, zone= 23, mobs={[106862]=  1,[106886]=  1}, giver=120492, rew={0,0,0,100}, preq=425297}, -- Deal With Death // Sich des Todes annehmen
[425300]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241229]=  3}, giver=120492, taker=120575, rew={0,0,0,100}, preq=425297}, -- Ongoing Research // Forschungen fortsetzen
[425301]={typ=22, lvl=73, rlvl=71, zone= 23, mobs={[106860]= 10}, giver=120492, rew={0,0,0,100}, preq=425297}, -- Endless Supply of Morale // Endloser Vorrat an Kampfmoral
[425302]={typ=24, lvl=73, rlvl=71, zone= 23, items={[546503]=  1}, giver=120492, rew={0,0,0,100}, mobs={[106861]=  1}, preq=425297}, -- Friendly Partner // Freundliche Partner
[425460]={typ=21, lvl=73, rlvl=71, zone= 23, items={[546242]=  1}, giver=120518, rew={0,0,0,250}, preq=424958}, -- Killer in the Midst // Mörder in der Mitte
[425461]={typ=21, lvl=73, rlvl=71, zone= 23, items={[240980]= 10}, giver=120520, rew={0,0,0,80}, preq=424959}, -- More Simulations // Mehr Simulationen
[425462]={typ=21, lvl=73, rlvl=71, zone= 23, items={[240895]= 10}, giver=120521, rew={0,0,0,150}, preq=425235}, -- Myrmex Eating Arts // Die Kunst der Myrmexernährung
[425463]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241194]=  5}, giver=120562, rew={0,0,0,30}, preq=425236}, -- Partner Potion // Freundschaftstrank
[425464]={typ=22, lvl=73, rlvl=71, zone= 23, mobs={[106733]=  5}, giver=120563, rew={0,0,0,50}, preq=425237}, -- Adjust The Instrument // Instrumenteneinstellung
[425465]={typ=22, lvl=73, rlvl=71, zone= 23, mobs={[106533]= 10}, giver=120564, rew={0,0,0,230}, preq=425238}, -- Feeding, Do Not Disturb // Fütterung - Bitte nicht stören!
[425466]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241203]=  5}, giver=120565, rew={0,0,0,50}, preq=425239}, -- Hotbed of Incubation // Brutstätte
[425467]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241195]= 10}, giver=120575, rew={0,0,0,50}, preq=425240}, -- Local Medicine // Heilmittel aus der Gegend
[425468]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241201]=  1}, giver=120496, rew={0,0,0,100}, preq=425241}, -- Busy, But Still Need To Eat // Beschäftigt, muss aber immer noch essen
[425469]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241266]=  5}, giver=120575, rew={0,0,0,100}, preq=425242}, -- Protect Oneself Before Saving Others // Man schütze sich selbst, bevor man andere rettet.
[425470]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241267]= 10}, giver=120700, rew={0,0,0,100}, preq=425270}, -- Myrmex Queen's Health // Die Gesundheit der Myrmex-Königin
[425471]={typ=22, lvl=73, rlvl=71, zone= 23, mobs={[106830]=  3}, giver=120521, rew={0,0,0,30}, preq=425271}, -- Nutrients For Growth // Wachstumsnährstoffe
[425472]={typ=21, lvl=73, rlvl=71, zone= 23, items={[241272]=  1}, giver=120700, rew={0,0,0,30}, preq=425272}, -- Reciprocity // Wechselwirkung
[425473]={typ=22, lvl=73, rlvl=71, zone= 23, mobs={[107058]= 10}, giver=120678, rew={0,0,0,150}, preq=425273}, -- Garon Funerals // Garon-Beerdigungen
[422918]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241288]= 10}, giver=120489, taker=120475, rew={308533,3485,10}, preq=425426}, -- Wing and a Prayer // Hals- und Beinbruch
[422920]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241290]= 10}, giver=120489, taker=120790, rew={308533,3485,10}, preq=425442}, -- Chunky Lizard Skin Armor // Grobe Echsenhaut-Rüstung
[422921]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241291]= 10}, giver=120790, rew={308533,3485,10}, preq=425445}, -- Custom-made Armor // Maßgefertigte Rüstung
[422922]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106798]= 10}, giver=120489, taker=120791, rew={308533,3485,10}}, -- Beetle Control // Käferbekämpfung
[422923]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241287]= 10}, giver=120489, taker=120473, rew={308533,3485,10}, preq=425443}, -- Greeny Yellow // Grünliches Gelb
[423488]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241296]= 10}, giver=120717, rew={308533,3485,10}, preq=425431}, -- Trade // Handel
[423489]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241297]= 10}, giver=120717, rew={308533,3485,10}, preq=425432}, -- Trade II // Handel II
[423490]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241298]= 10}, giver=120717, rew={308533,3485,10}, preq=425433}, -- Trade III // Handel III
[425176]={typ= 1, lvl=74, rlvl=72, zone= 23, items={[546230]=  1,[546269]=  1,[546270]=  1}, giver=120276, rew={308533,3485,10}, preq=425243}, -- Secret Herbs and Spices // Geheime Kräuter und Gewürze
[425177]={typ= 1, lvl=74, rlvl=72, zone= 23, items={[241189]= 10}, giver=120277, taker=120276, rew={308533,3485,10}, preq=425244}, -- Eliminate Remodeled Beasts // Vernichtung der umgeformten Bestien
[425202]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241205]= 10}, giver=120280, rew={308533,3485,10}, preq=425245}, -- The Waterfall's Secret // Das Geheimnis des Wasserfalls
[425203]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546143]=  1,[546144]=  1,[546145]=  1}, giver=120280, rew={308533,3485,10}, preq={425245,425246}}, -- Treating the Oriel Brothers // Die Oriel-Brüder versorgen
[425204]={typ= 1, lvl=74, rlvl=72, zone= 23, giver=120277, rew={308533,3485,10}, preq=425247}, -- Out of the Frying Pan // Vom Regen in die Traufe
[425278]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106801]= 10}, giver=120842, rew={308533,3485,10}, preq=425438}, -- Dangerous Yasheedees // Gefährliche Yasheedees
[425279]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101238]= 10}, giver=120792, rew={308533,3485,10}, preq=425440}, -- Myrmex Observation Records // Myrmex-Beobachtungsaufzeichnungen
[425280]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241285]=  7,[241286]=  2}, giver=120714, rew={308533,3485,10}, preq=425435}, -- Heaven and Earth Dragon Banquet // Himmlisches Drachenbankett
[425303]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241227]=  3,[241228]=  3}, giver=120771, rew={308533,3485,10}, preq=425297}, -- More Backup Supplies // Weitere Hilfsvorräte
[425304]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106862]=  1,[106886]=  1}, giver=120492, rew={308533,3485,10}, preq=425297}, -- Deal With Death // Sich des Todes annehmen
[425305]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241229]=  3}, giver=120492, taker=120575, rew={308533,3485,10}, preq=425297}, -- Ongoing Research // Forschungen fortsetzen
[425306]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106860]= 10}, giver=120492, rew={308533,3485,10}, preq=425297}, -- Endless Supply of Morale // Endloser Vorrat an Kampfmoral
[425307]={typ=34, lvl=74, rlvl=72, zone= 23, items={[546503]=  1}, giver=120492, rew={308533,3485,10}, mobs={[106861]=  1}, preq=425297}, -- Friendly Partner // Freundliche Partner
[425321]={typ=21, lvl=74, rlvl=71, zone= 23, items={[241181]=  3}, giver=120492, rew={308533,3485,10}, preq=425175}, -- Scorched Earth // Verbrannte Erde
[425322]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101244]=  8}, giver=120606, rew={308533,3485,10}, preq=425308}, -- Dignity of the Fallen // Würde der Gefallenen
[425323]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106772]=  7}, giver=120634, rew={308533,3485,10}, preq=425313}, -- Greasing the Gears // Wie geschmiert
[425324]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106773]=  2}, giver=120634, rew={308533,3485,10}}, -- The Omega Platform Cannot Fall // Die Omega-Plattform darf nicht fallen
[425325]={typ=21, lvl=74, rlvl=72, zone= 23, items={[240797]= 30}, giver=120634, rew={308533,3485,10}, preq=425313}, -- The Key Crystal // Der Schlüsselkristall
[425326]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101240]= 10}, giver=120634, rew={308533,3485,10}}, -- Charge up: Alliance Warriors // Aufladen: Bündniskrieger
[425327]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101241]=  5}, giver=120634, rew={308533,3485,10}}, -- Charge Up: Defense Crystal // Aufladen: Verteidigungskristall
[425328]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101242]= 10}, giver=120606, rew={308533,3485,10}, preq=425319}, -- Kill Them All! // Tötet sie alle!
[425329]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101242]=  5}, giver=120492, rew={308533,3485,10}}, -- Intense Strike // Harter Schlag
[425330]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101243]=  5}, giver=120606, rew={308533,3485,10}, preq=425319}, -- Maintaining Battle Capacity // Erhaltung der Kampfkraft
[425331]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106865]=  1}, giver=120606, rew={308533,3485,10}}, -- Stomp It! // Zermalmt sie!
[425332]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[102374]=  8}, giver=120606, rew={308533,3485,10}, preq=425319}, -- Beacon on a Bloody Path // Leuchtfeuer auf einem blutigen Pfad
[425333]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[102375]=  8}, giver=120606, rew={308533,3485,10}}, -- Standing Amongst the Corpses // Aufrecht zwischen Leichen
[425334]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[107202]=  1}, giver=120605, rew={308533,3485,10}, preq=425320}, -- The Truth Behind the Kulech Myrmex Attack // Die Wahrheit über den Kulech-Myrmex-Angriff
[425336]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[101244]=  8}, giver=120606, rew={0,0,0,150}, preq=425308}, -- Dignity of the Fallen // Würde der Gefallenen
[425337]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[106772]=  7}, giver=120634, rew={0,0,0,150}, preq=425313}, -- Greasing the Gears // Wie geschmiert?
[425338]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[106773]=  2}, giver=120634, rew={0,0,0,250}}, -- The Omega Platform Cannot Fall // Die Omega-Plattform darf nicht fallen
[425339]={typ=21, lvl=74, rlvl=71, zone= 23, items={[240797]= 30}, giver=120634, rew={0,0,0,200}, preq=425313}, -- The Key Crystal // Der Schlüsselkristall
[425340]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[101240]= 10}, giver=120634, rew={0,0,0,300}}, -- Charge up: Alliance Warriors // Aufladen: Bündniskrieger
[425341]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[101241]=  5}, giver=120634, rew={0,0,0,130}}, -- Charge Up: Defense Crystal // Aufladen: Verteidigungskristall
[425342]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[101242]= 10}, giver=120606, rew={0,0,0,280}, preq=425319}, -- Kill Them All! // Tötet sie alle!
[425343]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[101242]=  5}, giver=120492, rew={0,0,0,180}}, -- Intense Strikes // Harte Schläge
[425344]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[101243]=  5}, giver=120606, rew={0,0,0,100}, preq=425319}, -- Maintaining Battle Capacity // Erhaltung der Kampfkraft
[425345]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[106865]=  1}, giver=120606, rew={0,0,0,230}}, -- Stomp It! // Zermalmt sie!
[425346]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[102374]=  8}, giver=120606, rew={0,0,0,70}, preq=425319}, -- Beacon on a Bloody Path // Leuchtfeuer auf einem blutigen Pfad
[425347]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[102375]=  8}, giver=120606, rew={0,0,0,200}}, -- Standing Amongst the Corpses // Aufrecht zwischen Leichen
[425348]={typ=22, lvl=74, rlvl=71, zone= 23, mobs={[107202]=  1}, giver=120605, rew={0,0,0,780}, preq=425320}, -- The Truth Behind the Kulech Myrmex Attack // Die Wahrheit über den Kulech-Myrmex-Angriff
[425349]={typ=21, lvl=74, rlvl=71, zone= 23, items={[241181]=  3}, giver=120492, rew={0,0,0,100}, preq=425175}, -- Scorched Earth // Verbrannte Erde
[425364]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106895]=  8}, giver=119111, rew={308533,3485,10}, preq=425359}, -- Gaining the Upper Hand // Die Oberhand gewinnen
[425365]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[107118]=  5}, giver=119111, rew={308533,3485,10}, preq=425359}, -- Routing the Enemy // Den Feind überwältigen
[425366]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106722]=  8}, giver=119111, rew={308533,3485,10}, preq=425359}, -- Fortune Favors the Bold // Das Glück ist mit den Tapferen
[425367]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106739]=  4}, giver=119111, rew={308533,3485,10}, preq=425359}, -- False Trail // Falsche Spuren
[425368]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[107117]=  5}, giver=120574, rew={308533,3485,10}, preq=425359}, -- Last Line of Defense // Letzte Verteidigungslinie
[425369]={typ=21, lvl=74, rlvl=72, zone= 23, items={[209471]= 10}, giver=120574, taker=120579, rew={308533,3485,10}, preq=425359}, -- Enemy Disguises // Tarnung der Gegner
[425370]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106726]= 10}, giver=121027, rew={308533,3485,10}, preq=425362}, -- Unwanted Enemy // Unerwünschte Feinde
[425371]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106722]=  8}, giver=121027, rew={308533,3485,10}, preq=425362}, -- Pushback // Den Feind zurückdrängen
[425372]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106723]=  8}, giver=121027, rew={308533,3485,10}}, -- Surprise Attack // Überraschungsangriff
[425373]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101499]=  3}, giver=119111, rew={308533,3485,10}, preq=425359}, -- Rebuilding Defenses // Verteidigung wieder aufbauen
[425374]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101299]=  4}, giver=121027, rew={308533,3485,10}, preq=425362}, -- Cutting Off Troop Supply // Den Nachschub unterbrechen
[425375]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101300]=  4}, giver=121027, rew={308533,3485,10}, preq=425362}, -- Nipping It in the Bud // Im Keim ersticken
[425376]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101301]=  1}, giver=121027, rew={308533,3485,10}, preq=425362}, -- Attack Preparations // Angriffsvorbereitungen
[425377]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106887]=  1}, giver=120577, rew={308533,3485,10}, preq=425363}, -- Sacrifice // Opfer
[425378]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106895]=  8}, giver=119111, rew={0,0,0,200}, preq=425359}, -- Gaining the Upper Hand // Die Oberhand gewinnen
[425379]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[107118]=  5}, giver=119111, rew={0,0,0,100}, preq=425359}, -- Routing the Enemy // Den Feind überwältigen
[425380]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106722]=  8}, giver=119111, rew={0,0,0,120}, preq=425359}, -- Fortune Favors the Bold // Das Glück ist mit den Tapferen
[425381]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106739]=  4}, giver=119111, rew={0,0,0,70}, preq=425359}, -- False Trail // Falsche Spuren
[425382]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[107117]=  5}, giver=120574, rew={0,0,0,100}, preq=425359}, -- Last Line of Defense // Letzte Verteidigungslinie
[425383]={typ=21, lvl=74, rlvl=72, zone= 23, items={[209471]= 10}, giver=120574, taker=120579, rew={0,0,0,40}, preq=425359}, -- Enemy Disguises // Täuschung der Gegner
[425384]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106726]= 10}, giver=121027, rew={0,0,0,100}, preq=425362}, -- Unwanted Enemy // Unerwünschte Feinde
[425385]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106722]=  8}, giver=121027, rew={0,0,0,80}, preq=425362}, -- Pushback // Den Feind zurückdrängen
[425386]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106723]=  2}, giver=121027, rew={0,0,0,100}}, -- Surprise Attack // Überraschungsangriff
[425387]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101499]=  3}, giver=119111, rew={0,0,0,70}, preq=425359}, -- Rebuilding Defenses // Verteidigung wieder aufbauen
[425388]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101299]=  4}, giver=121027, rew={0,0,0,200}, preq=425362}, -- Cutting Off Troop Supply // Den Nachschub unterbrechen
[425389]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101300]=  4}, giver=121027, rew={0,0,0,200}, preq=425362}, -- Nipping It in the Bud // Im Keim ersticken
[425390]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[101301]=  1}, giver=121027, rew={0,0,0,120}, preq=425362}, -- Attack Preparations // Angriffsvorbereitungen
[425391]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106887]=  1}, giver=120577, rew={0,0,0,780}, preq=425363}, -- Sacrifice // Opfer
[425446]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546242]=  1}, giver=120518, rew={308533,3485,10}, preq=424958}, -- Killer in the Midst // Mörder in der Mitte
[425447]={typ=21, lvl=74, rlvl=72, zone= 23, items={[240980]= 10}, giver=120520, rew={308533,3485,10}, preq=424959}, -- More Simulations // Mehr Simulationen
[425448]={typ=21, lvl=74, rlvl=72, zone= 23, items={[240895]= 10}, giver=120521, rew={308533,3485,10}, preq=425235}, -- Myrmex Eating Art // Die Kunst der Myrmexernährung
[425449]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241194]=  5}, giver=120562, rew={308533,3485,10}, preq=425236}, -- Partner Potion // Freundschaftstrank
[425450]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106733]=  5}, giver=120563, rew={308533,3485,10}, preq=425237}, -- Adjust The Instrument // Instrumenteneinstellung
[425451]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106533]= 10}, giver=120564, rew={308533,3485,10}, preq=425238}, -- Feeding, Do Not Disturb // Fütterung - Bitte nicht stören!
[425452]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241203]=  5}, giver=120565, rew={308533,3485,10}, preq=425239}, -- Hotbed of Incubation // Brutstätte
[425453]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241195]= 10}, giver=120575, rew={308533,3485,10}, preq=425240}, -- Local Medicine // Heilmittel aus der Gegend
[425454]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241201]=  1}, giver=120496, rew={308533,3485,10}, preq=425241}, -- Busy, But Still Need To Eat // Beschäftigt, muss aber immer noch essen
[425455]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241266]=  5}, giver=120575, rew={308533,3485,10}, preq=425242}, -- Protect Oneself Before Saving Others // Man schütze sich selbst, bevor man andere rettet.
[425456]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241267]= 10}, giver=120700, rew={308533,3485,10}, preq=425270}, -- Myrmex Queen's Health // Die Gesundheit der Myrmex-Königin
[425457]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106830]=  3}, giver=120521, rew={308533,3485,10}, preq=425271}, -- Nutrients For Growth // Wachstumsnährstoffe
[425458]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241272]=  1}, giver=120700, rew={308533,3485,10}, preq=425272}, -- Reciprocity // Wechselwirkung
[425459]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[107058]= 10}, giver=120678, rew={308533,3485,10}, preq=425273}, -- Garon Funeral // Garon-Beerdigung
[425480]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241193]= 10,[546243]=  1}, giver=120581, rew={0,0,0,80}, preq=425248}, -- Speed Is The Winner // Schnelligkeit gewinnt
[425481]={typ= 4, lvl=74, rlvl=72, zone= 23, items={[546245]=  1}, giver=120577, rew={0,0,0,50}, preq=425249}, -- Keeping the Veiled Encampment Disguised // Das Schattenlager verborgen halten
[425482]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106719]= 10}, giver=120578, rew={0,0,0,230}, preq=425250}, -- Kulech Food // Kulech-Nahrung
[425483]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241202]= 10}, giver=120579, rew={0,0,0,80}, preq=425251}, -- Extracted From Blood // Blutextrakt
[425484]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106722]=  5,[106723]=  2}, giver=120578, rew={0,0,0,230}, preq=425252}, -- Continued Assistance: Kill Enemies // Weitere Hilfe: Tötet Feinde
[425485]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546256]=  1}, giver=120579, rew={0,0,0,300}, preq=425253}, -- Continued Assistance: Research // Weitere Hilfe: Forschung
[425486]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106728]= 10}, giver=120578, rew={0,0,0,230}, preq=425254}, -- Myrmex Backstab // Myrmex-Stoß in den Rücken
[425487]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546283]=  1}, giver=120649, rew={0,0,0,100}, preq=425255}, -- Supreme Efficiency // Höchste Effizienz
[425488]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546284]=  1}, giver=120649, rew={0,0,0,80}, preq=425256}, -- Enter the Myrmex initiating team // Schließt Euch dem Myrmex-Startteam an.
[425489]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241270]= 10}, giver=120577, rew={0,0,0,150}, preq=425257}, -- Insistence on Materials // Bestehen auf Materialien
[425490]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241271]= 10}, taker=120578, rew={0,0,0,50}, preq=425274}, -- Last Luck // Letztes Glück
[425491]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241330]= 10}, giver=120709, rew={0,0,0,80}, preq=425275}, -- Recycle and Reuse // Aufbereitung und Wiederverwertung
[425492]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106828]=  4}, giver=120581, rew={0,0,0,300}, preq=425276}, -- Plan Destroyer // Planzerstörer
[425493]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241329]=  5}, taker=120649, rew={0,0,0,50}, preq=425277}, -- Smuggled Myrmex Eggs // Geschmuggelte Myrmex-Eier
[425494]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241193]= 10,[546243]=  1}, giver=120581, rew={308533,3485,10}, preq=425248}, -- Speed Is The Winner // Schnelligkeit gewinnt
[425495]={typ= 4, lvl=74, rlvl=72, zone= 23, items={[546245]=  1}, giver=120577, rew={308533,3485,10}, preq=425249}, -- Keeping the Veiled Encampment Disguised // Das Schattenlager verborgen halten
[425496]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106719]= 10}, giver=120578, rew={308533,3485,10}, preq=425250}, -- Kulech Food // Kulech-Nahrung
[425497]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241202]= 10}, giver=120579, rew={308533,3485,10}, preq=425251}, -- Extracted From Blood // Blutextrakt
[425498]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106722]=  5,[106723]=  2}, giver=120578, rew={308533,3485,10}, preq=425252}, -- Continued Assistance: Kill Enemies // Weitere Hilfe: Tötet Feinde
[425499]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546256]=  1}, giver=120579, rew={308533,3485,10}, preq=425253}, -- Continued Assistance: Research // Weitere Hilfe: Forschung
[425500]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106728]= 10}, giver=120578, rew={308533,3485,10}, preq=425254}, -- Myrmex Backstab // Myrmex-Stoß in den Rücken
[425501]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546283]=  1}, giver=120649, rew={308533,3485,10}, preq=425255}, -- Supreme Efficiency // Höchste Effizienz
[425502]={typ=21, lvl=74, rlvl=72, zone= 23, items={[546284]=  1}, giver=120649, rew={308533,3485,10}, preq=425256}, -- Enter the Myrmex initiating team // Schließt Euch dem Myrmex-Startteam an.
[425503]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241270]= 10}, giver=120577, rew={308533,3485,10}, preq=425257}, -- Insistence on Materials // Bestehen auf Materialien
[425504]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241271]= 10}, taker=120578, rew={308533,3485,10}, preq=425274}, -- Last Luck // Letztes Glück
[425505]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241330]= 10}, giver=120709, rew={308533,3485,10}, preq=425275}, -- Recycle and Reuse // Aufbereitung und Wiederverwertung
[425506]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106828]=  4}, giver=120581, rew={308533,3485,10}, preq=425276}, -- Plan Destroyer // Planzerstörer
[425507]={typ=21, lvl=74, rlvl=72, zone= 23, items={[241329]=  5}, taker=120649, rew={308533,3485,10}, preq=425277}, -- Smuggled Myrmex Eggs // Geschmuggelte Myrmex-Eier
[425510]={typ=22, lvl=74, rlvl=72, zone= 23, mobs={[106515]=  5,[106533]=  5}, giver=120673, rew={308533,3485,10}, preq=425265}, -- Cleaning Plan // Reinigungsplan
[425604]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106473]= 10}, giver=120284, rew={308533,3485,10}, preq={425395,425396,425397}}, -- Instant Interception // Sofortige Intervention
[425605]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106805]= 10}, giver=120284, rew={308533,3485,10}, preq={425396,425604}}, -- Watertight // Wasserdicht
[425606]={typ=31, lvl=74, rlvl=72, zone= 23, items={[546290]=  1}, giver=120284, taker=119857, rew={308533,3485,10}, preq={425397,425605}}, -- Accidental Reception // Zufälliger Empfang
[425607]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241322]= 10}, giver=120281, rew={308533,3485,10}, preq={425398,425399}}, -- Ruins Research // Ruinenforschungen
[425608]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241323]=  5}, giver=120281, rew={308533,3485,10}, preq={425399,425607}}, -- Research Obstruction // Behinderung der Untersuchung
[425609]={typ=31, lvl=74, rlvl=72, zone= 23, items={[546298]=  1,[546710]=  1,[546711]=  1}, giver=120722, rew={308533,3485,10}, preq={425402,425403,425404}}, -- Support the Front Lines // Die Front unterstützen
[425610]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106611]= 10}, giver=120722, rew={308533,3485,10}, preq={425403,425609}}, -- Hold Ground // Standortverteidigung
[425611]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106613]= 10}, giver=120722, rew={308533,3485,10}, preq={425404,425610}}, -- Fireline Mission // Mission in der Schusslinie
[425612]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106808]= 10}, giver=120736, rew={308533,3485,10}, preq={425405,425406,425407,425408}}, -- Immediate Treatment // Sofortige Behandlung
[425613]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241280]= 10}, giver=120736, rew={308533,3485,10}, preq={425406,425612}}, -- Special Medicine // Spezialmedikament
[425614]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106619]= 10}, giver=120736, rew={308533,3485,10}, preq={425407,425613}}, -- Wonderful Effect // Wunderbarer Effekt
[425615]={typ=35, lvl=74, rlvl=72, zone= 23, giver=120736, taker=119857, rew={308533,3485,10}, preq={425408,425614}}, -- Healer's Heart // Herz eines Heilers
[425616]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241324]=  1}, giver=120273, rew={308533,3485,10}, preq={425409,425410,425411,425412}}, -- Unknown Energy // Unbekannte Energie
[425617]={typ=31, lvl=74, rlvl=72, zone= 23, items={[546297]=  1}, giver=120273, taker=120281, rew={308533,3485,10}, preq={425410,425616}}, -- Final Analysis // Finale Analyse
[425618]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241325]= 10}, giver=120281, rew={308533,3485,10}, preq={425411,425617}}, -- Local Resources // Lokale Ressourcen
[425619]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106807]=  5}, giver=120281, taker=120273, rew={308533,3485,10}, preq={425412,425618}}, -- Crush the Conspiracy // Die Verschwörung zerschlagen
[425620]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106612]= 10}, giver=120273, rew={308533,3485,10}, preq={425413,425414}}, -- Key Moment // Schlüsselmoment
[425621]={typ=31, lvl=74, rlvl=72, zone= 23, items={[241279]= 10}, giver=120273, rew={308533,3485,10}, preq={425414,425620}}, -- Potential Threat // Potenzielle Bedrohung
[425622]={typ=32, lvl=74, rlvl=72, zone= 23, mobs={[106620]=  1}, giver=120273, rew={308533,3485,10}, preq=425415}, -- Decapitation // Enthauptung
--[[ ] ]]

--[[ [ Merdhin Tundra / Merdhin-Tundra (24) ]]
[425584]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241328]= 10}, giver=121142, rew={0,0,0,50}, preq=425553}, -- Need to Know Herbs // Kräuter, die man kennen muss
[425662]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107111]=  5}, giver=121120, rew={333965,3877,10}, preq=425625}, -- Continuous Strikes // Fortgesetzte Angriffe
[425663]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107112]= 10}, giver=121120, rew={333965,3877,10}, preq=425626}, -- Indirect Combat // Indirekter Kampf
[425664]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107115]=  5}, giver=121120, rew={333965,3877,10}, preq=425627}, -- Disastrous Backfire // Katastrophaler Rückstoß
[425665]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107116]=  5}, giver=121122, rew={333965,3877,10}, preq=425629}, -- Maintaining Battle Strength // Erhalten der Kampfstärke
[425666]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241353]= 10}, giver=121123, rew={333965,3877,10}, preq=425646}, -- Assistance Repair // Hilfsreparaturen
[425667]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241354]= 10}, giver=121123, rew={333965,3877,10}}, -- Reducing Losses // Verringerung der Verluste
[425668]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241355]=  5}, giver=121124, rew={333965,3877,10}}, -- Core Research // Kern-Forschung
[425669]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[106618]=  1}, giver=121124, rew={333965,3877,10}, preq={425668,425658}}, -- Instant Transmission // Sofort-Übertragung
[425670]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241356]= 10}, giver=121124, rew={333965,3877,10}}, -- Prison Runes // Kerkerrunen
[425671]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[106852]=  5}, giver=121124, rew={333965,3877,10}, preq={425670,425660}}, -- Jailbreak Stone // Ausbruchsstein
[425724]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241328]= 10}, giver=121142, rew={333965,3877,10}, preq=425553}, -- Need to Know Herbs // Kräuter, die man kennen muss
[425725]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241314]= 10}, giver=121068, rew={333965,3877,10}, preq=425555}, -- Miracle Cure // Wunderheilmittel
[425726]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107152]= 10}, giver=121210, rew={333965,3877,10}, preq=425556}, -- Eliminating the Frenzied Ones // Eliminieren der Rasenden
[425727]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107081]=  8}, giver=121211, rew={333965,3877,10}, preq=425557}, -- Wrath of the Forest // Zorn des Waldes
[425728]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107079]=  3}, giver=121211, rew={333965,3877,10}, preq=425558}, -- Woodland Delirium // Wahn des Waldes
[425729]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107083]=  8}, giver=121211, rew={333965,3877,10}, preq=425559}, -- Woodland Disgust // Abscheu des Waldes
[425730]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107082]=  8}, giver=121212, rew={333965,3877,10}, preq=425560}, -- Woodland Distrust // Misstrauen des Waldes
[425731]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241313]= 10}, giver=121133, rew={333965,3877,10}, preq=425561}, -- Conversation Bridge // Konversationsbrücke
[425732]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241311]= 10}, giver=121214, rew={333965,3877,10}, preq=425562}, -- Pure Nature's Power // Reine Naturmacht
[425733]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241312]=  8}, giver=121215, rew={333965,3877,10}, preq=425563}, -- Capra and Carts // Capra und Karren
[425734]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107195]=  5}, giver=121217, rew={333965,3877,10}, preq=425565}, -- Tilling Hope // Hoffnung des Pflügens
[425735]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241698]= 10}, giver=121217, rew={333965,3877,10}, preq=425568}, -- Foul Remains // Üble Rückstände
[425736]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241700]= 10}, giver=121210, rew={333965,3877,10}, preq=425570}, -- Notes from Experience // Notizen aus Erfahrung
[425737]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241815]= 10}, giver=121214, rew={333965,3877,10}, preq=425571}, -- The Story of our Forefathers // Die Geschichte unserer Vorväter
[425739]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241812]=  5}, giver=121323, rew={333965,3877,10}, preq=425578}, -- Ice Crystal of the Cold Palace // Eiskristall des kalten Palasts
[425740]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241704]= 10}, giver=121297, rew={333965,3877,10}, preq=425688}, -- A Long, Long Time Ago // Vor langer, langer Zeit
[425744]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241314]= 10}, giver=121068, rew={0,0,0,50}, preq=425555}, -- Miracle Cure // Wunderheilmittel
[425745]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107152]= 10}, giver=121210, rew={0,0,0,200}, preq=425556}, -- Eliminating the Frenzied Ones // Eliminieren der Rasenden
[425750]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241313]= 10}, giver=121133, rew={0,0,0,50}, preq=425561}, -- Conversation Bridge // Konversationsbrücke
[425751]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241311]= 10}, giver=121214, rew={0,0,0,50}, preq=425562}, -- Pure Nature's Power // Reine Naturmacht
[425752]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241312]=  8}, giver=121215, rew={0,0,0,50}, preq=425563}, -- Capra and Carts // Capra und Karren
[425753]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107195]=  5}, giver=121217, rew={0,0,0,50}, preq=425565}, -- Tilling Hope // Hoffnung des Pflügens
[425758]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241812]=  5}, giver=121323, rew={0,0,0,50}, preq=425578}, -- Ice Crystal of the Cold Palace // Eiskristall des kalten Palasts
[425763]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107427]=  4}, giver=121584, rew={333965,3877,10}, preq=425220}, -- Reconnect the Transport Circles // Erneute Verbindung der Transportkreise
[425764]={typ= 1, lvl=76, rlvl=74, zone= 24, items={[547201]=  1}, giver=121584, rew={333965,3877,10}, preq=425763}, -- Transportation Tester // Transporttestperson
[425765]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242050]= 10}, giver=121585, rew={333965,3877,10}, preq=425540}, -- Eat Well, Sleep Well, Get Well I // Kraftfutter und Gesundheitsschlaf I
[425766]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242051]= 10}, giver=121585, rew={333965,3877,10}, preq=425765}, -- Eat Well, Sleep Well, Get Well II // Kraftfutter und Gesundheitsschlaf II
[425767]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107428]=  5}, giver=121173, rew={333965,3877,10}, preq=425207}, -- More Medical Supplies // Noch mehr medizinische Versorgungsgüter
[425768]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107429]= 10}, giver=121173, rew={333965,3877,10}, preq=425767}, -- Medics' Good Helper // Willkommener Sanitätshelfer
[425769]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107433]=  5,[107434]=  5}, giver=121603, rew={333965,3877,10}, preq=425542}, -- Deer Caretaker // Rentierpfleger
[425770]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242068]= 15}, giver=121603, rew={333965,3877,10}, preq=425769}, -- More Feed Needed // Noch mehr Rentierfutter
[425771]={typ=21, lvl=76, rlvl=74, zone= 24, items={[241327]=  1}, giver=121589, rew={333965,3877,10}, preq=425672}, -- More Holy Tree Fruits // Noch mehr Früchte des Heiligen Baums
[425772]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107101]=  7,[107102]=  7}, giver=121592, rew={333965,3877,10}, preq=425771}, -- More Stable Defense Line // Weitere Verstärkung der Verteidigungslinien
[425795]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107060]=  8}, giver=121595, rew={333965,3877,10}, preq=425518}, -- Return the Supplies // Ablieferung der Vorräte
[425796]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107063]= 10}, giver=120979, rew={333965,3877,10}, preq={425525,425526}}, -- Against the Punishers I // Die Bestrafer bestrafen I
[425797]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107064]=  5}, giver=120979, rew={333965,3877,10}, preq={425525,425526}}, -- Against the Punishers II // Die Bestrafer bestrafen II
[425798]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242056]= 10}, giver=121380, rew={333965,3877,10}}, -- Holy Tree Worship // Die Verehrung des Heiligen Baums
[425799]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107092]=  5,[107094]=  5}, giver=121000, rew={333965,3877,10}, preq=425701}, -- Block Attack // Blockangriff
[425800]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242057]=  5}, giver=121380, rew={333965,3877,10}}, -- Craftsman's Secret // Des Handwerkers Geheimnis
[425801]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242058]=  5}, giver=121390, rew={333965,3877,10}}, -- Warm Feather Coat // Warmer Federumhang
[425802]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242059]= 10}, giver=121390, rew={333965,3877,10}}, -- Meat Stew with Wine Marinade // Fleischeintopf mit Weinmarinade
[425803]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[106695]= 10}, giver=121391, rew={333965,3877,10}}, -- Eliminate Red Wolves // Eliminiert Rote Wölfe
[425804]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107066]=  8}, giver=120979, rew={333965,3877,10}, preq=425523}, -- Stop the Transport // Den Transport stoppen
[425805]={typ=21, lvl=76, rlvl=74, zone= 24, items={[242060]= 10}, giver=120968, rew={333965,3877,10}}, -- Get Back Rune Core // Runenkern zurückerlangen
[425806]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107063]= 10}, giver=120979, rew={0,0,0,120}, preq={425525,425526}}, -- Against the Punishers I // Die Bestrafer bestrafen I
[425807]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107064]=  5}, giver=120979, rew={0,0,0,180}, preq={425525,425526}}, -- Against the Punishers II // Die Bestrafer bestrafen II
[425808]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107092]=  5,[107094]=  5}, giver=121000, rew={0,0,0,120}}, -- Block Attack // Blockangriff
[425809]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[106695]= 10}, giver=121391, rew={0,0,0,100}}, -- Eliminate Red Wolves // Eliminiert Rote Wölfe
[425810]={typ=22, lvl=76, rlvl=74, zone= 24, mobs={[107066]=  8}, giver=120979, rew={0,0,0,150}, preq=425523}, -- Stop the Transport // Den Transport stoppen
[425647]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107111]=  5}, giver=121120, rew={0,0,0,250}, preq=425625}, -- Continuous Strikes // Fortgesetzte Angriffe
[425648]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107112]= 10}, giver=121120, rew={0,0,0,100}, preq=425626}, -- Indirect Combat // Indirekter Kampf
[425649]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107115]=  5}, giver=121120, rew={0,0,0,200}, preq=425627}, -- Disastrous Backfire // Katastrophaler Rückstoß
[425650]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107213]=  1}, giver=121120, rew={0,0,0,530}, preq=425628}, -- Crushing Dread // Vernichtendes Grauen
[425651]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107116]=  5}, giver=121122, rew={0,0,0,100}, preq=425629}, -- Maintaining Battle Strength // Erhalten der Kampfstärke
[425652]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107129]=  5}, giver=121122, rew={0,0,0,100}, preq=425630}, -- Defensive Positions // Verteidigungsstellungen
[425653]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107210]=  5}, giver=121121, rew={0,0,0,150}, preq=425631}, -- Control Phase // Kontrollphase
[425654]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107211]=  5}, giver=121121, rew={0,0,0,150}, preq=425632}, -- Amazing Yields // Verblüffende Erträge
[425655]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107212]=  5}, giver=121121, rew={0,0,0,150}, preq=425645}, -- Cutting the Supply // Kappen der Versorgungslinien
[425656]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241353]= 10}, giver=121123, rew={0,0,0,50}, preq=425646}, -- Assistance Repair // Hilfsreparaturen
[425657]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241354]= 10}, giver=121123, rew={0,0,0,50}}, -- Reducing Losses // Verringerung der Verluste
[425658]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241355]=  5}, giver=121124, rew={0,0,0,150}}, -- Core Research // Kern-Forschung
[425659]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[106618]=  1}, giver=121124, rew={0,0,0,50}, preq={425668,425658}}, -- Instant Transmission // Sofort-Übertragung
[425660]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241356]= 10}, giver=121124, rew={0,0,0,50}}, -- Prison Rune // Kerkerrune
[425661]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[106852]=  5}, giver=121124, rew={0,0,0,100}, preq={425670,425660}}, -- Jailbreak Stone // Ausbruchsstein
[425746]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107081]=  8}, giver=121211, rew={0,0,0,200}, preq=425557}, -- Wrath of the Forest // Zorn des Waldes
[425747]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107079]=  3}, giver=121211, rew={0,0,0,200}, preq=425558}, -- Woodland Delirium // Wahn des Waldes
[425748]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107083]=  8}, giver=121211, rew={0,0,0,200}, preq=425559}, -- Woodland Disgust // Abscheu des Waldes
[425749]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107082]=  8}, giver=121212, rew={0,0,0,200}, preq=425560}, -- Woodland Distrust // Misstrauen des Waldes
[425754]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241698]= 10}, giver=121217, rew={0,0,0,70}, preq=425568}, -- Foul Remains // Üble Rückstände
[425755]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241700]= 10}, giver=121210, rew={0,0,0,70}, preq=425570}, -- Notes from Experience // Notizen aus Erfahrung
[425756]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241815]= 10}, giver=121214, rew={0,0,0,50}, preq=425571}, -- The Story of our Forefathers // Die Geschichte unserer Vorväter
[425759]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241704]= 10}, giver=121297, rew={0,0,0,50}, preq=425688}, -- A Long, Long Time Ago // Vor langer, langer Zeit
[425773]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107427]=  4}, giver=121584, rew={0,0,0,50}, preq=425220}, -- Reconnect the Transport Circles // Erneute Verbindung der Transportkreise
[425774]={typ= 1, lvl=77, rlvl=75, zone= 24, items={[547201]=  1}, giver=121584, rew={0,0,0,150}, preq=425773}, -- Transportation Tester // Transporttestperson
[425775]={typ=21, lvl=77, rlvl=75, zone= 24, items={[242050]= 10}, giver=121585, rew={0,0,0,200}, preq=425540}, -- Eat Well, Sleep Well, Get Well I // Kraftfutter und Gesundheitsschlaf I
[425776]={typ=21, lvl=77, rlvl=75, zone= 24, items={[242051]= 10}, giver=121585, rew={0,0,0,100}, preq=425775}, -- Eat Well, Sleep Well, Get Well II // Kraftfutter und Gesundheitsschlaf II
[425777]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107428]=  5}, giver=121173, rew={0,0,0,125}, preq=425207}, -- More Medical Supplies // Noch mehr medizinische Versorgungsgüter
[425778]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107429]= 10}, giver=121173, rew={0,0,0,70}, preq=425777}, -- Medics' Good Helper // Willkommener Sanitätshelfer
[425779]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107433]=  5,[107434]=  5}, giver=121603, rew={0,0,0,100}, preq=425542}, -- Deer Caretaker // Rentierpfleger
[425780]={typ=21, lvl=77, rlvl=75, zone= 24, items={[242068]= 15}, giver=121603, rew={0,0,0,150}, preq=425779}, -- More Feed Needed // Noch mehr Rentierfutter
[425781]={typ=21, lvl=77, rlvl=75, zone= 24, items={[241327]=  1}, giver=121589, rew={0,0,0,150}, preq=425672}, -- More Holy Tree Fruits // Noch mehr Früchte des Heiligen Baums
[425782]={typ=22, lvl=77, rlvl=75, zone= 24, mobs={[107101]=  7,[107102]=  7}, giver=121592, rew={0,0,0,250}, preq=425781}, -- More Stable Defense Line // Weitere Verstärkung der Verteidigungslinien
--[[ ] ]]

--[[ [ Syrbal Pass / Syrbalpass (25) ]]
[426047]={typ=21, lvl=78, rlvl=76, zone= 25, items={[242101]=  5}, giver=121667, rew={0,0,0,50}, preq=425811}, -- Shells and other Toys // Panzer und anderes Spielzeug
[425834]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107562]=  5}, giver=121419, taker=121428, rew={0,0,0,100}, preq=425573}, -- Visitors from the Deep // Besucher aus der Tiefe
[425961]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107668]= 10}, giver=121948, rew={376098,8609,10}, preq=425874}, -- A Little Refreshment // Eine kleine Erfrischung
[425963]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107643]= 10}, giver=121949, rew={376098,8609,10}, preq=425999}, -- Temperature Falling // Temperatursturz
[426004]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242225]= 10}, giver=121956, rew={376098,8609,10}, preq=426066}, -- Everybody's at their Limits // Alle sind an ihren Grenzen
[426005]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242225]= 10}, giver=121956, rew={0,0,0,50}, preq=426066}, -- Everybody's at their Limits // Alle sind an ihren Grenzen
[426006]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107490]= 10}, giver=121957, rew={376098,8609,10}, preq=426061}, -- Great Little Soldier // Großer Kleiner Soldat
[426007]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107490]= 10}, giver=121957, rew={0,0,0,150}, preq=426061}, -- Great Little Soldier // Großer Kleiner Soldat
[426008]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242228]=  1}, taker=121971, rew={376098,8609,10}, preq=426063}, -- Mysterious Power Source // Geheimnisvolle Energiequelle
[426018]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242228]=  1}, taker=121971, rew={0,0,0,50}, preq=426063}, -- Mysterious Power Source // Geheimnisvolle Energiequelle
[426019]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107562]=  5}, giver=121419, taker=121428, rew={376098,8609,10}, preq=425573}, -- Visitors from the Deep // Besucher aus der Tiefe
[426020]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107487]= 10}, giver=121951, rew={376098,8609,10}, preq=426000}, -- Levelling the Ground // Dem Erdboden gleichmachen
[426022]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242220]= 10}, giver=121947, rew={376098,8609,10}, preq=426001}, -- Blessing of the Yasheedee // Segen der Yasheedee
[426024]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242231]= 10}, giver=121949, rew={376098,8609,10}, preq=426002}, -- Missing Ingredients // Fehlende Zutaten
[426026]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107488]= 10}, giver=121952, rew={376098,8609,10}, preq=426003}, -- Furious Escalation // Wilde Eskalation
[426046]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242101]=  5}, giver=121667, rew={376098,8609,10}, preq=425811}, -- Shells and other Toys // Panzer und anderes Spielzeug
[426048]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242136]= 10}, giver=121793, rew={376098,8609,10}, preq=425855}, -- In Need of Medicine // Medizin benötigt
[426049]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242136]= 10}, giver=121793, rew={0,0,0,50}, preq=425855}, -- In Need of Medicine // Medizin benötigt
[426050]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107507]= 10}, giver=121874, rew={376098,8609,10}, preq=425880}, -- A Helping Hand // Eine helfende Hand
[426051]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107507]= 10}, giver=121874, rew={0,0,0,200}, preq=425880}, -- A Helping Hand // Eine helfende Hand
[426052]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107509]= 10}, giver=121875, rew={376098,8609,10}, preq=425881}, -- Stabilizing the Flow // Stabilisierung der Strömung
[426053]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107509]= 10}, giver=121875, rew={0,0,0,200}, preq=425881}, -- Stabilizing the Flow // Stabilisierung der Strömung
[426054]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107629]=  5}, giver=121876, rew={376098,8609,10}, preq=425883}, -- The Source of the Mood Shifts // Die Ursache der Stimmungsschwankungen
[426055]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107629]=  5}, giver=121876, rew={0,0,0,100}, preq=425883}, -- The Source of the Mood Shifts // Die Ursache der Stimmungsschwankungen
[426056]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242140]= 10}, giver=121876, rew={376098,8609,10}, preq=425884}, -- Trusted Weapons // Zuverlässige Waffen
[426057]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242140]= 10}, giver=121876, rew={0,0,0,50}, preq=425884}, -- Trusted Weapons // Zuverlässige Waffen
[426058]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107490]= 10}, giver=121953, rew={376098,8609,10}, preq=425875}, -- Sabotaging the Production // Sabotage der Produktion
[426069]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107468]=  8}, giver=121668, rew={376098,8609,10}, preq=425791}, -- In Need of More Preserving Potion // Noch mehr Konservierungstrank benötigt
[426070]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242160]=  8}, giver=121667, rew={376098,8609,10}, preq=425791}, -- Inspiring Insects // Inspirierende Insekten
[426075]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107214]=  3}, giver=121428, rew={376098,8609,10}, preq=425738}, -- Hundred Flower Essence // Essenz der Hundert Blumen
[426076]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242077]= 10}, giver=121687, rew={376098,8609,10}, preq=425742}, -- Insect Remains from Icy Graves // Insektenüberreste aus Eisgräbern
[426077]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242081]= 10}, giver=121691, rew={376098,8609,10}, preq=425743}, -- Misty Sleeping Herb // Nebelhaftes Schlafkraut
[426078]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107505]= 10}, giver=121691, rew={376098,8609,10}, preq=425762}, -- Gathering Obstacle // Sammelhindernis
[426079]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242172]= 10}, giver=121786, rew={376098,8609,10}, preq=425849}, -- Dangerous Ingredients // Gefährliche Zutaten
[426086]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242166]=  7,[242167]=  7}, giver=121843, rew={376098,8609,10}, preq=425973}, -- Busy and Safe // Viel beschäftigt, aber in Sicherheit
[426087]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107628]=  5}, giver=121843, rew={376098,8609,10}, preq=425974}, -- Even more Repelling // Noch abstoßender
[426088]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242169]= 10}, giver=121844, rew={376098,8609,10}, preq=425975}, -- Food for Friends // Essen für Freunde
[426089]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242170]= 10}, giver=121844, rew={376098,8609,10}, preq=425976}, -- Even more Golden // Noch mehr Gold
[426090]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242166]=  7,[242167]=  7}, giver=121843, rew={0,0,0,150}, preq=425973}, -- Busy and Safe // Viel beschäftigt, aber in Sicherheit
[426091]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107628]=  5}, giver=121843, rew={0,0,0,50}, preq=425974}, -- Even more Repelling // Noch abstoßender
[426092]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242169]= 10}, giver=121844, rew={0,0,0,100}, preq=425975}, -- Food for Friends // Essen für Freunde
[426093]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242170]= 10}, giver=121844, rew={0,0,0,100}, preq=425976}, -- Even more Golden // Noch mehr Gold
[426129]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107214]=  3}, giver=121428, rew={0,0,0,100}, preq=425738}, -- Hundred Flower Essence // Essenz der Hundert Blumen
[426130]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107127]=  5,[107471]=  5}, giver=121787, rew={376098,8609,10}, preq=425852}, -- Emergency Shift // Notschicht
[426131]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242144]= 10}, giver=121788, rew={376098,8609,10}, preq=425741}, -- Safe Delivery // Sichere Lieferung
[426132]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107626]=  5}, giver=121819, rew={376098,8609,10}, preq=425866}, -- The Ritual Stones // Rituelle Steine
[426133]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107507]= 10,[107510]=  5}, giver=121820, rew={376098,8609,10}, preq=425869}, -- Wrath of the Earth // Zorn der Erde
[426134]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242077]= 10}, giver=121687, rew={0,0,0,200}, preq=425742}, -- Insect Remains from Icy Graves // Insektenüberreste aus Eisgräbern
[426135]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242081]= 10}, giver=121691, rew={0,0,0,100}, preq=425743}, -- Misty Sleeping Herb // Nebelhaftes Schlafkraut
[426136]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107505]= 10}, giver=121691, rew={0,0,0,100}, preq=425762}, -- Gathering Obstacle // Sammelhindernis
[426137]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242172]= 10}, giver=121786, rew={0,0,0,100}, preq=425849}, -- Dangerous Ingredients // Gefährliche Zutaten
[426138]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107127]=  5,[107471]=  5}, giver=121787, rew={0,0,0,100}, preq=425852}, -- Emergency Shift // Notschicht
[426139]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242144]= 10}, giver=121788, rew={0,0,0,100}, preq=425741}, -- Safe Delivery // Sichere Lieferung
[426140]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107626]=  5}, giver=121819, rew={0,0,0,100}, preq=425866}, -- The Ritual Stones // Rituelle Steine
[426141]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107507]= 10,[107510]=  5}, giver=121820, rew={0,0,0,200}, preq=425869}, -- Wrath of the Earth // Zorn der Erde
[426144]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107483]=  5,[107508]=  5}, giver=121888, rew={376098,8609,10}, preq=425992}, -- Flames of Revenge // Flammen der Vergeltung
[426145]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242195]=  1}, taker=121888, rew={376098,8609,10}, preq=425994}, -- Additional Reports // Zusätzliche Berichte
[426146]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107638]=  8}, giver=121921, rew={376098,8609,10}, preq=425996}, -- Rescuing more Captives // Weitere Gefangene retten
[426147]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107483]=  5,[107508]=  5}, giver=121888, rew={0,0,0,150}, preq=425992}, -- Flames of Revenge // Flammen der Vergeltung
[426148]={typ=21, lvl=79, rlvl=77, zone= 25, items={[242195]=  1}, taker=121888, rew={0,0,0,300}, preq=425994}, -- Additional Reports // Zusätzliche Berichte
[426149]={typ=22, lvl=79, rlvl=77, zone= 25, mobs={[107638]=  8}, giver=121921, rew={0,0,0,150}, preq=425996}, -- Rescuing more Captives // Weitere Gefangene retten
[425962]={typ=22, lvl=80, rlvl=78, zone= 25, mobs={[107668]= 10}, rew={0,0,0,30}, preq=425874}, -- A Little Refreshment // Eine kleine Erfrischung
[425964]={typ=22, lvl=80, rlvl=78, zone= 25, mobs={[107643]= 10}, giver=121949, rew={0,0,0,50}, preq=425999}, -- Temperature Falling // Temperatursturz
[426021]={typ=22, lvl=80, rlvl=78, zone= 25, mobs={[107487]= 10}, giver=121951, rew={0,0,0,200}, preq=426000}, -- Levelling the Ground // Dem Erdboden gleichmachen
[426023]={typ=21, lvl=80, rlvl=78, zone= 25, items={[242220]= 10}, giver=121947, rew={0,0,0,70}, preq=426001}, -- Blessing of the Yasheedee // Segen der Yasheedee
[426025]={typ=21, lvl=80, rlvl=78, zone= 25, items={[242231]= 10}, giver=121949, rew={0,0,0,50}, preq=426002}, -- Missing Ingredients // Fehlende Zutaten
[426027]={typ=22, lvl=80, rlvl=78, zone= 25, mobs={[107488]= 10}, giver=121952, rew={0,0,0,200}, preq=426003}, -- Furious Escalation // Wilde Eskalation
[426059]={typ=22, lvl=80, rlvl=78, zone= 25, mobs={[107490]= 10}, giver=121953, rew={0,0,0,200}, preq=425875}, -- Sabotaging the Production // Sabotage der Produktion
--[[ ] ]]

--[[ [ Sarlo / Sarlo (26) ]]
[426225]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242669]= 10}, giver=122434, rew={407100,17920,10}, preq=426220}, -- An Escort's Dilemma // Eskorten-Dilemma
[426226]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242669]= 10}, giver=122434, rew={0,0,0,100}, preq=426220}, -- An Escort's Dilemma // Eskorten-Dilemma
[426227]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107716]= 10}, giver=122432, rew={407100,17920,10}, preq=426220}, -- Dabiya's Fury // Dabiyas Zorn
[426228]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107716]= 10}, giver=122432, rew={0,0,0,100}, preq=426220}, -- Dabiya's Fury // Dabiyas Zorn
[426323]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242719]= 10}, giver=117054, rew={407100,17920,10}, preq=426302}, -- Weapon Recovery // Zurückgewinnung von Waffen
[426324]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548100]=  1}, giver=119907, rew={407100,17920,10}, preq=426305}, -- Stop the Secret Research and Development // Ein Ende der Forschung
[426325]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242696]= 10}, giver=120777, rew={407100,17920,10}, preq=426307}, -- Collect Camouflaged Weapons // Hilfe bei der Tarnung
[426326]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242719]= 10}, giver=117054, rew={0,0,0,100}, preq=426302}, -- Weapon Recovery // Zurückgewinnung von Waffen
[426327]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548100]=  1}, giver=119907, rew={0,0,0,100}, preq=426305}, -- Stop the Secret Research and Development // Ein Ende der Forschung
[426328]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242696]= 10}, giver=120777, rew={0,0,0,150}, preq=426307}, -- Collect Camouflaged Weapons // Hilfe bei der Tarnung
[426329]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242571]= 10}, giver=114999, rew={407100,17920,10}, preq=426155}, -- Drawn from Dew // Magischer Tau
[426330]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242572]= 10}, giver=114999, rew={407100,17920,10}, preq=426155}, -- From the Soil // Aus der Erde
[426331]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107695]= 10}, giver=122165, rew={407100,17920,10}, preq=426157}, -- The Fearless Warrior // Der furchtlose Krieger
[426332]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242574]= 10}, giver=122168, rew={407100,17920,10}, preq=426167}, -- After finishing your meal. Please make amends. // Wiedergutmachung
[426333]={typ=24, lvl=81, rlvl=79, zone= 26, items={[242575]=  5}, giver=122168, rew={407100,17920,10}, preq=426169}, -- Top-Flight Chef // Meisterkoch
[426334]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242571]= 10}, giver=114999, rew={0,0,0,100}, preq=426155}, -- Drawn from Dew // Magischer Tau
[426335]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242572]= 10}, giver=114999, rew={0,0,0,100}, preq=426155}, -- From the Soil // Aus der Erde
[426336]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107695]= 10}, giver=122165, rew={0,0,0,150}, preq=426157}, -- The Fearless Warrior // Der furchtlose Krieger
[426337]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242574]= 10}, giver=122168, rew={0,0,0,80}, preq=426167}, -- After finishing your meal. Please make amends. // Wiedergutmachung
[426338]={typ=24, lvl=81, rlvl=79, zone= 26, items={[242575]=  5}, giver=122168, rew={0,0,0,80}, preq=426169}, -- Top-Flight Chef // Meisterkoch
[426339]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242654]= 10}, giver=122320, rew={407100,17920,10}, preq=426254}, -- Bethomia's History // Vergangenheitsforschung
[426340]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242653]=  5}, giver=122322, rew={407100,17920,10}, preq=426255}, -- A Concealed Record // Ein verborgener Bericht
[426341]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242655]= 10}, giver=122324, rew={407100,17920,10}, preq=426258}, -- A Reverse of Fortunes // Schicksalshafte Wende
[426342]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548094]=  1,[548095]=  1}, giver=122312, rew={407100,17920,10}, preq=426259}, -- Supply Rescue // Rettung von Vorräten
[426343]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107724]= 10}, giver=122326, rew={407100,17920,10}, preq=426261}, -- A Slave's Request // Bitte eines Sklaven
[426344]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548111]=  1}, giver=122330, rew={407100,17920,10}, preq=426264}, -- The Way of Deception // Die Kunst der Täuschung
[426345]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107821]= 10}, giver=122334, rew={407100,17920,10}, preq=426265}, -- The Enemy is Watching // Der Feind hört mit
[426346]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242654]= 10}, giver=122320, rew={0,0,0,50}, preq=426254}, -- Bethomia's History // Vergangenheitsforschung
[426347]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242653]=  5}, giver=122322, rew={0,0,0,200}, preq=426255}, -- A Concealed Record // Ein verborgener Bericht
[426348]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242655]= 10}, giver=122324, rew={0,0,0,80}, preq=426258}, -- A Reverse of Fortunes // Schicksalshafte Wende
[426349]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548094]=  1,[548095]=  1}, giver=122312, rew={0,0,0,100}, preq=426259}, -- Supply Rescue // Rettung von Vorräten
[426350]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107724]= 10}, giver=122326, rew={0,0,0,200}, preq=426261}, -- A Slave's Request // Bitte eines Sklaven
[426351]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548111]=  1}, giver=122330, rew={0,0,0,50}, preq=426264}, -- The Way of Deception // Die Kunst der Täuschung
[426352]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107821]= 10}, giver=122334, rew={0,0,0,120}, preq=426265}, -- The Enemy is Watching // Der Feind hört mit
[426353]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242590]=  5}, giver=122183, rew={407100,17920,10}, preq=426182}, -- Lasting Hope // Beständige Hoffnung
[426354]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242591]=  4,[242592]=  4,[242593]=  8}, giver=122221, rew={407100,17920,10}, preq=426183}, -- Fixing the Armored Tank // Panzerreparatur
[426355]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107776]=  5,[107777]=  5}, giver=122223, rew={407100,17920,10}, preq=426186}, -- The Rescue Must Go On // Die Rettung muss weitergehen
[426356]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242619]= 10}, giver=122224, rew={407100,17920,10}, preq=426187}, -- Clean-up Can't Be Interrupted // Aufräumarbeiten
[426357]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242609]=  1,[242610]=  1,[242611]=  1}, giver=122186, rew={407100,17920,10}, preq=426195}, -- Expanding the Mini Factory // Erweiterung der Miniaturfabrik
[426358]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242590]=  5}, giver=122183, rew={0,0,0,100}, preq=426182}, -- Lasting Hope // Beständige Hoffnung
[426359]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242591]=  4,[242592]=  4,[242593]=  8}, giver=122221, rew={0,0,0,100}, preq=426183}, -- Fixing the Armored Tank // Panzerreparatur
[426360]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107776]=  5,[107777]=  5}, giver=122223, rew={0,0,0,80}, preq=426186}, -- The Rescue Must Go On // Die Rettung muss weitergehen
[426361]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242619]= 10}, giver=122224, rew={0,0,0,80}, preq=426187}, -- Clean-up Can't Be Interrupted // Aufräumarbeiten
[426362]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242609]=  1,[242610]=  1,[242611]=  1}, giver=122186, rew={0,0,0,80}, preq=426195}, -- Expanding the Mini Factory // Erweiterung der Miniaturfabrik
[426363]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107711]=  8,[107712]=  8}, giver=122340, rew={407100,17920,10}, preq=426204}, -- Crusade // Kreuzzug
[426364]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242635]=  4,[242636]=  4,[242637]=  4,[242638]=  4}, giver=122342, rew={407100,17920,10}, preq=426208}, -- Full from Delicious Food // Satt mit köstlichem Essen
[426365]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242640]=  5}, giver=122342, rew={407100,17920,10}, preq=426208}, -- Piping Hot Spring Eggs // Eier aus heißen Quellen
[426366]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107713]=  8,[107717]=  8}, giver=122345, rew={407100,17920,10}, preq=426213}, -- Eliminating Barriers // Hindernisse vernichten
[426367]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107711]=  8,[107712]=  8}, giver=122340, rew={0,0,0,150}, preq=426204}, -- Crusade // Kreuzzug
[426368]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242635]=  4,[242636]=  4,[242637]=  4,[242638]=  4}, giver=122342, rew={0,0,0,100}, preq=426208}, -- Full from Delicious Food // Satt mit köstlichem Essen
[426369]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242640]=  5}, giver=122342, rew={0,0,0,50}, preq=426208}, -- Piping Hot Spring Eggs // Eier aus heißen Quellen
[426370]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107713]=  8,[107717]=  8}, giver=122345, rew={0,0,0,200}, preq=426213}, -- Eliminating Barriers // Hindernisse vernichten
[426371]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107693]= 10}, giver=122206, rew={407100,17920,10}, preq=426171}, -- Control the Forest // Kontrolle über den Wald
[426372]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107693]= 10}, giver=122206, rew={0,0,0,100}, preq=426171}, -- Control the Forest // Kontrolle über den Wald
[426373]={typ=24, lvl=81, rlvl=79, zone= 26, items={[242579]= 10}, giver=122205, rew={407100,17920,10}, mobs={[107736]=  2}, preq=426172}, -- Continuing to Destroy Firearms // Weiter Feuerwaffen zerstören
[426374]={typ=24, lvl=81, rlvl=79, zone= 26, items={[242579]= 10}, giver=122205, rew={0,0,0,100}, mobs={[107736]=  2}, preq=426172}, -- Continuing to Destroy Firearms // Weiter Feuerwaffen zerstören
[426375]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107753]=  5}, giver=122150, rew={407100,17920,10}, preq=425861}, -- Battlefield Music // Schlachtfeldmusik
[426376]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107761]=  3}, giver=122163, rew={407100,17920,10}, preq=426040}, -- Clean Up // Das Aufräumen danach
[426377]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107767]=  5}, giver=122196, rew={407100,17920,10}, preq=426104}, -- Passive Resistance // Passiver Widerstand
[426378]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242577]= 15}, giver=122197, rew={407100,17920,10}, preq=426142}, -- Craving for Meat // Verlangen nach Fleisch
[426379]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242578]= 10}, giver=122198, rew={407100,17920,10}, preq=426143}, -- The Miracle of Life // Das Wunder des Lebens
[426380]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242587]=  5}, giver=122199, rew={407100,17920,10}, preq=426150}, -- Inscription Studies // Studium der Inschriften
[426381]={typ=21, lvl=81, rlvl=79, zone= 26, items={[241036]=  5}, giver=122200, rew={407100,17920,10}, preq=426151}, -- The Human Factor // Der Faktor Mensch
[426382]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548064]=  1}, giver=122258, taker=122199, rew={407100,17920,10}, preq=426152}, -- Mythical Legacy // Mythisches Erbe
[426383]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242621]= 10}, giver=122304, rew={407100,17920,10}, preq=426229}, -- Saving the Day // Rettet den Tag
[426384]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242622]= 10}, giver=122305, rew={407100,17920,10}, preq=426230}, -- The Fortunate Fortune // Günstiges Glück
[426385]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242623]=  1}, giver=122306, rew={407100,17920,10}, preq=426231}, -- Doing Nothing // Untätig
[426386]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107733]=  5,[107735]=  5}, giver=122308, rew={407100,17920,10}, preq=426232}, -- Not Budging an Inch // Keinen Fuß nachgeben
[426387]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242624]= 10}, giver=122309, rew={407100,17920,10}, preq=426233}, -- Experience with the Enemy // Erfahrung mit dem Feind
[426388]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107788]= 10}, giver=122309, rew={407100,17920,10}, preq=426234}, -- Neutralizing Odors // Neutralisieren der Gerüche
[426389]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548041]=  1}, giver=122310, rew={407100,17920,10}, preq=426235}, -- A Bad Feeling // Ein mieses Gefühl
[426390]={typ=25, lvl=81, rlvl=79, zone= 26, items={[548046]=  1}, giver=122310, taker=122311, rew={407100,17920,10}, preq={426235,426389,426236}}, -- Creating Confusion // Verwirrung stiften
[426391]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107793]= 10}, giver=122311, rew={407100,17920,10}, preq={426235,426389,426236,426390,426237}}, -- Bomb Disposal Expert // Bombenentschärfungskommando
[426392]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107794]= 10}, giver=122311, rew={407100,17920,10}, preq=426238}, -- Attack Rations // Unterbrechung des Nahrungsnachschubs
[426393]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107721]= 10}, giver=122312, rew={407100,17920,10}, preq=426239}, -- No Other Way // Keine andere Möglichkeit
[426394]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107796]=  5}, giver=122312, rew={407100,17920,10}, preq=426240}, -- Piecemeal Measures // Salamitaktik
[426395]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107753]=  5}, giver=122150, rew={0,0,0,50}, preq=425861}, -- Battlefield Music // Schlachtfeldmusik
[426396]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107761]=  3}, giver=122163, rew={0,0,0,50}, preq=426040}, -- Clean Up // Das Aufräumen danach
[426397]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107767]=  5}, giver=122196, rew={0,0,0,50}, preq=426104}, -- Passive Resistance // Passiver Widerstand
[426398]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242577]= 15}, giver=122197, rew={0,0,0,50}, preq=426142}, -- Craving for Meat // Verlangen nach Fleisch
[426399]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242578]= 10}, giver=122198, rew={0,0,0,50}, preq=426143}, -- The Miracle of Life // Das Wunder des Lebens
[426400]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242587]=  5}, giver=122199, rew={0,0,0,100}, preq=426150}, -- Inscription Studies // Studium der Inschriften
[426401]={typ=21, lvl=81, rlvl=79, zone= 26, items={[241036]=  5}, giver=122200, rew={0,0,0,50}, preq=426151}, -- The Human Factor // Der Faktor Mensch
[426402]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548064]=  1}, giver=122258, taker=122199, rew={0,0,0,500}, preq=426152}, -- Mythical Legacy // Mythisches Erbe
[426403]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242621]= 10}, giver=122304, rew={0,0,0,50}, preq=426229}, -- Saving the Day // Rettet den Tag
[426404]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242622]= 10}, giver=122305, rew={0,0,0,50}, preq=426230}, -- The Fortunate Fortune // Günstiges Glück
[426405]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242623]=  1}, giver=122306, rew={0,0,0,50}, preq=426231}, -- Doing Nothing // Untätig
[426406]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107733]=  5,[107735]=  5}, giver=122308, rew={0,0,0,100}, preq=426232}, -- Not Budging an Inch // Keinen Fuß nachgeben
[426407]={typ=21, lvl=81, rlvl=79, zone= 26, items={[242624]= 10}, giver=122309, rew={0,0,0,100}, preq=426233}, -- Experience with the Enemy // Erfahrung mit dem Feind
[426408]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107788]= 10}, giver=122309, rew={0,0,0,50}, preq=426234}, -- Neutralizing Odors // Neutralisieren der Gerüche
[426409]={typ=21, lvl=81, rlvl=79, zone= 26, items={[548041]=  1}, giver=122310, rew={0,0,0,50}, preq=426235}, -- A Bad Feeling // Ein mieses Gefühl
[426410]={typ=25, lvl=81, rlvl=79, zone= 26, items={[548046]=  1}, giver=122310, taker=122311, rew={0,0,0,50}, preq={426235,426409,426236}}, -- Creating Confusion // Verwirrung stiften
[426411]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107793]= 10}, giver=122311, rew={0,0,0,100}, preq={426235,426409,426236,426410,426237}}, -- Bomb Disposal Expert // Bombenentschärfungskommando
[426412]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107794]= 10}, giver=122311, rew={0,0,0,100}, preq=426238}, -- Attack Rations // Unterbrechung des Nahrungsnachschubs
[426413]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107721]= 10}, giver=122312, rew={0,0,0,50}, preq=426239}, -- No Other Way // Keine andere Möglichkeit
[426414]={typ=22, lvl=81, rlvl=79, zone= 26, mobs={[107796]=  5}, giver=122312, rew={0,0,0,50}, preq=426240}, -- Piecemeal Measures // Salamitaktik
--[[ ] ]]

--[[ [ Wailing Fjord / Jammerförde (27) ]]
[426423]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242556]= 10}, giver=117304, rew={0,0,0,150}, preq=426527}, -- Master Chef's Personal Recipe I // Privatgericht des Meisterkochs I
[426424]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242557]= 10}, giver=117304, rew={0,0,0,150}, preq=426528}, -- Master Chef's Personal Recipe II // Privatgericht des Meisterkochs II
[426425]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242558]=  1}, giver=117304, rew={0,0,0,50}, preq=426529}, -- Spice Things Up // Die Seele des Essens
[426436]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242559]=  5}, giver=117493, rew={0,0,0,80}, preq=426530}, -- Recovering Supplies // Bergen der Vorräte
[426540]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242560]=  8}, giver=117493, rew={0,0,0,100}, preq=426531}, -- Driftwood // Treibholz
[426541]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242561]=  7}, giver=117707, rew={0,0,0,150}, preq=426533}, -- Seaweed Supper // Seetanggericht
[426542]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242562]=  7}, giver=117707, rew={0,0,0,150}, preq=426534}, -- The Use of Oil // Der Zweck des Öls
[426543]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242563]= 10}, giver=118153, rew={0,0,0,100}, preq=426536}, -- Alcohol Unlocks The Heart // Guter Schnaps öffnet das Herz
[426544]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242565]= 10}, giver=118465, rew={0,0,0,100}, preq=426538}, -- First Class Healing // Erstklassige Heilung
[426545]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242950]= 10}, giver=122860, rew={0,0,0,100}, preq=426477}, -- Poisoned Pirates // Vergiftete Piraten
[426546]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242985]= 10}, giver=122893, rew={0,0,0,100}, preq=426480}, -- Pirates and Water // Piraten und Wasser
[426547]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242953]=  1}, giver=122893, rew={0,0,0,80}, preq=426480}, -- Transport Circle Materials // Transportkreismaterial
[426548]={typ= 2, lvl=83, rlvl=81, zone= 27, mobs={[107904]=  5,[107976]=  5}, giver=122895, rew={0,0,0,200}, preq=426481}, -- Something To Think About // Denkanstöße
[426582]={typ= 1, lvl=83, rlvl=81, zone= 27, items={[242564]=  1}, giver=118153, rew={0,0,0,50}, preq=426536}, -- The Primal Fang King and the Wine // Der Jungzahnkönig und der Wein
[426415]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242556]= 10}, giver=117304, rew={527227,25176,10}, preq=426527}, -- Master Chef's Personal Recipe I // Privatgericht des Meisterkochs I
[426416]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242557]= 10}, giver=117304, rew={527227,25176,10}, preq=426528}, -- Master Chef's Personal Recipe II // Privatgericht des Meisterkochs II
[426417]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242558]=  1}, giver=117304, rew={527227,25176,10}, preq=426529}, -- Spice Things Up // Die Seele des Essens
[426418]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242559]=  5}, giver=117493, rew={527227,25176,10}, preq=426530}, -- Recovering Supplies // Bergen der Vorräte
[426419]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242560]=  8}, giver=117493, rew={527227,25176,10}, preq=426531}, -- Driftwood // Strandholz
[426420]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242561]=  7}, giver=117707, rew={527227,25176,10}, preq=426533}, -- Seaweed for Supper // Seetanggericht
[426421]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242562]=  7}, giver=117707, rew={527227,25176,10}, preq=426534}, -- The Use of Oil // Der Zweck des Öls
[426422]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242563]= 10}, giver=118153, rew={527227,25176,10}, preq=426536}, -- Alcohol Unlocks The Heart // Guter Schnaps öffnet das Herz
[426452]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242978]= 10}, giver=122883, rew={527227,25176,10}, preq=426449}, -- Extra Antidote // Ersatz-Gegengift
[426453]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242974]= 10}, giver=122817, rew={527227,25176,10}, preq=426448}, -- For All Occasions // Für alle Fälle
[426454]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242956]= 10}, giver=122812, rew={527227,25176,10}, preq=426438}, -- Even Pirates Can Be Poor // Auch Piraten können arm sein
[426455]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242978]= 10}, giver=122883, rew={0,0,0,100}, preq=426449}, -- Supply of Antidote // Vorrat an Gegengift
[426456]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242974]= 10}, giver=122817, rew={0,0,0,100}, preq=426448}, -- For All Occasions // Für alle Fälle
[426482]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242565]= 10}, giver=118465, rew={527227,25176,10}, preq=426538}, -- First Class Healing // Erstklassige Heilung
[426483]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242950]= 10}, giver=122860, rew={527227,25176,10}, preq=426477}, -- Poisoned Pirate // Vergifteter Pirat
[426484]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242985]= 10}, giver=122893, rew={527227,25176,10}, preq=426480}, -- Precious as Water // Kostbar wie Wasser
[426485]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242953]=  1}, giver=122893, rew={527227,25176,10}, preq=426480}, -- Transport Circle Materials // Transportkreismaterial
[426486]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[107904]=  5,[107976]=  5}, giver=122895, rew={527227,25176,10}, preq=426481}, -- Something To Think About // Denkanstöße
[426549]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108174]=  8}, giver=122760, rew={527227,25176,10}, preq=426571}, -- Order in the Port // Hafenordnung
[426550]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108171]=  1}, giver=122760, rew={527227,25176,10}, preq=426572}, -- The Truth about the Shipwreck // Die Wahrheit über das Schiffsunglück
[426551]={typ= 4, lvl=84, rlvl=82, zone= 27, items={[242769]=  8}, giver=122761, rew={527227,25176,10}, preq=426574}, -- The Ocean's Hidden Treasure // Der versteckte Schatz des Ozeans
[426552]={typ= 4, lvl=84, rlvl=82, zone= 27, items={[242993]=  8}, giver=122761, rew={527227,25176,10}, preq=426575}, -- Pressing Out Every Last Drop of Value // Noch mehr Wert heraus pressen
[426553]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108147]=  8}, giver=122762, rew={527227,25176,10}, preq=426576}, -- Messing Around with Pirates // Sich mit Piraten abgeben
[426554]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242627]=  3,[242766]=  3,[242767]=  3}, giver=122763, rew={527227,25176,10}, preq=426577}, -- Sacrifice for Science // Das Opfer für die Wissenschaft
[426555]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[107919]=  8}, giver=122763, rew={527227,25176,10}, preq=426578}, -- Elimination of Danger // Die Beseitigung der Gefahr
[426556]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108172]=  1}, giver=122806, taker=122760, rew={527227,25176,10}, preq=426579}, -- Wanted: \"Stone Scorpion\" Gideon // Gesucht: Steinskorpion Gideon
[426557]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108173]=  1}, giver=122806, taker=122760, rew={527227,25176,10}, preq=426580}, -- Wanted: \"Guargo the Mad Bull\" // Gesucht: Guargo der wütende Stier
[426559]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242956]= 10}, giver=122812, rew={0,0,0,100}, preq=426438}, -- Even Pirates Have Poor Families // Piraten haben auch arme Familien
[426560]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108174]=  8}, giver=122760, rew={0,0,0,100}, preq=426571}, -- Order in the Port // Hafenordnung
[426561]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108171]=  1}, giver=122760, rew={0,0,0,200}, preq=426572}, -- The Truth about the Shipwreck // Die Wahrheit über das Schiffsunglück
[426562]={typ= 4, lvl=84, rlvl=82, zone= 27, items={[242769]=  8}, giver=122761, rew={0,0,0,50}, preq=426574}, -- The Ocean's Hidden Treasure // Der versteckte Schatz des Ozeans
[426563]={typ= 4, lvl=84, rlvl=82, zone= 27, items={[242993]=  8}, giver=122761, rew={0,0,0,50}, preq=426575}, -- Pressing Out Every Last Drop of Value // Noch mehr Wert heraus pressen
[426564]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108147]=  8}, giver=122762, rew={0,0,0,100}, preq=426576}, -- Messing Around with Pirates // Sich mit Piraten abgeben
[426565]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242627]=  3,[242766]=  3,[242767]=  3}, giver=122763, rew={0,0,0,50}, preq=426577}, -- Sacrifice for Science // Das Opfer für die Wissenschaft
[426566]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[107919]=  8}, giver=122763, rew={0,0,0,100}, preq=426578}, -- Eliminating the Danger // Die Beseitigung der Gefahr
[426567]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108172]=  1}, giver=122806, taker=122760, rew={0,0,0,200}, preq=426579}, -- Wanted: \"Stone Scorpion\" Gideon // Gesucht: Steinskorpion Gideon
[426568]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[108173]=  1}, giver=122806, taker=122760, rew={0,0,0,200}, preq=426580}, -- Wanted: \"Guargo the Mad Bull\" // Gesucht: Guargo der wütende Stier
[426581]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242564]=  1}, giver=118153, rew={527227,25176,10}, preq=426536}, -- The Primal Fang King and the Wine // Der Jungzahnkönig und der Wein
[426584]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242931]=  5,[242932]=  5}, giver=122829, rew={527227,25176,10}, preq=426521}, -- Daily Cleaning // Das tägliche Aufräumen
[426585]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242927]=  2,[242928]=  5}, giver=122832, rew={527227,25176,10}, preq=426523}, -- Learning to Write // Schreiben lernen
[426586]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242929]= 10}, giver=122833, rew={527227,25176,10}, preq=426526}, -- Sacrifice to the Wind // Das Opfer an den Wind
[426587]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242967]=  5}, giver=122862, rew={527227,25176,10}, preq=426509}, -- Even More Fireflint Lizards // Noch mehr Felsfeuerechsen
[426588]={typ= 2, lvl=84, rlvl=82, zone= 27, mobs={[107931]= 10}, giver=122864, rew={527227,25176,10}, preq=426511}, -- Tracking Down the Enemy // Aufspüren der Feinde
[426589]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242968]= 10}, giver=122865, rew={527227,25176,10}, preq=426512}, -- Tasty Like Beef // Leckeres Hüftfleisch
[426590]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242971]= 10}, giver=122865, rew={527227,25176,10}, preq=426513}, -- A Balanced Diet // Die Ernährung sollte ausgewogen sein
[426591]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242969]= 10}, giver=122866, rew={527227,25176,10}, preq=426514}, -- In-Depth Analysis // Eine tiefgehende Analyse
[426592]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242970]= 10}, giver=122866, rew={527227,25176,10}, preq=426515}, -- The Beauty of Thorns // Die Schönheit der Dornen
[426593]={typ= 1, lvl=84, rlvl=82, zone= 27, items={[242972]= 10}, giver=122866, rew={527227,25176,10}, preq=426516}, -- Researching an Unknown Pattern // Ihr erforscht ein unbekanntes Muster
[426594]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242931]=  5,[242932]=  5}, giver=122829, rew={0,0,0,100}, preq=426521}, -- Daily Cleaning // Das tägliche Aufräumen
[426595]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242927]=  2,[242928]=  5}, giver=122832, rew={0,0,0,150}, preq=426523}, -- Learning to Write // Schreiben lernen
[426596]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242929]= 10}, giver=122833, rew={0,0,0,200}, preq=426526}, -- Sacrifice for the Wind // Das Opfer an den Wind
[426597]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242967]=  5}, giver=122862, rew={0,0,0,150}, preq=426509}, -- Even More Fireflint Lizards // Noch mehr Felsfeuerechsen
[426598]={typ= 2, lvl=85, rlvl=83, zone= 27, mobs={[107931]= 10}, giver=122864, rew={0,0,0,150}, preq=426511}, -- Tracking Down the Enemy // Aufspüren der Feinde
[426599]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242968]= 10}, giver=122865, rew={0,0,0,200}, preq=426512}, -- Tastes Like Beef // Leckeres Hüftfleisch
[426600]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242971]= 10}, giver=122865, rew={0,0,0,100}, preq=426513}, -- A Balanced Diet // Die Ernährung sollte ausgewogen sein
[426601]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242969]= 10}, giver=122866, rew={0,0,0,200}, preq=426514}, -- In-Depth Analysis // Eine tiefgehende Analyse
[426602]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242970]= 10}, giver=122866, rew={0,0,0,200}, preq=426515}, -- The Beauty of Thorns // Die Schönheit der Dornen
[426603]={typ= 1, lvl=85, rlvl=83, zone= 27, items={[242972]= 10}, giver=122866, rew={0,0,0,150}, preq=426516}, -- Researching an Unknown Pattern // Ihr erforscht ein unbekanntes Muster
[426921]={typ= 1, lvl=89, rlvl=87, zone= 27, items={[242935]= 10}, giver=123222, rew={586798,43657,10}, preq=426778}, -- Retrieving the Records // Die Aufzeichnungen zurückholen
[426922]={typ= 1, lvl=89, rlvl=87, zone= 27, items={[242935]= 10}, giver=123222, rew={0,0,0,150}, preq=426778}, -- Retrieving the Records // Die Aufzeichnungen zurückholen
[427025]={typ= 1, lvl=91, rlvl=89, zone= 27, items={[243106]= 10}, giver=123309, rew={0,0,0,100}, preq=426797}, -- Earth Crystal // Erdkristall
[427029]={typ= 1, lvl=91, rlvl=89, zone= 27, items={[243109]=  1}, giver=123313, rew={0,0,0,150}, preq=426801}, -- The Eagle Hunt // Adlerjagd
--[[ ] ]]

--[[ [ Jungle of Hortek / Dschungel von Hortek (28) ]]
[426745]={typ= 2, lvl=85, rlvl=83, zone= 28, mobs={[108196]= 10}, giver=123056, rew={0,0,0,100}}, -- Always Ready to Rumble // Jederzeit angriffsbereit
[426747]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[243063]=  1}, taker=123194, rew={0,0,0,250}, preq=426610}, -- Mezzmillo's Heart // Mezzmillos Herz
[426749]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[548419]=  1,[548420]=  1,[548421]=  1}, giver=123055, rew={0,0,0,100}, preq=426613}, -- On the Origin of Species // Über die Entstehung der Arten
[426757]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[548659]=  1}, giver=123162, taker=123058, rew={0,0,0,100}, preq=426273}, -- A Test of Wisdom // Eine Prüfung der Weisheit
[426758]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[548676]=  1}, giver=123163, taker=123058, rew={0,0,0,100}, preq=426299}, -- A Test of Courage // Eine Prüfung des Mutes
[426759]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[548677]=  1}, giver=123164, taker=123058, rew={0,0,0,100}, preq=426558}, -- A Test of Strength // Eine Prüfung der Stärke
[426760]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[243054]= 10}, giver=123061, rew={0,0,0,50}, preq={426672,426569}}, -- Emergency Remedy // Notfallmedizin
[426761]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[240977]=  8}, giver=123063, rew={0,0,0,100}, preq={426614,426670}}, -- Sonoceptive Eyes // Schallseher-Auge
[426762]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[240975]=  8}, giver=123063, rew={0,0,0,100}, preq={426614,426680}}, -- Energy Rift // Energiespalte
[426763]={typ= 1, lvl=85, rlvl=83, zone= 28, items={[240974]= 10}, giver={123060,123068}, rew={0,0,0,100}, preq={426681,426682}}, -- Energetic Origins // Der Ursprung der Energie
[425690]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[243071]=  5}, giver=123107, rew={545873,31959,10}, preq=426649}, -- Nature's Medicine // Naturmedizin
[425714]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[243066]= 10}, giver=123101, rew={545873,31959,10}, preq=426638}, -- Plundering Pirates // Plündernde Piraten
[426321]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[242074]= 10}, giver=123141, rew={545873,31959,10}, preq=426643}, -- Mark of the Warrior // Das Zeugnis eines Kriegers
[426718]={typ= 1, lvl=86, rlvl=85, zone= 28, items={[243022]=  6}, giver=123032, rew={545873,31959,10}, preq=426683}, -- The Enigma of the Old Ship // Das Rätsel des alten Schiffs
[426719]={typ= 2, lvl=86, rlvl=85, zone= 28, mobs={[107941]=  8}, giver=123034, rew={545873,31959,10}, preq=426684}, -- Nothing But Hot Air // Nur heiße Luft
[426720]={typ= 1, lvl=86, rlvl=85, zone= 28, items={[243026]=  2,[243027]=  3,[243028]=  1}, giver=123037, rew={545873,31959,10}, preq=426687}, -- Even Death Won't Change Anything... // Selbst der Tod wird nichts ändern ...
[426721]={typ= 2, lvl=86, rlvl=85, zone= 28, mobs={[107936]=  8}, giver=123041, rew={545873,31959,10}, preq=426688}, -- Securing the Roads // Die Straßen sicher machen
[426722]={typ= 1, lvl=86, rlvl=85, zone= 28, items={[243050]=  6}, giver=123042, rew={545873,31959,10}, preq=426689}, -- Fixing for a Stroll // Reparieren und Spazieren
[426723]={typ= 2, lvl=86, rlvl=85, zone= 28, mobs={[107938]=  8}, giver=123044, rew={545873,31959,10}, preq=426691}, -- The First Step // Das ist nur der erste Schritt
[426724]={typ= 1, lvl=86, rlvl=85, zone= 28, items={[243030]=  5}, giver=123044, rew={545873,31959,10}, preq=426691}, -- The Pure Essence // Die reine Essenz
[426725]={typ= 1, lvl=86, rlvl=85, zone= 28, items={[243031]=  5}, giver=123046, rew={545873,31959,10}, preq=426692}, -- Singing in Key // Der Ton des Gesangs
[426734]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[107937]= 10}, giver=123078, rew={545873,31959,10}, preq=426625}, -- A Lake of Tranquility // Der Frieden des Sees
[426735]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[548407]=  1}, giver=123084, rew={545873,31959,10}, preq=426658}, -- A Lady in Waiting // Dieses Mädchen wartet
[426736]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[107943]=  1}, giver=123098, rew={545873,31959,10}, preq=426659}, -- Trespassing Forbidden // Betreten des Friedhofs verboten
[426737]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[108206]= 10}, giver=123078, rew={545873,31959,10}, preq=426660}, -- Not Like the Legends // Nicht dasselbe wie in der Legende
[426738]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[548408]=  1}, giver=123071, rew={545873,31959,10}, preq=426661}, -- Singing in the Night // Gesang in der Nacht
[426739]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[107937]= 10}, giver=123078, rew={0,0,0,120}, preq=426625}, -- A Lake of Tranquility // Der Frieden des Sees
[426740]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[548407]=  1}, giver=123084, rew={0,0,0,50}, preq=426658}, -- A Lady in Waiting // Dieses Mädchen wartet
[426741]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[107943]=  1}, giver=123098, rew={0,0,0,120}, preq=426659}, -- Trespassing Forbidden // Betreten des Friedhofs verboten
[426742]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[108206]= 10}, giver=123078, rew={0,0,0,120}, preq=426660}, -- Not Like the Legends // Nicht dasselbe wie in der Legende
[426743]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[548408]=  1}, giver=123071, rew={0,0,0,100}, preq=426661}, -- Singing in the Night // Gesang in der Nacht
[426744]={typ= 2, lvl=86, rlvl=83, zone= 28, mobs={[108196]= 10}, giver=123056, rew={545873,31959,10}, preq=426605}, -- Always Ready to Rumble // Jederzeit angriffsbereit
[426746]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[243063]=  1}, taker=123194, rew={545873,31959,10}, preq=426610}, -- Mezzmillo's Heart // Mezzmillos Herz
[426748]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[548419]=  1,[548420]=  1,[548421]=  1}, giver=123055, rew={545873,31959,10}, preq=426613}, -- On the Origin of Species // Über die Entstehung der Arten
[426750]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[548659]=  1}, giver=123162, taker=123058, rew={545873,31959,10}, preq=426273}, -- A Test of Wisdom // Eine Prüfung der Weisheit
[426751]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[548676]=  1}, giver=123163, taker=123058, rew={545873,31959,10}, preq=426299}, -- A Test of Courage // Eine Prüfung des Mutes
[426752]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[548677]=  1}, giver=123164, taker=123058, rew={545873,31959,10}, preq=426558}, -- A Test of Strength // Eine Prüfung der Stärke
[426753]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[243054]= 10}, giver=123061, rew={545873,31959,10}, preq={426672,426569}}, -- Emergency Supply // Notfallmedizin
[426754]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[240977]=  8}, giver=123063, rew={545873,31959,10}, preq={426614,426670}}, -- Sonoceptive Eyes // Schallseher-Auge
[426755]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[240975]=  8}, giver=123063, rew={545873,31959,10}, preq={426614,426680}}, -- Energy Rift // Energiespalte
[426756]={typ= 1, lvl=86, rlvl=83, zone= 28, items={[240974]= 10}, giver={123060,123068}, rew={545873,31959,10}, preq={426681,426682}}, -- Energetic Origins // Der Ursprung der Energie
[426764]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[241744]= 10}, giver=123107, rew={545873,31959,10}, preq=426648}, -- Ailic's Spirit of Inquiry // Ailics Forschergeist
[426765]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[241746]=  5}, giver=123156, rew={545873,31959,10}, preq=426646}, -- The More Offerings, The Better // Je mehr Opfergaben, desto besser
[426771]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[242938]= 10}, giver=123051, rew={545873,31959,10}, preq=426712}, -- Secret Ingredients // Das Innere ist ein Geheimnis
[426805]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[108391]= 10}, giver=123193, rew={545873,31959,10}, preq=426714}, -- Oust the Franko Pirates // Vertreibt die Frankopiraten
[426806]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[108185]= 10}, giver=123178, rew={545873,31959,10}, preq=426715}, -- The Reckoning // Endabrechnung
[426807]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[108187]= 10}, giver=123178, rew={545873,31959,10}, preq=426716}, -- The Second Reckoning // Die zweite Endabrechnung
[426808]={typ= 1, lvl=86, rlvl=84, zone= 28, items={[243088]= 10}, giver=123150, rew={545873,31959,10}, preq=426713}, -- Horned Beast Leather // Hornbestienleder
[426809]={typ= 2, lvl=86, rlvl=84, zone= 28, mobs={[108334]=  5}, giver=123172, rew={545873,31959,10}, preq=426717}, -- Faith // Glauben
[426726]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243022]=  6}, giver=123032, rew={0,0,0,100}, preq=426683}, -- The Enigma of the Old Ship // Das Rätsel des alten Schiffes
[426727]={typ= 2, lvl=87, rlvl=85, zone= 28, mobs={[107941]=  8}, giver=123034, rew={0,0,0,100}, preq=426684}, -- Nothing But Hot Air // Nur heiße Luft
[426728]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243026]=  2,[243027]=  3,[243028]=  1}, giver=123037, rew={0,0,0,150}, preq=426687}, -- Even Death Won't Change Anything... // Selbst der Tod wird nichts ändern ...
[426729]={typ= 2, lvl=87, rlvl=85, zone= 28, mobs={[107936]=  8}, giver=123041, rew={0,0,0,100}, preq=426688}, -- Securing the Roads // Die Straßen sicher machen
[426730]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243050]=  6}, giver=123042, rew={0,0,0,150}, preq=426689}, -- Fixing for a Stroll // Reparieren und Spazieren
[426731]={typ= 2, lvl=87, rlvl=85, zone= 28, mobs={[107938]=  8}, giver=123044, rew={0,0,0,100}, preq=426691}, -- The First Step // Das ist nur der erste Schritt
[426732]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243030]=  5}, giver=123044, rew={0,0,0,100}, preq=426691}, -- The Pure Essence // Die reine Essenz
[426733]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243031]=  5}, giver=123046, rew={0,0,0,100}, preq=426692}, -- Singing in Key // Der Ton des Gesangs
[426766]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243071]=  5}, giver=123107, rew={0,0,0,80}, preq=426649}, -- Nature's Medicine // Naturmedizin
[426767]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243066]= 10}, giver=123101, rew={0,0,0,50}, preq=426638}, -- Plundering Pirates // Plündernde Piraten
[426768]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[242074]= 10}, giver=123141, rew={0,0,0,80}, preq=426643}, -- Mark of the Warrior // Das Zeugnis eines Kriegers
[426769]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[241744]= 10}, giver=123107, rew={0,0,0,80}, preq=426648}, -- Ailic's Spirit of Inquiry // Ailics Forschergeist
[426770]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[241746]=  5}, giver=123156, rew={0,0,0,100}, preq=426646}, -- The More Offerings, The Better // Je mehr Opfergaben, desto besser.
[426772]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[242938]= 10}, giver=123051, rew={0,0,0,100}, preq=426712}, -- Secret Ingredients // Das Innere ist ein Geheimnis
[426810]={typ= 2, lvl=87, rlvl=85, zone= 28, mobs={[108391]= 10}, giver=123193, rew={0,0,0,100}, preq=426714}, -- Oust the Franko Pirates // Vertreibt die Frankopiraten
[426811]={typ= 2, lvl=87, rlvl=85, zone= 28, mobs={[108185]= 10}, giver=123178, rew={0,0,0,100}, preq=426715}, -- Final Reckoning // Endabrechnung
[426812]={typ= 2, lvl=87, rlvl=85, zone= 28, mobs={[108187]= 10}, giver=123178, rew={0,0,0,100}, preq=426716}, -- The Second Reckoning // Die zweite Endabrechnung
[426813]={typ= 1, lvl=87, rlvl=85, zone= 28, items={[243088]=  5}, giver=123150, rew={0,0,0,100}, preq=426713}, -- Horned Beast Leather // Hornbestienleder
[426814]={typ= 2, lvl=87, rlvl=85, zone= 28, mobs={[108334]=  5}, giver=123172, rew={0,0,0,100}, preq=426717}, -- Faith // Glauben
--[[ ] ]]

--[[ [ Salioca Basin / Saliocabecken (29) ]]
[423099]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201570]= 10}, giver=123023, rew={0,0,0,120}, preq=422753}, -- A Good Deed Every Day // Jeden Tag eine gute Tat
[423441]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201570]= 10}, giver=123023, rew={564012,39796,10}, preq=422753}, -- A Good Deed Every Day // Jeden Tag eine gute Tat
[423442]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103410]= 10}, giver=122792, rew={564012,39796,10}, preq=422754}, -- The Exorcist // Der Exorzist
[423443]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201561]= 10}, giver=123023, rew={564012,39796,10}, preq=422757}, -- The Wisdom of Adam // Adams Weisheit
[423473]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201565]= 10}, giver=122953, rew={564012,39796,10}, preq=423093}, -- Blood Red Honey // Blutroter Honig
[423678]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103407]= 10}, giver=122859, taker=122792, rew={564012,39796,10}, preq=423096}, -- Restless Swarm // Unruhiger Schwarm
[423679]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103409]=  5,[103416]=  3}, giver=122953, rew={564012,39796,10}, preq=423098}, -- Medical Science // Medizinkunde
[423913]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201569]= 10}, giver=122953, rew={564012,39796,10}, preq=423098}, -- Not Just A Doctor // Nicht nur Arzt
[423983]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201559]= 10}, giver=122792, rew={564012,39796,10}, preq=421640}, -- Every Last Penny // Der letzte Groschen
[423991]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103396]=  5,[108242]=  5,[108243]=  5}, giver=122859, rew={564012,39796,10}, preq=421640}, -- The Road to Vengeance I // Der Weg der Rache I
[423995]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[107945]=  1}, giver=122859, rew={564012,39796,10}, preq=423991}, -- The Road to Vengeance II // Der Weg der Rache II
[423996]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103410]= 10}, giver=122792, rew={0,0,0,50}, preq=422754}, -- The Exorcist // Der Exorzist
[423999]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201561]= 10}, giver=123023, rew={0,0,0,120}, preq=422757}, -- The Wisdom of Adam // Adams Weisheit
[424005]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201565]= 10}, giver=122953, rew={0,0,0,120}, preq=423093}, -- Blood Red Honey // Blutroter Honig
[424006]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103407]= 10}, giver=122859, taker=122792, rew={0,0,0,50}, preq=423096}, -- Restless Swarm // Unruhiger Schwarm
[424008]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103409]=  5,[103416]=  3}, giver=122953, rew={0,0,0,50}, preq=423098}, -- Medical Science // Medizinkunde
[424362]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201569]= 10}, giver=122953, rew={0,0,0,120}, preq=423098}, -- Not Just A Doctor // Nicht nur Arzt
[424461]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[201559]= 10}, giver=122792, rew={0,0,0,150}, preq=421640}, -- Every Last Penny // Der letzte Groschen
[424520]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103396]=  5,[108242]=  5,[108243]=  5}, giver=122859, rew={0,0,0,50}, preq=421640}, -- The Road to Vengeance I // Der Weg der Rache I
[424521]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[107945]=  1}, giver=122859, rew={0,0,0,50}, preq={421640,423991}}, -- The Road to Vengeance II // Der Weg der Rache II
[426850]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[108241]= 10}, giver=122562, rew={0,0,0,50}, preq=426910}, -- Ex-Verminator // Schädlingsbekämpfung
[426851]={typ= 1, lvl=88, rlvl=86, zone= 29, items={[209003]= 10}, giver=122562, rew={0,0,0,80}, preq=426911}, -- Hoarding Provisions // Proviant horten
[426852]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[108256]= 10}, giver=123212, rew={0,0,0,80}, preq=426815}, -- The Plague of Bees // Die Bienenplage
[426968]={typ= 2, lvl=88, rlvl=86, zone= 29, mobs={[103396]= 10}, giver=122376, rew={0,0,0,80}, preq=426909}, -- A Walk on the Safe Side // Sicher ist sicher
[426842]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108256]= 10}, giver=123212, rew={586798,43657,10}, preq=426815}, -- The Plague of Bees // Die Bienenplage
[426843]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108252]=  6,[108254]=  6}, giver=123211, rew={586798,43657,10}, preq=426817}, -- The End of the Illusions // Das Ende der Illusionen
[426844]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[209972]= 10}, giver=123213, rew={586798,43657,10}, preq=426819}, -- Ever More Blossom // Noch mehr Blüten
[426845]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108245]=  6,[108246]=  6}, giver=123219, rew={586798,43657,10}, preq=426820}, -- Infected Creatures // Infizierte Tiere
[426846]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[209973]=  5}, giver=123213, rew={586798,43657,10}, preq=426821}, -- Time For One Last Shake // Und jetzt noch kurz schütteln
[426847]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[107944]=  5}, giver=123213, rew={586798,43657,10}, preq=426822}, -- Disease Control // Seuchenschutz
[426848]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[209974]=  5}, giver=123217, rew={586798,43657,10}, preq=426824}, -- Cultivating Walu Mushrooms // Walu-Pilzzucht
[426849]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[242941]=  5}, giver=123220, rew={586798,43657,10}, preq=426825}, -- Hunt for the Light Source // Die Jagd nach der Lichtquelle
[426853]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108252]=  6,[108254]=  6}, giver=123211, rew={0,0,0,80}, preq=426817}, -- The End of the Illusions // Das Ende der Illusionen
[426854]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[209972]= 10}, giver=123213, rew={0,0,0,60}, preq=426819}, -- Ever More Blossom // Noch mehr Blüten
[426855]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108245]=  6,[108246]=  6}, giver=123219, rew={0,0,0,80}, preq=426820}, -- Infected Creatures // Infizierte Tiere
[426856]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[209973]=  5}, giver=123213, rew={0,0,0,80}, preq=426821}, -- Time For One Last Shake // Und jetzt noch kurz schütteln
[426857]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[107944]=  5}, giver=123213, rew={0,0,0,100}, preq=426822}, -- Disease Control // Seuchenschutz
[426919]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108253]= 10}, giver=123225, rew={586798,43657,10}, preq=426786}, -- Researching the Old Mechanisms // Erforscher der alten Mechanismen
[426920]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108253]= 10}, giver=123225, rew={0,0,0,100}, preq=426786}, -- Researching the Old Mechanisms // Erforscher der alten Mechanismen
[426929]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108570]= 10}, giver=123388, rew={586798,43657,10}, preq=426787}, -- The Jungle Gardener // Der Gärtner des Dschungels
[426930]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243136]= 10}, giver=123392, rew={586798,43657,10}, preq=426790}, -- The Joys of Writing // Die Freuden des Schreibens
[426931]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[548832]=  1}, giver=123392, rew={586798,43657,10}, preq=426790}, -- Gerador's Courier // Geradors Kurier
[426932]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243137]= 10}, giver=123396, rew={586798,43657,10}, preq=426791}, -- Tuning the Devices // Das Richten der Geräte
[426933]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[548833]=  1,[548834]=  1}, giver=123385, rew={586798,43657,10}, preq=426792}, -- One More Fight // Noch ein Kampf
[426934]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243138]= 10}, giver=123383, rew={586798,43657,10}, preq=426793}, -- Meals in the Parasite Jungle // Die Mahlzeit im Parasiten-Dschungel
[426935]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243139]= 10}, giver=123382, rew={586798,43657,10}, preq=426901}, -- Light at Night // Ein nächtliches Licht
[426936]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243144]= 10}, giver=123407, rew={586798,43657,10}, preq=426902}, -- The Fragment Collector // Fragmentesammler
[426937]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243147]=  5}, rew={586798,43657,10}, preq=426903}, -- The Purgatory's Coming // Die Fegefeuer kommt
[426941]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108570]= 10}, giver=123388, rew={0,0,0,100}, preq=426787}, -- The Jungle Gardener // Der Gärtner des Dschungels
[426942]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243136]= 10}, giver=123392, rew={0,0,0,100}, preq=426790}, -- The Joys of Writing // Die Freuden des Schreibens
[426943]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[548832]=  1}, giver=123392, rew={0,0,0,200}, preq=426790}, -- Gerador's Courier // Geradors Kurier
[426944]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243137]= 10}, giver=123396, rew={0,0,0,100}, preq=426791}, -- Tuning the Devices // Das Richten der Geräte
[426945]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[548833]=  1,[548834]=  1}, giver=123385, rew={0,0,0,80}, preq=426792}, -- One More Fight // Noch ein Kampf
[426946]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243138]= 10}, giver=123383, rew={0,0,0,60}, preq=426793}, -- Meals in the Parasite Jungle // Die Mahlzeit im Parasiten-Dschungel
[426947]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243139]= 10}, giver=123382, rew={0,0,0,80}, preq=426901}, -- Light at Night // Ein nächtliches Licht
[426948]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243144]= 10}, giver=123407, rew={0,0,0,100}, preq=426902}, -- The Fragment Collector // Fragmentesammler
[426951]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243146]=  5}, giver=123432, rew={586798,43657,10}, preq=426667}, -- Lessons of the Shaman // Die Lehre des Schamanen
[426952]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243145]= 10}, giver=123384, rew={586798,43657,10}, preq=426923}, -- The Entling's Wooden Shell // Die Holzschale des Entlings
[426960]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243147]=  5}, rew={0,0,0,360}, preq=426903}, -- The Purgatory's Coming // Die Fegefeuer kommt
[426963]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108241]= 10}, giver=122562, rew={586798,43657,10}, preq=426910}, -- Ex-Verminator // Schädlingsbekämpfung
[426964]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[209003]= 10}, giver=122562, rew={586798,43657,10}, preq=426911}, -- Hoarding Provisions // Proviant horten
[426965]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243099]= 10}, giver=123220, rew={586798,43657,10}, preq=426914}, -- Constant Change // Steter Wandel
[426966]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[208972]= 10}, giver=122647, rew={586798,43657,10}, preq=426917}, -- Get Some More // Besorgt noch ein paar
[426967]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[103396]= 10}, giver=122376, rew={586798,43657,10}, preq=426909}, -- A Walk on the Safe Side // Sicher ist sicher
[426996]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243150]= 10}, giver=123444, rew={586798,43657,10}, preq=426880}, -- Firewood Supplier // Brennholzlieferant
[426997]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243151]= 10}, giver=123444, rew={586798,43657,10}, preq=426881}, -- Ore Supplier // Erzlieferant
[426998]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243152]= 10}, giver=123444, rew={586798,43657,10}, preq=426882}, -- Plant Materials // Pflanzenmaterialien
[426999]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108233]= 10}, giver=123535, rew={586798,43657,10}, preq=426927}, -- Counter-Espionage // Spionageabwehr
[427000]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243192]=  5}, giver=123444, rew={586798,43657,10}, preq=426969}, -- Healthy Snake Poison // Gesundes Schlangengift
[427001]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243193]=  8}, giver=123460, rew={586798,43657,10}, preq=426969}, -- The Blood of the Harpy // Das Blut einer Harpyie
[427002]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243148]=  8}, giver=123461, rew={586798,43657,10}, preq=426969}, -- A Body to be Treasured // Der ganze Körper ein Schatz
[427003]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108255]=  8}, giver=123461, rew={586798,43657,10}, preq=426969}, -- The Pursuit // Die Verfolgung
[427004]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243153]= 10}, giver=123535, rew={586798,43657,10}, preq={426969,426924}}, -- The Unique Taste of Meat // Der einmalige Geschmack des Fleisches
[427005]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243195]= 10}, giver=123460, rew={586798,43657,10}, preq=426969}, -- Wings of Fortune // Schwingen des Glücks
[427006]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243170]=  3}, giver=123244, rew={586798,43657,10}, preq=426838}, -- The Brutal Blood Vine // Die Brutale Blutranke
[427010]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108233]= 10}, giver=123535, rew={0,0,0,100}, preq=426927}, -- Counter-Espionage // Spionageabwehr
[427011]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243192]=  5}, giver=123444, rew={0,0,0,80}, preq=426969}, -- Healthy Snake Poison // Gesundes Schlangengift
[427012]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243193]=  8}, giver=123460, rew={0,0,0,100}, preq=426969}, -- The Blood of the Harpy // Das Blut einer Harpyie
[427013]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243148]=  8}, giver=123461, rew={0,0,0,150}, preq=426969}, -- A Body to be Treasured // Der ganze Körper ein Schatz
[427014]={typ= 2, lvl=89, rlvl=87, zone= 29, mobs={[108255]=  8}, giver=123461, rew={0,0,0,100}, preq=426969}, -- The Pursuit // Die Verfolgung
[427015]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243153]= 10}, giver=123535, rew={0,0,0,50}, preq={426969,426924}}, -- The Unique Taste of Meat // Der einmalige Geschmack des Fleisches
[427016]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243195]= 10}, giver=123460, rew={0,0,0,50}, preq=426969}, -- Wings of Fortune // Schwingen des Glücks
[427017]={typ= 1, lvl=89, rlvl=87, zone= 29, items={[243170]=  3}, giver=123244, rew={0,0,0,150}, preq=426838}, -- The Brutal Blood Vine // Die Brutale Blutranke
[426858]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[209974]=  5}, rew={0,0,0,100}, preq=426824}, -- Cultivating Walu Mushrooms // Walu-Pilzzucht
[426859]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[242941]=  5}, giver=123220, rew={0,0,0,80}, preq=426825}, -- Hunt for the Light Source // Die Jagd nach der Lichtquelle
[426860]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[243099]= 10}, giver=123220, rew={0,0,0,80}, preq=426914}, -- Constant Change // Steter Wandel
[426861]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[208972]= 10}, giver=122647, rew={0,0,0,80}, preq=426917}, -- Get Some More // Besorgt noch ein paar
[426949]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[243146]=  5}, giver=123432, rew={0,0,0,150}, preq=426667}, -- Lessons of the Shaman // Die Lehre des Schamanen
[426950]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[243145]= 10}, giver=123384, rew={0,0,0,60}, preq=426923}, -- The Entling's Wooden Shell // Die Holzschale des Entlings
[427007]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[243150]= 10}, giver=123444, rew={0,0,0,50}, preq=426880}, -- Firewood Supplier // Brennholzlieferant
[427008]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[243151]= 10}, giver=123444, rew={0,0,0,50}, preq=426881}, -- Ore Supplier // Erzlieferant
[427009]={typ= 1, lvl=90, rlvl=88, zone= 29, items={[243152]= 10}, giver=123444, rew={0,0,0,50}, preq=426882}, -- Plant Materials // Pflanzenmaterialien
--[[ ] ]]

--[[ [ Kashaylan / Kashaylan (30) ]]
[424726]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201554]= 12}, giver=122552, rew={635168,48146,10}, preq=424522}, -- Drinking Water Source // Trinkwasserquelle
[424727]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201581]=  8}, giver=122553, rew={635168,48146,10}, preq=424665}, -- Private Research // Private Forschung
[424728]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201584]=  1}, giver=122557, rew={635168,48146,10}, preq=424708}, -- Don't Kill The Golden Hen! // Tötet die goldene Henne nicht!
[424729]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243108]= 10}, giver=122556, rew={635168,48146,10}, preq=424724}, -- Attitude Problems // Was soll denn diese Einstellung?
[424730]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[103750]=  6}, giver=122555, rew={635168,48146,10}, preq=424723}, -- Untenable Conditions // Unhaltbare Zustände
[424752]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[103430]= 15}, giver=122554, rew={635168,48146,10}, preq=424725}, -- Who Has Amnesia Now? // Wer hatte jetzt den Gedächtnisverlust?
[424753]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201588]=  8,[201589]=  8}, giver=122558, rew={635168,48146,10}}, -- Drink of their Blood, Eat of their Flesh // Trinkt des Feindes Blut, esst des Feindes Fleisch
[424754]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[103427]=  8,[103428]=  5}, giver=117247, rew={635168,48146,10}, preq=421655}, -- Retribution Plans // Vergeltungspläne
[424755]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201573]= 10,[201575]= 10}, giver=117246, rew={1270336,48146,10}, preq=422654}, -- Finding an Alternative // Einen anderen Weg finden
[424756]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201573]= 20}, giver=117246, taker=117245, rew={1270336,48146,10}, preq=422654}, -- Trade-Go-Round // Tauschkarusell
[424757]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[548802]=  1}, giver=123476, rew={635168,48146,10}, preq=427088}, -- The Archenemy // Der Erzfeind
[424758]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201554]= 12}, giver=122552, rew={0,0,0,180}, preq=424522}, -- Drinking Water Source // Trinkwasserquelle
[424759]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201581]=  8}, giver=122553, rew={0,0,0,120}, preq=424665}, -- Private Research // Private Forschung
[424760]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201584]=  1}, giver=122557, rew={0,0,0,320}, preq=424708}, -- Don't Kill The Golden Hen! // Tötet die goldene Henne nicht!
[424761]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243108]= 10}, giver=122556, rew={0,0,0,180}, preq=424724}, -- Attitude Problems // Was soll denn diese Einstellung?
[424762]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[103750]=  6}, giver=122555, rew={0,0,0,180}, preq=424723}, -- Untenable Conditions // Unhaltbare Zustände
[424763]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[103430]= 15}, giver=122554, rew={0,0,0,120}, preq=424725}, -- Who Has Amnesia Now? // Wer hatte jetzt den Gedächtnisverlust?
[424764]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201588]=  8,[201589]=  8}, giver=122558, rew={0,0,0,120}}, -- Drink of their Blood, Eat of their Flesh // Trinkt des Feindes Blut, esst des Feindes Fleisch
[424765]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[103427]=  8,[103428]=  5}, giver=117247, rew={0,0,0,120}}, -- Retribution Plans // Vergeltungspläne
[424766]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201573]= 10,[201575]= 10}, giver=117246, rew={0,0,0,50}, preq=422654}, -- Finding an Alternative // Einen anderen Weg finden
[424767]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201573]= 20}, giver=117246, taker=117245, rew={0,0,0,50}, preq=422654}, -- Trade-Go-Round // Tauschkarusell
[426938]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243106]= 10}, giver=123309, rew={635168,48146,10}, preq=426797}, -- Earth Crystal // Erdkristall
[426939]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243107]= 10}, giver=123310, rew={635168,48146,10}, preq=426798}, -- Rock Agate // Felsachat
[426940]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243108]= 10}, giver=123311, rew={635168,48146,10}, preq=426799}, -- Fragments from the Otherworld // Fragmente aus der Anderswelt
[427018]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243115]=  3}, giver=123312, rew={635168,48146,10}, preq=426800}, -- Teachers and their Pupils // Lehrer und Schüler
[427019]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243109]=  1}, giver=123313, rew={635168,48146,10}, preq=426801}, -- The Eagle Hunt // Adlerjagd
[427020]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201572]=  6,[201574]=  6,[201575]=  6}, giver=123308, rew={1270336,48146,10}, preq=426970}, -- Business Plans // Geschäftspläne
[427021]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]= 10,[201573]= 10}, giver=123477, rew={1270336,48146,10}, preq=426971}, -- Mutual Transactions // Wechselseitige Transaktion
[427022]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201572]= 10,[201574]= 10}, giver=123478, rew={1270336,48146,10}, preq=426972}, -- Culinary Trials // Kulinarische Versuche
[427023]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201573]= 10,[201575]= 10}, giver=123306, rew={1270336,48146,10}, preq=426973}, -- Camp Calls // Lagerbesuche
[427024]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]=  4,[201572]=  4,[201573]=  4,[201574]=  4,[201575]=  4}, giver=123306, rew={1270336,48146,10}, preq=426974}, -- Maintaining the Seal // Siegelpflege
[427026]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243107]= 10}, giver=123310, rew={0,0,0,80}, preq=426798}, -- Rock Agate // Felsachat
[427027]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243108]= 10}, giver=123311, rew={0,0,0,120}, preq=426799}, -- Fragments from the Otherworld // Fragmente aus der Anderswelt
[427028]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243115]=  3}, giver=123312, rew={0,0,0,100}, preq=426800}, -- Teachers and their Students // Lehrer und Schüler
[427030]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201572]=  6,[201574]=  6,[201575]=  6}, giver=123308, rew={0,0,0,200}, preq=426970}, -- Business Plans // Geschäftspläne
[427031]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]= 10,[201573]= 10}, giver=123477, rew={0,0,0,300}, preq=426971}, -- Mutual Transactions // Wechselseitige Transaktion
[427032]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201572]= 10,[201574]= 10}, giver=123478, rew={0,0,0,250}, preq=426972}, -- Culinary Trials // Kulinarische Versuche
[427033]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201573]= 10,[201575]= 10}, giver=123306, rew={0,0,0,250}, preq=426973}, -- Camp Calls // Lagerbesuche
[427034]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]=  4,[201572]=  4,[201573]=  4,[201574]=  4,[201575]=  4}, giver=123306, rew={0,0,0,250}, preq=426974}, -- Maintaining the Seal // Siegelpflege
[427045]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[108493]=  6,[108495]=  6}, giver=115807, rew={635168,48146,10}, preq=426986}, -- Only Practice // Es ist nur Übung
[427046]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[548862]=  1}, giver=121963, rew={635168,48146,10}, preq=426991}, -- More Practice // Noch mal Üben
[427047]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[208971]=  1}, giver=121963, rew={635168,48146,10}, preq=426991}, -- Improving Fighting Skills // Kampffähigkeit steigern
[427048]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243179]=  1}, giver=123561, rew={635168,48146,10}, preq=426988}, -- Research Expert // Forschungsexperte
[427049]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[106290]=  5}, giver=123561, rew={635168,48146,10}, preq=426987}, -- Investigating the Statue // Steinstatue untersuchen
[427050]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243180]= 10}, giver=123509, rew={635168,48146,10}, preq=426991}, -- Fresh Meat // Frisches Fleisch
[427051]={typ= 2, lvl=91, rlvl=89, zone= 30, mobs={[108497]=  5}, giver=123509, rew={635168,48146,10}, preq=426991}, -- Hardy Resolve // Durchsetzungsvermögen
[427052]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[241088]= 10}, giver=115807, rew={635168,48146,10}, preq=426992}, -- Weird Skulls // Kuriose Schädel
[427053]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243177]= 10}, giver=123366, rew={635168,48146,10}, preq=426995}, -- Wishing Runes // Wunschrunen
[427054]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[548165]=  1}, giver=123366, rew={635168,48146,10}, preq=426995}, -- Wishing Inc. // Wunschservice
[427065]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243181]= 10}, giver=123341, rew={635168,48146,10}, preq=427036}, -- The Fish Course // Fischgericht
[427066]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243182]= 10}, giver=123341, rew={635168,48146,10}, preq=427037}, -- The Secrets of Swamp Bear Meat // Das Geheimnis des Duftbärfleisches
[427067]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243183]= 10}, giver=123342, rew={635168,48146,10}, preq=427039}, -- Herbs of Healing // Heilkraut
[427068]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243184]= 10}, giver=123340, rew={635168,48146,10}, preq=427040}, -- Decontamination // Dekontamination
[427069]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243185]= 10}, giver=123343, rew={635168,48146,10}, preq=427042}, -- Essence of Water // Essenz des Wassers
[427070]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243186]= 10}, giver=123344, rew={635168,48146,10}, preq=427043}, -- Runic Sky Fire // Runen-Himmelsfeuer
[427071]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]=  7,[201572]=  7,[201573]=  7,[201574]=  7}, giver=123339, rew={1270336,48146,10}, preq=427041}, -- Stabilizing Pillars // Steinsäule stabilisieren
[427072]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]= 10,[201572]= 10,[201575]=  5}, giver=123351, rew={1270336,48146,10}, preq=427041}, -- Black Marketing // Schwarzhandel
[427073]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]=  5,[201573]=  5,[201575]=  5,[243187]=  1}, giver=123351, rew={1270336,48146,10}, preq=427041}, -- Evil Fish King // Boshafter Fischkönig
[427074]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201572]=  5,[201574]=  5,[201575]=  5,[243188]=  1}, giver=123351, rew={1270336,48146,10}, preq=427041}, -- King Torrent Crab // Sturzflut-Krebskönig
[427075]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243181]= 10}, giver=123341, rew={0,0,0,100}, preq=427036}, -- The Fish Course // Fischgericht
[427076]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243182]= 10}, giver=123341, rew={0,0,0,100}, preq=427037}, -- The Secrets of Swamp Bear Meat // Das Geheimnis des Duftbärfleisches
[427077]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243183]= 10}, giver=123342, rew={0,0,0,100}, preq=427039}, -- Herbs of Healing // Heilkraut
[427078]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243184]= 10}, giver=123340, rew={0,0,0,100}, preq=427040}, -- Decontamination // Dekontamination
[427079]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243185]= 10}, giver=123343, rew={0,0,0,100}, preq=427042}, -- Essence of Water // Essenz des Wassers
[427080]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[243186]= 10}, giver=123344, rew={0,0,0,100}, preq=427043}, -- Runic Sky Fire // Runen-Himmelsfeuer
[427081]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]=  7,[201572]=  7,[201573]=  7,[201574]=  7}, giver=123339, rew={0,0,0,400}, preq=427041}, -- Stabilizing Pillars // Steinsäule stabilisieren
[427082]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]= 10,[201572]= 10,[201575]=  5}, giver=123351, rew={0,0,0,250}, preq=427041}, -- Black Marketing // Schwarzhandel
[427083]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201571]=  5,[201573]=  5,[201575]=  5,[243187]=  1}, giver=123351, rew={0,0,0,200}, preq=427041}, -- Evil Fish King // Boshafter Fischkönig
[427084]={typ= 1, lvl=91, rlvl=89, zone= 30, items={[201572]=  5,[201574]=  5,[201575]=  5,[243188]=  1}, giver=123351, rew={0,0,0,200}, preq=427041}, -- King Torrent Crab // Sturzflut-Krebskönig
[426199]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[548802]=  1}, giver=123476, rew={0,0,0,250}, preq=427088}, -- The Archenemy // Der Erzfeind
[427055]={typ= 2, lvl=92, rlvl=90, zone= 30, mobs={[108493]=  6,[108495]=  6}, giver=115807, rew={0,0,0,80}, preq=426986}, -- Only Practice // Es ist nur Übung
[427056]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[548862]=  1}, giver=121963, rew={0,0,0,150}, preq=426991}, -- More Practice // Noch mal Üben
[427057]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[208971]=  1}, giver=121963, rew={0,0,0,100}, preq=426991}, -- Improving Fighting Skills // Kampffähigkeit steigern
[427058]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[243179]=  1}, rew={0,0,0,80}, preq=426988}, -- Research Expert // Forschungsexperte
[427059]={typ= 2, lvl=92, rlvl=90, zone= 30, mobs={[106290]=  5}, giver=123561, rew={0,0,0,80}, preq=426987}, -- Investigating the Statue // Steinstatue untersuchen
[427060]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[243180]= 10}, giver=123509, rew={0,0,0,50}, preq=426991}, -- Fresh Meat // Frisches Fleisch
[427061]={typ= 2, lvl=92, rlvl=90, zone= 30, mobs={[108497]=  5}, giver=123509, rew={0,0,0,50}, preq=426991}, -- Hardy Resolve // Durchsetzungsvermögen
[427062]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[241088]= 10}, giver=115807, rew={0,0,0,50}, preq=426992}, -- Weird Skulls // Kuriose Schädel
[427063]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[243177]= 10}, giver=123366, rew={0,0,0,50}, preq=426995}, -- Wishing Runes // Wunschrunen
[427064]={typ= 1, lvl=92, rlvl=90, zone= 30, items={[548165]=  1}, giver=123366, rew={0,0,0,50}, preq=426995}, -- Wishing Inc. // Wunschservice
--[[ ] ]]

--[[ [ Yrvandis Hollows / Höhlen von Yrvandis (31) ]]
[425221]={typ=22, lvl= 7, rlvl= 5, zone= 31, mobs={[106684]= 15}, giver=120441, rew={177,385,10}, preq=425032}, -- No.1 Chef Assistant // Erster Kochgehilfe
[425226]={typ=21, lvl= 7, rlvl= 5, zone= 31, items={[241083]=  5}, giver=120451, rew={177,385,10}, preq=425027}, -- More Shadow Hearts // Mehr Schattenherzen
[425222]={typ=22, lvl= 8, rlvl= 6, zone= 31, mobs={[106566]= 10}, giver=120457, rew={228,445,10}, preq=425043}, -- Needs more focus // Braucht mehr Fokus
[425227]={typ=21, lvl= 8, rlvl= 6, zone= 31, items={[240802]= 15}, giver=120446, rew={228,445,10}, preq=425037}, -- Reserve Tool Maintenance Oil // Reservewerkzeug-Wartungsöl
[425228]={typ=21, lvl= 8, rlvl= 6, zone= 31, items={[240804]=  5}, giver=120445, rew={228,445,10}, preq=425038}, -- Technique of Capturing Alive // Fangtechnik
[425223]={typ=22, lvl= 9, rlvl= 7, zone= 31, mobs={[106687]= 10}, giver=120458, rew={283,501,10}, preq=425046}, -- Temperature Control // Temperaturkontrolle
[425224]={typ=21, lvl= 9, rlvl= 7, zone= 31, items={[241116]= 10}, giver=120455, rew={283,501,10}, preq=425052}, -- Extra Recycling // Wiederverwertung
[425225]={typ=22, lvl= 9, rlvl= 7, zone= 31, mobs={[106688]=  5}, giver=120456, rew={283,501,10}, preq=425054}, -- Resisting the Outside Threat // Der äußeren Bedrohung widerstehen
[425229]={typ= 2, lvl= 9, rlvl= 7, zone= 31, mobs={[106563]= 10}, giver=120449, rew={283,501,10}, preq=425048}, -- Punish Food Thieves // Strafe den Nahrungsdieben
[425230]={typ= 2, lvl= 9, rlvl= 7, zone= 31, mobs={[106567]= 10}, giver=120447, rew={283,501,10}, preq=425050}, -- Tarhanis' Revenge // Tarhanis' Rache
--[[ ] ]]

--[[ [ Splitwater Coast / Splitterstromküste (32) ]]
[427211]={typ=22, lvl=93, rlvl=91, zone= 32, mobs={[103751]= 10}, giver=123706, rew={0,0,0,100}, preq=427129}, -- The Phoney War // Der nicht erklärte Krieg
[427213]={typ=21, lvl=93, rlvl=91, zone= 32, items={[203445]= 10}, giver=123795, rew={0,0,0,80}, preq=427132}, -- The General Commissioned Officer's Minister // Gesandter des Allgemeinen Dienstoffiziers
[427214]={typ=21, lvl=93, rlvl=91, zone= 32, items={[203448]=  3}, giver=123798, rew={0,0,0,50}, preq=427135}, -- The Story of the Statue // Die Geschichte der Statue
[427216]={typ=21, lvl=93, rlvl=91, zone= 32, items={[203603]= 10}, giver=123800, rew={654786,57371,10}, preq=427179}, -- The Capitalist Ethic // Verkaufsethik
[427217]={typ=22, lvl=93, rlvl=91, zone= 32, mobs={[103752]= 10}, giver=123802, rew={0,0,0,50}, preq=427180}, -- Please Squire, I Want Some More // Hand hoch, wer noch kein Essen bekommen hat
[427219]={typ=22, lvl=93, rlvl=91, zone= 32, mobs={[108673]= 10}, giver=123805, rew={0,0,0,100}, preq=427185}, -- Into the Wild // Bedrohung aus der Wildnis
[427223]={typ=22, lvl=93, rlvl=91, zone= 32, mobs={[108675]= 10}, giver=123810, rew={0,0,0,120}, preq=427188}, -- Stubborn as a Kobold // Die hartnäckigen Kobolde
[427224]={typ=21, lvl=93, rlvl=91, zone= 32, items={[204101]= 10}, giver=123814, rew={0,0,0,80}, preq=427193}, -- The Missionaries and their Tablets // Die Missionare und ihre Steintafeln
[427226]={typ=21, lvl=93, rlvl=91, zone= 32, items={[204393]= 10}, giver=123681, rew={0,0,0,80}, preq=427195}, -- Putting a Stop to the Smuggling // Dem Schmuggel ein Ende bereiten
[427228]={typ=22, lvl=93, rlvl=91, zone= 32, mobs={[103755]= 10}, giver=123817, rew={0,0,0,80}, preq=427199}, -- Mushroom, Mushroom! // Vorsicht Giftpilze!
[427229]={typ=22, lvl=93, rlvl=91, zone= 32, mobs={[108719]= 10}, giver=123817, rew={0,0,0,100}, preq=427198}, -- Who Needs Doctors? // Wer braucht schon Ärzte?
[425091]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108870]= 10}, giver=123658, rew={681239,62872,10}, preq=425062}, -- Cleanliness is Next to Godliness // Für eine saubere Umgebung ist jeder verantwortlich
[427159]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108729]=  5,[108730]=  5}, giver=123569, rew={681239,62872,10}, preq=427100}, -- Escape Route // Fluchtweg
[427160]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108725]= 10}, giver=123665, rew={681239,62872,10}, preq=427107}, -- Of Mice and Meadows // Feldmäuse vertreiben
[427161]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243220]=  5,[243249]=  5}, giver=123667, rew={681239,62872,10}, preq=427112}, -- The Zen of Tool Maintenance // Werkzeugpflege ist das A und O
[427162]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108936]=  5}, giver=123667, rew={681239,62872,10}, preq=427113}, -- Renovation Work // Der große Umbau
[427163]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243221]= 10}, giver=123669, rew={681239,62872,10}, preq=427114}, -- Extra Food // Nahrungsergänzung
[427164]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108998]=  8}, giver=123670, rew={681239,62872,10}, preq=427115}, -- Hired Hands // Aushilfsträger
[427165]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[109000]=  5}, giver=123668, rew={681239,62872,10}, preq=427116}, -- Clean Wounds Heal Faster // Saubere Wunden heilen besser
[427166]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243250]=  5,[243251]=  5}, giver=123569, rew={681239,62872,10}, preq=427117}, -- Origins of the Mystery Men // Woher kommen die mysteriösen Menschen?
[427167]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243252]= 10}, giver=123668, rew={681239,62872,10}, preq=427118}, -- Missing Medicine // Fehlende Medikamente
[427169]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108894]= 10}, giver=123569, rew={0,0,0,120}, preq=427159}, -- Free the Hostages // Geiseln befreien
[427170]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108892]= 10}, giver=123570, rew={0,0,0,100}, preq=427098}, -- Go Back Whence You Came! // Geht dorthin zurück, wo Ihr hergekommen seid!
[427171]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108725]= 10}, giver=123665, rew={0,0,0,100}, preq=427107}, -- Of Mice and Meadows // Feldmäuse vertreiben
[427172]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243220]=  5,[243249]=  5}, giver=123667, rew={0,0,0,80}, preq=427112}, -- The Zen of Tool Maintenance // Werkzeugpflege ist das A und O
[427173]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243221]= 10}, giver=123669, rew={0,0,0,60}, preq=427114}, -- Food Supplements // Nahrungsergänzung
[427174]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108998]=  8}, giver=123670, rew={0,0,0,50}, preq=427115}, -- Hired Hands // Aushilfsträger
[427175]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243250]=  5,[243251]=  5}, giver=123569, rew={0,0,0,120}, preq=427117}, -- Origins of the Mystery Men // Woher kommen die mysteriösen Menschen?
[427176]={typ=21, lvl=94, rlvl=92, zone= 32, items={[243252]= 10}, giver=123668, rew={0,0,0,80}, preq=427118}, -- Missing Medicine // Fehlende Medikamente
[427177]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108726]= 10}, giver=123566, rew={0,0,0,100}, preq=427106}, -- A Great Honor // Einen großen Dienst erweisen
[427201]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[103432]= 12}, giver={123354,123656}, rew={681239,62872,10}, preq=425187}, -- Suspicious Ship Components // Verdächtige Schiffskomponenten
[427202]={typ=21, lvl=94, rlvl=92, zone= 32, items={[201599]= 10}, giver=123659, rew={681239,62872,10}, preq=425393}, -- Regional Foods // Regionale Nahrungsmittel
[427203]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108997]=  8,[108999]=  8}, giver=123660, rew={681239,62872,10}, preq=425394}, -- Two Left Hands in the River // Auch im Fluss zwei linke Hände
[427204]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108869]= 10}, giver=123718, rew={681239,62872,10}, preq=425989}, -- The Difficult Missionary // Der schwierige Missionar
[427205]={typ=21, lvl=94, rlvl=92, zone= 32, items={[201891]=  5,[201933]=  5}, giver=123719, rew={681239,62872,10}, preq=426072}, -- The Stone Bridge Project // Das Steinbrückenprojekt
[427206]={typ=21, lvl=94, rlvl=92, zone= 32, items={[549115]=  1}, giver=123723, rew={681239,62872,10}, preq=426074}, -- Sacrifices to the Omnisoul Sarcophagus // Opfergaben für den Allseelensarg
[427207]={typ=21, lvl=94, rlvl=92, zone= 32, items={[549116]=  1,[549117]=  1,[549118]=  1}, giver=123722, rew={681239,62872,10}, preq=427101}, -- The Piecemeal Progress // Einer nach dem anderen
[427208]={typ=21, lvl=94, rlvl=92, zone= 32, items={[549119]=  1}, giver=123722, rew={681239,62872,10}, preq=427102}, -- The Traitor Istye // Der Verräter Istye
[427209]={typ=21, lvl=94, rlvl=92, zone= 32, items={[542680]=  1}, giver=123723, rew={681239,62872,10}, preq=427103}, -- Secret of the Omnisoul Sarcophagus // Das Geheimnis des Allseelensargs
[427210]={typ=21, lvl=94, rlvl=92, zone= 32, items={[201937]= 10}, giver=123706, rew={681239,62872,10}, preq=427128}, -- The Old Hunger and the Sea // Das Meer als Nahrungsquelle
[427212]={typ=21, lvl=94, rlvl=92, zone= 32, items={[201938]= 10}, giver=123821, rew={681239,62872,10}, preq=427130}, -- The Shellfish Gene // Sich hinter einem Panzer verstecken
[427215]={typ=21, lvl=94, rlvl=92, zone= 32, items={[203449]=  5}, giver=123798, rew={681239,62872,10}, preq=427135}, -- Myths of the Gods // Göttermythen
[427218]={typ=21, lvl=94, rlvl=92, zone= 32, items={[203725]= 10}, giver=123804, rew={681239,62872,10}, preq=427183}, -- Material for the Artisan // Material für den Handwerker
[427220]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[108674]=  1}, giver=123805, rew={681239,62872,10}}, -- Heir to the Wolf King // Nachfolger des Wolfskönigs
[427221]={typ=21, lvl=94, rlvl=92, zone= 32, items={[203726]= 10}, giver=123806, rew={681239,62872,10}, preq=427186}, -- A Time of Spice // Zeit der Gewürze
[427222]={typ=21, lvl=94, rlvl=92, zone= 32, items={[203941]= 10}, giver=123808, rew={681239,62872,10}, preq=427187}, -- Rescue the River Cockles // Flussmuscheln retten
[427225]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[103753]= 10}, giver=123823, rew={681239,62872,10}, preq=427194}, -- The Tunnel of Bandits // Banditentunnel
[427227]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[103754]= 15}, giver=123817, rew={681239,62872,10}, preq=427196}, -- Attack, Attack, Attack! // Angriff, Angriff und nochmal Angriff
[427230]={typ=22, lvl=94, rlvl=92, zone= 32, mobs={[103756]= 10}, giver=123817, rew={681239,62872,10}}, -- Warning Notes // Warnhinweis
[427231]={typ=21, lvl=95, rlvl=93, zone= 32, items={[201595]= 10}, giver=123654, rew={0,0,0,120}, preq=425063}, -- Enemy Badges // Gegnerische Abzeichen
[427232]={typ=22, lvl=95, rlvl=93, zone= 32, mobs={[108864]= 10}, giver=123655, rew={0,0,0,120}, preq=425064}, -- Freeing the Slaves // Sklavenbefreiung
[427233]={typ=22, lvl=95, rlvl=93, zone= 32, mobs={[108847]= 12}, giver=123655, rew={0,0,0,100}, preq=425065}, -- Knowledge is Power // Information ist Macht
[427234]={typ=21, lvl=95, rlvl=93, zone= 32, items={[201591]= 10}, giver=123656, rew={0,0,0,100}, preq=425173}, -- In Store for Winter // Überwinterungsvorräte
[427235]={typ=21, lvl=95, rlvl=93, zone= 32, items={[201596]= 10}, giver=123715, rew={0,0,0,80}}, -- Boshi Fodder // Boshifutter
[427236]={typ=22, lvl=95, rlvl=93, zone= 32, mobs={[103434]=  8}, giver=123716, rew={0,0,0,50}, preq=425987}, -- Workin' at the Boshi Wash // Wie man Boshi putzt
[427237]={typ=22, lvl=95, rlvl=93, zone= 32, mobs={[103574]= 10}, giver=123715, rew={0,0,0,100}, preq=425986}, -- A Crisis of Worms // Wurmkrise
--[[ ] ]]

--[[ [ Moorlands of Farsitan / Hügelland von Farsitan (33) ]]
[427298]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109039]= 10,[109040]=  5}, giver=123949, rew={737394,77509,10}, preq=427269}, -- Bolster the Defenses! // Verteidigung aufrechterhalten!
[427299]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[103776]=  3}, giver=123952, rew={737394,77509,10}, preq=427270}, -- A Friend in Need // Ein Freund in Not
[427300]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204762]= 10}, giver=123953, rew={737394,77509,10}, preq=427271}, -- Hunting Season // Jagdsaison
[427301]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[103779]=  8}, giver=123956, rew={737394,77509,10}, preq=427272}, -- Consumed by the Flames // Ein feuriges Ende
[427302]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109061]=  5}, giver=123957, rew={737394,77509,10}, preq=427273}, -- Phantom Menace // Heimliche Bedrohung
[427303]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109188]=  1}, giver=123975, rew={737394,77509,10}, preq=427274}, -- The Skeleton General // Skelettgeneral
[427305]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204822]= 10}, giver=123963, rew={737394,77509,10}, preq=427275}, -- Swamp Berries // Sumpfbeeren
[427306]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[543851]=  1}, giver=123967, taker=123968, rew={737394,77509,10}, preq=427276}, -- Escort Duty // Geleitschutz
[427307]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[542582]=  1,[542586]=  1,[543860]=  1}, giver=123974, rew={737394,77509,10}, preq=427277}, -- The Leader's Worries // Die Sorgen des Leiters
[427308]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109039]= 10,[109040]=  5}, giver=123949, rew={0,0,0,160}, preq=427269}, -- Bolster the Defenses! // Verteidigung aufrechterhalten!
[427309]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[103776]=  3}, giver=123952, rew={0,0,0,160}, preq=427270}, -- A Friend in Need // Ein Freund in Not
[427310]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204762]= 10}, giver=123953, rew={0,0,0,100}, preq=427271}, -- Hunting Season // Jagdsaison
[427311]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[103779]=  8}, giver=123956, rew={0,0,0,80}, preq=427272}, -- Consumed by the Flames // Ein feuriges Ende
[427312]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109061]=  5}, giver=123957, rew={0,0,0,100}, preq=427273}, -- Phantom Menace // Heimliche Bedrohung
[427313]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109188]=  1}, giver=123975, rew={0,0,0,100}, preq=427274}, -- The Skeleton General // Skelettgeneral
[427314]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204822]= 10}, giver=123963, rew={0,0,0,100}, preq=427275}, -- Swamp Berries // Sumpfbeeren
[427315]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[543851]=  1}, giver=123967, taker=123968, rew={0,0,0,130}, preq=427276}, -- Escort Duty // Geleitschutz
[427316]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[542582]=  1,[542586]=  1,[543860]=  1}, giver=123974, rew={0,0,0,120}, preq=427277}, -- The Leader's Worries // Die Sorgen des Leiters
[427317]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[108707]=  6,[109179]=  6}, giver=123950, rew={737394,77509,10}, preq=427278}, -- Reinforcing the Front // Verstärkung für die Front
[427318]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[103777]=  3}, giver=123950, rew={737394,77509,10}, preq=427279}, -- Targeted Troll Attacks // Gezielte Trollangriffe
[427319]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[243089]=  8}, giver=123954, rew={737394,77509,10}, preq=427280}, -- A Masterpiece // Ein Meisterwerk
[427320]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109194]=  5}, giver=123960, rew={737394,77509,10}, preq=427281}, -- Replacing Talisman Fragments // Talismanfragmente ersetzen
[427321]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[108856]=  5}, giver=123958, rew={737394,77509,10}, preq=427282}, -- Encounter with the Dark // Begegnung mit der Dunkelheit
[427322]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[108850]=  1}, giver=123976, rew={737394,77509,10}, preq=427283}, -- Bad Smiths // Schlechte Schmiede
[427323]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[542581]=  1}, giver=123964, rew={737394,77509,10}, preq=427284}, -- Here Puss Puss // Kätzchen, komm heim
[427324]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[543808]=  1}, giver=123969, taker=123970, rew={737394,77509,10}, preq=427285}, -- Pettyaxe's Vice // Kleinaxts Trunksucht
[427325]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[108707]=  6,[109179]=  6}, giver=123950, rew={0,0,0,140}, preq=427278}, -- Reinforcing the Front // Verstärkung für die Front
[427326]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[103777]=  3}, giver=123950, rew={0,0,0,160}, preq=427279}, -- Targeted Troll Attacks // Gezielte Trollangriffe
[427327]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[243089]=  8}, giver=123954, rew={0,0,0,100}, preq=427280}, -- A Masterpiece // Ein Meisterwerk
[427328]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109194]=  5}, giver=123960, rew={0,0,0,80}, preq=427281}, -- Replacing Talisman Fragments // Talismanfragmente ersetzen
[427329]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[108856]=  5}, giver=123958, rew={0,0,0,100}, preq=427282}, -- Encounter with the Dark // Begegnung mit der Dunkelheit
[427330]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[108850]=  1}, giver=123976, rew={0,0,0,100}, preq=427283}, -- Bad Smiths // Schlechte Schmiede
[427331]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[542581]=  1}, giver=123964, rew={0,0,0,100}, preq=427284}, -- Here Puss Puss // Kätzchen, komm heim
[427332]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[543808]=  1}, giver=123969, taker=123970, rew={0,0,0,100}, preq=427285}, -- Pettyaxe's Vice // Kleinaxts Trunksucht
[427333]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109053]=  5,[109055]=  5}, giver=123951, rew={737394,77509,10}, preq=427286}, -- The Price of Bravery // Geld für Tapferkeit
[427334]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109051]=  6,[109052]=  6,[109054]=  6}, giver=123898, rew={737394,77509,10}, preq=427287}, -- Attack of the Demon Soldiers // Angriff der Dämonensoldaten
[427335]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[243247]= 10}, giver=123955, rew={737394,77509,10}, preq=427288}, -- Bitter Medicine is Better // Gute Medizin ist bitter
[427336]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[104101]=  5}, giver=123959, rew={737394,77509,10}, preq=427289}, -- The Cost of Magic // Zauberei kostet Kraft
[427337]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204919]= 10}, giver=123961, rew={737394,77509,10}, preq=427290}, -- Laros' Prey // Laros' Beute
[427338]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109063]=  1}, giver=123977, rew={737394,77509,10}, preq=427291}, -- Aiding and Abetting Demons // Der Helfer der Dämonensoldaten
[427339]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204921]=  1}, giver=123965, rew={737394,77509,10}, preq=427292}, -- All About Preparation // Die richtige Zubereitung
[427340]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[544061]=  1}, giver=123971, rew={737394,77509,10}, preq=427293}, -- Energetic Sequencing // Die Reihenfolge der Energie
[427342]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109053]=  5,[109055]=  5}, giver=123951, rew={0,0,0,120}, preq=427286}, -- The Price of Bravery // Geld für Tapferkeit
[427343]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[103778]=  3}, giver=123898, rew={0,0,0,180}, preq=427287}, -- Attack of the Demon Soldiers // Angriff der Dämonensoldaten
[427344]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[243247]= 10}, giver=123955, rew={0,0,0,100}, preq=427288}, -- Bitter Medicine is Better // Gute Medizin ist bitter
[427345]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[104101]=  5}, giver=123959, rew={0,0,0,50}, preq=427289}, -- The Cost of Magic // Zauberei kostet Kraft
[427346]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204919]= 10}, giver=123961, rew={0,0,0,80}, preq=427290}, -- Laros' Prey // Laros' Beute
[427347]={typ= 2, lvl=96, rlvl=94, zone= 33, mobs={[109063]=  1}, giver=123977, rew={0,0,0,100}, preq=427291}, -- Aiding and Abetting Demons // Der Helfer der Dämonensoldaten
[427348]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[204921]=  1}, giver=123965, rew={0,0,0,120}, preq=427292}, -- All About Preparation // Die richtige Zubereitung
[427349]={typ= 1, lvl=96, rlvl=94, zone= 33, items={[544061]=  1}, giver=123971, rew={0,0,0,120}, preq=427293}, -- Energetic Sequencing // Die Reihenfolge der Energie
--[[ ] ]]

--[[ [ Tasuq / Tasuq (34) ]]
[427421]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[104935]=  8}, giver=124160, rew={798178,100197,10}, preq=427391}, -- Eliminating Opaque Elements // Beseitigung undurchsichtiger Elemente
[427422]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[104932]=  6,[104933]=  4,[104934]=  6}, giver=124160, rew={798178,100197,10}, preq=427395}, -- Eliminating the Ghost Pirates // Beseitigung der Geisterpiraten
[427423]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208385]=  8}, giver=124189, rew={798178,100197,10}, preq=427398}, -- Fresh, Fried Fish // Frischer, gebratener Fisch
[427424]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[109287]=  6,[109288]=  4,[109290]=  8}, giver=124197, rew={798178,100197,10}, preq=427400}, -- Clearing a Path // Freie Bahn
[427425]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[105777]=  1}, giver=124198, rew={798178,100197,10}, preq=427401}, -- Command of the Dust Camp // Kommando des Staublagers
[427426]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208387]= 10}, giver=124199, rew={798178,100197,10}, preq=427402}, -- More Research Documents // Weitere Forschungsunterlagen
[427427]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208389]=  6}, giver=124200, rew={798178,100197,10}, preq=427403}, -- What's with the Animals in the Jungle? // Was ist mit den Tieren im Dschungel?
[427428]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208390]=  6}, giver=124204, rew={798178,100197,10}, preq=427404}, -- Strange Panther // Seltsamer Panther
[427429]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[105926]=  1}, giver=124198, rew={798178,100197,10}, preq=427405}, -- Command of the Veiled Encampment // Kommando des Schattenlagers
[427430]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[109297]=  3,[109298]=  3,[109299]=  3}, giver=124206, rew={798178,100197,10}, preq=427408}, -- Stopping the Inexorable League's Attacks // Das Stoppen der Offensive des Zirkels der Unverwüstlichen
[427431]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208391]= 10}, giver=124214, rew={798178,100197,10}, preq=427409}, -- Main Thing: Materials! // Hauptsache Material!
[427432]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208393]= 10}, giver=124216, rew={798178,100197,10}, preq=427411}, -- We Need Supplies! // Wir brauchen Nachschub!
[427433]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208395]= 10}, giver=124208, rew={798178,100197,10}, preq=427414}, -- Purple Dilapidated Crystal // Violetter Verfallener Kristall
[427434]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[105983]=  1}, giver=124209, rew={798178,100197,10}, preq=427415}, -- The Elite Demon Swordsman in the Valley of No Return // Der Elite-Dämonenschwertkämpfer im Tal ohne Wiederkehr
[427435]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208397]= 10}, giver=124211, rew={798178,100197,10}, preq=427417}, -- What Are They Up To...? // Was haben sie vor ...?
[427436]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[104935]=  8}, giver=124160, rew={0,0,0,100}, preq=427391}, -- Eliminating Opaque Elements // Beseitigung undurchsichtiger Elemente
[427437]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[104932]=  6,[104933]=  4,[104934]=  6}, giver=124160, rew={0,0,0,100}, preq=427395}, -- Eliminating the Ghost Pirates // Beseitigung der Geisterpiraten
[427438]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208385]=  8}, giver=124189, rew={0,0,0,100}, preq=427398}, -- Fresh, Fried Fish // Frischer, gebratener Fisch
[427439]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[109287]=  6,[109288]=  4,[109290]=  8}, giver=124197, rew={0,0,0,100}, preq=427400}, -- Clearing a Path // Freie Bahn
[427440]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[105777]=  1}, giver=124198, rew={0,0,0,100}, preq=427401}, -- Command of the Dust Camp // Kommando des Staublagers
[427441]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208387]= 10}, giver=124199, rew={0,0,0,100}, preq=427402}, -- More Research Documents // Weitere Forschungsunterlagen
[427442]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208389]=  6}, giver=124200, rew={0,0,0,100}, preq=427403}, -- What's with the Animals in the Jungle? // Was ist mit den Tieren im Dschungel?
[427443]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208390]=  6}, giver=124204, rew={0,0,0,100}, preq=427404}, -- Strange Panther // Seltsamer Panther
[427444]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[105926]=  1}, giver=124198, rew={0,0,0,100}, preq=427405}, -- Command of the Veiled Encampment // Kommando des Schattenlagers
[427445]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[109297]=  3,[109298]=  3,[109299]=  3}, giver=124206, rew={0,0,0,100}, preq=427408}, -- Stopping the Inexorable League's Attacks // Das Stoppen der Offensive des Zirkels der Unverwüstlichen
[427446]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208391]= 10}, giver=124214, rew={0,0,0,100}, preq=427409}, -- Main Thing: Materials! // Hauptsache Material!
[427447]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208393]= 10}, giver=124216, rew={0,0,0,100}, preq=427411}, -- We Need Supplies! // Wir brauchen Nachschub!
[427448]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208395]= 10}, giver=124208, rew={0,0,0,100}, preq=427414}, -- Purple Dilapidated Crystal // Violetter Verfallener Kristall
[427449]={typ= 2, lvl=98, rlvl=96, zone= 34, mobs={[105983]=  1}, giver=124209, rew={0,0,0,10}, preq=427415}, -- The Elite Demon Swordsman in the Valley of No Return // Der Elite-Dämonenschwertkämpfer im Tal ohne Wiederkehr
[427450]={typ= 1, lvl=98, rlvl=96, zone= 34, items={[208397]= 10}, giver=124211, rew={0,0,0,100}, preq=427417}, -- What Are They Up To...? // Was haben sie vor ...?
--[[ ] ]]

--[[ [ Korris / Korris (35) ]]
[427516]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[106285]=  8}, giver=124341, rew={830424,111942,10}, preq=427486}, -- Keeping the Secret // Das Geheimnis bewahren
[427517]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109321]=  3,[109322]=  6,[109327]=  3}, giver=124342, rew={830424,111942,10}, preq=427487}, -- Troubles with Wild Animals // Wilde Tiere sind schaurig
[427518]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243451]=  6}, giver=124343, rew={830424,111942,10}, preq=427488}, -- Stunning Stingers // Betäubungsstacheln
[427519]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243453]= 10}, giver=124345, rew={830424,111942,10}, preq=427490}, -- Thank God for Alchemy // Gut, dass ich Alchemie studiert habe
[427520]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243455]=  6}, giver=124352, rew={830424,111942,10}, preq=427497}, -- Succulent Boar Meat // Saftiges Keilerfleisch
[427521]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243456]=  6}, giver=124353, rew={830424,111942,10}, preq=427498}, -- Unusual Temperatures // Ungewöhnliche Temperaturen
[427522]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[549401]=  1,[549402]=  1}, giver=124354, rew={830424,111942,10}, preq=427499}, -- Upland and Lowland Fluctuations // Hoch- und Tieflandfluktuationen
[427523]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243458]=  6}, giver=124355, rew={830424,111942,10}, preq=427500}, -- Guessing the Plans // Pläne erraten
[427524]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243460]=  6}, giver=124357, rew={830424,111942,10}, preq=427502}, -- Proof of Deceit // Täuschungsbeweis
[427525]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243461]=  6}, giver=124359, rew={830424,111942,10}, preq=427504}, -- Hearts of the Eye of Frost // Herzen des Frostauges
[427526]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109367]=  4}, giver=124361, rew={830424,111942,10}, preq=427506}, -- Eliminate the Priests of the Eye of Frost // Eliminiert die Priester des Frostauges
[427527]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243464]=  6}, giver=124363, rew={830424,111942,10}, preq=427508}, -- The Little Uses for Big Equipment // Große Ausrüstungsteile sind auch nützlich
[427528]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243462]=  6}, giver=124364, rew={830424,111942,10}, preq=427509}, -- The Hearts of the Snow Fortress // Die Herzen der Eisigen Bastion
[427529]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243466]= 10}, giver=124367, rew={830424,111942,10}, preq=427512}, -- Cure for Corruption // Mittel gegen den Verfall
[427530]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243467]=  1}, giver=124368, rew={830424,111942,10}, preq=427513}, -- Strange Energy on the Ice Blade Plateau // Die Seltsame Energie auf dem Eisklingen-Plateau
[427531]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243452]= 10}, giver=124344, rew={0,0,0,100}, preq=427489}, -- Pungent Deodorizers // Stinkender Geruchsneutralisierer
[427532]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109328]=  4,[109329]=  6,[109330]=  2,[109331]=  6}, giver=124346, rew={0,0,0,100}, preq=427491}, -- Thinning the Inexorable League's Ranks // Verringert die Anzahl der Anhänger des Zirkels der Unverwüstlichen
[427533]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[243454]= 10}, giver=124347, rew={0,0,0,100}, preq=427492}, -- Analyzing the Spatial Magic Rituals // Analyse der Raummagie-Rituale
[427534]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109334]= 10}, giver=124348, rew={0,0,0,100}, preq=427493}, -- Scealoks of the Altar // Die Scealoks, die den Altar bewachen
[427535]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109341]=  8}, giver=124349, rew={0,0,0,100}, preq=427494}, -- Shadows of Terror // Die furchtbaren Schatten
[427536]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109348]=  6,[109349]=  6}, giver=124350, rew={0,0,0,100}, preq=427495}, -- Clearing the Way // Den Weg freiräumen
[427537]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109359]=  3,[109360]=  3,[109361]=  3}, giver=124351, rew={0,0,0,100}, preq=427496}, -- Defense of the Icefog Camp // Die Verteidigung des Lagers der Eisnebel
[427538]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[549380]=  1}, giver=124356, rew={0,0,0,100}, preq=427501}, -- Manipulating the Frost Camp Altar // Manipuliert den Altar im Frostlager
[427539]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109375]=  1}, giver=124358, rew={0,0,0,100}, preq=427503}, -- When the Cat's Away // Sturmfreie Bude
[427540]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109366]=  4}, giver=124360, rew={0,0,0,100}, preq=427505}, -- Kill the Eye of Frost Commanders // Tötet die Frostauge-Kampfkommandanten
[427541]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[549394]=  1}, giver=124362, rew={0,0,0,100}, preq=427507}, -- Manipulating the Eye of Frost Altar // Manipuliert den Altar im Frostauge
[427542]={typ= 2, lvl=99, rlvl=97, zone= 35, mobs={[109401]= 10}, giver=124365, rew={0,0,0,100}, preq=427510}, -- Destroying the Minotaur Totems // Zerstört die Minotaurentotems
[427543]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[549395]=  1}, giver=124366, rew={0,0,0,100}, preq=427511}, -- Manipulating the Snow Fortress Altar // Manipuliert den Altar in der Eisigen Bastion
[427544]={typ= 1, lvl=99, rlvl=97, zone= 35, items={[549396]=  1}, giver=124369, rew={0,0,0,100}, preq=427514}, -- Inhibiting the Dark Magic Emissions // Unterbindet die Ausströmung der dunklen Magie
--[[ ] ]]

--[[ [ Enoch / Enoch (36) ]]
[427611]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243489]= 10}, giver=124419, rew={863973,125528,10}, preq=427582}, -- Burning Torches in the Darkness // Brennende Fackeln in der Dunkelheit
[427612]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243490]=  8}, giver=124420, rew={863973,125528,10}, preq=427583}, -- The true scientific proof // Der wahre wissenschaftliche Beweis
[427613]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109432]=  6}, giver=124421, rew={863973,125528,10}, preq=427584}, -- The Ancient Bloodthirsty Beast of Enoch // Die blutrünstige Bestie von Enoch
[427614]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243491]=  8}, giver=124422, rew={863973,125528,10}, preq=427585}, -- Blessing Blossom // Segensblüte
[427615]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243492]=  8}, giver=124424, rew={863973,125528,10}, preq=427587}, -- No Divine Will // Kein göttlicher Wille
[427616]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109440]=  8}, giver=124426, rew={863973,125528,10}, preq=427589}, -- The Release of Eternal Sleep // Der befreiende Schlaf
[427617]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109444]=  8}, giver=124427, rew={863973,125528,10}, preq=427590}, -- I want to finally get to sleep! // Ich möchte endlich schlafen!
[427618]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243494]= 10}, giver=124428, rew={863973,125528,10}, preq=427591}, -- Dark Magic Twilight Mud // Dunkler magischer Dämmerschlamm
[427619]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243498]= 10}, giver=124509, rew={863973,125528,10}, preq=427597}, -- Mountains of Scattered Supplies // Bergen der verstreuten Materialien
[427620]={typ= 4, lvl=100, rlvl=98, zone= 36, items={[243499]=  1}, giver=124509, rew={863973,125528,10}, preq=427600}, -- The Personal Amulet of an Old Comrade // Das persönliche Amulett eines alten Kameraden
[427621]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243500]=  8}, giver=124435, rew={863973,125528,10}, preq=427601}, -- Little Friend // Kleiner Freund
[427622]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243501]= 10}, giver=124436, rew={863973,125528,10}, preq=427602}, -- Lake Water to Heal Wounds // Seewasser für die Wundheilung
[427623]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243502]=  8}, giver=124437, rew={863973,125528,10}, preq=427603}, -- Tree Beetle Shells with Sharp Thorns // Baumkäferpanzer mit spitzen Dornen
[427624]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243504]=  6}, giver=124438, rew={863973,125528,10}, preq=427604}, -- Adorable Mutants // Liebenswerte Mutanten
[427625]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243505]= 10}, giver=124510, rew={863973,125528,10}, preq=427605}, -- Spell Amulet // Zauberamulette
[427626]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109422]=  8}, giver=124418, rew={0,0,0,100}, preq=427581}, -- Leonin lying in wait // Leonin im Hinterhalt
[427627]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109441]=  8}, giver=124423, rew={0,0,0,100}, preq=427586}, -- Seal the Information Leak // Das Informationsleck schließen
[427628]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109379]=  8}, giver=124425, rew={0,0,0,100}, preq=427588}, -- New Unknown Devices All the Time // Immer wieder neue unbekannte Vorrichtungen
[427629]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109449]=  8}, giver=124429, rew={0,0,0,100}, preq=427592}, -- Hunt for Decayed Entlings // Jagd auf verfallene Entlinge
[427630]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109380]=  8}, giver=124430, rew={0,0,0,10}, preq=427593}, -- Shield the Camp from the Enemy // Das Lager vor dem Feind abschirmen
[427631]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109454]=  5}, giver=124431, rew={0,0,0,100}, preq=427594}, -- Weaken the Blackstar Sanctuary's Defenses // Schwächung der Abwehr des Heiligtums des Dunkelsterns
[427632]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243497]=  8}, giver=124432, rew={0,0,0,100}, preq=427596}, -- Kill the Robbers! // Tötet diese Räuberinnen!
[427633]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109435]=  3,[109436]=  3,[109437]=  3}, giver=124433, rew={0,0,0,100}, preq=427598}, -- Annihilating the Enemies of the Outpost. // Vernichtung der Feinde des Postens
[427634]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109460]=  5}, giver=124434, rew={0,0,0,100}, preq=427599}, -- Too many Moonfang Hunters // Zu viele Mondzahnjägerinnen
[427635]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109609]=  8}, giver=124439, rew={0,0,0,100}, preq=427606}, -- Destroy Supplies // Vorratsmaterialien vernichten
[427636]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243506]=  8}, giver=124440, rew={0,0,0,100}, preq=427607}, -- Gather Documents // Dokumente einsammeln
[427637]={typ= 2, lvl=100, rlvl=98, zone= 36, mobs={[109611]=  8}, giver=124441, rew={0,0,0,100}, preq=427608}, -- With all your Power! // Mit ganzer Kraft!
[427638]={typ= 1, lvl=100, rlvl=98, zone= 36, items={[243508]=  5}, giver=124442, rew={0,0,0,100}, preq=427609}, -- Dangerous Giant Insects // Gefährliche Rieseninsekten
--[[ ] ]]

--[[ [ Vortis / Vortis (37) ]]
[427706]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243514]= 10}, giver=124533, rew={863973,125528,10}, mobs={[124567]=  0}, preq=427676}, -- No More Heat Shock // Keine Hitzeschocks mehr
[427707]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243516]=  6}, giver=124536, rew={863973,125528,10}, mobs={[109625]=  0}, preq=427679}, -- An Antidote // Ein Gegengift
[427708]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243517]=  6}, giver=124537, rew={863973,125528,10}, mobs={[109619]=  0}, preq=427680}, -- Cactus Tubers // Kaktusknollen
[427709]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[549524]=  1,[549525]=  1}, giver=124540, rew={863973,125528,10}, mobs={[549524]=  1}, preq=427683}, -- The Researcher's Fondness // Die Vorlieben des Forschers
[427710]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243521]=  5}, giver=124541, rew={863973,125528,10}, mobs={[124569]=  0}, preq=427684}, -- A Taste of the Sea // Der Geschmack nach Meer
[427711]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109636]=  8}, giver=124542, rew={863973,125528,10}, preq=427685}, -- Imitation Rocks // Felsimitationen
[427712]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243522]= 30}, giver=124544, rew={863973,125528,10}, mobs={[124577]=  0}, preq=427687}, -- A Poisonous Water Resource // Eine giftige Wasserressource
[427713]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109639]=  8}, giver=124545, rew={863973,125528,10}, preq=427688}, -- Scarecrow // Vogelscheuche
[427714]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243524]= 10,[243525]=  1}, giver=124548, taker=124549, rew={863973,125528,10}, mobs={[124572]=  0}, preq=427691}, -- An Unforgettable Aroma // Ein unvergessliches Aroma
[427715]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243526]=  6}, giver=124551, rew={863973,125528,10}, mobs={[124570]=  0}, preq=427693}, -- The Canines' Staple Food // Das Hauptnahrungsmittel der Canin
[427716]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243527]=  6}, giver=124553, rew={863973,125528,10}, mobs={[109650]=  0}, preq=427695}, -- Resources for Exploration Excursions // Hilfsmittel für Erkundungsausflüge
[427717]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109656]=  8}, giver=124555, rew={863973,125528,10}, preq=427697}, -- Peace and Quiet // Ohrenruhe
[427718]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243529]=  6}, giver=124559, rew={863973,125528,10}, mobs={[109674]=  0}, preq=427701}, -- Lovable Mechanical Creatures // Liebenswerte mechanische Kreaturen
[427719]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243531]=  1}, giver=124561, rew={863973,125528,10}, mobs={[243530]=  0}, preq=427703}, -- Soul Energy Investigation // Untersuchung der Seelenenergie
[427721]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109621]=  4,[109622]=  4}, giver=124534, rew={0,0,0,100}, preq=427677}, -- Kicking Up Some Dust // Etwas Staub aufwirbeln
[427722]={typ= 2, lvl=100, rlvl=99, zone= 37, items={[243515]=  6}, giver=124535, rew={0,0,0,100}, preq=427678}, -- Where Did All this Dust Come From? // Woher all dieser Staub?
[427723]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109629]=  3,[109630]=  3,[109631]=  2}, giver=124538, rew={0,0,0,100}, preq=427681}, -- Clearing out the Bandits // Banditensäuberung
[427724]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109667]=  1}, giver=124543, rew={0,0,0,100}, preq=427686}, -- A Tough Cookie // Ein harter Brocken
[427725]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109638]=  6,[109651]=  3}, giver=124546, rew={0,0,0,100}, preq=427689}, -- Onslaught of the Gluttons // Ansturm der Vielfraße
[427726]={typ= 2, lvl=100, rlvl=99, zone= 37, items={[243523]=  6}, giver=124547, rew={0,0,0,100}, preq=427690}, -- Pincer Shields // Scherenschilde
[427727]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109642]=  8}, giver=124550, rew={0,0,0,100}, preq=427692}, -- Hunting Lurkers // Jagd auf Schleicher
[427728]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109649]=  8}, giver=124552, rew={0,0,0,100}, preq=427694}, -- The Earth Dragon's Minions // Die Lakaien des Erddrachen
[427729]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243528]=  6}, giver=124554, rew={0,0,0,100}, mobs={[109654]=  0}, preq=427696}, -- Stealing the Order Documents // Der Raub der Befehlsdokumente
[427730]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109658]=  8}, giver=124556, rew={0,0,0,100}, preq=427698}, -- Ancient Destruction // Antike Zerstörung
[427731]={typ= 1, lvl=100, rlvl=99, zone= 37, mobs={[109677]=  0}, giver=124557, rew={0,0,0,100}, preq=427699}, -- Clear Barricades out of the Way // Barrikaden aus dem Weg räumen
[427732]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109665]=  8}, giver=124558, rew={0,0,0,100}, preq=427700}, -- Peace of the Grave // Grabesruhe
[427733]={typ= 2, lvl=100, rlvl=99, zone= 37, mobs={[109666]=  2}, giver=124560, rew={0,0,0,100}, preq=427702}, -- Unwieldy Stones // Sperrige Steine
[427734]={typ= 1, lvl=100, rlvl=99, zone= 37, items={[243815]=  4}, giver=124562, rew={0,0,0,100}, mobs={[100008]=  0}, preq=427704}, -- Damned Beetles! // Verfluchte Käfer!
--[[ ] ]]

--[[ [ Chassizz / Chassizz (38) ]]
[427801]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243539]= 10}, giver=124612, rew={863973,125528,10}, mobs={[109700]=  0}, preq=427772}, -- Bloodthirsty Tarbloods // Blutrünstige Schwarzblutbestien
[427802]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243540]= 10}, giver=124613, rew={863973,125528,10}, mobs={[109695]=  0}, preq=427773}, -- Skulls of the Dead // Die Schädel der Toten
[427803]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243542]=  1}, giver=124614, rew={863973,125528,10}, mobs={[124649]=  1}, preq=427774}, -- The Rivensword // Die geborstene Klinge
[427804]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243543]=  1}, giver=124615, rew={863973,125528,10}, mobs={[109707]=  1}, preq=427775}, -- Lost Orders // Wo ist bloß die Bestellliste hin?
[427805]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243544]= 10}, giver=124616, rew={863973,125528,10}, mobs={[109701]=  0}, preq=427776}, -- Seeds of Death // Samen des Todes
[427806]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243545]= 10}, giver=124617, rew={863973,125528,10}, mobs={[243545]=  0}, preq=427777}, -- Quality Materials // Hochwertige Materialien
[427807]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243548]= 10}, giver=124620, rew={863973,125528,10}, mobs={[124651]=  0}, preq=427780}, -- Fragments of Energy // Fragmente einer unbekannten Energie
[427808]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243549]= 10}, giver=124621, rew={863973,125528,10}, mobs={[109723]=  0}, preq=427781}, -- Unbearable Heat // Unerträgliche Hitze
[427809]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243551]= 10}, giver=124622, rew={863973,125528,10}, mobs={[124652]=  0}, preq=427782}, -- Magma Energy // Magmaenergie
[427810]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243552]=  8}, giver=124623, rew={863973,125528,10}, mobs={[109717]=  0}, preq=427783}, -- Respect of the Flame Devil // Respekt der Flammenteufel
[427811]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243553]= 10}, giver=124624, rew={863973,125528,10}, mobs={[109722]=  0}, preq=427784}, -- Diabolical Mutations // Teuflische Mutation
[427812]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243554]= 10}, giver=124625, rew={863973,125528,10}, mobs={[109726]=  0}, preq=427785}, -- Plundering the Naga Supplies // Plünderung der Naga-Vorräte
[427813]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243557]= 10}, giver=124631, rew={863973,125528,10}, mobs={[109742]=  0}, preq=427791}, -- Delicious Red Meat // Köstliches rotes Fleisch
[427814]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243559]=  1}, giver=124634, rew={863973,125528,10}, mobs={[124658]=  1}, preq=427794}, -- Another Great Barrier? // Noch eine Bannmauer?
[427815]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243563]=  1}, giver=124638, rew={863973,125528,10}, mobs={[124654]=  1}, preq=427798}, -- A Warning for Posterity // Warnung für die Nachwelt
[427816]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243538]= 10}, giver=124611, rew={0,0,0,100}, mobs={[109694]=  0}, preq=427771}, -- Fire Claws // Feuerklauen
[427817]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243546]= 10}, giver=124618, rew={0,0,0,100}, mobs={[109709]=  0}, preq=427778}, -- Rise of the Runic Guards // Wiedererweckte Runenwachen
[427818]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243547]=  1}, giver=124619, rew={0,0,0,100}, mobs={[109714]=  1}, preq=427779}, -- Titan Unbound // Der wilde Titan
[427819]={typ= 2, lvl=100, rlvl=100, zone= 38, mobs={[109727]=  8}, giver=124626, rew={0,0,0,100}, preq=427786}, -- Destroying the Prototypes // Zerstört die Prototypen
[427820]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243555]= 10}, giver=124627, rew={0,0,0,100}, mobs={[109728]= 10}, preq=427787}, -- The Goals of the Inexorable League // Die Ziele des Zirkels der Unverwüstlichen
[427821]={typ= 2, lvl=100, rlvl=100, zone= 38, mobs={[109732]=  5,[109733]=  3,[109734]=  2}, giver=124628, rew={0,0,0,100}, preq=427788}, -- Chaos in the Nest // Chaos im Schlangennest
[427822]={typ= 1, lvl=100, rlvl=100, zone= 38, mobs={[109760]= 10}, giver=124629, rew={0,0,0,100}, preq=427789}, -- All Powder No Puff // Keinen Schuss Pulver wert
[427823]={typ= 2, lvl=100, rlvl=100, zone= 38, mobs={[109730]=  1,[109731]=  1}, giver=124630, rew={0,0,0,100}, preq=427790}, -- Cropping the Snakes // Die Köpfe der Schlange
[427824]={typ= 2, lvl=100, rlvl=100, zone= 38, mobs={[109736]=  4,[109737]=  4}, giver=124632, rew={0,0,0,100}, preq=427792}, -- Minions of the Traitor // Die Lakaien des Verräters
[427825]={typ= 1, lvl=100, rlvl=100, zone= 38, giver=124633, rew={0,0,0,100}, preq=427793}, -- Of Rocks and Hard Places // Wütende Steine
[427826]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243560]= 10}, giver=124635, rew={0,0,0,100}, mobs={[109746]=  1,[109749]=  1}, preq=427795}, -- More Blueprints // Noch mehr Blaupausen
[427827]={typ= 1, lvl=100, rlvl=100, zone= 38, items={[243561]= 10}, giver=124636, rew={0,0,0,100}, mobs={[109747]= 10}, preq=427796}, -- Interrupt the Incantation // Stoppt die Beschwörung
[427828]={typ= 1, lvl=100, rlvl=100, zone= 38, mobs={[109761]= 10}, giver=124637, rew={0,0,0,100}, preq=427797}, -- Destroy the Combat Equipment // Zerstört die Kampfausrüstung
[427829]={typ= 2, lvl=100, rlvl=100, zone= 38, mobs={[109792]=  3,[109793]=  3,[109794]=  3,[109798]=  2}, giver=124639, rew={0,0,0,100}, preq=427799}, -- Overcoming the New Pantheon's Defenses // Die Verteidigung des Neuen Pantheons durchbrechen
--[[ ] ]]

--[[ [ Ystra Labyrinth - Revivers' Corridor / Ystra-Labyrinth - Auferstehungskorridor (205) ]]
[422396]={typ= 1, lvl=32, rlvl=30, zone=205, items={[205003]= 10}, giver=113068, rew={7166,1601,10}, mobs={[101396]=  0,[102152]=  0}}, -- Treasure Hunter's Treasure // Der Schatz des Schatzsuchers
[422410]={typ= 1, lvl=32, rlvl=30, zone=205, items={[204895]= 10}, giver=113077, rew={7166,1601,10}, mobs={[101396]=  0,[102152]=  0}, preq=422406}, -- More Heads // Mehr Köpfe
[422400]={typ= 1, lvl=35, rlvl=33, zone=205, items={[205002]= 10}, giver=113070, rew={12139,1698,10}, mobs={[102145]=  0,[102146]=  0,[102147]=  0,[102148]=  0}}, -- Supplementary Research Material // Zusätzliches Forschungsmaterial
[422395]={typ= 1, lvl=38, rlvl=36, zone=205, items={[205004]= 10}, giver=113064, rew={18466,1796,10}, mobs={[102149]=  0,[102150]=  0,[102153]=  0,[102154]=  0,[102155]=  0}}, -- Death Count // Die Anzahl der Toten
[422392]={typ=11, lvl=39, rlvl=37, zone=205, items={[204981]=  5}, giver=113062, rew={28689,3657,10}}, -- Guard Control // Wachenkontrolle
[422394]={typ= 1, lvl=39, rlvl=37, zone=205, items={[204980]= 100}, giver=113063, rew={21516,1828,10}, preq=422393}, -- Tiny Control Equipment // Winziges Kontrollwerkzeug
[422397]={typ=12, lvl=39, rlvl=37, zone=205, items={[205001]=  1}, giver=113069, rew={28689,2742,20}, mobs={[102144]=  1}}, -- Secret Aid // Geheimer Gehilfe
--[[ ] ]]

--[[ [ Ystra Labyrinth - Guards' Corridor / Ystra-Labyrinth - Korridor der Wächter (206) ]]
[422390]={typ= 1, lvl=42, rlvl=40, zone=206, items={[205010]= 10}, giver=113084, rew={28695,1926,10}}, -- Ice Delivery! // Eislieferung!
[422387]={typ= 1, lvl=43, rlvl=41, zone=206, items={[205013]= 10}, giver=113082, rew={30579,1958,10}}, -- Complementary Property: Light // Ergänzende Eigenschaft: Licht
[422388]={typ= 1, lvl=43, rlvl=41, zone=206, items={[205014]= 10}, giver=113082, rew={30579,1958,10}}, -- Complementary Property: Darkness // Ergänzende Eigenschaft: Finsternis
[422389]={typ= 1, lvl=44, rlvl=42, zone=206, items={[205011]= 10}, giver=113083, rew={33936,1991,10}}, -- Start A Fire // Entzündet ein Feuer
[422398]={typ= 1, lvl=45, rlvl=43, zone=206, items={[205016]=  3}, giver=113082, rew={38815,1996,10}}, -- Should be Liquid // Sollte flüssig sein
[422399]={typ= 1, lvl=45, rlvl=43, zone=206, items={[205015]=  3}, giver=113083, rew={38815,1996,10}}, -- Special Venom Sample // Besondere Giftprobe
[422409]={typ= 1, lvl=45, rlvl=43, zone=206, items={[205012]= 10}, giver=113085, rew={38815,1996,10}}, -- Complex Puzzle // Kompliziertes Puzzle
--[[ ] ]]

--[[ [ Ystra Labyrinth - Royals' Refuge / Ystra-Labyrinth - Königliche Zuflucht (207) ]]
[422359]={typ= 3, lvl=47, rlvl=45, zone=207, items={[204894]=  6}, giver=113046, rew={0,0,0}}, -- 6 Pieces of Solid Energy // 6 Stück feste Energie
[422360]={typ= 3, lvl=47, rlvl=45, zone=207, items={[204894]= 60}, giver=113046, rew={0,0,0}, preq=422359}, -- More Pieces of Solid Energy // Noch mehr Stücke feste Energie
--[[ ] ]]

--[[ [  /  (358) ]]
[420632]={typ= 1, lvl=31, rlvl=29, zone=358, items={[201463]= 10}, giver=110729, taker=110281, rew={6317,1568,10}, mobs={[100139]=  0}}, -- Strong Medicine // Starke Medizin
[420436]={typ= 4, lvl=33, rlvl=31, zone=358, items={[200881]=  1}, giver=110729, taker=110273, rew={8048,1633,10}}, -- Supplying the Sea of Snow // Lieferung für das Schneemeer
[421187]={typ= 3, lvl=33, rlvl=31, zone=358, items={[202364]= 20}, giver=111230, rew={0,0,0}, preq=421186}, -- Even More Mysterious Essence // Noch mehr geheimnisvolle Essenz
[420437]={typ= 4, lvl=34, rlvl=32, zone=358, items={[200686]= 10}, giver=110729, taker=110241, rew={10174,1666,10}}, -- Supplying Winternight Valley // Lieferung in das Winternacht-Tal
[420631]={typ= 1, lvl=34, rlvl=32, zone=358, items={[201462]= 10}, giver=110729, taker=110706, rew={10174,1666,10}, mobs={[100354]=  0}}, -- Abundant Ingredients // Reichlich Zutaten
[420438]={typ= 1, lvl=35, rlvl=33, zone=358, items={[200617]= 15}, giver=110729, taker=110281, rew={12139,1698,10}, mobs={[100592]=  0}}, -- Fur Trade // Pelzhandel
[420439]={typ= 1, lvl=35, rlvl=33, zone=358, items={[200579]= 10}, giver=110729, taker=110287, rew={12139,1698,10}, mobs={[100271]=  0,[100356]=  0,[100357]=  0,[101024]=  0}}, -- Minotaur Trinkets // Minotauren-Schmuckstücke
[420442]={typ= 1, lvl=35, rlvl=32, zone=358, items={[201124]= 15}, giver=110729, taker=110257, rew={12139,1698,10}, mobs={[100269]=  0}}, -- The Cyclops Menace // Die Zyklopenbedrohung
[420440]={typ= 2, lvl=36, rlvl=34, zone=358, mobs={[100124]= 15}, giver=110729, taker=110472, rew={14178,1731,10}}, -- Annoying Snow Ferrets // Lästige Schneefrettchen
[420441]={typ= 1, lvl=37, rlvl=35, zone=358, items={[200016]= 10}, giver=110729, taker=110474, rew={16029,1763,10}, mobs={[100368]=  0}}, -- Winter Spider Specimen // Winterspinnenarten
[421458]={typ=12, lvl=45, rlvl=40, zone=358, items={[203039]=  1}, giver=111443, rew={77631,7986,0}, mobs={[101022]=  1}}, -- Battle for Mystery // Kampf um Mysterium
--[[ ] ]]

--[[ [ Guild Castle / Gildenburg (401) ]]
[421524]={typ=12, lvl=10, rlvl=10, zone=401, mobs={[100926]=  5,[100927]=  5}, giver=113038, rew={780,1208,0}}, -- The City Guards' Request // Der Antrag der Stadtwache
[421629]={typ=14, lvl=10, rlvl=10, zone=401, items={[203396]= 15}, giver=113037, rew={292,604,0}, mobs={[100399]=  0}}, -- Construction Manpower // Bauarbeiter
[421639]={typ=12, lvl=10, rlvl=10, zone=401, mobs={[100926]=  8,[100927]=  8}, giver=113039, rew={858,1328,0}}, -- The Garrison's Request // Der Antrag der Garnison
[421525]={typ=14, lvl=20, rlvl=20, zone=401, items={[203398]=  2}, giver=113038, rew={2003,2341,0}}, -- Construction Materials // Baumaterial
[421630]={typ=14, lvl=20, rlvl=20, zone=401, items={[203398]=  1}, giver=113037, rew={1502,1951,0}}, -- Construction Materials // Baumaterial
[421644]={typ=14, lvl=20, rlvl=20, zone=401, items={[203398]=  3}, giver=113039, rew={3004,2731,0}}, -- Construction Materials // Baumaterial
[421526]={typ=14, lvl=25, rlvl=25, zone=401, items={[203399]=  5,[203400]= 25}, giver=113038, rew={4626,2979,0}, mobs={[100139]=  0,[100272]=  0}}, -- The Guild Needs Herbs // Die Gilde braucht Kräuter
[421631]={typ=14, lvl=25, rlvl=25, zone=401, items={[203399]=  5,[203400]= 15}, giver=113037, rew={3469,2483,0}, mobs={[100139]=  0,[100272]=  0}}, -- The Guild Needs Herbs // Die Gilde braucht Kräuter
[421645]={typ=14, lvl=25, rlvl=25, zone=401, items={[203399]= 10,[203400]= 30}, giver=113039, rew={6939,3476,0}, mobs={[100139]=  0,[100272]=  0}}, -- The Guild Needs Herbs // Die Gilde braucht Kräuter
[421527]={typ=14, lvl=30, rlvl=30, zone=401, items={[203401]= 25}, giver=113038, rew={7922,3686,0}, mobs={[100231]=  0,[100232]=  0,[100641]=  0}}, -- Materials Needed for Construction // Materialien zum Bauen
[421632]={typ=14, lvl=30, rlvl=30, zone=401, items={[203401]= 20}, giver=113037, rew={5941,3072,0}, mobs={[100231]=  0,[100232]=  0,[100641]=  0}}, -- Materials Needed for Construction // Materialien zum Bauen
[421646]={typ=14, lvl=30, rlvl=30, zone=401, items={[203401]= 30}, giver=113039, rew={11883,4300,0}, mobs={[100231]=  0,[100232]=  0,[100641]=  0}}, -- Materials Needed for Construction // Materialien zum Bauen
[421528]={typ=14, lvl=40, rlvl=40, zone=401, items={[203402]= 25}, giver=113038, rew={33331,4466,0}, mobs={[100419]=  0,[100421]=  0,[100616]=  0,[100617]=  0}}, -- The Guild Needs Weapons // Die Gilde braucht Waffen
[421633]={typ=14, lvl=40, rlvl=40, zone=401, items={[203402]= 20}, giver=113037, rew={24998,3722,0}, mobs={[100419]=  0,[100421]=  0,[100616]=  0,[100617]=  0}}, -- The Guild Needs Weapons // Die Gilde braucht Waffen
[421647]={typ=14, lvl=40, rlvl=40, zone=401, items={[203402]= 30}, giver=113039, rew={49996,5210,0}, mobs={[100419]=  0,[100421]=  0,[100616]=  0,[100617]=  0}}, -- The Guild Needs Weapons // Die Gilde braucht Waffen
[421529]={typ=12, lvl=45, rlvl=45, zone=401, mobs={[100794]=  1}, giver=113038, rew={113858,9982,0}}, -- Wanted: Blackhorn Hafiz // Gesucht: Schwarzhorn-Hafiz
[421634]={typ=12, lvl=45, rlvl=45, zone=401, mobs={[100611]=  1}, giver=113037, rew={77631,7986,0}}, -- Reward: Dorlos // Belohnung: Dorlos
[421648]={typ=12, lvl=45, rlvl=45, zone=401, mobs={[101352]=  1}, giver=113039, rew={150086,11979,0}}, -- Reward: Uguda // Belohnung: Uguda
--[[ ] ]]

--[[ [ Varanas / Varanas (10000) ]]
[422958]={typ=15, lvl=23, rlvl=21, zone=10000, giver=114087, taker=113689, rew={880,549,0}}, -- Proceed to the Scar of Despair Camp // Begebt Euch ins Lager bei der Narbe der Verzweiflung.
--[[ ] ]]

}
