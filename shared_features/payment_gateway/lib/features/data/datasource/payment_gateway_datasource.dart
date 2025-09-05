import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_gateway/config/network/api_endpoints.dart';
import 'package:payment_gateway/features/data/models/get_payment_option_data_model.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_request.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_response.dart';
import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_reponse.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_request.dart';

class PaymentGatewayDataSource {
  DioClient dioClient;

  PaymentGatewayDataSource({required this.dioClient});

  Future<Either<Failure, GetTransactionIdResponse>> getTransactionId(
      GetTransactionIdRequest request) async {
    final response = await dioClient.postRequest(
      getMsApiUrl(ApiEndpoints.getTransactionId),
      data: request.toJson(),
      converter: (response) =>
          GetTransactionIdResponse.fromJson(response as Map<String, dynamic>),
    );
    return response;
  }

  Future<Either<Failure, PaymentCredentialsResponseModel>>
      getPaymentCredentials() async {
    final response = await dioClient.getRequest(
      getMsApiUrl(ApiEndpoints.getPaymentCredentials),
      converter: (response) => PaymentCredentialsResponseModel.fromJson(
          response as Map<String, dynamic>),
    );
    return response;
  }

  Future<Either<Failure, UpdatePaymentDetailResponse>> updatePaymentDetail(
      UpdatePaymentDetailRequest request) async {
    final response = await dioClient.postRequest(
      getMsApiUrl(ApiEndpoints.updatePaymentDetail),
      data: request.toJson(),
      converter: (response) => UpdatePaymentDetailResponse.fromJson(
          response as Map<String, dynamic>),
    );
    return response;
  }

  Future<Either<Failure, PaymentOptionsResponeModel>>
      getPaymentOptionsData() async {
    final response = await dioClient.getRequest(
      getMsApiUrl(ApiEndpoints.getPaymentOptions),
      converter: (response) => PaymentOptionsResponeModel.fromJson(
          response as Map<String, dynamic>),
    );
    return response;
  }
}
