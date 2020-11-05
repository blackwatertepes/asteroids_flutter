import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:Asteroidio/components/time.dart';
import 'package:Asteroidio/systems/asteroids.dart';
import 'package:Asteroidio/systems/bullets.dart';
import 'package:Asteroidio/systems/debris.dart';
import 'package:Asteroidio/systems/explosions.dart';
import 'package:Asteroidio/systems/missles.dart';
import 'package:Asteroidio/systems/players.dart';

class Game extends BaseGame {
  Asteroids asteroids;
  Bullets bullets;
  Debris debris;
  Explosions explosions;
  Missles missles;
  Players players;
  Time time;
  Size screenSize;
  TapGestureRecognizer tapper;
  Util flameUtil;
  bool inProgress;
  double switchGunRadius;
  int gameEndedAt;
  int restartDelay;

  Game() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());

    debris =  new Debris(this, screenSize.width, screenSize.height);
    asteroids = new Asteroids(this, screenSize.width, screenSize.height, debris.createDebris);
    bullets =  new Bullets(this, screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    explosions =  new Explosions(this, screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    missles =  new Missles(this, screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, explosions.addExplosion);
    players = new Players(this, screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, this.endGame, missles.addMissle, bullets.addBullet);
    time = new Time(screenSize.width, screenSize.height);
    tapper = TapGestureRecognizer();
    flameUtil = Util();

    add(time);

    tapper.onTapDown = onTapDown;
    flameUtil.addGestureRecognizer(tapper);

    inProgress = false;
    switchGunRadius = 20;
    gameEndedAt = 0;
    restartDelay = 1000;
  }

  @override
  void update(double t) {
    super.update(t);

    asteroids.update(t);
    bullets.update(t);
    debris.update(t);
    explosions.update(t);
    missles.update(t);
    players.update(t);
  }

  void resize(Size size) {
    super.resize(size);

    screenSize = size;
  }

  void startGame() {
    players.addPlayer();
    time.reset();
    inProgress = true;
    asteroids.start();
  }

  void endGame() {
    time.stop();
    inProgress = false;
    asteroids.stop();
    gameEndedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onTapDown(TapDownDetails d) {
    if (inProgress) {
      double distFromCenter = sqrt(pow(screenSize.width / 2 - d.globalPosition.dx, 2) + pow(screenSize.height / 2 - d.globalPosition.dy, 2));
      if (distFromCenter <= switchGunRadius) {
        players.switchGun();
      } else {
        players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
      }
    } else if (gameEndedAt < DateTime.now().millisecondsSinceEpoch - restartDelay) {
      startGame();
    }
  }
}
