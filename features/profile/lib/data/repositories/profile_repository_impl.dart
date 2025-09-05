import 'dart:io';

import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_req.dart';
import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_res.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:profile/data/data_sources/profile_data_source.dart';
import 'package:profile/data/models/aadhaar_consent_req.dart';
import 'package:profile/data/models/aadhaar_consent_res.dart';
import 'package:profile/data/models/active_loan_list_request.dart';
import 'package:profile/data/models/active_loan_list_response.dart';
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
import 'package:profile/data/models/validate_license_request.dart';
import 'package:profile/data/models/validate_license_response.dart';
import 'package:profile/data/models/validate_pan_request.dart';
import 'package:profile/data/models/validate_pan_response.dart';
import 'package:profile/domain/repositories/profile_repository.dart';
/// ProfileRepositoryImpl is the concrete implementation of the ProfileRepository
/// interface.
/// This class implements the methods defined in ProfileRepository to interact
/// with data. It acts as a bridge between the domain layer
/// (use cases) and the data layer (data sources).
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  ProfileRepositoryImpl({
    required this.profileDataSource,
  });

  @override
  Future<Either<Failure, MyProfileResponse>> getMyProfile(
      MyProfileRequest req) async {
    final result = await profileDataSource.getMyProfile(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ProfileImageResponse>> getMyProfileImage(
      ProfileImageRequest req) async {
    final result = await profileDataSource.getMyProfileImage(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }



  @override
  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req) async {
    final result = await profileDataSource.getPresetUri(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> uploadDocument(
      String presetUri, File file) async {
    final result = await profileDataSource.uploadDocument(presetUri, file);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> deleteDocument(String presetUri) async {
    final result = await profileDataSource.deleteDocuments(presetUri);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdateEmailResponse>> updateEmailID(
      UpdateEmailRequest updateEmailRequest) async {
    final result = await profileDataSource.updateEmail(updateEmailRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdatePanResponse>> updatePAN(
      UpdatePanRequest req) async {
    final result = await profileDataSource.updatePAN(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UploadProfilePhotoResponse>> uploadProfilePic(
      UploadProfilePhotoRequest req) async {
    final result = await profileDataSource.uploadProfilePic(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, DeleteProfilePhotoResponse>> deleteProfilePic(
      DeleteProfilePhotoRequest req) async {
    final result = await profileDataSource.deleteProfilePic(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidatePANResponse>> validatePAN(
      ValidatePANRequest req) async {
    final result = await profileDataSource.validatePAN(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, AadhaarConsentRes>> getAadhaarConsent(
      AadhaarConsentReq req) async {
    final result = await profileDataSource.getAadhaarConsent(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(
      ValidateAadhaarOtpReq req) async {
    final result = await profileDataSource.validateAadhaarOtp(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, NameMatchRes>> validateNameMatch(
      NameMatchReq req) async {
    final result = await profileDataSource.validateNameMatch(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdatePhoneRes>> updatePhoneNumber(
      UpdatePhoneReq req) async {
    final result = await profileDataSource.updatePhoneNumber(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdateAddressLicenseResponse>> updateAddressLicense(
      UpdateAddressLicenseRequest req) async {
    final result = await profileDataSource.updateAddressByDrivingLicence(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, AddressUpdateOfflineResponse>> updateAddressOffline(
      AddressUpdateOfflineRequest req) async {
    final result = await profileDataSource.updateAddressOffline(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateLicenseResponse>> validateLicense(
      ValidateLicenseRequest req) async {
    final result = await profileDataSource.validateDrivingLicense(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

   @override
  Future<Either<Failure, OCRVoterIDResponse>> ocrVoterID(
      OCRProfileRequest req) async {
    final result = await profileDataSource.ocrVoterID(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

   @override
  Future<Either<Failure, OCRPassportResponse>> ocrPassport(
      OCRProfileRequest req) async {
    final result = await profileDataSource.ocrPassport(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }


  @override
  Future<Either<Failure, DobGenderMatchResponse>> dobGenderMatch(DobGenderMatchRequest req) async{
    final result = await profileDataSource.dobGenderMatch(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, UpdateAddressByAadhaarRes>> updateAddressByAddress(UpdateAddressByAadhaarReq req) async{
    final result = await profileDataSource.updateAddressByAddress(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ActiveLoanListResponse>> getActiveLoansList(ActiveLoanListRequest getActiveLoanRequest) async{
    final result = await profileDataSource.getActiveLoansList(getActiveLoanRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
