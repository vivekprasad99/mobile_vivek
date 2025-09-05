import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_response.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_add_bank_account_repository.dart';

class LoanRefundAddBankAccountUseCase extends UseCase<LoanRefundAddBankAccountResponse, LoanRefundAddBankAccountRequest> {
  final LoanRefundAddBankAccountRepository repository;
  LoanRefundAddBankAccountUseCase({required this.repository});

  @override
  Future<Either<Failure, LoanRefundAddBankAccountResponse>> call(LoanRefundAddBankAccountRequest params) async {
    return await repository.addBankAccount(params);
  }
}
