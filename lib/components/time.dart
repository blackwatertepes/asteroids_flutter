import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

class Time  {
  double sizeWidth;
  double sizeHeight;
  int start;
  int total;
  bool running;

  Time(double init_sizeWidth, double init_sizeHeight) {
    sizeWidth = init_sizeWidth;
    sizeHeight = init_sizeHeight;

    reset();

    total = 0;
    running = false;
  }

  @override
  void render(Canvas canvas) {
    int minutes = (total / 60000).floor();
    int seconds = (total / 1000).floor() % 60;
    String secondsStr = "${seconds}".padLeft(2, "0");
    String minutesStr = "${minutes}".padLeft(2, "0");

    String corner = "Time: ${minutesStr}:${secondsStr}";
    TextPainter textPainter = Flame.util.text(corner, color: Colors.white, fontSize: 14.0);
    textPainter.paint(canvas, Offset(sizeWidth - 80, 30));

    if (!running) {
      String begin = "Click anywhere to start";
      TextPainter beginPainter = Flame.util.text(begin, color: Colors.white, fontSize: 20.0);
      beginPainter.paint(canvas, Offset(10, 300));

      if (total > 0) {
        String title = "${minutesStr}:${secondsStr}";
        TextPainter titlePainter = Flame.util.text(title, color: Colors.white, fontSize: 28.0);
        titlePainter.paint(canvas, Offset(10, 350));
      }
    }
  }

  @override
  void update(double t) {
    if (running) {
      total = DateTime.now().millisecondsSinceEpoch - start;
    }
  }

  void reset() {
    start = DateTime.now().millisecondsSinceEpoch;
    running = true;
  }

  void stop() {
    running = false;
  }
}
