import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:asteroids_flutter/components/player.dart';
import 'package:asteroids_flutter/components/score.dart';
import 'package:asteroids_flutter/systems/asteroids.dart';

void main() => runApp(MyGame().widget);

class MyGame extends BaseGame {
  Asteroids asteroids;
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
    player.render(canvas);
    score.render(canvas);
  }

  @override
  void update(double t) {
    asteroids.update(t);
    player.update(t);
  }

  void resize(Size size) {
    screenSize = size;
  }

  void onTapDown(TapDownDetails d) {
    player.fireAt(d.globalPosition.dx, d.globalPosition.dy);
  }
}
