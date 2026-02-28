import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

class BackgroundComponent extends PositionComponent {
  BackgroundComponent() : super(priority: -100);

  @override
  void render(Canvas canvas) {
    _drawSky(canvas);
    _drawStars(canvas);
    _drawSun(canvas);
    _drawClouds(canvas);
    _drawGround(canvas);
    _drawLeftVillage(canvas);
    _drawRightVillage(canvas);
  }

  void _drawSky(Canvas canvas) {
    final gradient = Gradient.linear(
      const Offset(0, -35),
      const Offset(0, 22),
      [
        const Color(0xFFC4D4F5), // periwinkle
        const Color(0xFFD8C4F0), // lavender
        const Color(0xFFFFE5CB), // peach
      ],
      [0.0, 0.45, 1.0],
    );
    canvas.drawRect(
      const Rect.fromLTRB(-30, -35, 30, 35),
      Paint()..shader = gradient,
    );
  }

  void _drawStars(Canvas canvas) {
    final rng = Random(42);
    final paint = Paint()..color = const Color(0xCCFFFFFF);
    for (var i = 0; i < 28; i++) {
      final x = rng.nextDouble() * 56 - 28;
      final y = rng.nextDouble() * 17 - 34;
      canvas.drawCircle(Offset(x, y), 0.09, paint);
    }
  }

  void _drawSun(Canvas canvas) {
    canvas.save();
    canvas.translate(11, -22);

    canvas.drawCircle(Offset.zero, 2.3, Paint()..color = const Color(0x33FFD700));
    canvas.drawCircle(Offset.zero, 1.8, Paint()..color = const Color(0x55FFD700));
    canvas.drawCircle(Offset.zero, 1.4, Paint()..color = const Color(0xFFFFD700));

    final rayPaint = Paint()
      ..color = const Color(0xAAFFD700)
      ..strokeWidth = 0.12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      canvas.drawLine(
        Offset(cos(angle) * 1.65, sin(angle) * 1.65),
        Offset(cos(angle) * 2.6, sin(angle) * 2.6),
        rayPaint,
      );
    }
    canvas.restore();
  }

  void _drawClouds(Canvas canvas) {
    _drawCloud(canvas, -7.0, -20.0);
    _drawCloud(canvas, 2.5, -24.0);
    _drawCloud(canvas, 11.5, -18.0);
    _drawCloud(canvas, -14.0, -15.5);
  }

  void _drawCloud(Canvas canvas, double cx, double cy) {
    canvas.save();
    canvas.translate(cx, cy);
    final paint = Paint()..color = const Color(0xEEFFFFFF);
    final bumps = [
      [0.0, 0.0, 0.92],
      [-1.05, 0.35, 0.72],
      [1.05, 0.35, 0.72],
      [-0.52, -0.32, 0.68],
      [0.52, -0.28, 0.68],
    ];
    for (final b in bumps) {
      canvas.drawCircle(Offset(b[0], b[1]), b[2], paint);
    }
    canvas.restore();
  }

  void _drawGround(Canvas canvas) {
    const gY = 9.0;

    // Base fill (solid ground below hills)
    canvas.drawRect(
      const Rect.fromLTRB(-30, gY, 30, 35),
      Paint()..color = const Color(0xFF6DBF67),
    );

    // Rolling hill silhouette
    final hillPath = Path()
      ..moveTo(-30, 35)
      ..lineTo(-30, gY + 2.5)
      ..quadraticBezierTo(-22, gY - 2.5, -14, gY + 1.5)
      ..quadraticBezierTo(-7, gY + 5.0, 0, gY + 0.8)
      ..quadraticBezierTo(7, gY - 2.5, 14, gY + 1.5)
      ..quadraticBezierTo(22, gY + 5.0, 30, gY + 1.0)
      ..lineTo(30, 35)
      ..close();
    canvas.drawPath(hillPath, Paint()..color = const Color(0xFF6DBF67));

    // Lighter grass strip on surface
    final grassPath = Path()
      ..moveTo(-30, gY + 2.8)
      ..quadraticBezierTo(-22, gY - 2.2, -14, gY + 1.8)
      ..quadraticBezierTo(-7, gY + 5.3, 0, gY + 1.1)
      ..quadraticBezierTo(7, gY - 2.2, 14, gY + 1.8)
      ..quadraticBezierTo(22, gY + 5.3, 30, gY + 1.3)
      ..lineTo(30, gY + 1.8)
      ..quadraticBezierTo(22, gY + 5.6, 14, gY + 2.1)
      ..quadraticBezierTo(7, gY - 1.9, 0, gY + 1.4)
      ..quadraticBezierTo(-7, gY + 5.6, -14, gY + 2.1)
      ..quadraticBezierTo(-22, gY - 1.9, -30, gY + 3.1)
      ..close();
    canvas.drawPath(grassPath, Paint()..color = const Color(0xFF86D880));
  }

  void _drawLeftVillage(Canvas canvas) {
    const gY = 9.0;
    _drawFruitTree(canvas, -11.5, gY,
        const Color(0xFF9B59B6), const Color(0xFFCE93D8));
    _drawHouse(canvas, -9.5, gY, const Color(0xFFD7A8E0),
        const Color(0xFF7B1FA2), const Color(0xFFFFEB3B));
    _drawFruitTree(canvas, -7.8, gY - 0.5,
        const Color(0xFFF44336), const Color(0xFFFF8A80));
    _drawMushroom(canvas, -13.2, gY + 0.3);
    _drawMushroom(canvas, -6.5, gY + 0.4);
  }

  void _drawRightVillage(Canvas canvas) {
    const gY = 9.0;
    _drawFruitTree(canvas, 7.8, gY - 0.5,
        const Color(0xFFFF9800), const Color(0xFFFFCC80));
    _drawHouse(canvas, 9.5, gY, const Color(0xFF9CCC65),
        const Color(0xFF2E7D32), const Color(0xFFFF8A80));
    _drawPalmTree(canvas, 12.5, gY - 1.0);
    _drawFlower(canvas, 7.2, gY + 0.3, const Color(0xFFFFEB3B));
    _drawFlower(canvas, 14.0, gY + 0.4, const Color(0xFFFF4081));
  }

  void _drawFruitTree(Canvas canvas, double x, double baseY,
      Color fruitColor, Color lightColor) {
    canvas.save();
    canvas.translate(x, baseY);

    // Trunk
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, -2.5),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = 0.36
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Foliage
    canvas.drawCircle(
        const Offset(-0.7, -3.0), 1.0, Paint()..color = const Color(0xFF66BB6A));
    canvas.drawCircle(
        const Offset(0.7, -3.0), 1.0, Paint()..color = const Color(0xFF66BB6A));
    canvas.drawCircle(
        const Offset(0, -3.6), 1.18, Paint()..color = const Color(0xFF4CAF50));

    // Fruits
    final fruitPositions = [
      [-0.55, -3.98],
      [0.55, -3.72],
      [0.0, -4.38],
      [-0.9, -3.22],
      [0.9, -3.28],
    ];
    final fp = Paint()..color = fruitColor;
    final lp = Paint()..color = lightColor;
    for (final pos in fruitPositions) {
      canvas.drawCircle(Offset(pos[0], pos[1]), 0.28, fp);
      canvas.drawCircle(Offset(pos[0] - 0.08, pos[1] - 0.08), 0.12, lp);
    }

    canvas.restore();
  }

  void _drawHouse(Canvas canvas, double x, double baseY,
      Color wallColor, Color roofColor, Color windowColor) {
    canvas.save();
    canvas.translate(x, baseY);

    // House body
    canvas.drawRect(
      const Rect.fromLTRB(-1.1, -2.0, 1.1, 0),
      Paint()..color = wallColor,
    );

    // Roof
    final roofPath = Path()
      ..moveTo(-1.35, -2.0)
      ..lineTo(0, -3.6)
      ..lineTo(1.35, -2.0)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = roofColor);

    // Chimney
    canvas.drawRect(
      const Rect.fromLTRB(0.35, -3.95, 0.72, -2.85),
      Paint()..color = roofColor,
    );

    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(-0.28, -1.0, 0.28, 0),
        const Radius.circular(0.15),
      ),
      Paint()..color = const Color(0xFF8D6E63),
    );

    // Windows
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(-0.85, -1.72, -0.3, -1.2),
        const Radius.circular(0.08),
      ),
      Paint()..color = windowColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(0.3, -1.72, 0.85, -1.2),
        const Radius.circular(0.08),
      ),
      Paint()..color = windowColor,
    );

    canvas.restore();
  }

  void _drawPalmTree(Canvas canvas, double x, double baseY) {
    canvas.save();
    canvas.translate(x, baseY);

    // Curved trunk
    final trunkPath = Path()
      ..moveTo(-0.18, 0)
      ..quadraticBezierTo(-0.6, -2.5, -0.1, -4.5)
      ..lineTo(0.18, -4.5)
      ..quadraticBezierTo(-0.25, -2.5, 0.18, 0)
      ..close();
    canvas.drawPath(trunkPath, Paint()..color = const Color(0xFF8D6E63));

    // Fronds
    final frondPaint = Paint()
      ..color = const Color(0xFF388E3C)
      ..strokeWidth = 0.24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fronds = [
      [0.0, -4.5, -2.8, -5.8, -0.6, -5.1],
      [0.0, -4.5, 2.8, -5.8, 0.6, -5.1],
      [0.0, -4.5, -3.2, -4.6, 0.0, -5.0],
      [0.0, -4.5, 3.2, -4.6, 0.0, -5.0],
      [0.0, -4.5, 0.2, -6.3, 0.0, -5.3],
    ];
    for (final f in fronds) {
      final path = Path()
        ..moveTo(f[0], f[1])
        ..quadraticBezierTo(f[2], f[3], f[4], f[5]);
      canvas.drawPath(path, frondPaint);
    }

    // Coconuts
    canvas.drawCircle(const Offset(-0.32, -4.6), 0.3,
        Paint()..color = const Color(0xFF8D6E63));
    canvas.drawCircle(const Offset(0.35, -4.72), 0.28,
        Paint()..color = const Color(0xFF6D4C41));

    canvas.restore();
  }

  void _drawMushroom(Canvas canvas, double x, double baseY) {
    canvas.save();
    canvas.translate(x, baseY);

    // Stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(-0.22, -0.55, 0.22, 0),
        const Radius.circular(0.1),
      ),
      Paint()..color = const Color(0xFFF5F5F5),
    );

    // Cap
    final capPath = Path()
      ..moveTo(-0.46, -0.55)
      ..quadraticBezierTo(-0.5, -1.15, 0, -1.32)
      ..quadraticBezierTo(0.5, -1.15, 0.46, -0.55)
      ..close();
    canvas.drawPath(capPath, Paint()..color = const Color(0xFFE53935));

    // White spots
    canvas.drawCircle(const Offset(0, -0.93), 0.1,
        Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(const Offset(-0.24, -0.74), 0.07,
        Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(const Offset(0.24, -0.74), 0.07,
        Paint()..color = const Color(0xFFFFFFFF));

    canvas.restore();
  }

  void _drawFlower(Canvas canvas, double x, double baseY, Color petalColor) {
    canvas.save();
    canvas.translate(x, baseY);

    // Stem
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, -0.9),
      Paint()
        ..color = const Color(0xFF4CAF50)
        ..strokeWidth = 0.1
        ..style = PaintingStyle.stroke,
    );

    // Petals
    final petalPaint = Paint()..color = petalColor;
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      canvas.drawCircle(
        Offset(cos(angle) * 0.22, -0.9 + sin(angle) * 0.22),
        0.18,
        petalPaint,
      );
    }

    // Center
    canvas.drawCircle(const Offset(0, -0.9), 0.14,
        Paint()..color = const Color(0xFFFFE000));

    canvas.restore();
  }
}
