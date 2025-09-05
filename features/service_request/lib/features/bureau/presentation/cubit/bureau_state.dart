part of 'bureau_cubit.dart';

@immutable
sealed class BureauState {}

final class BureauInitial extends BureauState {}

class BureauLoadingState extends BureauState {
  final bool isLoadingBureaus;
  final bool isLoadingPaymentLastDate;


  BureauLoadingState({
    this.isLoadingBureaus = false,
    this.isLoadingPaymentLastDate = false,
  });
}

class BureauSuccessState extends BureauState {
  final BureauResponse response;

  BureauSuccessState({required this.response});

  List<Object?> get props => [response];
}

class BureauFailureState extends BureauState {
  final Failure error;

  BureauFailureState({required this.error});

  List<Object?> get props => [error];
}

class ReasonSuccessState extends BureauState {
  final ReasonResponse response;

  ReasonSuccessState({required this.response});

  List<Object?> get props => [response];
}

class ReasonFailureState extends BureauState {
  final Failure error;

  ReasonFailureState({required this.error});

  List<Object?> get props => [error];
}

class ButtonEnableState extends BureauState {
  final bool isButtonDisable;

  ButtonEnableState({required this.isButtonDisable});

  List<Object?> get props => [isButtonDisable];
}

class BureauDocumentStatusSuccess extends BureauState {
  final String fileName;
  final String useCase;
  final bool isPayment;
  final int index;

  BureauDocumentStatusSuccess(
      {required this.fileName,
      required this.useCase,
      required this.isPayment,
      required this.index});

  List<Object?> get props => [fileName, useCase, isPayment, index];
}

class BureauDocumentStatusFailure extends BureauState {
  final Failure failure;

  BureauDocumentStatusFailure({required this.failure});

  List<Object?> get props => [failure];
}

class BureauUploadLoadingState extends BureauState {
  final bool isUploadLoading;

  BureauUploadLoadingState({required this.isUploadLoading});

  List<Object?> get props => [isUploadLoading];
}

class BureauDocumentUploadState extends BureauState {
  final String imageName;
  final bool imageAdded;
  final int index;
  final bool imagePayment;

  BureauDocumentUploadState(
      {required this.imageName,
      required this.imageAdded,
      required this.index,
      required this.imagePayment});

  List<Object?> get props => [imageName, imageAdded, index];
}

class BureauImageCompressForPaymentState extends BureauState {
  final File? imageFile;
  final bool compressSuccess;
  final String errorMessage;
  final int index;

  BureauImageCompressForPaymentState(
      {required this.imageFile,
      required this.compressSuccess,
      required this.index,
      required this.errorMessage});

  List<Object?> get props => [imageFile, compressSuccess, errorMessage, index];
}

class BureauImageCompressForCreditState extends BureauState {
  final File? imageFile;
  final bool compressSuccess;
  final String errorMessage;
  final int index;

  BureauImageCompressForCreditState(
      {required this.imageFile,
      required this.compressSuccess,
      required this.index,
      required this.errorMessage});

  List<Object?> get props => [imageFile, compressSuccess, errorMessage];
}

class BureauDocumentUploadInitial extends BureauState {
  List<Object?> get props => [];
}



class BureauGetPresetUriResponseSuccessState extends BureauState {
  final GetPresetUriResponse response;
  final String useCase;
  final bool isPayment;

  BureauGetPresetUriResponseSuccessState(
      {required this.response, required this.useCase, required this.isPayment});

  List<Object?> get props => [response, useCase, isPayment];
}

class BureauGetPresetUriResponseFailureState extends BureauState {
  final Failure failure;

  BureauGetPresetUriResponseFailureState({required this.failure});

  List<Object?> get props => [failure];
}

class BureauGenerateSRSuccessState extends BureauState {
  final GenerateSrResponse response;
  final String srType;

  BureauGenerateSRSuccessState({required this.response, required this.srType});

  List<Object?> get props => [response, srType];
}

class BureauGenerateSRFailureState extends BureauState {
  final Failure failure;

  BureauGenerateSRFailureState({required this.failure});

  List<Object?> get props => [failure];
}

class BureauSelectFileNameState extends BureauState {
  final String fileName;

  BureauSelectFileNameState({required this.fileName});

  List<Object?> get props => [fileName];
}

class GetLoansSuccessState extends BureauState {
  final GetLoansResponse response;

  GetLoansSuccessState({required this.response});

  List<Object?> get props => [response];
}

class GetLoansFailureState extends BureauState {
  final Failure failure;

  GetLoansFailureState({required this.failure});

  List<Object?> get props => [failure];
}

class GetPaymentSuccessState extends BureauState {
  final PaymentResponse response;

  GetPaymentSuccessState({required this.response});

  List<Object?> get props => [response];
}

class GetPaymentFailureState extends BureauState {
  final Failure failure;

  GetPaymentFailureState({required this.failure});

  List<Object?> get props => [failure];
}

class DedupeSuccessState extends BureauState {
  final DedupeResponse response;

  DedupeSuccessState({required this.response});

  List<Object?> get props => [response];
}

class DedupeFailureState extends BureauState {
  final Failure failure;

  DedupeFailureState({required this.failure});

  List<Object?> get props => [failure];
}

class PaymentUpdatedList extends BureauState {
  final List<String> paymentList;
  final bool canMore;

  PaymentUpdatedList(this.paymentList, this.canMore);

  List<Object?> get props => [paymentList, canMore];
}

class CreditUpdatedList extends BureauState {
  final List<String> creditList;
  final bool canCreditMore;

  CreditUpdatedList(this.creditList, this.canCreditMore);

  List<Object?> get props => [creditList, canCreditMore];
}

class IsShowLoanNotReflect extends BureauState {
  final String isShowLoanNotReflect;

  IsShowLoanNotReflect( this.isShowLoanNotReflect);

  List<Object?> get props => [isShowLoanNotReflect];
}

class EmptyRateUsState extends BureauState {
  List<Object?> get props => [];
}
