import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';

import 'components/background_component.dart';
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

  final ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  final ValueNotifier<FruitType> nextFruitNotifier =
      ValueNotifier(FruitType.berry);

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

    final fruits = world.children.whereType<FruitBody>().toList();
    for (final fruit in fruits) {
      fruit.removeFromParent();
    }

    mergeManager.clear();
    scoreManager.reset();
    spawnManager.enabled = true;
    spawnManager.previewX = null;
    _gameActive = true;
  }
}
