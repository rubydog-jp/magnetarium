import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const dot = TextStyle(
    fontSize: 16,
    fontFamily: 'k12x8',
    color: Colors.yellow,
  );

  static const general = TextStyle(
    fontSize: 16,
    fontFamily: 'NotoSans',
    color: Colors.white,
  );
}

class TextPaints {
  static final dot = TextPaint(
    style: TextStyles.dot,
  );

  static final general = TextPaint(
    style: TextStyles.general,
  );
}
