import 'dart:io';

import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/config/error/error.dart';

import 'package:core/config/string_resource/Strings.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:profile/config/profile_constant.dart';
import 'package:profile/data/models/aadhaar_consent_req.dart';
import 'package:profile/data/models/aadhaar_consent_res.dart';
import 'package:profile/data/models/addr_document_dropdown_model.dart';
import 'package:profile/data/models/addr_update_offline_req.dart';
import 'package:profile/data/models/addr_update_offline_res.dart';
import 'package:profile/data/models/delete_profile_pic_response.dart';
import 'package:profile/data/models/dob_gender_match_req.dart';
import 'package:profile/data/models/dob_gender_match_res.dart';
import 'package:profile/data/models/get_preset_uri_request.dart';
import 'package:profile/data/models/get_preset_uri_response.dart';
import 'package:profile/data/models/get_profile_img.res.dart';
import 'package:profile/data/models/get_profile_img_req.dart';
import 'package:profile/data/models/my_profile_model_request.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/data/models/name_match_req.dart';
import 'package:profile/data/models/name_match_res.dart';
import 'package:profile/data/models/ocr_passport_response.dart';
import 'package:profile/data/models/ocr_profile_request.dart';
import 'package:profile/data/models/ocr_voterid_response.dart';
import 'package:profile/data/models/update_address_by_aadhaar_req.dart';
import 'package:profile/data/models/update_address_by_aadhaar_res.dart';
import 'package:profile/data/models/update_address_license_request.dart';
import 'package:profile/data/models/update_address_license_response.dart';
import 'package:profile/data/models/update_email_request.dart';
import 'package:profile/data/models/update_email_response.dart';
import 'package:profile/data/models/update_pan_request.dart';
import 'package:profile/data/models/update_pan_response.dart';
import 'package:profile/data/models/update_phone_req.dart';
import 'package:profile/data/models/update_phone_res.dart';
import 'package:profile/data/models/upload_profile_pic_request.dart';
import 'package:profile/data/models/upload_profile_pic_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_res.dart';
import 'package:profile/data/models/validate_license_request.dart';
import 'package:profile/data/models/validate_license_response.dart';
import 'package:profile/data/models/validate_pan_request.dart';
import 'package:profile/data/models/validate_pan_response.dart';

import '../../data/models/active_loan_list_request.dart';
import '../../data/models/active_loan_list_response.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.usecase}) : super(ProfileInitial());

  final ProfileUseCase usecase;

  void imageAdded(bool imageAdded, String imageName) {
    emit(ProfileUploadState(imageAdded: imageAdded, imageName: imageName));
  }

  void getMyProfile(MyProfileRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getMyProfile(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(MyProfileFailureState(failure: l)),
          (r) => emit(MyProfileSuccessState(response: r)));
    } catch (e) {
      emit(MyProfileFailureState(failure: NoDataFailure()));
    }
  }

  void getMyProfileImage(ProfileImageRequest request) async {
    try {
      emit(ImageLoadingState(isImageloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getMyProfileImage(request);
      emit(ImageLoadingState(isImageloading: false));
      result.fold((l) => emit(MyProfileImageFailureState(failure: l)),
          (r) => emit(MyProfileImageSuccessState(response: r)));
    } catch (e) {
      emit(MyProfileImageFailureState(failure: NoDataFailure()));
    }
  }

  void updateEmailId(UpdateEmailRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.updateEmailID(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(UpdateEmailFailureState(failure: l)),
          (r) => emit(UpdateEmailSuccessState(response: r)));
    } catch (e) {
      emit(UpdateEmailFailureState(failure: NoDataFailure()));
    }
  }

  void updatePAN(UpdatePanRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }

      final result = await usecase.updatePAN(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(UpdatePANFailureState(failure: l)),
          (r) => emit(UpdatePANSuccessState(response: r)));
    } catch (e) {
      emit(UpdatePANFailureState(failure: NoDataFailure()));
    }
  }

  void validatePAN(ValidatePANRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.validatePAN(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(ValidatePANFailureState(failure: l)),
          (r) => emit(ValidatePANSuccessState(response: r)));
    } catch (e) {
      emit(ValidatePANFailureState(failure: NoDataFailure()));
    }
  }

  void getAadhaarConsent(AadhaarConsentReq request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      try {
        final info = NetworkInfo();
        final wifiIP = await info.getWifiIP();
        request.userIpAddress = wifiIP;
      } catch(e) {
        request.userIpAddress = "";
      }
      final result = await usecase.getAadhaarConsent(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(GetAadhaarConsentFailureState(failure: l)),
              (r) => emit(GetAadhaarConsentSuccessState(response: r)));
    } catch (e) {
      emit(ProfileLoadingState(isloading: false));
      emit(GetAadhaarConsentFailureState(failure: NoDataFailure()));
    }
  }

  void validateNameMatch(NameMatchReq request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.validateNameMatch(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(NameMatchFailureState(failure: l)),
              (r) => emit(NameMatchSuccessState(response: r)));
    } catch (e) {
      emit(ProfileLoadingState(isloading: false));
      emit(NameMatchFailureState(failure: NoDataFailure()));
    }
  }

  void validateDOBGenderMatch(DobGenderMatchRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.validateDobGenderMatch(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(DobGenderMatchFailureState(failure: l)),
              (r) => emit(DobGenderMatchSuccessState(response: r)));
    } catch (e) {
      emit(ProfileLoadingState(isloading: false));
      emit(DobGenderMatchFailureState(failure: NoDataFailure()));
    }
  }

  void updatePhoneNumber(UpdatePhoneReq request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.updatePhoneNumber(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(UpdatePhoneFailureState(failure: l)),
              (r) => emit(UpdatePhoneSuccessState(response: r)));
    } catch (e) {
      emit(ProfileLoadingState(isloading: false));
      emit(UpdatePhoneFailureState(failure: NoDataFailure()));
    }
  }

  void uploadProfilePic(UploadProfilePhotoRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.uploadProfilePic(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(UploadProfilePicFailureState(failure: l)),
          (r) => emit(UploadProfilePicSuccessState(response: r)));
    } catch (e) {
      emit(UploadProfilePicFailureState(failure: NoDataFailure()));
    }
  }


   void validateLicense(ValidateLicenseRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.validateLicense(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(ValidateLicenseFailureState(failure: l)),
          (r) => emit(ValidateLicenseSuccessState(response: r)));
    } catch (e) {
      emit(ValidateLicenseFailureState(failure: NoDataFailure()));
    }
  }

  void ocrPassportFront(OCRProfileRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.ocrPassport(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(OcrPassportFrontFailureState(failure: l)),
          (r) => emit(OcrPassportFrontSuccessState(response: r)));
    } catch (e) {
      emit(OcrPassportFrontFailureState(failure: NoDataFailure()));
    }
  }

  void ocrPassportBack(OCRProfileRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.ocrPassport(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(OcrPassportBackFailureState(failure: l)),
          (r) => emit(OcrPassportBackSuccessState(response: r)));
    } catch (e) {
      emit(OcrPassportBackFailureState(failure: NoDataFailure()));
    }
  }

  void ocrVoterFront(OCRProfileRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.ocrVoterID(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(OcrVoterFrontFailureState(failure: l)),
          (r) => emit(OcrVoterFrontSuccessState(response: r)));
    } catch (e) {
      emit(OcrVoterFrontFailureState(failure: NoDataFailure()));
    }
  }

  void ocrVoterBack(OCRProfileRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.ocrVoterID(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(OcrVoterBackFailureState(failure: l)),
          (r) => emit(OcrVoterBackSuccessState(response: r)));
    } catch (e) {
      emit(OcrVoterBackFailureState(failure: NoDataFailure()));
    }
  }



  void updateAddressLicense(UpdateAddressLicenseRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.updateLicenseAddress(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(UpdateLicenseAddressFailureState(failure: l)),
          (r) => emit(UpdateLicenseAddressSuccessState(response: r)));
    } catch (e) {
      emit(UpdateLicenseAddressFailureState(failure: NoDataFailure()));
    }
  }

  void updateAddressOffline(AddressUpdateOfflineRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.updateAddressOffline(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(AddressUpdateOfflineFailureState(failure: l)),
          (r) => emit(AddressUpdateOfflineSuccessState(response: r)));
    } catch (e) {
      emit(AddressUpdateOfflineFailureState(failure: NoDataFailure()));
    }
  }

  void updateAddressByAadhaar(UpdateAddressByAadhaarReq request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.updateAddressByAddress(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(UpdateAddressByAadhaarFailureState(failure: l)),
              (r) => emit(UpdateAddressByAadhaarSuccessState(response: r)));
    } catch (e) {
      emit(UpdateAddressByAadhaarFailureState(failure: NoDataFailure()));
    }
  }

  updateEmailConsent(bool isChecked) {
    emit(EmailConsentState(isChecked));
  }

  updatePANConsent(bool isChecked) {
    emit(PANConsentState(isChecked));
  }

  updateDrivingLicenseAddressConsent(bool isChecked) {
    emit(AddressUpdateConsentState(isChecked));
  }

   updateAadhaarConsent(bool isChecked) {
    emit(AddressUpdateConsentState(isChecked));
  }

   updateAddressConsent(bool isChecked) {
    emit(AddressUpdateConsentState(isChecked));
  }

  updateMobileConsent(bool isChecked) {
    emit(MobileConsentState(isChecked));
  }

  enterAadharConsent(bool isChecked) {
    emit(EnterAadharConsentState(isChecked));
  }

  selectAuthType(AddressDocumentDropdownModel model) {
    emit(AuthDropDownState(dropdownValue: model.value!));
  }

  void compressImage(XFile? sourceFile) async {
    try {
      final bytes = await sourceFile?.length();
      final kb = bytes! / 1024;
      final fileSizeInMB = kb / 1024;
      if (fileSizeInMB < AppConst.maxFileSizeInMB) {
        String? fileMimeType = getFileExtension(sourceFile?.path ?? "");
        if (AppConst.supportedFileTypes.contains(fileMimeType)) {
          emit(ImageCompressState(
              imageFile: sourceFile, compressSuccess: true, errorMessage: ""));
        } else {
          emit(ProfileLoadingState(isloading: true));
          XFile? outPathFile = await getCompressedFile(sourceFile);
          emit(ImageCompressState(
              imageFile: outPathFile, compressSuccess: true, errorMessage: ""));
          emit(ProfileLoadingState(isloading: false));
        }
      } else {
        emit(ImageCompressState(
            imageFile: sourceFile,
            compressSuccess: false,
            errorMessage: getString(msgMaxFileSizeError)));
        emit(ProfileLoadingState(isloading: false));
      }
    } catch (e) {
      emit(ImageCompressState(
          imageFile: sourceFile,
          compressSuccess: false,
          errorMessage: getString(msgFilePickError)));
      emit(ProfileLoadingState(isloading: false));
    }
  }

  Future<XFile?> getCompressedFile(XFile? file) async {
    final filePath = file?.path;
    final lastIndex = filePath?.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath?.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath?.substring(lastIndex ?? 0)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file!.path,
      outPath,
      quality: 50,
    );
    return result;
  }

  Future<void> uploadDocument(String presetUri, File file) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      final result = await usecase.uploadDocument(presetUri, file);
      emit(ProfileLoadingState(isloading: false));
      result.fold(
          (l) => emit(DocumentStatusFailure(failure: l)),
          (r) => emit(DocumentStatusSuccess(
              fileName: r, useCase: ProfileConst.deleteDocument)));
    } catch (e) {
      emit(DocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  Future<void> deleteDocuments(String presetUri) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      final result = await usecase.deleteDocument(presetUri);
      emit(ProfileLoadingState(isloading: false));
      result.fold(
          (l) => emit(DocumentStatusFailure(failure: l)),
          (r) => emit(DocumentStatusSuccess(
              fileName: r, useCase: ProfileConst.deleteDocument)));
    } catch (e) {
      emit(DocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  Future<void> getPresetUri(GetPresetUriRequest request,
      {required String operation}) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      await Future.delayed(const Duration(seconds: 3));
      final result = await usecase.getPresetUri(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold(
          (l) => emit(GetPresetUriResponseFailureState(failure: l)),
          (r) => emit(GetPresetUriResponseSuccessState(
              response: r, useCase: operation)));
    } catch (e) {
      emit(GetPresetUriResponseFailureState(failure: NoDataFailure()));
    }
  }
  void setDeliveryAddress(
    PermanentAddr? address,
    String? addressType,
  ) {
    emit(SelectAddressState(address: address, addressType: addressType));
  }

  void getActiveLoansList(ActiveLoanListRequest request) async {
    try {
      emit(ProfileLoadingState(isloading: true));
      await Future.delayed(const Duration(seconds: 3));
      final result = await usecase.getActiveLoansList(request);
      emit(ProfileLoadingState(isloading: false));
      result.fold((l) => emit(GetActiveLoansListFailureState(failure: l)),
              (r) => emit(GetActiveLoansListSuccessState(response: r)));
    } catch (e) {
      emit(ProfileLoadingState(isloading: false));
      emit(GetActiveLoansListFailureState(failure: NoDataFailure()));
    }
  }
}
