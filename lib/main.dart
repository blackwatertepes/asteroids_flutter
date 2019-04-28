import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/components/component.dart';
import 'package:asteroids_flutter/components/asteroid.dart';

void main() => runApp(MyGame().widget);

class MyGame extends BaseGame {
  List<Asteroid> asteroids;
  double spawnRadius; // Where asteroids spawn
  double boundRadius; // Where asteroids die
  double directionNoise; // How much asteroids stray from center

  MyGame() {
    asteroids = List<Asteroid>();
    spawnRadius = 300;
    boundRadius = 400;
    directionNoise = 1.0;
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
    if (rand.nextDouble() < 0.1) {
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
  }

  bool offScreen(PositionComponent object) {
    double distFromCenter = sqrt(pow(size.width / 2 - object.x, 2) + pow(size.height / 2 - object.y, 2));
    if (distFromCenter > boundRadius) {
      return true;
    }
    return false;
  }
}
