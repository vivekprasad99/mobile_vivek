import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/datasource/loan_refund_add_bank_account_datasource.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_response.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_add_bank_account_repository.dart';

class LoanRefundAddBankAccountRepositoryImpl extends LoanRefundAddBankAccountRepository {
  LoanRefundAddBankAccountRepositoryImpl({required this.datasource});
  final LoanRefundAddBankAccountDatasource datasource;


  @override
  Future<Either<Failure, LoanRefundAddBankAccountResponse>> addBankAccount(LoanRefundAddBankAccountRequest request) async {
   final result = await datasource.addBankAccount(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}