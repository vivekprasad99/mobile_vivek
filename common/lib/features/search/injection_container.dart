import 'package:common/features/search/data/data_source/search_datasource.dart';
import 'package:common/features/search/data/repository/search_repository_impl.dart';
import 'package:common/features/search/domain/repository/search_repository.dart';
import 'package:common/features/search/domain/usecases/search_usecases.dart';
import 'package:common/features/search/presentation/cubit/search_cubit.dart';
import 'package:common/features/search/presentation/cubit/search_viewmode.dart';
import 'package:core/services/di/injection_container.dart';

Future<void> initSearchDI() async {
  di.registerFactory(() => SearchDatasource(dioClient: di()));
  di.registerFactory<SearchRepository>(() => SearchRepositoryImpl(datasource: di()));
  di.registerFactory(() => SearchUseCase(repository: di()));
  di.registerFactory(() => SearchViewModel());
  di.registerFactory(() => SearchCubit(usecase: di(),searchViewModel: di()));
}