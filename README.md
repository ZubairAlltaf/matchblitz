# Icon Match Blitz 🧠⚡

A fast-paced and challenging emoji-matching memory game built with Flutter and the Flame engine. Test your memory and speed by finding all the pairs before the timer runs out!

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🚀 Live Demo

You can play the game live in your browser right now!

[**➡️ Play Icon Match Blitz Here**](https://jade-rolypoly-1efa5c.netlify.app/)

---

## ✨ Features

* **Engaging Gameplay:** A classic pair-matching game that's easy to learn but hard to master.
* **Progressive Difficulty:** The grid size grows and the timer gets shorter as you advance through the levels.
* **Save & Continue:** Your progress is automatically saved, so you can pick up where you left off.
* **Local High Score:** The game saves your all-time high score directly on your device.
* **Clean "Blueprint" UI:** A unique, minimalist aesthetic for a modern and polished feel.
* **Responsive Design:** Playable on any screen size, thanks to Flutter and Flame's responsive layout capabilities.
* **Web & Mobile Ready:** Built with Flutter, this project can be compiled for Web, Android, and iOS from a single codebase.

---

## 🛠️ Tech Stack & Architecture

This project was built with a modern and scalable architecture, separating the UI, game logic, and state management.

* **Framework:** [**Flutter**](https://flutter.dev/)
* **Game Engine:** [**Flame**](https://flame-engine.org/) for the core game loop, rendering, and input handling.
* **State Management:** [**Provider**](https://pub.dev/packages/provider) for managing the global game state (level, score, timer) and decoupling the UI from the game logic.
* **Local Storage:** [**shared\_preferences**](https://pub.dev/packages/shared_preferences) for persisting the high score and saved game progress.
* **Animations & Styling:** Custom UI components with animations powered by [**flutter\_animate**](https://pub.dev/packages/flutter_animate) and styled with [**Google Fonts**](https://pub.dev/packages/google_fonts).

---

## 📦 Getting Started

To run this project locally, follow these steps:

**1. Clone the repository:**
```bash
git clone [https://github.com/ZubairAlltaf/matchblitz.git](https://github.com/ZubairAlltaf/matchblitz.git)
cd matchblitz
```

**2. Get dependencies:**
```bash
flutter pub get
```

**3. Run the app:**
```bash
flutter run
```

---

## 📂 Project Structure

The project is organized into the following main directories:

```
lib
├── game/             # Contains all Flame engine game logic and components
│   ├── components/   # Individual game pieces like the tiles
│   └── icon_match_game.dart
├── models/           # Data models (e.g., TileModel)
├── providers/        # State management (GameStateProvider)
├── screens/          # All Flutter UI screens (MainMenu, GameScreen, etc.)
├── services/         # Helper services ( StorageService)
└── main.dart         # The main entry point of the app
```

---

## 📜 License

This project is licensed under the MIT License open for all the changes and usage -

---

## 👨‍💻 Author

**Zubair Altaf**

* GitHub: [@ZubairAlltaf](https://github.com/ZubairAlltaf)
* LinkedIn: [@muhammad-zubair-215172376](https://www.linkedin.com/in/muhammad-zubair-215172376/)
