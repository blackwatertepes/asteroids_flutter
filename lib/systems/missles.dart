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
    missles.removeWhere((Missle missle) => this.exploded(missle));
  }

  void addMissle(double dx, double dy) {
    double direction = atan2(dy - y, dx - x);
    double distance = sqrt(pow(dx - x, 2) + pow(dy - y, 2)); // * 2
    Missle missle = new Missle(x, y, direction, 2, distance);
    missles.add(missle);
  }

  bool exploded(Missle object) {
    double distance = sqrt(pow(object.x - x, 2) + pow(object.y - y, 2));
    if (distance >= object.dist) {
      // Create an explosion
      return true;
    }
    return false;
  }
}
