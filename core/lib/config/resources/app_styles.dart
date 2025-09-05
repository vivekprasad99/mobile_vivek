import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_dimens.dart';

/// Light theme
ThemeData themeLight(BuildContext context) => ThemeData(
  fontFamily: 'Quicksand',
  useMaterial3: true,
  primaryColor: AppColors.primaryLight,
  disabledColor: AppColors.primaryLight5,
  hintColor: AppColors.textLight,
  unselectedWidgetColor: AppColors.borderLight,
  cardColor: AppColors.cardLight,
  highlightColor: AppColors.secondaryLight,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  primaryColorDark: AppColors.black,
  dividerColor: AppColors.primaryLight6,
  indicatorColor: AppColors.secondaryLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.backgroundLightGradient,
    secondary: AppColors.backgroundLightGradient2,
    error: Colors.black

  ),
  progressIndicatorTheme:
  const ProgressIndicatorThemeData(color: AppColors.primaryLight3),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.secondaryLight,
    disabledColor: AppColors.borderLight,
  ),

  textTheme: TextTheme(
    headlineLarge: Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontSize: AppDimens.headlineLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: AppDimens.headlineMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontSize: AppDimens.headlineSmall,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),

    displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
      fontSize: AppDimens.displayLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
      fontSize: AppDimens.displayMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
      fontSize: AppDimens.displaySmall,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),


    titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: AppDimens.titleLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: AppDimens.titleMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: AppDimens.titleSmall,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),


    bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: AppDimens.bodyLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
    ),
    bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: AppDimens.bodyMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      color: AppColors.primaryLight,
    ),
    bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: AppDimens.bodySmall,
      fontWeight: FontWeight.w600,
      fontFamily: "Quicksand",
      color: AppColors.primaryLight,
    ),

//TODO:- Its used for "Karla" font family
    labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
      fontSize: AppDimens.labelLarge,
      fontFamily: "Karla",
      fontWeight: FontWeight.w600,
      color: AppColors.textLight,
    ),
    labelMedium: Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: AppDimens.labelMedium,
      fontFamily: "Karla",
      fontWeight: FontWeight.w400,
      color: AppColors.textLight,
    ),
    labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
      fontSize: AppDimens.labelSmall,
      fontWeight: FontWeight.w400,
      fontFamily: "Karla",
      color: AppColors.textLight,
    ),


  ),
  appBarTheme: const AppBarTheme().copyWith(
    titleTextStyle: Theme.of(context).textTheme.bodyLarge,
    backgroundColor: AppColors.cardLight,
    iconTheme:  const IconThemeData(color: AppColors.secondaryLight),
  ),
  drawerTheme: const DrawerThemeData().copyWith(
    elevation: AppDimens.zero,
    surfaceTintColor: AppColors.background,
    backgroundColor: AppColors.drawerBvg,
  ),
  bottomSheetTheme: const BottomSheetThemeData().copyWith(
    backgroundColor: AppColors.background,
    surfaceTintColor: Colors.transparent,
    elevation: AppDimens.zero,
  ),
  dialogTheme: const DialogTheme().copyWith(
    backgroundColor: AppColors.background,
    surfaceTintColor: Colors.transparent,
    elevation: AppDimens.zero,
  ),
  iconTheme: const IconThemeData(color: AppColors.secondaryLight),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

/// Dark theme
ThemeData themeDark(BuildContext context) => ThemeData(
  fontFamily: 'Quicksand',
  useMaterial3: true,
  primaryColor: AppColors.white,
  disabledColor: AppColors.shadowDark,
  hintColor: AppColors.white,
  cardColor: AppColors.cardDark,
  brightness: Brightness.dark,
  highlightColor: AppColors.secondaryLight,
  unselectedWidgetColor: AppColors.disableTextDark,
  scaffoldBackgroundColor: AppColors.primaryDark,
  primaryColorDark: AppColors.white,
  dividerColor: AppColors.primaryLight6,
  indicatorColor: AppColors.white,

  progressIndicatorTheme:
  const ProgressIndicatorThemeData(color: AppColors.secondaryLight5),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.secondaryLight,
    disabledColor: AppColors.shadowDark,

  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.backgroundDarkGradient,
    secondary: AppColors.backgroundDarkGradient3,
      error: Colors.white

  ),
  textTheme: TextTheme(
    headlineLarge: Theme.of(context).textTheme.headlineLarge?.copyWith(
      fontSize: AppDimens.headlineLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    headlineMedium: Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: AppDimens.headlineMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    headlineSmall: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontSize: AppDimens.headlineSmall,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),

    displayLarge: Theme.of(context).textTheme.displayLarge?.copyWith(
      fontSize: AppDimens.displayLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    displayMedium: Theme.of(context).textTheme.displayMedium?.copyWith(
      fontSize: AppDimens.displayMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    displaySmall: Theme.of(context).textTheme.displaySmall?.copyWith(
      fontSize: AppDimens.displaySmall,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),

    titleLarge: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontSize: AppDimens.titleLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: AppDimens.titleMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: AppDimens.titleSmall,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),


    bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: AppDimens.bodyLarge,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: AppDimens.bodyMedium,
      fontFamily: "Quicksand",
      fontWeight: FontWeight.w700,
      color: AppColors.white,
    ),
    bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: AppDimens.bodySmall,
      fontWeight: FontWeight.w600,
      fontFamily: "Quicksand",
      color: AppColors.white,
    ),

//TODO:- Its used for "Karla" font family
    labelLarge: Theme.of(context).textTheme.labelLarge?.copyWith(
      fontSize: AppDimens.labelLarge,
      fontFamily: "Karla",
      fontWeight: FontWeight.w600,
      color: AppColors.white,
    ),
    labelMedium: Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: AppDimens.labelMedium,
      fontFamily: "Karla",
      fontWeight: FontWeight.w400,
      color: AppColors.white,
    ),
    labelSmall: Theme.of(context).textTheme.labelSmall?.copyWith(
      fontSize: AppDimens.labelSmall,
      fontWeight: FontWeight.w400,
      fontFamily: "Karla",
      color: AppColors.white,
    ),


  ),
  appBarTheme: const AppBarTheme().copyWith(
    titleTextStyle: Theme.of(context).textTheme.bodyLarge,
    iconTheme: const IconThemeData(color: AppColors.white),
    backgroundColor: AppColors.primaryDark,
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColors.primaryDark,
    ),
  ),
  drawerTheme: const DrawerThemeData().copyWith(
    elevation: AppDimens.zero,
    surfaceTintColor: AppColors.backgroundDark,
    backgroundColor: AppColors.drawerBvg,
    shadowColor: AppColors.shadowDark,
  ),
  bottomSheetTheme: const BottomSheetThemeData().copyWith(
    backgroundColor: AppColors.backgroundDark,
    surfaceTintColor: Colors.transparent,
    elevation: AppDimens.zero,
  ),
  dialogTheme: const DialogTheme().copyWith(
    backgroundColor: AppColors.backgroundDark,
    surfaceTintColor: Colors.transparent,
    elevation: AppDimens.zero,
  ),
  iconTheme: const IconThemeData(color: AppColors.primary),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class BoxDecorations {
  BoxDecorations(this.context);

  final BuildContext context;

  BoxDecoration get button => BoxDecoration(
      color: AppColors.primary,
      borderRadius:
      const BorderRadius.all(Radius.circular(AppDimens.cornerRadius)),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowDark.withOpacity(0.5),
          blurRadius: 16.0,
          spreadRadius: 1.0,
        ),
      ]);

  BoxDecoration get card => BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius:
    const BorderRadius.all(Radius.circular(AppDimens.cornerRadius)),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowDark.withOpacity(0.5),
        blurRadius: 16.0,
        spreadRadius: 1.0,
      )
    ],
  );
}














