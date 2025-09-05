import 'package:equatable/equatable.dart';
import '../../data/models/service_request_item_model.dart';

abstract class CloseServiceRequestState extends Equatable {}

class CloseServiceRequestStateInitial extends CloseServiceRequestState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends CloseServiceRequestState {
  final bool isLoading;
  LoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class CloseServiceRequestListState extends CloseServiceRequestState {
  final List<ServiceRequestItemModel> listItem;
  CloseServiceRequestListState({required this.listItem});

  @override
  List<Object?> get props => [listItem];
}
