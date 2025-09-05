import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:flutter/material.dart';

class CustomPhoneField extends TextField {
  const CustomPhoneField({
    super.key,
    this.alignment,
    this.width,
    this.controller,
    this.focusNode,
    this.textStyle,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = false,
    this.validator,
  });

  final Alignment? alignment;

  final double? width;

  @override
  final TextEditingController? controller;

  @override
  final FocusNode? focusNode;

  final TextStyle? textStyle;

  @override
  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  @override
  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final String? labelText;

  final TextStyle? labelStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: floatingTextFieldWidget(context),
          )
        : floatingTextFieldWidget(context);
  }

  Widget floatingTextFieldWidget(BuildContext context) => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          autofocus: autofocus,
          style: textStyle ?? CustomTextStyles.bodyMediumGray800,
          obscureText: obscureText,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );

  @override
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? theme.textTheme.bodyLarge,
        labelText: labelText ?? "",
        labelStyle: labelStyle,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding:
            contentPadding ?? EdgeInsets.fromLTRB(16.h, 17.v, 16.h, 19.v),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.h),
              borderSide: BorderSide(
                color: appTheme.gray600,
                width: 1,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.h),
              borderSide: BorderSide(
                color: appTheme.gray600,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.h),
              borderSide: BorderSide(
                color: appTheme.gray600,
                width: 1,
              ),
            ),
      );
}

/// Extension on [CustomFloatingTextField] to facilitate inclusion of all types of border style etc
extension PhoneFieldStyleHelper on CustomPhoneField {
  static OutlineInputBorder get outlineGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.h),
        borderSide: BorderSide(
          color: appTheme.gray600.withOpacity(0.12),
          width: 1,
        ),
      );
}
