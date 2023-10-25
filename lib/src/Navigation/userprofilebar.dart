import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils.dart';

class UserProfileBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
/*     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double height = screenHeight * (9 / 100);
    double iconSize = 1.5; // 3% of screen width
    double textSize = 1.4; // 3% of screen width
    double containerPadding = 1.0; // 1% of screen width
    double containerMargin = 1.0; // 1% of screen width
    double logoSize = 2; // 15% of screen width
    double sizeboxWidth = screenWidth * (.4 / 100); */

    double screenHeight = Dimensions.screenHeight;
    final screenWidth = Dimensions.screenWidth;
    double logoSize = Dimensions.imglogoSize;
    double sizeboxWidth = screenWidth * (.4 / 100);
    double height = screenHeight * (9 / 100);
    double iconSize = Dimensions.iconSize;
    double textsize = Dimensions.textSize - 10;
    return Container(
      color: Color(0xFFE8EBF5),
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            // Adjust spacing as needed
            child: Image.asset(
              'assets/profile.png',
              width: logoSize,
              height: logoSize,
            ),
          ),
          SizedBox(
            width: sizeboxWidth,
          ),
          Text(
            'Jabar Chand',
            style: SafeGoogleFont(
              'Lato',
              fontWeight: FontWeight.w400,
              fontSize: textsize,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(
            width: sizeboxWidth,
          ),
          Icon(
            Icons.arrow_drop_down_outlined,
            size: iconSize,
          ),
        ],
      ),
    );
  }
}
