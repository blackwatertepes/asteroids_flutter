import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Explosion extends PositionComponent {
  Paint boxPaint;
  double x;
  double y;
  double blastRadius;
  double maxBlastRadius;
  double blastSpeed;

  Explosion(double init_x, double init_y, double init_blast_radius) {
    x = init_x;
    y = init_y;
    maxBlastRadius = init_blast_radius;

    blastRadius = 0;
    blastSpeed = 0.2;
  }

  @override
  void render(Canvas canvas) {
    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    Random rand = Random();

    canvas.drawCircle(Offset(x, y), rand.nextDouble() * blastRadius, boxPaint);
  }

  @override
  void update(double t) {
    if (blastRadius < maxBlastRadius) {
      blastRadius += blastSpeed;
    }
  }

  bool done() {
    return blastRadius >= maxBlastRadius;
  }
}
