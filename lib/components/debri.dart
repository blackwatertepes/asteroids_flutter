import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Debri extends PositionComponent {
  Rect boxRect;
  Paint boxPaint;
  double length;
  double direction;
  double rotationSpeed;
  double maxRotationSpeed;
  double speed;
  double minSpeed;
  double maxSpeed;
  bool destroyed;

  Debri(double initLength, double initDirection) {
    length = initLength;
    direction = initDirection;
    destroyed = false;

    maxRotationSpeed = 0.04;
    minSpeed = 0.4;
    maxSpeed = 0.8;

    Random rand = Random();

    rotationSpeed = rand.nextDouble() * maxRotationSpeed * 2 - maxRotationSpeed;
    speed = rand.nextDouble() * (maxSpeed - minSpeed) + minSpeed;
  }

  @override
  void update(double t) {
    super.update(t);

    x += cos(direction) * speed;
    y += sin(direction) * speed;
    angle += rotationSpeed;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    Path path = Path()
      ..moveTo(-length / 2 * cos(angle), -length / 2 * sin(angle))
      ..lineTo(length / 2 * cos(angle), length / 2 * sin(angle));

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    c.drawPath(path, boxPaint);
  }

  bool destroy() {
    return destroyed;
  }
}
