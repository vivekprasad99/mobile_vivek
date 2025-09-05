import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

Color setColorBasedOnTheme(
    {required BuildContext context,
    required Color lightColor,
    required Color darkColor}) {
  final Brightness brightness = Theme.of(context).brightness;
  return brightness == Brightness.light ? lightColor : darkColor;
}

TextStyle setStyleTheme({required BuildContext context}) {
  return TextStyle(
      fontWeight: FontWeight.bold,
      color: setColorBasedOnTheme(
        context: context,
        lightColor: AppColors.secondaryLight,
        darkColor: AppColors.secondaryLight5,
      ));
}
