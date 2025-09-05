import 'package:core/config/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/data/models/product_feature_detail_request.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/domain/usecases/product_feature_usecase.dart';
import 'package:product/presentation/cubit/product_feature_state.dart';

class ProductFeatureCubit extends Cubit<ProductFeatureState> {
  ProductFeatureCubit({
    required this.productFeatureUseCase,
  }) : super(const ProductFeatureInitialState(
    sliderIndex: 0,
    ));

  final ProductFeatureUseCase productFeatureUseCase;

  productFeature({required ProductFeatureRequest productFeatureRequest}) async {
    try {
      emit(const LoadingState(isloading: true, sliderIndex: 0));
      final result = await productFeatureUseCase.call(productFeatureRequest);
      emit(const LoadingState(isloading: false, sliderIndex: 0));
      result.fold(
          (l) => emit(ProductFeatureFailureState(error: l, sliderIndex: 0)),
          (r) => emit(ProductFeatureSuccessState(response: r, sliderIndex: 0)));
    } catch (e) {
      emit(const LoadingState(isloading: false, sliderIndex: 0));
      emit(ProductFeatureFailureState(error: NoDataFailure(), sliderIndex: 0));
    }
  }

  productFeatureDetailAPI({required ProductFeatureDetailRequest productFeatureRequest}) async {
    try {
      emit(const LoadingState(isloading: true, sliderIndex: 0));
      await Future.delayed(const Duration(seconds: 3));
      final result = await productFeatureUseCase.productFeatureDetail(productFeatureRequest);
      emit(const LoadingState(isloading: false, sliderIndex: 0));
      result.fold(
          (l) => emit(ProductFeatureFailureState(error: l, sliderIndex: 0)),
          (r) {
            emit(SetProductDetailFromSearch(loanType: r.productFeature!.first.types!.first, sliderIndex: 0));
          });
    } catch (e) {
      emit(const LoadingState(isloading: false, sliderIndex: 0));
      emit(ProductFeatureFailureState(error: NoDataFailure(), sliderIndex: 0));
    }
  }



  
}
