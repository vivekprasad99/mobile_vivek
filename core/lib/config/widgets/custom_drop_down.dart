import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.alignment,
    this.width,
    this.focusNode,
    this.icon,
    this.autofocus = true,
    this.textStyle,
    this.items,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  });

  final Alignment? alignment;

  final double? width;

  final FocusNode? focusNode;

  final Widget? icon;

  final bool? autofocus;

  final TextStyle? textStyle;

  final List<DropdownMenuItem<T>>? items;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<T>? validator;

  final Function(T)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: dropDownWidget(context),
          )
        : dropDownWidget(context);
  }

  Widget dropDownWidget(context) => SizedBox(
        width: width ?? double.maxFinite,
        child: DropdownButtonFormField<T>(
          focusNode: focusNode ?? FocusNode(),
          icon: Icon(
            Icons.expand_more,
            color: Theme.of(context).primaryColor,
          ),
          iconSize: 20,
          autofocus: autofocus!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.secondaryLight5),
              ),
          items: items,
          // hint: Text(
          //   hintText ?? "",
          //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //         color: setColorBasedOnTheme(
          //             context: context,
          //             lightColor: AppColors.primaryLight,
          //             darkColor: AppColors.secondaryLight5),
          //       ),
          // ),
          decoration: decoration(context),
          validator: validator,
          onChanged: (value) {
            onChanged!(value as T);
          },
        ),
      );
  InputDecoration decoration(context) => InputDecoration(
        // hintText: hintText ?? "",
        // label: ,
        // hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        //       // height: 8.0,
        //       color: setColorBasedOnTheme(
        //           context: context,
        //           lightColor: AppColors.primaryLight,
        //           darkColor: AppColors.secondaryLight5),
        //     ),
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              left: 12.h,
              top: 12.v,
              bottom: 12.v,
            ),
        fillColor: Colors.transparent,
        filled: filled,
        // labelText: hintText,
        label: Text(
          hintText ?? "",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.secondaryLight5),
              ),
        ),
        // labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
        //       color: setColorBasedOnTheme(
        //           context: context,
        //           lightColor: AppColors.primaryLight,
        //           darkColor: AppColors.secondaryLight5),
        //     ),
        border: borderDecoration ??
            UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight3,
                    darkColor: AppColors.secondaryLight5),
                width: 1.5,
              ),
            ),
        enabledBorder: borderDecoration ??
            UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight3,
                    darkColor: AppColors.secondaryLight5),
                width: 1.5,
              ),
            ),
        focusedBorder: borderDecoration ??
            UnderlineInputBorder(
              // borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight3,
                    darkColor: AppColors.secondaryLight5),
                width: 1.5,
              ),
            ),
      );
}
