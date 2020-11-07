import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Explosion extends PositionComponent {
  Paint boxPaint;
  double blastRadius;
  double maxBlastRadius;
  double blastSpeed;

  Explosion(double _blastRadius) {
    maxBlastRadius = _blastRadius;

    blastRadius = 0;
    blastSpeed = 0.2;
  }

  @override
  void update(double t) {
    super.update(t);

    if (blastRadius < maxBlastRadius) {
      blastRadius += blastSpeed;
    }
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    Random rand = Random();

    c.drawCircle(Offset(0, 0), rand.nextDouble() * blastRadius, boxPaint);
  }

  bool done() {
    return blastRadius >= maxBlastRadius;
  }
}
