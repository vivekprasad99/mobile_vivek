import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_response.dart';
import 'package:auth/features/mobile_otp/domain/repositories/phone_validate_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class PhoneValidateUseCase extends UseCase<SendOtpResponse, SendOtpRequest> {
  final PhoneValidateRepository repository;

  PhoneValidateUseCase({required this.repository});

  @override
  Future<Either<Failure, SendOtpResponse>> call(SendOtpRequest params) async {
    final result = await repository.sendOtp(params);
    return result.fold((l) => result,
        (r) => r.code == null ? throw Exception('Code is empty') : result);
  }
}
