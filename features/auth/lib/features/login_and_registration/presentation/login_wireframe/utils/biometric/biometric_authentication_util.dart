import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'app_enum.dart';

class BiometricAuth {
  BiometricAuth._privateConstructor();

  static final BiometricAuth getInstance = BiometricAuth._privateConstructor();

  bool isDialogShowing = false;

  factory BiometricAuth() => getInstance;

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await _auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    return canCheckBiometrics;
  }

  String generateBiometricKey({int length = 16}) {
    final Random generator = Random.secure();
    final Uint8List bytes = Uint8List.fromList(
        List.generate(length, (index) => generator.nextInt(256)));
    String hexString =
        bytes.map((e) => e.toRadixString(length).padLeft(2, "0")).join();
    return hexString;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = <BiometricType>[];

    if (await _auth.canCheckBiometrics) {
      try {
        availableBiometrics = await _auth.getAvailableBiometrics();
      } catch (e, s) {
        dev.log("Get Available biometrics ${e.toString()}", stackTrace: s);
      }
    } else {
      dev.log("Get Available biometrics Unknown error");
    }

    return availableBiometrics;
  }

  Future<BiometricAuthResult> authenticateWithBiometrics() async {
    bool authenticated = false;
    List<BiometricType> availableBiometrics = await getAvailableBiometrics();

    if (availableBiometrics.isEmpty) {
      authenticated = false;
      return BiometricAuthResult.deactivated;
    }
    try {
      authenticated = await _auth.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true, useErrorDialogs: false));

      if (authenticated) {
        return BiometricAuthResult.success;
      } else {
        // Handled because if the user canceled
        return BiometricAuthResult.none;
      }
    } catch (e) {
      return BiometricAuthResult.error;
    }
  }

  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      dev.log("Get biometrics result ${e.message}");
      return false;
    }
    return authenticated;
  }

  Future<void> cancelAuthentication() async {
    await _auth.stopAuthentication();
  }
}
