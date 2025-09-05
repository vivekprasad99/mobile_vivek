import 'dart:io';

import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_req.dart';
import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_res.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:profile/data/models/addr_update_offline_req.dart';
import 'package:profile/data/models/addr_update_offline_res.dart';
import 'package:profile/data/models/delete_profile_pic_request.dart';
import 'package:profile/data/models/delete_profile_pic_response.dart';
import 'package:profile/data/models/dob_gender_match_req.dart';
import 'package:profile/data/models/dob_gender_match_res.dart';
import 'package:profile/data/models/get_preset_uri_request.dart';
import 'package:profile/data/models/get_preset_uri_response.dart';
import 'package:profile/data/models/get_profile_img.res.dart';
import 'package:profile/data/models/get_profile_img_req.dart';
import 'package:profile/data/models/my_profile_model_request.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/data/models/ocr_passport_response.dart';
import 'package:profile/data/models/ocr_profile_request.dart';
import 'package:profile/data/models/ocr_voterid_response.dart';
import 'package:profile/data/models/update_address_license_request.dart';
import 'package:profile/data/models/update_address_license_response.dart';
import 'package:profile/data/models/update_email_request.dart';
import 'package:profile/data/models/update_email_response.dart';
import 'package:profile/data/models/update_pan_request.dart';
import 'package:profile/data/models/update_pan_response.dart';
import 'package:profile/data/models/upload_profile_pic_request.dart';
import 'package:profile/data/models/upload_profile_pic_response.dart';
import 'package:profile/data/models/validate_license_request.dart';
import 'package:profile/data/models/validate_license_response.dart';
import 'package:profile/data/models/validate_pan_request.dart';
import 'package:profile/data/models/validate_pan_response.dart';
import 'package:profile/domain/repositories/profile_repository.dart';

import '../../data/models/aadhaar_consent_req.dart';
import '../../data/models/aadhaar_consent_res.dart';
import '../../data/models/active_loan_list_request.dart';
import '../../data/models/active_loan_list_response.dart';
import '../../data/models/name_match_req.dart';
import '../../data/models/name_match_res.dart';
import '../../data/models/update_address_by_aadhaar_req.dart';
import '../../data/models/update_address_by_aadhaar_res.dart';
import '../../data/models/update_phone_req.dart';
import '../../data/models/update_phone_res.dart';

/// use case is a class responsible for encapsulating a specific piece of business logic or
/// a particular operation that your application needs to perform.
/// It acts as a bridge between the presentation
/// layer and the data layer.
class ProfileUseCase {
  final ProfileRepository profileRepository;
  ProfileUseCase({required this.profileRepository});

  Future<Either<Failure, String>> deleteDocument(String presetUrl) async {
    return await profileRepository.deleteDocument(presetUrl);
  }

  Future<Either<Failure, MyProfileResponse>> getMyProfile(
      MyProfileRequest req) async {
    return await profileRepository.getMyProfile(req);
  }

  Future<Either<Failure, ProfileImageResponse>> getMyProfileImage(
      ProfileImageRequest req) async {
    return await profileRepository.getMyProfileImage(req);
  }

  Future<Either<Failure, UpdateEmailResponse>> updateEmailID(
      UpdateEmailRequest req) async {
    return await profileRepository.updateEmailID(req);
  }

  Future<Either<Failure, UpdatePanResponse>> updatePAN(
      UpdatePanRequest req) async {
    return await profileRepository.updatePAN(req);
  }

  Future<Either<Failure, ValidatePANResponse>> validatePAN(
      ValidatePANRequest req) async {
    return await profileRepository.validatePAN(req);
  }

  Future<Either<Failure, UploadProfilePhotoResponse>> uploadProfilePic(
      UploadProfilePhotoRequest req) async {
    return await profileRepository.uploadProfilePic(req);
  }

  Future<Either<Failure, DeleteProfilePhotoResponse>> deleteProfilePic(
      DeleteProfilePhotoRequest req) async {
    return await profileRepository.deleteProfilePic(req);
  }

  Future<Either<Failure, UpdateAddressLicenseResponse>> updateLicenseAddress(
      UpdateAddressLicenseRequest req) async {
    return await profileRepository.updateAddressLicense(req);
  }

  Future<Either<Failure, AddressUpdateOfflineResponse>> updateAddressOffline(
      AddressUpdateOfflineRequest req) async {
    return await profileRepository.updateAddressOffline(req);
  }

  Future<Either<Failure, UpdateAddressByAadhaarRes>> updateAddressByAddress(
      UpdateAddressByAadhaarReq req) async {
    return await profileRepository.updateAddressByAddress(req);
  }

  Future<Either<Failure, ValidateLicenseResponse>> validateLicense(
      ValidateLicenseRequest req) async {
    return await profileRepository.validateLicense(req);
  }

  Future<Either<Failure, OCRVoterIDResponse>> ocrVoterID(
      OCRProfileRequest req) async {
    return await profileRepository.ocrVoterID(req);
  }

  Future<Either<Failure, OCRPassportResponse>> ocrPassport(
      OCRProfileRequest req) async {
    return await profileRepository.ocrPassport(req);
  }
  

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req) async {
    return await profileRepository.getPresetUri(req);
  }

  Future<Either<Failure, String>> uploadDocument(
      String presetUrl, File file) async {
    return await profileRepository.uploadDocument(presetUrl, file);
  }

  Future<Either<Failure, AadhaarConsentRes>> getAadhaarConsent(
      AadhaarConsentReq req) async {
    return await profileRepository.getAadhaarConsent(req);
  }
  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(
      ValidateAadhaarOtpReq req) async {
    return await profileRepository.validateAadhaarOtp(req);
  }

  Future<Either<Failure, NameMatchRes>> validateNameMatch(
      NameMatchReq req) async {
    return await profileRepository.validateNameMatch(req);
  }

  Future<Either<Failure, DobGenderMatchResponse>> validateDobGenderMatch(
      DobGenderMatchRequest req) async {
    return await profileRepository.dobGenderMatch(req);
  }

  Future<Either<Failure, UpdatePhoneRes>> updatePhoneNumber(UpdatePhoneReq req) async {
    return await profileRepository.updatePhoneNumber(req);
  }


  Future<Either<Failure, ActiveLoanListResponse>> getActiveLoansList(
      ActiveLoanListRequest params) async {
    return await profileRepository.getActiveLoansList(params);
  }
}
