import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Player extends PositionComponent {
  Rect boxRect;
  Paint boxPaint;
  double size;
  bool destroyed;

  Player() {
    angle = 0;
    size = 20;
    destroyed = false;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    double tri = pi * 2 / 3;
    Path path = Path()
      ..moveTo(cos(angle) * size, sin(angle) * size)
      ..lineTo(cos(tri + angle) * size, sin(tri + angle) * size)
      ..lineTo(cos(tri * 1.5 + angle) * size / 4, sin(tri * 1.5 + angle) * size / 4)
      ..lineTo(cos(tri * 2 + angle) * size, sin(tri * 2 + angle) * size)
      ..lineTo(cos(angle) * size, sin(angle) * size);

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    c.drawPath(path, boxPaint);
  }

  @override
  void update(double t) {
    super.update(t);
  }

  void fireAt(double atX, double atY) {
    angle = atan2(atY - y, atX - x);
  }

  bool destroy() {
    return destroyed;
  }
}
