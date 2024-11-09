import 'package:flutter/material.dart';

class TextTimeWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const TextTimeWidget({
    super.key,
    required this.text,
    this.color = Colors.black, // Default color is black
    this.fontSize = 48.0,      // Default font size
    this.fontWeight = FontWeight.bold, // Default weight
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
