import 'package:auto_size_text/auto_size_text.dart';
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

class ReusableAutoSizeText extends StatelessWidget {
  final String text;
  final double minFontSize;
  final TextOverflow overflow;

  ReusableAutoSizeText({
    required this.text,
    this.minFontSize = 4,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      minFontSize: minFontSize,
      overflow: overflow,
      style: TextStyle(
        fontWeight: FontWeight.w600
      ),
    );
  }
}