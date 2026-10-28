# Changelog

Ce fichier a été restructuré pour suivre un ordre cohérent :
- version d'addon en premier,
- puis langue (Français / English / Deutsch),
- puis notes détaillées.

---

## V5.8.1 - Cleanup, stability and collections

### Français
- Ajout de deux nouvelles fenêtres : Montures et Familiers, accessibles depuis les boutons de la fenêtre principale.
- Ces fenêtres listent par ordre alphabétique toutes les montures et tous les familiers connus de vos personnages, avec l'icône, le nom et le personnage qui les possède.
- Nettoyage des points de rupture dans la persistance des données personnages.
- Correction des structures manquantes lors du chargement des professions, réputations et quêtes épiques.
- Optimisation des sauvegardes en supprimant les chemins de données inutiles ou fragiles.
- Renforcement de la robustesse du chargement des données utilisateur.
- Mise à jour du fichier calcstats de Giseldah.

### English
- Added two new windows: Mounts and Pets, opened from the buttons in the main window.
- These windows list, in alphabetical order, every mount and pet known to your characters, with icon, name and owning character.
- Cleaned up fragile persistence paths for character data.
- Fixed missing-table issues when loading professions, reputations, and epic entries.
- Optimized saves by avoiding unnecessary or unsafe data rewrites.
- Hardened the plugin against missing or partially initialized data on load.
- Updated the calcstats file from Giseldah.

### Deutsch
- Zwei neue Fenster hinzugefügt: Reittiere und Haustiere, erreichbar über die Schaltflächen im Hauptfenster.
- Diese Fenster listen alphabetisch alle Reittiere und Haustiere deiner Charaktere auf, mit Symbol, Name und besitzendem Charakter.
- Bereinigung fragiler Persistenzpfade für Charakterdaten.
- Fehler bei fehlenden Tabellen beim Laden von Berufen, Ruf und epischen Einträgen behoben.
- Speicherung optimiert, indem unnötige oder unsichere Neuschreibungen von Daten vermieden werden.
- Robusteres Laden bei fehlenden oder teilweise initialisierten Daten.
- Aktualisierung der calcstats-Datei von Giseldah.

---

## V5.07 - Cleanup and stability pass

### Français
- Version de plugin mise à jour vers 5.07 pour la branche Testing.
- Nettoyage des points de rupture dans la persistance des données personnages.
- Correction des structures manquantes lors du chargement des professions, réputations et quêtes épiques.
- Optimisation des sauvegardes en supprimant les chemins de données inutiles ou fragiles.
- Renforcement de la robustesse du chargement des données utilisateur.

### English
- Updated the plugin version to 5.07 for the Testing branch.
- Cleaned up fragile persistence paths for character data.
- Fixed missing-table issues when loading professions, reputations, and epic entries.
- Optimized saves by avoiding unnecessary or unsafe data rewrites.
- Hardened the plugin against missing or partially initialized data on load.

### Deutsch
- Plugin-Version auf 5.07 für den Testing-Branch aktualisiert.
- Bereinigung fragiler Persistenzpfade für Zeichendaten.
- Fehler bei fehlenden Tabellen beim Laden von Berufen, Ruf und epischen Einträgen behoben.
- Speicherung optimiert, indem unnötige oder unsichere Datums-Neu-Schreibungen vermieden werden.
- Robusteres Laden bei fehlenden oder teilweise initialisierten Daten.

---

## V5.06 - Major refactor and stability update

### Français
- Refactor majeur du code par xruptor.
- Consolidation de la logique de persistance et de chargement.
- Nettoyage des fenêtres et des helpers partagés.
- Correction des erreurs liées aux sauvegardes et aux données per-character.
- Amélioration de la cohérence des structures de données sauvegardées.
- Ajustements de compatibilité et de robustesse du plugin.

### English
- Major code refactor carried out by xruptor.
- Consolidated persistence and loading logic.
- Cleaned up shared helpers and UI code paths.
- Fixed issues related to saves and per-character data handling.
- Improved consistency of saved data structures.
- Increased plugin robustness and compatibility.

### Deutsch
- Größere Code-Umstrukturierung durch xruptor.
- Konsolidierte Persistenz- und Lade-Logik.
- Bereinigung gemeinsamer Helfer und UI-Pfade.
- Fehler bei Speicherungen und personenbezogenen Daten behoben.
- Konsistenz der gespeicherten Datenstrukturen verbessert.
- Robustheit und Kompatibilität des Plugins verbessert.

---

## V4.92 - Mise à jour majeur

### Français
- Mise à jour des statistiques avec la dernière version de Giseldah, V 2.5.5.
- Ajout de 5 nouvelles réputations.
- Mise à jour du niveau max à 160.
- Mise à jour des noms des serveurs disponibles.
- Mise à jour du Tier 16 des professions.
- Refonte et nettoyage du code fait par xruptor.

### English
- Updated statistics with the latest version of Giseldah, V 2.5.5.
- Added 5 new reputations.
- Updated max level to 160.
- Updated available server names.
- Updated Tier 16 professions.
- Code overhaul and cleanup done by xruptor.

### Deutsch
- Aktualisierung der Statistiken mit der neuesten Version von Giseldah, V 2.5.5.
- Hinzufügen von 5 neuen Rufwerten.
- Aktualisierung des maximalen Levels auf 160.
- Aktualisierung der verfügbaren Servernamen.
- Aktualisierung des Tier 16 der Berufe.
- Code-Überarbeitung und Bereinigung durchgeführt von xruptor.

---

## V4.53

### Français
- Mise à jour des statistiques avec la dernière version de Giseldah, V 2.5.5.
- Ajout de 5 nouvelles réputations.
- Mise à jour du niveau max à 160.
- Mise à jour des noms des serveurs disponibles.
- Mise à jour du Tier 16 des professions.
- Mise à jour des vocations (qui n'existent plus), avec travail en cours pour l'ajout des professions.

### English
- Updating statistics with the latest version of Giseldah, V 2.5.5.
- Added 5 new reputations.
- Updated max level to 160.
- Updated available server names.
- Updated Tier 16 professions.
- Updated vocations (which no longer exist), with work in progress for adding professions.

### Deutsch
- Aktualisierung der Statistiken mit der neuesten Version von Giseldah, V 2.5.5.
- Hinzufügen von 5 neuen Rufwerten.
- Aktualisierung des Maximallevels auf 160.
- Aktualisierung der verfügbaren Servernamen.
- Aktualisierung des Tiers 16 der Berufe.
- Aktualisierung der Berufe (die es nicht mehr gibt), Arbeit läuft für das Hinzufügen der Berufe.

---

## V4.52

### Français
- Correction d'un bug dans la fenêtre des statistiques.
- Correction d'un bug dans la fenêtre de l'UI principale.
- Correction d'un bug dans la fenêtre de l'affichage du cash.
- Correction d'un bug dans la fonction de calcul du cash.
- Correction d'un bug dans les réputations.
- Correction d'un bug dans les vocations qui n'existent plus.
- Correction d'un bug dans l'affichage du sac à dos avec modification de l'option pour l'afficher aléatoirement ou non.

### English
- Fixed a bug in the statistics window.
- Fixed a bug in the main UI window.
- Fixed a bug in the cash display window.
- Fixed a bug in the cash calculation function.
- Fixed a bug in reputations.
- Fixed a bug in vocations that no longer exist.
- Fixed a bug in the backpack display with an option to show it randomly or not.

### Deutsch
- Ein Bug im Statistikfenster behoben.
- Ein Bug im Haupt-UI-Fenster behoben.
- Ein Bug im Cash-Anzeigefenster behoben.
- Ein Bug in der Cash-Berechnungsfunktion behoben.
- Ein Bug bei den Reputation behoben.
- Ein Bug bei den nicht mehr existierenden Berufen behoben.
- Ein Bug bei der Darstellung des Rucksacks behoben mit der Anpassung der Option, um ihn zufällig anzuzeigen oder nicht.

---

## V4.49

### Français
- Correction d'un bug dans la fenêtre des statistiques.
- Changement du texte de la fenêtre des statistiques en allemand pour une meilleure compréhension.
- Changement de la police du texte de la fenêtre des statistiques en allemand pour une meilleure lisibilité.
- Merci à Farothhen pour son travail sur l’allemand.

### English
- Fixed a bug in the stats window.
- Changed the text of the statistics window to German for better comprehension.
- Changed the text of the statistics window to German for better readability.
- Thanks to Farothhen for his work on German.

### Deutsch
- Ein Fehler im Statistikfenster wurde behoben.
- Der Text des Statistikfensters wurde zum besseren Verständnis auf Deutsch umgestellt.
- Der Text des Statistikfensters wurde zur besseren Lesbarkeit auf Deutsch geändert.
- Danke an Farothhen für seine Arbeit an der deutschen.

---

## V4.48

### Français
- Correction d'un bug qui n’affichait plus l’argent de session correctement.

### English
- Fixed a bug that caused session money to no longer display correctly.

### Deutsch
- Es wurde ein Fehler behoben, der dazu führte, dass das Sitzungsgeld nicht mehr korrekt angezeigt wurde.

---

## V4.47

### Français
- Mise à jour de la version allemande, merci à Farothhen pour son travail.

### English
- Update of the German version, thanks to Farothhen for his work.

### Deutsch
- Aktualisierung der deutschen Version, Dank an Farothhen für seine Arbeit.

---

## V4.46

### Français
- Rajout de la réputation des citoyens de Umbar barhabel.

### English
- Added the reputation of the citizens of Umbar barhabel.

### Deutsch
- Der Ruf der Einwohner von Umbar barhabel wurde hinzugefügt.

---

## V4.45

### Français
- Mise à jour de la version allemande, merci à Farothhen pour son travail.

### English
- Update of the German version, thanks to Farothhen for his work.

### Deutsch
- Aktualisierung der deutschen Version, Dank an Farothhen für seine Arbeit.

---

## V4.44

### Français
- Correction de l’affichage de l’icône du plugin au-dessus du nom du premier personnage.
- Correction du grand espace à gauche / à l’icône suivante si le portefeuille était affiché.
- Correction : plus aucune icône ne chevauche le nom du joueur.
- Ajout d’infobulles supplémentaires.

### English
- Corrected the plugin icon being displayed on top of the first character name.
- Corrected the big gap to the left / to the next icon if the wallet was displayed.
- Fixed: no more icons overlapping the player name.
- Added some more tooltips.

### Deutsch
- Korrigiert: Das Plugin-Symbol wird über dem Namen des ersten Charakters angezeigt.
- Die große Lücke nach links / zum nächsten Symbol wurde korrigiert, wenn die Brieftasche angezeigt wurde.
- Korrigiert: Symbole überlappen den Spielernamen nicht mehr.
- Einige weitere Tooltips hinzugefügt.

---

## V4.43

### Français
- Correction d'un bug lors de la première connexion avec un nouveau personnage.
- Correction d'un problème d'affichage de la fenêtre du cash.
- Correction d'un problème d'affichage de la fenêtre des statistiques.
- Correction d'un bug d'affichage de la fenêtre des réputations.

### English
- Fix a bug when logging in with a new character for the first time.
- Fix a problem with the display of the cash window.
- Fix an issue with the display of the statistics window.
- Fix a bug in the display of the reputation window.

### Deutsch
- Behebung eines Fehlers beim ersten Einloggen mit einem neuen Charakter.
- Behebung eines Problems mit der Anzeige des Kassenfensters.
- Behebung eines Problems mit der Anzeige des Statistikfensters.
- Behebung eines Fehlers in der Anzeige des Reputationsfensters.

---

## V4.42

### Français
- Correction d'une faute d'orthographe.

### English
- Correct a spelling mistake.

### Deutsch
- Korrigieren Sie einen Rechtschreibfehler.

---

## V4.41

### Français
- Ajout d'une option “no vocation” si vous n'en choisissez pas.

### English
- Adding a “no vocation” option if you don't choose one.

### Deutsch
- Hinzufügen einer Option „Keine Berufung“, wenn Sie keine auswählen.

---

## V4.40

### Français
- Correction d'une faute de frappe.
- Optimisation du code.

### English
- Fixed a typo.
- Code optimization.

### Deutsch
- Ein Tippfehler wurde behoben.
- Code-Optimierung.

---

## V4.39

### Français
- Correction d'une faute de frappe.

### English
- Fixed a typo.

### Deutsch
- Ein Tippfehler wurde behoben.

---

## V4.38

### Français
- Utilise la dernière version de CalcStat 2.3.1 de Giseldah.

### English
- Uses the latest version of Giseldah CalcStat 2.3.1.

### Deutsch
- Verwendet die neueste Version von Giseldah CalcStat 2.3.1.

---

## V4.37

### Français
- Correction des fautes d'orthographe dans la version anglaise et allemande.

### English
- Corrected spelling errors in the English and German version.

### Deutsch
- Rechtschreibfehler in der englischen und deutschen Version korrigiert.

---

## V4.36

### Français
- Ajout de parenthèses autour du bonus de réputation.

### English
- Add parentheses around reputation bonus.

### Deutsch
- Setzen Sie Klammern um den Reputationsbonus.

---

## V4.35

### Français
- Correction d'un bug qui affichait une erreur si une réputation non définie recevait des points.

### English
- Fixed a bug that caused an error to display if an undefined reputation received points.

### Deutsch
- Es wurde ein Fehler behoben, der dazu führte, dass ein Fehler angezeigt wurde, wenn eine undefinierte Reputation Punkte erhielt.

---

## V4.34

### Français
- Correction d'un bug qui ne sauvegardait pas correctement la vocation choisie.
- Correction d'un bug qui continuait d’afficher le gain de réputation bonus, une fois terminé.

### English
- Fixed a bug that didn't correctly save the chosen vocation.
- Fixed a bug that kept showing the bonus reputation gain when completed.

### Deutsch
- Es wurde ein Fehler behoben, durch den der gewählte Beruf nicht korrekt gespeichert wurde.
- Es wurde ein Fehler behoben, durch den der Bonus-Rufgewinn weiterhin angezeigt wurde, wenn er abgeschlossen war.

---

## V4.33

### Français
- Correction d'un bug qui empêchait le plugin de se charger correctement.

### English
- Fixed a bug that prevented the plugin from loading properly.

### Deutsch
- Es wurde ein Fehler behoben, der verhinderte, dass das Plugin richtig geladen wurde.

---

## V4.32

### Français
- Correction d'un bug : la vocation choisie ne se chargeait pas correctement dans la fenêtre d'option.

### English
- Fixed a bug where the chosen vocation did not correctly load in the option window.

### Deutsch
- Behebung eines Fehlers, der dazu führte, dass der ausgewählte Beruf nicht korrekt im Optionsfenster geladen wurde.

---

## V4.31

### Français
- Ajout de fenêtres d'aide pour définir le genre et la vocation de votre personnage.
- Correction de fautes d'orthographe dans la version allemande.

### English
- Addition of help windows for defining the gender and vocation of your character.
- Fixed spelling errors in the German version.

### Deutsch
- Hinzufügung von Hilfefenstern zum Definieren des Geschlechts und der Berufung Ihres Charakters.
- Rechtschreibfehler in der deutschen Version behoben.

---

## V4.30

### Français
- Ajout de nouvelles réputations.
- Correction d’un bug de lecture du chat qui ne mettait pas à jour les réputations correctement.

### English
- Added new reputations.
- Fixed a chat reading bug that did not update reputations correctly.

### Deutsch
- Neuer Ruf hinzugefügt.
- Es wurde ein Fehler beim Chat-Lesen behoben, der dazu führte, dass der Ruf nicht korrekt aktualisiert wurde.

---

## V4.29

### Français
- Ajout d'une option pour définir la vocation courante.

### English
- Added an option to set the current vocation.

### Deutsch
- Es wurde eine Option hinzugefügt, um die aktuelle Berufung festzulegen.

---

## V4.28

### Français
- Modification du niveau maximum au niveau 150.
- Ajout de la dernière version de CalcStat v2.3 de Giseldah.

### English
- Changed the level cap to level 150.
- Added the latest version of Giseldah CalcStat v2.3.

### Deutsch
- Die Stufenobergrenze wurde auf Stufe 150 geändert.
- Die neueste Version von Giseldah CalcStat v2.3 wurde hinzugefügt.

---

## V4.27

### Français
- Ajout de la nouvelle classe : le Marin.

### English
- Added the new class: the Mariner.

### Deutsch
- Die neue Klasse, der Mariner, wurde hinzugefügt.

---

## V4.26

### Français
- Utilise la dernière version de CalcStat 2.2.3 de Giseldah.

### English
- Uses the latest version of Giseldah CalcStat 2.2.3.

### Deutsch
- Verwendet die neueste Version von Giseldah CalcStat 2.2.3.

---

## V4.25

### Français
- Utilise la dernière version de CalcStat 2.2.2 de Giseldah.

### English
- Uses the latest version of Giseldah CalcStat 2.2.2.

### Deutsch
- Verwendet die neueste Version von Giseldah CalcStat 2.2.2.

---

## V4.24

### Français
- Correction d’un bug dans l’affichage de la nouvelle réputation.

### English
- Fix a bug in the display of the new reputation.

### Deutsch
- Behebung eines Fehlers in der Anzeige der neuen Reputation.

---

## V4.23

### Français
- Utilise la dernière version de CalcStat 2.2 de Giseldah.

### English
- Uses the latest version of Giseldah CalcStat 2.2.

### Deutsch
- Verwendet die neueste Version von Giseldah CalcStat 2.2.

---

## V4.22

### Français
- Rajout de la nouvelle race : les Hobbits des rivières.

### English
- Added the new race: the River Hobbit.

### Deutsch
- Die neue Rasse Flusshobbit wurde hinzugefügt.

---

## V4.21

### Français
- Correction d’un bug dans l’affichage de la nouvelle réputation.

### English
- Fix a bug in the display of the new reputation.

### Deutsch
- Behebung eines Fehlers in der Anzeige der neuen Reputation.

---

## V4.20

### Français
- Rajout de la nouvelle réputation de la version U36 : Les voies de la bravoure.

### English
- Added the new reputation of the U36 version: The Paths of Valour.

### Deutsch
- Der neue Ruf der U36-Version wurde hinzugefügt: Die Pfade der Tapferkeit.

---

## V4.19

### Français
- Utilise la dernière version du calcstat 2.1.3 de Giseldah.

### English
- Uses the latest version of the Giseldah calcstat 2.1.3.

### Deutsch
- Verwendet die neueste Version von Giseldah Calcstat 2.1.3.

---

## V4.18

### Français
- Utilise la dernière version du calcstat de Giseldah.

### English
- Uses the latest version of the Giseldah calcstat.

### Deutsch
- Verwendet die neueste Version von Giseldah Calcstat.

---

## V4.17

### Français
- Modification d'une fonction de séparation de string dans la fonction Split.

### English
- Modification of a string separation function in the Split function.

### Deutsch
- Modifikation einer String-Trennfunktion in der Split-Funktion.

---

## V4.16

### Français
- Modification du positionnement de la fenêtre d'affichage des professions, elle s'adapte à la position de l'addon sur l'écran.

### English
- Modification of the position of the display window of professions, it adapts to the position of the addon on the screen.

### Deutsch
- Änderung der Position des Anzeigefensters von Berufen, es passt sich der Position des Addons auf dem Bildschirm an.

---

## V4.15

### Français
- Modification du positionnement de la fenêtre d'affichage des professions.

### English
- Modification of the positioning of the display window of professions.

### Deutsch
- Anpassung der Positionierung des Anzeigefensters der Berufe.

---

## V4.14

### Français
- Utilise la dernière version du calcstat de Giseldah.

### English
- Uses the latest version of the Giseldah calcstat.

### Deutsch
- Verwendet die neueste Version von Giseldah Calcstat.

---

## V4.13

### Français
- Correction d'un bug de mise à jour de l'expérience et du gain de réputation.

### English
- Fix a bug with updating experience and gaining reputation.

### Deutsch
- Beheben Sie einen Fehler, indem Sie Erfahrung aktualisieren und an Reputation gewinnen.

---

## V4.12

### Français
- Rajout de 6 réputations.

### English
- Add 6 reputations.

### Deutsch
- Füge 6 Rufe hinzu.

---

## V4.11

### Français
- Déplacement de la fenêtre pop-up des professions pour les petites résolutions.

### English
- Move the pop-up window of professions for small resolutions.

### Deutsch
- Bewegen Sie das Popup-Fenster der Berufe für kleine Auflösungen.

---

## V4.10

### Français
- Corrections de bugs.
- Optimisation du code.

### English
- Bug fixes.
- Code optimization.

### Deutsch
- Fehlerbehebungen.
- Codeoptimierung.

---

## V4.09

### Français
- Correction d'un bug qui empêchait l'affichage correct du nom de Tolkien.

### English
- Fixed a bug that prevented Tolkien's name from displaying correctly.

### Deutsch
- Es wurde ein Fehler behoben, der verhinderte, dass Tolkiens Name korrekt angezeigt wurde.

---

## V4.08

### Français
- Correction d'un bug qui empêchait l'affichage de la fenêtre d'aide.

### English
- Fixed a bug that cluttered the display of the help window.

### Deutsch
- Es wurde ein Fehler behoben, der die Anzeige des Hilfefensters überladen hat.

---

## V4.07

### Français
- Corrections de bugs.
- Optimisation du code.

### English
- Bug fixes.
- Code optimization.

### Deutsch
- Fehlerbehebungen.
- Code-Optimierung.

---

## V4.06

### Français
- Corrections de bugs.
- Optimisation du code.

### English
- Bug fixes.
- Code optimization.

### Deutsch
- Fehlerbehebungen.
- Code-Optimierung.

---

## V4.05

### Français
- Correction d'un bug d'affichage de la barre lors du changement d'options.

### English
- Fixed bar display bug when changing options.

### Deutsch
- Fehler bei der Balkenanzeige beim Ändern von Optionen behoben.

---

## V4.04

### Français
- Correction d'un bug d'affichage des fenêtres depuis la barre.

### English
- Fixed a window display bug from the bar.

### Deutsch
- Ein Fehler bei der Fensteranzeige in der Leiste wurde behoben.

---

## V4.03

### Français
- Corrections de bugs.
- Optimisation du code.

### English
- Bug fixes.
- Code optimization.

### Deutsch
- Fehlerbehebungen.
- Code-Optimierung.

---

## V4.02

### Français
- Corrections de bugs.
- Optimisation du code.

### English
- Bug fixes.
- Code optimization.

### Deutsch
- Fehlerbehebungen.
- Code-Optimierung.

---

## V4.01

### Français
- Mise à jour de l'auto update de la bar AltHolic.

### English
- AltHolic Bar Auto Update Update.

### Deutsch
- Automatische Aktualisierung der AltHolic-Leiste.

---

## V4.0

### Français
- Réécriture de la gestion des fenêtres lors de l'appui sur F12.
- Diverses corrections de bugs.
- Quelques optimisations de code.

### English
- Rewrite of window management when pressing F12.
- Various bug fixes.
- Some code optimization.

### Deutsch
- Umschreiben der Fensterverwaltung beim Drücken von F12.
- Diverse Fehlerbehebungen.
- Etwas Code-Optimierung.

---

## V3.23 - V3.24

### Français
- Rajout d'une explication dans le fichier init pour sauvegarder uniquement par serveur.

### English
- Added an explanation in the init file to save only by server.

### Deutsch
- Eine Erklärung in der Init-Datei hinzugefügt, um nur vom Server zu speichern.

---

## V3.22

### Français
- Diverses corrections de bugs.

### English
- Various bug fixes.

### Deutsch
- Diverse Fehlerbehebungen.

---

## V3.21

### Français
- Diverses corrections de bugs.

### English
- Various bug fixes.

### Deutsch
- Diverse Fehlerbehebungen.

---

## V3.20

### Français
- Rajout d'une option pour afficher la taille du sac dans la barre.

### English
- Added an option to display the size of the bag in the bar.

### Deutsch
- Option zur Anzeige der Taschengröße in der Leiste hinzugefügt.

---

## V3.19

### Français
- Diverses corrections de bugs.

### English
- Various bug fixes.

### Deutsch
- Diverse Fehlerbehebungen.

---

## V3.18

### Français
- Optimisation de la fenêtre de recherche, pour un résultat de recherche plus rapide.

### English
- Optimization of the search window, for a faster search result.

### Deutsch
- Optimierung des Suchfensters, für ein schnelleres Suchergebnis.

---

## V3.17

### Français
- Rajout d'une option pour fermer la fenêtre serveur avec double clic sur l'icône.
- Correction d'un bug d'affichage du texte dans la fenêtre d'option de la barre.

### English
- Addition of an option to close the server window with double click on the icon.
- Fixed a text display bug in the toolbar option window.

### Deutsch
- Hinzufügen einer Option zum Schließen des Serverfensters mit Doppelklick auf das Symbol.
- Fehler bei der Textanzeige im Optionsfenster der Symbolleiste behoben.

---

## V3.16

### Français
- Correction d'un bug dans le fichier de FCT.

### English
- Fixed a bug in the FCT file.

### Deutsch
- Fehler in der FCT-Datei behoben.

---

## V3.15

### Français
- Diverses corrections de bugs.

### English
- Various bugs fixes.

### Deutsch
- Diverse Fehlerbehebungen.

---

## V3.14

### Français
- Rajout d'une fenêtre pour afficher l'expérience des autres personnages.

### English
- Addition of a window to display the experience of other characters.

### Deutsch
- Hinzufügen eines Fensters, um die Erfahrung anderer Charaktere anzuzeigen.

---

## V3.13

### Français
- Correction d'un bogue dans la gestion de la réputation dans la fenêtre de réputation.
- Correction de bogues.
- Ajustement de la barre de défilement dans la fenêtre des livres épiques.

### English
- Fixed a bug in reputation management in the reputation window.
- Bug fixes.
- Adjusted the scroll bar in the Epic Books window.

### Deutsch
- Fehler im Reputationsmanagement im Reputationsfenster behoben.
- Fehlerbehebung.
- Bildlaufleiste im Fenster Epic Books angepasst.

---

## V3.12

### Français
- Correction d'un bogue dans la gestion de la réputation dans la fenêtre de réputation.

### English
- Fixed a bug in reputation management in the reputation window.

### Deutsch
- Fehler im Reputationsmanagement im Reputationsfenster behoben.

---

## V3.11

### Français
- Supprimer le sensible à la casse dans la recherche.
- Rajout d'une barre de défilement dans la fenêtre du stockage partagé.

### English
- Remove case sensitive from search.
- Addition of a scroll bar in the shared storage window.

### Deutsch
- Groß-/Kleinschreibung aus der Suche entfernen.
- Hinzufügen einer Bildlaufleiste im Shared Storage-Fenster.

---

## V3.10

### Français
- Quelques corrections de bogues sur la barre.

### English
- Some bugs fixes on the bar.

### Deutsch
- Einige Fehlerbehebungen in der Leiste.

---

## V3.09

### Français
- Quelques corrections de bogues.

### English
- Some bugs fixes.

### Deutsch
- Einige Fehlerbehebungen.

---

## V3.08

### Français
- Quelques corrections de bogues.

### English
- Some bugs fixes.

### Deutsch
- Einige Fehlerbehebungen.

---

## V3.07

### Français
- Quelques corrections de bogues.

### English
- Some bugs fixes.

### Deutsch
- Einige Fehlerbehebungen.

---

## V3.06

### Français
- Quelques corrections de bogues.

### English
- Some bugs fixes.

### Deutsch
- Einige Fehlerbehebungen.

---

## V3.05

### Français
- Correction d'un problème d'affichage de la barre.

### English
- Fixed a bar display problem.

### Deutsch
- Problem mit der Balkenanzeige behoben.

---

## V3.04

### Français
- Correction d'un bug dans le fichier de FCT.

### English
- Fixed a bug in the FCT file.

### Deutsch
- Fehler in der FCT-Datei behoben.

---

## V3.03

### Français
- Correction d'un problème d'affichage avec la nouvelle barre.

### English
- Fixed a display issue with the new bar.

### Deutsch
- Anzeigeproblem mit der neuen Leiste behoben.

---

## V3.02

### Français
- Quelques corrections de bogues.

### English
- Some bugs fixes.

### Deutsch
- Einige Fehlerbehebungen.

---

## V3.01

### Français
- Correction d'un bogue de gestion de la touche F12.

### English
- Fix a bug in handling the F12 key.

### Deutsch
- Behebung eines Fehlers bei der Handhabung der F12-Taste.

---

## V3.0

### Français
- Rajout d'une barre affichable dans les options au sommet de l'écran.
- Quelques corrections de bogues.

### English
- Addition of a displayable bar in the options at the top of the screen.
- Some bugs fixes.

### Deutsch
- Hinzufügen einer anzeigbaren Leiste in den Optionen am oberen Bildschirmrand.
- Einige Fehlerbehebungen.

---

## V2.73

### Français
- Correction d'un bogue de gestion de la touche F12 pour cacher entièrement le HUD.

### English
- Fix a bug in the handling of the F12 key to completely hide the HUD.

### Deutsch
- Behebung eines Fehlers bei der Handhabung der F12-Taste, um das HUD vollständig auszublenden.

---

## V2.72

### Français
- Correction d'un bogue d'affichage pour les noms de joueur très longs.

### English
- Fix a display bug for very long player names.

### Deutsch
- Behebung eines Anzeigefehers für sehr lange Spielernamen.

---

## V2.71

### Français
- Rajout d'une fenêtre de validation pour ne pas effacer un personnage par accident.

### English
- Addition of a validation window to not delete a character by accident.

### Deutsch
- Hinzufügen eines Validierungsfensters, um ein Zeichen nicht versehentlich zu löschen.

---

## V2.70

### Français
- Rajout d'une option pour afficher une icône de suppression de personnage.

### English
- Addition of an option to display a character deletion icon.

### Deutsch
- Hinzufügen einer Option zum Anzeigen eines Symbols zum Löschen von Zeichen.

---

## V2.69

### Français
- Correction d'un bogue dans la fenêtre des livres épiques.

### English
- Fix a bug in the Epic Books window.

### Deutsch
- Behebung eines Fehlers im Fenster von Epic Books.

---

## V2.68

### Français
- Mise à jour des statistiques utilisant CalcStat, la dernière version 1.8.0 de Giseldah.

### English
- Update statistics using CalcStat, the last version 1.8.0 of Giseldah.

### Deutsch
- Aktualisieren Sie die Statistiken mit CalcStat, die letzte Version 1.8.0 von Giseldah.

---

## V2.67

### Français
- Correction d'une erreur d'affichage dans la fenêtre d'argent.
- Correction d'une erreur d'affichage dans la fenêtre des quêtes épiques.
- Correction d'une erreur d'affichage de l'argent possédé par le joueur.
- Correction de la taille des fenêtres qui ne s'ajustait pas correctement au nombre de personnages.
- Correction d'une erreur d'affichage du bouton des quêtes épiques.
- Correction d'une erreur d'affichage du bouton de recherche.

### English
- Correct a display error in the money window.
- Correct a display error in the epic quest window.
- Correct an error in displaying the money owned by the player.
- Correct the window size that did not fit correctly to the number of characters.
- Correct an error in the display of the epic quest buttons.
- Correct a search button display error.

### Deutsch
- Korrigieren Sie einen Anzeigefehler im Geldfenster.
- Korrigiere einen Anzeigefehler im epischen Questfenster.
- Korrigieren Sie einen Fehler bei der Anzeige des Geldes des Spielers.
- Korrigieren Sie die Fenstergröße, die nicht richtig auf die Anzahl der Zeichen passte.
- Korrigiere einen Fehler in der Anzeige der epischen Quest-Buttons.
- Korrigieren Sie einen Anzeigefehler der Suchschaltfläche.

---

## V2.66

### Français
- Rajout d'une option pour afficher les différents serveurs.
- Permet de trier l'affichage par serveur.

### English
- Addition of an option to display the different servers.
- Allows you to sort the display by server.

### Deutsch
- Hinzufügen einer Option zur Anzeige der verschiedenen Server.
- Ermöglicht die Sortierung der Anzeige nach Server.

---

## V2.65

### Français
- Corrections de bugs.

### English
- Bug fixes.

### Deutsch
- Fehlerbehebung.

---

## V2.64

### Français
- Mise à jour des statistiques utilisant CalcStat version de Giseldah.

### English
- Updating statistics using the CalcStat version of Giseldah.

### Deutsch
- Aktualisieren von Statistiken mit dem CalcStat version von Giseldah.

---

## V2.63

### Français
- Mise à jour du niveau maximal à 140.
- Rajout de la nouvelle faction de Gundabad.

### English
- Updated max level to 140.
- Addition of the new faction of Gundabad.

### Deutsch
- Maximales Level auf 140 aktualisiert.
- Aufnahme der neuen Fraktion von Gundabad.

---

## V2.61

### Français
- Rajout de la nouvelle classe le bagarreur.

### English
- Addition of the new class the brawler.

### Deutsch
- Aufnahme der neuen Klasse der Schläger.

---

## V2.60

### Français
- Nettoyage de code et optimisation.

### English
- Code cleaning and optimization.

### Deutsch
- Codebereinigung und -optimierung.

---

## V2.58

### Français
- Mise à jour du niveau de l'addon.
- Correction de bugs mineurs.
- Correction de fautes d'orthographe en Français.

### English
- Update addon level.
- Minor bug fixes.
- Correction of spelling errors in French.

### Deutsch
- Add-on-Level aktualisieren.
- Kleinere Fehlerbehebungen.
- Korrektur von Rechtschreibfehlern in Französisch.

---

## V2.57

### Français
- Modification de la position de la fenêtre d'information des données de personnage.

### English
- Changing the Position of the Character Data Info Window.

### Deutsch
- Ändern der Position des Zeichendaten-Infofensters.

---

## V2.56

### Français
- Correction d'un bug d'affichage de la fenêtre de profession si beaucoup de personnages.
- Définition d'un timer pour la sauvegarde du sac à dos et du stockage partagé.
- Rajout d'un contrôle de sauvegarde uniquement si pas en combat.

### English
- Fixed a display bug in the profession window if a lot of characters.
- Definition of a timer for backing up the backpack and shared storage.
- Addition of a save control only if not in combat.

### Deutsch
- Anzeigefehler im Berufsfenster behoben, wenn viele Charaktere.
- Definition eines Timers zum Sichern des Rucksacks und gemeinsamen Speichers.
- Hinzufügen einer Speicherkontrolle nur, wenn nicht im Kampf.

---

## V2.54

### Français
- Correction d'un bug d'affichage si la résolution d'écran est trop petite pour la fenêtre du stockage partagé et pour la fenêtre des livres épiques.

### English
- Fixed a display bug if the screen resolution is too small for the shared storage window and for the epic books window.

### Deutsch
- Anzeigefehler bei zu kleiner Bildschirmauflösung behoben für das gemeinsame Speicherfenster und für das epische Bücherfenster.

---

## V2.53

### Français
- Correction d'un bug avec les réputations.

### English
- Fixed a bug with reputations.

### Deutsch
- Fehler mit Reputationen behoben.

---

## V2.52

### Français
- Nettoyage et optimisation du code.

### English
- Code cleaning and optimization.

### Deutsch
- Codebereinigung und -optimierung.

---

## V2.51

### Français
- Correction d'un bug dans les réputations qui commence par étranger.

### English
- Fix a bug in reputations that starts with foreigner.

### Deutsch
- Reputationsfehler behoben, der mit Ausländer beginnt.

---

## V2.50

### Français
- Correction d'une erreur de texte dans les nouvelles réputations en français.
- Redimensionnement automatique de certaines fenêtres si la résolution d'écran est plus petite.

### English
- Correct a text error in the new French reputation.
- Automatically resizes some windows if the screen resolution is smaller.

### Deutsch
- Korrigieren Sie einen Textfehler im neuen französischen Ruf.
- Ändert automatisch die Größe einiger Fenster, wenn die Bildschirmauflösung kleiner ist.

---

## V2.49

### Français
- Rajout des nouvelles réputations de l'update 30.

### English
- Addition of the new reputation of Update 30.

### Deutsch
- Hinzufügen des neuen Rufs von Update 30.

---

## V2.48

### Français
- Nettoyage et optimisation du code.

### English
- Code cleaning and optimization.

### Deutsch
- Codebereinigung und -optimierung.

---

## V2.47

### Français
- Nettoyage et optimisation du code.

### English
- Code cleaning and optimization.

### Deutsch
- Codebereinigung und -optimierung.

---

## V2.46

### Français
- Correction d'un bug qui ne sauvegardait pas correctement l'emplacement de l'icône principale.
- Correction de bugs mineurs.

### English
- Fixed a bug that did not correctly save the location of the main icon.
- Fixed minor bugs.

### Deutsch
- Es wurde ein Fehler behoben, der die Position des Hauptsymbols nicht korrekt speicherte.
- Kleinere Fehler behoben.

---

## V2.45

### Français
- Changement cosmétique et mise à jour de bugs mineurs.

### English
- Cosmetic change and minor bug update.

### Deutsch
- Kosmetische Veränderung und kleines Bug Update.

---

## V2.44

### Français
- Rajout d'une option pour changer l'affichage du niveau lorsqu'on est niveau maximum.
- Réorganisation de la fenêtre d'options.

### English
- Addition of an option to change the level display when you are at maximum level.
- Reorganization of the options window.

### Deutsch
- Hinzufügen einer Option zum Ändern der Pegelanzeige, wenn Sie sich auf maximaler Ebene befinden.
- Neuorganisation des Optionsfensters.

---

## V2.43

### Français
- Correction de la position de l'icône qui ne sauvegardait pas l'emplacement correctement.

### English
- Correct the position of the icon that did not save the location correctly.

### Deutsch
- Korrigieren Sie die Position des Symbols, das den Speicherort nicht korrekt gespeichert hat.

---

Note: le fichier historique contient encore d'autres versions antérieures non réécrites dans cette passe de normalisation, mais la structure a été uniformisée selon le schéma suivant :
- Version
- Français
- English
- Deutsch
