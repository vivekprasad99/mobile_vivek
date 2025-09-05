import 'package:core/utils/encryption/preference_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../login_wireframe/utils/biometric/app_enum.dart';
import '../login_wireframe/utils/biometric/biometric_authentication_util.dart';
import 'biometric_state.dart';
import 'package:permission_handler/permission_handler.dart' as permission;


class BiometricCubit extends Cubit<Biometric> {
  BiometricCubit()
      : super(BiometricTypeFaceId(
            isFacedId: false,
            availableBiometrics: const <BiometricType>[],
            isDeviceHasBiometric: false,
            isUserInteracted: false));

  void getAvailableBiometric(bool isAndroid) async {
    if (await BiometricAuth.getInstance.checkBiometrics()) {
      List<BiometricType> availableBiometrics =
          await BiometricAuth.getInstance.getAvailableBiometrics();
      if (isAndroid) {
        if(availableBiometrics.isNotEmpty){
          getAvailableBiometricCallback(true, availableBiometrics, true);
        } else {
          getAvailableBiometricCallback(false, availableBiometrics, false);
        }
      } else {
        if(availableBiometrics.isNotEmpty){
          // if(availableBiometrics.contains(BiometricType.face)) {
          //   getAvailableBiometricCallback(false, availableBiometrics, true);
          // } else {
          //   getAvailableBiometricCallback(false, availableBiometrics, false);
          // }
          getAvailableBiometricCallback(true, availableBiometrics, true);
        } else {
          getAvailableBiometricCallback(false, availableBiometrics, false);
        }
        // if (availableBiometrics.contains(BiometricType.weak)) {
        //   if(availableBiometrics.contains(BiometricType.face)) {
        //     getAvailableBiometricCallback(true, availableBiometrics, true);
        //   } else {
        //     getAvailableBiometricCallback(false, availableBiometrics, true);
        //   }
        // } else {
        //   getAvailableBiometricCallback(false, availableBiometrics, true);
        // }
      }

    }
  }

  void getAvailableBiometricCallback(bool isFace,
      List<BiometricType> availableBiometrics, bool isDeviceHasBiometrics) {
    emit(BiometricTypeFaceId(
        isFacedId: isFace,
        availableBiometrics: availableBiometrics,
        isDeviceHasBiometric: isDeviceHasBiometrics,
        isUserInteracted: false));
  }

  void registerWithBiometric() async {
    var result = await BiometricAuth.getInstance.authenticateWithBiometrics();
    if (result == BiometricAuthResult.success) {
      String biometricKey = BiometricAuth.getInstance.generateBiometricKey();
      await PreferencesHelper.setBiometricKey(biometricKey);
      // emit(BiometricTypeFaceId(
      //     isFacedId: state.isFacedId,
      //     availableBiometrics: state.availableBiometrics,
      //     isDeviceHasBiometric: state.isDeviceHasBiometric,
      //     isUserInteracted: true));
      emit(BiometricAuthState(isAuthSuccess: true));
    } else {
      emit(BiometricAuthState(isAuthSuccess: false));
      // emit(BiometricTypeFaceId(
      //     isFacedId: state.isFacedId,
      //     availableBiometrics: state.availableBiometrics,
      //     isDeviceHasBiometric: state.isDeviceHasBiometric,
      //     isUserInteracted: true));
    }
  }

  void getSettings() async {
    await permission.openAppSettings();
  }
}
