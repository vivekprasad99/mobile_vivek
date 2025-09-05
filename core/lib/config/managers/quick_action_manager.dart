import 'package:flutter/material.dart';
import 'package:locate_us/locate_us.dart' as locate_us;
import 'package:url_launcher/url_launcher.dart';
import '../string_resource/strings.dart';

class QuickActionManager {
  static final QuickActionManager _quickActionManager =
      QuickActionManager._internal();

  factory QuickActionManager() {
    return _quickActionManager;
  }

  QuickActionManager._internal();

  void makePhoneCall(String phone, context) async {
    Uri phoneno = Uri.parse('tel:$phone');
    if (await canLaunchUrl(phoneno)) {
      await launchUrl(phoneno);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getString(msgSomethingWentWrong)),
        backgroundColor: Colors.red,
      ));
    }
  }

  void triggerLocateUs(BuildContext context) {
    locate_us.LocateUsServices.trigger(context);
  }
}
