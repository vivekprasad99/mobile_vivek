
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_response.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_bank_details_repository.dart';

class LoanRefundBankDetailsUseCase extends UseCase<LoanRefundBankAccountDetailsResponse, LoanRefundBankAccountDetailsRequest> {
  final LoanRefundBankDetailsRepository repository;
  LoanRefundBankDetailsUseCase({required this.repository});

  @override
  Future<Either<Failure, LoanRefundBankAccountDetailsResponse>> call(LoanRefundBankAccountDetailsRequest params) async {
    return await repository.getBankList(params);
  }
}