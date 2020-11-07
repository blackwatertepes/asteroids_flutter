import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Missle extends PositionComponent {
  Rect boxRect;
  Paint boxPaint;
  double direction;
  double length;
  double width;
  double speed;
  double dist;
  double blastRadius;
  bool destroyed;

  Missle(double _direction, double _distance, double _blastRadius) {
    direction = _direction;
    dist = _distance;
    blastRadius = _blastRadius;

    length = 10;
    width =  0.1;
    speed = 4;
    destroyed = false;
  }

  @override
  void update(double t) {
    super.update(t);

    x += cos(direction) * speed;
    y += sin(direction) * speed;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(cos(direction + width) * length, sin(direction + width) * length)
      ..lineTo(cos(direction - width) * length, sin(direction - width) * length)
      ..lineTo(0, 0);

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
