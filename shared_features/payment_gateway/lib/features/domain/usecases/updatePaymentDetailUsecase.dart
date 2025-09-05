import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_reponse.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_request.dart';
import 'package:payment_gateway/features/domain/repositories/payment_repository.dart';

class UpdatePaymentDetailUsecase
    extends UseCase<UpdatePaymentDetailResponse, UpdatePaymentDetailRequest> {
  final PaymentGatewayRepository paymentGatewayRepository;

  UpdatePaymentDetailUsecase({required this.paymentGatewayRepository});

  @override
  Future<Either<Failure, UpdatePaymentDetailResponse>> call(
      UpdatePaymentDetailRequest params) async {
    return await paymentGatewayRepository.updatePaymentDetial(params);
  }
}
