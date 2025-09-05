import 'dart:io';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File> pickAndRenameImage(XFile pickedFile, String feature) async {
  String? fileMimeType = getFileExtension(pickedFile.path);
  final File originalFile = File(pickedFile.path);
  final directory = await getApplicationDocumentsDirectory();
  final String newFileName =
      "${feature}_${DateTime.now().millisecondsSinceEpoch}${fileMimeType!}";
  final String newFilePath = path.join(directory.path, newFileName);
  final File renamedFile = await originalFile.copy(newFilePath);
  return renamedFile;
}

LoanData mappingLoanData(LoanItem activeLoanData) {
  var loanData = LoanData();
  loanData.ucic = activeLoanData.ucic;
  loanData.cif = activeLoanData.cif;
  if (activeLoanData.coApplicantCIF == null ||
      activeLoanData.coApplicantCIF!.equalsIgnoreCase("null") ||
      activeLoanData.coApplicantCIF!.isEmpty) {
    loanData.coApplicantCIF = null;
  } else {
    loanData.coApplicantCIF = activeLoanData.coApplicantCIF;
  }

  loanData.loanAccountNumber = activeLoanData.loanNumber;
  loanData.totalAmount = double.parse(activeLoanData.totalAmount ?? "0.0");
  loanData.totalPendingAmount =
      double.parse(activeLoanData.totalPendingAmount ?? "0.0");
  loanData.installmentAmount =
      double.parse(activeLoanData.installmentAmount ?? "0.0");
  loanData.startDate = activeLoanData.startDate;
  loanData.endDate = activeLoanData.endDate;
  loanData.nextDuedate = activeLoanData.nextDuedate;
  loanData.loanStatus = activeLoanData.loanStatus;
  loanData.dpd = activeLoanData.dpd;
  loanData.lob = activeLoanData.lob;
  loanData.productName = activeLoanData.productName;
  loanData.vehicleRegistration = activeLoanData.vehicleRegistration;
  loanData.sourceSystem = activeLoanData.sourceSystem;
  loanData.productCategory = activeLoanData.productCategory;
  loanData.mandateStatus = activeLoanData.mandateStatus;
  loanData.nocStatus = activeLoanData.nocStatus;
  return loanData;
}

String convertDateTime(String date) {
  if (date.contains("-")) {
    if (date.isEmpty) date = '2024-05-25 21:35:00';
    DateFormat inputDateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dateTime = inputDateFormat.parse(date);
    // Define the output format
    DateFormat outputDateFormat = DateFormat('dd MMM yy HH:mm');
    // Format the DateTime object to the desired output format
    String formattedDate = outputDateFormat.format(dateTime);
    return formattedDate;
  } else {
    if (date.isEmpty) date = '25/05/2024 21:35';
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    DateTime dateTime = dateFormat.parse(date);
    DateFormat outputDateFormat = DateFormat('dd MMM yy HH:mm');

// Format the DateTime object to the desired output format
    String formattedDate = outputDateFormat.format(dateTime);
    return formattedDate;
  }
}

enum ProfileScreenName {
  pan("pan"),
  email("email"),
  mobile("mobile"),
  addressPermanent("addressPermanent"),
  addressCurrent("addressCurrent");

  const ProfileScreenName(this.value);

  final String value;
}
