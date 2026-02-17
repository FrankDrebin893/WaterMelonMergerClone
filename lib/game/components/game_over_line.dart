import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/painting.dart';

import '../fruit_drop_game.dart';
import 'container_wall.dart';
import 'fruit_body.dart';

class GameOverLine extends BodyComponent with ContactCallbacks {
  static const double yPosition = -ContainerWall.height / 2 + 2.0;

  final Set<FruitBody> _touching = {};
  double _touchTimer = 0;
  FruitDropGame? _game;

  @override
  Body createBody() {
    final halfW = ContainerWall.width / 2;
    final shape = EdgeShape()
      ..set(Vector2(-halfW, yPosition), Vector2(halfW, yPosition));
    final fixtureDef = FixtureDef(shape, isSensor: true);
    final bodyDef = BodyDef(
      type: BodyType.static,
      userData: this,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onMount() {
    super.onMount();
    _game = findParent<FruitDropWorld>()?.parent as FruitDropGame?;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is FruitBody) _touching.add(other);
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is FruitBody) _touching.remove(other);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _touching.removeWhere((f) => f.pendingRemoval || !f.isMounted);

    if (_touching.isNotEmpty) {
      _touchTimer += dt;
      if (_touchTimer > 2.0) {
        _game?.onGameOver();
      }
    } else {
      _touchTimer = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    final halfW = ContainerWall.width / 2;
    final paint = Paint()
      ..color = const Color(0x44FF0000)
      ..strokeWidth = 0.08
      ..style = PaintingStyle.stroke;
    // Dashed line effect
    const dashWidth = 0.5;
    const gapWidth = 0.3;
    var x = -halfW;
    while (x < halfW) {
      final endX = (x + dashWidth).clamp(-halfW, halfW);
      canvas.drawLine(
        Offset(x, yPosition),
        Offset(endX, yPosition),
        paint,
      );
      x += dashWidth + gapWidth;
    }
  }

  @override
  bool get renderBody => false;
}
