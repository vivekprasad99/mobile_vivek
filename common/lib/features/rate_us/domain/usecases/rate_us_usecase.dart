import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/data/models/rate_us_response.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_request.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_response.dart';
import 'package:common/features/rate_us/domain/repositories/rate_us_repository.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:core/config/error/failure.dart';

class RateUsUseCase extends UseCase<RateUsResponse, RateUsRequest>
{
  final RateUsRepository repository;
  RateUsUseCase({required this.repository});

  @override
  Future<Either<Failure, RateUsResponse>> call(RateUsRequest params) async{
    return await repository.getRateUs(params);
  }

  Future<Either<Failure, UpdateRateUsResponse>> updateRateUsRecord(UpdateRateUsRequest rateUsRequest) async{
    return await repository.updateRateUsRecord(rateUsRequest);
  }
}