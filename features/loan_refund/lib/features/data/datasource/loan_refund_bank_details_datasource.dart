import 'dart:convert';

import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_response.dart';

class LoanRefundBankDetailsDatasource {
  DioClient dioClient;
  LoanRefundBankDetailsDatasource({required this.dioClient});

  Future<Either<Failure, LoanRefundBankAccountDetailsResponse>> getLoansList(
      LoanRefundBankAccountDetailsRequest getAchLoansRequest) async {
    final loanListStubData = await rootBundle.loadString('assets/stubdata/loan_refund/bank_list.json');
    final body = json.decode(loanListStubData);
   Either<Failure, LoanRefundBankAccountDetailsResponse> response = Right(
      LoanRefundBankAccountDetailsResponse.fromJson(body as Map<String, dynamic>));
    return response;
  }
}
