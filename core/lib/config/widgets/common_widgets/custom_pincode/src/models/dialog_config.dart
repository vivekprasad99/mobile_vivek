part of '../../pin_code_fields.dart';

class DialogConfig {
  final String? dialogTitle;
  final String? dialogContent;
  final String? affirmativeText;
  final String? negativeText;
  final PinCodePlatform platform;
  DialogConfig._internal({
    this.dialogContent,
    this.dialogTitle,
    this.affirmativeText,
    this.negativeText,
    this.platform = PinCodePlatform.other,
  });

  factory DialogConfig({
    String? affirmativeText,
    String? dialogContent,
    String? dialogTitle,
    String? negativeText,
    PinCodePlatform? platform,
  }) {
    return DialogConfig._internal(
      affirmativeText: affirmativeText ?? "Paste",
      dialogContent: dialogContent ?? "Do you want to paste this code ",
      dialogTitle: dialogTitle ?? "Paste Code",
      negativeText: negativeText ?? "Cancel",
      platform: platform ?? PinCodePlatform.other,
    );
  }
}
