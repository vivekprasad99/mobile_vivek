import 'package:common/features/privacy_policy/data/models/get_privacy_policy_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';

abstract class PrivacyPolicyState extends Equatable {}

final class PrivacyPolicyInitial extends PrivacyPolicyState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends PrivacyPolicyState {
  final bool isLoading;

  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class PrivacyPolicySuccessState extends PrivacyPolicyState {
  final GetPrivacyPolicyResponse response;

  PrivacyPolicySuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class PrivacyPolicyFailureState extends PrivacyPolicyState {
  final Failure failure;

  PrivacyPolicyFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
