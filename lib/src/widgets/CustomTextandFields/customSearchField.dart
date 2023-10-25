import 'package:flutter/material.dart';

import '../../constants.dart';

class CustomSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final double width;
  final Color borderColor;

  const CustomSearchTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.width,
    required this.borderColor,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(fontSize: Dimensions.Txtfontsize),
          prefixIcon: Icon(Icons.search),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: Dimensions.widthSearchTxtField,
              color: borderColor,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: Dimensions.widthSearchTxtField,
              color: borderColor,
            ),
          ),
        ),
      ),
    );
  }
}
