import 'dart:math';
import 'package:flutter/material.dart';
import 'package:asteroids_flutter/components/asteroid.dart';
import 'package:asteroids_flutter/components/player.dart';

class Players {
  List<Asteroid> asteroids;
  List<Player> players;
  double x;
  double y;
  Function endGame;
  Function addMissle;
  Function addBullet;
  Function addProjectile;

  Players(double init_x, double init_y, List<Asteroid> init_asteroids, Function end_game, Function add_missle, Function add_bullet) {
    x = init_x;
    y = init_y;
    endGame = end_game;
    addMissle = add_missle;
    addBullet = add_bullet;

    players = List<Player>();
    asteroids = init_asteroids;

    addProjectile = addBullet;
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

  void addPlayer() {
    Player player = new Player(x, y);
    players.add(player);
  }

  bool fireAt(double dx, double dy) {
    players.forEach((Player player) => player.fireAt(dx, dy));
    addProjectile(dx, dy);
    return players.length > 0;
  }

  void switchGun() {
    if (addProjectile == addBullet) {
      addProjectile = addMissle;
    } else {
      addProjectile = addBullet;
    }
  }

  void hasCollidedWithMany(Player player, List<Asteroid> asteroids) {
    asteroids.forEach((Asteroid asteroid) => this.hasCollided(player, asteroid));
  }

  void hasCollided(Player player, Asteroid asteroid) {
    if (player.x - asteroid.x < player.size + asteroid.size && player.y - asteroid.y < player.size + asteroid.size) {
      double distBetween = sqrt(pow(player.x - asteroid.x, 2) + pow(player.y - asteroid.y, 2));
      if (distBetween < player.size + asteroid.size) {
        player.destroy();
        endGame();
      }
    }
  }
}
