import 'dart:math';

class CordsGenerator {
  final maxY = 60;
  final minY = -60;
  final maxX = 80;
  final minX = -80;

  final step = 2;
  var xCur = 0;
  var yCur = 0;
  var yDir = 1;
  var xDir = 1;

  (int x, int y, int speed) getNextCords() {
    final changeXDir = Random().nextInt(100);
    final changeYDir = Random().nextInt(100);
    final randXShift = Random().nextInt(4) - 2;
    final randYShift = Random().nextInt(4) - 2;
    final newX = xCur + (step * xDir) + randXShift;
    final newY = yCur + (step * yDir) + randYShift;
    final dx = (newX - xCur).abs();
    final dy = (newY - yCur).abs();
    if (changeXDir <= 10) { // Шанс 10% что изменится направление
      xDir *= -1;
    }
    if (changeYDir <= 10) {
      yDir *= -1;
    }

    if (newX >= maxX) xDir = -1;
    if (newX <= minX) xDir = 1;
    if (newY >= maxY) yDir = -1;
    if (newY <= minY) yDir = 1;

    xCur = newX;
    yCur = newY;
    final speed = dx + dy + 3;
    return (newX, newY, speed);
  }
}