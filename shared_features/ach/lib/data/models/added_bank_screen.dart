import 'package:ach/data/models/fetch_bank_accoun_response.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';

class AddedBankScreenModel {
  final LoanData? loanData;
  final List<BankData>? bankData;

  AddedBankScreenModel({
    required this.loanData,
    required this.bankData
  });
}