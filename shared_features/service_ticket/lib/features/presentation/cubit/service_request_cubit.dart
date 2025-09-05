import 'package:core/config/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_details/data/models/active_loan_detail_request.dart';
import 'package:product_details/data/models/doucments_request.dart';
import 'package:product_details/domain/usecases/product_detail_usecases.dart';
import 'package:service_ticket/features/data/models/reopen_case_request.dart';
import 'package:service_ticket/features/data/models/sr_details_request.dart';
import '../../../../config/utils.dart';
import '../../constants/sr_constant.dart';
import '../../data/models/get_preset_uri_request.dart';
import '../../data/models/query_subquery_request.dart';
import '../../data/models/sr_request.dart';
import '../../data/models/view_sr_request.dart';
import '../../presentation/cubit/service_request_state.dart';
import '../../domain/usecasses/service_request_usecase.dart';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  final ServiceRequestUseCase serviceRequestUseCase;
  final ProductDetailsUseCase productDetailsUseCase;

  ServiceRequestCubit({required this.serviceRequestUseCase, required this.productDetailsUseCase})
      : super(ServiceRequestInitial());

  fetchQuerySubQuery(FetchQuerySubQueryRequest request) async {
    try {
      emit(ServiceRequestLoadingState(isLoading: true));
      final result = await serviceRequestUseCase.fetchQuerySubQuery(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(QuerySubQueryFailureState(error: l)),
              (r) => emit(QuerySubQuerySuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(QuerySubQueryFailureState(error: NoDataFailure()));
    }
  }

  void selectQuery(String name) {
    emit(SelectedQueryState(name: name));
  }

  void selectAddMore(bool isAddMoreSelected) {
    emit(SelectedAddMoreState(isMulitpleEnabled: isAddMoreSelected));
  }

  void imageAdded(bool imageAdded,String imageName, {bool? isSecondImage}) {
    emit(DocumentUploadState(imageAdded: imageAdded, imageName: imageName, isSecondImage: isSecondImage));
  }

  void compressImage(XFile? sourceFile, {bool? isSecondImage, int filesize = AppConst.maxFileSizeInMB}) async{
    try {
      emit(UploadLoadingState(isUploadLoading: true));
      var renameFile = await pickAndRenameImage(sourceFile!,"sr");
      final bytes = await renameFile.length();
      final kb = bytes/1024;
      final fileSizeInMB = kb / 1024;
      if (fileSizeInMB < filesize) {
        String? fileMimeType = getFileExtension(renameFile.path);
        if (AppConst.supportedFileTypes.contains(fileMimeType)) {
          emit(UploadLoadingState(isUploadLoading: false));
          emit(ImageCompressState(
              imageFile: renameFile, isSecondImage: isSecondImage, compressSuccess: true, errorMessage: ""));
        } else {
          File? outPathFile = await getCompressedFile(renameFile);
          emit(ImageCompressState(
              imageFile: outPathFile, isSecondImage: isSecondImage, compressSuccess: true, errorMessage: ""));
          emit(UploadLoadingState(isUploadLoading: false));
        }
      } else {
        emit(ImageCompressState(imageFile: renameFile,isSecondImage: isSecondImage, compressSuccess: false,errorMessage: getString(msgMaxFileSizeError)));
        emit(UploadLoadingState(isUploadLoading: false));
      }
    } catch (e) {
      emit(ImageCompressState(imageFile: File(sourceFile?.path ?? ""), isSecondImage: isSecondImage, compressSuccess: false,errorMessage: getString(msgFilePickError)));
      emit(UploadLoadingState(isUploadLoading: false));
    }
  }

  Future<File?> getCompressedFile(File? file) async {
    final filePath = file?.path;
    final lastIndex = filePath?.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath?.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath?.substring(lastIndex??0)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file!.path, outPath,
      quality: 50,
    );
    return File(result!.path);
  }

  Future<void> uploadDocument(String presetUri,File file) async {
    try {
      emit(UploadLoadingState(isUploadLoading: true));
      final result = await serviceRequestUseCase.uploadDocument(presetUri, file);
      emit(UploadLoadingState(isUploadLoading: false));
      result.fold((l) => emit(DocumentStatusFailure(failure: l)),
              (r) => emit(DocumentStatusSuccess(fileName: r, useCase: SRConst.deleteDocument)));
    } catch (e) {
      emit(DocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  Future<void> deleteDocuments(String presetUri, bool? isSecondImage) async {
    try {
      emit(UploadLoadingState(isUploadLoading: true));
      final result = await serviceRequestUseCase.deleteDocument(presetUri);
      emit(UploadLoadingState(isUploadLoading: false));
      result.fold((l) => emit(DocumentStatusFailure(failure: l)),
              (r) => emit(DocumentStatusSuccess(fileName: r, useCase: SRConst.deleteDocument, isSecondImage: isSecondImage)));
    } catch (e) {
      emit(DocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  Future<void> getPresetUri(GetPresetUriRequest request,{required String operation, bool? isSecondImage}) async {
    try {
      emit(UploadLoadingState(isUploadLoading: true));
      final result = await serviceRequestUseCase.getPresetUri(request);
      emit(UploadLoadingState(isUploadLoading: false));
      result.fold((l) => emit(GetPresetUriResponseFailureState(failure: l)),
              (r) => emit(GetPresetUriResponseSuccessState(response: r, useCase: operation, isSecondImage: isSecondImage)));
    } catch (e) {
      emit(GetPresetUriResponseFailureState(failure: NoDataFailure()));
    }
  }

  void generateServiceRequest(SRRequest request) async {
    emit(ServiceRequestLoadingState(isLoading: true));
    try {
      final result = await serviceRequestUseCase.call(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(ServiceRequestFailureState(error: l)),
              (r) => emit(ServiceRequestSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
    }
  }

  void viewServiceRequest(ViewSRRequest request) async {
    emit(ServiceRequestLoadingState(isLoading: true));
    try {
      final result = await serviceRequestUseCase.viewServiceRequest(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(ViewServiceRequestFailureState(error: l)),
              (r) => emit(ViewServiceRequestSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(ViewServiceRequestFailureState(error: NoDataFailure()));
    }
  }

  void fetchReopenReasons() async {
    emit(ServiceRequestLoadingState(isLoading: true));
    try {
      final result = await serviceRequestUseCase.reopeningReason();
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(FetchReopenReasonsFailureState(error: l)),
              (r) => emit(FetchReopenReasonsSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(FetchReopenReasonsFailureState(error: NoDataFailure()));
    }
  }

  void reopenCase(ReopenCaseRequest request) async {
    try {
      emit(ServiceRequestLoadingState(isLoading: true));
      final result = await serviceRequestUseCase.reopenCase(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(ReopenServiceRequestFailureState(error: l)),
              (r) => emit(ReopenServiceRequestSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(ReopenServiceRequestFailureState(error: NoDataFailure()));
    }
  }
  void srDetailsByNumber(SRDetailsRequest request) async {
    try {
      emit(ServiceRequestLoadingState(isLoading: true));
      final result = await serviceRequestUseCase.srDetailsBySrNumber(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(SrDetailsFailureState(error: l)),
              (r) => emit(SrDetailsSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(SrDetailsFailureState(error: NoDataFailure()));
    }
  }

  void getDocuments(DocumentsRequest request) async {
    try {
      emit(ServiceRequestLoadingState(isLoading: true));
      final result = await productDetailsUseCase.getDocuments(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(GetDocumentsFailureState(failure: l)),
              (r) => emit(GetDocumentsSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(GetDocumentsFailureState(failure: NoDataFailure()));
    }
  }

  void getSOADocuments(DocumentsRequest request) async {
    try {
      emit(ServiceRequestLoadingState(isLoading: true));
      final result = await productDetailsUseCase.getDocuments(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(GetDocumentsFailureState(failure: l)),
              (r) => emit(SOADocumentsSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(GetDocumentsFailureState(failure: NoDataFailure()));
    }
  }

  void getRepaymentScheduleDocuments(DocumentsRequest request) async {
    try {
      emit(ServiceRequestLoadingState(isLoading: true));
      await Future.delayed(const Duration(seconds: 3));
      final result = await productDetailsUseCase.getDocuments(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(GetDocumentsFailureState(failure: l)),
              (r) => emit(RepaymentScheduleDocumentSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(GetDocumentsFailureState(failure: NoDataFailure()));
    }
  }

  void getActiveLoansDetails(ActiveLoanDetailRequest request) async {
    try {
      emit(ServiceRequestLoadingState(isLoading: true));
      final result = await productDetailsUseCase.getActiveLoansDetails(request);
      emit(ServiceRequestLoadingState(isLoading: false));
      result.fold((l) => emit(ActiveLoansDetailsFailureState(failure: l)),
              (r) => emit(ActiveLoansDetailsSuccessState(response: r)));
    } catch (e) {
      emit(ServiceRequestLoadingState(isLoading: false));
      emit(ActiveLoansDetailsFailureState(failure: NoDataFailure()));
    }
  }
}
