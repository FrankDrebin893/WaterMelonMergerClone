import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

Color _withAlpha(Color c, double a) => c.withValues(alpha: a.clamp(0.0, 1.0));

abstract class BombPainter {
  static void draw(Canvas canvas, double radius, {double opacity = 1.0}) {
    // Main sphere — dark radial gradient
    final gradient = ui.Gradient.radial(
      Offset(-radius * 0.3, -radius * 0.3),
      radius * 1.2,
      [
        _withAlpha(const Color(0xFF5A5A5A), opacity),
        _withAlpha(const Color(0xFF111111), opacity),
      ],
    );
    canvas.drawCircle(Offset.zero, radius, Paint()..shader = gradient);

    // Highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-radius * 0.26, -radius * 0.3),
        width: radius * 0.5,
        height: radius * 0.28,
      ),
      Paint()..color = _withAlpha(const Color(0xFFFFFFFF), 0.38 * opacity),
    );

    // Angry brows (slanted inward)
    final browPaint = Paint()
      ..color = _withAlpha(const Color(0xFFFFFFFF), 0.9 * opacity)
      ..strokeWidth = radius * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(-radius * 0.38, -radius * 0.2),
      Offset(-radius * 0.1, -radius * 0.08),
      browPaint,
    );
    canvas.drawLine(
      Offset(radius * 0.1, -radius * 0.08),
      Offset(radius * 0.38, -radius * 0.2),
      browPaint,
    );

    // Eyes
    final eyePaint =
        Paint()..color = _withAlpha(const Color(0xFFFFFFFF), opacity);
    canvas.drawCircle(
        Offset(-radius * 0.19, radius * 0.1), radius * 0.09, eyePaint);
    canvas.drawCircle(
        Offset(radius * 0.19, radius * 0.1), radius * 0.09, eyePaint);

    // Frown
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(0, radius * 0.42),
        width: radius * 0.4,
        height: radius * 0.2,
      ),
      pi + 0.2, // bottom arc = frown
      pi - 0.4,
      false,
      Paint()
        ..color = _withAlpha(const Color(0xFFFFFFFF), opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.07
        ..strokeCap = StrokeCap.round,
    );

    // Fuse (curving out of top)
    final fusePath = Path()
      ..moveTo(0, -radius * 0.95)
      ..quadraticBezierTo(
          radius * 0.38, -radius * 1.4, radius * 0.22, -radius * 1.78);
    canvas.drawPath(
      fusePath,
      Paint()
        ..color = _withAlpha(const Color(0xFF8D6E63), opacity)
        ..strokeWidth = radius * 0.11
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Fuse glow
    canvas.drawCircle(
      Offset(radius * 0.22, -radius * 1.78),
      radius * 0.22,
      Paint()..color = _withAlpha(const Color(0x88FF6600), opacity),
    );
    // Fuse spark tip
    canvas.drawCircle(
      Offset(radius * 0.22, -radius * 1.78),
      radius * 0.11,
      Paint()..color = _withAlpha(const Color(0xFFFFFF00), opacity),
    );

    // Outline
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = _withAlpha(const Color(0xFF1A1A1A), 0.7 * opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.1,
    );
  }
}
