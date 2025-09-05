import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/data/models/rate_us_response.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_request.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class RateUsRepository {
  Future<Either<Failure, RateUsResponse>> getRateUs(RateUsRequest rateUsRequest);

  Future<Either<Failure, UpdateRateUsResponse>> updateRateUsRecord(UpdateRateUsRequest rateUsRequest);
}