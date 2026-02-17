import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../components/container_wall.dart';
import '../components/fruit_body.dart';
import '../data/fruit_type.dart';
import '../fruit_drop_game.dart';
import '../painters/fruit_painter.dart';

class SpawnManager extends Component with HasWorldReference<FruitDropWorld> {
  static const _spawnPool = [
    FruitType.berry,
    FruitType.berry,
    FruitType.berry,
    FruitType.raspberry,
    FruitType.raspberry,
    FruitType.orange,
  ];

  final _random = Random();
  FruitType nextFruit = FruitType.berry;
  double? previewX;
  bool _ready = true;
  double _cooldown = 0;
  bool enabled = true;

  SpawnManager() {
    nextFruit = _randomFruit();
  }

  FruitType _randomFruit() {
    return _spawnPool[_random.nextInt(_spawnPool.length)];
  }

  void onPointerMove(double worldX) {
    if (!enabled) return;
    previewX = worldX.clamp(
      -ContainerWall.width / 2 + nextFruit.radius + 0.1,
      ContainerWall.width / 2 - nextFruit.radius - 0.1,
    );
  }

  void drop() {
    if (!_ready || previewX == null || !enabled) return;
    _ready = false;
    _cooldown = 0.5;

    final spawnY = -ContainerWall.height / 2 - nextFruit.radius - 0.5;
    final spawnPos = Vector2(previewX!, spawnY);
    world.add(FruitBody(fruitType: nextFruit, position: spawnPos));

    nextFruit = _randomFruit();
  }

  @override
  void update(double dt) {
    if (!_ready) {
      _cooldown -= dt;
      if (_cooldown <= 0) _ready = true;
    }
  }

  @override
  void render(Canvas canvas) {
    if (previewX == null || !enabled) return;

    final spawnY = -ContainerWall.height / 2 - nextFruit.radius - 0.5;

    canvas.save();
    canvas.translate(previewX!, spawnY);
    FruitPainter.draw(canvas, nextFruit, nextFruit.radius,
        opacity: _ready ? 0.5 : 0.2);
    canvas.restore();

    // Drop guide line
    final linePaint = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = 0.05;
    canvas.drawLine(
      Offset(previewX!, spawnY + nextFruit.radius),
      Offset(previewX!, ContainerWall.height / 2),
      linePaint,
    );
  }
}
