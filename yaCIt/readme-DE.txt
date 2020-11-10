yaCIt 2.0

Dieses Addon ersetzt den originalen Monsterkarten-Tooltip und zeigt er-
weiterte Informationen auf einem eigenen Tooltip an:
 - Monsterbeschreibung gemäß Eintrag im Kompendium
 - Kategorie des Monsters (Humanoid usw.)
 - Zonen, in denen das Monster zu finden ist
 - Der Attribut-Bonus
 - ob Du die Karte besitzt und auf wievielen deiner Chars auf dem aktuellen Server
 - wenn die Karte eine Questbelohnung ist
 - Karte kann nur während einer Quest erworben werden
 - Karte kann nicht erworben werden
 
Der neue Tooltip wird bei allen gültigen Positonen für eine Karte angezeigt.
Dies gilt nicht im Falle des grauen Platzhalters, wenn mit der Karte eine 
ausgeführt wird. 
Das Addon verändert auch den versteckten Tooltip, den das Addon 'Adv. 
Auctionhouse' zum Filtern der Suchliste verwendet. Daher kann auch nach
Eigenschaften der Karte gesucht werden. Ein spezieller Filter ($notowned) wird 
den AAH-Filtern hinzugefügt, mindestens AAH 2.7+ ist nötig

yaCIt arbeitet korrekt mit pbInfo zusammen.
Die Unterstützung für Extratip wurde entfernt, weil dessen aktueller Code 
Hooking nicht mehr zulässt.

Wenn der Mauszeiger über einem Monster schwebt, wird dieser Tooltip mit der
Information erweitert, ob diese Karte existiert. In diesem fall wird ange-
zeigt, ob Du die Karte besitzt oder nicht.
Wenn der Name des Monsters in der Kartenliste bekannt ist, aber die aktuelle
Zone nicht zugeordnet ist, wird dies in einer globalen Korrekturliste ver-
merkt und gespeichert.

Unerfreulicherweise ist es an manchen Stellen nicht möglich, die Gegenstands-
nummer zu ermitteln, daher wird in diesen Fällen der Name verwendet. Weil es
Karten mit identischen Namen gibt, kann es zu Verwechslungen kommen. Unter 
anderem ist dies der Fall in der Mailbox, im Handelsfenster (PC-PC) und im 
Auktionshaus (außer der Suchliste)
Für den Monster-Tooltip wird zusätzlich die aktuelle Zone in Betracht gezo-
gen, was die Fehlerwahrscheinlichkeit reduziert.

Sollte in einer PvP-Umgebung ein Spieler-Pet den gleichen Namen wie eine 
Karte tragen, so könnte die aktuelle Zone für diese Karte registriert werden.
Daher werden alle Pets von der Kartensuche ausgenommen. Außerdem wurde die 
Tooltip-Funktion für die PvP-Zonen deaktiviert.

Das Monster-Kompendium wurde ersetzt. Schau Dich einfach um und vergiss das
Kontextmenü der Kartenliste nicht.
Es gibt eine Zusammenfassung der verfügbaren und erworbenen Attribut-Boni.

Anmerkung: Nach erfolgreichen Laden zeigt yaCIt folgende Meldungen an:

  yaCIt: 2.0 by Corgrind
  yaCIt: Es sind insgesamt 1156 Karten, davon hast Du XX (XX%).
  yaCIt: Verwende /ci oder /yacit [help] für Informationen


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
  Es wird eine Suche über die Liste der Kartennamen ausgeführt. Jede Karte,
  deren Name alle angegebenen Wortteile enthält, wird als Verknüpfung bei
  den Systemmeldungen ausgegeben.
  "/ci naga" listet alle Naga-Karten auf
  "/ci kobold plünd" listet Kobold-Plünderer und Anführer der Kobold-Plünderer auf

Vielen Dank an odie2 für die polnische Übersetzung.

Dank geht an alle Coder der Tools vyCardInfo (vaily), Zzabur's Compendium 
(DarkAngeOmega) und MonsterCardTooltip (joselucas):
Ich habe viel gelernt, wie Addon-Programmierung funktioniert und wie man an 
die Karteninformationen kommt.
Ebenfalls vielen Dank an den Programmierer (Mavoc) von Adv. Auctionhouse
Und mehr Dank geht an Pyrr, der gezeigt hat wie man das originale 3D Model 
in den eigenen Frame integriert. (durch v1.4 Framehandling überflüssig)
Ich habe Teile der Vorlagen von Lootimatic für meinen Konfigurationsdialog 
verwendet. Danke an KingDefrost / PetraAreon, die diese Tolol betreuen.

============================================================
Technische Informationen

Das erst Mal, wenn yaCIt geladen wird, und immer nach einem Update der In-
game-Kartenliste (Client-Update) benötigt das Addon ca. 30 sec (auf meinen 
PC) zum Aktualisieren der Zonenzuordnungen. Dies äußert sich in einer ver-
längerten Ladezeit während der Ladebildschirm angezeigt wird. Bitte stell 
sicher, dass die Einstellungen gespeichert werden, ansonsten erfolgt 
diese Aktualisierung erneut.

Der Code filtert die Kartenliste von leeren und Platzhalter Namen. In der
Regel folgt daraus eine geringere Kartenanzahl als bei Zzaburs oder vyCardinfo

*** Weitere technische Informationen im englischen readme-EN.txt ***
