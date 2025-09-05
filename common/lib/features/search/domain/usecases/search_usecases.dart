import 'package:common/features/search/data/model/get_recent_list_request.dart';
import 'package:common/features/search/data/model/get_recent_list_response.dart';
import 'package:common/features/search/data/model/recommended_list_response.dart';
import 'package:common/features/search/data/model/search_request.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/search/data/model/update_recent_list_request.dart';
import 'package:common/features/search/data/model/update_recent_list_response.dart';
import 'package:common/features/search/domain/repository/search_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class SearchUseCase extends UseCase<SearchResponse, SearchRequest>
{
  final SearchRepository repository;
  SearchUseCase({required this.repository});

  @override
  Future<Either<Failure, SearchResponse>> call(SearchRequest params) async{
    return await repository.getSearchRoute(params);
  }

  Future<Either<Failure, GetRecentListResponse>> getRecentList(GetRecentListRequest params) async{
    return await repository.getRecentList(params);
  }

  Future<Either<Failure, UpdateRecentListResponse>> updateRecentList(UpdateRecentListRequest params) async{
    return await repository.updateRecentList(params);
  }

  Future<Either<Failure, RecommendedListResponse>> getRecommendedList() async{
    return await repository.getRecommendedList();
  }

  Future<Either<Failure, SearchResponse>> getTypeAheadSearchData() async{
    return await repository.getTypeAheadSearchData();
  }
}