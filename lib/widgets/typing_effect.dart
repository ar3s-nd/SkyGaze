import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TypingEffect extends StatelessWidget {
  final String text, cursor;
  final double size;
  final Color color;
  final bool repeat;
  final int time1, time2;

  const TypingEffect({
    super.key, 
    required this.time1,
    required this.time2,
    required this.text, 
    required this.size, 
    required this.color,
    required this.repeat,
    required this.cursor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textStyle: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          speed: Duration(milliseconds: time1),
          cursor: cursor
        ),
      ],
      repeatForever: repeat,
      pause: Duration(microseconds: time2),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}

