import 'package:ach/config/ach_const.dart';
import 'package:ach/config/ach_util.dart';
import 'package:ach/config/routes/route.dart';
import 'package:ach/data/models/check_vpa_status_res.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_webview/config/routes/route.dart' as payment_web_view;
import 'package:payment_webview/data/models/payment_model.dart';

import '../../../config/source.dart';
import '../../../data/models/generate_mandate_request.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/madate_res_model.dart';
import '../../../data/models/update_mandate_info.dart';
import '../../cubit/ach_cubit.dart';
import 'package:webview_flutter_platform_interface/src/types/navigation_decision.dart';

class MandatePreviewBottomSheet extends StatefulWidget {
  final LoanData loanData;
  final String bankCode;
  final String bankName;
  final VerificationOption verificationMode;
  final String ifscCode;
  final String bankAccountNumber;
  final AccountType? accountType;
  final String selectedApplicant;
  final String payerName;
  final String payerVpa;
  final UpdateMandateInfo updateMandateInfo;
  final Source? source;
  final String mandateSource;

  const MandatePreviewBottomSheet(
      {super.key,
      required this.loanData,
      required this.bankCode,
      required this.bankName,
      required this.verificationMode,
      required this.ifscCode,
      required this.bankAccountNumber,
      required this.accountType,
      required this.selectedApplicant,
      required this.payerName,
      required this.payerVpa,
      required this.updateMandateInfo,
      required this.mandateSource,
      this.source});

  @override
  State<MandatePreviewBottomSheet> createState() =>
      _MandatePreviewBottomSheetState();
}

class _MandatePreviewBottomSheetState extends State<MandatePreviewBottomSheet> {
  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return BlocProvider<AchCubit>(
      create: (context) => di<AchCubit>(),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(28.h),
                  topLeft: Radius.circular(28.h)),
              // borderRadius: BorderRadius.circular(
              //   28.h,
              // ),
              color: Theme.of(context).cardColor),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.v),
                Text(
                  getString(lblMandatePreview),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20.v),
                _buildAccountData(context,
                    name: getString(lblMandateName),
                    value: widget.selectedApplicant.split("#&#")[1]),
                SizedBox(height: 10.v),
                _buildAccountData(
                  context,
                  name: getString(msgMandateLoanAccountNumber2),
                  value: widget.loanData.loanAccountNumber ?? "",
                ),
                SizedBox(height: 10.v),
                _buildAccountData(
                  context,
                  name: getString(lblMandateAmount),
                  value: "₹${widget.loanData.installmentAmount}",
                ),
                SizedBox(height: 10.v),
                _buildAccountData(
                  context,
                  name: getString(msgMandateFrequency),
                  value: AchConst.mandateFrequency,
                ),
                SizedBox(height: 10.v),
                _buildAccountData(
                  context,
                  name: getString(msgVerificationMethod),
                  value: getVerificationModeShortCode(
                          widget.verificationMode.optionId ?? "")
                      .label,
                ),
                SizedBox(height: 10.v),
                _buildAccountData(
                  context,
                  name: getString(lblBankName),
                  value: widget.bankName,
                ),
                SizedBox(height: 10.v),
                _buildAccountData(
                  context,
                  name: getVerificationModeShortCode(
                                  widget.verificationMode.optionId ?? "")
                              .shortCode ==
                          VerificationMode.upi.shortCode
                      ? getString(msgVpaNumber)
                      : getString(msgMandateBankAccountNumber),
                  value: getVerificationModeShortCode(
                                  widget.verificationMode.optionId ?? "")
                              .shortCode ==
                          VerificationMode.upi.shortCode
                      ? widget.payerVpa
                      : formatAccountNumber(widget.bankAccountNumber),
                ),
                Visibility(
                  visible: getVerificationModeShortCode(
                              widget.verificationMode.optionId ?? "")
                          .shortCode !=
                      VerificationMode.upi.shortCode,
                  child: SizedBox(height: 10.v),
                ),
                Visibility(
                    visible: getVerificationModeShortCode(
                                widget.verificationMode.optionId ?? "")
                            .shortCode !=
                        VerificationMode.upi.shortCode,
                    child: _buildAccountData(
                      context,
                      name: getString(lblIfscCode),
                      value: widget.ifscCode,
                    )),
                SizedBox(height: 30.v),
                _buildBack(context),
                SizedBox(
                  height: 20.v,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocConsumer<AchCubit, AchState>(
          listener: (buildContext, state) async {
            if (state is GenerateMandateReqSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                String source =
                    state.response.aggregatorResponse?.source ?? "Cams";
                String responseUrl =
                    state.response.aggregatorResponse?.responseUrl ?? "";
                String redirectUrl =
                    state.response.aggregatorResponse?.redirectUrl ?? "";
                String baseUrl = state.response.aggregatorResponse?.url ?? "";
                WeviewModel model = WeviewModel(
                  baseUrl: baseUrl,
                  responseUrl: responseUrl,
                  redirectUrl: redirectUrl,
                  showAppBar: false,
                  appBarTitle: null,
                  onNavigationRequest: (request) {
                    final uri = request.url;
                    if (source == MandateSourceType.cams.label) {
                      if (uri.toString().contains(redirectUrl) ||
                          uri.toString().contains(responseUrl)) {
                        String? campsOutput =
                            Uri.parse(uri).queryParameters["output"];
                        var mandateSource = MandateResponseModel(
                            mandateSource: source, mandateOutput: campsOutput);
                        context.pushReplacementNamed(
                            Routes.mandateSuccessScreen.name,
                            extra: {
                              "loanData": widget.loanData,
                              "bankName": widget.bankName,
                              "verificationMode": widget.verificationMode,
                              "selectedApplicant": widget.selectedApplicant,
                              "accountNumber": widget.bankAccountNumber,
                              "vpaStatus": VpaStatus(),
                              "mandateResponse": mandateSource,
                              "updateMandateInfo": widget.updateMandateInfo
                            });
                        return NavigationDecision.prevent;
                      } else {
                        return NavigationDecision.navigate;
                      }
                    } else {
                      if (uri.toString().contains(redirectUrl)) {
                        String? nupayResponse =
                            Uri.parse(uri).queryParameters["uniq_id"];
                        nupayResponse ??=
                            Uri.parse(uri).queryParameters["status"];
                        var mandateSource = MandateResponseModel(
                            mandateSource: source,
                            mandateOutput: nupayResponse,
                            mandateFailedMessage:
                                nupayResponse == NupayStatus.failed.status
                                    ? Uri.parse(uri).queryParameters["msg"]
                                    : "");
                        context.pushReplacementNamed(
                            Routes.mandateSuccessScreen.name,
                            extra: {
                              "loanData": widget.loanData,
                              "bankName": widget.bankName,
                              "verificationMode": widget.verificationMode,
                              "selectedApplicant": widget.selectedApplicant,
                              "accountNumber": widget.bankAccountNumber,
                              "vpaStatus": VpaStatus(),
                              "mandateResponse": mandateSource,
                              "updateMandateInfo": widget.updateMandateInfo
                            });
                        return NavigationDecision.prevent;
                      } else {
                        return NavigationDecision.navigate;
                      }
                    }
                  },
                  // onOverrideUrlLoading:
                  //     (inAppWebViewController, navigationAction) {
                  // final uri = navigationAction.request.url!;
                  // if (source == MandateSourceType.cams.label) {
                  //   if (uri.toString().contains(redirectUrl) || uri.toString().contains(responseUrl)) {
                  //     String? campsOutput = uri.queryParameters["output"];
                  //     var mandateSource = MandateResponseModel(
                  //         mandateSource: source, mandateOutput: campsOutput);
                  //     context.pushReplacementNamed(
                  //         Routes.mandateSuccessScreen.name,
                  //         extra: {
                  //           "loanData": widget.loanData,
                  //           "bankName": widget.bankName,
                  //           "verificationMode": widget.verificationMode,
                  //           "selectedApplicant": widget.selectedApplicant,
                  //           "accountNumber": widget.bankAccountNumber,
                  //           "vpaStatus": VpaStatus(),
                  //           "mandateResponse": mandateSource,
                  //           "updateMandateInfo": widget.updateMandateInfo
                  //         });
                  //     return NavigationActionPolicy.CANCEL;
                  //   } else {
                  //     return NavigationActionPolicy.ALLOW;
                  //   }
                  // } else {
                  //   if (uri.toString().contains(redirectUrl)) {
                  //     String? nupayResponse =
                  //         uri.queryParameters["uniq_id"];
                  //     nupayResponse ??= uri.queryParameters["status"];
                  //     var mandateSource = MandateResponseModel(
                  //         mandateSource: source,
                  //         mandateOutput: nupayResponse,mandateFailedMessage: nupayResponse==NupayStatus.failed.status ? uri.queryParameters["msg"]:""  );
                  //     context.pushReplacementNamed(
                  //         Routes.mandateSuccessScreen.name,
                  //         extra: {
                  //           "loanData": widget.loanData,
                  //           "bankName": widget.bankName,
                  //           "verificationMode": widget.verificationMode,
                  //           "selectedApplicant": widget.selectedApplicant,
                  //           "accountNumber": widget.bankAccountNumber,
                  //           "vpaStatus": VpaStatus(),
                  //           "mandateResponse": mandateSource,
                  //           "updateMandateInfo": widget.updateMandateInfo
                  //         });
                  //     return NavigationActionPolicy.CANCEL;
                  //   } else {
                  //     return NavigationActionPolicy.ALLOW;
                  //   }
                  // }
                  // if (uri.toString().contains(redirectUrl) || uri.toString().contains(responseUrl)) {
                  //   if(source == MandateSourceType.cams.label){
                  //   String? campsOutput = uri.queryParameters["output"];
                  //   var mandateSource = MandateResponseModel(madateSource: source, madateOutput: campsOutput);
                  //   context.pushReplacementNamed(Routes.mandateSuccessScreen.name, extra: {"loanData": widget.loanData, "bankName": widget.bankName, "verificationMode":widget.verificationMode, "selectedApplicant": widget.selectedApplicant,
                  //     "accountNumber": widget.bankAccountNumber, "vpaStatus": VpaStatus(), "mandateResponse": mandateSource, "updateMandateInfo" : widget.updateMandateInfo
                  //   });
                  //   } else {
                  //     String? nupayResponse = uri.queryParameters["uniq_id"];
                  //     var mandateSource = MandateResponseModel(madateSource: source, madateOutput: nupayResponse);
                  //     context.pushReplacementNamed(Routes.mandateSuccessScreen.name, extra: {"loanData": widget.loanData, "bankName": widget.bankName, "verificationMode":widget.verificationMode, "selectedApplicant": widget.selectedApplicant,
                  //       "accountNumber": widget.bankAccountNumber, "vpaStatus": VpaStatus(), "mandateResponse": mandateSource, "updateMandateInfo" : widget.updateMandateInfo
                  //     });
                  //   }
                  //   return NavigationActionPolicy.CANCEL;
                  // }
                  // return NavigationActionPolicy.ALLOW;
                  // }
                );
                _context.pushNamed(
                    payment_web_view.Routes.paymentWebviewScreen.name,
                    extra: model);
              } else {
                toastForFailureMessage(
                    context: context, msg: state.response.message ?? "");
              }
            } else if (state is GenerateMandateReqFailureState) {
              toastForFailureMessage(
                  context: context, msg: getFailureMessage(state.failure));
            } else if (state is LoadingDialogState) {
              if (state.isloading) {
                showLoaderDialog(buildContext, getString(lblMandateLoading));
              } else {
                Navigator.of(buildContext, rootNavigator: true).pop();
              }
            } else if (state is GenerateMandateReqFailureState) {
              if (context.mounted) {
                toastForFailureMessage(
                    context: context, msg: getFailureMessage(state.failure));
              }
            }
          },
          builder: (context, state) {
            return CustomElevatedButton(
                height: 42.v,
                onPressed: () {
                  if (getVerificationModeShortCode(
                              widget.verificationMode.optionId ?? "")
                          .shortCode ==
                      VerificationMode.upi.shortCode) {
                    context.pop(true);
                  } else {
                    var mode = getVerificationModeShortCode(
                            widget.verificationMode.optionId ?? "")
                        .shortCode;
                    var request = GenerateMandateRequest(
                        aggregator: widget.mandateSource,
                        cif: widget.loanData.cif,
                        accountHolderName: removeSpecialCharacters(
                            widget.selectedApplicant.split("#&#")[1]),
                        accountType: widget.accountType?.value,
                        authenticationMode: mode,
                        bankCode: widget.bankCode,
                        emailId: "",
                        mandateCategory: "L001",
                        mobileNo: getPhoneNumber(),
                        accountNumber: widget.bankAccountNumber,
                        enachAmount:
                            widget.loanData.installmentAmount.toString(),
                        ifsc: widget.ifscCode,
                        mandateStartDate: getCurrentDate(),
                        mandateEndDate: widget.loanData.endDate,
                        pan: "",
                        frequencyDeduction: AchConst.frequencydeduction,
                        payerVpa: mode == VerificationMode.upi.shortCode
                            ? widget.payerVpa
                            : "",
                        payerName: mode == VerificationMode.upi.shortCode
                            ? widget.payerName
                            : "",
                        productName: widget.loanData.productName ?? widget.loanData.productCategory ,
                        sourceSystem: widget.loanData.sourceSystem,
                        loanNumber: widget.loanData.loanAccountNumber,
                        updateRequest:
                            widget.updateMandateInfo.mandateData != null
                                ? true
                                : false,
                        mandateId: widget.updateMandateInfo.mandateData != null
                            ? widget.updateMandateInfo.mandateData?.mandateId
                            : "",
                        trxnNo: generateRandom16DigitNumber(),
                        batchNumber: widget.updateMandateInfo.mandateData !=
                                null
                            ? widget.updateMandateInfo.mandateData?.batchNo ??
                                ""
                            : "",
                        updateReason:
                            widget.updateMandateInfo.mandateData != null
                                ? widget.updateMandateInfo.reason
                                : "",
                        revokeable:
                            mode == VerificationMode.upi.shortCode ? "Y" : "N",
                        authorize:
                            mode == VerificationMode.upi.shortCode ? "Y" : "N",
                        authorizerevoke:
                            mode == VerificationMode.upi.shortCode ? "Y" : "N",
                        superAppId: getSuperAppId(),
                        source: AppConst.source);
                    context.read<AchCubit>().generateMandateReq(request);
                  }
                },
                text: getString(lblConfirm),
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    )),
                buttonTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white));
          },
        ),
        SizedBox(
          height: 20.v,
        ),
        SizedBox(
          width: double.maxFinite,
          height: 42.v,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                            color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5,
                        ))))),
            child: Text(getString(lblBack),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5,
                    ))),
            //  margin: EdgeInsets.symmetric(horizontal: 3.h),
          ),
        ),
      ],
    );
  }

  /// Common widget for text
  Widget _buildAccountData(
    BuildContext context, {
    required String name,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
