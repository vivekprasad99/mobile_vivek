import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_gateway/features/data/models/get_payment_option_data_model.dart';
import 'package:payment_gateway/features/domain/repositories/payment_repository.dart';

class GetPaymentOptionDataUsecase
    extends UseCase<PaymentOptionsResponeModel, NoParams> {
  final PaymentGatewayRepository paymentGatewayRepository;

  GetPaymentOptionDataUsecase({required this.paymentGatewayRepository});

  @override
  Future<Either<Failure, PaymentOptionsResponeModel>> call(
      NoParams params) async {
    return await paymentGatewayRepository.getPaymentOptionsData();
  }
}


