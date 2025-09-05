import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/open_service_request_response.dart';
import '../../data/models/service_request_item_model.dart';

abstract class OpenServiceRequestState extends Equatable {}

class OpenServiceRequestStateInitial extends OpenServiceRequestState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends OpenServiceRequestState {
  final bool isLoading;
  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class OpenServiceRequestListState extends OpenServiceRequestState {
  final List<ServiceRequestItemModel> listItem;
  OpenServiceRequestListState({required this.listItem});

  @override
  List<Object?> get props => [listItem];
}

class OpenServiceRequestSuccessState extends OpenServiceRequestState {
  final OpenServiceRequestResponse response;
  OpenServiceRequestSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class OpenServiceRequestFailureState extends OpenServiceRequestState {
  final Failure error;
  OpenServiceRequestFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
