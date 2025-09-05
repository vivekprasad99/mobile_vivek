import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payment_gateway/features/domain/repositories/payment_repository.dart';

class GetPaymentCredentialsUsecase
    extends UseCase<PaymentCredentialsResponseModel, NoParams> {
  final PaymentGatewayRepository paymentGatewayRepository;

  GetPaymentCredentialsUsecase({required this.paymentGatewayRepository});

  @override
  Future<Either<Failure, PaymentCredentialsResponseModel>> call(
      NoParams params) async {
    return await paymentGatewayRepository.getPaymentCredentials();
  }
}


