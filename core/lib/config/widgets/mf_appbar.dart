import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar customAppbar({
  required BuildContext context,
  required String title,
  required Function() onPressed,
  List<Widget>? actions,
  Widget? leading,
}) {
  final Brightness brightness = Theme.of(context).brightness;
  return AppBar(
    centerTitle: false,
    toolbarHeight: 64,
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    automaticallyImplyLeading: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness:
          brightness == Brightness.dark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ),
    leading: leading ??
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.secondaryLight,
                darkColor: AppColors.white),
          ),
          onPressed: onPressed,
        ),
    elevation: 0.0,
    title: Text(title, style: Theme.of(context).textTheme.titleLarge),
    actions: actions ?? [],
  );
}
