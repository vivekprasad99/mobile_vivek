import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:profile/data/models/addr_document_dropdown_model.dart';

import '../data/models/active_loan_list_response.dart';

enum OtpScreenType {
  mobileOtp("mobile_otp"),
  aadhaarOtp("aadhaar_otp"),
  emailOtp("email_otp");

  const OtpScreenType(this.value);

  final String value;
}

enum Operation {
  updatePhoneNumber("update_phone_number"),
  updateAddress("update_address"),
  updateEmail("update_email"),
  updatePan("update_pan"),
  mapMyLoan("map_my_loan");

  const Operation(this.value);

  final String value;
}

enum ConfirmDetailScreenType {
  aadhaarDetails("aadhaar_details"),
  addressDrivingLicenseDetails("address_driving_license_details");

  const ConfirmDetailScreenType(this.value);

  final String value;
}

enum AddressType {
  permanent("Permanent"),
  current("Residence");

  const AddressType(this.value);

  final String value;
}

enum MaskingFieldType {
  email("email"),
  pan("pan"),
  aadhaar("aadhaar"),
  mobile("mobile");

  const MaskingFieldType(this.value);

  final String value;
}

enum ProfileImageType {
  file("file"),
  memory("memory");

  const ProfileImageType(this.value);

  final String value;
}

enum AddressAuthDropdownType {
  aadhaar("Aadhaar"),
  drivingLicense("Driving license"),
  passport("Passport"),
  voterID("Voter ID"),
  voterIDNew("Voter ID New"),
  electricityBill("Electricity bill"),
  telephoneBill("Landline telephone bill"),
  postPaidMobile("Post-paid mobile phone bill"),
  pipelineBill("Pipeline gas bill"),
  waterBill("Water Bill"),
  municipalTax("Municipal Property tax receipt"),
  pension("Pension or family pension payment orders (PPOs)"),
  letterOfAllotment("Letter of allotment of accomodation"),
  offlineAadhaar("Offline Aadhaar"),
  offlineDrivingLicense("Offline Driving License");

  const AddressAuthDropdownType(this.value);

  final String value;
}

List<AddressDocumentDropdownModel> getDropdownItems(AddressType type) {
  bool isSameAddress =
      PrefUtils.getBool(PrefUtils.isAddressSameAsCurrent, false);
  List<AddressDocumentDropdownModel> list1 = [
    AddressDocumentDropdownModel('aadhaar', 'Aadhaar'),
    AddressDocumentDropdownModel('drivingLicense', 'Driving license'),
  ];
  List<AddressDocumentDropdownModel> list2 = [
    AddressDocumentDropdownModel('passport', 'Passport'),
    AddressDocumentDropdownModel('voterID', 'Voter ID'),
    AddressDocumentDropdownModel('voterIDNew', 'Voter ID New')
  ];
  List<AddressDocumentDropdownModel> list3 = [
    AddressDocumentDropdownModel('electricityBill', 'Electricity bill'),
    AddressDocumentDropdownModel('telephoneBill', 'Landline telephone bill'),
    AddressDocumentDropdownModel(
        'postPaidMobile', 'Post-paid mobile phone bill'),
    AddressDocumentDropdownModel('pipelineBill', 'Pipeline gas bill'),
    AddressDocumentDropdownModel('waterBill', 'Water Bill'),
    AddressDocumentDropdownModel(
        'municipalTax', 'Municipal Property tax receipt'),
    AddressDocumentDropdownModel(
        'pension', 'Pension or family pension payment orders (PPOs)'),
    AddressDocumentDropdownModel(
        'letterOfAllotment', 'Letter of allotment of accommodation'),
    AddressDocumentDropdownModel('offlineAadhaar', 'Offline Aadhaar'),
    AddressDocumentDropdownModel(
        'offlineDrivingLicense', 'Offline Driving License')
  ];

  if (type == AddressType.permanent) {
    return [...list1, ...list2];
  } else if (isSameAddress && type == AddressType.current) {
    return [...list1, ...list2];
  } else {
    return [...list2, ...list3];
  }
}

String generateCaseId() {
  Random random = Random();
  StringBuffer stringBuffer = StringBuffer();

  // Ensure the first digit is non-zero (1-9) to keep the number 13 digits long
  stringBuffer.write(random.nextInt(9) + 1);

  // Generate the remaining 12 digits (0-9)
  for (int i = 0; i < 12; i++) {
    stringBuffer.write(random.nextInt(10));
  }

  return stringBuffer.toString();
}

class IPAddress {
  String ip;

  IPAddress(this.ip);
}

String maskString(String input, MaskingFieldType type,
    {String maskChar = '*'}) {
  String start = "", end = "", middle = "";
  switch (type) {
    case MaskingFieldType.pan:
      if (input.length < 3) return input;
      String lastTwo = input.substring(input.length - 2);
      String maskedPart = '*' * (input.length - 2);
      start = maskedPart + lastTwo;
      break;

    case MaskingFieldType.mobile:
      if (input.length <= 4) {
        return input;
      }
      start = input.substring(0, 2);
      end = input.substring(input.length - 2);
      middle = maskChar * (input.length - 4);

      break;

    case MaskingFieldType.email:
      int atIndex = input.indexOf('@');
      if (atIndex == -1) return input;

      String localPart = input.substring(0, atIndex);
      if (localPart.length < 3) return input;
      String firstTwo = localPart.substring(0, 2);
      String lastChar = localPart[localPart.length - 1];
      String maskedPart = '*' * (localPart.length - 3);
      String obfuscatedLocalPart = firstTwo + maskedPart + lastChar;
      String obfuscatedEmail = obfuscatedLocalPart + input.substring(atIndex);

      start = obfuscatedEmail;

      break;

    case MaskingFieldType.aadhaar:
      if (input.length <= 2) {
        return input;
      }

      start = 'x' * (input.length - 2) + input.substring(input.length - 2);

      break;
    default:
  }
  return '$start$middle$end';
}

Future<String> getDeviceIp() async {
  try {
    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.json);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    return data.toString();
  } on IpAddressException {
    return "";
  }
}

Future<String> convertImgToBase64(imagePath) async {
  File imageFile = File(imagePath);
  Uint8List bytes = await imageFile.readAsBytes();
  String base64String = base64Encode(bytes);
  return base64String;
}

class PanCardInputFormatter extends TextInputFormatter {
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

List<ActiveLoanData>? getActiveLoanList(List<ActiveLoanData> loanList)  {
   return loanList.where((item) => item.loanStatus.toString().equalsIgnoreCase("active")).toList();
}


