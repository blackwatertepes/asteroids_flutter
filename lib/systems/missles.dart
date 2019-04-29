import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/asteroid.dart';
import 'package:asteroids_flutter/components/missle.dart';

class Missles {
  List<Missle> missles;
  List<Asteroid> asteroids;
  double x;
  double y;

  Missles(double init_x, double init_y, List<Asteroid> init_asteroids) {
    x = init_x;
    y = init_y;

    missles = List<Missle>();
    asteroids = init_asteroids;
  }

  @override
  void render(Canvas canvas) {
    missles.forEach((Missle missle) => missle.render(canvas));
  }

  @override
  void update(double t) {
    missles.forEach((Missle missle) => missle.update(t));
    missles.removeWhere((Missle missle) => this.exploded(missle));
  }

  void addMissle(double dx, double dy) {
    double direction = atan2(dy - y, dx - x);
    double distance = sqrt(pow(dx - x, 2) + pow(dy - y, 2)); // * 2
    Missle missle = new Missle(x, y, direction, 2, distance, 20);
    missles.add(missle);
  }

  bool exploded(Missle object) {
    double distance = sqrt(pow(object.x - x, 2) + pow(object.y - y, 2));
    if (distance >= object.dist) {
      // TODO: Create an explosion

      // Collision detection...
      asteroids.forEach((Asteroid asteroid) => this.hasCollided(object, asteroid));

      return true;
    }
    return false;
  }

  void hasCollided(Missle missle, Asteroid asteroid) {
    if (missle.x - asteroid.x < missle.blastRadius + asteroid.size && missle.y - asteroid.y < missle.blastRadius + asteroid.size) {
      double distBetween = sqrt(pow(missle.x - asteroid.x, 2) + pow(missle.y - asteroid.y, 2));
      if (distBetween < missle.blastRadius + asteroid.size) {
        asteroid.destroy();
      }
    }
  }
}
