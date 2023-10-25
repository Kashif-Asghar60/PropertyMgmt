import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propertymgmt_uae/src/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final bool autofocus;
  final bool readOnly;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  // final MaxLengthEnforcement maxLengthEnforced;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double width;
  final Color backgroundColor;
  final String hintText;
  final double borderRadius;
  final String? Function(String?)? validator;
  final double borderWidth;
  final String? errorText;
  final double? height;
  CustomTextField({
    this.height,
    this.errorText,
    this.validator,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.style,
    this.textDirection,
    this.textAlign,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.buildCounter,
    this.inputFormatters,
    this.enabled,
    this.width = 200.0,
    this.backgroundColor = Colors.white,
    this.hintText = '',
    this.borderRadius = 5.0,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
        final defaultHeight = height ?? Dimensions.buttonHeight; // Use 10 as the default height if height is not provided

  //  print("vvv $height");
    return SizedBox(
      width: width,
        height:defaultHeight,

     
      child: TextFormField(
        validator: validator,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: TextStyle(
          fontSize: Dimensions.Txtfontsize,
        ),
        textDirection: textDirection,
        textAlign: textAlign ?? TextAlign.start,
        autofocus: autofocus,
        readOnly: readOnly,
        obscureText: obscureText,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted, // Use onFieldSubmitted for TextFormField
        onTap: onTap,
        inputFormatters: inputFormatters,
        enabled: enabled,
        decoration: InputDecoration(
          errorText: errorText,
          fillColor: backgroundColor,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff8A8282),
              width: .5,
            ),
          ),
             focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.purple, // Change this color to the desired cursor and underline color
        width: .5,
      ),),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: Dimensions.Txtfontsize),
          errorStyle: TextStyle(fontSize: Dimensions.Txtfontsize / 1.5),
          labelStyle: TextStyle(fontSize: Dimensions.Txtfontsize / 1.5),
        ),
      ),
    );
  }
}
