import 'package:flutter/material.dart';

import '../constants.dart';
import 'RoutesSwitch.dart';

class RightContentPanel extends StatelessWidget {
  const RightContentPanel({
    super.key,
    required GlobalKey<NavigatorState> navigatorKey,
    required this.selectedMenu,
  }) : _navigatorKey = navigatorKey;

  final GlobalKey<NavigatorState> _navigatorKey;
  final String selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: Dimensions.screenWidth*2,
        height: Dimensions.screenHeight,
        color: AppConstants.content_areaClr,
        child: Navigator(
          key: _navigatorKey,
          initialRoute: selectedMenu,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                if (settings.name != null) {
                  // Check if the route name is defined in screenWidgets
                  return RouteSwitch(routeName: settings.name!);
                }
                return Center(
                  child: Text('Content goes here for $selectedMenu'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
