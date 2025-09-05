import 'package:core/features/app_content/data/model/app_content_response.dart';
import 'package:equatable/equatable.dart';

import '../../../../config/error/failure.dart';

abstract class QuickActionState extends Equatable {}

class StickyActionButtonInitialState extends QuickActionState {
  @override
  List<Object?> get props => [];
}

class OpenState extends QuickActionState {
  final bool isOpen;
  OpenState({required this.isOpen});

  @override
  List<Object?> get props => [isOpen];
}

class StickyAtionButtonSuccessState extends QuickActionState {
  final AppContentResponse response;
  StickyAtionButtonSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class StickyAtionButtonFailureState extends QuickActionState {
  final Failure error;
  StickyAtionButtonFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
