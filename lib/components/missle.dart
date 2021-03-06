import 'dart:math';
import 'dart:ui';

class Missle {
  Rect boxRect;
  Paint boxPaint;
  double x;
  double y;
  double direction;
  double length;
  double width;
  double speed;
  double dist;
  double blastRadius;
  bool destroyed;

  Missle(double init_x, double init_y, double init_direction, double init_distance, double init_blast_radius) {
    x = init_x;
    y = init_y;
    direction = init_direction;
    dist = init_distance;
    blastRadius = init_blast_radius;

    Random rand = Random();

    length = 10;
    width =  0.1;
    speed = 4;
    destroyed = false;
  }

  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x, y)
      ..lineTo(x - cos(direction + width) * length, y - sin(direction + width) * length)
      ..lineTo(x - cos(direction - width) * length, y - sin(direction - width) * length)
      ..lineTo(x, y);

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

  bool destroy() {
    destroyed = true;
    return destroyed;
  }
}
