// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ach_cubit.dart';

@immutable
sealed class AchState extends Equatable {}

final class AchInitial extends AchState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends AchState {
  final bool isloading;

  LoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class LoadingDialogState extends AchState {
  final bool isloading;

  LoadingDialogState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class GetLoansListSuccessState extends AchState {
  final GetAchLoansResponse response;

  GetLoansListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetLoansListFailureState extends AchState {
  final Failure failure;

  GetLoansListFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class FetchBankAccountSuccessState extends AchState {
  final FetchBankAccountResponse response;
  final LoanData? loanItem;

  FetchBankAccountSuccessState({required this.response, required this.loanItem});

  @override
  List<Object?> get props => [response];
}

class FetchBankAccountFailureState extends AchState {
  final Failure failure;

  FetchBankAccountFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetBankListSuccessState extends AchState {
  final new_banks.GetBankListResponse response;

  GetBankListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FilterBankList extends AchState {
  final new_banks.Bank bank;

  FilterBankList({required this.bank});

  @override
  List<Object?> get props => [bank];
}

class GetBankListFailureState extends AchState {
  final Failure failure;

  GetBankListFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}


class GetCMSBankListSuccessState extends AchState {
  final GetCMSBankListResponse response;

  GetCMSBankListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetCMSBankListFailureState extends AchState {
  final Failure failure;

  GetCMSBankListFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetPopularBankListSuccessState extends AchState {
  final List<PopularBank>? response;

  GetPopularBankListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetPopularBankListFailureState extends AchState {
  final Failure failure;

  GetPopularBankListFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetMandatesSuccessState extends AchState {
  final GetMandateResponse response;

  GetMandatesSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetMandatesFailureState extends AchState {
  final Failure failure;

  GetMandatesFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class PennyDropSuccessState extends AchState {
  final PennyDropResponse response;

  PennyDropSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class PennyDropFailureState extends AchState {
  final Failure failure;

  PennyDropFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ValidateNameSuccessState extends AchState {
  final NameMatchRes response;
  final String payerName;

  ValidateNameSuccessState({required this.response, required this.payerName});

  @override
  List<Object?> get props => [response];
}

class ValidateNameFailureState extends AchState {
  final Failure failure;

  ValidateNameFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GenerateMandateReqSuccessState extends AchState {
  final GenerateMandateResponse response;

  GenerateMandateReqSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GenerateMandateReqFailureState extends AchState {
  final Failure failure;

  GenerateMandateReqFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GenerateUpiMandateReqSuccessState extends AchState {
  final GenerateUpiMandateResponse response;
  final String trxnNo;

  GenerateUpiMandateReqSuccessState({required this.response, required this.trxnNo});

  @override
  List<Object?> get props => [response];
}

class GenerateUpiMandateReqFailureState extends AchState {
  final Failure failure;

  GenerateUpiMandateReqFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetCancelMandateReasonSuccessState extends AchState {
  final GetCancelMandateReasonResponse response;

  GetCancelMandateReasonSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetCancelMandateReasonFailureState extends AchState {
  final Failure failure;

  GetCancelMandateReasonFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetPresetUriResponseSuccessState extends AchState {
  final GetPresetUriResponse response;
  final String useCase;

  GetPresetUriResponseSuccessState({required this.response,required this.useCase});

  @override
  List<Object?> get props => [response, useCase];
}

class GetPresetUriResponseFailureState extends AchState {
  final Failure failure;

  GetPresetUriResponseFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SelectBankState extends AchState {
  final BankData? bank;
  SelectBankState({
    required this.bank,
  });
  @override
  List<Object?> get props => [bank];
}

class SelectNewBankState extends AchState {
  final new_banks.Bank? bank;
  SelectNewBankState({
    required this.bank,
  });
  @override
  List<Object?> get props => [bank];
}

class GetUpdateMandeReasonSuccessState extends AchState {
  final UpdateMandateReasonResp response;

  GetUpdateMandeReasonSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetUpdateMandeReasonFailureState extends AchState {
  final Failure failure;

  GetUpdateMandeReasonFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SelectCancelReasonState extends AchState {
  final CancelReason reasonResponse;

  SelectCancelReasonState({required this.reasonResponse});

  @override
  List<Object?> get props => [reasonResponse];
}

class SelectUpdateReasonState extends AchState {
  final UpdateMandateReason reasonResponse;

  SelectUpdateReasonState({required this.reasonResponse});

  @override
  List<Object?> get props => [reasonResponse];
}

class SelectNewBankVerificationOtpionState extends AchState {
  final new_banks.VerificationOption? option;
  final new_banks.Bank? bank;

  SelectNewBankVerificationOtpionState({required this.option, required this.bank});

  @override
  List<Object?> get props => [option];
}

class SelectedLoanItemState extends AchState {
  final LoanData? loanItem;

  SelectedLoanItemState({required this.loanItem});

  @override
  List<Object?> get props => [loanItem];
}

class ValidateVpaSuccessState extends AchState {
  final ValidateVpaResp response;

  ValidateVpaSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ValidateVpaFailureState extends AchState {
  final Failure failure;

  ValidateVpaFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class FetchApplicantNameSuccessState extends AchState {
  final FetchApplicantNameRes response;
  final LoanData? loanData;

  FetchApplicantNameSuccessState({required this.response, required this.loanData});

  @override
  List<Object?> get props => [response, loanData];
}

class FetchApplicantNameFailureState extends AchState {
  final Failure failure;

  FetchApplicantNameFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class CheckVpaStatusSuccessState extends AchState {
  final CheckVpaStatusRes response;

  CheckVpaStatusSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class CheckVpaStatusFailureState extends AchState {
  final Failure failure;

  CheckVpaStatusFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class DecryptCampsOutputSuccessState extends AchState {
  final CampsOutputRes response;

  DecryptCampsOutputSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class DecryptCampsOutputFailureState extends AchState {
  final Failure failure;

  DecryptCampsOutputFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class NupayStatusByIdSuccessState extends AchState {
  final NupayStatusRes response;

  NupayStatusByIdSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class NupayStatusByIdFailureState extends AchState {
  final Failure failure;

  NupayStatusByIdFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SelectedApplicant extends AchState {
  final String? applicant;
  SelectedApplicant({
    required this.applicant,
  });
  @override
  List<Object?> get props => [];
}

class DocumentStatusSuccess extends AchState {
  final String fileName;
  final String useCase;

  DocumentStatusSuccess({required this.fileName, required this.useCase});

  @override
  List<Object?> get props => [fileName, useCase];
}

class DocumentStatusFailure extends AchState {
  final Failure failure;

  DocumentStatusFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}



class DocumentUploadState extends AchState {
  final String imageName;
  final bool imageAdded;

  DocumentUploadState({required this.imageName, required this.imageAdded});

  @override
  List<Object?> get props => [imageName, imageAdded];
}

class ImageCompressState extends AchState {
  final File? imageFile;
  final bool compressSuccess;
  final String errorMessage;

  ImageCompressState({required this.imageFile, required this.compressSuccess, required this.errorMessage});

  @override
  List<Object?> get props => [imageFile, compressSuccess, errorMessage];
}
