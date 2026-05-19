# Birdle 🐦 - Flutter Basics

Ein Wordle-Klon, entwickelt als erstes Praxisprojekt zur systematischen Einarbeitung in Dart und das Flutter-Framework. 

Das primäre Ziel dieses Repositories war das praktische Verstehen der Flutter-Kernarchitektur, um ein solides Fundament für kommende, komplexere App-Projekte zu legen.

## 🚀 Kernkompetenzen & Learnings

Während der Entwicklung dieses Projekts habe ich folgende Konzepte in Flutter angewendet:

* **Architektur & Custom Widgets:** Aufbau dynamischer Layouts und Raster. Fokus auf "Separation of Concerns" durch die saubere Trennung von visuellen Bausteinen (UI) und der reinen Business-Logik (`game.dart`).
* **State Management:** Verwaltung des App-Zustands und das gezielte Auslösen von UI-Updates mittels `setState`, basierend auf verarbeiteten Benutzereingaben.
* **Animationen (Implicit Animations):** Umsetzung flüssiger UI-Übergänge ohne komplexe manuelle Animationsverwaltung.
  * Austausch statischer `Container` durch `AnimatedContainer`.
  * Feintuning der Animationen durch Parameter wie `duration` (für das Timing) und `curve` (Nutzung verschiedener Animationskurven wie `Curves.bounceIn` oder `Curves.decelerate` für Feedback).

## 🛠 Tech-Stack
* **Sprache:** Dart
* **Framework:** Flutter SDK

## 💻 Lokales Ausführen

Um das Projekt lokal in einem Browser zu testen, clone das Repository und führe folgenden Befehl im Terminal aus:

```bash
flutter run