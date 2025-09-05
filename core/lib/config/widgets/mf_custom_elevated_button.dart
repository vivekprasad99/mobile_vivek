import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class MfCustomButton extends StatelessWidget {
  final double? height;
  final Color? buttonColor;
  final Color textColor;
  final Color borderColor;
  final String text;
  final GestureTapCallback onPressed;
  final double? width;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool? leftIcon;
  final Widget? rightIcon;
  final bool? outlineBorderButton;
  final bool? isDisabled;

  const MfCustomButton({
    this.buttonColor = AppColors.secondaryLight,
    this.borderColor = AppColors.secondaryLight,
    this.height,
    this.borderRadius = 8,
    this.width,
    this.textColor = Colors.white,
    required this.onPressed,
    required this.text,
    this.textStyle,
    this.leftIcon = false,
    this.rightIcon,
    required this.outlineBorderButton,
    this.isDisabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine button styles based on state (disabled or enabled)
    final Color resolvedButtonColor = isDisabled == true
        ? Theme.of(context).disabledColor
        : buttonColor ?? Theme.of(context).highlightColor;

    final TextStyle? resolvedTextStyle = textStyle ??
        Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDisabled == true
                ? setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight4,
                    darkColor: AppColors.disableTextDark,
                  ) // Use disabled color when button is disabled
                : outlineBorderButton == true
                    ? setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5,
                      )
                    : AppColors
                        .white // Default text color when not disabled or outlined
            );

    return GestureDetector(
      onTap: isDisabled == true ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        alignment: Alignment.center,
        height: height ?? 42.v,
        decoration: outlineBorderButton == true
            ? BoxDecoration(
                border: Border.all(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: borderColor,
                        darkColor: AppColors.secondaryLight5)),
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : BoxDecoration(
                color: resolvedButtonColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon ?? false
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            Text(
              text,
              style: resolvedTextStyle,
            ),
            rightIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
