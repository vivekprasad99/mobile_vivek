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

/// ProfileRepository is an abstract class defining the contract for operations
/// related to data within the domain layer.
/// Concrete implementations of this repository interface will be provided
/// in the data layer to interact with specific data sources (e.g., API, database).
abstract class ProfileRepository {
  Future<Either<Failure, String>> deleteDocument(String presetUri);
  Future<Either<Failure, MyProfileResponse>> getMyProfile(MyProfileRequest req);
  Future<Either<Failure, ProfileImageResponse>> getMyProfileImage(ProfileImageRequest req);
  Future<Either<Failure, UpdateEmailResponse>> updateEmailID(
      UpdateEmailRequest req);
  Future<Either<Failure, UpdatePanResponse>> updatePAN(UpdatePanRequest req);
  Future<Either<Failure, ValidatePANResponse>> validatePAN(ValidatePANRequest req);
  Future<Either<Failure, ValidateLicenseResponse>> validateLicense(ValidateLicenseRequest req);
    Future<Either<Failure, OCRVoterIDResponse>> ocrVoterID(OCRProfileRequest req);
        Future<Either<Failure, OCRPassportResponse>> ocrPassport(OCRProfileRequest req);
  Future<Either<Failure, UpdateAddressLicenseResponse>> updateAddressLicense(UpdateAddressLicenseRequest req);
    Future<Either<Failure, AddressUpdateOfflineResponse>> updateAddressOffline(AddressUpdateOfflineRequest req);
  Future<Either<Failure, UpdateAddressByAadhaarRes>> updateAddressByAddress(UpdateAddressByAadhaarReq req);
  Future<Either<Failure, UploadProfilePhotoResponse>> uploadProfilePic(UploadProfilePhotoRequest req);
  Future<Either<Failure, DeleteProfilePhotoResponse>> deleteProfilePic(DeleteProfilePhotoRequest req);
  Future<Either<Failure, String>> uploadDocument(String presetUri, File file);
  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req);
  Future<Either<Failure, AadhaarConsentRes>> getAadhaarConsent(
      AadhaarConsentReq req);
  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(
      ValidateAadhaarOtpReq req);
  Future<Either<Failure, NameMatchRes>> validateNameMatch(
      NameMatchReq req);
  Future<Either<Failure, DobGenderMatchResponse>> dobGenderMatch(
      DobGenderMatchRequest req);
  Future<Either<Failure, UpdatePhoneRes>> updatePhoneNumber(
      UpdatePhoneReq req);
  Future<Either<Failure, ActiveLoanListResponse>> getActiveLoansList(
      ActiveLoanListRequest getActiveLoanRequest);
}
