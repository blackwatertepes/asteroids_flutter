import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

class Score  {
  double sizeWidth;
  double sizeHeight;

  Score(double init_sizeWidth, double init_sizeHeight) {
    sizeWidth = init_sizeWidth;
    sizeHeight = init_sizeHeight;
  }

  @override
  void render(Canvas canvas) {
    String text = "Score: 0";
    TextPainter textPainter = Flame.util.text(text, color: Colors.white, fontSize: 14.0);
    textPainter.paint(canvas, Offset(sizeWidth - 80, 30));
  }

  @override
  void update(double t) {
  }
}
