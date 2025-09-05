import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    this.value,
    this.isExpanded,
    this.onChanged,
    this.hintText,
    required this.items,
    this.selectedTrailingIcon,
    this.trailingIcon,
  });

  final bool? isExpanded;
  final dynamic value;
  final String? hintText;
  final Function(T?)? onChanged;
  final List<DropdownMenuEntry> items;
  final Widget? selectedTrailingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      onSelected: onChanged,
      textStyle:
          Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
      label: Text(
        hintText ?? "",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      width: MediaQuery.of(context).size.width * 0.92,
      selectedTrailingIcon: selectedTrailingIcon ??
          Icon(
            Icons.keyboard_arrow_up,
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight3,
                darkColor: AppColors.secondaryLight5),
          ),
      trailingIcon: trailingIcon ??
          Icon(
            Icons.keyboard_arrow_down,
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight3,
                darkColor: AppColors.secondaryLight5),
          ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.fromLTRB(10.h, 10.v, 16.h, 10.v),
        activeIndicatorBorder: BorderSide(
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight3,
                darkColor: AppColors.secondaryLight5)),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight3,
                darkColor: AppColors.secondaryLight5),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight3,
                darkColor: AppColors.secondaryLight5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight3,
                darkColor: AppColors.secondaryLight5),
          ),
        ),
      ),
      dropdownMenuEntries: items
          .map((e) => DropdownMenuEntry<T>(
                value: e.value,
                label: e.label,
                style: MenuItemButton.styleFrom(
                  // foregroundColor: AppColors.primaryLight,
                  textStyle: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 16, color: AppColors.textLight),
                ),
              ))
          .toList(),
    );
  }
}
