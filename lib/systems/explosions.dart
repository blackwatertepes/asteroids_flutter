import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Asteroidio/components/asteroid.dart';
import 'package:Asteroidio/components/explosion.dart';
import 'package:Asteroidio/components/game.dart';

class Explosions {
  Game gameRef;
  List<Asteroid> asteroids;
  List<Explosion> explosions;
  double x;
  double y;

  Explosions(Game _gameRef, double init_x, double init_y, List<Asteroid> init_asteroids) {
    gameRef = _gameRef;
    x = init_x;
    y = init_y;
    asteroids = init_asteroids;

    explosions = List<Explosion>();
  }

  void update(double t) {
    explosions.forEach((Explosion explosion) => explosion.update(t));
    explosions.removeWhere((Explosion explosion) => explosion.done());

    // Collision detection...
    explosions.forEach((Explosion explosion) => this.hasCollidedWithMany(explosion, asteroids));
  }

  void addExplosion(double dx, double dy, double blastRadius) {
    Explosion explosion = new Explosion(dx, dy, blastRadius);
    gameRef.add(explosion);
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
