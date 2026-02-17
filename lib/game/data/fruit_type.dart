import 'dart:ui';

enum FruitType {
  berry(radius: 0.5, score: 1, color: Color(0xFF6A5ACD)),
  raspberry(radius: 0.7, score: 3, color: Color(0xFFE30B5C)),
  orange(radius: 0.95, score: 6, color: Color(0xFFFF8C00)),
  apple(radius: 1.2, score: 10, color: Color(0xFFDC143C)),
  coconut(radius: 1.5, score: 15, color: Color(0xFF8B4513)),
  watermelon(radius: 1.9, score: 21, color: Color(0xFF2E8B57));

  const FruitType({
    required this.radius,
    required this.score,
    required this.color,
  });

  final double radius;
  final int score;
  final Color color;

  FruitType? get next {
    final i = index + 1;
    return i < FruitType.values.length ? FruitType.values[i] : null;
  }
}
