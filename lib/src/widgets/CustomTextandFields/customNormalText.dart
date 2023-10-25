import 'package:flutter/material.dart';

class CustomNormalText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final String fontFamily;
  final FontWeight fontWeight;
  final double height;

  CustomNormalText({
    required this.text,
    this.fontSize = 24.0,
    this.color = Colors.black,
    this.fontFamily = 'Lato',
    this.fontWeight = FontWeight.w500,
    this.height = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}
