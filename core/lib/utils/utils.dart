import 'dart:io';

import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/date_time_utils.dart';
import 'package:core/utils/helper/log.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/error/failure.dart';
import '../config/string_resource/strings.dart';

export 'extensions/extension.dart';
export 'helper/helper.dart';

bool _isInternetAvailable = false;

setNetworkConnectivity(bool isInternetAvailable) {
  _isInternetAvailable = isInternetAvailable;
}

bool isInternetAvailable() {
  return _isInternetAvailable;
}

String getCurrentTimeStamp() {
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return dateTime.toString();
}

showSnackBar({required BuildContext context, required String message}) {
  var snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

enum UserRegStatus {
  newUser(0),
  registeredUser(1),
  customer(2),
  pan(3);

  const UserRegStatus(this.value);

  final int value;
}

enum AppTheme {
  light("light"),
  dark("dark");

  const AppTheme(this.value);

  final String value;
}

UserRegStatus getUserRegisterStatus() {
  if (PrefUtils.getBool(PrefUtils.keyIsCustomer, false)) {
    if (PrefUtils.getBool(PrefUtils.keyIsPAN, false)) {
      return UserRegStatus.pan;
    } else {
      return UserRegStatus.customer;
    }
  } else {
    return UserRegStatus.newUser;
  }
}

enum AuthNavFlow {
  register(0),
  forgotMpin(1),
  changeMpin(2),
  changeUserToCustomer(3);

  const AuthNavFlow(this.value);

  final int value;
}

String getDeviceId() {
  return PrefUtils.getString(PrefUtils.keyDeviceId, "");
}

void setPhoneNumber(phoneNumber) {
  PrefUtils.saveString(PrefUtils.keyPhoneNumber, phoneNumber);
}

String getPhoneNumber() {
  return PrefUtils.getString(PrefUtils.keyPhoneNumber, "");
}

String getUserName() {
  return PrefUtils.getString(PrefUtils.keyUserName, "");
}

void setSuperAppId(String superAppID) {
  PrefUtils.saveString(PrefUtils.keySuperAppId, superAppID);
}

String getSuperAppId() {
  return PrefUtils.getString(PrefUtils.keySuperAppId, "");
}

void setAccessToken(String accessToken) {
  PrefUtils.saveString(PrefUtils.keyToken, accessToken);
}

String getAccessToken() {
  return PrefUtils.getString(PrefUtils.keyToken, '');
}

void setUCIC(String ucic) {
  PrefUtils.saveString(PrefUtils.ucic, ucic);
}

String getUCIC() {
  return PrefUtils.getString(PrefUtils.ucic, '');
}

String getSelectedLanguage() {
  return PrefUtils.getString(PrefUtils.keySelectedLanguage, "en");
}

int getPanLanMaxAttempt() {
  return PrefUtils.getInt(
      PrefUtils.keyPanLanMaxAttempt, AppConst.maxPanLanAttempts);
}

int getCreateMpinMaxAttempt() {
  return PrefUtils.getInt(
      PrefUtils.keyCreateMpinMaxAttempt, AppConst.createMpinMaxAttempt);
}

bool isCustomer() {
  return PrefUtils.getBool(PrefUtils.keyIsCustomer, false);
}

resetRegistrationFlow() {
  PrefUtils.removeData(PrefUtils.keyPhoneNumber);
  PrefUtils.removeData(PrefUtils.keyIsCustomer);
  PrefUtils.removeData(PrefUtils.keyIsPAN);
  PrefUtils.removeData(PrefUtils.keyIsMultipleUCIC);
  PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
  PrefUtils.removeData(PrefUtils.keyUserName);
  PrefUtils.removeData(PrefUtils.keySuperAppId);
  PrefUtils.removeData(PrefUtils.ucic);
}

void removeLoginData() {
  PrefUtils.removeData(PrefUtils.ucic);
  PrefUtils.removeData(PrefUtils.keySuperAppId);
  PrefUtils.removeData(PrefUtils.keyIsCustomer);
  PrefUtils.removeData(PrefUtils.keyIsPAN);
  PrefUtils.removeData(PrefUtils.keyIsMultipleUCIC);
  PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
  PrefUtils.removeData(PrefUtils.keyUserName);
  // PrefUtils.removeData(PrefUtils.keyEnableBioMetric);
  // PrefUtils.removeData(PrefUtils.keyActiveBioMetric);
  PrefUtils.removeData(PrefUtils.keyMpin);
  PrefUtils.removeData(PrefUtils.emailID);
  PrefUtils.removeData(PrefUtils.keyTypeAheadSearchApiTimeStamp);
  PrefUtils.removeData(PrefUtils.keyRecentSearchList);
}

void removeSearchPrefData() {
  PrefUtils.removeData(PrefUtils.keyTypeAheadSearchApiTimeStamp);
  PrefUtils.removeData(PrefUtils.keyRecentSearchList);
}

void setSelectedLanguage(String? selectedLang) {
  PrefUtils.saveString(PrefUtils.keySelectedLanguage, selectedLang ?? "en");
}

String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.startsWith("+91")) {
    return phoneNumber.substring(3, phoneNumber.length);
  } else if (phoneNumber.startsWith("91")) {
    return phoneNumber.substring(2, phoneNumber.length);
  }
  return phoneNumber;
}

void displayForceUpdateAlert(BuildContext context, String message,
    {bool? showLeftButton, Function? onTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: Text(message),
        actions: [
          Visibility(
              visible: showLeftButton ?? false,
              child: TextButton(
                child: Text(
                  getString(lblLater),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onTap!();
                },
              )),
          TextButton(
            child: Text(
              getString(lblUpdate),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (Platform.isAndroid || Platform.isIOS) {
                PackageInfo.fromPlatform().then((value) {
                  final url = Uri.parse(
                    Platform.isAndroid
                        ? "market://details?id=${value.packageName}"
                        : "https://apps.apple.com/app/id${value.packageName}",
                  );
                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                });
              }
            },
          )
        ],
      ); // Your custom dialog widget
    },
  );
}

void displayAlertWithAction(BuildContext context, String message,
    {String? leftBtnLbl,
    String? rightBtnLbl,
    Function? leftBtnTap,
    Function? rightBtnTap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(
              leftBtnLbl ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              leftBtnTap!();
            },
          ),
          TextButton(
            child: Text(
              rightBtnLbl ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              rightBtnTap!();
            },
          ),
        ],
      ); // Your custom dialog widget
    },
  );
}

void displayAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(
              "Exit",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => exit(0));
            },
          )
        ],
      ); // Your custom dialog widget
    },
  );
}

void displayAlertSingleAction(BuildContext context, String message,
    {String? btnLbl, Function? btnTap}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(
              btnLbl ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              btnTap!();
            },
          )
        ],
      ); // Your custom dialog widget
    },
  );
}

int compareVersions(String appVersion, String backendVersion) {
  try {
    if (appVersion.contains("-")) {
      appVersion = appVersion.substring(0, appVersion.length - 4);
      appVersion = appVersion.substring(2, appVersion.length);
    }
    List<String> v1Parts = appVersion.split('.');
    List<String> v2Parts = backendVersion.split('.');

    for (int i = 0; i < 3; i++) {
      int v1Part = int.parse(v1Parts[i]);
      int v2Part = int.parse(v2Parts[i]);
      if (v1Part < v2Part) {
        return -1;
      } else if (v1Part > v2Part) {
        return 1;
      }
    }
  } catch (e) {
    return 0;
  }

  return 0; // Versions are equal
}

String? getFileExtension(String fileName) {
  try {
    return ".${fileName.split('.').last}";
  } catch (e) {
    return null;
  }
}

String getFailureMessage(Failure failure) {
  if (failure is ServerFailure) {
    return failure.message ?? "";
  } else {
    return getString(msgSomethingWentWrong);
  }
}

String formatAccountNumber(String accountNumber) {
  // Add a space after every four digits
  return accountNumber.replaceAllMapped(
      RegExp(r".{4}"), (match) => "${match.group(0)} ");
}

String removeSpecialCharacters(String input) {
  // Remove all special characters except alphanumeric characters and spaces
  return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
}

bool validateUPI(String upi) {
  // Regular expression to match UPI ID format (e.g., username@bank)
  RegExp regex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
  return regex.hasMatch(upi);
}

Future<void> exportLogToDownloadFile(BuildContext mContext) async {
  var exstorage = await Permission.manageExternalStorage.request();
  if (exstorage.isGranted) {
    try {
      Directory? externalDirectory = await getExternalStorageDirectory();
      String path = externalDirectory!.path;
      File file = File('$path/SuperApp/Logs/${getCurrentDate()}.txt');
      File sourceFile = File(file.path);
      if (sourceFile.existsSync()) {
        String? destinationPath =
            "${await getDownloadPath()}/${getCurrentDate()}.txt";

        await sourceFile.copy(destinationPath);
        toastForSuccessMessage(
            context: mContext, msg: "File Exported successfully");
      }
    } catch (error, st) {
      log.e(error.toString(), stackTrace: st);
    }
  }
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }
  } catch (err, st) {
    log.e(err.toString(), stackTrace: st);
  }
  return directory?.path;
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length == 2 || text.length == 5) {
      if (oldValue.text.length < newValue.text.length) {
        return TextEditingValue(
          text: '$text/',
          selection: TextSelection.collapsed(offset: text.length + 1),
        );
      }
    }

    return newValue;
  }
}

Future<String> getUserAgent() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? deviceName;
  String? osVersion;
  String? os;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceName = androidInfo.model ?? 'Unknown';
    osVersion = androidInfo.version.release ?? 'Unknown';
    os = 'Android';
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceName = iosInfo.name ?? 'Unknown';
    osVersion = iosInfo.systemVersion ?? 'Unknown';
    os = 'iOS';
  }

  return '$os $osVersion; $deviceName';
}

Future<int> calculateFileSize(String filePath) async {
  try {
    final file = File(filePath);
    final bytes = await file.length();
    final megabytes = bytes / (1024 * 1024);
    return megabytes.toInt();
  } catch (e) {
    return 0;
  }
}
class IFSCInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final RegExp regExp = RegExp(r'[^A-Z0-9\s]');
    String sanitizedValue = newValue.text.replaceAll(regExp, '');
    return TextEditingValue(
      text: sanitizedValue,
      selection: TextSelection.collapsed(offset: sanitizedValue.length),
    );
  }
}

String getCurrentLang(){
  return PrefUtils.getString(PrefUtils.keySelectedLanguage, "en");
}