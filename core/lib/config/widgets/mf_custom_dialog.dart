import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

void showMfCustomDialog(
  BuildContext context, {
  required String msg,
  required String buttonTitle,
  required VoidCallback onTap,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return MfCustomDialog(
        msg: msg,
        onTap: onTap,
        buttonTitle: buttonTitle,
      );
    },
  );
}

class MfCustomDialog extends StatelessWidget {
  const MfCustomDialog({
    super.key,
    required this.msg,
    required this.onTap,
    required this.buttonTitle,
  });

  final String msg;
  final String buttonTitle;
  final VoidCallback onTap;

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
            Text(msg, style: Theme.of(context).textTheme.titleMedium),
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
        onPressed: onTap);
  }
}
