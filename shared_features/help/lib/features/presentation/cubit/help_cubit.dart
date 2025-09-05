import 'package:bloc/bloc.dart';
import 'package:core/config/config.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';
import 'package:help/features/data/models/help_request.dart';
import 'package:help/features/data/models/help_response.dart';
import 'package:help/features/domain/usecases/help_usecases.dart';

part 'help_state.dart';

class HelpCubit extends Cubit<HelpState> {
  HelpCubit({required this.helpUseCase}) : super(HelpInitial());
  final HelpUseCase helpUseCase;

  void loadFaqs({
    required HelpRequest request,
    required String subCategory,
    required String categoryName,
  }) async {
    try {
      emit(LoadingState(isLoading: true));
      final response = await helpUseCase.call(request);
      emit(LoadingState(isLoading: false));

      response.fold((failure) {
        emit(FailureState(error: failure));
      }, (data) {
        final category = data.data?.categories?.firstWhere(
          (cat) =>
              cat.productTypes?.any((pt) =>
                  pt.productType == categoryName &&
                  pt.subTypes?.any((st) => st.productSubType == subCategory) ==
                      true) ==
              true,
          orElse: () => Category(),
        );

        if (category == null) {
          emit(ErrorState(message: getString(lblNoCategory)));
          return;
        }

        final oldSubType = <SubType>[];
        final addedSubTypes = <String>{};

        for (var productType in category.productTypes!) {
          for (var subType in productType.subTypes!) {
            if (subType.productSubType != subCategory &&
                addedSubTypes.add(subType.productSubType ?? '')) {
              oldSubType.add(subType);
            }
          }
        }

        final productType = category.productTypes?.firstWhere(
          (pt) => pt.productType == categoryName,
          orElse: () => ProductType(),
        );

        if (productType == null) {
          emit(ErrorState(message: getString(lblNoProduct)));
          return;
        }

        final subType = productType.subTypes?.firstWhere(
          (st) => st.productSubType == subCategory,
          orElse: () => SubType(),
        );

        if (subType == null) {
          emit(ErrorState(message: getString(lblNoFaq)));
          return;
        }

        final allFaqs = <FAQ>[];
        final headers = <String>[];
        final productSubTypeName = <String>[];
        for (var type in subType.types!) {
          allFaqs.addAll(type.faq ?? []);
          headers.add(type.header ?? '');
          productSubTypeName.add(subType.productSubType ?? '');
        }

        emit(LoadedState(
            faqs: allFaqs,
            subType: oldSubType,
            headers: headers,
            productSubTypeName: productSubTypeName));
      });
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(FailureState(error: NoDataFailure()));
    }
  }

  void selectSubType(String subType) {
    if (state is LoadedState) {
      final loadedState = state as LoadedState;
      final updatedSubTypes = loadedState.subType
          .where((e) => e.productSubType != subType)
          .toList();
      emit(LoadedState(
        faqs: loadedState.faqs,
        subType: updatedSubTypes,
        productSubTypeName: loadedState.productSubTypeName,
        headers: loadedState.headers,
      ));
    }
  }
}
