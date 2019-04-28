import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components/component.dart';
import 'package:asteroids_flutter/components/asteroid.dart';

void main() => runApp(MyGame().widget);

class MyGame extends BaseGame {
  List<Asteroid> asteroids;
  List<Asteroid> destroyable;
  double spawnRadius; // Where asteroids spawn
  double boundRadius; // Where asteroids die
  double directionNoise; // How much asteroids stray from center
  double spawnRate; // How quickly new asteroids spawn

  MyGame() {
    asteroids = List<Asteroid>();
    destroyable = List<Asteroid>();
    spawnRadius = 300;
    boundRadius = 400;
    directionNoise = 0.8;
    spawnRate = 0.1;
  }

  @override
  void render(Canvas canvas) {
    String text = "Score: 0";
    TextPainter textPainter = Flame.util.text(text, color: Colors.white, fontSize: 14.0);
    textPainter.paint(canvas, Offset(size.width - 80, 30));

    asteroids.forEach((Asteroid asteroid) => asteroid.render(canvas));
  }

  @override
  void update(double t) {
    Random rand = Random();
    if (rand.nextDouble() < spawnRate) {
      double location = rand.nextDouble() * pi * 2;
      double x = size.width / 2 + cos(location) * spawnRadius;
      double y = size.height / 2 + sin(location) * spawnRadius;
      double direction = atan2(size.height / 2 - y, size.width / 2 - x) + pi + rand.nextDouble() * directionNoise * 2 - directionNoise;
      Asteroid asteroid = new Asteroid(x, y, direction);
      add(asteroid);
      asteroids.add(asteroid);
    }

    asteroids.forEach((Asteroid asteroid) => asteroid.update(t));
    asteroids.removeWhere((Asteroid asteroid) => this.offScreen(asteroid));

    // Collision detection...
    asteroids.forEach((Asteroid asteroid) => this.hasCollidedWithMany(asteroid, asteroids));
    destroyable.forEach((Asteroid asteroid) => asteroids.remove(asteroid));
    destroyable.clear();
  }

  void hasCollidedWithMany(Asteroid object_a, List<Asteroid> objects) {
    objects.forEach((Asteroid object_b) => this.hasCollided(object_a, object_b));
  }

  void hasCollided(Asteroid object_a, Asteroid object_b) {
    double distBetween = sqrt(pow(object_a.x - object_b.x, 2) + pow(object_a.y - object_b.y, 2));
    if (object_a != object_b && distBetween < object_a.size + object_b.size) {
      destroyable.add(object_a);
      destroyable.add(object_b);
    }
  }

  bool offScreen(PositionComponent object) {
    double distFromCenter = sqrt(pow(size.width / 2 - object.x, 2) + pow(size.height / 2 - object.y, 2));
    if (distFromCenter > boundRadius) {
      return true;
    }
    return false;
  }
}
