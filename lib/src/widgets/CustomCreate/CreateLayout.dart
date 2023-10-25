import 'package:flutter/material.dart';

import '../../constants.dart';
import '../buttonCustom.dart';

class CustomFormContainer extends StatelessWidget {
  final String heading;
  final List<Widget> centerContent;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  CustomFormContainer({
    required this.heading,
    required this.centerContent,
    this.onCancel,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(
        Dimensions.paddingtenants,
        Dimensions.paddingtenants - 10,
        Dimensions.paddingtenants,
        0,
      ), 
      color: AppConstants.content_areaClr,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: TextStyle(
                fontSize: Dimensions.textSize * 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),

            // Center content

            // Center content wrapped in an Expanded widget
            // Wrap center content in a scrollable widget
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: centerContent,
              ),
            ),
            SizedBox(height: Dimensions.buttonHeight * 2),

            // Cancel and Save buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  width: Dimensions.buttonWidth,
                  height: Dimensions.buttonHeight,
                  color: AppConstants.whitecontainer,
                  txtcolor: AppConstants.BlackTxtColor,
                  text: "Cancel",
                  fontSize: Dimensions.Txtfontsize,
                  onPressed: onCancel ??
                      () {
                        Navigator.of(context).pop();
                      },
                ),
                SizedBox(width: Dimensions.sizeboxWidth * 4),
                CustomButton(
                  width: Dimensions.buttonWidth,
                  height: Dimensions.buttonHeight,
                  color: AppConstants.greenbutton,
                  txtcolor: AppConstants.whiteTxtColor,
                  text: "Save",
                  fontSize: Dimensions.Txtfontsize,
                  onPressed: onSave ?? () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
