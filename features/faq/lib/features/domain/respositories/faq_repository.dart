import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/faq_request.dart';
import '../../data/models/faq_response.dart';

abstract class FAQRepository {
  Future<Either<Failure, FAQResponse>> getFAQ(FAQRequest request);
}
