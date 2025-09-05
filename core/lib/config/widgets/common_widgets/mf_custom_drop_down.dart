import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class MfCustomDropDown<T> extends StatelessWidget {
  final String title;
  final double? menuHeight;
  final double? width;
  final TextEditingController? selectedController;
  final TextStyle? textStyle;
  final TextStyle? titleTextStyle;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final Function(T?)? onSelected;
  final T? initialValue;
  final bool? enabled;

  const MfCustomDropDown(
      {this.textStyle,
      this.titleTextStyle,
      this.menuHeight,
      this.width,
      this.selectedController,
      required this.title,
      required this.dropdownMenuEntries,
      this.onSelected,
      this.initialValue,
      this.enabled,
      super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return DropdownMenu(
        initialSelection: initialValue,
        controller: selectedController,
        menuHeight: menuHeight,
        enabled: enabled ?? true,
        menuStyle: MenuStyle(

          backgroundColor: MaterialStateProperty.all<Color>(
              brightness == Brightness.dark
                  ? AppColors.shadowDark
                  : AppColors.white),
        ),

        textStyle: textStyle ??
            Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.textLight,
                      darkColor: AppColors.white),
                ),
        label: Text(
          title,
          style: titleTextStyle ??
              Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.secondaryLight5),
                  ),
        ),
        width: width ?? MediaQuery.of(context).size.width * 0.92,
        selectedTrailingIcon: Icon(
          Icons.keyboard_arrow_up,
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.white),
        ),
        trailingIcon: Icon(
          Icons.keyboard_arrow_down,
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.secondaryLight5),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.fromLTRB(10.h, 10.v, 16.h, 10.v),
          activeIndicatorBorder: BorderSide(
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight,
                darkColor: AppColors.secondaryLight5),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5),
            ),
          ),
        ),
        onSelected: onSelected,
        dropdownMenuEntries: dropdownMenuEntries,

    );
  }
}