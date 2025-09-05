import 'dart:convert';
import 'dart:io';

import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_req.dart';
import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_res.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/dio_client_doc_upload.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:profile/config/network/api_endpoints.dart';
import 'package:profile/config/profile_constant.dart';
import 'package:profile/data/models/aadhaar_consent_req.dart';
import 'package:profile/data/models/aadhaar_consent_res.dart';
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

import '../models/active_loan_list_request.dart';
import '../models/active_loan_list_response.dart';


class ProfileDataSource {
  DioClient dioClient;
  DioClientDocUpload dioClientUnc;
  ProfileDataSource({required this.dioClient, required this.dioClientUnc});

  Future<Either<Failure, MyProfileResponse>> getMyProfile(
      MyProfileRequest req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final loginStubData = await rootBundle
          .loadString('assets/stubdata/profile/my_profile.json');
      final body = json.decode(loginStubData);
      Either<Failure, MyProfileResponse> response =
      Right(MyProfileResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.customerProfile),
          converter: (response) =>
              MyProfileResponse.fromJson(response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }
  }

  Future<Either<Failure, ProfileImageResponse>> getMyProfileImage(
      ProfileImageRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.customerProfileImage),
        converter: (response) =>
            ProfileImageResponse.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, UpdateEmailResponse>> updateEmail(
      UpdateEmailRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updateEmail),
        converter: (response) =>
            UpdateEmailResponse.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, NameMatchRes>> validateNameMatch(
      NameMatchReq req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.validateNameMatch),
        converter: (response) =>
            NameMatchRes.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, DobGenderMatchResponse>> dobGenderMatch(
      DobGenderMatchRequest req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final loginStubData = await rootBundle
          .loadString('assets/stubdata/profile/dob_gender_match_res.json');
      final body = json.decode(loginStubData);
      Either<Failure, DobGenderMatchResponse> response =
      Right(DobGenderMatchResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.validateDobGenderMatch),
          converter: (response) =>
              DobGenderMatchResponse.fromJson(response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }

  }

  Future<Either<Failure, UpdatePhoneRes>> updatePhoneNumber(
      UpdatePhoneReq req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updatePhoneNumber),
        converter: (response) =>
            UpdatePhoneRes.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, AadhaarConsentRes>> getAadhaarConsent(
      AadhaarConsentReq req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final loginStubData = await rootBundle
          .loadString('assets/stubdata/profile/get_aadhaar_consent.json');
      final body = json.decode(loginStubData);
      Either<Failure, AadhaarConsentRes> response =
      Right(AadhaarConsentRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getAadhaarConsent),
          converter: (response) =>
              AadhaarConsentRes.fromJson(response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }

  }

  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(
      ValidateAadhaarOtpReq req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final loginStubData = await rootBundle
          .loadString('assets/stubdata/profile/validateAadhaarOtp.json');
      final body = json.decode(loginStubData);
      Either<Failure, ValidateAadhaarOtpRes> response =
          Right(ValidateAadhaarOtpRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.validateAadhaarOTP),
          converter: (response) =>
              ValidateAadhaarOtpRes.fromJson(response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }
  }

  Future<Either<Failure, UpdatePanResponse>> updatePAN(
      UpdatePanRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updatePan),
        converter: (response) =>
            UpdatePanResponse.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, ValidatePANResponse>> validatePAN(
      ValidatePANRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.validatePan),
        converter: (response) =>
            ValidatePANResponse.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, UploadProfilePhotoResponse>> uploadProfilePic(
      UploadProfilePhotoRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updateProfile),
        converter: (response) => UploadProfilePhotoResponse.fromJson(
            response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, DeleteProfilePhotoResponse>> deleteProfilePic(
      DeleteProfilePhotoRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.deleteProfile),
        converter: (response) => DeleteProfilePhotoResponse.fromJson(
            response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, ValidateLicenseResponse>> validateDrivingLicense(
      ValidateLicenseRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.validateDrivingLicense),
        converter: (response) =>
            ValidateLicenseResponse.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

   Future<Either<Failure, OCRVoterIDResponse>> ocrVoterID(
      OCRProfileRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.ocrProfile),
        converter: (response) =>
            OCRVoterIDResponse.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, OCRPassportResponse>> ocrPassport(
      OCRProfileRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.ocrProfile),
        converter: (response) =>
            OCRPassportResponse.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, UpdateAddressLicenseResponse>>
      updateAddressByDrivingLicence(UpdateAddressLicenseRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updateAddress),
        converter: (response) => UpdateAddressLicenseResponse.fromJson(
            response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }

  Future<Either<Failure, AddressUpdateOfflineResponse>>
      updateAddressOffline(AddressUpdateOfflineRequest req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updateAddressOffline),
        converter: (response) => AddressUpdateOfflineResponse.fromJson(
            response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }


  Future<Either<Failure, UpdateAddressByAadhaarRes>> updateAddressByAddress(UpdateAddressByAadhaarReq req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final loginStubData = await rootBundle
          .loadString('assets/stubdata/profile/udpate_address_by_aadhaar.json');
      final body = json.decode(loginStubData);
      Either<Failure, UpdateAddressByAadhaarRes> response =
      Right(UpdateAddressByAadhaarRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.updateAddress),
          converter: (response) => UpdateAddressByAadhaarRes.fromJson(
              response as Map<String, dynamic>),
          data: req.toJson());
      return response;
    }
  }

  Future<Either<Failure, String>> deleteDocuments(String presetUri) async {
    // final loginStubData =
    //     await rootBundle.loadString('assets/stubdata/ach/get_preset_uri.json');
    // final body = json.decode(loginStubData);
    // Either<Failure, GetPresetUriResponse> response =
    //     Right(GetPresetUriResponse.fromJson(body as Map<String, dynamic>));

    //TODO code for Stub failure response
    // Either<Failure, String> response =
    //     const Left(ServerFailure("Invalid request"));

    // TODO code for actual api call
    final response = await dioClientUnc.deleteDocument(presetUri);
    return response;
  }

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest request) async {
    String fileName = request.useCase == ProfileConst.deleteDocument
        ? 'assets/stubdata/profile/get_preset_uri_delete.json'
        : 'assets/stubdata/profile/get_preset_uri.json';
    final loginStubData = await rootBundle.loadString(fileName);
    final body = json.decode(loginStubData);
    Either<Failure, GetPresetUriResponse> response =
        Right(GetPresetUriResponse.fromJson(body as Map<String, dynamic>));

    return response;
  }

  Future<Either<Failure, String>> uploadDocument(
      String presetUri, File file) async {
    final response = await dioClientUnc.uploadDocument(presetUri, file);
    return response;
  }

  Future<Either<Failure, ActiveLoanListResponse>> getActiveLoansList(
      ActiveLoanListRequest getActiveLoansListRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final loginStubData = await rootBundle
          .loadString('assets/stubdata/product_details/active_loan_list.json');
      final body = json.decode(loginStubData);
      Either<Failure, ActiveLoanListResponse> response =
      Right(ActiveLoanListResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getActiveLoanList),
        data: getActiveLoansListRequest.toJson(),
        converter: (response) =>
            ActiveLoanListResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }
  }
}
