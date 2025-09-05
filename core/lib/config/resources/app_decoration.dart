import 'package:core/utils/size_utils.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray100,
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray40001,
      );
  static BoxDecoration get fillBluegray50 => BoxDecoration(
        color: appTheme.blueGray50,
      );
  static BoxDecoration get fillDeepPurple => BoxDecoration(
        color: appTheme.deepPurple400,
      );
  static BoxDecoration get outlineGray40001 => BoxDecoration(
        color: appTheme.gray200,
        border: Border.all(
          color: appTheme.gray40001,
          width: 1.h,
        ),
      );
  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.3),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.08),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9001 => BoxDecoration(
        color: appTheme.gray50,
        border: Border.all(
          color: appTheme.black900,
          width: 4.h,
        ),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: appTheme.gray50001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOnPrimary => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.onPrimary,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h,
          strokeAlign: strokeAlignCenter,
        ),
      );
  // Custom borders
  static BorderRadius get customBorderTL10 => BorderRadius.vertical(
        top: Radius.circular(10.h),
      );
  static BoxDecoration get fillGreen => BoxDecoration(
        color: appTheme.green50,
      );

  static BoxDecoration get fillGray40002 => BoxDecoration(
        color: appTheme.gray40002,
      );

  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );

  static BoxDecoration get fillGray300 => BoxDecoration(
        color: appTheme.gray300,
      );
  static BoxDecoration get fillPink2002 => BoxDecoration(
        color: appTheme.pink2002,
      );
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderTL28 => BorderRadius.vertical(
        top: Radius.circular(28.h),
      );
  static BorderRadius get circleBorder20 => BorderRadius.circular(
        20.h,
      );
  static BorderRadius get customBorderBL14 => BorderRadius.vertical(
        bottom: Radius.circular(14.h),
      );
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15.h,
      );
  static BorderRadius get circleBorder34 => BorderRadius.circular(
        34.h,
      );
  static BorderRadius get circleBorder19 => BorderRadius.circular(
        19.h,
      );
  static BorderRadius get customBorderTL20 => BorderRadius.vertical(
        top: Radius.circular(20.h),
      );
  static BorderRadius get customBorderTL10 => BorderRadius.vertical(
        top: Radius.circular(10.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder8 => BorderRadius.circular(
        8.h,
      );
  static BorderRadius get roundedBorder2 => BorderRadius.circular(
        2.h,
      );
  static BorderRadius get roundedBorder55 => BorderRadius.circular(
        55.h,
      );
  // Circle borders
  static BorderRadius get circleBorder16 => BorderRadius.circular(
        16.h,
      );

  // Custom borders
  static BorderRadius get roundedBorder4 => BorderRadius.circular(
        4.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
