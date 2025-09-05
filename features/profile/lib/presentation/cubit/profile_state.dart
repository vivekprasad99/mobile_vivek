part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {}

final class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ProfileLoadingState extends ProfileState {
  final bool isloading;

  ProfileLoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class ImageLoadingState extends ProfileState {
  final bool isImageloading;

  ImageLoadingState({required this.isImageloading});

  @override
  List<Object?> get props => [isImageloading];
}

class MyProfileSuccessState extends ProfileState {
  final MyProfileResponse response;

  MyProfileSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class MyProfileFailureState extends ProfileState {
  final Failure failure;

  MyProfileFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class MyProfileImageSuccessState extends ProfileState {
  final ProfileImageResponse response;

  MyProfileImageSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class MyProfileImageFailureState extends ProfileState {
  final Failure failure;

  MyProfileImageFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UpdateEmailSuccessState extends ProfileState {
  final UpdateEmailResponse response;

  UpdateEmailSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class UpdateEmailFailureState extends ProfileState {
  final Failure failure;

  UpdateEmailFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UpdatePANSuccessState extends ProfileState {
  final UpdatePanResponse response;

  UpdatePANSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class UpdatePANFailureState extends ProfileState {
  final Failure failure;

  UpdatePANFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ValidatePANSuccessState extends ProfileState {
  final ValidatePANResponse response;

  ValidatePANSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ValidatePANFailureState extends ProfileState {
  final Failure failure;

  ValidatePANFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ValidateLicenseSuccessState extends ProfileState {
  final ValidateLicenseResponse response;

  ValidateLicenseSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ValidateLicenseFailureState extends ProfileState {
  final Failure failure;

  ValidateLicenseFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class OcrPassportFrontSuccessState extends ProfileState {
  final OCRPassportResponse response;

  OcrPassportFrontSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class OcrPassportFrontFailureState extends ProfileState {
  final Failure failure;

  OcrPassportFrontFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class OcrPassportBackSuccessState extends ProfileState {
  final OCRPassportResponse response;

  OcrPassportBackSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class OcrPassportBackFailureState extends ProfileState {
  final Failure failure;

  OcrPassportBackFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class OcrVoterFrontSuccessState extends ProfileState {
  final OCRVoterIDResponse response;

  OcrVoterFrontSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class OcrVoterFrontFailureState extends ProfileState {
  final Failure failure;

  OcrVoterFrontFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}


class OcrVoterBackSuccessState extends ProfileState {
  final OCRVoterIDResponse response;

  OcrVoterBackSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class OcrVoterBackFailureState extends ProfileState {
  final Failure failure;

  OcrVoterBackFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
class UpdateLicenseAddressSuccessState extends ProfileState {
  final UpdateAddressLicenseResponse response;

  UpdateLicenseAddressSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class UpdateLicenseAddressFailureState extends ProfileState {
  final Failure failure;

  UpdateLicenseAddressFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class AddressUpdateOfflineSuccessState extends ProfileState {
  final AddressUpdateOfflineResponse response;

  AddressUpdateOfflineSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class AddressUpdateOfflineFailureState extends ProfileState {
  final Failure failure;

  AddressUpdateOfflineFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UpdateAddressByAadhaarSuccessState extends ProfileState {
  final UpdateAddressByAadhaarRes response;

  UpdateAddressByAadhaarSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class UpdateAddressByAadhaarFailureState extends ProfileState {
  final Failure failure;

  UpdateAddressByAadhaarFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UploadProfilePicSuccessState extends ProfileState {
  final UploadProfilePhotoResponse response;

  UploadProfilePicSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class UploadProfilePicFailureState extends ProfileState {
  final Failure failure;

  UploadProfilePicFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class DeleteProfilePicSuccessState extends ProfileState {
  final DeleteProfilePhotoResponse response;

  DeleteProfilePicSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class DeleteProfilePicFailureState extends ProfileState {
  final Failure failure;

  DeleteProfilePicFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class PANConsentState extends ProfileState {
  final bool isPANConsent;
  PANConsentState(this.isPANConsent);

  @override
  List<Object?> get props => [isPANConsent];
}

class AddressUpdateConsentState extends ProfileState {
  final bool isAddressConsent;
  AddressUpdateConsentState(this.isAddressConsent);

  @override
  List<Object?> get props => [isAddressConsent];
}

class AadhaarConsentState extends ProfileState {
  final bool isAadhaarConsent;
  AadhaarConsentState(this.isAadhaarConsent);

  @override
  List<Object?> get props => [isAadhaarConsent];
}

class DocumentStatusFailure extends ProfileState {
  final Failure failure;

  DocumentStatusFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class AuthDropDownState extends ProfileState {
  
  final String dropdownValue;

  AuthDropDownState({required this.dropdownValue});

  @override
  List<Object?> get props => [dropdownValue];
}

class EmailConsentState extends ProfileState {
  final bool isEmailConsent;
  EmailConsentState(this.isEmailConsent);

  @override
  List<Object?> get props => [isEmailConsent];
}

class MobileConsentState extends ProfileState {
  final bool isMobileConsent;
  MobileConsentState(this.isMobileConsent);

  @override
  List<Object?> get props => [isMobileConsent];
}

class EnterAadharConsentState extends ProfileState {
  final bool isEnterAadharConsent;
  EnterAadharConsentState(this.isEnterAadharConsent);

  @override
  List<Object?> get props => [isEnterAadharConsent];
}

class DocumentStatusSuccess extends ProfileState {
  final String fileName;
  final String useCase;

  DocumentStatusSuccess({required this.fileName, required this.useCase});

  @override
  List<Object?> get props => [fileName, useCase];
}

class ProfileUploadState extends ProfileState {
  final String imageName;
  final bool imageAdded;

  ProfileUploadState({required this.imageName, required this.imageAdded});

  @override
  List<Object?> get props => [imageName, imageAdded];
}

class ImageCompressState extends ProfileState {
  final XFile? imageFile;
  final bool compressSuccess;
  final String errorMessage;

  ImageCompressState(
      {required this.imageFile,
      required this.compressSuccess,
      required this.errorMessage});

  @override
  List<Object?> get props => [imageFile, compressSuccess, errorMessage];
}

class GetPresetUriResponseSuccessState extends ProfileState {
  final GetPresetUriResponse response;
  final String useCase;

  GetPresetUriResponseSuccessState(
      {required this.response, required this.useCase});

  @override
  List<Object?> get props => [response, useCase];
}

class GetPresetUriResponseFailureState extends ProfileState {
  final Failure failure;

  GetPresetUriResponseFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}


class GetAadhaarConsentSuccessState extends ProfileState {
  final AadhaarConsentRes response;

  GetAadhaarConsentSuccessState(
      {required this.response});

  @override
  List<Object?> get props => [response];
}

class GetAadhaarConsentFailureState extends ProfileState {
  final Failure failure;

  GetAadhaarConsentFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SentAadhaarOtpSuccessState extends ProfileState {
  final ValidateAadhaarOtpRes response;

  SentAadhaarOtpSuccessState(
      {required this.response});

  @override
  List<Object?> get props => [response];
}

class SentAadhaarOtpFailureState extends ProfileState {
  final Failure failure;

  SentAadhaarOtpFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class NameMatchSuccessState extends ProfileState {
  final NameMatchRes response;

  NameMatchSuccessState(
      {required this.response});

  @override
  List<Object?> get props => [response];
}

class NameMatchFailureState extends ProfileState {
  final Failure failure;

  NameMatchFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}


class DobGenderMatchSuccessState extends ProfileState {
  final DobGenderMatchResponse response;

  DobGenderMatchSuccessState(
      {required this.response});

  @override
  List<Object?> get props => [response];
}

class DobGenderMatchFailureState extends ProfileState {
  final Failure failure;

  DobGenderMatchFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
class UpdatePhoneSuccessState extends ProfileState {
  final UpdatePhoneRes response;

  UpdatePhoneSuccessState(
      {required this.response});

  @override
  List<Object?> get props => [response];
}

class UpdatePhoneFailureState extends ProfileState {
  final Failure failure;

  UpdatePhoneFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
class SelectAddressState extends ProfileState {
  final PermanentAddr? address;
  final String? addressType;

  SelectAddressState({
    required this.address,
    required this.addressType,
  });
  @override
  List<Object?> get props => [address, addressType];
}
class GetActiveLoansListSuccessState extends ProfileState {
  final ActiveLoanListResponse response;

  GetActiveLoansListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetActiveLoansListFailureState extends ProfileState {
  final Failure failure;

  GetActiveLoansListFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
