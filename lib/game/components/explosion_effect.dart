import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../data/fruit_type.dart';

class ExplosionEffect extends PositionComponent {
  ExplosionEffect({
    required Vector2 position,
    required this.fruitType,
  }) : super(position: position);

  final FruitType fruitType;
  final List<_Particle> _particles = [];
  double _elapsed = 0;
  static const double _duration = 0.45;

  @override
  void onMount() {
    super.onMount();
    final rng = Random();
    final baseRadius = fruitType.radius;
    final color = fruitType.color;

    // Ring of particles
    final count = 10 + fruitType.index * 2;
    for (var i = 0; i < count; i++) {
      final angle = (i / count) * pi * 2 + rng.nextDouble() * 0.3;
      final speed = baseRadius * (3.0 + rng.nextDouble() * 4.0);
      final size = baseRadius * (0.08 + rng.nextDouble() * 0.12);
      _particles.add(_Particle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        size: size,
        color: color,
        decay: 0.7 + rng.nextDouble() * 0.3,
      ));
    }

    // Bright flash particles (white/yellow)
    for (var i = 0; i < 6; i++) {
      final angle = rng.nextDouble() * pi * 2;
      final speed = baseRadius * (2.0 + rng.nextDouble() * 2.0);
      _particles.add(_Particle(
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        size: baseRadius * 0.15,
        color: const Color(0xFFFFFF80),
        decay: 0.5 + rng.nextDouble() * 0.2,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= _duration) {
      removeFromParent();
      return;
    }

    for (final p in _particles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      // Slow down
      p.vx *= 0.95;
      p.vy *= 0.95;
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = (_elapsed / _duration).clamp(0.0, 1.0);

    // Shockwave ring
    final ringRadius = fruitType.radius * (1.0 + progress * 3.0);
    final ringAlpha = (1.0 - progress) * 0.6;
    final ringPaint = Paint()
      ..color = fruitType.color.withValues(alpha: ringAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = fruitType.radius * 0.15 * (1.0 - progress);
    canvas.drawCircle(Offset.zero, ringRadius, ringPaint);

    // Particles
    for (final p in _particles) {
      final alpha = (1.0 - progress / p.decay).clamp(0.0, 1.0);
      final size = p.size * (1.0 - progress * 0.5);
      if (alpha <= 0 || size <= 0) continue;

      final paint = Paint()..color = p.color.withValues(alpha: alpha);
      canvas.drawCircle(Offset(p.x, p.y), size, paint);
    }
  }
}

class _Particle {
  double x = 0;
  double y = 0;
  double vx;
  double vy;
  double size;
  Color color;
  double decay;

  _Particle({
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.decay,
  });
}
