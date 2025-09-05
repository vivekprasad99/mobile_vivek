import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class ShowCustomDailougeWidget extends StatelessWidget {
  const ShowCustomDailougeWidget(
      {super.key, required this.errorMsg, required this.ontap, required this.buttonTitle});

  final String errorMsg;
  final String buttonTitle;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.v)),
      elevation: 0.0,
      backgroundColor: Theme.of(context).cardColor,
      child: dialogContent(context, brightness),
    );
  }

  Widget dialogContent(BuildContext context, Brightness brightness) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMsg, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 20.h),
            _buildDoneButton(context),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return MfCustomButton(
        text: buttonTitle,
        outlineBorderButton: false,
        isDisabled: false,
        onPressed: ontap);
  }
}
