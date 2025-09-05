import 'package:billpayments/config/network/api_endpoints.dart';
import 'package:billpayments/features/data/models/bill_payment_request.dart';
import 'package:billpayments/features/data/models/get_bill_payments_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';

class BillPaymentsDatasource {
  DioClient dioClient;

  BillPaymentsDatasource({required this.dioClient});

  Future<Either<Failure, GetBillPaymentResponse>> getBbpsUrl(
      BillPaymentRequest billPaymentRequest) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getBbpsRedirectUrl),
        converter: (response) =>
            GetBillPaymentResponse.fromJson(response as Map<String, dynamic>),
        data: billPaymentRequest.toJson());
    return response;
  }
}
