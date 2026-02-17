import 'package:flame/components.dart';

class ScoreManager extends Component {
  int score = 0;
  bool hasWon = false;

  void addScore(int points) {
    score += points;
  }

  void reset() {
    score = 0;
    hasWon = false;
  }
}
