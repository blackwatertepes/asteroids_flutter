import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/asteroid.dart';
import 'package:asteroids_flutter/components/explosion.dart';

class Explosions {
  List<Asteroid> asteroids;
  List<Explosion> explosions;
  double x;
  double y;

  Explosions(double init_x, double init_y, List<Asteroid> init_asteroids) {
    x = init_x;
    y = init_y;
    asteroids = init_asteroids;

    explosions = List<Explosion>();
  }

  @override
  void render(Canvas canvas) {
    explosions.forEach((Explosion explosion) => explosion.render(canvas));
  }

  @override
  void update(double t) {
    explosions.forEach((Explosion explosion) => explosion.update(t));
    explosions.removeWhere((Explosion explosion) => explosion.done());

    // Collision detection...
    explosions.forEach((Explosion explosion) => this.hasCollidedWithMany(explosion, asteroids));
  }

  void addExplosion(double dx, double dy, double blastRadius) {
    Explosion explosion = new Explosion(dx, dy, blastRadius);
    explosions.add(explosion);
  }

  void hasCollidedWithMany(Explosion explosion, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(explosion, asteroid));
  }

  void hasCollided(Explosion explosion, Asteroid asteroid) {
    if (explosion.x - asteroid.x < explosion.blastRadius + asteroid.size && explosion.y - asteroid.y < explosion.blastRadius + asteroid.size) {
      double distBetween = sqrt(pow(explosion.x - asteroid.x, 2) + pow(explosion.y - asteroid.y, 2));
      if (distBetween < explosion.blastRadius + asteroid.size) {
        asteroid.hit(1);
      }
    }
  }
}
