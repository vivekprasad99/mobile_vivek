
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/datasource/loan_refund_bank_details_datasource.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_response.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_bank_details_repository.dart';

class LoanRefundBankDetailsRepositoryImpl extends LoanRefundBankDetailsRepository {
  LoanRefundBankDetailsRepositoryImpl({required this.datasource});
  final LoanRefundBankDetailsDatasource datasource;

  @override
  Future<Either<Failure, LoanRefundBankAccountDetailsResponse>> getBankList(LoanRefundBankAccountDetailsRequest request) async {
    final result = await datasource.getLoansList(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
