# Fruit Drop Game

## Project Setup
- **Framework**: Flutter + Flame engine + Forge2D physics
- **Flutter SDK**: Installed at `C:/flutter` (must use full path `C:/flutter/bin/flutter.bat`)
- **Dependencies**: `flame`, `flame_forge2d` (see pubspec.yaml)

## Common Commands
```bash
# Analyze for errors
"C:/flutter/bin/flutter.bat" analyze

# Run on Chrome (web)
"C:/flutter/bin/flutter.bat" run -d chrome

# Build for web
"C:/flutter/bin/flutter.bat" build web
```

## Architecture
- `lib/main.dart` — App entry point with GameWidget and overlay registration
- `lib/game/fruit_drop_game.dart` — `FruitDropGame` (Forge2DGame) and `FruitDropWorld` (Forge2DWorld)
- `lib/game/data/fruit_type.dart` — Fruit hierarchy enum (berry → raspberry → orange → apple → coconut → watermelon)
- `lib/game/components/` — Physics bodies: `FruitBody`, `ContainerWall`, `GameOverLine`, `ExplosionEffect`
- `lib/game/managers/` — `SpawnManager` (drop mechanic), `MergeManager` (merge + explosion), `ScoreManager`
- `lib/game/painters/fruit_painter.dart` — Canvas-based cartoon fruit rendering (no external assets)
- `lib/game/overlays/` — Flutter widget overlays for HUD and game-over screen

## Key Patterns
- Bodies cannot be created/destroyed inside Forge2D contact callbacks — `MergeManager` defers all mutations to `update()`
- `FruitBody.pendingRemoval` flag prevents double-enqueue of merges
- Managers are accessed via `FruitDropWorld` fields, game reference found via `parent` traversal
- `PanDetector` mixin handles all touch input (not TapDetector — they conflict)

## Workflow Rules
- **Always commit and push after making changes** — use the remote at origin
- Run `flutter analyze` before committing to catch errors
- **Keep README.md up to date** — when adding features, changing gameplay mechanics, or modifying project structure, update README.md to reflect the changes
