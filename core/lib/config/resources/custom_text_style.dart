import 'package:core/utils/size_utils.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:flutter/material.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeGray800 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray800,
      );
  static get bodyMediumGray90002 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray90002,
      );
  static get titleSmallPoppinsBluegray90001 =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: appTheme.blueGray90001,
        fontWeight: FontWeight.w500,
      );
  static get labelLargeOnErrorContainer => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onErrorContainer,
      );
  static get titleSmallPoppinsOnPrimary =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallPoppinsGray800 =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallRobotoBluegray90001 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: appTheme.blueGray90001,
        fontWeight: FontWeight.w500,
      );
  static get bodyMediumRobotoBluegray90001 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyMediumIBMPlexSansBlack900 =>
      theme.textTheme.bodyMedium!.iBMPlexSans.copyWith(
        color: appTheme.black900,
      );
  static get titleMediumPoppinsGray80002 =>
      theme.textTheme.titleMedium!.poppins.copyWith(
        color: appTheme.gray80002,
        fontWeight: FontWeight.w600,
      );
  static get bodySmallRobotoGray90001 =>
      theme.textTheme.bodySmall!.roboto.copyWith(
        color: appTheme.gray90001,
      );
  static get labelLargeGray90001 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray90001,
        fontWeight: FontWeight.w600,
      );
  static get bodySmallRobotoGray80001 =>
      theme.textTheme.bodySmall!.roboto.copyWith(
        color: appTheme.gray80001,
      );
  static get titleSmallBlack900SemiBold => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get bodyMediumff161616 => theme.textTheme.bodyMedium!.copyWith(
        color: const Color(0XFF161616),
      );
  static get titleSmallPoppinsErrorContainer =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: theme.colorScheme.errorContainer,
        fontWeight: FontWeight.w500,
      );
  static get bodySmallErrorContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get titleSmallff161616 => theme.textTheme.titleSmall!.copyWith(
        color: const Color(0XFF161616),
        fontWeight: FontWeight.w700,
      );
  static get titleLargePoppinsBluegray90001 =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyMediumErrorContainer_1 => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
      );
  static get bodyMediumIBMPlexSans => theme.textTheme.bodyMedium!.iBMPlexSans;
  static get bodyMediumRobotoOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleMediumRobotoPrimary =>
      theme.textTheme.titleMedium!.roboto.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );

  static get titleLargeRobotoPrimary =>
      theme.textTheme.displayLarge!.roboto.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 24);

  static get titleLargeQuickSandPrimary =>
      theme.textTheme.displayLarge!.quicksand.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 20);

  static get smallKarla => theme.textTheme.bodyMedium!.quicksand.copyWith(
      color: appTheme.gray800, fontWeight: FontWeight.w400, fontSize: 12);

  static get titleSmallRobotoOnPrimaryContainer =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(0.49),
        fontWeight: FontWeight.w500,
      );
  static get bodyLargeGray80001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray80001,
      );
  static get bodyMediumIBMPlexSansBlack900Light =>
      theme.textTheme.bodyMedium!.iBMPlexSans.copyWith(
        color: appTheme.black900,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w300,
      );

  static get bodyLarge_1 => theme.textTheme.bodyLarge!;
  static get bodyLargeff5b5b5b => theme.textTheme.bodyLarge!.copyWith(
        color: const Color(0XFF5B5B5B),
      );
  static get titleMediumBlack900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
      );
  static get bodyMediumGray70002 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray70002,
      );
  static get titleMediumGray900 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray900,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallInterBlack900 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallInterOnPrimary =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get titleLargeQuicksandOnPrimary =>
      theme.textTheme.titleLarge!.quicksand.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 22.fSize,
      );
  static get bodySmallRed900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red900,
      );
  static get bodySmallRed90001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red90001,
      );
  static get bodySmallBluegray90001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodySmallGray70001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray70001,
      );
  static get bodyLargeOnPrimaryContainer => theme.textTheme.bodyLarge!.copyWith(
        color: Colors.grey,
      );
  static get bodyMediumErrorContainer => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.errorContainer,
        fontWeight: FontWeight.w400,
      );
  static get bodyMediumGray100 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray100,
        fontWeight: FontWeight.w400,
      );
  static get bodySmallGray70002 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray70002,
      );
  static get bodyMediumGray800 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w400,
      );

  static get bodyMediumGray80002 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.gray80002,
        fontWeight: FontWeight.w400,
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );
  static get bodySmallRobotoGray800 =>
      theme.textTheme.bodySmall!.roboto.copyWith(
        color: appTheme.gray800,
      );
  static get bodySmallRobotoRed900 =>
      theme.textTheme.bodySmall!.roboto.copyWith(
        color: appTheme.red900,
      );
  // Title text style
  static get titleSmallBlack900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallGray80001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray80001,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallMedium => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleSmallMediumUnderline => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      );
  static get titleSmallOnPrimary => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static get titleSmallOnPrimaryContainer =>
      theme.textTheme.titleSmall!.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      );
  static get bodySmallOnPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get bodySmallOnPrimaryContainer_1 =>
      theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      );
  static get titleSmallOnPrimarySemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallOnPrimary_1 => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get bodySmallGray80001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray80001,
      );

  static get titleSmallBlack900Medium => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      );
  static get bodySmallff333333 => theme.textTheme.bodySmall!.copyWith(
        color: const Color(0XFF333333),
      );

  static get bodySmallPoppinsBluegray90001 =>
      theme.textTheme.bodySmall!.poppins.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 8.fSize,
      );
  static get bodyMediumRobotoGray90001 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.gray90001,
      );

  static get bodyMediumRobotoGray90001_1 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.gray90001,
      );

  static get labelLargePoppinsGray90001 =>
      theme.textTheme.labelLarge!.poppins.copyWith(
        color: appTheme.gray90001,
      );

  static get bodySmallGray90001 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray90001,
      );

  // Label text style
  static get labelLargeBlack900 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.black900,
      );
  static get bottomnavSmallGray800 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray800,
        fontWeight: FontWeight.w500,
      );
}

extension on TextStyle {
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

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get iBMPlexSans {
    return copyWith(
      fontFamily: 'IBM Plex Sans',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}
