import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Bullet extends PositionComponent {
  Rect boxRect;
  Paint boxPaint;
  double x;
  double y;
  double direction;
  double size;
  double speed;

  Bullet(double init_x, double init_y, double init_direction, double init_speed) {
    x = init_x;
    y = init_y;
    direction = init_direction;
    speed = init_speed;

    Random rand = Random();

    size = init_speed * 2;
  }

  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x, y)
      ..lineTo(x + cos(direction) * size, y + sin(direction) * size);

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
  }
}