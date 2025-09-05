import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:faq/features/data/models/faq_response.dart';

class CustomDropDown extends StatelessWidget {
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
    this.themeData,
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

  final List<SubTypes>? items;

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

  final ThemeData? themeData;

  final FormFieldValidator<SubTypes>? validator;

  final Function(SubTypes)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: dropDownWidget,
          )
        : dropDownWidget;
  }

  Widget get dropDownWidget => SizedBox(
        width: width ?? double.maxFinite,
        child: Theme(
          data: themeData ?? ThemeData(),
          child: DropdownButtonFormField<SubTypes>(
            focusNode: focusNode ?? FocusNode(),
            icon: icon,
            autofocus: autofocus!,
            style: textStyle ?? CustomTextStyles.bodySmallGray80001,
            items: items!.map((SubTypes item) {
              return DropdownMenuItem<SubTypes>(
                value: item,
                child: Text(
                  item.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: hintStyle ?? CustomTextStyles.bodySmallBluegray90001,
                ),
              );
            }).toList(),
            decoration: decoration,
            validator: validator,
            onChanged: (value) {
              onChanged!(value!);
            },
          ),
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodySmallBluegray90001,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.only(
              top: 12.v,
              bottom: 12.v,
            ),
        fillColor: fillColor ?? appTheme.gray50,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.h),
              borderSide: BorderSide(
                color: appTheme.black900,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.h),
              borderSide: BorderSide(
                color: appTheme.black900,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.h),
              borderSide: BorderSide(
                color: appTheme.black900,
                width: 1,
              ),
            ),
      );
}
