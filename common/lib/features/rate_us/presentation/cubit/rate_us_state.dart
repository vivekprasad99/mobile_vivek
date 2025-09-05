part of 'rate_us_cubit.dart';

@immutable
sealed class RateUsState extends Equatable {}

final class RateUsInitial extends RateUsState {
  @override
  List<Object?> get props => [];
}

class ChangeRateUsState extends RateUsState {
  final List<RateUsModel> rateUsModelList;

  ChangeRateUsState({required this.rateUsModelList});

  @override
  List<Object?> get props => [rateUsModelList];
}

class EmptyRateUsState extends RateUsState {
  @override
  List<Object?> get props => [];
}

class GetRateUsModel extends RateUsState {
  final RateUsModel rateUsModel;

  GetRateUsModel({required this.rateUsModel});

  @override
  List<Object?> get props => [rateUsModel];
}

class LoadingState extends RateUsState {
  final bool isloading;

  LoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class RateUsSuccessState extends RateUsState {
  final RateUsResponse response;

  RateUsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class RateUsFailureState extends RateUsState {
  final Failure failure;

  RateUsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UpdateRateUsRecordSuccessState extends RateUsState {
  final UpdateRateUsResponse response;
  final bool? isComingFromCloseButton;
  final bool? isCustomerHappy;

  UpdateRateUsRecordSuccessState(
      {required this.response, this.isComingFromCloseButton,this.isCustomerHappy,});

  @override
  List<Object?> get props => [response, isComingFromCloseButton,isCustomerHappy];
}
