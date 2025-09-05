import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_response.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_repository.dart';

class LoanRefundUseCase extends UseCase <LoanRefundConsentResponse, LoanRefundConsentRequest> {
  final LoanRefundRepository repository;
  LoanRefundUseCase({required this.repository});

  @override
  Future<Either<Failure, LoanRefundConsentResponse>> call(LoanRefundConsentRequest params) async {
    return await repository.getConsent(params);
  }
}