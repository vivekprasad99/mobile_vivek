import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:core/config/error/failure.dart';
import 'package:faq/features/data/models/faq_response.dart';
import '../../data/models/faq_request.dart';
import '../../domain/usecases/faq_usecases.dart';
import 'faq_state.dart';

class FAQCubit extends Cubit<FAQState> {
  final FAQUseCase faqUseCase;
  FAQCubit({required this.faqUseCase}) : super(FAQInitial()) {
    emit(FAQMicActiveState(
      showMic: true,
    ));
  }

  getFAQ({required FAQRequest request}) async {
    try {
      emit(LoadingState(isLoading: true));
      final result = await faqUseCase.call(request);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(FAQFailureState(error: l)), (r) {
        emit(FAQSuccessState(response: r));
      });
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(FAQFailureState(error: NoDataFailure()));
    }
  }

  void selectCategory(SubTypes category, String name) {
    emit(DropDownState(category: category, name: name));
  }

  List<Faq> result = [];
  List<Videos> videoResult = [];

  void performSearch(Data data, String query) {
    try {
      var result = searchFAQs(data, query);
      emit(SearchLoaded(results: result[0], videos: result[1]));
    } catch (e, st) {
      log("Exception-----$e", stackTrace: st);
    }
  }

  searchFAQs(Data data, String query) {
    String trimmedQuery = query.trim().toLowerCase();
    result.clear();
    videoResult.clear();

    if (trimmedQuery.isEmpty || (trimmedQuery.length < 3)) {
      result.clear();
      videoResult.clear();
      emit(FAQMicActiveState(
        showMic: true,
      ));
      emit(SearchLoaded(results: result, videos: videoResult));
    } else {
      final lowerCaseQuery = trimmedQuery.toLowerCase();

      void searchInFAQs(List<Faq> faqs) {
        for (var faq in faqs) {
          if (faq.question != null && faq.answer != null) {
            if (faq.question!.toLowerCase().contains(lowerCaseQuery) ||
                faq.answer!.toLowerCase().contains(lowerCaseQuery)) {
              if (!result.contains(faq)) {
                result.add(faq);
              }
            }
          }
        }
      }

      void searchInVideoTypes(List<VideoTypes> videoTypes) {
        for (VideoTypes videoType in videoTypes) {
          for (Videos video in videoType.videos ?? []) {
            if (video.title != null && video.subTitle != null) {
              if (video.title!.toLowerCase().contains(lowerCaseQuery) ||
                  video.subTitle!.toLowerCase().contains(lowerCaseQuery)) {
                if (!videoResult.contains(video)) {
                  videoResult.add(video);
                }
              }
            }
          }
        }
      }

      void traverseData(Categories category) {
        for (ProductTypes productType in category.productTypes ?? []) {
          for (SubTypes subType in productType.subTypes ?? []) {
            for (Types type in subType.types ?? []) {
              searchInFAQs(type.faq ?? []);
            }
          }
        }

        for (GeneralTypes generalType in category.generalTypes ?? []) {
          searchInFAQs(generalType.faq ?? []);
        }

        searchInVideoTypes(category.videoTypes ?? []);
      }

      for (Categories category in data.categories ?? []) {
        traverseData(category);
      }
      result.sort((a, b) {
        if (a.question != null && b.question != null) {
          return a.question!.toLowerCase().compareTo(b.question!.toLowerCase());
        }
        return 0;
      });
      emit(FAQMicActiveState(
        showMic: false,
      ));
      return [result, videoResult];
    }
  }

  searchBarClose() {
    result.clear();
    videoResult.clear();
    emit(FAQMicActiveState(
      showMic: true,
    ));
    emit(SearchLoaded(results: result, videos: videoResult));
  }
}
