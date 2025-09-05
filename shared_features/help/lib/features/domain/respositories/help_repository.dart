import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/help_request.dart';
import '../../data/models/help_response.dart';

abstract class HelpRepository {
  Future<Either<Failure, HelpResponse>> getHelpData(
      HelpRequest request);
}
