import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/asteroid.dart';
import 'package:asteroids_flutter/components/explosion.dart';
import 'package:asteroids_flutter/components/missle.dart';

class Missles {
  List<Asteroid> asteroids;
  List<Explosion> explosions;
  List<Missle> missles;
  double x;
  double y;

  Missles(double init_x, double init_y, List<Asteroid> init_asteroids) {
    x = init_x;
    y = init_y;

    explosions = List<Explosion>();
    missles = List<Missle>();
    asteroids = init_asteroids;
  }

  @override
  void render(Canvas canvas) {
    explosions.forEach((Explosion explosion) => explosion.render(canvas));
    missles.forEach((Missle missle) => missle.render(canvas));
  }

  @override
  void update(double t) {
    explosions.forEach((Explosion explosion) => explosion.update(t));
    explosions.removeWhere((Explosion explosion) => explosion.done());

    missles.forEach((Missle missle) => missle.update(t));
    missles.removeWhere((Missle missle) => this.exploded(missle));

    // Collision detection...
    explosions.forEach((Explosion explosion) => this.hasCollidedWithMany(explosion, asteroids));
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
      Explosion explosion = new Explosion(object.x, object.y, object.blastRadius);
      explosions.add(explosion);
      return true;
    }
    return false;
  }

  void hasCollidedWithMany(Explosion explosion, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(explosion, asteroid));
  }

  void hasCollided(Explosion explosion, Asteroid asteroid) {
    if (explosion.x - asteroid.x < explosion.blastRadius + asteroid.size && explosion.y - asteroid.y < explosion.blastRadius + asteroid.size) {
      double distBetween = sqrt(pow(explosion.x - asteroid.x, 2) + pow(explosion.y - asteroid.y, 2));
      if (distBetween < explosion.blastRadius + asteroid.size) {
        asteroid.destroy();
      }
    }
  }
}
