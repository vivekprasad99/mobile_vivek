import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:meta/meta.dart';
import 'package:service_request/features/bureau/config/bureau_const.dart';
import 'package:service_request/features/bureau/config/bureau_utils.dart';
import 'package:service_request/features/bureau/data/models/bureau_response.dart';
import 'package:service_request/features/bureau/data/models/dedupe_request.dart';
import 'package:service_request/features/bureau/data/models/dedupe_response.dart';
import 'package:service_request/features/bureau/data/models/generate_sr_resp.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_request.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_response.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_request.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_response.dart';
import 'package:service_request/features/bureau/data/models/reason_response.dart';
import '../../domain/usecases/bureau_usecases.dart';
part 'bureau_state.dart';

class BureauCubit extends Cubit<BureauState> {
  BureauCubit({required this.bureauUseCase}) : super(BureauInitial());
  final BureauUseCase bureauUseCase;
  final Set<Bureau> selectedBureaus = {};

  getBureaus() async {
    emit(BureauLoadingState(isLoadingBureaus: true));
    try {
      final result = await bureauUseCase.call(NoParams());
      emit(BureauLoadingState(isLoadingBureaus: false));
      result.fold((l) => emit(BureauFailureState(error: l)),
          (r) => emit(BureauSuccessState(response: r)));
    } catch (e) {
      emit(BureauLoadingState(isLoadingBureaus: false));
      emit(BureauFailureState(error: NoDataFailure()));
    }
  }

  void getLoans(GetLoansRequest request) async {
    emit(BureauLoadingState(isLoadingBureaus: true));
    try {
      final result = await bureauUseCase.getLoan(request);
      emit(BureauLoadingState(isLoadingBureaus: false));
      result.fold((l) => emit(GetLoansFailureState(failure: l)),
          (r) => emit(GetLoansSuccessState(response: r)));
    } catch (e) {
      emit(BureauLoadingState(isLoadingBureaus: false));
      emit(BureauFailureState(error: NoDataFailure()));
    }
  }

  void getReason() async {
    emit(BureauLoadingState(isLoadingBureaus: true));
    try {
      final result = await bureauUseCase.getReason();
      emit(BureauLoadingState(isLoadingBureaus: false));
      result.fold((l) => emit(ReasonFailureState(error: l)),
          (r) => emit(ReasonSuccessState(response: r)));
    } catch (e) {
      emit(BureauLoadingState(isLoadingBureaus: false));
      emit(BureauFailureState(error: NoDataFailure()));
    }
  }

  Set<Bureau> getSelectedBureaus() {
    return selectedBureaus;
  }

  void proceedButtonVisibility(
      List<Bureau> bureauData, String isReasonSelect, String isProductSelect) {
    bool isBureauSelect = selectedBureaus.any((element) => element.isSelected);
    bool isButtonDisable = !(isBureauSelect &&
        isReasonSelect.isNotEmpty &&
        isProductSelect.isNotEmpty);

    emit(ButtonEnableState(isButtonDisable: isButtonDisable));
  }

  void selectFileName(String fileName) {
    emit(BureauSelectFileNameState(fileName: fileName));
  }

  void imageAdded(
      bool imageAdded, String imageName, int index, bool imagePayment) {
    if (imagePayment) {
      emit(BureauDocumentUploadState(
        imageAdded: imageAdded,
        imageName: imageName,
        index: index,
        imagePayment: true,
      ));
    } else {
      emit(BureauDocumentUploadState(
        imageAdded: imageAdded,
        imageName: imageName,
        index: index,
        imagePayment: false,
      ));
    }
  }

  void compressImage(XFile? sourceFile, bool isPayment, int index) async {
    try {
      emit(BureauUploadLoadingState(isUploadLoading: true));
      var renameFile = await pickAndRenameImage(sourceFile!, "Bureau");
      final bytes = await renameFile.length();
      final kb = bytes / 1024;
      final fileSizeInMB = kb / 1024;

      if (fileSizeInMB < AppConst.maxFileSizeInMB) {
        String? fileMimeType = getFileExtension(renameFile.path);

        if (AppConst.supportedFileTypes.contains(fileMimeType)) {
          emit(BureauUploadLoadingState(isUploadLoading: false));
          if (isPayment) {
            emit(BureauImageCompressForPaymentState(
              imageFile: renameFile,
              compressSuccess: true,
              errorMessage: "",
              index: index,
            ));
          } else {
            emit(BureauImageCompressForCreditState(
              imageFile: renameFile,
              compressSuccess: true,
              errorMessage: "",
              index: index,
            ));
          }
        } else {
          File? outPathFile = await getCompressedFile(renameFile);
          emit(BureauUploadLoadingState(isUploadLoading: false));
          if (isPayment) {
            emit(BureauImageCompressForPaymentState(
              imageFile: outPathFile,
              compressSuccess: true,
              errorMessage: "",
              index: index,
            ));
          } else {
            emit(BureauImageCompressForCreditState(
              imageFile: outPathFile,
              compressSuccess: true,
              errorMessage: "",
              index: index,
            ));
          }
        }
      } else {
        emit(BureauUploadLoadingState(isUploadLoading: false));
        if (isPayment) {
          emit(BureauImageCompressForPaymentState(
            imageFile: renameFile,
            compressSuccess: false,
            errorMessage: getString(msgMaxFileSizeError),
            index: index,
          ));
        } else {
          emit(BureauImageCompressForCreditState(
            imageFile: renameFile,
            compressSuccess: false,
            errorMessage: getString(msgMaxFileSizeError),
            index: index,
          ));
        }
      }
    } catch (e) {
      emit(BureauUploadLoadingState(isUploadLoading: false));
      if (isPayment) {
        emit(BureauImageCompressForPaymentState(
          imageFile: File(sourceFile?.path ?? ""),
          compressSuccess: false,
          errorMessage: getString(msgFilePickError),
          index: index,
        ));
      } else {
        emit(BureauImageCompressForCreditState(
          imageFile: File(sourceFile?.path ?? ""),
          compressSuccess: false,
          errorMessage: getString(msgFilePickError),
          index: index,
        ));
      }
    }
  }

  Future<File?> getCompressedFile(File? file) async {
    final filePath = file?.path;
    final lastIndex = filePath?.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath?.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath?.substring(lastIndex ?? 0)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file!.path,
      outPath,
      quality: 50,
    );
    return File(result!.path);
  }

  Future<void> getPresetUri(
      GetPresetUriRequest request, int index, bool isPayment,
      {required String operation}) async {
    try {
      emit(BureauUploadLoadingState(isUploadLoading: true));
      final result = await bureauUseCase.getPresetUri(request);
      emit(BureauUploadLoadingState(isUploadLoading: false));
      result.fold(
        (l) => emit(BureauGetPresetUriResponseFailureState(failure: l)),
        (r) => emit(BureauGetPresetUriResponseSuccessState(
            response: r, useCase: operation, isPayment: isPayment)),
      );
    } catch (e) {
      emit(BureauGetPresetUriResponseFailureState(failure: NoDataFailure()));
    }
  }

  Future<void> uploadDocument(
      String presetUri, File file, int index, bool isPayment) async {
    try {
      emit(BureauUploadLoadingState(isUploadLoading: true));
      final result = await bureauUseCase.uploadDocument(presetUri, file);
      emit(BureauUploadLoadingState(isUploadLoading: false));
      result.fold(
        (l) => emit(BureauDocumentStatusFailure(failure: l)),
        (r) => emit(BureauDocumentStatusSuccess(
          fileName: r,
          useCase: BureauConst.deleteDocument,
          isPayment: isPayment,
          index: index,
        )),
      );
    } catch (e) {
      emit(BureauDocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  Future<void> deleteDocuments(
      String presetUri, int index, bool isPayment) async {
    try {
      emit(BureauUploadLoadingState(isUploadLoading: true));
      final result = await bureauUseCase.deleteDocument(presetUri);
      emit(BureauUploadLoadingState(isUploadLoading: false));
      result.fold(
        (l) => emit(BureauDocumentStatusFailure(failure: l)),
        (r) => emit(BureauDocumentStatusSuccess(
          fileName: r,
          useCase: BureauConst.deleteDocument,
          isPayment: isPayment,
          index: index,
        )),
      );
    } catch (e) {
      emit(BureauDocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  void getDedupeCheck(DedupeRequest request) async {
    emit(BureauLoadingState(isLoadingBureaus: true));
    try {
      final result = await bureauUseCase.getDedupeCheck(request);
      emit(BureauLoadingState(isLoadingBureaus: false));
      result.fold((l) => emit(DedupeFailureState(failure: l)),
          (r) => emit(DedupeSuccessState(response: r)));
    } catch (e) {
      emit(BureauLoadingState(isLoadingBureaus: false));
      emit(DedupeFailureState(failure: NoDataFailure()));
    }
  }

  void getLoanPayment(PaymentRequest request) async {
    emit(BureauLoadingState(isLoadingPaymentLastDate: true));
    try {
      final result = await bureauUseCase.getLoanPayment(request);
      emit(BureauLoadingState(isLoadingPaymentLastDate: false));
      result.fold((l) => emit(GetPaymentFailureState(failure: l)),
          (r) => emit(GetPaymentSuccessState(response: r)));
    } catch (e) {
      emit(BureauLoadingState(isLoadingPaymentLastDate: false));
      emit(GetPaymentFailureState(failure: NoDataFailure()));
    }
  }

  void initialize(List<String> paymentListString) {
    if (paymentListString.isNotEmpty) {
      emit(PaymentUpdatedList(paymentListString, true));
    } else {
      emit(PaymentUpdatedList(const [''], true));
    }
  }

  void initializeCredit(List<String> creditListString) {
    if (creditListString.isNotEmpty) {
      emit(CreditUpdatedList(creditListString, true));
    } else {
      emit(CreditUpdatedList(const [''], true));
    }
  }

  void addMore(List<String> paymentListString, bool canAddMore) {
    final updatedList = [...paymentListString];
    if (updatedList.length < 4) {
      updatedList.add(''); // Adding a new empty string
      emit(PaymentUpdatedList(updatedList, updatedList.length < 4));
    }
  }

  void addCreditMore(List<String> creditListString, bool canAddMore) {
    final updatedCreditList = [...creditListString];
    if (updatedCreditList.length < 4) {
      updatedCreditList.add(''); // Adding a new empty string
      emit(CreditUpdatedList(updatedCreditList, updatedCreditList.length < 4));
    }
  }

  void toggleSelection(List<Bureau> bureau, int ind) {
    List<Bureau> updatedBureaus = List.from(
        bureau); // Create a new list to avoid mutating the original list
    if (ind != -1) {
      Bureau selectedBureau = Bureau(
        id: bureau[ind].id,
        name: bureau[ind].name,
        isSelected: !bureau[ind].isSelected,
      );

      updatedBureaus[ind] = selectedBureau;

      if (selectedBureau.isSelected) {
        selectedBureaus.add(selectedBureau);
      } else {
        selectedBureaus.removeWhere((b) => b.id == selectedBureau.id);
      }

      emit(BureauSuccessState(
        response: BureauResponse(
          status: "Success",
          message: "",
          data: updatedBureaus,
        ),
      ));
    }
  }

  void isLoanNotReflect(String isShow) {
    emit(EmptyRateUsState());

    if (isShow == "3") {
      emit(IsShowLoanNotReflect(isShow));
    } else {
      emit(IsShowLoanNotReflect(isShow));
    }
  }
}
