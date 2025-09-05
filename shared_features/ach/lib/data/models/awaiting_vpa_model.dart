import 'package:ach/data/models/validate_vpa_resp.dart';

import '../../config/ach_util.dart';
import 'get_ach_loans_response.dart';
import 'get_bank_list_resp.dart';

class AwaitingVPAModel {
  LoanData? loanData;
  VerificationOption? verificationMode;
  String? bankName;
  String? bankCode;
  String? bankAccountNumber;
  String? selectedApplicant;
  String? trxnNo;
  String? refNo;
  AccountType? accountType;
  VpaData? vpaData;

  AwaitingVPAModel({
    this.loanData,
    this.verificationMode,
    this.bankName,
    this.bankCode,
    this.bankAccountNumber,
    this.selectedApplicant,
    this.trxnNo,
    this.accountType,
    this.vpaData,
    this.refNo
  });
}
