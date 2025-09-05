import 'package:core/services/di/injection_container.dart';
import 'package:faq/features/data/datasource/faq_datasource.dart';
import 'package:faq/features/data/repositories/faq_repository_impl.dart';
import 'package:faq/features/domain/respositories/faq_repository.dart';
import 'package:faq/features/domain/usecases/faq_usecases.dart';
import 'package:faq/features/presentation/cubit/faq_cubit.dart';

Future<void> initFAQDI() async {
  di.registerFactory(() => FAQDataSource(dioClient: di()));
  di.registerFactory<FAQRepository>(
      () => FAQRepositoryImpl(datasource: di()));
  di.registerFactory(() => FAQUseCase(repository: di()));
  di.registerFactory(() => FAQCubit(faqUseCase: di()));
}
