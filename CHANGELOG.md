# Changelog

## V5.8.1 - Cleanup, stability and collections

### French
- Ajout de deux nouvelles fenêtres : Montures et Familiers, accessibles depuis les boutons de la fenêtre principale
- Ces fenêtres listent par ordre alphabétique toutes les montures et tous les familiers connus de vos personnages, avec l'icône, le nom et le personnage qui les possède
- Nettoyage des points de rupture dans la persistance des données personnages
- Correction des structures manquantes lors du chargement des professions, réputations et quêtes épiques
- Optimisation des sauvegardes en supprimant les chemins de données inutiles ou fragiles
- Renforcement de la robustesse du chargement des données utilisateur

### English
- Added two new windows: Mounts and Pets, opened from the buttons in the main window
- These windows list, in alphabetical order, every mount and pet known to your characters, with its icon, name and owning character
- Cleaned up fragile persistence paths for character data
- Fixed missing-table issues when loading professions, reputations, and epic entries
- Optimized saves by avoiding unnecessary or unsafe data rewrites
- Hardened the plugin against missing or partially initialized data on load

### Deutsch
- Zwei neue Fenster hinzugefügt: Reittiere und Haustiere, erreichbar über die Schaltflächen im Hauptfenster
- Diese Fenster listen alphabetisch alle Reittiere und Haustiere deiner Charaktere auf, mit Symbol, Name und besitzendem Charakter
- Bereinigung fragiler Persistenzpfade für Charakterdaten
- Fehler bei fehlenden Tabellen beim Laden von Berufen, Ruf und epischen Einträgen behoben
- Speicherung optimiert, indem unnötige oder unsichere Neuschreibungen von Daten vermieden werden
- Robusteres Laden bei fehlenden oder teilweise initialisierten Daten
  
## V5.07 - Cleanup and stability pass

### French
- Version de plugin mise à jour vers 5.07 pour la branche Testing
- Nettoyage des points de rupture dans la persistance des données personnages
- Correction des structures manquantes lors du chargement des professions, réputations et quêtes épiques
- Optimisation des sauvegardes en supprimant les chemins de données inutiles ou fragiles
- Renforcement de la robustesse du chargement des données utilisateur

### English
- Updated the plugin version to 5.07 for the Testing branch
- Cleaned up fragile persistence paths for character data
- Fixed missing-table issues when loading professions, reputations, and epic entries
- Optimized saves by avoiding unnecessary or unsafe data rewrites
- Hardened the plugin against missing or partially initialized data on load

### Deutsch
- Plugin-Version auf 5.07 für den Testing-Branch aktualisiert
- Bereinigung fragiler Persistenzpfade für Zeichendaten
- Fehler bei fehlenden Tabellen beim Laden von Berufen, Ruf und epischen Einträgen behoben
- Speicherung optimiert, indem unnötige oder unsichere Datums-Neu-Schreibungen vermieden werden
- Robusteres Laden bei fehlenden oder teilweise initialisierten Daten

---

## V5.06 - Major refactor and stability update

### French
- Refactor majeur du code par xruptor
- Consolidation de la logique de persistance et de chargement
- Nettoyage des fenêtres et des helpers partagés
- Correction des erreurs liées aux sauvegardes et aux données per-character
- Amélioration de la cohérence des structures de données sauvegardées
- Ajustements de compatibilité et de robustesse du plugin

### English
- Major code refactor carried out by xruptor
- Consolidated persistence and loading logic
- Cleaned up shared helpers and UI code paths
- Fixed issues related to saves and per-character data handling
- Improved consistency of saved data structures
- Increased plugin robustness and compatibility

### Deutsch
- Größere Code-Umstrukturierung durch xruptor
- Konsolidierte Persistenz- und Lade-Logik
- Bereinigung gemeinsamer Helfer und UI-Pfade
- Fehler bei Speicherungen und personenbezogenen Daten behoben
- Konsistenz der gespeicherten Datenstrukturen verbessert
- Robustheit und Kompatibilität des Plugins verbessert

---
