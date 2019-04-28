import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:asteroids_flutter/components/score.dart';
import 'package:asteroids_flutter/systems/asteroids.dart';

void main() => runApp(MyGame().widget);

class MyGame extends BaseGame {
  Asteroids asteroids;
  Score score;
  Size screenSize;

  MyGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    asteroids = new Asteroids(screenSize.width, screenSize.height);
    score = new Score(screenSize.width, screenSize.height);
  }

  @override
  void render(Canvas canvas) {
    score.render(canvas);
    asteroids.render(canvas);
  }

  @override
  void update(double t) {
    asteroids.update(t);
  }

  void resize(Size size) {
    screenSize = size;
  }
}
