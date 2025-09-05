import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_request.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_response.dart';
import '../../../config/network/api_endpoints.dart';

class LoanRefundDatasource {
  DioClient dioClient;

  LoanRefundDatasource({required this.dioClient});

  Future<Either<Failure, LoanRefundConsentResponse>> getConsent(
      LoanRefundConsentRequest loanRefundConsentRequest) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getConsent),
        converter: (response) => LoanRefundConsentResponse.fromJson(
            response as Map<String, dynamic>),
        data: loanRefundConsentRequest.toJson());
    return response;
  }
}
