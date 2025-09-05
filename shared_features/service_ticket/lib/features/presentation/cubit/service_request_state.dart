import 'dart:io';

import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/documents_response.dart';
import 'package:service_ticket/features/data/models/dedupe_response.dart';
import 'package:service_ticket/features/data/models/reopen_case_response.dart';
import '../../data/models/get_preset_uri_response.dart';
import '../../data/models/query_subquery_response.dart';
import '../../data/models/reopen_reason_response.dart';
import '../../data/models/service_request_response.dart';
import '../../data/models/view_sr_response.dart';

abstract class ServiceRequestState extends Equatable {}

class ServiceRequestInitial extends ServiceRequestState {
  @override
  List<Object?> get props => [];
}

class ServiceRequestLoadingState extends ServiceRequestState {
  final bool isLoading;
  ServiceRequestLoadingState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class ServiceRequestSuccessState extends ServiceRequestState {
  final ServiceRequestResponse response;
  ServiceRequestSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ServiceRequestFailureState extends ServiceRequestState {
  final Failure error;
  ServiceRequestFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class ViewServiceRequestSuccessState extends ServiceRequestState {
  final ViewSRResponse response;
  ViewServiceRequestSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ViewServiceRequestFailureState extends ServiceRequestState {
  final Failure error;
  ViewServiceRequestFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class QuerySubQuerySuccessState extends ServiceRequestState {
  final FetchQuerySubQueryResponse response;
  QuerySubQuerySuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class QuerySubQueryFailureState extends ServiceRequestState {
  final Failure error;
  QuerySubQueryFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchReopenReasonsSuccessState extends ServiceRequestState {
  final ReopenReasonResponse response;
  FetchReopenReasonsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class FetchReopenReasonsFailureState extends ServiceRequestState {
  final Failure error;
  FetchReopenReasonsFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
// ignore_for_file: must_be_immutable
class ReopenServiceRequestSuccessState extends ServiceRequestState {
  ReopenCaseResponse response;
  ReopenServiceRequestSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class ReopenServiceRequestFailureState extends ServiceRequestState {
  final Failure error;
  ReopenServiceRequestFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}

class CheckDedupeSuccessState extends ServiceRequestState {
  final DedupeResponse response;
  CheckDedupeSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class CheckDedupeFailureState extends ServiceRequestState {
  final Failure error;
  CheckDedupeFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class SelectedQueryState extends ServiceRequestState {
  final String name;
  SelectedQueryState({required this.name});

  @override
  List<Object?> get props => [name];
}

class SelectedAddMoreState extends ServiceRequestState {
  final bool isMulitpleEnabled;
  SelectedAddMoreState({required this.isMulitpleEnabled});

  @override
  List<Object?> get props => [isMulitpleEnabled];
}

class UploadLoadingState extends ServiceRequestState {
  final bool isUploadLoading;

  UploadLoadingState({required this.isUploadLoading});

  @override
  List<Object?> get props => [isUploadLoading];
}

class DocumentUploadState extends ServiceRequestState {
  final String imageName;
  final bool imageAdded;
  final bool? isSecondImage;
  DocumentUploadState({required this.imageName, required this.imageAdded, this.isSecondImage});

  @override
  List<Object?> get props => [imageName, imageAdded, isSecondImage];
}

class DocumentStatusSuccess extends ServiceRequestState {
  final String fileName;
  final String useCase;
  final bool? isSecondImage;
  DocumentStatusSuccess({required this.fileName, required this.useCase, this.isSecondImage});

  @override
  List<Object?> get props => [fileName, useCase];
}

class DocumentStatusFailure extends ServiceRequestState {
  final Failure failure;

  DocumentStatusFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ImageCompressState extends ServiceRequestState {
  final File? imageFile;
  final bool? isSecondImage;
  final bool compressSuccess;
  final String errorMessage;

  ImageCompressState(
      {required this.imageFile,
        this.isSecondImage,
        required this.compressSuccess,
        required this.errorMessage});

  @override
  List<Object?> get props => [imageFile, isSecondImage, compressSuccess, errorMessage];
}

class GetPresetUriResponseSuccessState extends ServiceRequestState {
  final GetPresetUriResponse response;
  final String useCase;
  final bool? isSecondImage;
  GetPresetUriResponseSuccessState({required this.response,required this.useCase, this.isSecondImage});

  @override
  List<Object?> get props => [response, useCase, isSecondImage];
}

class GetPresetUriResponseFailureState extends ServiceRequestState {
  final Failure failure;

  GetPresetUriResponseFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
class SrDetailsSuccessState extends ServiceRequestState {
  final ViewSRResponse response;
  SrDetailsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class SrDetailsFailureState extends ServiceRequestState {
  final Failure error;
  SrDetailsFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class GetDocumentsSuccessState extends ServiceRequestState {
  final DocumentsResponse response;

  GetDocumentsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class SOADocumentsSuccessState extends ServiceRequestState {
  final DocumentsResponse response;

  SOADocumentsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class RepaymentScheduleDocumentSuccessState extends ServiceRequestState {
  final DocumentsResponse response;

  RepaymentScheduleDocumentSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetDocumentsFailureState extends ServiceRequestState {
  final Failure failure;

  GetDocumentsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ActiveLoansDetailsSuccessState extends ServiceRequestState {
  final ActiveLoanDetailResponse response;

  ActiveLoansDetailsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ActiveLoansDetailsFailureState extends ServiceRequestState {
  final Failure failure;

  ActiveLoansDetailsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}