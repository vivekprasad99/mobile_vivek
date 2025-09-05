import 'dart:convert';

import 'package:common/features/search/data/model/get_recent_list_request.dart';
import 'package:common/features/search/data/model/get_recent_list_response.dart';
import 'package:common/features/search/data/model/recommended_list_response.dart';
import 'package:common/features/search/data/model/search_request.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/search/data/model/update_recent_list_request.dart';
import 'package:common/features/search/data/model/update_recent_list_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import '../../../../config/network/api_endpoints.dart';

class SearchDatasource {
  DioClient dioClient;

  SearchDatasource({required this.dioClient});

  Future<Either<Failure, SearchResponse>> getSearchRoute(
      SearchRequest searchRequest,) async { 
    final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.getSearchRoute),
        converter: (response) =>
            SearchResponse.fromJson(response as Map<String, dynamic>),
        queryParameters: searchRequest.toJson(),
        );
    return response;
  }

  Future<Either<Failure, GetRecentListResponse>> getRecentList(
      GetRecentListRequest searchRequest,) async { 
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getRecentList),
        converter: (response) =>
            GetRecentListResponse.fromJson(response as Map<String, dynamic>),
        data: searchRequest.toJson(),
        );
    return response;
  }

  Future<Either<Failure, UpdateRecentListResponse>> updateRecentList(
      UpdateRecentListRequest searchRequest,) async { 
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updateRecentList),
        converter: (response) =>
            UpdateRecentListResponse.fromJson(response as Map<String, dynamic>),
        data: searchRequest.toJson(),
        );
    return response;
  }

   Future<Either<Failure, RecommendedListResponse>> getRecommendedList() async { 
    final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.getRecommendedList),
        converter: (response) =>
            RecommendedListResponse.fromJson(response as Map<String, dynamic>),
        );
    return response;
  }

  Future<Either<Failure, SearchResponse>> getTypeAheadSearchData() async { 
    // final response = await dioClient.getRequest(
    //     getCMSApiUrl(ApiEndpoints.getRecommendedList),
    //     converter: (response) =>
    //         SearchResponse.fromJson(response as Map<String, dynamic>),
    //     );
    final getTypeAheadSearchStubData = await rootBundle
          .loadString('assets/stubdata/search_data.json');
      final body = json.decode(getTypeAheadSearchStubData);
      Either<Failure, SearchResponse> response = Right(
          SearchResponse.fromJson(body as Map<String, dynamic>),);
    return response;
  }
}