import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';

class CustomDatePickerTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final double width;

  CustomDatePickerTextField(
      {required this.labelText, required this.controller, required this.width});

  @override
  _CustomDatePickerTextFieldState createState() =>
      _CustomDatePickerTextFieldState();
}

class _CustomDatePickerTextFieldState extends State<CustomDatePickerTextField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != widget.controller.text) {
      setState(() {
        widget.controller.text =
            "${picked.day},${_getMonthName(picked.month)},${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: Dimensions.buttonHeight * 1.1,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: AppConstants.whitecontainer,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff8A8282),
              width: .5,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(fontSize: Dimensions.Txtfontsize),
          suffixIcon: IconButton(
            iconSize: Dimensions.iconSize,
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
        readOnly: true,
      ),
    );
  }
}
