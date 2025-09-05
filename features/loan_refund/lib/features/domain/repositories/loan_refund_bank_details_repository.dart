import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_response.dart';

abstract class LoanRefundBankDetailsRepository {
  Future<Either<Failure, LoanRefundBankAccountDetailsResponse>> getBankList(LoanRefundBankAccountDetailsRequest request);
}
