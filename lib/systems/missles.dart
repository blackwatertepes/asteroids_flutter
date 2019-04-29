import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/missle.dart';

class Missles {
  List<Missle> missles;
  double x;
  double y;

  Missles(double init_x, double init_y) {
    x = init_x;
    y = init_y;

    missles = List<Missle>();
  }

  @override
  void render(Canvas canvas) {
    missles.forEach((Missle missle) => missle.render(canvas));
  }

  @override
  void update(double t) {
    missles.forEach((Missle missle) => missle.update(t));
    missles.removeWhere((Missle missle) => this.offScreen(missle));

    // Collision detection...
    // bullets.forEach((Bullet bullet) => this.hasCollidedWithMany(bullet, asteroids));
    // destroyable.forEach((Asteroid asteroid) => asteroids.remove(asteroid));
    // destroyable.clear();
  }

  // void hasCollidedWithMany(Asteroid object_a, List<Asteroid> objects) {
  //   objects.forEach((Asteroid object_b) => this.hasCollided(object_a, object_b));
  // }

  // void hasCollided(Asteroid object_a, Asteroid object_b) {
  //   double distToHit = object_a.size + object_b.size;
  //   if (object_a.x - object_b.x < distToHit && object_a.y - object_b.y < distToHit) {
  //     double distBetween = sqrt(pow(object_a.x - object_b.x, 2) + pow(object_a.y - object_b.y, 2));
  //     if (object_a != object_b && distBetween < distToHit) {
  //       destroyable.add(object_a);
  //       destroyable.add(object_b);
  //     }
  //   }
  // }

  void addMissle(double dx, double dy) {
    double direction = atan2(dy - y, dx - x);
    Missle missle = new Missle(x, y, direction, 2);
    missles.add(missle);
  }

  bool offScreen(Missle object) {
    if (object.x < 0 || object.y < 0 || object.x > x * 2 || object.y > y * 2) {
      return true;
    }
    return false;
  }
}
