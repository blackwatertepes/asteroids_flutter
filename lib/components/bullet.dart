import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Bullet extends PositionComponent {
  Rect boxRect;
  Paint boxPaint;
  double direction;
  double size;
  double speed;
  bool destroyed;

  Bullet(double initDirection) {
    direction = initDirection;
    speed = 8;
    size = speed;
    destroyed = false;
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
    super.update(t);

    x += cos(direction) * speed;
    y += sin(direction) * speed;
  }

  bool destroy() {
    return destroyed;
  }
}
