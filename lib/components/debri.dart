import 'dart:math';
import 'dart:ui';

class Debri {
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

  Debri(double init_x, double init_y, double init_length, double init_angle, double init_direction) {
    x = init_x;
    y = init_y;
    length = init_length;
    angle = init_angle;
    direction = init_direction;

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
    x += cos(direction) * speed;
    y += sin(direction) * speed;
    angle += rotationSpeed;
  }
}
