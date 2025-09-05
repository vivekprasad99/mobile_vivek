import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_response.dart';

abstract class LoanRefundAddBankAccountRepository {
  Future<Either<Failure, LoanRefundAddBankAccountResponse>> addBankAccount(LoanRefundAddBankAccountRequest request);
}
