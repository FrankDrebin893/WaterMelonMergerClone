import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../components/explosion_effect.dart';
import '../components/fruit_body.dart';
import '../fruit_drop_game.dart';
import 'score_manager.dart';

class MergeManager extends Component {
  final Queue<(FruitBody, FruitBody)> _mergeQueue = Queue();
  FruitDropWorld? _world;
  FruitDropGame? _game;

  void enqueueMerge(FruitBody a, FruitBody b) {
    _mergeQueue.add((a, b));
  }

  void clear() {
    _mergeQueue.clear();
  }

  @override
  void onMount() {
    super.onMount();
    _world = parent as FruitDropWorld?;
    _game = _world?.parent as FruitDropGame?;
  }

  @override
  void update(double dt) {
    final w = _world;
    if (w == null) return;

    while (_mergeQueue.isNotEmpty) {
      final (a, b) = _mergeQueue.removeFirst();

      if (!a.isMounted || !b.isMounted) continue;

      final midpoint = (a.body.position + b.body.position) / 2;
      final mergedType = a.fruitType.next;
      final explosionRadius = a.fruitType.radius * 5;
      final fruitType = a.fruitType;

      a.removeFromParent();
      b.removeFromParent();

      // Spawn explosion effect
      w.add(ExplosionEffect(
        position: midpoint.clone(),
        fruitType: fruitType,
      ));

      if (mergedType != null) {
        w.add(FruitBody(fruitType: mergedType, position: midpoint.clone()));

        final scoreManager =
            w.children.whereType<ScoreManager>().firstOrNull;
        scoreManager?.addScore(mergedType.score);
      } else {
        final scoreManager =
            w.children.whereType<ScoreManager>().firstOrNull;
        scoreManager?.addScore(50);
        scoreManager?.hasWon = true;
        _game?.onWin();
        return;
      }

      _applyExplosionForce(w, midpoint, explosionRadius);
    }
  }

  void _applyExplosionForce(
      FruitDropWorld w, Vector2 center, double explosionRadius) {
    for (final child in w.children.whereType<FruitBody>()) {
      if (child.pendingRemoval || !child.isMounted) continue;
      final dist = child.body.position.distanceTo(center);
      if (dist < explosionRadius && dist > 0.01) {
        final direction = (child.body.position - center).normalized();
        final strength = (1.0 - dist / explosionRadius) * 45.0;
        final impulse = direction * strength;
        // Extra horizontal push for more scatter
        impulse.x *= 1.4;
        child.body.applyLinearImpulse(impulse);
      }
    }
  }
}
