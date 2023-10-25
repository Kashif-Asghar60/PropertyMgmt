import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';

// Define a reusable DataCell widget

/* DataCell customDataCell(String text, double width, double fontsize) {
  return DataCell(
    Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(0, 3, 4, 3),
      constraints:
      
          BoxConstraints(maxWidth: width, minHeight: Dimensions.buttonHeight),
      child: Text(
        text,
        softWrap: true,
        style: TextStyle(
          fontSize: fontsize,
        ),
      ),
    ),
  );
} */
DataCell customDataCell(String text, double width, double fontsize) {
  // Check if the text is too large to fit in the cell
  if (text.length > 20) { // You can adjust the threshold as needed
    return DataCell(
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(0, 3, 4, 3),
            constraints:
                BoxConstraints(maxWidth: width, minHeight: Dimensions.buttonHeight),
            child: Text(
              text,
              softWrap: true,
              style: TextStyle(
                fontSize: fontsize,
              ),
            ),
          ),
        ),
      ),
    );
  } else {
    return DataCell(
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(0, 3, 4, 3),
        constraints:
            BoxConstraints(maxWidth: width, minHeight: Dimensions.buttonHeight),
        child: Text(
          text,
          softWrap: true,
          style: TextStyle(
            fontSize: fontsize,
          ),
        ),
      ),
    );
  }
}
