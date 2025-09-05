import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:core/config/string_resource/strings.dart';


class ThanksFeedbackDialogBox extends StatelessWidget {
  final Function(BuildContext dialogContex) onTap;
  const ThanksFeedbackDialogBox(this.onTap,{super.key});

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

  Widget dialogContent(BuildContext dialogContex, Brightness brightness) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.v),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(getString(labelThankFeedback),
              style: Theme.of(dialogContex).textTheme.titleLarge,),
          SizedBox(height: 8.h),
          Text(getString(msgImproveTheApp),
              style: Theme.of(dialogContex).textTheme.labelMedium,),
          SizedBox(height: 16.h),
          _buildDoneButton(dialogContex),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext dialogContex) {
    return MfCustomButton(
        text: getString(labelDone),
        outlineBorderButton: false,
        isDisabled: false,
        onPressed: () {
          onTap(dialogContex);
        },);
  }
}
