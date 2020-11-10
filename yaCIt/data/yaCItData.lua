-- Lista kart o specjalnych właściwościach:
-- karta jest nagrodą za zadanie (1)
-- mob pojawia się tylko podczas rozwiązywania zadania(2)
-- karty drako (3)
-- karta nie jest możliwa do zdobycia(4)
-- karty dostępne w eventach (5)
-- karty z rzadkich potworów które trzeba wyrespić (7)
-- karty potworów występujących tylko podczas wydarzeń specjalnych (8)
-- karty bez znanej strefy są przypisane do 'nieznana strefa'

yaCIt.SpecialProps = {
["bbfdc"] = 1,	-- Czerwonooki Nocny Niedźwiedź
["bbff8"] = 1,	-- Zabójca z Zurhidonu
["bbffb"] = 1,	-- Morrison
["bc003"] = 1,	-- Demon z Krainy Snów
["bc012"] = 1,	-- Pancerny Kasumille
["bc013"] = 1,	-- Wściekły Goblin
["bc01e"] = 1,	-- Bestia Morcus
["bc027"] = 1,	-- Związany Badacz
["bc039"] = 1,	-- Carfcamoi
["bc03b"] = 2,	-- Cień Króla Berhu
["bc046"] = 2,	-- Quirlag, Syn Smoka Ziemi
["bc0b1"] = 2,	-- Sauropus
["bc0b3"] = 2,	-- Mściwy Duch
["bc158"] = 2,	-- Tajemniczy Olbrzymi Wilk
["bc29d"] = 2,	-- Wściekły Brudny Bies
["bc2a0"] = 2,	-- Zakazany Wartownik
["bc2b0"] = 2,	-- Generał Czarnych Węży Mafrur
["bc3ce"] = 2,	-- Groźny Tygrys Szablozębny
["bc3cf"] = 5,	-- Niespokojna Roślina (mob dostępny podczas misji, niemożliwy do ubicia)
["bc3d0"] = 2,	-- Gigantyczny Stary Pyton Bazyliszkowy
["bc3d1"] = 2,	-- Zmutowana Żmija z Mestro
["bc4b3"] = 2,	-- Widmo Zasadzki
["bc4f1"] = 2,	-- Nurkujący Kladoren
["bc5a6"] = 2,	-- Straż Stalowego Topora
["bc5a7"] = 2,	-- Straż Stalowego Ostrza
["bc5a8"] = 2,	-- Straż Stalowego Różdżki
["bc5ad"] = 2,	-- Dzika Koralowa Jaszczurka
["bc5b0"] = 5,	-- Szalona Papowaka (mob dostępny podczas misji, niemożliwy do ubicia)
["bc5ce"] = 2,	-- Królowa Krwawych Pszczół
["bc5d0"] = 2,	-- Duch Głodu
["bc6c7"] = 5,	-- Agregat Chorego Morza (mob nie został wprowadzony do gry)
["bc0b2"] = 7,	-- Ambas
["bc099"] = 7,	-- Ayelo
["bc01d"] = 7,	-- Beruda Lize
["bbfd2"] = 7,	-- Grzyb Kapitan
["bbfd1"] = 7,	-- Grzyb Strażnik
["bbfd3"] = 7,	-- Hillarzu Pierwszy
["bc0af"] = 7,	-- Mędrzec Akeli
["bc1d8"] = 7,	-- Przyrzeżny Wartownik
["bc0a3"] = 7,	-- Runiczny Duch Śnieżny
["bc037"] = 7,	-- Starszy Renifer
["bc1e2"] = 8,	-- Axis, Dowódca Wilków Bojowych
["bc2fb"] = 8,	-- Bambam Lom
["bc2f9"] = 8,	-- Mgielny Wojownik Rh'anka
["bc2fa"] = 8,	-- Mglisty Szaman Rh'anka
["bc236"] = 8,	-- Moriargy
["bc367"] = 8,	-- Szkodnik z Farmy
["bc3eb"] = 8,	-- Zaklęty Zombi
-- Karty Drako --
["bc6fa"] = 3,	-- Młody Drako Kreios
["bc6fb"] = 3,	-- Dorosły Drako Kreios
["bc6fc"] = 3,	-- Legendarny Drako Kreios
["bc6fd"] = 3,	-- Młoda Drako Tethys
["bc6fe"] = 3,	-- Dorosła Drako Tethys
["bc6ff"] = 3,	-- Legendarna Drako Tethys
["bc700"] = 3,	-- Młody Drako Okeanos
["bc701"] = 3,	-- Dorosły Drako Okeanos
["bc702"] = 3,	-- Legendarny Drako Okeanos
["bc703"] = 3,	-- Młody Drako Koios
["bc704"] = 3,	-- Dorosły Drako Koios
["bc705"] = 3,	-- Legendarny Drako Koios
["bc706"] = 3,	-- Młody Drako Kronos
["bc707"] = 3,	-- Dorosły Drako Kronos
["bc708"] = 3,	-- Legendarny Drako Kronos
["bc709"] = 3,	-- Młoda Drako Rhea
["bc70a"] = 3,	-- Dorosła Drako Rhea
["bc70b"] = 3,	-- Legendarna Drako Rhea
["bc70c"] = 3,	-- Młoda Drako Mnemosyne
["bc70d"] = 3,	-- Dorosła Drako Mnemosyne
["bc70e"] = 3,	-- Legendarna Drako Mnemosyne
["bc70f"] = 3,	-- Młody Drako Hyperion
["bc710"] = 3,	-- Dorosły Drako Hyperion
["bc711"] = 3,	-- Legendarny Drako Hyperion
["bc712"] = 3,	-- Młody Drako Iapetos
["bc713"] = 3,	-- Dorosły Drako Iapetos
["bc714"] = 3,	-- Legendarny Drako Iapetos
["bc715"] = 3,	-- Młoda Drako Theia
["bc716"] = 3,	-- Dorosła Drako Theia
["bc717"] = 3,	-- Legendarna Drako Theia
["bc718"] = 3,	-- Młoda Drako Themis
["bc719"] = 3,	-- Dorosła Drako Themis
["bc71a"] = 3,	-- Legendarna Drako Themis
["bc71b"] = 3,	-- Młoda Drako Phoibe
["bc71c"] = 3,	-- Dorosła Drako Phoibe
["bc71d"] = 3,	-- Legendarna Drako Phoibe
};

--  Poniższa lista dodaje karty ze stref które nie mogą być znalezione w wyszukiwarce światowej (+).
--  Zapobiega to również powtarzaniu stref, wprowadza poprawkę gdy istnieje mob bez karty (-1).
yaCIt.MobZones = {
["bbfd0"] = { [301]=100992, [301]=100993, [1]=1 },	-- Grzyb
["bbfd1"] = { [1]=100375, [8]=-1 },	-- Grzyb Strażnik
["bbfd2"] = { [1]=100376 },	-- Grzyb Kapitan
["bbfd3"] = { [1]=100377 },	-- Hillarzu Pierwszy
["bbfdb"] = { [5]=-1 },	-- Wilk
["bbfdc"] = { [1]=100560 },	-- Czerwonooki Nocny Niedźwiedź
["bbfe2"] = { [1]=100203, [33]=-1 },	-- Kobold Zwiadowca
["bbfe7"] = { [1]=100107, [2]=-1 },	-- Goblin Górnik
["bbfe8"] = { [1]=100150, [352]=-1 },	-- Goblin Tropiciel
["bbfeb"] = { [2]=100211 }, -- Hiena Trawiasta
["bbfee"] = { [2]=100294 }, -- Kobold Rabuś
["bbfef"] = { [2]=100398, [4]=100568, [4]=100569 },	-- Ważka Ostroskrzydła
["bbff3"] = { [2]=100213 },	-- Pająk Kolczasty
["bbff4"] = { [2]=100378 },	-- Szczurouchy Nietoperz
["bbff5"] = { [2]=100379, [102]=1, [201]=1 },	-- Pająk Ścierwojad
["bbff6"] = { [2]=100391, [102]=1, [201]=1 },	-- Obsesyjny Cień
["bbff7"] = { [27]=107934 },	-- Taren
["bbff8"] = { [2]=100078 },	-- Zabójca z Zurhidonu
["bbfff"] = { [2]=100065 },	-- Wędrowiec z Tageny
["bc000"] = { [2]=100066, [102]=-1, [11]=-1, [25]=-1 },	-- Uczeń Zurhidonu
["bc003"] = { [2]=100076 },	-- Demon z Krainy Snów
["bc012"] = { [4]=100097 },	-- Pancerny Kasumille
["bc013"] = { [4]=100098 },	-- Wściekły Goblin
["bc01b"] = { [1]=100122 },	-- Bubsitan
["bc01d"] = { [1]=101280 },	-- Beruda Lize
["bc01e"] = { [4]=100221, [7]=-1 },	-- Bestia Morcus
["bc027"] = { [102]=100068 },	-- Związany Badacz
["bc029"] = { [102]=100070 },	-- Nekromag
["bc02a"] = { [102]=1, [201]=1, [354]=-1 },	-- Zombi
["bc02b"] = { [102]=100072, [120]=-1 },	-- Ghul
["bc02c"] = { [102]=100073 },	-- Książę Ghuli
["bc02d"] = { [102]=100074, [120]=-1 },	-- Demoniczna Wiedźma Ancalon
["bc02e"] = { [102]=1, [201]=1 },	-- Szlam
["bc02f"] = { [102]=100392 },	-- Mroczny Nietoperz Wrzaskun
["bc030"] = { [102]=100561 },	-- Płynny Chaos
["bc031"] = { [102]=100562 },	-- Okrutny Pożeracz
["bc032"] = { [102]=100563 },	-- Pusta Skorupa
["bc039"] = { [5]=100355 },	-- Carfcamoi
["bc03b"] = { [5]=100366 },	-- Cień Króla Berhu
["bc03d"] = { [5]=100369 },	-- Ognistooka Fretka Ystryjska
["bc03e"] = { [5]=100570 },	-- Śnieżna Żaba Ystryjska
["bc046"] = { [5]=100266 },	-- Quirlag, Syn Smoka Ziemi
["bc052"] = { [104]=100364 },	-- Minotaur Ghul
["bc054"] = { [102]=100614, },	-- Sługa
["bc055"] = { [103]=100144, [103]=100148, [1]=-1 },	-- Chyży Cień
["bc056"] = { [103]=100166 },	-- Siła Androliera
["bc057"] = { [103]=100193 },	-- Waleczna Zbroja
["bc058"] = { [103]=100206 },	-- Przeklęta Szata
["bc059"] = { [103]=100231 },	-- Kryształ Smutku
["bc05a"] = { [103]=100232 },	-- Kryształ Nienawiści
["bc05b"] = { [103]=100233 },	-- Cień Androliera
["bc05c"] = { [103]=100234 },	-- Cień Żądzy
["bc05d"] = { [103]=100236 },	-- Więzień Androliera
["bc05e"] = { [103]=100261 },	-- Krodamon
["bc05f"] = { [103]=100262 },	-- Krodamar
["bc060"] = { [103]=100264 },	-- Magister Gumas
["bc061"] = { [103]=100641 },	-- Kryształ Grozy
["bc062"] = { [6]=100620 },	-- Olbrzymi Kaktus Iglasty
["bc063"] = { [6]=100621 },	-- Olbrzymi Kaktus Kwiecisty
["bc064"] = { [104]=100138 },	-- Przeklęty Żelazny Golem
["bc065"] = { [104]=100154 },	-- Razeela
["bc066"] = { [104]=100611 },	-- Dorlos
["bc067"] = { [104]=100159 },	-- Ognisty Koszmar
["bc068"] = { [104]=100374 },	-- Nikczemny Duch Lodu
["bc069"] = { [104]=100583 },	-- Manoperz
["bc06a"] = { [104]=100587 },	-- Skorpion Spękany
["bc06b"] = { [104]=100594, [26]=-1 },	-- Strażnik Zurhidonu
["bc06c"] = { [104]=100597 },	-- Żuk Mroku
["bc06d"] = { [104]=100606 },	-- Żołnierz Zurhidonu
["bc06e"] = { [104]=100607, [26]=-1 },	-- Grabieżca Zurhidonu
["bc06f"] = { [104]=100609 },	-- Bestia Morcus z Zaświatów
["bc070"] = { [104]=100610 },	-- Pożeracz Snów
["bc071"] = { [6]=100667 },	-- Olbrzymi Kaktus Owocowy
["bc076"] = { [6]=100443, },	-- Czarny Skorpion Skalny
["bc077"] = { [6]=100444, },	-- Skorpion Żądlący
["bc078"] = { [6]=100445, },	-- Iguana Wyżynna
["bc079"] = { [6]=100446, },	-- Iguana Blaskołuska
["bc084"] = { [119]=-1 },	-- Jaszczur Ognisty
["bc086"] = { [105]=100160 },	-- Królowa Merymexów Kal Turok
["bc08b"] = { [6]=100435, [26]=-1 },	-- Zmutowana Larwa
["bc090"] = { [6]=100451 },	-- Szaman Yeda
["bc099"] = { [6]=100450 },	-- Ayelo
["bc09c"] = { [6]=100662 },	-- Zanikająca Dusza Mężczyzny
["bc0a2"] = { [250]=100649 },	-- Łamignat
["bc0a3"] = { [201]=100700, [201]=100705, [1]=-1 },	-- Runiczny Duch Śnieżny
["bc0a4"] = { [201]=100701 },	-- Krwiożerczy Nietoperz Listowiec
["bc0a5"] = { [201]=100702 },	-- Nietoperz Zielonoskrzydły
["bc0a6"] = { [201]=100703 },	-- Drapieżny Nietoperz Cienisty
["bc0a7"] = { [201]=100704 },	-- Posępny Nietoperz Magiczny
["bc0a8"] = { [201]=100706 },	-- Hrabia Hibara
["bc0a9"] = { [201]=100707 },	-- Hrabia Hibara
["bc0aa"] = { [4]=100726 },	-- Taylin Ość
["bc0ab"] = { [2]=100692 },	-- Pierzchacz Brązołuski
["bc0ac"] = { [4]=100140 },	-- Marclaw Młotozębny
["bc0ad"] = { [4]=100628 },	-- Chester Żelazna Zbroja
["bc0af"] = { [5]=100200 },	-- Mędrzec Akeli
["bc0b0"] = { [4]=100629 },	-- Perodia
["bc0b1"] = { [5]=100408 },	-- Sauropus
["bc0b2"] = { [5]=100737 },	-- Ambas
["bc0b3"] = { [5]=100738 },	-- Mściwy Duch
["bc0b6"] = { [2]=100817 },	-- Kipos
["bc0cd"] = { [110]=101456 },	-- Piaskowa Pluskwa Jaskiniowa
["bc0ce"] = { [110]=101457 },	-- Skalny Skorpion Jaskiniowy
["bc0cf"] = { [110]=101458 },	-- Kobold Strażnik
["bc0d0"] = { [110]=101459 },	-- Kobold Mistrz Górniczy
["bc0d1"] = { [110]=101460 },	-- Kobold Geniusz
["bc0d2"] = { [110]=101461 },	-- Kobold Kroczący w Cieniu
["bc0d3"] = { [110]=101462 },	-- Anglo
["bc0d4"] = { [205]=102144 },	-- Żywiołak Strachu
["bc0d5"] = { [205]=102145 },	-- Zamarznięty Cień
["bc0d6"] = { [205]=102146 },	-- Cień Więźnia
["bc0d7"] = { [205]=102147 },	-- Nikczemna Ułuda
["bc0d8"] = { [205]=102148 },	-- Cień Mordercy
["bc0d9"] = { [205]=102149 },	-- Bezgłowy Wojownik
["bc0da"] = { [205]=102150 },	-- Nieumarły Poszukiwacz
["bc0db"] = { [205]=102151 },	-- Zwłoki Poszukiwacza Skarbów
["bc0dc"] = { [206]=102129 },	-- Strażnik Czarnego Rdzenia
["bc0dd"] = { [206]=101398 },	-- Energetyczny Strażnik Burzy
["bc0de"] = { [206]=101399 },	-- Energetyczny Strażnik Mrozu
["bc0e0"] = { [206]=101401, [123]=-1, [117]=-1 },	-- Ognisty Runiczny Szermierz
["bc0e1"] = { [206]=102134, [123]=-1, [117]=-1 },	-- Strażnik Runy Mrozu
["bc0e2"] = { [206]=102135 },	-- Kryształ Palącej Trucizny
["bc0e3"] = { [206]=102136 },	-- Kryształ Zabójczej Trucizny
["bc0e5"] = { [207]=102159, [134]=-1, [135]=-1 },	-- Kamienny Strażnik
["bc0e6"] = { [207]=102160 },	-- Strażnik z Zimnej Stali
["bc0e7"] = { [207]=102161 },	-- Rogaty Strażnik
["bc0e8"] = { [207]=102162 },	-- Zwiastun Chaosu
["bc0e9"] = { [206]=102195 },	-- Duch Twórcy Strażników
["bc0ea"] = { [207]=102196 },	-- Przywódca Runicznych Strażników
["bc0eb"] = { [207]=102197 },	-- Raichika Niszczyciel
["bc0ec"] = { [207]=102163, [204]=-1 },	-- Martwy Strażnik
["bc0ed"] = { [207]=102164 },	-- Nikczemny Kościany Strażnik
["bc0ee"] = { [107]=101515 },	-- Salamandra z Ousul
["bc0ef"] = { [107]=101516 },	-- Jadowita Żaba z Ousul
["bc0f0"] = { [107]=101504 },	-- Urocza Dziewica Muz
["bc0f1"] = { [107]=101505 },	-- Szalona Dziewica Muz
["bc0f2"] = { [107]=101506 },	-- Zrozpaczona Dziewica Muz
["bc0f3"] = { [107]=101508 },	-- Runiczny Wartownik
["bc0f4"] = { [107]=101509, [190]=-1, [192]=-1, [38]=-1 },	-- Runiczny Strażnik
["bc0f5"] = { [107]=101511 },	-- Runiczny Niszczyciel
["bc0f6"] = { [107]=101512 },	-- Runiczny Przepatrywacz
["bc0f8"] = { [107]=101507 },	-- Żelazny Wojownik Runiczny
["bc0f9"] = { [107]=101501, [120]=-1 },	-- Yusalien
["bc0fa"] = { [107]=101502 },	-- Locatha
["bc0fb"] = { [107]=101500 },	-- Uczeń Bogini Sztuk
["bc0fc"] = { [107]=101503 },	-- Ensia
["bc0fd"] = { [107]=100237 },	-- Regin
["bc0fe"] = { [252]=101355 },	-- Wojownik Agrizy
["bc0ff"] = { [252]=101356 },	-- Generał Agrizy
["bc100"] = { [252]=101357 },	-- Nieustraszony Barbarzyński Żołnierz
["bc101"] = { [252]=101358 },	-- Wojak Agrizy
["bc102"] = { [252]=101359 },	-- Żołnierz Oblężniczy Agrizy
["bc103"] = { [252]=101360 },	-- Zakapior Agrizy
["bc104"] = { [252]=101361 },	-- Agresor Agrizy
["bc105"] = { [252]=101362 },	-- Wilczy Jeździec Agrizy
["bc106"] = { [252]=101363, [30]=-1 },	-- Oszalały Olbrzymi Wilk
["bc107"] = { [252]=101364 },	-- Przyzywacz Burzy
["bc108"] = { [252]=101365 },	-- Obrońca Agrizy
["bc109"] = { [252]=101366 },	-- Uzdrowiciel Agrizy
["bc10b"] = { [252]=101387 },	-- Czarownik Zurhidonu
["bc10c"] = { [10]=-1, [252]=101388 },	-- Zwolennik Zurhidonu
["bc10d"] = { [252]=101347 },	-- Negocjator Zurhidonu
["bc10e"] = { [252]=101346 },	-- Boddosh
["bc10f"] = { [252]=101349 },	-- Masso
["bc110"] = { [252]=101350 },	-- Gorn
["bc111"] = { [252]=101351 },	-- Ordig
["bc112"] = { [252]=101352 },	-- Uguda
["bc113"] = { [108]=101531 },	-- Klątwa Willa
["bc114"] = { [108]=101532 },	-- Lojalny Talomo
["bc115"] = { [108]=101533 },	-- Głaz Sidaar
["bc116"] = { [108]=101534 },	-- Obserwator Luke
["bc117"] = { [108]=101535, [120]=-1 },	-- Śnieżna Blake
["bc118"] = { [108]=101255, [208]=-1 },	-- Marynarz Czarnych Żagli
["bc119"] = { [108]=101256, [208]=101256 },	-- Sternik Czarnych Żagli
["bc11a"] = { [108]=101257 },	-- Morderca Czarnych Żagli
["bc11b"] = { [108]=101258 },	-- Sługa Śnieżnej
["bc11c"] = { [108]=101259, [208]=101259 },	-- Morski Pogromca Czarnych Żagli
["bc11d"] = { [108]=101260 },	-- Tajny Agent Blake
["bc11e"] = { [108]=101261 },	-- Agresor Czarnych Żagli
["bc11f"] = { [108]=101262 },	-- Zabójca Blake
["bc120"] = { [108]=101263 },	-- Klątwa Głębin
["bc121"] = { [108]=101264 },	-- Koszmar Głębin
["bc122"] = { [108]=101265 },	-- Przeklęty Marynarz Czarnych Żagli
["bc123"] = { [108]=101266 },	-- Przeklęty Pirat Czarnych Żagli
["bc141"] = { [10]=100744, [30]=-1 },	-- Olbrzymi Krab Strumieniowy
["bc143"] = { [30]=-1 },	-- Wściekły Łuskacz
["bc144"] = { [10]=100775, [30]=-1 },	-- Ważka Purpurowa
["bc147"] = { [10]=100776 },	-- Pomocnik Zurhidonu
["bc148"] = { [252]=-1 },	-- Egzekutor Zurhidonu
["bc158"] = { [10]=101292 },	-- Tajemniczy Olbrzymi Wilk
["bc14f"] = { [10]=100755 },	-- Olbrzymi Wilk z Dziczy
["bc15d"] = { [10]=100740 },	-- Jadowita Żaba Bagienna
["bc15f"] = { [10]=100752, [32]=-1 },	-- Dziki Łuskacz
["bc160"] = { [10]=100796 },	-- Żaba Czerwonoogoniasta
["bc162"] = { [402]=-1 },	-- Latający Baloniak
["bc16a"] = { [11]=100863, [35]=-1 },	-- Jaszczur Górski
["bc170"] = { [11]=100870, [24]=-1 },	-- Młody Mamut
["bc178"] = { [11]=101006, [113]=-1, [114]=-1 },	-- Lodowy Krasnolud Robotnik
["bc187"] = { [11]=100973, [2]=-1, [25]=-1, [102]=-1 },	-- Uczeń Zurhidonu
["bc188"] = { [11]=100974, [2]=-1, [25]=-1, [102]=-1 },	-- Uczeń Zurhidonu (fioletowa)
["bc1bc"] = { [3]=101571, [13]=-1 },	-- Hiena z Pustkowi
["bc1be"] = { [3]=100333, [23]=-1, [146]=-1, [147]=-1, [148]=-1 },	-- Żywiołak Wiatru
["bc1c4"] = { [3]=100342 },	-- Żaba Rycząca
["bc1c5"] = { [3]=100590 },	-- Czarny Krab Pancerny
["bc1d0"] = { [3]=100347 },	-- Zmutowany Piaskowy Skorpion
["bc1d4"] = { [3]=101563 },	-- Larwa Samicy Piaskowego Skorpiona
["bc1d5"] = { [3]=101564 },	-- Larwa Samca Piaskowego Skorpiona
["bc1d8"] = { [3]=101575 },	-- Przybrzeżny Wartownik
["bc1e0"] = { [11]=101789 },	-- Szturmowiec Agrizy
["bc1e1"] = { [11]=101790 },	-- Szturmowy Wilk Agrizy
["bc1e2"] = { [11]=101791 },	-- Axis, Dowódca Wilków Bojowych
["bc1e3"] = { [113]=101585, [114]=1 },	-- Skuty Lodem Strażnik
["bc1e4"] = { [113]=101586, [114]=1 },	-- Mula Gwóźdź
["bc1e5"] = { [113]=101587, [114]=1 },	-- Crasset Włochata Stopa
["bc1e6"] = { [113]=101606, [114]=1 },	-- Magiczny Strażnik Lodołuski
["bc1e7"] = { [113]=101588, [114]=1 },	-- Król Kretów
["bc1e8"] = { [113]=101590, [114]=1 },	-- Wodna Cavia Kryształowa
["bc1e9"] = { [113]=101592, [114]=1 },	-- Pierzasta Cavia Kryształowa
["bc1ea"] = { [113]=101598, [114]=1, [37]=-1 },	-- Olbrzym Ziemi - Żołnierz
["bc1eb"] = { [113]=101600, [114]=1 },	-- Bitewna Bestia Fogur
["bc1ec"] = { [113]=101601, [114]=1 },	-- Pancerna Bestia Fogur
["bc1ed"] = { [113]=101687, [114]=1 },	-- Lodowy Krasnolud Handlarz
["bc1ee"] = { [113]=101688, [114]=1 },	-- Lodowy Krasnolud Zabójca
["bc1ef"] = { [113]=101689, [114]=1 },	-- Lodowy Krasnolud Niszczyciel
["bc1f0"] = { [113]=101690, [114]=1 },	-- Lodowy Krasnolud Posłaniec Dusz
["bc1f1"] = { [113]=101691, [114]=1 },	-- Lodowy Krasnolud Posłaniec Żywiołów
["bc1f2"] = { [113]=101692, [114]=1 },	-- Nieustraszony Lodowy Krasnolud
["bc1f3"] = { [113]=101693, [114]=1 },	-- Lodowy Krasnolud Rzeźnik
["bc1f4"] = { [113]=101694, [114]=1 },	-- Poskramiacz Bitewnych Bestii Fogur
["bc1f5"] = { [113]=101695, [114]=1 },	-- Poskramiacz Pancernych Bestii Fogur
["bc1f6"] = { [113]=101725, [114]=1 },	-- Lodowy Krasnolud Rekrut
["bc1f7"] = { [113]=101707, [114]=1 },	-- Lodowy Robotnik
["bc1f8"] = { [113]=101708, [114]=1 },	-- Lodowy Krasnolud Tragarz
["bc201"] = { [7]=101784 },	-- Bisang
["bc218"] = { [7]=101764, [4]=-1 },	-- Tajemniczy Gość
["bc219"] = { [23]=-1, [146]=-1, [147]=-1, [148]=-1 },	-- Żywiołak Wody
["bc229"] = { [7]=101755 },	-- Wojownik Twardogłowych (+4 patt)
["bc22a"] = { [7]=101756 },	-- Wojownik Twardogłowych (+3 sta)
["bc236"] = { [7]=101772 },	-- Moriargy
["bc238"] = { [120]=-1, [9]=-1, [25]=-1 },	-- Badacz Zurhidonu
["bc258"] = { [114]=101268 },	-- Pangkor
["bc259"] = { [114]=101584, [120]=-1 },	-- Thynos
["bc26d"] = { [8]=102223, [1]=-1 },	-- Grzyb Strażnik
["bc29d"] = { [8]=102323 },	-- Wściekły Brudny Bies
["bc29e"] = { [8]=102242, [9]=-1 },	-- Zakazany Obrońca
["bc2a0"] = { [8]=102244 },	-- Zakazany Wartownik
["bc2a4"] = { [208]=102386 },	-- Koszmarny Androlier
["bc2a5"] = { [208]=102405 },	-- Koszmarny Trup
["bc2a6"] = { [208]=102406 },	-- Zimny Koszmar
["bc2a7"] = { [208]=102407 },	-- Burzowy Koszmar
["bc2a8"] = { [208]=102408 },	-- Mara Wojny
["bc2a9"] = { [208]=102409 },	-- Treacherous Illusion
["bc2aa"] = { [208]=102410 },	-- Mara Zdrady
["bc2b0"] = { [9]=102509 },	-- Generał Czarnych Węży Mafrur
["bc2b7"] = { [9]=102516, [119]=102516 },	-- Wartownik Nag
["bc2c1"] = { [119]=102802, [9]=-1 },	-- Generał Szkarłatnych Węży, Kurawang
["bc2c6"] = { [9]=102531 },	-- Kwatermistrz Nag
["bc2ca"] = { [9]=102535, [302]=-1 },	-- Straszliwa Mantikora
["bc2cb"] = { [9]=102536, [302]=-1 },	-- Straszliwy Jeździec Wichru
["bc2d4"] = { [9]=102503, [8]=-1 },	-- Magmowy Transporter
["bc2e0"] = { [209]=103531 },	-- Wielki Pająk Kanalizacyjny
["bc2e1"] = { [127]=-1, [209]=103532 },	-- Wielki Kanalizacyjny Karaluch
["bc2e2"] = { [127]=-1, [209]=103533 },	-- Ogromny Szczur z Kanałów
["bc2e3"] = { [209]=103534, [227]=-1, [127]=-1 },	-- Kanalizacyjny Potwór Błotny
["bc2f9"] = { [16]=103603 },	-- Mgielny Wojownik Rh'anka
["bc2fa"] = { [16]=103606 },	-- Mglisty Szaman Rh'anka
["bc2fb"] = { [16]=103607 },	-- Bambam Lom
["bc303"] = { [16]=103583 },	-- Ślepy Siecznik
["bc310"] = { [15]=103580 },	-- Król Hipogryfów Wodjin
["bc319"] = { [17]=103991, [14]=-1 },	-- Zgniłe Enciątko
["bc31b"] = { [17]=103993 },	-- Elfi Wojownik Jyr'na (+4 pdeff)
["bc31c"] = { [17]=103994 },	-- Elfi Wojownik Jyr'na (+3 matt)
["bc32b"] = { [17]=104013 },	-- Wartownik z Zaramonde
["bc32d"] = { [17]=104149 },	-- Zioło Szalejącego Płomienia
["bc329"] = { [17]=104015, [190]=-1, [191]=-1, [193]=-1 },	-- Spaczony Centaur Wojownik
["bc338"] = { [22]=106473 },	-- Badacz Ruin
["bc338"] = { [23]=106473, [22]=-1 },	-- Badacz Ruin
["bc339"] = { [17]=104039 },	-- Griffith Czarnogwiazdy, Spaczony Centaur
["bc347"] = { [18]=104272, [37]=-1 },	-- Pustynne Boshi
["bc353"] = { [18]=104284, [37]=-1	},	-- Piaskowy Żółw
["bc354"] = { [36]=109449, [130]=-1, [132]=-1, [133]=-1 },	-- Upadłe Enciątko
["bc356"] = { [18]=104288, [127]=-1, [128]=-1, [139]=-1, [140]=-1 },	-- Badacz Ręki Prawdy
["bc367"] = { [17]=104011 },	-- Szkodnik z Farmy
["bc370"] = { [19]=104705 },	-- Kapłanka Pająków Mandara
["bc378"] = { [19]=104713, [136]=-1, [137]=-1, [138]=-1 },	-- Zaklinacz Węży
["bc38e"] = { [19]=104735, [18]=-1 },	-- Panzilla Trawiasta
["bc3b8"] = { [13]=105174, [3]=-1 },	-- Hiena z Pustkowi
["bc3bd"] = { [13]=105179 },	-- Pradawny Limon Bandyta (+1 wis)
["bc3ca"] = { [13]=105193 },	-- Krab Pustelnik z Hending
["bc3ce"] = { [13]=105271 },	-- Groźny Tygrys Szablozębny
["bc3d0"] = { [13]=105276 },	-- Gigantyczny Stary Pyton Bazyliszkowy
["bc3d1"] = { [13]=105277 },	-- Zmutowana Żmija z Mestro
["bc3da"] = { [13]=105375 },	-- Pradawny Limon Bandyta (+2 patt)
["bc3e1"] = { [14]=105290 },	-- Akolita Mrocznego Rytu
["bc3e2"] = { [14]=105291 },	-- Mag Mrocznego Rytu
["bc3e3"] = { [14]=105292 },	-- Instruktor Mrocznego Rytu
["bc3e4"] = { [14]=105293 },	-- Czarnoksiężnik Mrocznego Rytu
["bc3eb"] = { [14]=105398 },	-- Zaklęty Zombi
["bc3fa"] = { [14]=105433, [30]=-1 },	-- Szkielet - Wojownik(Xaviera)
["bc40d"] = { [14]=105492, [17]=-1 },	-- Zgniłe Enciątko(Xaviera)
["bc417"] = { [14]=105511, [30]=-1 },	-- Harpia - Kusicielka (Xaviera)
["bc426"] = { [20]=105668, [30]=-1 },	-- Zwiastun Śmierci
["bc42c"] = { [20]=105766 },	-- Zjawa z Pola Bitwy
["bc427"] = { [20]=105669 },	-- Dziwny Bandyta z Pola Bitwy
["bc42a"] = { [20]=105764 },	-- Szczenię Gnatożuja
["bc45a"] = { [21]=105797 },	-- Złodziejska Złota Rączka
["bc472"] = { [21]=106079 },	-- Obserwator Sismonda
["bc473"] = { [21]=105893 },	-- Targonharl
["bc474"] = { [21]=105894 },	-- Lagusen
["bc4ae"] = { [31]=106556 },	-- Ślepy Pająk Otchłani
["bc4af"] = { [31]=106557 },	-- Plugawy Szczur Jaskiniowy
["bc4b0"] = { [31]=106558 },	-- Kryształowy Szczurowąż
["bc4b3"] = { [31]=106561 },	-- Widmo Zasadzki
["bc4b6"] = { [31]=106564 },	-- Marionetka Mrocznej Energii
["bc4d1"] = { [23]=106727 },	-- Myrmex - Obrońca Gniazda (+4 mdeff)
["bc4d3"] = { [23]=106859 },	-- Myrmex - Obrońca Gniazda (+4 pdeff)
["bc4dc"] = { [24]=107079 },	-- Szalona Postać
["bc4f1"] = { [24]=107103 },	-- Nurkujący Kladoren
["bc4f7"] = { [24]=107110, [154]=-1, [155]=-1, [156]=-1 },	-- Pogromca Żywiołów nr 732
["bc501"] = { [24]=107213 },	-- Zelkenrys
["bc50d"] = { [25]=107505, [33]=-1 },	-- Cień z Ruin
["bc50f"] = { [25]=107511, [35]=-1 },	-- Cienisty Strażnik
["bc51a"] = { [25]=107507, [102]=-1, [11]=-1, [2]=-1 },	-- Uczeń Zuhiradonu
["bc532"] = { [26]=107739, [25]=-1 },	-- Pradawny Wilczek Sarlo
["bc538"] = { [26]=107748, [25]=-1 },	-- Twardoróg Sarlo
["bc541"] = { [26]=107707, [104]=-1 },	-- Najeźdźca Zurhidonu
["bc549"] = { [26]=107712, [104]=-1 },	-- Strażnik Zurhidonu
["bc557"] = { [26]=107794, [6]=-1 },	-- Zmutowana Larwa
["bc55d"] = { [26]=107729, [120]=-1 },	-- Patrol Zurhidonu
["bc5ad"] = { [28]=106877 },	-- Dzika Koralowa Jaszczurka
["bc5b0"] = { [28]=108118 },	-- Szalona Papowaka
["bc5ba"] = { [28]=108230 },	-- Czerownoplamisty Potwór
["bc5ce"] = { [29]=108261 },	-- Królowa Krwawych Pszczół
["bc5d0"] = { [29]=103410 },	-- Duch Głodu
["bc5f0"] = { [32]=108674 },	-- Gniewny Kieł
["bc600"] = { [30]=108526, [10]=-1 },	-- Ważka Purpurowa
["bc601"] = { [30]=108527, [10]=-1 },	-- Olbrzymi Krab Strumieniowy
["bc60a"] = { [30]=108426, [252]=-1 },	-- Olbrzymi Szaleńczy Wilk
["bc60e"] = { [30]=108509 },	-- Kierowca Lekkiego Banka
["bc610"] = { [30]=108554 },	-- Rozgniewany Mały Mamut
["bc614"] = { [30]=103427, [14]=-1 },	-- Skrytobójca Harpia (Kashaylan)
["bc615"] = { [30]=103428, [14]=-1 },	-- Harpia Zaklinaczka
["bc625"] = { [30]=108500 },	-- Dziki Samiec Mantikory
["bc627"] = { [30]=108502, [14]=-1 },	-- Szkieletowy Żołnierz (Kashaylan)
["bc62c"] = { [32]=108719, [169]=-1, [170]=-1, [171]=-1 },	-- Lekarz Okrętowy Rozpryskującej Rzeki
["bc62d"] = { [32]=108723 },	-- Mieszkaniec Mglistego Portu (+1 sta)
["bc62e"] = { [32]=108724 },	-- Mieszkaniec Mglistego Portu (+1 int)
["bc63d"] = { [32]=108911 },	-- Młoda Gazela Wybrzeża Rozpryskującej Rzeki
["bc63f"] = { [32]=108839, [10]=-1 },	-- Dziki Łuskacz
["bc644"] = { [32]=108849, [169]=-1, [170]=-1, [171]=-1 },	-- Brygadzista Drewna Opałowego
["bc65a"] = { [33]=109188, [140]=-1, [139]=-1},	-- Szkielet Generał
["bc65c"] = { [33]=109035 },	-- Mały Szerokoustny Nosorożec (+3 pdeff)
["bc65f"] = { [33]=109175 },	-- Mały Szerokoustny Nosorożec (+3 mdeff)
["bc667"] = { [33]=109046, [172]=-1, [173]=-1, [174]=-1 },	-- Żelaznoszczęki Grafitowy Szaman
["bc678"] = { [33]=109041 },	-- Zagubiony Mag Szkielet
["bc679"] = { [33]=108856, [25]=-1 },	-- Runiczny Cień
["bc67b"] = { [33]=109225, [1]=-1 },	-- Zwiadowca Koboldów
["bc67c"] = { [30]=108400, [22]=-1, [154]=-1, [155]=-1, [156]=-1 },	-- Sismond
["bc688"] = { [34]=104940, [178]=-1, [179]=-1, [180]=-1 },	-- Kontrolowane Ciało Wojownika
["bc68a"] = { [34]=109283, [178]=-1, [179]=-1, [180]=-1 },	-- Zmieszany Kaktus Owocowy
["bc68c"] = { [34]=109285, [178]=-1, [179]=-1, [180]=-1 },	-- Zmieszany Kaktus Iglasty
["bc69f"] = { [34]=109304, [178]=-1, [179]=-1, [180]=-1 },	-- Jadowity Wąż Tasuq
["bc6a1"] = { [34]=109306, [178]=-1, [179]=-1, [180]=-1 },	-- Brązowy Wilk Tasuq
["bc6a2"] = { [34]=104994, [178]=-1, [179]=-1, [180]=-1 },	-- Upadła Harpia
["bc6a3"] = { [34]=104995, [178]=-1, [179]=-1, [180]=-1 },	-- Upadły Skorpion Skalny
["bc6a8"] = { [34]=105089 },	-- Chaotyczna Mroczna Energia
["bc6bc"] = { [35]=109328, [25]=-1 },	-- Cienisty Strażnik
["bc6c7"] = { [35]=109339 },	-- Agregat Chorego Morza
["bc6d8"] = { [35]=109356, [11]=-1},	--Wyżynna Jaszczurka
-- Vortis --
["bc71e"] = { [37]=109619 },	-- Kaktus Burzowy
["bc71f"] = { [37]=109620 },	-- Lis Burzowy
["bc720"] = { [37]=109621, [28]=-1 },	-- Kryształ Ducha Ziemi
["bc721"] = { [37]=109622 },	-- Żołnierz Ziemi
["bc722"] = { [37]=109623 },	-- Rycerz Ziemi
["bc723"] = { [37]=109624, [113]=-1, [114]=-1 },	-- Olbrzymi Żołnierz Ziemi
["bc724"] = { [37]=109625 },	-- Burzowa Żmija Piaskowa
["bc725"] = { [37]=109626 },	-- Obłąkany Skorpion Burzowy
["bc726"] = { [37]=109627 },	-- Burzowy Żarłacz
["bc727"] = { [37]=109628 },	-- Panzilla Burzowa
["bc728"] = { [37]=109629 },	-- Zwiadowca Bandytów Canin
["bc729"] = { [37]=109630 },	-- Bandzior Bandytów Canin
["bc72a"] = { [37]=109631 },	-- Szajka Bandytów Canin
["bc72b"] = { [37]=109632 },	-- Dozorca Grona Niezniszczalnych
["bc72c"] = { [37]=109633 },	-- Nietoperz Burzowy
["bc72d"] = { [37]=109634 },	-- Wartownik Górski
["bc72e"] = { [37]=109635 },	-- Górski Zwiadowca Badacz
["bc72f"] = { [37]=109636 },	-- Zielony Żółw Lądowy
["bc730"] = { [37]=109637 },	-- Zielona Ćma Górska
["bc731"] = { [37]=109638 },	-- Zmutowany Yasheedee
["bc732"] = { [37]=109639 },	-- Sęp Bezkresu
["bc733"] = { [37]=109640 },	-- Biesokrzew Bezkresu
["bc734"] = { [37]=109641 },	-- Ocalały Bezkresu
["bc735"] = { [37]=109642 },	-- Czatownik Bezkresu
["bc736"] = { [37]=109643 },	-- Znachor Bezkresu
["bc737"] = { [37]=109644 },	-- Czarownik Bezkresu
["bc738"] = { [37]=109645 },	-- Pożeracz Bezkresu
["bc739"] = { [37]=109646 },	-- Gruzowy Skorpion Piaskowy
["bc73a"] = { [37]=109647 },	-- Szalony Skorpion Nożycoręki
["bc73b"] = { [37]=109648, [18]=-1 },	-- Piaskowy Żółw
["bc73c"] = { [37]=109649 },	-- Żmija Piaskowa Bezkresu
["bc73d"] = { [37]=109650 },	-- Piaskowy Nietoperz Bezkresu
["bc73e"] = { [37]=109651 },	-- Yasheedee Piłopaszczy
["bc73f"] = { [37]=109652 },	-- Hiena Żarłaczna
["bc740"] = { [37]=109653 },	-- Olbrzymi Wilk Żarłacz
["bc741"] = { [37]=109654 },	-- Zwiadowca Górskiego Szlaku
["bc742"] = { [37]=109655 },	-- Strażnik Górskiego Szlaku
["bc743"] = { [37]=109656 },	-- Cienie Górskiego Szlaku
["bc744"] = { [37]=109657 },	-- Szkieletowe Cierpienie
["bc745"] = { [37]=109658 },	-- Golem Chaosu
["bc746"] = { [37]=109659 },	-- Szelmy Cmentarzyska
["bc747"] = { [37]=109660 },	-- Mag Bojowy Cmentarzyska
["bc748"] = { [37]=109661 },	-- Straż Magów Cmentarzyska
["bc749"] = { [37]=109662 },	-- Badacze Cmentarzyska
["bc74a"] = { [37]=109663 },	-- Demon Pożeracza Cmentarzyska
["bc74b"] = { [37]=109664 },	-- Korpus Duszy bez Świadomości
["bc74c"] = { [37]=109665 },	-- Kości Dusz
["bc74d"] = { [37]=109666 },	-- Kamienny Wielki Posąg
["bc74e"] = { [37]=109667 },	-- Bokato
["bc74f"] = { [37]=109668 },	-- Sorlu Harp
["bc750"] = { [37]=109674, [134]=-1, [135]=-1 },	-- Olbrzymi Runiczny Strażnik
-- Chassizz --
["bc751"] =	{ [38]=109691 },	-- Skrytobójca Chassizz
["bc752"] =	{ [38]=109692 },	-- Bojownik Chassizz
["bc753"] =	{ [38]=109693 },	-- Mag Chassizz
["bc754"] =	{ [38]=109694 },	-- Ognisty Legwan
["bc755"] =	{ [38]=109695 },	-- Nieumarły Wędrowiec
["bc756"] =	{ [38]=109696 },	-- Nieumarły Czarownik
["bc757"] =	{ [38]=109697 },	-- Nieumarły Skrytobójca
["bc758"] =	{ [38]=109698, [30]=-1 },	-- Oddech Śmierci
["bc759"] =	{ [38]=109699 },	-- Cień Śmierci
["bc75a"] =	{ [38]=109700 },	-- Bestia Czarnej Krwi
["bc75b"] =	{ [38]=109701 },	-- Robak Purpurowego Kryształu
["bc75c"] =	{ [38]=109702 },	-- Biesokrzew Lasu Popiołu
["bc75d"] =	{ [38]=109703 },	-- Mięsożerna Roślina Lasu Popiołu
["bc75e"] =	{ [38]=109704 },	-- Grzyb Lasu Popiołu
["bc75f"] =	{ [38]=109705 },	-- Opiekun Lasu Popiołu
["bc760"] =	{ [38]=109706 },	-- Król Grzybów Lasu Popiołu
["bc761"] =	{ [38]=109707 },	-- Czatownika Lasu Popiołu
["bc762"] =	{ [38]=109708 },	-- Ochraniacz Run
["bc763"] =	{ [38]=109709 },	-- Strażnik Run
["bc764"] =	{ [38]=109710 },	-- Runiczna Patrol
["bc765"] =	{ [38]=109711 },	-- Niszczyciel Run
["bc766"] =	{ [38]=109712, [190]=-1, [192]=-1, [107]=-1 },	-- Runiczny Strażnik
["bc767"] =	{ [38]=109713 },	-- Transmutor Run
["bc768"] =	{ [38]=109714 },	-- Mechaniczny Tytan
["bc769"] =	{ [38]=109716 },	-- Magmowy Podżegacz
["bc76a"] =	{ [38]=109718 },	-- Magmowy Niszczyciel
["bc76b"] =	{ [38]=109722 },	-- Zmutowany Żywiołak Ognia
["bc76c"] =	{ [38]=109723 },	-- Magmowa Traszka
["bc76d"] =	{ [38]=109715 },	-- Magmowy Żywiołak Ognia
["bc76e"] =	{ [38]=109717 },	-- Magmowy Pretendent
["bc76f"] =	{ [38]=109719 },	-- Magmowy Infiltrator
["bc770"] =	{ [38]=109724 },	-- Kipiąca Stalowa Straż
["bc771"] =	{ [38]=109725 },	-- Kapitan Kipiącej Stalowej Straży
["bc772"] =	{ [38]=109726, [8]=-1 },	-- Ankylar Transportowy
["bc773"] =	{ [38]=109727 },	-- Niegotowy Żołnierz Demon
["bc774"] =	{ [38]=109728 },	-- Posłaniec Grona Niezniszczalnych
["bc775"] =	{ [38]=109729 },	-- Magazynier Kaa
["bc776"] =	{ [38]=109732 },	-- Patrol Gniazda Węży
["bc777"] =	{ [38]=109733 },	-- Logistyk Gniazda Węży
["bc778"] =	{ [38]=109734 },	-- Opiekun Gniazda Węży
["bc779"] =	{ [38]=109735 },	-- Straż Przednia Gniazda Węży
["bc77a"] =	{ [38]=109730 },	-- Generał Bursztynowo Oko Czerwonych Węży
["bc77b"] =	{ [38]=109731 },	-- Generał Nefrytowego Zęba Zielonych Węży
["bc77c"] =	{ [38]=109720 },	-- Magmowy Komendant
["bc77d"] =	{ [38]=109721 },	-- Magmowy Wścieklak
["bc77e"] =	{ [38]=109736 },	-- Żywiołak Ognia Posłańca Popiołu
["bc77f"] =	{ [38]=109737 },	-- Duch Ognia Posłańca Popiołu
["bc780"] =	{ [38]=109738 },	-- Kryształ Gniewu
["bc781"] =	{ [38]=109739 },	-- Prorok Apokalipsy Grona Niezniszczalnych
["bc782"] =	{ [38]=109740 },	-- Bojownik Apokalipsy Grona Niezniszczalnych
["bc783"] =	{ [38]=109741 },	-- Magiczna Straż Apokalipsy Grona Niezniszczalnych
["bc784"] =	{ [38]=109742 },	-- Dzik Czerwono-mięsny
["bc785"] =	{ [38]=109743 },	-- Łotr Apokalipsy
["bc786"] =	{ [38]=109744 },	-- Mag Bojowy Apokalipsy
["bc787"] =	{ [38]=109745 },	-- Magiczna Straż Niebiańskiego Szczytu
["bc788"] =	{ [38]=109746 },	-- Badacz Niebiańskiego Szczytu
["bc789"] =	{ [38]=109747 },	-- Demon Pożeracz Niebiańskiego Szczytu
["bc78a"] =	{ [38]=109748 },	-- Straż Naga Niebiańskiego Szczytu
["bc78b"] =	{ [38]=109749 },	-- Budowlaniec Naga Niebiańskiego Szczytu
["bc78d"] =	{ [38]=109751, [178]=-1, [179]=-1, [180]=-1 },	-- Mazzren
["bc78e"] =	{ [38]=109752, [36]=-1, [184]=-1, [185]=-1, [186]=-1 },	-- Kadnis
["bc78f"] =	{ [38]=109753, [187]=-1, [188]=-1, [189]=-1 },	-- Minas
["bc790"] =	{ [38]=109754 },	-- Eosis
["bc791"] =	{ [38]=109755 },	-- Metlav
-- Karty Drako -- 
["bc6fa"] = { [10000]=109555 },	-- Młody Drako Kreios
["bc6fb"] = { [10000]=109556 },	-- Dorosły Drako Kreios
["bc6fc"] = { [10000]=109557 },	-- Legendarny Drako Kreios
["bc6fd"] = { [10000]=109558 },	-- Młoda Drako Tethys
["bc6fe"] = { [10000]=109559 },	-- Dorosła Drako Tethys
["bc6ff"] = { [10000]=109560 },	-- Legendarna Drako Tethys
["bc700"] = { [10000]=109561 },	-- Młody Drako Okeanos
["bc701"] = { [10000]=109562 },	-- Dorosły Drako Okeanos
["bc702"] = { [10000]=109563 },	-- Legendarny Drako Okeanos
["bc703"] = { [10000]=109564 },	-- Młody Drako Koios
["bc704"] = { [10000]=109565 },	-- Dorosły Drako Koios
["bc705"] = { [10000]=109566 },	-- Legendarny Drako Koios
["bc706"] = { [10000]=109567 },	-- Młody Drako Kronos
["bc707"] = { [10000]=109568 },	-- Dorosły Drako Kronos
["bc708"] = { [10000]=109569 },	-- Legendarny Drako Kronos
["bc709"] = { [10000]=109570 },	-- Młoda Drako Rhea
["bc70a"] = { [10000]=109571 },	-- Dorosła Drako Rhea
["bc70b"] = { [10000]=109572 },	-- Legendarna Drako Rhea
["bc70c"] = { [10000]=109573 },	-- Młoda Drako Mnemosyne
["bc70d"] = { [10000]=109574 },	-- Dorosła Drako Mnemosyne
["bc70e"] = { [10000]=109575 },	-- Legendarna Drako Mnemosyne
["bc70f"] = { [10000]=109576 },	-- Młody Drako Hyperion
["bc710"] = { [10000]=109577 },	-- Dorosły Drako Hyperion
["bc711"] = { [10000]=109578 },	-- Legendarny Drako Hyperion
["bc712"] = { [10000]=109579 },	-- Młody Drako Iapetos
["bc713"] = { [10000]=109580 },	-- Dorosły Drako Iapetos
["bc714"] = { [10000]=109581 },	-- Legendarny Drako Iapetos
["bc715"] = { [10000]=109582 },	-- Młoda Drako Theia
["bc716"] = { [10000]=109583 },	-- Dorosła Drako Theia
["bc717"] = { [10000]=109584 },	-- Legendarna Drako Theia
["bc718"] = { [10000]=109585 },	-- Młoda Drako Themis
["bc719"] = { [10000]=109586 },	-- Dorosła Drako Themis
["bc71a"] = { [10000]=109587 },	-- Legendarna Drako Themis
["bc71b"] = { [10000]=109588 },	-- Młoda Drako Phoibe
["bc71c"] = { [10000]=109589 },	-- Dorosła Drako Phoibe
["bc71d"] = { [10000]=109590 },	-- Legendarna Drako Phoibe
};

yaCIt.MobNamePatch = {
[TEXT("Sys100992_name")] = "bbfd0",	-- Dziki Grzyb
[TEXT("Sys100993_name")] = "bbfd0",	-- Młody Dziki Grzyb
[TEXT("Sys100568_name")] = "bbfef",	-- Ważka z Aslan
[TEXT("Sys100569_name")] = "bbfef",	-- Ważka z Aslan
[TEXT("Sys100298_name")] = "bbffc",	-- Wściekły Parszywy Wieprz
[TEXT("Sys100299_name")] = "bbffd",	-- Wściekły Krwiożerczy Wilk
[TEXT("Sys100131_name")] = "bc001",	-- Sherfas
[TEXT("Sys102847_name")] = "bc00f",	-- Ayesha
[TEXT("Sys100655_name")] = "bc04c",	-- Minotaur Strażnik Ołtarza
[TEXT("Sys100274_name")] = "bc052",	-- Aukuda Potępieniec
[TEXT("Sys100880_name")] = "bc089",	-- Młody Myrmex Kal Turok
[TEXT("Sys100881_name")] = "bc08b",	-- Larwa
[TEXT("Sys102144_name")] = "bc0d4",	-- Rumak Umarłych
[TEXT("Sys102147_name")] = "bc0d7",	-- Złowieszczy Cień
[TEXT("Sys102154_name")] = "bc0d9",	-- Bezgłowy Upiór
[TEXT("Sys102155_name")] = "bc0d9",	-- Kapitan Upiorów
[TEXT("Sys102153_name")] = "bc0da",	-- Nieumarły Upiór
[TEXT("Sys102152_name")] = "bc0db",	-- Pozostałości po Poszukiwaczach Skarbów
[TEXT("Sys102129_name")] = "bc0dc",	-- Czarny Strażnik Rdzenia
[TEXT("Sys102131_name")] = "bc0de",	-- Mroźny Strażnik Energetyczny
[TEXT("Sys102139_name")] = "bc0df",	-- Święty Zaklęty Kapłan
[TEXT("Sys102140_name")] = "bc0e0",	-- Zaklęty Rycerz Płomienia
[TEXT("Sys102141_name")] = "bc0e1",	-- Zaklęty Strażnik Mrozu
[TEXT("Sys102162_name")] = "bc0e8",	-- Zwiastun Chaosu
[TEXT("Sys102195_name")] = "bc0e9",	-- Twórca Upiornych Strażników
[TEXT("Sys101737_name")] = "bc23f",	-- Rzekotka Stawowa
[TEXT("Sys102728_name")] = "bc27e",	-- Podpalacz z Akropolu
[TEXT("Sys102727_name")] = "bc2ae",	-- Tancerz Ostrzy z Akropolu
[TEXT("Sys102732_name")] = "bc2ae",	-- Żołnierz z Akropolu
[TEXT("Sys102733_name")] = "bc2ae",	-- Wartownik z Akropolu
[TEXT("Sys102729_name")] = "bc2b7",	-- Okrutny Strażnik z Akropolu
[TEXT("Sys102730_name")] = "bc2b7",	-- Chorąży z Akropolu
[TEXT("Sys102731_name")] = "bc2b7",	-- Śledczy z Akropolu
[TEXT("Sys102798_name")] = "bc2b7",	-- Mistrz Płomieni Szkarłatnych Węży
[TEXT("Sys103796_name")] = "bc2e1",	-- Wielki Karaluch do Eksperymentów
[TEXT("Sys103882_name")] = "bc2e1",	-- Wielki Karaluch do Eksperymentów
[TEXT("Sys103797_name")] = "bc2e2",	-- Szczur do Eksperymentów
[TEXT("Sys103883_name")] = "bc2e2",	-- Szczur do Eksperymentów
[TEXT("Sys103798_name")] = "bc2e3",	-- Błotny Potwór do Eksperymentów
[TEXT("Sys103884_name")] = "bc2e3",	-- Błotny Potwór do Eksperymentów
[TEXT("Sys107185_name")] = "bc303",	-- Urażony Hackman
[TEXT("Sys107183_name")] = "bc310",	-- Rozwścieczony Wodjin
[TEXT("Sys107792_name")] = "bc370",	-- Urażona Mandara
[TEXT("Sys107192_name")] = "bc474",	-- Rozwścieczony Lagusen
[TEXT("Sys107190_name")] = "bc473",	-- Rozwścieczony Targonharl
}
