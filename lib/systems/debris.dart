import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Asteroidio/components/asteroid.dart';
import 'package:Asteroidio/components/debri.dart';
import 'package:Asteroidio/components/game.dart';

class Debris {
  Game gameRef;
  List<Debri> debris;
  double screenWidth;
  double screenHeight;

  Debris(Game _gameRef, double init_screenWidth, double init_screenHeight) {
    gameRef = _gameRef;
    screenWidth = init_screenWidth;
    screenHeight = init_screenHeight;

    debris = List<Debri>();
  }

  void update(double t) {
    Random rand = Random();

    debris.forEach((Debri debri) => debri.update(t));
    debris.removeWhere((Debri debri) => this.offScreen(debri));
  }

  void createDebris(Asteroid asteroid) {
    if (asteroid.destroyed) {
      double amount = asteroid.numVertices / 2;
      for (int vert = 0; vert < amount; vert++) {
        double theta = pi * 2 / amount * vert;
        double x = asteroid.x + asteroid.size * cos(theta);
        double y = asteroid.y + asteroid.size * sin(theta);
        double length = asteroid.size * 2 * pi / amount;
        double angle = theta + pi / 2;
        double direction = theta;

        Debri debri = Debri(x, y, length, angle, direction);
        gameRef.add(debri);
        debris.add(debri);
      }
    }
  }

  bool offScreen(Debri object) {
    double margin = 10;
    if (object.x < 0 - margin || object.y < 0 - margin || object.x > screenWidth + margin || object.y > screenHeight + margin) {
      return true;
    }
    return false;
  }
}
