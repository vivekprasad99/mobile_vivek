
import 'package:appstatus/feature/data/models/application_status_category_response.dart';
import 'package:appstatus/feature/data/models/application_status_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';

abstract class ApplicationStatusState extends Equatable {}

class AppStatusInitial extends ApplicationStatusState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ApplicationStatusState {
  final bool isLoading;
  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class ApplicationStatusSuccessState extends ApplicationStatusState {
  final ApplicationStatusResponse response;
  ApplicationStatusSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ApplicationStatusFailureState extends ApplicationStatusState {
  final Failure error;
  ApplicationStatusFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
class ApplicationStatusCategorySuccessState extends ApplicationStatusState {
  final ApplicationStatusCategoryResponse response;
  ApplicationStatusCategorySuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}