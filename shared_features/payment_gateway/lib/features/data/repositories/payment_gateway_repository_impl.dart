import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_gateway/features/data/datasource/payment_gateway_datasource.dart';
import 'package:payment_gateway/features/data/models/get_payment_option_data_model.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_request.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_response.dart';
import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_reponse.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_request.dart';
import 'package:payment_gateway/features/domain/repositories/payment_repository.dart';

class PaymentGatewayRepositoryImpl implements PaymentGatewayRepository {
  PaymentGatewayRepositoryImpl({required this.datasource});
  final PaymentGatewayDataSource datasource;

  @override
  Future<Either<Failure, GetTransactionIdResponse>> getTransactionId(
      GetTransactionIdRequest getTransactionIDRequest) async {
    final result = await datasource.getTransactionId(getTransactionIDRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
  
  @override
  Future<Either<Failure, UpdatePaymentDetailResponse>> updatePaymentDetial(UpdatePaymentDetailRequest updatePaymentDetailRequest) 
  async{
    final result = await datasource.updatePaymentDetail(updatePaymentDetailRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, PaymentCredentialsResponseModel>> getPaymentCredentials()async{
    final result = await datasource.getPaymentCredentials();
    return result.fold((left) => Left(left), (right) => Right(right));
  }
  @override
  Future<Either<Failure, PaymentOptionsResponeModel>> getPaymentOptionsData()async{
    final result = await datasource.getPaymentOptionsData();
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
