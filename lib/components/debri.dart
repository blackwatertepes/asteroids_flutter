import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Debri extends PositionComponent {
  Rect boxRect;
  Paint boxPaint;
  double x;
  double y;
  double length;
  double direction;
  double angle;
  double rotationSpeed;
  double maxRotationSpeed;
  double speed;
  double minSpeed;
  double maxSpeed;

  Debri(double initX, double initY, double initLength, double initAngle, double initDirection) {
    x = initX;
    y = initY;
    length = initLength;
    angle = initAngle;
    direction = initDirection;

    maxRotationSpeed = 0.04;
    minSpeed = 0.4;
    maxSpeed = 0.8;

    Random rand = Random();

    rotationSpeed = rand.nextDouble() * maxRotationSpeed * 2 - maxRotationSpeed;
    speed = rand.nextDouble() * (maxSpeed - minSpeed) + minSpeed;
  }

  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x - length / 2 * cos(angle), y - length / 2 * sin(angle))
      ..lineTo(x + length / 2 * cos(angle), y + length / 2 * sin(angle));

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    canvas.drawPath(path, boxPaint);
  }

  @override
  void update(double t) {
    super.update(t);

    x += cos(direction) * speed;
    y += sin(direction) * speed;
    angle += rotationSpeed;
  }
}
