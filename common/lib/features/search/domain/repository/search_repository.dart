import 'package:common/features/search/data/model/get_recent_list_request.dart';
import 'package:common/features/search/data/model/get_recent_list_response.dart';
import 'package:common/features/search/data/model/recommended_list_response.dart';
import 'package:common/features/search/data/model/search_request.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/search/data/model/update_recent_list_request.dart';
import 'package:common/features/search/data/model/update_recent_list_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResponse>> getSearchRoute(SearchRequest searchRequest);
  Future<Either<Failure, GetRecentListResponse>> getRecentList(GetRecentListRequest searchRequest);
  Future<Either<Failure, UpdateRecentListResponse>> updateRecentList(UpdateRecentListRequest searchRequest);
  Future<Either<Failure, RecommendedListResponse>> getRecommendedList();
  Future<Either<Failure, SearchResponse>> getTypeAheadSearchData();

}