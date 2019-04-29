import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:asteroids_flutter/components/player.dart';
import 'package:asteroids_flutter/components/score.dart';
import 'package:asteroids_flutter/systems/asteroids.dart';
import 'package:asteroids_flutter/systems/bullets.dart';
import 'package:asteroids_flutter/systems/explosions.dart';
import 'package:asteroids_flutter/systems/missles.dart';

void main() => runApp(MyGame().widget);

class MyGame extends BaseGame {
  Asteroids asteroids;
  Bullets bullets;
  Explosions explosions;
  Missles missles;
  Player player;
  Score score;
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
    player = new Player(screenSize.width / 2, screenSize.height / 2);
    score = new Score(screenSize.width, screenSize.height);
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
    player.render(canvas);
    score.render(canvas);
  }

  @override
  void update(double t) {
    asteroids.update(t);
    bullets.update(t);
    explosions.update(t);
    missles.update(t);
    player.update(t);
  }

  void resize(Size size) {
    screenSize = size;
  }

  void onTapDown(TapDownDetails d) {
    player.fireAt(d.globalPosition.dx, d.globalPosition.dy);
    // bullets.addBullet(d.globalPosition.dx, d.globalPosition.dy);
    missles.addMissle(d.globalPosition.dx, d.globalPosition.dy);
  }
}
