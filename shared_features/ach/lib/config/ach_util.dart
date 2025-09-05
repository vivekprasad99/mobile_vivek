import 'dart:io';
import 'dart:math';

import 'package:core/utils/extensions/extension.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

enum MandateStatus {
  createMandate(0),
  updateMandate(1),
  holdMandate(2);

  const MandateStatus(this.value);
  final int value;
}

enum AccountType {
  savingAccount("Saving Account", "SA", "SAVINGS"),
  currentAccount("Current Account","CA", "CURRENT");
  const AccountType(this.label, this.value, this.tag);
  final String value;
  final String label;
  final String tag;
}

enum VerificationMode {
  netBanking("NetBanking","net_banking","N"),
  debitCard("Debit Card","debit_card","D"),
  aadhaar("Aadhaar","aadhaar","A"),
  upi("UPI","upi","UA");

  const VerificationMode(this.label,this.value,this.shortCode);
  final String label;
  final String value;
  final String shortCode;
}

VerificationMode getVerificationModeShortCode(String verificationType){
  if(verificationType == VerificationMode.netBanking.value){
    return VerificationMode.netBanking;
  } else if(verificationType == VerificationMode.debitCard.value){
    return VerificationMode.debitCard;
  } else if(verificationType == VerificationMode.aadhaar.value){
    return VerificationMode.aadhaar;
  } else if(verificationType == VerificationMode.upi.value){
    return VerificationMode.upi;
  }
  return VerificationMode.netBanking;
}

String getMandateType(String verificationType){
  if(verificationType == VerificationMode.netBanking.value || verificationType == VerificationMode.debitCard.value){
    return "EMNDT";
  }  else if(verificationType == VerificationMode.aadhaar.value){
    return "AADH";
  } else if(verificationType == VerificationMode.upi.value){
    return "UPIM";
  }
  return "EMNDT";
}

enum LoanType {
  personalLoan("Personal Loan", "Personal Loan"),
  vehicleLoan("Vehicle Loan", "Vehicle Loan");

  const LoanType(this.label, this.value);
  final String value;
  final String label;
}

String getCurrentDate(){
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

Future<File> pickAndRenameImage(XFile pickedFile, String feature) async {
  // String? fileMimeType = getFileExtension(pickedFile.path);
  final File originalFile = File(pickedFile.path);
  String basename = path.basename(originalFile.path);
  final directory = await getApplicationDocumentsDirectory();
  final String newFileName = "$feature-${DateTime.now().millisecondsSinceEpoch}#&#$basename";
  final String newFilePath = path.join(directory.path, newFileName);
  final File renamedFile = await originalFile.copy(newFilePath);
  return renamedFile;
}

String generateRandom16DigitNumber() {
  Random random = Random();
  StringBuffer stringBuffer = StringBuffer();
  stringBuffer.write(random.nextInt(9) + 1);
  // Generate the remaining 15 digits (0-9)
  for (int i = 0; i < 15; i++) {
    stringBuffer.write(random.nextInt(10));
  }
  return stringBuffer.toString();
}

enum VPAStatus {
  pending("PENDING"),
  active("ACTIVE"),
  rejected("REJECTED"),
  revoked("REVOKED"),
  pause("PAUSE");

  const VPAStatus(this.status);
  final String status;
}

enum EnachStatus {
  pending("PENDING"),
  failed("FAILURE"),
  rejected("REJECTED"),
  success("SUCCESS"),
  lodged("LODGED");


  const EnachStatus(this.status);
  final String status;
}

String getFormattedFileName(String filename) {
  try {
    return filename.split("#&#")[1];
  } catch (e) {
    return filename;
  }
}

enum MandateSourceType {
  cams("Cams"),
  nupay("nupay");

  const MandateSourceType(this.label);
  final String label;
}

enum NupayStatusCode {
  np000("NP000","Request accepted successfully OR Success."),
  np001("NP001","Record not found."),
  np002("NP002","Error"),
  np004("NP004","Login failed."),
  np005("NP005","Record already exists."),
  np003("NP003","Mandatory field is required OR fields validation error."),
  np031("NP031","Authorization failed."),
  np034("NP034","Token mismatch."),
  np041("NP041","Internal Server Error - Please try Later.");

  const NupayStatusCode(this.status, this.desc);
  final String status;
  final String desc;
}

enum NupayStatus {
  rejected("rejected"),
  accepted("accepted"),
  ack("ACK"),
  inProcess("InProcess"),
  expired("expired"),
  failed("failed");


  const NupayStatus(this.status);
  final String status;
}

enum MandateJourney {
  productDetail("ProductDetail"),
  refund("Refund");
  const MandateJourney(this.name);
  final String name;
}

enum MandateSource {
  cams("cams"),
  nupay("nupay");
  const MandateSource(this.name);
  final String name;
}


bool isValidBankAccount(String accountNumber) {
  // Check if the account number is not empty
  if (accountNumber.isEmpty) {
    return false;
  }

  // Check if the account number contains only digits
  final isDigitsOnly = RegExp(r'^[0-9]+$').hasMatch(accountNumber);
  if (!isDigitsOnly) {
    return false;
  }

  // Check the length of the account number (example: length should be between 10 and 16 digits)
  if (accountNumber.length < 10 || accountNumber.length > 16) {
    return false;
  }

  return true;
}

bool isValidIFSC(String ifsc) {
  // Check if the length is 11 characters
  if (ifsc.length != 11) {
    return false;
  }

  // Check if the first four characters are alphabetic
  if (!RegExp(r'^[A-Z]{4}').hasMatch(ifsc)) {
    return false;
  }

  // Check if the fifth character is '0'
  if (ifsc[4] != '0') {
    return false;
  }

  // Check if the last six characters are numeric
  if (!RegExp(r'^[0-9]{6}$').hasMatch(ifsc.substring(5))) {
    return false;
  }

  return true;
}


bool isActiveMandate(String mandateStatus) {
  return mandateStatus.equalsIgnoreCase("Active") ||
      mandateStatus.equalsIgnoreCase("Completed") ||
      mandateStatus.equalsIgnoreCase("Hold") ||
      mandateStatus.equalsIgnoreCase("Approved");
}

bool isSetMandate(String mandateStatus) {
  return mandateStatus.equalsIgnoreCase("Reject") ||
      mandateStatus.equalsIgnoreCase("NULL") ||
      mandateStatus.equalsIgnoreCase("Rejected") ||
      mandateStatus.equalsIgnoreCase("New") ||
      mandateStatus.equalsIgnoreCase("") ||
      mandateStatus.equalsIgnoreCase("Closed");
}

bool isMandateDisable(String mandateStatus, String sourceSystem) {
  if (sourceSystem.equalsIgnoreCase("Autofin")) {
    if (mandateStatus.equalsIgnoreCase("relodgement")) {
      return true;
    }
  } else if (sourceSystem.equalsIgnoreCase("Pennant")) {
    if (mandateStatus.equalsIgnoreCase("Awaiting confirmation")) {
      return true;
    }
  }
  return false;
}

String getMandateStatusLabel(String mandateStatus, String sourceSystem) {
  if (sourceSystem.equalsIgnoreCase("Autofin")) {
    if (mandateStatus.equalsIgnoreCase("Active")) {
      return "Active";
    } else if (mandateStatus.equalsIgnoreCase("Reject")) {
      return "Rejected";
    } else if (mandateStatus.equalsIgnoreCase("Relodgement")) {
      return "In progress";
    } else if (mandateStatus.equalsIgnoreCase("NULL")) {
      return "Set Mandate";
    } else if (mandateStatus.equalsIgnoreCase("Blank")) {
      return "Set Mandate";
    }
  } else if (sourceSystem.equalsIgnoreCase("Finnone")) {
    if (mandateStatus.equalsIgnoreCase("Closed")) {
      return "Inactive";
    } else if (mandateStatus.equalsIgnoreCase("Completed")) {
      return "Active";
    } else if (mandateStatus.equalsIgnoreCase("Rejected")) {
      return "Rejected";
    }
  } else if (sourceSystem.equalsIgnoreCase("Pennant")) {
    if (mandateStatus.equalsIgnoreCase("New")) {
      return "Set Mandate";
    } else if (mandateStatus.equalsIgnoreCase("Awaiting confirmation")) {
      return "In progress";
    } else if (mandateStatus.equalsIgnoreCase("Hold")) {
      return "Inactive";
    } else if (mandateStatus.equalsIgnoreCase("Rejected")) {
      return "Rejected";
    } else if (mandateStatus.equalsIgnoreCase("Approved")) {
      return "Active";
    }
  }
  return mandateStatus;
}
