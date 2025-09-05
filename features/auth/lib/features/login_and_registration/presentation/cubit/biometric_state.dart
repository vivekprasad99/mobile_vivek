import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

abstract class Biometric extends Equatable {}
// ignore_for_file: must_be_immutable
class BiometricTypeFaceId extends Biometric {
  final bool isFacedId;
  List<BiometricType> availableBiometrics;
  bool isDeviceHasBiometric;
  bool isUserInteracted;
  BiometricTypeFaceId(
      {required this.isFacedId,
      required this.availableBiometrics,
      required this.isDeviceHasBiometric,
      required this.isUserInteracted});

  @override
  List<Object?> get props =>
      [isFacedId, availableBiometrics, isDeviceHasBiometric, isUserInteracted];
}

class BiometricAuthState extends Biometric {
  final bool isAuthSuccess;

  BiometricAuthState(
      {required this.isAuthSuccess});

  @override
  List<Object?> get props =>
      [isAuthSuccess];
}
