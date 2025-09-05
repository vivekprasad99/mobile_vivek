import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineGray => BoxDecoration(
        borderRadius: BorderRadius.circular(17.h),
        border: Border.all(
          color: appTheme.gray700,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.gray50,
        borderRadius: BorderRadius.circular(34.h),
        border: Border.all(
          color: appTheme.black900,
          width: 4.h,
        ),
      );
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        color: theme.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(
          color: appTheme.blueGray90001,
          width: 2.h,
        ),
      );
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  });

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  color: appTheme.gray500,
                  borderRadius: BorderRadius.circular(21.h),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}
