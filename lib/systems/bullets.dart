import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/asteroid.dart';
import 'package:asteroids_flutter/components/bullet.dart';

class Bullets {
  List<Bullet> bullets;
  List<Asteroid> asteroids;
  double x;
  double y;

  Bullets(double init_x, double init_y, List<Asteroid> init_asteroids) {
    x = init_x;
    y = init_y;

    bullets = List<Bullet>();
    asteroids = init_asteroids;
  }

  @override
  void render(Canvas canvas) {
    bullets.forEach((Bullet bullet) => bullet.render(canvas));
  }

  @override
  void update(double t) {
    bullets.forEach((Bullet bullet) => bullet.update(t));
    bullets.removeWhere((Bullet bullet) => this.offScreen(bullet));

    // Collision detection...
    bullets.forEach((Bullet bullet) => this.hasCollidedWithMany(bullet, asteroids));
    bullets.removeWhere((Bullet bullet) => bullet.destroyed);
  }

  void hasCollidedWithMany(Bullet bullet, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(bullet, asteroid));
  }

  void hasCollided(Bullet bullet, Asteroid asteroid) {
    if (bullet.x - asteroid.x < asteroid.size && bullet.y - asteroid.y < asteroid.size) {
      double distBetween = sqrt(pow(bullet.x - asteroid.x, 2) + pow(bullet.y - asteroid.y, 2));
      if (distBetween < asteroid.size) {
        bullet.destroy();
        asteroid.hit(0.75);
      }
    }
  }

  void addBullet(double dx, double dy) {
    double direction = atan2(dy - y, dx - x);
    Bullet bullet = new Bullet(x, y, direction);
    bullets.add(bullet);
  }

  bool offScreen(Bullet object) {
    if (object.x < 0 || object.y < 0 || object.x > x * 2 || object.y > y * 2) {
      return true;
    }
    return false;
  }
}
