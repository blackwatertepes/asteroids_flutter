import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

class Time  {
  double sizeWidth;
  double sizeHeight;
  int start;
  int total;

  Time(double init_sizeWidth, double init_sizeHeight) {
    sizeWidth = init_sizeWidth;
    sizeHeight = init_sizeHeight;

    start = DateTime.now().millisecondsSinceEpoch;
    total = 0;
  }

  @override
  void render(Canvas canvas) {
    int minutes = (total / 60000).floor();
    int seconds = (total / 1000).floor() % 60;
    String secondsStr = "${seconds}".padLeft(2, "0");
    String minutesStr = "${minutes}".padLeft(2, "0");
    String text = "Time: ${minutesStr}:${secondsStr}";
    TextPainter textPainter = Flame.util.text(text, color: Colors.white, fontSize: 14.0);
    textPainter.paint(canvas, Offset(sizeWidth - 80, 30));
  }

  @override
  void update(double t) {
    total = DateTime.now().millisecondsSinceEpoch - start;
  }
}
