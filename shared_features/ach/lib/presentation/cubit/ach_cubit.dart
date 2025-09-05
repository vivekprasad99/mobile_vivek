import 'dart:io';

import 'package:ach/config/ach_const.dart';
import 'package:ach/data/models/check_vpa_status_req.dart';
import 'package:ach/data/models/check_vpa_status_res.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/fetch_applicant_name_res.dart';
import 'package:ach/data/models/generate_upi_mandate_request.dart';
import 'package:ach/data/models/get_preset_uri_request.dart';
import 'package:ach/data/models/name_match_req.dart';
import 'package:ach/data/models/name_match_resp.dart';
import 'package:ach/data/models/nupay_status_req.dart';
import 'package:ach/data/models/nupay_status_res.dart';
import 'package:ach/data/models/popular_bank_list_res.dart';
import 'package:ach/data/models/validate_vpa_req.dart';
import 'package:ach/data/models/validate_vpa_resp.dart';
import 'package:bloc/bloc.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../config/ach_util.dart';
import '../../data/models/camps_output_req.dart';
import '../../data/models/camps_output_res.dart';
import '../../data/models/fetch_bank_accoun_response.dart';
import '../../data/models/fetch_bank_account_req.dart';
import '../../data/models/generate_mandate_request.dart';
import '../../data/models/generate_mandate_response.dart';
import '../../data/models/generate_upi_mandate_response.dart';
import '../../data/models/get_ach_loans_request.dart';
import '../../data/models/get_ach_loans_response.dart';
import '../../data/models/get_bank_list_resp.dart' as new_banks;
import '../../data/models/get_bank_list_resp.dart';
import '../../data/models/get_cancel_mandate_response.dart';
import '../../data/models/get_cms_bank_list_resp.dart';
import '../../data/models/get_mandate_req.dart';
import '../../data/models/get_mandate_res.dart';
import '../../data/models/get_preset_uri_response.dart';
import '../../data/models/penny_drop_req.dart';
import '../../data/models/penny_drop_resp.dart';
import '../../data/models/update_mandate_reason_resp.dart';
import '../../domain/usecases/ach_usecase.dart';

part 'ach_state.dart';

class AchCubit extends Cubit<AchState> {
  AchCubit({required this.usecase}) : super(AchInitial());
  final AchUsecase usecase;
  void getLoansList(GetAchLoansRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.call(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetLoansListFailureState(failure: l)),
          (r) => emit(GetLoansListSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetLoansListFailureState(failure: NoDataFailure()));
    }
  }

  void fetchBankAccount(FetchBankAccountRequest request, LoanData? loanItem) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.fetchBankAccount(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(FetchBankAccountFailureState(failure: l)),
          (r) => emit(FetchBankAccountSuccessState(response: r, loanItem: loanItem)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(FetchBankAccountFailureState(failure: NoDataFailure()));
    }
  }

  void getBankList() async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getBankList();
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetBankListFailureState(failure: l)),
          (r) => emit(GetBankListSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetBankListFailureState(failure: NoDataFailure()));
    }
  }

  void getCMSBankList() async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getCMSBankList();
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetCMSBankListFailureState(failure: l)),
              (r) => emit(GetCMSBankListSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetCMSBankListFailureState(failure: NoDataFailure()));
    }
  }

  void getPopularBankList(List<CMSBank>? banks) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      List<PopularBank>? popularBanks = [];
      if(banks?.isNotEmpty == true){
        for (var bank in banks!) {
          popularBanks.add(PopularBank(bankId: bank.bankId, bankName: bank.bankName, isPopular: bank.isPopular, bankCode: bank.bankCode));
        }
      }
      emit(LoadingState(isloading: false));
      emit(GetPopularBankListSuccessState(response: popularBanks));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetPopularBankListFailureState(failure: NoDataFailure()));
    }
  }

  void getVerificationOption(BankData bankData,  List<CMSBank>? masterBankData) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getBankList();
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetBankListFailureState(failure: l)),
              (r) => emit(_handleVerificationOption(bankData, r, masterBankData)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetBankListFailureState(failure: NoDataFailure()));
    }
  }

  _handleVerificationOption(BankData bankData, new_banks.GetBankListResponse response, List<CMSBank>? masterBankData){
    if(response.data!=null && response.data?.banks!.isNotEmpty == true){
      List<new_banks.Bank>? outputList = response.data?.banks?.where((o) => (o.bankCode == bankData.bankCode || o.bankId?.toString() == bankData.bankCode || o.bankName?.toString() == bankData.bankName)).toList();
      var bankList = filterBank(outputList!, masterBankData!);
      if(bankList.isNotEmpty) {
        emit(LoadingState(isloading: false));
        emit(GetBankListSuccessState(response: response));
        emit(FilterBankList(bank: bankList[0]));
      } else {
        emit(LoadingState(isloading: false));
        emit(GetBankListFailureState(failure: NoDataFailure()));
      }
    }
  }

  List<Bank> filterBank(List<Bank> bankList, List<CMSBank> cmsbankList) {
    for (int i = 0; i < bankList.length; i++) {
      Bank bank = bankList[i];
      CMSBank? cmsBank = cmsbankList
          .where((element) => (element.bankCode == bank.bankCode ||
              element.bankId?.toString() == bank.bankCode ||
              element.bankName?.toString() == bank.bankName))
          .firstOrNull;
      if (cmsBank != null) {
        CMSVerificationOption? cmsVerificationOptionForAadhaar = cmsBank.verificationOption
            ?.where((element) => (element.optionId == VerificationMode.aadhaar.value))
            .firstOrNull;
        if (cmsVerificationOptionForAadhaar != null) {
          VerificationOption verificationOption = VerificationOption(
              optionId: cmsVerificationOptionForAadhaar.optionId,
              optionName: cmsVerificationOptionForAadhaar.optionName,
              isRecommended: cmsVerificationOptionForAadhaar.isRecommended);
          if (bankList[i].verificationOption?.contains(verificationOption) == false) {
            bankList[i].verificationOption?.add(verificationOption);
          }
        }
        CMSVerificationOption? cmsVerificationOptionForUpi = cmsBank.verificationOption
            ?.where((element) => (element.optionId == VerificationMode.upi.value))
            .firstOrNull;
        if (cmsVerificationOptionForUpi != null) {
          VerificationOption verificationOption = VerificationOption(
              optionId: cmsVerificationOptionForUpi.optionId,
              optionName: cmsVerificationOptionForUpi.optionName,
              isRecommended: cmsVerificationOptionForUpi.isRecommended);
          if (bankList[i].verificationOption?.contains(verificationOption) == false) {
            bankList[i].verificationOption?.add(verificationOption);
          }
        }
      }
    }
    return bankList;
  }

  List<Bank> filterPopularBank(List<Bank> bankList, List<PopularBank> popularBankList){
    for (int i = 0; i < bankList.length; i++) {
      Bank bank = bankList[i];
      PopularBank? popularBank =popularBankList.where((element) => (element.bankCode == bank.bankCode)).firstOrNull;
      if(popularBank != null){
        bankList[i].isPopular = popularBank.isPopular;
      }
    }
    return bankList;
  }

  void getMandates(GetMandateRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getMandates(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetMandatesFailureState(failure: l)),
          (r) => emit(GetMandatesSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetMandatesFailureState(failure: NoDataFailure()));
    }
  }

  void pennyDrop(PennyDropReq request) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.pennyDrop(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(PennyDropFailureState(failure: l)),
          (r) => emit(PennyDropSuccessState(response: r)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(PennyDropFailureState(failure: NoDataFailure()));
    }
  }

  void validateName(NameMatchReq request) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.validateName(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(ValidateNameFailureState(failure: l)),
              (r) => emit(ValidateNameSuccessState(response: r, payerName: request.beneName ?? "")));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(ValidateNameFailureState(failure: NoDataFailure()));
    }
  }

  void generateMandateReq(GenerateMandateRequest request) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.generateMandateReq(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(GenerateMandateReqFailureState(failure: l)),
          (r) => emit(GenerateMandateReqSuccessState(response: r)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(GenerateMandateReqFailureState(failure: NoDataFailure()));
    }
  }

  void generateUpiMandateReq(GenerateUpiMandateRequest request, String trxnNo) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.generateUpiMandateReq(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(GenerateUpiMandateReqFailureState(failure: l)),
              (r) => emit(GenerateUpiMandateReqSuccessState(response: r, trxnNo: trxnNo)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(GenerateUpiMandateReqFailureState(failure: NoDataFailure()));
    }
  }

  void getCancelMandateReason() async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getCancelMandateReason();
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetCancelMandateReasonFailureState(failure: l)),
          (r) => emit(GetCancelMandateReasonSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetCancelMandateReasonFailureState(failure: NoDataFailure()));
    }
  }

  Future<void> getPresetUri(GetPresetUriRequest request,{required String operation}) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getPresetUri(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetPresetUriResponseFailureState(failure: l)),
          (r) => emit(GetPresetUriResponseSuccessState(response: r, useCase: operation)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetPresetUriResponseFailureState(failure: NoDataFailure()));
    }
  }


  Future<void> uploadDocument(String presetUri,File file) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.uploadDocument(presetUri, file);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(DocumentStatusFailure(failure: l)),
              (r) => emit(DocumentStatusSuccess(fileName: r, useCase: AchConst.deleteDocument)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(DocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  Future<void> deleteDocuments(String presetUri) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.deleteDocument(presetUri);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(DocumentStatusFailure(failure: l)),
              (r) => emit(DocumentStatusSuccess(fileName: r, useCase: AchConst.deleteDocument)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(DocumentStatusFailure(failure: NoDataFailure()));
    }
  }

  void getUpdateMandateReason() async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getUpdateMandateReason();
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetUpdateMandeReasonFailureState(failure: l)),
          (r) => emit(GetUpdateMandeReasonSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetUpdateMandeReasonFailureState(failure: NoDataFailure()));
    }
  }

  void selectBank(BankData? bank) {
    emit(SelectBankState(bank: bank));
  }

  void selectNewBank(new_banks.Bank? bank) {
    emit(SelectNewBankState(bank: bank));
  }

  void selectCancelReason(
      CancelReason cancelReason) {
    emit(SelectCancelReasonState(
        reasonResponse: cancelReason));
  }

  void selectUpdateReason(
      UpdateMandateReason updateMandateReason) {
    emit(SelectUpdateReasonState(
        reasonResponse: updateMandateReason));
  }

  void selectNewBankVerifyOption(new_banks.VerificationOption? option, new_banks.Bank? bank) {
    emit(SelectNewBankVerificationOtpionState(option: option, bank: bank));
  }

  void setLoanItem(LoanData? loanItem) {
    emit(SelectedLoanItemState(loanItem: loanItem));
  }

  void validateVpa(ValidateVpaReq request) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.validateVpa(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(ValidateVpaFailureState(failure: l)),
          (r) => emit(ValidateVpaSuccessState(response: r)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(ValidateVpaFailureState(failure: NoDataFailure()));
    }
  }

  void fetchApplicantName(FetchApplicantNameReq request, LoanData? loanData) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.fetchApplicantName(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(FetchApplicantNameFailureState(failure: l)),
              (r) => emit(FetchApplicantNameSuccessState(response: r, loanData: loanData)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(FetchApplicantNameFailureState(failure: NoDataFailure()));
    }
  }

  void checkVpaStatus(CheckVpaStatusReq request) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.checkVpaStatus(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(CheckVpaStatusFailureState(failure: l)),
              (r) => emit(CheckVpaStatusSuccessState(response: r)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(CheckVpaStatusFailureState(failure: NoDataFailure()));
    }
  }

  void decryptCampsOutput(CampsOutputReq request) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.decryptCampsOutput(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(DecryptCampsOutputFailureState(failure: l)),
              (r) => emit(DecryptCampsOutputSuccessState(response: r)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(DecryptCampsOutputFailureState(failure: NoDataFailure()));
    }
  }

  void getNupayStatusById(NupayStatusReq request) async {
    try {
      emit(LoadingDialogState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await usecase.getNupayStatusById(request);
      emit(LoadingDialogState(isloading: false));
      result.fold((l) => emit(NupayStatusByIdFailureState(failure: l)),
              (r) => emit(NupayStatusByIdSuccessState(response: r)));
    } catch (e) {
      emit(LoadingDialogState(isloading: false));
      emit(NupayStatusByIdFailureState(failure: NoDataFailure()));
    }
  }

  void selectApplicant(String? applicantName) {
    emit(SelectedApplicant(applicant: applicantName));
  }

  void imageAdded(bool imageAdded,String imageName) {
    emit(DocumentUploadState(imageAdded: imageAdded, imageName: imageName));
  }

  void compressImage(XFile? sourceFile) async{
    try {
      emit(LoadingState(isloading: true));
      var renameFile = await pickAndRenameImage(sourceFile!,"CreateMandate");
      final fileSizeInMB = await calculateFileSize(renameFile.path);
      if (fileSizeInMB < AppConst.maxFileSizeInMB) {
        String? fileMimeType = getFileExtension(renameFile.path);
        if (AppConst.supportedFileTypes.contains(fileMimeType)) {
          emit(LoadingState(isloading: false));
          emit(ImageCompressState(
              imageFile: renameFile, compressSuccess: true, errorMessage: ""));
        } else {
          emit(ImageCompressState(
              imageFile: renameFile, compressSuccess: true, errorMessage: ""));
          emit(LoadingState(isloading: false));
        }
      } else {
        emit(LoadingState(isloading: false));
        emit(ImageCompressState(imageFile: renameFile, compressSuccess: false,errorMessage: getString(msgMaxFileSizeError)));
      }
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(ImageCompressState(imageFile: File(sourceFile?.path ?? ""), compressSuccess: false,errorMessage: getString(msgFilePickError)));
    }
  }

  Future<File?> getCompressedFile(File? file) async {
    final filePath = file?.path;
    final lastIndex = filePath?.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath?.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath?.substring(lastIndex??0)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file!.path, outPath,
      quality: 95,
    );
    return File(result!.path);
  }

  int getMandateStatus(String mandateStatus, String nocStatus) {
    if(mandateStatus == "N" && nocStatus == "NA"){
      return MandateStatus.createMandate.value;
    } else if(mandateStatus == "Y" && nocStatus == "No"){
      return MandateStatus.updateMandate.value;
    } else if(mandateStatus == "Y" && nocStatus == "Yes"){
      return MandateStatus.updateMandate.value;
    }
    return MandateStatus.createMandate.value;
  }

}
