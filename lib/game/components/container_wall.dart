import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/painting.dart';

class ContainerWall extends BodyComponent {
  static const double width = 12.0;
  static const double height = 18.0;

  @override
  Body createBody() {
    final halfW = width / 2;
    final halfH = height / 2;
    final bodyDef = BodyDef(type: BodyType.static, position: Vector2.zero());
    final body = world.createBody(bodyDef);

    // Bottom
    body.createFixture(FixtureDef(
      EdgeShape()..set(Vector2(-halfW, halfH), Vector2(halfW, halfH)),
      friction: 0.5,
    ));
    // Left wall
    body.createFixture(FixtureDef(
      EdgeShape()..set(Vector2(-halfW, -halfH), Vector2(-halfW, halfH)),
      friction: 0.3,
    ));
    // Right wall
    body.createFixture(FixtureDef(
      EdgeShape()..set(Vector2(halfW, -halfH), Vector2(halfW, halfH)),
      friction: 0.3,
    ));

    return body;
  }

  @override
  void render(Canvas canvas) {
    const halfW = width / 2;
    const halfH = height / 2;

    // Container background
    final bgPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      const Rect.fromLTRB(-halfW, -halfH, halfW, halfH),
      bgPaint,
    );

    // Wall border
    final wallPaint = Paint()
      ..color = const Color(0xFF4A90D9)
      ..strokeWidth = 0.15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Bottom
    canvas.drawLine(
        const Offset(-halfW, halfH), const Offset(halfW, halfH), wallPaint);
    // Left
    canvas.drawLine(
        const Offset(-halfW, -halfH), const Offset(-halfW, halfH), wallPaint);
    // Right
    canvas.drawLine(
        const Offset(halfW, -halfH), const Offset(halfW, halfH), wallPaint);
  }

  @override
  bool get renderBody => false;
}
