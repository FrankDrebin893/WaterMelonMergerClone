import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../fruit_drop_game.dart';
import '../managers/merge_manager.dart';
import '../painters/bomb_painter.dart';

class BombBody extends BodyComponent with ContactCallbacks {
  static const double radius = 0.8;

  BombBody({required Vector2 position}) : _initialPosition = position;

  final Vector2 _initialPosition;
  bool pendingExplosion = false;
  MergeManager? _mergeManager;

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(
      shape,
      density: 1.5,
      friction: 0.3,
      restitution: 0.05,
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
    // Ignore sensor contacts (e.g. the game-over line at the top)
    if (contact.fixtureA.isSensor || contact.fixtureB.isSensor) return;
    if (!pendingExplosion) {
      pendingExplosion = true;
      _mergeManager?.enqueueBomb(this);
    }
  }

  @override
  void render(Canvas canvas) {
    BombPainter.draw(canvas, radius);
  }

  @override
  bool get renderBody => false;
}
