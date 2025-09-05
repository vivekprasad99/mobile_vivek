import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/datasource/loan_refund_datasource.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_response.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_repository.dart';
import '../models/loan_refund_consent_request.dart';

class LoanRefundRepositoryImpl extends LoanRefundRepository {
  LoanRefundRepositoryImpl({required this.datasource});
  final LoanRefundDatasource datasource;

  @override
  Future<Either<Failure, LoanRefundConsentResponse>> getConsent(LoanRefundConsentRequest request) async {
    final result = await datasource.getConsent(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
