import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:asteroids_flutter/components/time.dart';
import 'package:asteroids_flutter/systems/asteroids.dart';
import 'package:asteroids_flutter/systems/bullets.dart';
import 'package:asteroids_flutter/systems/explosions.dart';
import 'package:asteroids_flutter/systems/missles.dart';
import 'package:asteroids_flutter/systems/players.dart';

void main() => runApp(MyGame().widget);

class MyGame extends BaseGame {
  Asteroids asteroids;
  Bullets bullets;
  Explosions explosions;
  Missles missles;
  Players players;
  Time time;
  Size screenSize;
  TapGestureRecognizer tapper;
  Util flameUtil;

  MyGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());

    asteroids = new Asteroids(screenSize.width, screenSize.height);
    bullets =  new Bullets(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    explosions =  new Explosions(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids);
    missles =  new Missles(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, explosions.addExplosion);
    players = new Players(screenSize.width / 2, screenSize.height / 2, asteroids.asteroids, this.endGame);
    time = new Time(screenSize.width, screenSize.height);
    tapper = TapGestureRecognizer();
    flameUtil = Util();

    tapper.onTapDown = onTapDown;
    flameUtil.addGestureRecognizer(tapper);
  }

  @override
  void render(Canvas canvas) {
    asteroids.render(canvas);
    bullets.render(canvas);
    explosions.render(canvas);
    missles.render(canvas);
    players.render(canvas);
    time.render(canvas);
  }

  @override
  void update(double t) {
    asteroids.update(t);
    bullets.update(t);
    explosions.update(t);
    missles.update(t);
    players.update(t);
    time.update(t);
  }

  void resize(Size size) {
    screenSize = size;
  }

  void startGame() {
    players.addPlayer();
    time.reset();
  }

  void endGame() {
    time.stop();
  }

  void onTapDown(TapDownDetails d) {
    bool fired = players.fireAt(d.globalPosition.dx, d.globalPosition.dy);
    if (fired) {
      // bullets.addBullet(d.globalPosition.dx, d.globalPosition.dy);
      missles.addMissle(d.globalPosition.dx, d.globalPosition.dy);
    } else {
      startGame();
    }
  }
}
