import 'dart:math';
import 'dart:ui';

class Player  {
  Rect boxRect;
  Paint boxPaint;
  double x;
  double y;
  double size;
  double angle;

  Player(double init_x, double init_y) {
    x = init_x;
    y = init_y;

    angle = 0;
    size = 10;
  }

  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x - size, y - size)
      ..lineTo(x, y - size / 2)
      ..lineTo(x + size, y - size)
      ..lineTo(x, y + size)
      ..lineTo(x - size, y - size);

    // Transform.rotate(angle: angle, child: path);

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    canvas.drawPath(path, boxPaint);
  }

  @override
  void update(double t) {
  }

  void fireAt(double at_x, double at_y) {
    angle = atan2(y - at_y, x - at_x);
  }
}
