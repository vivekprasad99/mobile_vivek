import 'package:core/config/config.dart';
import 'package:equatable/equatable.dart';
import 'package:product/data/models/product_feature_response.dart';

class ProductFeatureState extends Equatable {
  const ProductFeatureState({this.productsModelObj, required this.sliderIndex});

  final ProductFeature? productsModelObj;
  final int sliderIndex;

  @override
  List<Object?> get props => [
        sliderIndex,
        productsModelObj,
      ];

  ProductFeatureState copyWith({
    int? sliderIndex,
    ProductFeature? productsModelObj,
  }) {
    return ProductFeatureState(
      sliderIndex: sliderIndex ?? this.sliderIndex,
      productsModelObj: productsModelObj ?? this.productsModelObj,
    );
  }
}

class ProductFeatureInitialState extends ProductFeatureState {
  const ProductFeatureInitialState({required super.sliderIndex});

  @override
  List<Object?> get props => [];
}

class LoadingState extends ProductFeatureState {
  final bool isloading;

  const LoadingState({required this.isloading, required super.sliderIndex});

  @override
  List<Object?> get props => [isloading];
}

class ProductFeatureSuccessState extends ProductFeatureState {
  final ProductFeatureResponse response;

  const ProductFeatureSuccessState(
      {required this.response, required super.sliderIndex});

  @override
  List<Object?> get props => [response];
}

class ProductFeatureFailureState extends ProductFeatureState {
  final Failure error;

  const ProductFeatureFailureState(
      {required this.error, required super.sliderIndex});

  @override
  List<Object?> get props => [error];
}


class SetProductDetailFromSearch extends ProductFeatureState {
  final LoanType loanType;

  const SetProductDetailFromSearch(
      {required this.loanType, required super.sliderIndex});
}
