# Fruit Drop

A Suika-style fruit merging game built with Flutter, Flame engine, and Forge2D physics. Drop fruit into a container — when two identical fruits collide, they merge into a larger fruit with an explosion that scatters nearby pieces.

## Gameplay

- **Drop** fruit by dragging to position and releasing
- **Merge** two identical fruits to create the next size up
- **Fruit hierarchy**: Berry → Raspberry → Orange → Apple → Coconut → Watermelon
- **Win** by merging two watermelons
- **Game over** if fruits stack above the danger line for too long
- Merging causes an **explosion** that pushes surrounding fruit around, enabling chain reactions

## Screenshots

*Coming soon*

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.41+)

### Install dependencies

```bash
flutter pub get
```

### Run the game

```bash
# Web (Chrome)
flutter run -d chrome

# Android (with device/emulator connected)
flutter run -d android

# iOS (macOS only, with simulator or device)
flutter run -d ios
```

### Build

```bash
# Web
flutter build web

# Android APK
flutter build apk

# iOS (macOS only)
flutter build ios
```

## Tech Stack

- **Flutter** — Cross-platform UI framework
- **Flame** — 2D game engine for Flutter
- **Forge2D** — Box2D physics engine (via flame_forge2d)
- All fruit visuals are rendered with **Canvas** drawing (gradients, paths) — no external image assets

## Project Structure

```
lib/
├── main.dart                          # App entry point
└── game/
    ├── fruit_drop_game.dart           # Game + World orchestration
    ├── data/
    │   └── fruit_type.dart            # Fruit hierarchy definition
    ├── components/
    │   ├── fruit_body.dart            # Physics body for each fruit
    │   ├── container_wall.dart        # Bucket walls
    │   ├── game_over_line.dart        # Overflow detection
    │   └── explosion_effect.dart      # Merge particle animation
    ├── managers/
    │   ├── spawn_manager.dart         # Drop preview + spawning
    │   ├── merge_manager.dart         # Merge logic + explosion force
    │   └── score_manager.dart         # Score tracking
    ├── painters/
    │   └── fruit_painter.dart         # Canvas fruit rendering
    └── overlays/
        ├── hud_overlay.dart           # Score + next fruit display
        └── game_over_overlay.dart     # Win/loss screen
```

## License

This project is for personal/educational use.
