import 'package:core/features/app_content/data/model/app_content_response.dart';
import 'package:dartz/dartz.dart';

import '../../../../config/error/failure.dart';

abstract class AppContentRepository {
  Future<Either<Failure, AppContentResponse>> getTollFreeNum();
}
