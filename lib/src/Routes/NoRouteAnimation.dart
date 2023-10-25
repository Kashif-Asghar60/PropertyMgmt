import 'package:flutter/material.dart';

import 'RoutesSwitch.dart';

class NoAnimationPageRoute<T> extends PageRoute<T> {
  NoAnimationPageRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

NoAnimationPageRoute buildNoAnimationPageRoute(String subMenuItem) {
  return NoAnimationPageRoute(builder: (context) {
    return RouteSwitch(routeName: subMenuItem); // Replace with your page widget
  });
}
