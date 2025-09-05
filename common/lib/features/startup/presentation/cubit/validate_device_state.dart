import 'package:common/features/startup/data/models/applaunch_config_response.dart';
import 'package:common/features/startup/data/models/token_response.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';

abstract class ValidateDeviceState extends Equatable {}

class LoadingDialogState extends ValidateDeviceState {
  final bool isValidateDeviceLoading;
  LoadingDialogState({required this.isValidateDeviceLoading});

  @override
  List<Object?> get props => [isValidateDeviceLoading];
}

class ValidateDeviceInitState extends ValidateDeviceState {
  ValidateDeviceInitState();

  @override
  List<Object?> get props => [];
}

class ValidateDeviceSuccessState extends ValidateDeviceState {
  final ValidateDeviceResponse response;
  ValidateDeviceSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ValidateDeviceFailureState extends ValidateDeviceState {
  final Failure error;
  ValidateDeviceFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class AppLaunchConfigSuccessState extends ValidateDeviceState {
  final AppLaunchConfigResponse response;
  AppLaunchConfigSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class AppLaunchConfigFailureState extends ValidateDeviceState {
  final Failure error;
  AppLaunchConfigFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class PreLoginTokenSuccessState extends ValidateDeviceState {
  final TokenResponse response;
  PreLoginTokenSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class PreLoginTokenFailureState extends ValidateDeviceState {
  final Failure error;
  PreLoginTokenFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}