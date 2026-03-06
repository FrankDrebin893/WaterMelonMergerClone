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

    // Excited brows (arched upward — happy!)
    final browPaint = Paint()
      ..color = _withAlpha(const Color(0xFFFFFFFF), 0.9 * opacity)
      ..strokeWidth = radius * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(-radius * 0.22, -radius * 0.22),
        width: radius * 0.38,
        height: radius * 0.22,
      ),
      pi + 0.35,
      pi - 0.7,
      false,
      browPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(radius * 0.22, -radius * 0.22),
        width: radius * 0.38,
        height: radius * 0.22,
      ),
      pi + 0.35,
      pi - 0.7,
      false,
      browPaint,
    );

    // Big excited eyes
    final eyePaint =
        Paint()..color = _withAlpha(const Color(0xFFFFFFFF), opacity);
    canvas.drawCircle(
        Offset(-radius * 0.2, radius * 0.08), radius * 0.11, eyePaint);
    canvas.drawCircle(
        Offset(radius * 0.2, radius * 0.08), radius * 0.11, eyePaint);
    // Eye shine sparkles
    final shinePaint =
        Paint()..color = _withAlpha(const Color(0xFFFFFF88), 0.9 * opacity);
    canvas.drawCircle(
        Offset(-radius * 0.16, radius * 0.04), radius * 0.04, shinePaint);
    canvas.drawCircle(
        Offset(radius * 0.24, radius * 0.04), radius * 0.04, shinePaint);

    // Wide excited grin
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(0, radius * 0.36),
        width: radius * 0.52,
        height: radius * 0.3,
      ),
      0.05,
      pi - 0.1,
      false,
      Paint()
        ..color = _withAlpha(const Color(0xFFFFFFFF), opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.08
        ..strokeCap = StrokeCap.round,
    );

    // Pink excited cheeks
    canvas.drawCircle(
      Offset(-radius * 0.38, radius * 0.28),
      radius * 0.1,
      Paint()..color = _withAlpha(const Color(0xFFFF88AA), 0.45 * opacity),
    );
    canvas.drawCircle(
      Offset(radius * 0.38, radius * 0.28),
      radius * 0.1,
      Paint()..color = _withAlpha(const Color(0xFFFF88AA), 0.45 * opacity),
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
