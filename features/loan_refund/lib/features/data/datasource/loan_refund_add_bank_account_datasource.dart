import 'dart:convert';

import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_response.dart';

class LoanRefundAddBankAccountDatasource {
  DioClient dioClient;
  LoanRefundAddBankAccountDatasource({required this.dioClient});

  Future<Either<Failure, LoanRefundAddBankAccountResponse>> addBankAccount(
      LoanRefundAddBankAccountRequest addBankAccountRequest) async {
    final loanListStubData = await rootBundle.loadString('assets/stubdata/loan_refund/add_bank_account.json');
    final body = json.decode(loanListStubData);
    Either<Failure, LoanRefundAddBankAccountResponse> response =
        Right(LoanRefundAddBankAccountResponse.fromJson(body as Map<String, dynamic>));
    return response;
  }
}
