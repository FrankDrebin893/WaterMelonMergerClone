import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import '../data/fruit_type.dart';

Color _withAlpha(Color c, double a) => c.withValues(alpha: a.clamp(0.0, 1.0));

abstract class FruitPainter {
  static void draw(Canvas canvas, FruitType type, double radius,
      {double opacity = 1.0}) {
    switch (type) {
      case FruitType.berry:
        _drawBerry(canvas, radius, opacity);
      case FruitType.raspberry:
        _drawRaspberry(canvas, radius, opacity);
      case FruitType.orange:
        _drawOrange(canvas, radius, opacity);
      case FruitType.apple:
        _drawApple(canvas, radius, opacity);
      case FruitType.coconut:
        _drawCoconut(canvas, radius, opacity);
      case FruitType.watermelon:
        _drawWatermelon(canvas, radius, opacity);
    }
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  static void _drawOutline(Canvas canvas, double radius, double opacity) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = _withAlpha(const Color(0xFF1A1A1A), 0.55 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.09,
    );
  }

  static void _drawHighlight(Canvas canvas, double radius, double opacity) {
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.25, -radius * 0.28),
        width: radius * 0.52,
        height: radius * 0.3,
      ),
      Paint()..color = _withAlpha(const Color(0xFFFFFFFF), 0.55 * opacity),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.22, -radius * 0.33),
        width: radius * 0.22,
        height: radius * 0.13,
      ),
      Paint()..color = _withAlpha(const Color(0xFFFFFFFF), 0.4 * opacity),
    );
  }

  static void _drawFace(Canvas canvas, double radius, double opacity,
      {double yOffset = 0.08}) {
    final eyeR = radius * 0.075;
    final eyeY = radius * yOffset;

    final eyePaint =
        Paint()..color = _withAlpha(const Color(0xFF1A1A1A), opacity);
    canvas.drawCircle(Offset(-radius * 0.2, eyeY), eyeR, eyePaint);
    canvas.drawCircle(Offset(radius * 0.2, eyeY), eyeR, eyePaint);

    // Eye shine
    final shinePaint =
        Paint()..color = _withAlpha(const Color(0xFFFFFFFF), 0.7 * opacity);
    canvas.drawCircle(
        Offset(-radius * 0.2 + eyeR * 0.5, eyeY - eyeR * 0.45),
        eyeR * 0.38,
        shinePaint);
    canvas.drawCircle(
        Offset(radius * 0.2 + eyeR * 0.5, eyeY - eyeR * 0.45),
        eyeR * 0.38,
        shinePaint);

    // Smile arc
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(0, radius * (yOffset + 0.15)),
        width: radius * 0.38,
        height: radius * 0.2,
      ),
      0.15,
      pi - 0.3,
      false,
      Paint()
        ..color = _withAlpha(const Color(0xFF1A1A1A), opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.055
        ..strokeCap = StrokeCap.round,
    );

    // Rosy cheeks
    final cheekPaint =
        Paint()..color = _withAlpha(const Color(0xFFFF69B4), 0.4 * opacity);
    canvas.drawCircle(
        Offset(-radius * 0.33, radius * (yOffset + 0.06)),
        radius * 0.1,
        cheekPaint);
    canvas.drawCircle(
        Offset(radius * 0.33, radius * (yOffset + 0.06)),
        radius * 0.1,
        cheekPaint);
  }

  // ── Berry ──────────────────────────────────────────────────────────────────

  static void _drawBerry(Canvas canvas, double radius, double opacity) {
    final gradient = ui.Gradient.radial(
      Offset(-radius * 0.3, -radius * 0.3),
      radius * 1.3,
      [
        _withAlpha(const Color(0xFFB57FE0), opacity),
        _withAlpha(const Color(0xFF4A1A6B), opacity),
      ],
    );
    canvas.drawCircle(Offset.zero, radius, Paint()..shader = gradient);

    // Crown — three green petals
    final crownPaint = Paint()
      ..color = _withAlpha(const Color(0xFF2E7D32), opacity)
      ..style = PaintingStyle.fill;
    for (var i = -1; i <= 1; i++) {
      final path = Path()
        ..moveTo(i * radius * 0.15, -radius * 0.82)
        ..lineTo(i * radius * 0.22, -radius * 1.28)
        ..lineTo(i * radius * 0.08, -radius * 0.82);
      canvas.drawPath(path, crownPaint);
    }
    canvas.drawCircle(
      Offset(0, -radius * 0.82),
      radius * 0.16,
      Paint()..color = _withAlpha(const Color(0xFF388E3C), opacity),
    );

    _drawHighlight(canvas, radius, opacity);
    _drawFace(canvas, radius, opacity, yOffset: 0.1);
    _drawOutline(canvas, radius, opacity);
  }

  // ── Raspberry ──────────────────────────────────────────────────────────────

  static void _drawRaspberry(Canvas canvas, double radius, double opacity) {
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()..color = _withAlpha(const Color(0xFF9E0000), opacity),
    );

    final darkDrupe = _withAlpha(const Color(0xFFC62828), opacity);
    final lightDrupe = _withAlpha(const Color(0xFFFF5252), opacity);
    final drupeR = radius * 0.31;

    for (var i = 0; i < 7; i++) {
      final angle = i * pi * 2 / 7;
      final dx = cos(angle) * radius * 0.48;
      final dy = sin(angle) * radius * 0.48;
      canvas.drawCircle(Offset(dx, dy), drupeR, Paint()..color = darkDrupe);
      canvas.drawCircle(
        Offset(dx - drupeR * 0.2, dy - drupeR * 0.2),
        drupeR * 0.58,
        Paint()..color = lightDrupe,
      );
    }
    // Center drupelet
    canvas.drawCircle(Offset.zero, drupeR * 0.85, Paint()..color = darkDrupe);
    canvas.drawCircle(
        const Offset(-0.02, -0.02), drupeR * 0.5, Paint()..color = lightDrupe);

    // Sepal leaves
    final leafPaint =
        Paint()..color = _withAlpha(const Color(0xFF388E3C), opacity);
    for (var i = -1; i <= 1; i += 2) {
      final path = Path()
        ..moveTo(0, -radius * 0.88)
        ..quadraticBezierTo(i * radius * 0.38, -radius * 1.08,
            i * radius * 0.42, -radius * 0.88)
        ..quadraticBezierTo(
            i * radius * 0.22, -radius * 0.8, 0, -radius * 0.88);
      canvas.drawPath(path, leafPaint);
    }
    // Stem
    canvas.drawLine(
      Offset(0, -radius * 0.88),
      Offset(0, -radius * 1.22),
      Paint()
        ..color = _withAlpha(const Color(0xFF1B5E20), opacity)
        ..strokeWidth = radius * 0.09
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    _drawHighlight(canvas, radius, opacity);
    _drawFace(canvas, radius, opacity, yOffset: 0.05);
    _drawOutline(canvas, radius, opacity);
  }

  // ── Orange ─────────────────────────────────────────────────────────────────

  static void _drawOrange(Canvas canvas, double radius, double opacity) {
    final gradient = ui.Gradient.radial(
      Offset(-radius * 0.28, -radius * 0.28),
      radius * 1.25,
      [
        _withAlpha(const Color(0xFFFFCC02), opacity),
        _withAlpha(const Color(0xFFE65100), opacity),
      ],
    );
    canvas.drawCircle(Offset.zero, radius, Paint()..shader = gradient);

    // Segment lines
    final segPaint = Paint()
      ..color = _withAlpha(const Color(0xFFBF6000), 0.22 * opacity)
      ..strokeWidth = radius * 0.04
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      canvas.drawLine(
        Offset(cos(angle) * radius * 0.18, sin(angle) * radius * 0.18),
        Offset(cos(angle) * radius * 0.9, sin(angle) * radius * 0.9),
        segPaint,
      );
    }

    // Navel
    canvas.drawCircle(
      Offset(0, -radius * 0.72),
      radius * 0.1,
      Paint()..color = _withAlpha(const Color(0xFFE65100), 0.55 * opacity),
    );

    // Stem
    canvas.drawLine(
      Offset(0, -radius * 0.88),
      Offset(0, -radius * 1.2),
      Paint()
        ..color = _withAlpha(const Color(0xFF5D4037), opacity)
        ..strokeWidth = radius * 0.09
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Leaf
    final leafPath = Path()
      ..moveTo(0, -radius * 1.05)
      ..quadraticBezierTo(
          radius * 0.48, -radius * 1.45, radius * 0.55, -radius * 1.18)
      ..quadraticBezierTo(radius * 0.32, -radius * 0.96, 0, -radius * 1.05);
    canvas.drawPath(
        leafPath, Paint()..color = _withAlpha(const Color(0xFF388E3C), opacity));

    _drawHighlight(canvas, radius, opacity);
    _drawFace(canvas, radius, opacity, yOffset: 0.1);
    _drawOutline(canvas, radius, opacity);
  }

  // ── Apple ──────────────────────────────────────────────────────────────────

  static void _drawApple(Canvas canvas, double radius, double opacity) {
    final gradient = ui.Gradient.radial(
      Offset(-radius * 0.3, -radius * 0.28),
      radius * 1.28,
      [
        _withAlpha(const Color(0xFFFF5252), opacity),
        _withAlpha(const Color(0xFF7F0000), opacity),
      ],
    );
    canvas.drawCircle(Offset.zero, radius, Paint()..shader = gradient);

    // Top indent
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, -radius * 0.82),
        width: radius * 0.4,
        height: radius * 0.18,
      ),
      Paint()..color = _withAlpha(const Color(0xFF7F0000), 0.45 * opacity),
    );

    // Curved stem
    final stemPath = Path()
      ..moveTo(0, -radius * 0.88)
      ..quadraticBezierTo(
          radius * 0.1, -radius * 1.15, radius * 0.05, -radius * 1.32);
    canvas.drawPath(
      stemPath,
      Paint()
        ..color = _withAlpha(const Color(0xFF5D4037), opacity)
        ..strokeWidth = radius * 0.1
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Leaf
    final leafPath = Path()
      ..moveTo(radius * 0.05, -radius * 1.18)
      ..quadraticBezierTo(
          radius * 0.58, -radius * 1.52, radius * 0.62, -radius * 1.22)
      ..quadraticBezierTo(
          radius * 0.42, -radius * 1.06, radius * 0.05, -radius * 1.18);
    canvas.drawPath(
        leafPath, Paint()..color = _withAlpha(const Color(0xFF4CAF50), opacity));
    // Leaf vein
    canvas.drawLine(
      Offset(radius * 0.05, -radius * 1.18),
      Offset(radius * 0.52, -radius * 1.34),
      Paint()
        ..color = _withAlpha(const Color(0xFF2E7D32), 0.5 * opacity)
        ..strokeWidth = radius * 0.03
        ..style = PaintingStyle.stroke,
    );

    _drawHighlight(canvas, radius, opacity);
    _drawFace(canvas, radius, opacity, yOffset: 0.08);
    _drawOutline(canvas, radius, opacity);
  }

  // ── Coconut ────────────────────────────────────────────────────────────────

  static void _drawCoconut(Canvas canvas, double radius, double opacity) {
    final gradient = ui.Gradient.radial(
      Offset(-radius * 0.3, -radius * 0.3),
      radius * 1.2,
      [
        _withAlpha(const Color(0xFFA1887F), opacity),
        _withAlpha(const Color(0xFF4E342E), opacity),
      ],
    );
    canvas.drawCircle(Offset.zero, radius, Paint()..shader = gradient);

    // Fiber texture
    final hairPaint = Paint()
      ..color = _withAlpha(const Color(0xFF5D4037), 0.4 * opacity)
      ..strokeWidth = radius * 0.025
      ..style = PaintingStyle.stroke;
    final rng = Random(7);
    for (var i = 0; i < 18; i++) {
      final angle = rng.nextDouble() * pi * 2;
      canvas.drawLine(
        Offset(cos(angle) * radius * 0.52, sin(angle) * radius * 0.52),
        Offset(cos(angle) * radius * 0.92, sin(angle) * radius * 0.92),
        hairPaint,
      );
    }

    // Three oval marks forming an inherent face
    final markPaint =
        Paint()..color = _withAlpha(const Color(0xFF3E2723), opacity);
    final eyeR = radius * 0.14;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(-radius * 0.28, -radius * 0.15),
          width: eyeR * 1.3,
          height: eyeR * 1.7),
      markPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(radius * 0.28, -radius * 0.15),
          width: eyeR * 1.3,
          height: eyeR * 1.7),
      markPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, radius * 0.22),
          width: eyeR * 1.1,
          height: eyeR * 1.4),
      markPaint,
    );

    // Smile below the marks
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(0, radius * 0.52),
        width: radius * 0.45,
        height: radius * 0.22,
      ),
      0.1,
      pi - 0.2,
      false,
      Paint()
        ..color = _withAlpha(const Color(0xFF3E2723), opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06
        ..strokeCap = StrokeCap.round,
    );

    // Rosy cheeks
    canvas.drawCircle(Offset(-radius * 0.5, radius * 0.35), radius * 0.1,
        Paint()..color = _withAlpha(const Color(0xFFFF69B4), 0.32 * opacity));
    canvas.drawCircle(Offset(radius * 0.5, radius * 0.35), radius * 0.1,
        Paint()..color = _withAlpha(const Color(0xFFFF69B4), 0.32 * opacity));

    _drawHighlight(canvas, radius, opacity);
    _drawOutline(canvas, radius, opacity);
  }

  // ── Watermelon ─────────────────────────────────────────────────────────────

  static void _drawWatermelon(Canvas canvas, double radius, double opacity) {
    // Green rind
    final rindGradient = ui.Gradient.radial(
      Offset(-radius * 0.2, -radius * 0.2),
      radius * 1.2,
      [
        _withAlpha(const Color(0xFF81C784), opacity),
        _withAlpha(const Color(0xFF1B5E20), opacity),
      ],
    );
    canvas.drawCircle(Offset.zero, radius, Paint()..shader = rindGradient);

    // Dark stripes
    final stripePaint = Paint()
      ..color = _withAlpha(const Color(0xFF1B5E20), 0.5 * opacity)
      ..strokeWidth = radius * 0.09
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 5; i++) {
      final angle = i * pi * 2 / 5 + pi / 10;
      canvas.drawLine(
        Offset(cos(angle) * radius * 0.2, sin(angle) * radius * 0.2),
        Offset(cos(angle) * radius * 0.95, sin(angle) * radius * 0.95),
        stripePaint,
      );
    }

    // Red flesh circle
    final fleshR = radius * 0.73;
    final fleshGradient = ui.Gradient.radial(
      Offset(-radius * 0.2, -radius * 0.2),
      radius * 0.9,
      [
        _withAlpha(const Color(0xFFFF8A80), opacity),
        _withAlpha(const Color(0xFFD32F2F), opacity),
      ],
    );
    canvas.drawCircle(Offset.zero, fleshR, Paint()..shader = fleshGradient);

    // Seeds, avoiding center face area
    final seedPaint =
        Paint()..color = _withAlpha(const Color(0xFF1A1A1A), 0.8 * opacity);
    final rng = Random(13);
    for (var i = 0; i < 10; i++) {
      final angle = rng.nextDouble() * pi * 2;
      final dist = fleshR * (0.35 + rng.nextDouble() * 0.42);
      final sx = cos(angle) * dist;
      final sy = sin(angle) * dist;
      if (sy > -fleshR * 0.12 &&
          sy < fleshR * 0.42 &&
          sx.abs() < fleshR * 0.48) {
        continue;
      }
      canvas.save();
      canvas.translate(sx, sy);
      canvas.rotate(angle + pi / 2);
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero,
            width: radius * 0.065,
            height: radius * 0.11),
        seedPaint,
      );
      canvas.restore();
    }

    _drawHighlight(canvas, fleshR, opacity);
    _drawFace(canvas, fleshR, opacity, yOffset: 0.08);
    _drawOutline(canvas, radius, opacity);
  }
}
