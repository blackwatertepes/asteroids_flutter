import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Player extends PositionComponent {
  Rect boxRect;
  Paint boxPaint;
  double size;
  double angle;
  bool destroyed;

  Player() {
    angle = 0;
    size = (width + height) / 2;
    destroyed = false;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    double tri = pi * 2 / 3;
    Path path = Path()
      ..moveTo(x + cos(angle) * size, y + sin(angle) * size)
      ..lineTo(x + cos(tri + angle) * size, y + sin(tri + angle) * size)
      ..lineTo(x + cos(tri * 1.5 + angle) * size / 4, y + sin(tri * 1.5 + angle) * size / 4)
      ..lineTo(x + cos(tri * 2 + angle) * size, y + sin(tri * 2 + angle) * size)
      ..lineTo(x + cos(angle) * size, y + sin(angle) * size);

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    width = 100;
    height = 100;

    c.drawPath(path, boxPaint);

    c.drawRect(Rect.fromLTWH(0, 0, width, height), boxPaint);
  }

  @override
  void update(double t) {
    super.update(t);
  }

  void fireAt(double atX, double atY) {
    angle = atan2(atY - y, atX - x);
  }

  // bool destroy() {
  //   destroyed = true;
  //   return destroyed;
  // }
}
