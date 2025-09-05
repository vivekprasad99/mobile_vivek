import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFloatingTextField extends StatelessWidget {
  const CustomFloatingTextField({
    super.key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.counterText,
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
    this.onChange,
    this.maxLength,
    this.isReadOnly = false,
    this.inputFormatters,
    this.onTap,
    this.helperText,
    this.helperTextstyle,
    this.prefixText,
    this.prefixStyle,
    this.textCapitalization,
  });

  final Alignment? alignment;

  final double? width;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final String? counterText;

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

  final void Function(String)? onChange;

  final int? maxLength;

  final bool isReadOnly;

  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final String? helperText;
  final TextStyle? helperTextstyle;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final TextCapitalization? textCapitalization;

  @override
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: !isReadOnly,
          readOnly: isReadOnly,
          maxLength: maxLength,
          onChanged: onChange,
          inputFormatters: inputFormatters ?? [],
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          // focusNode: focusNode ?? FocusNode(),
          autofocus: autofocus!,
          style: textStyle ?? CustomTextStyles.bodyMediumGray800,
          obscureText: obscureText!,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          cursorColor: Theme.of(context).hintColor,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );
  InputDecoration get decoration => InputDecoration(
      errorMaxLines: 2,
      errorStyle: const TextStyle(color: AppColors.textFieldErrorColor),
      counterText: counterText ?? "",
      hintText: hintText ?? "",
      hintStyle: hintStyle ?? theme.textTheme.bodyLarge,
      labelText: labelText ?? "",
      labelStyle: labelStyle,
      prefixIcon: prefix,
      helperStyle: helperTextstyle,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      isDense: true,
      helperText: helperText,
      contentPadding:
          contentPadding ?? EdgeInsets.fromLTRB(10.h, 10.v, 16.h, 10.v),
      fillColor: fillColor,
      filled: filled,
      focusedErrorBorder: borderDecoration ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.h),
            borderSide: BorderSide(
              color: appTheme.gray600,
              width: 1,
            ),
          ),
      errorBorder: borderDecoration ??
          OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.h),
            borderSide: BorderSide(
              color: appTheme.gray600,
              width: 1,
            ),
          ),
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
      prefixText: prefixText,
      prefixStyle: prefixStyle);
}

/// Extension on [CustomFloatingTextField] to facilitate inclusion of all types of border style etc
extension FloatingTextFormFieldStyleHelper on CustomFloatingTextField {
  static OutlineInputBorder get outlineGray => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.h),
        borderSide: BorderSide(
          color: appTheme.gray600.withOpacity(0.12),
          width: 1,
        ),
      );
}
