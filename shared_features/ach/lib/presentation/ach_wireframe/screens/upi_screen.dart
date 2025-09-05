import 'package:ach/config/ach_const.dart';
import 'package:ach/data/models/add_bank_detail_model.dart';
import 'package:ach/data/models/payer_detail_model.dart';
import 'package:ach/data/models/validate_vpa_req.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

import '../../../config/ach_util.dart';
import '../../../config/routes/route.dart';
import '../../../data/models/awaiting_vpa_model.dart';
import '../../../data/models/generate_upi_mandate_request.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/name_match_req.dart';
import '../../../data/models/update_mandate_info.dart';
import '../../../data/models/validate_vpa_resp.dart';
import '../widgets/mandate_preview_bottomsheet.dart';

class UpiScreen extends StatefulWidget {
  final LoanData loanData;
  final Bank selectedBank;
  final VerificationOption verificationMode;
  final String selectedApplicant;
  final UpdateMandateInfo updateMandateInfo;

  const UpiScreen(
      {super.key,
      required this.loanData,
      required this.selectedBank,
      required this.verificationMode,
      required this.selectedApplicant, required this.updateMandateInfo});

  @override
  State<UpiScreen> createState() => _UpiScreenState();
}

class _UpiScreenState extends State<UpiScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController upiId = TextEditingController();
  VpaData? _vpaData;
  // bool isVerified = false;
  @override
  void dispose() {
    upiId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(
          context: context,
          title: getString(lblMandateCreateMandate),
          onPressed: () {
            Navigator.pop(context);
          },
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryAuthentication)],
        ),
        body: MFGradientBackground(
          horizontalPadding: 16.h,
          verticalPadding: 14.v,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.v),
              Container(
                height: 5.v,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(3.h)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.h),
                  child: const LinearProgressIndicator(
                    value: 0.2,
                    backgroundColor: AppColors.primaryLight5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryLight3),
                  ),
                ),
              ),
              SizedBox(height: 28.v),
              Text(getString(lblUpiId), style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10.v),
              Form( key:_formKey ,child: BlocConsumer<AchCubit, AchState>(
                listener: (context, state) async {
                  if (state is ValidateVpaSuccessState) {
                    if (state.response.code == AppConst.codeSuccess) {
                      _vpaData = state.response.data;
                    } else {
                      toastForFailureMessage(
                          context: context,
                          msg: getString(msgInvalidVpa));
                    }
                  } else if (state is ValidateVpaFailureState) {
                    toastForFailureMessage(
                        context: context,
                        msg: getFailureMessage(state.failure),
                        bottomPadding: 40.v);
                  } else if (state is ValidateNameSuccessState) {
                    if (state.response.code == AppConst.codeSuccess) {
                      if(state.response.score! >= AchConst.acceptedMatchScore) {
                       bool confirm = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) =>
                                MandatePreviewBottomSheet(
                                    loanData: widget.loanData,
                                    verificationMode: widget.verificationMode,
                                    bankCode: widget.selectedBank.bankCode ?? "",
                                    bankName: widget.selectedBank.bankName ?? "",
                                    accountType: _getAccountType(_vpaData?.accountType ?? "SAVINGS"),
                                    bankAccountNumber: "",
                                    ifscCode: _vpaData?.ifsc ?? "",
                                    selectedApplicant: widget.selectedApplicant,
                                    payerName: _vpaData?.payerName ?? "",
                                    payerVpa: _vpaData?.vpa ?? "", updateMandateInfo: widget.updateMandateInfo, mandateSource: MandateSource.cams.name));
                        if(confirm) {
                          var request = GenerateUpiMandateRequest(
                              trxnno: generateRandom16DigitNumber(),
                              loanAccountNumber:
                                  widget.loanData.loanAccountNumber,
                              amount: widget.loanData.installmentAmount,
                              mandatestartdate: getCurrentDate(),
                              mandateenddate: widget.loanData.endDate,
                              payername: removeSpecialCharacters(_vpaData?.payerName ?? ""),
                              payervpa: _vpaData?.vpa,
                              pattern: AchConst.createMandatePattern,
                              revokeable: AchConst.achRevokeable,
                              authorize: AchConst.achAuthorize,
                              authorizerevoke: AchConst.achAuthorizeRevoke,
                              updateReason: widget.updateMandateInfo.mandateData!=null ? widget.updateMandateInfo.reason ?? "" : "",
                              mandateId: widget.updateMandateInfo.mandateData!=null ? widget.updateMandateInfo.mandateData?.mandateId ?? "" : "",
                              updateRequest: widget.updateMandateInfo.mandateData!=null ? true : false,
                              loanNumber: widget.loanData.loanAccountNumber,
                              sourceSystem: widget.loanData.sourceSystem,
                              productName: widget.loanData.productName ?? widget.loanData.productCategory,
                              batchNumber: widget.updateMandateInfo.mandateData!=null ? widget.updateMandateInfo.mandateData?.batchNo ?? "" : "",
                              ifsc: _vpaData?.ifsc,
                              superAppId: getSuperAppId(), source: AppConst.source);
                          context.read<AchCubit>().generateUpiMandateReq(
                              request, request.trxnno ?? "");
                        }
                      } else {
                        var vpaPayerDetail = VpaPayerDetail();
                        vpaPayerDetail.payerVpa = upiId.text;
                        vpaPayerDetail.payerName = state.payerName;
                        context.pushNamed(Routes.nameMismatchScreen.name, extra: {"loanData": widget.loanData, "selectedBank": widget.selectedBank, "selectedApplicant": widget.selectedApplicant, "verificationMode":widget.verificationMode, "bankAccountDetail":BankAccountDetail(), "vpaPayerDetail": vpaPayerDetail, "updateMandateInfo" : widget.updateMandateInfo});
                      }
                    } else {
                      var vpaPayerDetail = VpaPayerDetail();
                      vpaPayerDetail.payerVpa = upiId.text;
                      vpaPayerDetail.payerName = state.payerName;
                      context.pushNamed(Routes.nameMismatchScreen.name, extra: {"loanData": widget.loanData, "selectedBank": widget.selectedBank, "selectedApplicant": widget.selectedApplicant, "verificationMode":widget.verificationMode, "bankAccountDetail":BankAccountDetail(), "vpaPayerDetail": vpaPayerDetail, "updateMandateInfo" : widget.updateMandateInfo});
                    }
                  } else if (state is ValidateNameFailureState) {
                    toastForFailureMessage(
                        context: context,
                        msg: getFailureMessage(state.failure),
                        bottomPadding: 40.v);
                  } else if (state is LoadingDialogState) {
                    if (state.isloading) {
                      showLoaderDialog(context, getString(lblMandateLoading));
                    } else {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  } if (state is GenerateUpiMandateReqSuccessState) {
                    if(state.response.code==AppConst.codeSuccess) {
                      if(context.mounted){
                        if(state.response.aggregatorResponse?.status == VPAStatus.pending.status) {
                          var awaitingVPAModel = AwaitingVPAModel(
                              refNo: state.response.aggregatorResponse?.mandateRefNo,
                              trxnNo: state.trxnNo,
                              loanData: widget.loanData,
                              bankName: widget.selectedBank.bankName,
                              bankCode:  widget.selectedBank.bankCode,
                              bankAccountNumber: "",
                              selectedApplicant: widget.selectedApplicant,
                              verificationMode: widget.verificationMode,
                              accountType: _getAccountType(_vpaData?.accountType ?? "SAVINGS"), vpaData: _vpaData);
                          context.pushNamed(Routes.awaitingUpi.name,
                              extra: {"awaitingVPAModel": awaitingVPAModel, "updateMandateInfo" : widget.updateMandateInfo});
                        } else {
                          toastForFailureMessage(context: context, msg: state.response.aggregatorResponse?.errDesc ?? "");
                        }
                      }
                    } else {
                      if(context.mounted){
                        toastForFailureMessage(
                            context: context,
                            msg: getString(msgVpaAuthFailed) );
                      }
                    }
                  } else if(state is GenerateMandateReqFailureState){
                    if(context.mounted){
                      toastForFailureMessage(
                          context: context,
                          msg: getString(msgVpaAuthFailed) );
                    }
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<AchCubit, AchState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          MfCustomFloatingTextField(
                            suffix: (state is ValidateVpaSuccessState && state.response.code == AppConst.codeSuccess)
                                ? const Icon(
                              Icons.check_circle,
                              size: 30,
                              color: Color(0xFF238823),
                            )
                                : null,
                            width: 328.h,
                            labelText: getString(lblVpa),
                            borderDecoration: UnderlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.secondaryLight5,
                                ),
                                width: 1,
                              ),
                            ),
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.secondaryLight5,
                                )),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.secondaryLight5,
                                )),
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.text,
                            controller: upiId,
                            validator: (value) {
                              if (value!.isEmpty || !validateUPI(value)) {
                                return getString(msgEnterVpa);
                              }
                              return null;
                            }
                            // controller: textFieldController2,
                          ),
                          SizedBox(height: 10.v),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      context.read<AchCubit>().validateVpa(
                                          ValidateVpaReq(vpa: upiId.text, superAppId: getSuperAppId(), source: AppConst.source));
                                    }
                                  },
                                  child: Text(getString(lblMandateVerify),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            )
                        ],
                      );
                    },
                  );
                },
              )),
            ],
          ),
        ),
        floatingActionButton: BlocBuilder<AchCubit, AchState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomElevatedButton(
                text: getString(lblMandateContinue),
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: (state is ValidateVpaSuccessState)
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    )),
                buttonTextStyle: (state is ValidateVpaSuccessState)
                    ? Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.white)
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).unselectedWidgetColor),
                onPressed: () {
                  if (state is ValidateVpaSuccessState) {
                    if (state.response.code == AppConst.codeSuccess) {
                      var nameMatchReq = NameMatchReq(
                          beneName: state.response.data?.payerName ?? "",
                          custName: widget.selectedApplicant.split("#&#")[1],
                          superAppId: getSuperAppId(), source: AppConst.source);
                      context.read<AchCubit>().validateName(nameMatchReq);
                    } else {
                      toastForFailureMessage(
                          context: context,
                          msg: state.response.message ?? "",
                          bottomPadding: 40.v);
                    }
                  }
                },
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

AccountType _getAccountType(String accountType) {
  if (accountType == AccountType.savingAccount.tag) {
    return AccountType.savingAccount;
  } else if (accountType == AccountType.currentAccount.tag) {
    return AccountType.currentAccount;
  } else {
    return AccountType.savingAccount;
  }
}
