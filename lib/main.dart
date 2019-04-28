import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:asteroids_flutter/systems/asteroids.dart';

void main() => runApp(MyGame().widget);

class MyGame extends BaseGame {
  Size screenSize;
  Asteroids asteroids;

  MyGame() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    asteroids = new Asteroids(screenSize.width, screenSize.height);
  }

  @override
  void render(Canvas canvas) {
    String text = "Score: 0";
    TextPainter textPainter = Flame.util.text(text, color: Colors.white, fontSize: 14.0);
    textPainter.paint(canvas, Offset(screenSize.width - 80, 30));

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
