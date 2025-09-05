import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/background/theme_type.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MFGradientBackground extends StatelessWidget {
  final Widget child;
  final ThemeType themeType;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool? showLoader;

  const MFGradientBackground(
      {super.key,
      required this.child,
      this.horizontalPadding,
      this.verticalPadding,
      this.showLoader = false,
      this.themeType = ThemeType.lightTheme});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Stack(
      children: [

        brightness == Brightness.dark
            ? Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
            color: AppColors.backgroundDarkGradient,
          ),
          child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding ?? 16.w,
                vertical: verticalPadding ?? 16.v,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.backgroundDarkGradient3.withOpacity(0.3),
                    AppColors.backgroundDarkGradient2.withOpacity(0.01),
                    AppColors.backgroundDarkGradient.withOpacity(0.09),
                  ],
                  stops: const [0.2, 0.5, 0.4],
                ),
              ),
              child: child),
        )
            : Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 16.w,
            vertical: verticalPadding ?? 16.v,
          ),
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                stops: const [
                  0.0086,
                  0.992,
                  0.3493
                ]),
          ),
          child: child,
        ),
        if (showLoader == true)
          Container(
            height: SizeUtils.height,
            width: SizeUtils.width,
            color: Colors.grey.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).indicatorColor,
              ),
            ),
          ),
      ],
    );
  }
}
