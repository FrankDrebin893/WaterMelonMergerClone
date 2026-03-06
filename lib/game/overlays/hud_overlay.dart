import 'package:flutter/material.dart';

import '../data/fruit_type.dart';
import '../fruit_drop_game.dart';

class HudOverlay extends StatelessWidget {
  final FruitDropGame game;

  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Score
            ValueListenableBuilder<int>(
              valueListenable: game.scoreNotifier,
              builder: (context, score, _) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Score: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),

            // Bomb button
            ValueListenableBuilder<int>(
              valueListenable: game.bombCountNotifier,
              builder: (context, count, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: game.bombActiveNotifier,
                  builder: (context, active, _) {
                    final available = count > 0 && !active;
                    return GestureDetector(
                      onTap: available ? () => game.activateBomb() : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFFF6600)
                              : available
                                  ? Colors.black54
                                  : Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                          border: active
                              ? Border.all(
                                  color: const Color(0xFFFFDD00), width: 2.5)
                              : null,
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFFF6600)
                                        .withValues(alpha: 0.6),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('💣',
                                style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 4),
                            Text(
                              active ? 'READY' : '×$count',
                              style: TextStyle(
                                color: available || active
                                    ? Colors.white
                                    : Colors.white38,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Next fruit indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Next: ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  ValueListenableBuilder<FruitType>(
                    valueListenable: game.nextFruitNotifier,
                    builder: (context, fruit, _) {
                      return Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: fruit.color,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
