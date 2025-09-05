import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_response.dart';

abstract class LoanRefundRepository {
  Future<Either<Failure, LoanRefundConsentResponse>> getConsent(LoanRefundConsentRequest request);
}
