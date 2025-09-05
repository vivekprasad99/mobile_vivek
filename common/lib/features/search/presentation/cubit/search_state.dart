part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class UpdateSearchSuggestionList extends SearchState {
  final bool? showServices;
  final List<SearchData> data;
  final List<SearchData>? productsList;
  final List<SearchData>? servicesList;

  UpdateSearchSuggestionList({required this.data,this.productsList,this.servicesList,this.showServices});
}

class LoadingState extends SearchState {
  final bool isloading;

  LoadingState({required this.isloading});
}

class GetSearchRouteSuccessState extends SearchState {
  final SearchResponse response;
  final List<SearchData> productsList;
  final List<SearchData> servicesList;
  final List<SearchData> faqsList;
  final bool? isShowServices;
  

  GetSearchRouteSuccessState(
      {required this.response,
      required this.productsList,
      required this.servicesList,
      required this.faqsList,
      this.isShowServices,
      });
}

class GetSearchRouteFailureState extends SearchState {
  final Failure failure;

  GetSearchRouteFailureState({required this.failure});
}

class SearchRecentRecommendedState extends SearchState {
  final GetRecentListResponse? response;
  final List<SearchData>? recentSearchList;
  final List<SearchData>? recommendedList;
  final bool showMic;
  final bool? isFromPref;

  SearchRecentRecommendedState({
    this.response,
     this.recentSearchList,
     this.recommendedList,
     required this.showMic,
     this.isFromPref,
  });
}

class SearchRecentRecommendedFailureState extends SearchState {
  final Failure failure;

  SearchRecentRecommendedFailureState({
    required this.failure,
  });
}


class UpdateRecentListSuccessState extends SearchState {
  final UpdateRecentListResponse response;

  UpdateRecentListSuccessState(
      {required this.response,
      });
}

class UpdateRecentListFailureState extends SearchState {
  final Failure failure;

  UpdateRecentListFailureState({required this.failure});
}

class SearchButtonEnableState extends SearchState {
  final bool? searchEnable;

  SearchButtonEnableState({required this.searchEnable});
}

