import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/asteroid.dart';
import 'package:asteroids_flutter/components/missle.dart';

class Missles {
  List<Asteroid> asteroids;
  List<Missle> missles;
  double x;
  double y;
  Function addExplosion;

  Missles(double init_x, double init_y, List<Asteroid> init_asteroids, Function init_add_explosion) {
    x = init_x;
    y = init_y;
    addExplosion = init_add_explosion;

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

    // Collision detection...
    // explosions.forEach((Explosion explosion) => this.hasCollidedWithMany(explosion, asteroids));
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
      addExplosion(object.x, object.y, object.blastRadius);
      return true;
    }
    return false;
  }

  // void hasCollidedWithMany(Explosion explosion, List<Asteroid> asteroids) {
  //   asteroids.forEach((Asteroid asteroid) => this.hasCollided(explosion, asteroid));
  // }

  // void hasCollided(Explosion explosion, Asteroid asteroid) {
  //   if (explosion.x - asteroid.x < explosion.blastRadius + asteroid.size && explosion.y - asteroid.y < explosion.blastRadius + asteroid.size) {
  //     double distBetween = sqrt(pow(explosion.x - asteroid.x, 2) + pow(explosion.y - asteroid.y, 2));
  //     if (distBetween < explosion.blastRadius + asteroid.size) {
  //       asteroid.hit(1);
  //     }
  //   }
  // }
}
