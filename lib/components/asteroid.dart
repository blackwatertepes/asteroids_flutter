import 'dart:math';
import 'dart:ui';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';

class Asteroid extends PositionComponent {
  List<double> randVertices;
  Rect boxRect;
  Paint boxPaint;
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
  bool destroyed;
  // Function createDebris;

  // Asteroid(double initX, double initY, double initDirection, Function _createDebris) {
  Asteroid(double initDirection) {
    direction = initDirection;
    // createDebris = _createDebris;

    minSize = 10;
    maxSize = 20;
    randVertices = List<double>();
    maxRotationSpeed = 0.04;
    minSpeed = 1;
    maxSpeed = 2;
    numVertices = 20;
    noiseMulti = 2;
    destroyed = false;

    Random rand = Random();

    for (int i = 0; i < numVertices; i++) {
      randVertices.add(rand.nextDouble() * noiseMulti * 2 - noiseMulti);
    }

    size = rand.nextDouble() * (maxSize - minSize) + minSize;
    angle = rand.nextDouble() * pi * 2;
    rotationSpeed = rand.nextDouble() * maxRotationSpeed * 2 - maxRotationSpeed;
    speed = rand.nextDouble() * (maxSpeed - minSpeed) + minSpeed;
  }

  @override
  void onMount() {
    anchor = Anchor.center;
  }

  @override
  void update(double t) {
    super.update(t);

    x += cos(direction) * speed;
    y += sin(direction) * speed;
    angle += rotationSpeed;
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    Path path = Path()
      ..moveTo(size * cos(angle), size * sin(angle));

    for (int vert = 0; vert < randVertices.length; vert ++) {
      double randVertice = randVertices[vert];
      double theta = pi * 2 / numVertices * vert;
      path.lineTo((size + randVertice) * cos(theta + angle), (size + randVertice) * sin(theta + angle));
    }

    path.lineTo(size * cos(angle), size * sin(angle));

    boxPaint = Paint();
    boxPaint.color = Color(0xffffffff);
    boxPaint.style = PaintingStyle.stroke;
    boxPaint.strokeWidth = 2;

    c.drawPath(path, boxPaint);
  }

  // Returns whether or not is was destroyed
  bool hit(double strength) {
    size -= strength * 4;
    if (size < minSize) {
      // destroy();
      return true;
    }
    return false;
  }

  bool destroy() {
    // this.createDebris(this);
    return destroyed;
  }
}
