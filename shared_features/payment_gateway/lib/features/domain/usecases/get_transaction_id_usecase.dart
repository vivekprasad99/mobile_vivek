import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_request.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_response.dart';
import 'package:payment_gateway/features/domain/repositories/payment_repository.dart';

class GetTransactionIDUsecase
    extends UseCase<GetTransactionIdResponse, GetTransactionIdRequest> {
  final PaymentGatewayRepository paymentGatewayRepository;

  GetTransactionIDUsecase({required this.paymentGatewayRepository});

  @override
  Future<Either<Failure, GetTransactionIdResponse>> call(
      GetTransactionIdRequest params) async {
    return await paymentGatewayRepository.getTransactionId(params);
  }
}
