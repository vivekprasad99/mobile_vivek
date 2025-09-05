import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/terms_conditions_response.dart';

abstract class TermsConditionsState extends Equatable {}

final class TermsConditionsInitial extends TermsConditionsState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends TermsConditionsState {
  final bool isLoading;

  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class TermsConditionsSuccessState extends TermsConditionsState {
  final TermsConditionsResponse response;

  TermsConditionsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class TermsConditionsFailureState extends TermsConditionsState {
  final Failure failure;

  TermsConditionsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
