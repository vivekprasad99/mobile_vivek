import 'package:common/features/rate_us/data/datasource/rate_us_datasource.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/data/models/rate_us_response.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_request.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_response.dart';
import 'package:common/features/rate_us/domain/repositories/rate_us_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

class RateUsRepositoryImpl implements RateUsRepository {
  RateUsRepositoryImpl({required this.datasource});
  final RateUsDatasource datasource;

  @override
  Future<Either<Failure, RateUsResponse>> getRateUs(RateUsRequest rateUsRequest) async{
    final result = await datasource.getRateUs(rateUsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdateRateUsResponse>> updateRateUsRecord(UpdateRateUsRequest updateRateUsRequest) async{
    final result = await datasource.updateRateUsRecord(updateRateUsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}