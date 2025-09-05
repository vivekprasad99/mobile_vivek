import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/config/widgets/common_widgets/custom_pincode/pin_code_fields.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore_for_file: must_be_immutable
class CustomEmailOtpTextField extends StatelessWidget {
  CustomEmailOtpTextField({
    super.key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.length,
  });

  final Alignment? alignment;

  final int? length;

  final BuildContext context;

  final TextEditingController? controller;

  final TextStyle? textStyle;

  final TextStyle? hintStyle;

  Function(String) onChanged;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget,
          )
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => PinCodeTextField(
        appContext: context,
        controller: controller,
        length: length?? 6,
        autoFocus: false,
        obscureText: true,
        obscuringCharacter: '*',
        keyboardType: TextInputType.number,
        textStyle: textStyle ??  Theme.of(context).textTheme.labelMedium,
        hintStyle: hintStyle ?? CustomTextStyles.bodyLargeGray800,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        pinTheme: PinTheme(
          fieldHeight: 52.h,
          fieldWidth: 48.v,
          shape: PinCodeFieldShape.underline,
          borderRadius: BorderRadius.circular(4.h),
          inactiveColor: Theme.of(context).disabledColor,
          activeColor: Theme.of(context).primaryColor,
          fieldOuterPadding: EdgeInsets.zero,
          selectedColor: Theme.of(context).primaryColor,
        ),
        onChanged: (value) => onChanged(value),
        validator: validator,
      );
}
