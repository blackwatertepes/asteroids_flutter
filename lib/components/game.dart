import 'dart:math';
import 'dart:ui';
// import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
// import 'package:flame/util.dart';
import 'package:Asteroidio/components/asteroid.dart';
import 'package:Asteroidio/components/debri.dart';
import 'package:Asteroidio/components/player.dart';
import 'package:Asteroidio/components/time.dart';
// import 'package:flutter/semantics.dart';
// import 'package:Asteroidio/systems/bullets.dart';
// import 'package:Asteroidio/systems/explosions.dart';
// import 'package:Asteroidio/systems/missles.dart';

class Game extends BaseGame {
  Time time;
  Size screenSize;
  // TapGestureRecognizer tapper;
  // Util flameUtil;
  bool inProgress;
  double switchGunRadius;
  int gameEndedAt;
  int restartDelay;
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
  Player player;

  Game() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());

    // bullets =  new Bullets(this, screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    // explosions =  new Explosions(this, screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    // missles =  new Missles(this, screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, explosions.addExplosion);
    time = new Time(screenSize.width, screenSize.height);
    // tapper = TapGestureRecognizer();
    // flameUtil = Util();

    add(time);

    // tapper.onTapDown = onTapDown;
    // flameUtil.addGestureRecognizer(tapper);

    inProgress = false;
    switchGunRadius = 20;
    gameEndedAt = 0;
    restartDelay = 1000;
    spawnRadius = (screenSize.width + screenSize.height) / 2;
    boundRadius = spawnRadius + 10;
    directionNoise = 0.8;
    minSpawnRate = 0.01;
    maxSpawnRate = 0.1;
    spawnGrowthRate = 0.002 / 60; // @ 60fps, .002 is 50 seconds
    spawnRate = minSpawnRate;
    running = false;

    // FIXME: Just for development...
    startGame();
  }

  @override
  void update(double t) {
    super.update(t);

    Random rand = Random();
    if (rand.nextDouble() < spawnRate) {
      double location = rand.nextDouble() * pi * 2;
      double x = screenSize.width / 2 + cos(location) * spawnRadius;
      double y = screenSize.height / 2 + sin(location) * spawnRadius;
      double direction = atan2(screenSize.height / 2 - y, screenSize.width / 2 - x) + rand.nextDouble() * directionNoise * 2 - directionNoise;
      Asteroid asteroid = new Asteroid(direction)
        ..x = x
        ..y = y;
      add(asteroid);
    }

    if (running && spawnRate < maxSpawnRate) {
      spawnRate += spawnGrowthRate;
    }

    offscreenAsteroids().forEach((c) {
      c.destroyed = true;
    });

    offscreenDebris().forEach((c) {
      c.destroyed = true;
    });

    // Collision detection...
    asteroids().forEach((asteroid) => hasCollidedWithMany(asteroid, asteroids()));

    // Collision detection...
    if (player != null) {
      hasCollidedWithManyPlayer(player, asteroids());
    }

  //   bullets.update(t);
  //   explosions.update(t);
  //   missles.update(t);
  //   players.update(t);
  }

  List<dynamic> asteroids() {
    return components.where((c) => c is Asteroid).toList();
  }

  List<dynamic> offscreenAsteroids() {
    return asteroids().where((c) => offScreenAsteroid(c)).toList();
  }

  List<dynamic> debris() {
    return components.where((c) => c is Debri).toList();
  }
  
  List<dynamic> offscreenDebris() {
    return debris().where((c) => offScreenDebri(c)).toList();
  }

  void resize(Size size) {
    super.resize(size);

    screenSize = size;
  }

  void startGame() {
    addPlayer();
    time.reset();
    inProgress = true;
    start();
  }

  void endGame() {
    time.stop();
    inProgress = false;
    stop();
    gameEndedAt = DateTime.now().millisecondsSinceEpoch;
  }

  // void onTapDown(TapDownDetails d) {
  //   if (inProgress) {
  //     double distFromCenter = sqrt(pow(screenSize.width / 2 - d.globalPosition.dx, 2) + pow(screenSize.height / 2 - d.globalPosition.dy, 2));
  //     if (distFromCenter <= switchGunRadius) {
  //       players.switchGun();
  //     } else {
  //       players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
  //     }
  //   } else if (gameEndedAt < DateTime.now().millisecondsSinceEpoch - restartDelay) {
  //     startGame();
  //   }
  // }

  void addPlayer() {
    player = new Player()
      ..x = screenSize.width / 2
      ..y = screenSize.height / 2;
    add(player);
  }

  // bool fireAt(double dx, double dy) {
  //   players.forEach((Player player) => player.fireAt(dx, dy));
  //   addProjectile(dx, dy);
  //   return players.length > 0;
  // }

  // void switchGun() {
  //   if (addProjectile == addBullet) {
  //     addProjectile = addMissle;
  //   } else {
  //     addProjectile = addBullet;
  //   }
  // }

  void hasCollidedWithManyPlayer(Player player, List<dynamic> asteroids) {
    asteroids.forEach((asteroid) => this.hasCollidedPlayer(player, asteroid));
  }

  void hasCollidedPlayer(Player player, Asteroid asteroid) {
    if (player.x - asteroid.x < player.size + asteroid.size && player.y - asteroid.y < player.size + asteroid.size) {
      double distBetween = sqrt(pow(player.x - asteroid.x, 2) + pow(player.y - asteroid.y, 2));
      if (distBetween < player.size + asteroid.size) {
        player.destroy();
        endGame();
      }
    }
  }

  void hasCollidedWithMany(Asteroid objectA, List<dynamic> objects) {
    objects.forEach((objectB) => this.hasCollided(objectA, objectB));
  }

  void hasCollided(Asteroid objectA, Asteroid objectB) {
    double distToHit = objectA.size + objectB.size;
    if (objectA.x - objectB.x < distToHit && objectA.y - objectB.y < distToHit) {
      double distBetween = sqrt(pow(objectA.x - objectB.x, 2) + pow(objectA.y - objectB.y, 2));
      if (objectA != objectB && distBetween < distToHit) {
        if (objectA.hit(0.5)) {
          createDebris(objectA);
          objectA.destroyed = true;
        }
        if (objectB.hit(0.5)) {
          createDebris(objectB);
          objectB.destroyed = true;
        }

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

  double reflection(direction, normal) {
    double dx = cos(direction);
    double dy = sin(direction);
    double nx = cos(normal);
    double ny = sin(normal);
    double rx = dx - 2 * dx * pow(nx, 2);
    double ry = dy - 2 * dy * pow(ny, 2);
    return atan2(ry, rx);
  }

  void start() {
    running = true;
  }

  void stop() {
    running = false;
    spawnRate = minSpawnRate;
  }

  bool offScreenAsteroid(Asteroid a) {
    double distFromCenter = sqrt(pow(screenSize.width / 2 - a.x, 2) + pow(screenSize.height / 2 - a.y, 2));
    if (distFromCenter > boundRadius) {
      return true;
    }
    return false;
  }

  bool offScreenDebri(Debri d) {
    double margin = 10;
    if (d.x < 0 - margin || d.y < 0 - margin || d.x > screenSize.width + margin || d.y > screenSize.height + margin) {
      return true;
    }
    return false;
  }

  void createDebris(Asteroid asteroid) {
    double amount = asteroid.numVertices / 2;
    for (int vert = 0; vert < amount; vert++) {
      double theta = pi * 2 / amount * vert;
      double x = asteroid.x + asteroid.size * cos(theta);
      double y = asteroid.y + asteroid.size * sin(theta);
      double length = asteroid.size * 2 * pi / amount;
      double angle = theta + pi / 2;
      double direction = theta;

      Debri debri = Debri(length, direction)
        ..x = x
        ..y = y
        ..angle = angle;
      add(debri);
    }
  }
}
