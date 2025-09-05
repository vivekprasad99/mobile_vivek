import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/app_colors.dart';

class MfCustomFloatingTextField extends StatelessWidget {
  const MfCustomFloatingTextField({
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
    this.minLines,
    this.isReadOnly = false,
    this.inputFormatters,
    this.onTap,
    this.textCapitalization = TextCapitalization.none
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
  final TextCapitalization textCapitalization;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final void Function(String)? onChange;

  final int? maxLength;

  final int? minLines;

  final bool isReadOnly;

  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;

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
          minLines: minLines,
          readOnly: isReadOnly,
          maxLength: maxLength,
          onChanged: onChange,
          inputFormatters: inputFormatters ?? [],
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: controller,
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
          textCapitalization: textCapitalization,
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
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding:
            contentPadding ?? EdgeInsets.fromLTRB(10.h, 10.v, 16.h, 10.v),
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
