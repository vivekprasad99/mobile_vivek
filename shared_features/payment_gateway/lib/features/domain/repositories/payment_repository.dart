import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_gateway/features/data/models/get_payment_option_data_model.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_request.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_response.dart';
import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_reponse.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_request.dart';

abstract class PaymentGatewayRepository {
  Future<Either<Failure, GetTransactionIdResponse>> getTransactionId(
      GetTransactionIdRequest getTransactionIDRequest);

  Future<Either<Failure, UpdatePaymentDetailResponse>> updatePaymentDetial(
      UpdatePaymentDetailRequest updatePaymentDetailRequest);
      
  Future<Either<Failure, PaymentCredentialsResponseModel>> getPaymentCredentials();
  Future<Either<Failure, PaymentOptionsResponeModel>> getPaymentOptionsData();
}
