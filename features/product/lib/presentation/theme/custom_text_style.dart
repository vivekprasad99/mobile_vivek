import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../utils/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodySmall10 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 10.fSize,
      );
  static get bodySmall8 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 8.fSize,
      );
  static get bodySmallRoboto => theme.textTheme.bodySmall!.roboto;
  static get bodySmallRobotoLight => theme.textTheme.bodySmall!.roboto.copyWith(
        fontWeight: FontWeight.w300,
      );
  static get bodySmallRobotoOnPrimary =>
      theme.textTheme.bodySmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 9.fSize,
      );
  static get bodySmallff000000 => theme.textTheme.bodySmall!.copyWith(
        color: const Color(0XFF000000),
        fontSize: 10.fSize,
      );
  // Label style
  static get labelLargeRoboto => theme.textTheme.labelLarge!.roboto;
  static get labelLargeRobotoGray80001 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: appTheme.gray80001,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeRobotoGray80001Medium =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: appTheme.gray80001,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeRobotoOnPrimaryContainer =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get labelLargeff000000 => theme.textTheme.labelLarge!.copyWith(
        color: const Color(0XFF000000),
      );
  static get labelMediumIBMPlexSansBlack900 =>
      theme.textTheme.labelMedium!.iBMPlexSans.copyWith(
        color: appTheme.black900,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w600,
      );
  static get labelMediumIBMPlexSansff000000 =>
      theme.textTheme.labelMedium!.iBMPlexSans.copyWith(
        color: const Color(0XFF000000),
        fontSize: 10.fSize,
        fontWeight: FontWeight.w600,
      );
  static get labelMediumPrimary => theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 10.fSize,
      );
  // Title text style
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallGray80001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray80001,
      );
  static get titleSmallIBMPlexSansGray90001 =>
      theme.textTheme.titleSmall!.iBMPlexSans.copyWith(
        color: appTheme.gray90001,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallPrimaryContainer => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get titleSmallQuicksand => theme.textTheme.titleSmall!.quicksand;
}

extension on TextStyle {
  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get iBMPlexSans {
    return copyWith(
      fontFamily: 'IBM Plex Sans',
    );
  }

  TextStyle get quicksand {
    return copyWith(
      fontFamily: 'Quicksand',
    );
  }
}
