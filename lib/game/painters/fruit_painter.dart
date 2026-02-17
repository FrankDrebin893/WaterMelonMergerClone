import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import '../data/fruit_type.dart';

Color _withAlpha(Color c, double a) => c.withValues(alpha: a);

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

  static void _drawBase(
      Canvas canvas, double radius, Color light, Color dark, double opacity) {
    final gradient = ui.Gradient.radial(
      Offset(-radius * 0.3, -radius * 0.3),
      radius * 1.2,
      [_withAlpha(light, opacity), _withAlpha(dark, opacity)],
    );
    canvas.drawCircle(Offset.zero, radius, Paint()..shader = gradient);
  }

  static void _drawHighlight(Canvas canvas, double radius, double opacity) {
    final highlight = Paint()
      ..color = _withAlpha(const Color(0xFFFFFFFF), 0.35 * opacity);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.25, -radius * 0.3),
        width: radius * 0.55,
        height: radius * 0.35,
      ),
      highlight,
    );
  }

  static void _drawStem(Canvas canvas, double radius, double opacity) {
    final stemPaint = Paint()
      ..color = _withAlpha(const Color(0xFF5D4037), opacity)
      ..strokeWidth = radius * 0.1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, -radius * 0.85),
      Offset(0, -radius * 1.2),
      stemPaint,
    );
  }

  static void _drawLeaf(Canvas canvas, double radius, double opacity) {
    final leafPaint = Paint()
      ..color = _withAlpha(const Color(0xFF4CAF50), opacity)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, -radius * 1.1)
      ..quadraticBezierTo(
          radius * 0.4, -radius * 1.4, radius * 0.5, -radius * 1.15)
      ..quadraticBezierTo(radius * 0.3, -radius * 1.0, 0, -radius * 1.1);
    canvas.drawPath(path, leafPaint);
  }

  static void _drawBerry(Canvas canvas, double radius, double opacity) {
    _drawBase(canvas, radius, const Color(0xFF9370DB), const Color(0xFF3A1D8E),
        opacity);
    _drawHighlight(canvas, radius, opacity);
    final crownPaint = Paint()
      ..color = _withAlpha(const Color(0xFF4CAF50), opacity)
      ..style = PaintingStyle.fill;
    for (var i = -1; i <= 1; i++) {
      final path = Path()
        ..moveTo(i * radius * 0.2, -radius * 0.8)
        ..lineTo(i * radius * 0.25, -radius * 1.2)
        ..lineTo(i * radius * 0.15, -radius * 0.8);
      canvas.drawPath(path, crownPaint);
    }
  }

  static void _drawRaspberry(Canvas canvas, double radius, double opacity) {
    final baseColor = _withAlpha(const Color(0xFFE30B5C), opacity);
    final darkColor = _withAlpha(const Color(0xFFAD0845), opacity);
    _drawBase(canvas, radius, const Color(0xFFFF4081), const Color(0xFFAD0845),
        opacity);

    final bumpPaint = Paint()..color = baseColor;
    final bumpDarkPaint = Paint()..color = darkColor;
    final bumpRadius = radius * 0.28;
    for (var angle = 0.0; angle < pi * 2; angle += pi / 3) {
      final dist = radius * 0.55;
      final x = cos(angle) * dist;
      final y = sin(angle) * dist;
      canvas.drawCircle(Offset(x, y), bumpRadius, bumpDarkPaint);
      canvas.drawCircle(
          Offset(x - bumpRadius * 0.15, y - bumpRadius * 0.15),
          bumpRadius * 0.7,
          bumpPaint);
    }
    _drawHighlight(canvas, radius, opacity);
    _drawStem(canvas, radius, opacity);
  }

  static void _drawOrange(Canvas canvas, double radius, double opacity) {
    _drawBase(canvas, radius, const Color(0xFFFFB74D), const Color(0xFFE65100),
        opacity);
    final dimplePaint = Paint()
      ..color = _withAlpha(const Color(0xFFE68A00), 0.3 * opacity);
    final rng = Random(42);
    for (var i = 0; i < 12; i++) {
      final angle = rng.nextDouble() * pi * 2;
      final dist = rng.nextDouble() * radius * 0.7;
      canvas.drawCircle(
        Offset(cos(angle) * dist, sin(angle) * dist),
        radius * 0.06,
        dimplePaint,
      );
    }
    _drawHighlight(canvas, radius, opacity);
    _drawStem(canvas, radius * 0.7, opacity);
    _drawLeaf(canvas, radius * 0.7, opacity);
  }

  static void _drawApple(Canvas canvas, double radius, double opacity) {
    _drawBase(canvas, radius, const Color(0xFFEF5350), const Color(0xFF8E0000),
        opacity);
    final indentPaint = Paint()
      ..color = _withAlpha(const Color(0xFF8E0000), 0.4 * opacity);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, -radius * 0.75),
        width: radius * 0.5,
        height: radius * 0.2,
      ),
      indentPaint,
    );
    _drawHighlight(canvas, radius, opacity);
    _drawStem(canvas, radius, opacity);
    _drawLeaf(canvas, radius, opacity);
  }

  static void _drawCoconut(Canvas canvas, double radius, double opacity) {
    _drawBase(canvas, radius, const Color(0xFFA1887F), const Color(0xFF4E342E),
        opacity);
    final eyePaint = Paint()
      ..color = _withAlpha(const Color(0xFF3E2723), opacity);
    final eyeRadius = radius * 0.15;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, -radius * 0.2),
          width: eyeRadius * 1.5,
          height: eyeRadius * 2),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(-radius * 0.35, radius * 0.2),
          width: eyeRadius * 1.5,
          height: eyeRadius * 2),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(radius * 0.35, radius * 0.2),
          width: eyeRadius * 1.5,
          height: eyeRadius * 2),
      eyePaint,
    );
    final hairPaint = Paint()
      ..color = _withAlpha(const Color(0xFF5D4037), 0.3 * opacity)
      ..strokeWidth = radius * 0.03
      ..style = PaintingStyle.stroke;
    final rng = Random(7);
    for (var i = 0; i < 8; i++) {
      final angle = rng.nextDouble() * pi * 2;
      final start = radius * 0.6;
      final end = radius * 0.9;
      canvas.drawLine(
        Offset(cos(angle) * start, sin(angle) * start),
        Offset(cos(angle) * end, sin(angle) * end),
        hairPaint,
      );
    }
    _drawHighlight(canvas, radius, opacity);
  }

  static void _drawWatermelon(Canvas canvas, double radius, double opacity) {
    final rindPaint = Paint()
      ..color = _withAlpha(const Color(0xFF2E7D32), opacity);
    canvas.drawCircle(Offset.zero, radius, rindPaint);

    final stripePaint = Paint()
      ..color = _withAlpha(const Color(0xFF4CAF50), 0.5 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.12;
    canvas.drawCircle(Offset.zero, radius * 0.85, stripePaint);

    final darkStripePaint = Paint()
      ..color = _withAlpha(const Color(0xFF1B5E20), 0.4 * opacity)
      ..strokeWidth = radius * 0.08
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      canvas.drawLine(
        Offset(cos(angle) * radius * 0.15, sin(angle) * radius * 0.15),
        Offset(cos(angle) * radius * 0.95, sin(angle) * radius * 0.95),
        darkStripePaint,
      );
    }

    final fleshGradient = ui.Gradient.radial(
      Offset(-radius * 0.2, -radius * 0.2),
      radius * 0.8,
      [
        _withAlpha(const Color(0xFFFF6B6B), opacity),
        _withAlpha(const Color(0xFFD32F2F), opacity),
      ],
    );
    canvas.drawCircle(
        Offset.zero, radius * 0.72, Paint()..shader = fleshGradient);

    final seedPaint = Paint()
      ..color = _withAlpha(const Color(0xFF212121), opacity);
    final rng = Random(13);
    for (var i = 0; i < 8; i++) {
      final angle = rng.nextDouble() * pi * 2;
      final dist = radius * 0.25 + rng.nextDouble() * radius * 0.35;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cos(angle) * dist, sin(angle) * dist),
          width: radius * 0.07,
          height: radius * 0.12,
        ),
        seedPaint,
      );
    }

    _drawHighlight(canvas, radius * 0.72, opacity);
  }
}
