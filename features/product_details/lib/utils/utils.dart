
import 'package:ach/config/ach_const.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/utils/extensions/extension.dart';
import '../data/models/active_loan_list_response.dart';

LoanData mappingLoanData(ActiveLoanData activeLoanData){
  var loanData = LoanData();
  loanData.ucic = activeLoanData.ucic;
  loanData.cif = activeLoanData.cif;
  if (loanData.coApplicantCIF == null ||
      loanData.coApplicantCIF!.equalsIgnoreCase("null")  ||
      loanData.coApplicantCIF!.isEmpty) {
    loanData.coApplicantCIF = null;
  } else {
    loanData.coApplicantCIF = activeLoanData.coApplicantCif;
  }

  loanData.branchId = activeLoanData.branchId;
  loanData.loanAccountNumber = activeLoanData.loanNumber;
  loanData.totalAmount = activeLoanData.totalOutstandingAmount;
  loanData.totalPendingAmount = activeLoanData.totalAmountOverdue;
  loanData.interestRate = activeLoanData.interestRate;
  loanData.installmentAmount = activeLoanData.installmentAmount;
  loanData.excessAmount = activeLoanData.excessAmount;
  loanData.startDate = activeLoanData.startDate;
  loanData.endDate = activeLoanData.endDate;
  loanData.nextDuedate = activeLoanData.nextDuedate;
  loanData.loanStatus = activeLoanData.loanStatus;
  loanData.dpd = int.parse(activeLoanData.dpd?.isNotEmpty==true ? activeLoanData.dpd.toString() : "0") ;
  loanData.lob = activeLoanData.lob;
  loanData.productName = activeLoanData.productName;
  loanData.vehicleRegistration = activeLoanData.vehicleRegistration;
  loanData.sourceSystem = activeLoanData.sourceSystem;
  loanData.productCategory = activeLoanData.productCategory;
  loanData.mandateStatus = activeLoanData.mandateStatus;
  loanData.nocStatus = activeLoanData.nocStatus;
  return loanData;
}

String getMandateStatus(String mandateStatus) {
  if (mandateStatus == AchConst.nullMandateStatus) {
    return getString(lblCreateMandate);
  } else if (mandateStatus == AchConst.activeMandateStatus) {
    return getString(lblUpdateMandate);
  }
  return getString(lblCreateMandate);
}