import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';

GlobalKey<NavigatorState> dialogNavigatorKey = GlobalKey<NavigatorState>();


void showCustomDialog(BuildContext context, Widget content) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppConstants.content_areaClr,
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: content,
            ),
          );
        },
      );
    },
  );
}

/* void showCustomDialog(BuildContext context, Widget content) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Navigator(
        key: dialogNavigatorKey,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppConstants.content_areaClr,
                content: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: content, // The content you pass to the function
                ),
              );
            },
          );
        },
      );
    },
  );
}
 */
/* 
void showCustomDialog(BuildContext context, Widget content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppConstants.content_areaClr,
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: content,
        ),
      );
    },
  );
}
 */