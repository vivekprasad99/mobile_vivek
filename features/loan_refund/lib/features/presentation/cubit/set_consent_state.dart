import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class SetConsentState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SetConsentInitialState extends SetConsentState {}

class SetConsentLoadingState extends SetConsentState {}

class SetConsentSuccessState extends SetConsentState {}

class SetConsentFailureState extends SetConsentState {}
