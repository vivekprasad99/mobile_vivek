import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/respositories/faq_repository.dart';
import '../datasource/faq_datasource.dart';
import '../models/faq_request.dart';
import '../models/faq_response.dart';

class FAQRepositoryImpl extends FAQRepository {
  FAQRepositoryImpl({required this.datasource});
  final FAQDataSource datasource;

  @override
  Future<Either<Failure, FAQResponse>> getFAQ(
      FAQRequest request) async {
    final result = await datasource.getFAQ(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

}
