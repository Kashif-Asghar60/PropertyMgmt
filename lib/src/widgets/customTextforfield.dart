import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showStar;

  CustomTextWidget({
    required this.text,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.w500,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
              fontFamily: 'Lato',
              fontWeight: fontWeight,
              height: 0,
            ),
          ),
          if (showStar)
            TextSpan(
              text: '*',
              style: TextStyle(
                color: Color(0xFFF31919),
                fontSize: fontSize,
                fontFamily: 'Lato',
                fontWeight: fontWeight,
                height: 0,
              ),
            ),
        ],
      ),
    );
  }
}
