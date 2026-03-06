import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';

import 'components/background_component.dart';
import 'components/bomb_body.dart';
import 'components/container_wall.dart';
import 'components/fruit_body.dart';
import 'components/game_over_line.dart';
import 'data/fruit_type.dart';
import 'managers/merge_manager.dart';
import 'managers/score_manager.dart';
import 'managers/spawn_manager.dart';

class FruitDropWorld extends Forge2DWorld {
  final SpawnManager spawnManager = SpawnManager();
  final MergeManager mergeManager = MergeManager();
  final ScoreManager scoreManager = ScoreManager();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(BackgroundComponent());
    add(ContainerWall());
    add(GameOverLine());
    addAll([spawnManager, mergeManager, scoreManager]);
  }
}

class FruitDropGame extends Forge2DGame<FruitDropWorld> with PanDetector {
  FruitDropGame()
      : super(
          world: FruitDropWorld(),
          zoom: 20,
          gravity: Vector2(0, 15.0),
        );

  static const int _startingBombs = 3;

  final ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  final ValueNotifier<FruitType> nextFruitNotifier =
      ValueNotifier(FruitType.berry);
  final ValueNotifier<int> bombCountNotifier = ValueNotifier(_startingBombs);
  final ValueNotifier<bool> bombActiveNotifier = ValueNotifier(false);

  bool _gameActive = true;

  SpawnManager get spawnManager => world.spawnManager;
  MergeManager get mergeManager => world.mergeManager;
  ScoreManager get scoreManager => world.scoreManager;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_gameActive && world.isMounted) {
      scoreNotifier.value = scoreManager.score;
      nextFruitNotifier.value = spawnManager.nextFruit;
      bombActiveNotifier.value = spawnManager.isBombNext;
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (!_gameActive) return;
    _updatePreview(info.eventPosition.global);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!_gameActive) return;
    _updatePreview(info.eventPosition.global);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (!_gameActive) return;
    spawnManager.drop();
  }

  void _updatePreview(Vector2 screenPos) {
    final worldPos = screenToWorld(screenPos);
    spawnManager.onPointerMove(worldPos.x);
  }

  void activateBomb() {
    if (!_gameActive) return;
    if (bombCountNotifier.value <= 0) return;
    if (spawnManager.isBombNext) return;
    bombCountNotifier.value--;
    spawnManager.activateBomb();
  }

  void onGameOver() {
    if (!_gameActive) return;
    _gameActive = false;
    spawnManager.enabled = false;
    pauseEngine();
    overlays.add('gameOver');
  }

  void onWin() {
    if (!_gameActive) return;
    _gameActive = false;
    spawnManager.enabled = false;
    pauseEngine();
    overlays.add('gameOver');
  }

  void resetGame() {
    overlays.remove('gameOver');
    resumeEngine();

    for (final fruit in world.children.whereType<FruitBody>().toList()) {
      fruit.removeFromParent();
    }
    for (final bomb in world.children.whereType<BombBody>().toList()) {
      bomb.removeFromParent();
    }

    mergeManager.clear();
    scoreManager.reset();
    spawnManager.enabled = true;
    spawnManager.previewX = null;
    spawnManager.deactivateBomb();
    bombCountNotifier.value = _startingBombs;
    _gameActive = true;
  }
}
