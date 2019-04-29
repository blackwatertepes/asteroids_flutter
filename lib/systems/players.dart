import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/asteroid.dart';
import 'package:asteroids_flutter/components/player.dart';

class Players {
  List<Asteroid> asteroids;
  List<Player> players;
  double x;
  double y;

  Players(double init_x, double init_y, List<Asteroid> init_asteroids) {
    x = init_x;
    y = init_y;

    players = List<Player>();
    asteroids = init_asteroids;

    addPlayer(x, y);
  }

  @override
  void render(Canvas canvas) {
    players.forEach((Player player) => player.render(canvas));
  }

  @override
  void update(double t) {
    players.forEach((Player player) => player.update(t));
    players.removeWhere((Player player) => player.destroyed);

    // Collision detection...
    players.forEach((Player player) => this.hasCollidedWithMany(player, asteroids));
  }

  void addPlayer(double dx, double dy) {
    Player player = new Player(x, y);
    players.add(player);
  }

  bool fireAt(double dx, double dy) {
    players.forEach((Player player) => player.fireAt(dx, dy));
    return players.length > 0;
  }

  void hasCollidedWithMany(Player player, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(player, asteroid));
  }

  void hasCollided(Player player, Asteroid asteroid) {
    if (player.x - asteroid.x < player.size + asteroid.size && player.y - asteroid.y < player.size + asteroid.size) {
      double distBetween = sqrt(pow(player.x - asteroid.x, 2) + pow(player.y - asteroid.y, 2));
      if (distBetween < player.size + asteroid.size) {
        player.destroy();
      }
    }
  }
}
