import 'dart:math';
import 'dart:ui';

class Asteroid {
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
  bool destroyed;
  Function createDebris;

  Asteroid(double init_x, double init_y, double init_direction, Function create_debris) {
    x = init_x;
    y = init_y;
    direction = init_direction;
    createDebris = create_debris;

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

  // Returns whether or not is was destroyed
  bool hit(double strength) {
    size -= strength * 4;
    if (size < minSize) {
      destroy();
      return true;
    }
    return false;
  }

  bool destroy() {
    destroyed = true;
    createDebris(this);
    return destroyed;
  }
}
