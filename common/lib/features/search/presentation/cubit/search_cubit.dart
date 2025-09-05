import 'dart:convert';
import 'package:common/features/search/data/model/get_recent_list_request.dart';
import 'package:common/features/search/data/model/get_recent_list_response.dart';
import 'package:common/features/search/data/model/search_request.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/search/data/model/update_recent_list_request.dart';
import 'package:common/features/search/data/model/update_recent_list_response.dart';
import 'package:common/features/search/domain/usecases/search_usecases.dart';
import 'package:common/features/search/presentation/cubit/search_viewmode.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase usecase;
  final SearchViewModel searchViewModel;
  SearchCubit({required this.usecase, required this.searchViewModel})
      : super(SearchInitial()) {
    checkTypeAheadSearchDataAvailable();
  }

  List<SearchData> typeAheadSearchData = [];
  List<SearchData> searchResults = [];
  List<SearchData> productsList = [];
  List<SearchData> faqsList = [];
  List<SearchData> recentSearchList = [];
  List<SearchData> recommendedSearchList = [];
  List<SearchData> typeAheadSearchList = [];
  int serviceTitleMatchCount = 0;
  int productTitleMatchCount = 0;

  checkTypeAheadSearchDataAvailable() async {
    String apiTimeStamp =
        PrefUtils.getString(PrefUtils.keyTypeAheadSearchApiTimeStamp, "");
    DateTime now = DateTime.now();
    if (apiTimeStamp.isEmpty ||
        now.difference(DateTime.parse(apiTimeStamp)).inMinutes >= 10) {
      getTypeAheadSearchData();
    } else {
      List<SearchData> data = await searchViewModel.getSearchData();
      typeAheadSearchData = data;
      getRecommendedList();
    }
  }

  void getRecentListAPI(GetRecentListRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getRecentList(request);
      emit(LoadingState(isloading: false));
      result.fold((l) {
        emit(SearchRecentRecommendedFailureState(failure: l));
      }, (r) async {
        List<String> recentListType = r.data?.searchKeys ?? [];
        List<SearchData> filteredSearchData = typeAheadSearchData
            .where((item) => recentListType.contains(item.title))
            .toList();
        List<String> searchList = filteredSearchData
            .map((item) => jsonEncode(item.toJson()))
            .toList();
        await PrefUtils.saveStringList(
            PrefUtils.keyRecentSearchList, searchList,);
        emit(SearchRecentRecommendedState(
            response: r,
            recentSearchList: filteredSearchData,
            recommendedList: recommendedSearchList,
            showMic: true,
            isFromPref: false,),);
      });
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(SearchRecentRecommendedFailureState(failure: NoDataFailure()));
    }
  }

  void getTypeAheadSearchData() async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getTypeAheadSearchData();
      await Future.delayed(const Duration(seconds: 1));
      emit(LoadingState(isloading: false));
      result.fold((l) {
        emit(SearchRecentRecommendedFailureState(failure: l));
      }, (r) async {
        DateTime currentTime = DateTime.now();
        PrefUtils.saveString(
            PrefUtils.keyTypeAheadSearchApiTimeStamp, currentTime.toString(),);
        await searchViewModel.storeSearchData(r.data ?? []);
        typeAheadSearchData = r.data ?? [];
        getRecommendedList();
      });
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(SearchRecentRecommendedFailureState(failure: NoDataFailure()));
    }
  }

  void getRecommendedList() async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getRecommendedList();
      emit(LoadingState(isloading: false));
      result.fold((l) {
        emit(SearchRecentRecommendedFailureState(failure: l));
      }, (r) async {
        List<String> recommendedListTitles =
            (r.data ?? []).map((item) => item.title ?? '').toList();
        List<SearchData> filteredSearchData = typeAheadSearchData
            .where((item) => recommendedListTitles.contains(item.title))
            .toList();
        recommendedSearchList = filteredSearchData;
        List<String>? searchList =
            PrefUtils.getStringList(PrefUtils.keyRecentSearchList);
        if (searchList.isEmpty) {
          getRecentListAPI(GetRecentListRequest(superAppId: getSuperAppId()));
        } else {
          loadRecentSearches();
        }
      });
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(SearchRecentRecommendedFailureState(failure: NoDataFailure()));
    }
  }

  void updateRecentListAPI(UpdateRecentListRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      await Future.delayed(const Duration(seconds: 1));
      final result = await usecase.updateRecentList(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(UpdateRecentListFailureState(failure: l)),
          (r) async {
        emit(UpdateRecentListSuccessState(response: r));
        searchStateOnBack();
      });
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(UpdateRecentListFailureState(failure: NoDataFailure()));
    }
  }

  Future<void> loadRecentSearches() async {
    List<String>? searchList =
        PrefUtils.getStringList(PrefUtils.keyRecentSearchList);
    recentSearchList = searchList
        .map((item) => SearchData.fromJson(jsonDecode(item)))
        .toList();
    emit(SearchRecentRecommendedState(
        isFromPref: true,
        showMic: true,
        recommendedList: recommendedSearchList,
        recentSearchList: recentSearchList,),);
  }

  Future<void> addSearch(SearchData search) async {
    SearchData newSearch = search;
    recentSearchList.removeWhere((item) => item.title == search.title);
    recentSearchList.insert(0, newSearch);
    if (recentSearchList.length > 5) {
      recentSearchList = recentSearchList.sublist(0, 5);
    }
    List<String> searchList =
        recentSearchList.map((item) => jsonEncode(item.toJson())).toList();
    await PrefUtils.saveStringList(PrefUtils.keyRecentSearchList, searchList);
  }

  updateSuggestionListData(List<SearchData> data) {
    for (var item in data) {
      if (item.title != null && item.title.toString().isNotEmpty) {
        productsList.add(item);
      } else if (item.faqQuestion != null &&
          item.faqQuestion.toString().isNotEmpty) {
        faqsList.add(item);
      }
    }
  }

  void getSearchRoute(SearchRequest request) async {
    productsList.clear();
    faqsList.clear();
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.call(request);
      emit(LoadingState(isloading: false));
      result.fold((l) {
        emit(GetSearchRouteFailureState(failure: l));
      }, (r) async {
        await updateSuggestionListData(r.data ?? []);
        await onQueryChanged(request.searchQuery ?? "");
        List<SearchData> combinedData = [
          ...typeAheadSearchList,
          ...productsList,
        ];
        Set<String> seenTitles = {};
        List<SearchData> uniqueData = [];

        for (var item in combinedData) {
          if (!seenTitles.contains(item.title)) {
            seenTitles.add(item.title ?? "");
            uniqueData.add(item);
          }
        }
        faqsList.sort((a, b) {
          if (a.faqQuestion != null && b.faqQuestion != null) {
            return a.faqQuestion!
                .toLowerCase()
                .compareTo(b.faqQuestion!.toLowerCase());
          }
          return 0;
        });
        List<SearchData> newproductsList = [];
        List<SearchData> newservicesList = [];
        for (var item in uniqueData) {
          if (item.category == "services") {
            newservicesList.add(item);
          } else {
            newproductsList.add(item);
          }
        }

       bool isShowServices = _determineShowServices(newservicesList, newproductsList, request.searchQuery ?? "");

        emit(GetSearchRouteSuccessState(
            response: r, productsList: newproductsList, faqsList: faqsList,servicesList: newservicesList,isShowServices: isShowServices));
      });
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetSearchRouteFailureState(failure: NoDataFailure()));
    }
  }

  bool _determineShowServices(List<SearchData> servicesList,
      List<SearchData> productsList, String query) {
    int servicesMatches = _countMatches(servicesList, query);
    int productsMatches = _countMatches(productsList, query);
    return servicesMatches >= productsMatches;
  }

  int _countMatches(List<SearchData> dataList, String query) {
  int count = 0;
  List<String> queryWords = query.toLowerCase().split(' ');

  for (var item in dataList) {
    if (item.title != null) {
      String titleLower = item.title!.toLowerCase();
      bool matchFound = false;

      for (var word in queryWords) {
        if (titleLower.contains(word)) {
          matchFound = true;
          break;
        }
      }

      if (matchFound) {
        count++;
      }
    }
  }

  return count;
}

  searchBarClose() {
    searchResults.clear();
    emit(SearchRecentRecommendedState(
        showMic: true,
        recentSearchList: recentSearchList,
        recommendedList: recommendedSearchList,
        isFromPref: true,),);
  }


  onQueryChanged(String query) {
    String trimmedQuery = query.trim().toLowerCase();
    if (!isCustomer()) {
      typeAheadSearchData = typeAheadSearchData
          .where((element) => element.isUser == true)
          .toList();
    }
    if (trimmedQuery.isEmpty || (trimmedQuery.length < 3)) {
      searchResults.clear();
      emit(SearchRecentRecommendedState(
          showMic: true,
          recentSearchList: recentSearchList,
          recommendedList: recommendedSearchList,
          isFromPref: true,),);
    } else {
      List<SearchData> results = [];
      String loweredQuery = trimmedQuery.toLowerCase();
      List<String> queryWords = loweredQuery.split(' ');


      for (var item in typeAheadSearchData) {
        List<String> searchList = List<String>.from(item.searchList!);
        bool isMatch = false;
        int titleMatchCount = 0;

        List<String> titleWords = (item.title ?? "").toLowerCase().split(' ');
        titleMatchCount = queryWords
            .where((queryWord) =>
                titleWords.any((titleWord) => titleWord.contains(queryWord)),)
            .length;

        if (titleMatchCount > 0) {
          isMatch = true;
        } else {
          for (var searchItem in searchList) {
            List<String> searchWords = searchItem.toLowerCase().split(' ');
            int searchMatchCount = queryWords
                .where((queryWord) => searchWords
                    .any((searchWord) => searchWord.contains(queryWord)),)
                .length;

            if (searchMatchCount > 0) {
              isMatch = true;
              break;
            }
          }
        }

        if (isMatch) {
          results.add(item);
        }
      }

      results.sort((a, b) {
        bool aTitleMatch = queryWords.any(
            (queryWord) => (a.title ?? "").toLowerCase().contains(queryWord),);
        bool bTitleMatch = queryWords.any(
            (queryWord) => (b.title ?? "").toLowerCase().contains(queryWord),);

        if (aTitleMatch && !bTitleMatch) {
          return -1;
        } else if (!aTitleMatch && bTitleMatch) {
          return 1;
        } else {
          int aMatchCount = (a.searchList ?? []).fold(0, (count, searchItem) {
            List<String> searchWords = searchItem.toLowerCase().split(' ');
            return count +
                queryWords
                    .where((queryWord) => searchWords
                        .any((searchWord) => searchWord.contains(queryWord)),)
                    .length;
          });

          int bMatchCount = (b.searchList ?? []).fold(0, (count, searchItem) {
            List<String> searchWords = searchItem.toLowerCase().split(' ');
            return count +
                queryWords
                    .where((queryWord) => searchWords
                        .any((searchWord) => searchWord.contains(queryWord)),)
                    .length;
          });

          if (aMatchCount == bMatchCount) {
            return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
          }
          return bMatchCount.compareTo(aMatchCount);
        }
      });

      searchResults = results;
      typeAheadSearchList = results;
      List<SearchData> productsList = [];
      List<SearchData> servicesList = [];
      for (var item in searchResults) {
        if (item.category == "products") {
          productsList.add(item);
        } else if (item.category == "services") {
          servicesList.add(item);
        }
      }

      bool? isShowServiceOnTop = _determineShowServices(servicesList, productsList, trimmedQuery);


      //TODO: remove later
      // if (serviceTitleMatchCount > productTitleMatchCount) {
      //   isShowServiceOnTop = true;
      // } else if (productTitleMatchCount > serviceTitleMatchCount) {
      //   isShowServiceOnTop = false;
      // } else {
      //   isShowServiceOnTop = servicesList.length >= productsList.length;
      // }

      emit(SearchRecentRecommendedState(showMic: false));
      emit(UpdateSearchSuggestionList(
          showServices: isShowServiceOnTop,
          data: searchResults,
          productsList: productsList,
          servicesList: servicesList,),);
    }
  }

  getExistingRecentSearchList() {
    List<String>? searchList =
        PrefUtils.getStringList(PrefUtils.keyRecentSearchList);
    List<SearchData> recentSearchList = searchList
        .map((item) => SearchData.fromJson(jsonDecode(item)))
        .toList();
    List<String?> titles =
        recentSearchList.map((searchData) => searchData.title).toList();
    String superAppId = getSuperAppId();
    updateRecentListAPI(
        UpdateRecentListRequest(superAppId: superAppId, recentList: titles),);
  }

  void searchStateOnBack() {
    emit(SearchRecentRecommendedState(
        showMic: true,
        recentSearchList: recentSearchList,
        recommendedList: recommendedSearchList,
        isFromPref: true,),);
  }

  String _lastSearchText = '';

  void onTextChanged(String text) {
    final isEnabled = text.isNotEmpty && text != _lastSearchText;
    emit(SearchButtonEnableState(searchEnable: isEnabled));
  }

  void onSearch(String text) {
    _lastSearchText = text;
    emit(SearchButtonEnableState(searchEnable: false));
  }
}
