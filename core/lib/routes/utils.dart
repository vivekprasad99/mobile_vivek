import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

String getPreviousRoute(BuildContext context) {
  var routeStack = GoRouter.of(context)
      .routerDelegate
      .currentConfiguration
      .matches
      .map((e) => e.matchedLocation)
      .toList()
      .reversed
      .toList();
  if (routeStack.length > 1) {
    return routeStack[1];
  }
  return '';
}
