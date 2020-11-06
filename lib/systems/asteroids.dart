import 'dart:math';
// import 'package:flame/components/mixins/has_game_ref.dart';
// import 'package:flutter/material.dart';
import 'package:Asteroidio/components/asteroid.dart';
import 'package:Asteroidio/components/game.dart';

class Asteroids {
  Game gameRef;
  List<Asteroid> asteroids;
  double spawnRadius; // Where asteroids spawn
  double boundRadius; // Where asteroids die
  double directionNoise; // How much asteroids stray from center
  double spawnRate; // How quickly new asteroids spawn
  double minSpawnRate;
  double maxSpawnRate;
  double spawnGrowthRate;
  double sizeWidth;
  double sizeHeight;
  bool running;
  // Function createDebris;

  // Asteroids(Game _gameRef, double init_sizeWidth, double init_sizeHeight, Function create_debris) {
  Asteroids(Game _gameRef, double initSizeWidth, double initSizeHeight) {
    gameRef = _gameRef;
    sizeWidth = initSizeWidth;
    sizeHeight = initSizeHeight;
    // createDebris = create_debris;

    asteroids = List<Asteroid>();
    spawnRadius = (sizeWidth + sizeHeight) / 2;
    boundRadius = spawnRadius + 10;
    directionNoise = 0.8;
    minSpawnRate = 0.01;
    maxSpawnRate = 0.1;
    spawnGrowthRate = 0.002 / 60; // @ 60fps, .002 is 50 seconds
    spawnRate = minSpawnRate;
    running = false;
  }

  void update(double t) {
    Random rand = Random();
    if (rand.nextDouble() < spawnRate) {
      double location = rand.nextDouble() * pi * 2;
      double x = sizeWidth / 2 + cos(location) * spawnRadius;
      double y = sizeHeight / 2 + sin(location) * spawnRadius;
      double direction = atan2(sizeHeight / 2 - y, sizeWidth / 2 - x) + rand.nextDouble() * directionNoise * 2 - directionNoise;
      Asteroid asteroid = new Asteroid(200, 200, direction);//(x, y, direction);//, createDebris);
      gameRef.add(asteroid);
      asteroids.add(asteroid);
    }

    if (running && spawnRate < maxSpawnRate) {
      spawnRate += spawnGrowthRate;
    }

    // asteroids.forEach((Asteroid asteroid) => asteroid.update(t));
    // asteroids.removeWhere((Asteroid asteroid) => this.offScreen(asteroid) || asteroid.destroyed);

    // Collision detection...
    // asteroids.forEach((Asteroid asteroid) => this.hasCollidedWithMany(asteroid, asteroids));
  }

  void hasCollidedWithMany(Asteroid objectA, List<Asteroid> objects) {
    objects.forEach((Asteroid objectB) => this.hasCollided(objectA, objectB));
  }

  void hasCollided(Asteroid objectA, Asteroid objectB) {
    double distToHit = objectA.size + objectB.size;
    if (objectA.x - objectB.x < distToHit && objectA.y - objectB.y < distToHit) {
      double distBetween = sqrt(pow(objectA.x - objectB.x, 2) + pow(objectA.y - objectB.y, 2));
      if (objectA != objectB && distBetween < distToHit) {
        objectA.hit(0.5);
        objectB.hit(0.5);

        // Reflection/Bounce...
        double angle = atan2(objectA.y - objectB.y, objectA.x - objectB.x);
        double normal = angle + pi;
        if (!objectA.destroyed) {
          objectB.direction = reflection(objectB.direction, normal);
        }
        if (!objectB.destroyed) {
          objectA.direction = reflection(objectA.direction, normal);
        }
      }
    }
  }

  void start() {
    running = true;
  }

  void stop() {
    running = false;
    spawnRate = minSpawnRate;
  }

  double reflection(direction, normal) {
    double dx = cos(direction);
    double dy = sin(direction);
    double nx = cos(normal);
    double ny = sin(normal);
    double rx = dx - 2 * dx * pow(nx, 2);
    double ry = dy - 2 * dy * pow(ny, 2);
    return atan2(ry, rx);
  }

  bool offScreen(Asteroid object) {
    double distFromCenter = sqrt(pow(sizeWidth / 2 - object.x, 2) + pow(sizeHeight / 2 - object.y, 2));
    if (distFromCenter > boundRadius) {
      return true;
    }
    return false;
  }
}
