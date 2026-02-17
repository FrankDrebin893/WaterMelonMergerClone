import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../data/fruit_type.dart';
import '../fruit_drop_game.dart';
import '../managers/merge_manager.dart';
import '../painters/fruit_painter.dart';

class FruitBody extends BodyComponent with ContactCallbacks {
  FruitBody({required this.fruitType, required Vector2 position})
      : _initialPosition = position;

  final FruitType fruitType;
  final Vector2 _initialPosition;
  bool pendingRemoval = false;
  MergeManager? _mergeManager;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = fruitType.radius;
    final fixtureDef = FixtureDef(
      shape,
      density: 0.8 + fruitType.index * 0.2,
      friction: 0.3,
      restitution: 0.35,
    );
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: _initialPosition,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onMount() {
    super.onMount();
    final w = findParent<FruitDropWorld>();
    _mergeManager = w?.children.whereType<MergeManager>().firstOrNull;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is FruitBody &&
        other.fruitType == fruitType &&
        !pendingRemoval &&
        !other.pendingRemoval) {
      pendingRemoval = true;
      other.pendingRemoval = true;
      _mergeManager?.enqueueMerge(this, other);
    }
  }

  @override
  void render(Canvas canvas) {
    FruitPainter.draw(canvas, fruitType, fruitType.radius);
  }

  @override
  bool get renderBody => false;
}
