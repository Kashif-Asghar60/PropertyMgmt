import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color txtcolor;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback onPressed;

  CustomButton({
    required this.color,
    required this.txtcolor,
    required this.text,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        fixedSize: Size(width, height), // Set the button size

        // You can customize the button size here if needed
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: txtcolor,
        ),
      ),
    );
  }
}
