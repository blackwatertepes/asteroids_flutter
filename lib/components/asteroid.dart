import 'dart:math';
import 'dart:ui';
import 'package:flame/components/component.dart';

class Asteroid extends PositionComponent {
  List<double> randVertices;
  Rect boxRect;
  Paint boxPaint;
  double x;
  double y;
  double size;
  double minSize;
  double maxSize;
  double direction;
  double angle;
  double rotationSpeed;
  double maxRotationSpeed;
  double speed;
  double minSpeed;
  double maxSpeed;
  double numVertices;
  double noiseMulti;

  Asteroid(double init_x, double init_y, double init_direction) {
    x = init_x;
    y = init_y;
    direction = init_direction;

    minSize = 10;
    maxSize = 20;
    randVertices = List<double>();
    maxRotationSpeed = 0.04;
    minSpeed = 0.5;
    maxSpeed = 1;
    numVertices = 20;
    noiseMulti = 2;

    Random rand = Random();

    for (int i = 0; i < numVertices; i++) {
      randVertices.add(rand.nextDouble() * noiseMulti * 2 - noiseMulti);
    }

    // direction = rand.nextDouble() * pi * 2;
    size = rand.nextDouble() * (maxSize - minSize) + minSize;
    angle = rand.nextDouble() * pi * 2;
    rotationSpeed = rand.nextDouble() * maxRotationSpeed * 2 - maxRotationSpeed;
    speed = rand.nextDouble() * (maxSpeed - minSpeed) * 2 - maxSpeed;

    if (speed > 0) {
      speed += minSpeed;
    } else {
      speed -= minSpeed;
    }
  }

  @override
  void render(Canvas canvas) {
    Path path = Path()
      ..moveTo(x + size * cos(angle), y + size * sin(angle));

    for (int vert = 0; vert < randVertices.length; vert ++) {
      double randVertice = randVertices[vert];
      double theta = pi * 2 / numVertices * vert;
      path.lineTo(x + (size + randVertice) * cos(theta + angle), y + (size + randVertice) * sin(theta + angle));
    }

    path.lineTo(x + size * cos(angle), y + size * sin(angle));

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
