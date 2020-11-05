import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Asteroidio/components/asteroid.dart';
import 'package:Asteroidio/components/game.dart';
import 'package:Asteroidio/components/missle.dart';

class Missles {
  Game gameRef;
  List<Asteroid> asteroids;
  List<Missle> missles;
  double x;
  double y;
  Function addExplosion;

  Missles(Game _gameRef, double init_x, double init_y, List<Asteroid> init_asteroids, Function init_add_explosion) {
    gameRef = _gameRef;
    x = init_x;
    y = init_y;
    addExplosion = init_add_explosion;

    missles = List<Missle>();
    asteroids = init_asteroids;
  }

  void update(double t) {
    missles.forEach((Missle missle) => missle.update(t));
    missles.removeWhere((Missle missle) => this.exploded(missle) || missle.destroyed);

    // Collision detection...
    missles.forEach((Missle missle) => this.hasCollidedWithMany(missle, asteroids));
  }

  void addMissle(double dx, double dy) {
    double direction = atan2(dy - y, dx - x);
    double distance = sqrt(pow(dx - x, 2) + pow(dy - y, 2)); // * 2
    Missle missle = new Missle(x, y, direction, distance, 20);
    gameRef.add(missle);
    missles.add(missle);
  }

  bool exploded(Missle object) {
    double distance = sqrt(pow(object.x - x, 2) + pow(object.y - y, 2));
    if (distance >= object.dist) {
      addExplosion(object.x, object.y, object.blastRadius);
      return true;
    }
    return false;
  }

  void hasCollidedWithMany(Missle missle, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(missle, asteroid));
  }

  void hasCollided(Missle missle, Asteroid asteroid) {
    if (missle.x - asteroid.x < asteroid.size && missle.y - asteroid.y < asteroid.size) {
      double distBetween = sqrt(pow(missle.x - asteroid.x, 2) + pow(missle.y - asteroid.y, 2));
      if (distBetween < asteroid.size) {
        missle.destroy();
      }
    }
  }
}
