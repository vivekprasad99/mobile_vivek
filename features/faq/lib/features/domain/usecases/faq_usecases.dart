import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/faq_request.dart';
import '../../data/models/faq_response.dart';
import '../respositories/faq_repository.dart';

class FAQUseCase extends UseCase<FAQResponse, FAQRequest> {
  final FAQRepository repository;
  FAQUseCase({required this.repository});

  @override
  Future<Either<Failure, FAQResponse>> call(FAQRequest params) async {
    return await repository.getFAQ(params);
  }
}
