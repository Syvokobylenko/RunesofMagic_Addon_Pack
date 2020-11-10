yaCIt 2.0

Dieses Addon ersetzt den originalen Monsterkarten-Tooltip und zeigt er-
weiterte Informationen auf einem eigenen Tooltip an:
 - Monsterbeschreibung gem�� Eintrag im Kompendium
 - Kategorie des Monsters (Humanoid usw.)
 - Zonen, in denen das Monster zu finden ist
 - Der Attribut-Bonus
 - ob Du die Karte besitzt und auf wievielen deiner Chars auf dem aktuellen Server
 - wenn die Karte eine Questbelohnung ist
 - Karte kann nur w�hrend einer Quest erworben werden
 - Karte kann nicht erworben werden
 
Der neue Tooltip wird bei allen g�ltigen Positonen f�r eine Karte angezeigt.
Dies gilt nicht im Falle des grauen Platzhalters, wenn mit der Karte eine 
ausgef�hrt wird. 
Das Addon ver�ndert auch den versteckten Tooltip, den das Addon 'Adv. 
Auctionhouse' zum Filtern der Suchliste verwendet. Daher kann auch nach
Eigenschaften der Karte gesucht werden. Ein spezieller Filter ($notowned) wird 
den AAH-Filtern hinzugef�gt, mindestens AAH 2.7+ ist n�tig

yaCIt arbeitet korrekt mit pbInfo zusammen.
Die Unterst�tzung f�r Extratip wurde entfernt, weil dessen aktueller Code 
Hooking nicht mehr zul�sst.

Wenn der Mauszeiger �ber einem Monster schwebt, wird dieser Tooltip mit der
Information erweitert, ob diese Karte existiert. In diesem fall wird ange-
zeigt, ob Du die Karte besitzt oder nicht.
Wenn der Name des Monsters in der Kartenliste bekannt ist, aber die aktuelle
Zone nicht zugeordnet ist, wird dies in einer globalen Korrekturliste ver-
merkt und gespeichert.

Unerfreulicherweise ist es an manchen Stellen nicht m�glich, die Gegenstands-
nummer zu ermitteln, daher wird in diesen F�llen der Name verwendet. Weil es
Karten mit identischen Namen gibt, kann es zu Verwechslungen kommen. Unter 
anderem ist dies der Fall in der Mailbox, im Handelsfenster (PC-PC) und im 
Auktionshaus (au�er der Suchliste)
F�r den Monster-Tooltip wird zus�tzlich die aktuelle Zone in Betracht gezo-
gen, was die Fehlerwahrscheinlichkeit reduziert.

Sollte in einer PvP-Umgebung ein Spieler-Pet den gleichen Namen wie eine 
Karte tragen, so k�nnte die aktuelle Zone f�r diese Karte registriert werden.
Daher werden alle Pets von der Kartensuche ausgenommen. Au�erdem wurde die 
Tooltip-Funktion f�r die PvP-Zonen deaktiviert.

Das Monster-Kompendium wurde ersetzt. Schau Dich einfach um und vergiss das
Kontextmen� der Kartenliste nicht.
Es gibt eine Zusammenfassung der verf�gbaren und erworbenen Attribut-Boni.

Anmerkung: Nach erfolgreichen Laden zeigt yaCIt folgende Meldungen an:

  yaCIt: 2.0 by Corgrind
  yaCIt: Es sind insgesamt 1156 Karten, davon hast Du XX (XX%).
  yaCIt: Verwende /ci oder /yacit [help] f�r Informationen


Kommandozeile (Chat):

/ci [help] [cfg] [<beliebiger Text>]
/yacit [help] [cfg] [<beliebiger Text>]

Keine Parameter
  Zeigt den aktuellen Status des Addons

help
  Zeigt eine erweiterte Hilfe an

cfg
  Zeigt den Konfigurationsdialog an.

<beliebiger Text>
  Es wird eine Suche �ber die Liste der Kartennamen ausgef�hrt. Jede Karte,
  deren Name alle angegebenen Wortteile enth�lt, wird als Verkn�pfung bei
  den Systemmeldungen ausgegeben.
  "/ci naga" listet alle Naga-Karten auf
  "/ci kobold pl�nd" listet Kobold-Pl�nderer und Anf�hrer der Kobold-Pl�nderer auf

Vielen Dank an odie2 f�r die polnische �bersetzung.

Dank geht an alle Coder der Tools vyCardInfo (vaily), Zzabur's Compendium 
(DarkAngeOmega) und MonsterCardTooltip (joselucas):
Ich habe viel gelernt, wie Addon-Programmierung funktioniert und wie man an 
die Karteninformationen kommt.
Ebenfalls vielen Dank an den Programmierer (Mavoc) von Adv. Auctionhouse
Und mehr Dank geht an Pyrr, der gezeigt hat wie man das originale 3D Model 
in den eigenen Frame integriert. (durch v1.4 Framehandling �berfl�ssig)
Ich habe Teile der Vorlagen von Lootimatic f�r meinen Konfigurationsdialog 
verwendet. Danke an KingDefrost / PetraAreon, die diese Tolol betreuen.

============================================================
Technische Informationen

Das erst Mal, wenn yaCIt geladen wird, und immer nach einem Update der In-
game-Kartenliste (Client-Update) ben�tigt das Addon ca. 30 sec (auf meinen 
PC) zum Aktualisieren der Zonenzuordnungen. Dies �u�ert sich in einer ver-
l�ngerten Ladezeit w�hrend der Ladebildschirm angezeigt wird. Bitte stell 
sicher, dass die Einstellungen gespeichert werden, ansonsten erfolgt 
diese Aktualisierung erneut.

Der Code filtert die Kartenliste von leeren und Platzhalter Namen. In der
Regel folgt daraus eine geringere Kartenanzahl als bei Zzaburs oder vyCardinfo

*** Weitere technische Informationen im englischen readme-EN.txt ***
