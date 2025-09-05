import 'package:common/features/search/data/data_source/search_datasource.dart';
import 'package:common/features/search/data/model/get_recent_list_request.dart';
import 'package:common/features/search/data/model/get_recent_list_response.dart';
import 'package:common/features/search/data/model/recommended_list_response.dart';
import 'package:common/features/search/data/model/search_request.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/search/data/model/update_recent_list_request.dart';
import 'package:common/features/search/data/model/update_recent_list_response.dart';
import 'package:common/features/search/domain/repository/search_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.datasource});
  final SearchDatasource datasource;

  @override
  Future<Either<Failure, SearchResponse>> getSearchRoute(SearchRequest searchRequest) async{
    final result = await datasource.getSearchRoute(searchRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetRecentListResponse>> getRecentList(GetRecentListRequest searchRequest) async{
    final result = await datasource.getRecentList(searchRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdateRecentListResponse>> updateRecentList(UpdateRecentListRequest searchRequest) async{
    final result = await datasource.updateRecentList(searchRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, RecommendedListResponse>> getRecommendedList() async{
    final result = await datasource.getRecommendedList();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, SearchResponse>> getTypeAheadSearchData() async{
    final result = await datasource.getTypeAheadSearchData();
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}