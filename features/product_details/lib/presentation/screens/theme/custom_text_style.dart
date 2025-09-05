import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/presentation/screens/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodySmallPink900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.pink900,
      );
  static get bodySmallQuicksand =>
      theme.textTheme.bodySmall!.quicksand.copyWith(
        fontSize: 11.fSize,
      );
  static get bodySmallQuicksandPink900 =>
      theme.textTheme.bodySmall!.quicksand.copyWith(
        color: appTheme.pink900,
      );
  static get bodySmallQuicksandPink90011 =>
      theme.textTheme.bodySmall!.quicksand.copyWith(
        color: appTheme.pink900,
        fontSize: 11.fSize,
      );
  static get bodySmallRed700 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red700,
      );
  // Label text style
  static get labelLargeGray600 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeMedium => theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get labelLargeRed700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.red700,
      );
  static get labelLargeRed700Medium => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.red700,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeWhiteA700 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.whiteA700,
      );
  // Title text style
  static get titleLarge20 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 20.fSize,
      );
  static get titleMedium_1 => theme.textTheme.titleMedium!;
  static get titleSmallBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get titleSmallKarlaBluegray900 =>
      theme.textTheme.titleSmall!.karla.copyWith(
        color: appTheme.blueGray900,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallRed700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.red700,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallRed700Bold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.red700,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallRobotoWhiteA700 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallWhiteA700 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallWhiteA700Bold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w700,
      );
}

extension on TextStyle {
  TextStyle get karla {
    return copyWith(
      fontFamily: 'Karla',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get quicksand {
    return copyWith(
      fontFamily: 'Quicksand',
    );
  }
}
