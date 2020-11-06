import 'package:flutter/material.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/text_config.dart';
import 'package:Asteroidio/components/game.dart';
// import 'package:flutter/semantics.dart';
// import 'package:flutter/services.dart';
// import 'package:play_games/player_games.dart';

class Time extends PositionComponent with HasGameRef<Game> {
  double sizeWidth;
  double sizeHeight;
  int start;
  int total;
  bool running;
  TextComponent timer;

  Time(double initSizeWidth, double initSizeHeight) {
    sizeWidth = initSizeWidth;
    sizeHeight = initSizeHeight;

    reset();

    total = 0;
    running = false;
  }

  String time() {
    int minutes = (total / 60000).floor();
    int seconds = (total / 1000).floor() % 60;
    String secondsStr = "$seconds".padLeft(2, "0");
    String minutesStr = "$minutes".padLeft(2, "0");
    String text = "Time: $minutesStr:$secondsStr";
    return text;
  }

  @override
  onMount() {
    TextConfig timeConfig = TextConfig(fontSize: 14.0, color: Colors.white);

    timer = TextComponent(time(), config: timeConfig);

    gameRef.add(timer
      ..x = sizeWidth - 80
      ..y = 30);

    if (!running) {
      if (total > 0) {
        TextConfig scoreConfig = TextConfig(fontSize: 28.0, color: Colors.white);

        gameRef.add(TextComponent(time(), config: scoreConfig)
          ..x = 10
          ..y = 320);
      }
    }
  }

  @override
  void render(Canvas c) {
    prepareCanvas(c);
  }

  @override
  void update(double t) {
    super.update(t);

    if (running) {
      total = DateTime.now().millisecondsSinceEpoch - start;
      timer.text = time();
    }
  }

  void reset() {
    start = DateTime.now().millisecondsSinceEpoch;
    running = true;
  }

  void stop() {
    running = false;
    // submitScoreById('CgkIt4fvrooGEAIQAA', total);
  }
}
