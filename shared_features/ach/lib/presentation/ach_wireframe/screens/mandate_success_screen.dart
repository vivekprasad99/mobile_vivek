import 'package:ach/config/ach_const.dart';
import 'package:ach/data/models/madate_res_model.dart';
import 'package:ach/data/models/nupay_status_req.dart';
import 'package:ach/data/models/nupay_status_res.dart';
import 'package:clipboard/clipboard.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/presentation/widget/rate_us_dialog_box.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_button_style.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/routes/extension.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart'
    as rate_us;
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:go_router/go_router.dart';

import '../../../config/ach_util.dart';
import '../../../config/source.dart';
import '../../../data/models/camps_output_req.dart';
import '../../../data/models/camps_output_res.dart';
import '../../../data/models/check_vpa_status_res.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/update_mandate_info.dart';
import '../../cubit/ach_cubit.dart';
import 'package:common/features/rate_us/utils/helper/constant_data.dart';


class MandateSuccessScreen extends StatefulWidget {
  final LoanData loanData;
  final String bankName;
  final VerificationOption verificationMode;
  final String accountNumber;
  final String selectedApplicant;
  final VpaStatus vpaStatus;
  final MandateResponseModel mandateResponse;
  final Source? source;
  final UpdateMandateInfo updateMandateInfo;

  const MandateSuccessScreen(
      {super.key,
      required this.loanData,
      required this.bankName,
      required this.verificationMode,
      required this.accountNumber,
      required this.selectedApplicant,
      required this.vpaStatus,
      required this.mandateResponse,
      required this.updateMandateInfo,
      required this.source});

  @override
  State<MandateSuccessScreen> createState() => _MandateSuccessScreenState();
}

class _MandateSuccessScreenState extends State<MandateSuccessScreen> {
  var _status = <String, String>{};
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    bool isVpaMode =
        getVerificationModeShortCode(widget.verificationMode.optionId ?? "")
                .shortCode ==
            VerificationMode.upi.shortCode;
    if (isVpaMode) {
      _status = _getStatus(CampsOutputRes(), widget.vpaStatus);
    } else {
      showLoader = true;
      if (widget.mandateResponse.mandateSource ==
          MandateSourceType.cams.label) {
        var request = CampsOutputReq(
            encryptedRequest: widget.mandateResponse.mandateOutput,
            superAppId: getSuperAppId(),
            source: AppConst.source);
        context.read<AchCubit>().decryptCampsOutput(request);
      } else {
        if (widget.mandateResponse.mandateOutput == NupayStatus.failed.status) {
          showLoader = false;
          var status = <String, String>{};
          status['status'] = "FAILED";
          status['umrn'] = "";
          status['statusDesc'] =
              widget.mandateResponse.mandateFailedMessage ?? "";
          _status = status;
        } else {
          var request = NupayStatusReq(
              nupayId: widget.mandateResponse.mandateOutput,
              superAppId: getSuperAppId(),
              source: AppConst.source);
          context.read<AchCubit>().getNupayStatusById(request);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: MultiBlocListener(
            listeners: [
              BlocListener<rate_us.RateUsCubit, rate_us.RateUsState>(
                listener: (context, state) {
                  if (state is rate_us.RateUsSuccessState) {
                    if (state.response.code == AppConst.codeSuccess) {
                      if (state.response.rateUsStatus ?? false) {
                        showRateUsPopup(context, ConstantData.achCreation);
                      } else {
                        Navigator.of(context).popUntil(ModalRoute.withName(
                            common_routes.Routes.home.name));
                      }
                    } else {
                      toastForFailureMessage(
                          context: context,
                          msg: getString(state.response.responseCode ??
                              msgSomethingWentWrong));
                    }
                  } else if (state is rate_us.RateUsFailureState) {
                    showSnackBar(
                        context: context,
                        message: getFailureMessage(state.failure));
                  }
                },
              ),
              BlocListener<AchCubit, AchState>(
                listener: (context, state) {
                  if (state is DecryptCampsOutputSuccessState) {
                    if (state.response.code == AppConst.codeSuccess) {
                      setState(() {
                        _status = _getStatus(state.response, widget.vpaStatus);
                      });
                    } else {
                      if (context.mounted) {
                        toastForFailureMessage(
                            context: context,
                            msg: state.response.message ?? "");
                        setState(() {
                          _status = _getStatusForApiFailure(
                              message: state.response.message ?? "");
                        });
                      }
                    }
                  } else if (state is DecryptCampsOutputFailureState) {
                    if (context.mounted) {
                      toastForFailureMessage(
                          context: context,
                          msg: getFailureMessage(state.failure));
                      setState(() {
                        _status = _getStatusForApiFailure(
                            message: getFailureMessage(state.failure));
                      });
                    }
                  } else if (state is NupayStatusByIdSuccessState) {
                    if (state.response.code == AppConst.codeSuccess) {
                      setState(() {
                        _status = _getStatusForNupay(state.response);
                      });
                    } else {
                      if (context.mounted) {
                        toastForFailureMessage(
                            context: context,
                            msg: state.response.message ?? "");
                        setState(() {
                          _status = _getStatusForApiFailure(
                              message: state.response.message ?? "");
                        });
                      }
                    }
                  } else if (state is NupayStatusByIdFailureState) {
                    if (context.mounted) {
                      toastForFailureMessage(
                          context: context,
                          msg: getFailureMessage(state.failure));
                      setState(() {
                        _status = _getStatusForApiFailure(
                            message: getFailureMessage(state.failure));
                      });
                    }
                  } else if (state is LoadingDialogState) {
                    showLoader = state.isloading;
                  }
                },
              ),
            ],
            child: MFGradientBackground(
              child: showLoader
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _status["status"].toString().equalsIgnoreCase("SUCCESS") ?
                        SvgPicture.asset(
                          ImageConstant.imgCongratulationIcon,
                          colorFilter: ColorFilter.mode(
                              setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.secondaryLight5,
                              ),
                              BlendMode.srcIn),
                        ) :
                        Icon(
                          Icons.error_outline,
                          size: 56,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.secondaryLight,
                              darkColor: AppColors.primaryLight5),
                        ),
                        SizedBox(height: 20.v),
                        Text(
                            _status["status"] == "SUCCESS"
                                ? getString(msgYouHaveSuccessfully)
                                : _getMandateStatusTitle(
                                    _status["status"] ?? ""),
                            style: Theme.of(context).textTheme.headlineLarge),
                        SizedBox(height: 20.v),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: setColorBasedOnTheme(
                                context: context,
                                lightColor: Colors.white,
                                darkColor: AppColors.cardDark),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ExpansionTile(
                            enabled:
                                _status["status"] == "SUCCESS" ? true : false,
                            shape: const Border(),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            iconColor: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: Colors.white),
                            collapsedIconColor: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: Colors.white),
                            tilePadding: EdgeInsets.zero,
                            dense: true,
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _status["status"] == "SUCCESS"
                                    ? const Icon(
                                        Icons.check_circle,
                                        size: 17,
                                        color: Color(0xFF238823),
                                      )
                                    : const Icon(
                                        Icons.cancel_rounded,
                                        size: 17,
                                        color: Colors.red,
                                      ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    _status["status"] == "SUCCESS"
                                        ? _getFormatEMandateMessage(
                                            widget.loanData.loanAccountNumber ??
                                                "",
                                            _status["umrn"] ?? "")
                                        : _getMandateStatusMessage(
                                            _status["status"] ?? ""),
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ],
                            ),
                            // subtitle: Text('Trailing expansion arrow icon'),
                            children: [
                              Divider(
                                color: Theme.of(context).dividerColor,
                              ),
                              SizedBox(height: 10.v),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getString(lblUmrn),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                            child: Text(
                                                          _status["umrn"] ?? "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelSmall,
                                                        )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              FlutterClipboard.copy(
                                                                      _status["umrn"] ??
                                                                          "")
                                                                  .then((value) => showSnackBar(
                                                                      context:
                                                                          context,
                                                                      message:
                                                                          getString(
                                                                              msgMandateCopied)));
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .file_copy_outlined,
                                                              size: 20,
                                                              color: setColorBasedOnTheme(
                                                                  context:
                                                                      context,
                                                                  lightColor:
                                                                      AppColors
                                                                          .primaryLight,
                                                                  darkColor:
                                                                      AppColors
                                                                          .primaryLight4),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.v,
                                                ),
                                                _buildExpandedData(
                                                    context: context,
                                                    title: getString(
                                                        msgLoanAccountNumber),
                                                    subtitle: widget.loanData
                                                            .loanAccountNumber ??
                                                        ""),
                                                SizedBox(
                                                  height: 10.v,
                                                ),
                                                _buildExpandedData(
                                                    context: context,
                                                    title: getVerificationModeShortCode(widget
                                                                        .verificationMode
                                                                        .optionId ??
                                                                    "")
                                                                .shortCode ==
                                                            VerificationMode
                                                                .upi.shortCode
                                                        ? getString(
                                                            msgVpaNumber)
                                                        : getString(
                                                        msgMandateBankAccountNumber),
                                                    subtitle: getVerificationModeShortCode(widget
                                                                        .verificationMode
                                                                        .optionId ??
                                                                    "")
                                                                .shortCode ==
                                                            VerificationMode
                                                                .upi.shortCode
                                                        ? widget.accountNumber
                                                        : formatAccountNumber(
                                                            widget
                                                                .accountNumber)),
                                                SizedBox(
                                                  height: 10.v,
                                                ),
                                                _buildExpandedData(
                                                    context: context,
                                                    title:
                                                        getString(lblMandateStartDate),
                                                    subtitle: widget.loanData
                                                            .startDate ??
                                                        ""),
                                                SizedBox(
                                                  height: 10.v,
                                                ),
                                                _buildExpandedData(
                                                    context: context,
                                                    title: getString(
                                                        msgMandateFrequency),
                                                    subtitle: AchConst
                                                        .mandateFrequency),
                                              ],
                                            ))),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildExpandedData(
                                            context: context,
                                            title: getString(lblMandateName),
                                            subtitle: widget.selectedApplicant
                                                .split("#&#")[1]),
                                        SizedBox(
                                          height: 10.v,
                                        ),
                                        _buildExpandedData(
                                            context: context,
                                            title: getString(lblBankName),
                                            subtitle: widget.bankName),
                                        SizedBox(
                                          height: 10.v,
                                        ),
                                        _buildExpandedData(
                                            context: context,
                                            title: getString(lblMandateAmount),
                                            subtitle:
                                                "₹${widget.loanData.installmentAmount}"),
                                        SizedBox(
                                          height: 10.v,
                                        ),
                                        _buildExpandedData(
                                            context: context,
                                            title: getString(lblEndDate),
                                            subtitle:
                                                widget.loanData.endDate ?? ""),
                                      ],
                                    )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        _buildButton(context)
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedData(
      {required BuildContext context,
      required String title,
      required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return BlocBuilder<rate_us.RateUsCubit, rate_us.RateUsState>(
      builder: (context, state) {
        return CustomElevatedButton(
          onPressed: () {
            if (widget.source != null &&
                widget.source?.purpose == Purpose.pennyDrop) {
              GoRouter.of(context)
                  .popUntilPath(widget.source?.callBackRoute ?? "");
              return;
            }
            checkLastRatingDate(context, ConstantData.achCreation);
          },
          isDisabled: state == rate_us.LoadingState(isloading: true),
          text: widget.source != null
              ? getString(lblMandateContinue)
              : getString(lblHome),
          margin: EdgeInsets.symmetric(horizontal: 3.h),
          buttonStyle: CustomButtonStyles.fillOnPrimaryContainerEnable,
          buttonTextStyle: CustomTextStyles.titleSmallOnPrimarySemiBold,
        );
      },
    );
  }

  void checkLastRatingDate(BuildContext context, String featureType) async {
    RateUsRequest rateUsRequest =
        RateUsRequest(superAppId: getSuperAppId(), feature: featureType);
    BlocProvider.of<rate_us.RateUsCubit>(context).getRateUs(rateUsRequest);
  }

  void showRateUsPopup(BuildContext context, String featureType) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => di<rate_us.RateUsCubit>(),
          child: RateUsDialogBox(featureType,onTap: (BuildContext dialogContex){
            Navigator.of(dialogContex).pop();
            Navigator.of(context).popUntil(ModalRoute.withName(
                common_routes.Routes.home.name));
          },),
        );
      },
    );
  }

  String _getFormatEMandateMessage(String loanNumber, String umrn) {
    return getString(lblEMandateSuccess)
        .replaceAll("#LoanNumber#", loanNumber)
        .replaceAll("#UMRN#", umrn);
  }

  Map<String, String> _getStatus(
      CampsOutputRes campsOutputRes, VpaStatus vpaStatus) {
    var status = <String, String>{};
    bool isVpaMode =
        getVerificationModeShortCode(widget.verificationMode.optionId ?? "")
                .shortCode ==
            VerificationMode.upi.shortCode;
    if (isVpaMode) {
      status['status'] = _getVpaStatus(vpaStatus);
      status['umrn'] = vpaStatus.umn ?? "";
      status['statusDesc'] = vpaStatus.statusdesc ?? "";
    } else {
      status['status'] = _getEnachStatus(campsOutputRes);
      status['umrn'] = campsOutputRes.campsOutput?.umrn ?? "";
      status['statusDesc'] = campsOutputRes.campsOutput?.statusDesc ?? "";
    }
    return status;
  }

  Map<String, String> _getStatusForNupay(NupayStatusRes nupayStatusRes) {
    var status = <String, String>{};
    status['status'] = (nupayStatusRes.nupayData?.response?.statusCode! ==
            NupayStatusCode.np000.status)
        ? nupayStatusRes.nupayData?.response?.data?.customer?.accptd ==
                NupayStatus.accepted.status
            ? "SUCCESS"
            : nupayStatusRes.nupayData?.response?.data?.customer?.accptd ==
                    NupayStatus.inProcess.status
                ? "PENDING"
                : "FAILED"
        : "FAILED";
    status['umrn'] =
        nupayStatusRes.nupayData?.response?.data?.customer?.umrn ?? "";
    status['statusDesc'] =
        nupayStatusRes.nupayData?.response?.data?.customer?.reasonDesc ?? "";
    return status;
  }

  String _getVpaStatus(VpaStatus vpaStatus) {
    if (vpaStatus.status == VPAStatus.active.status) {
      return "SUCCESS";
    } else if (vpaStatus.status == VPAStatus.pending.status) {
      return "PENDING";
    } else {
      return "FAILED";
    }
  }

  String _getEnachStatus(CampsOutputRes campsOutputRes) {
    if (campsOutputRes.campsOutput?.status == EnachStatus.success.status) {
      return "SUCCESS";
    } else if (campsOutputRes.campsOutput?.status ==
        EnachStatus.pending.status) {
      return "PENDING";
    } else {
      return "FAILED";
    }
  }

  String _getMandateStatusMessage(String status) {
    if (status == "PENDING") {
      return getString(msgMandateStatusPending);
    } else {
      if (_status["statusDesc"]?.isNotEmpty == true) {
        return _status["statusDesc"] ?? getString(msgMandateStatusRejected);
      }
      return getString(msgMandateStatusRejected);
    }
  }

  String _getMandateStatusTitle(String status) {
    if (status == "PENDING") {
      return getString(lblEMandatePending);
    } else {
      return getString(lblEMandateFailed);
    }
  }

  Map<String, String> _getStatusForApiFailure({required String message}) {
    var status = <String, String>{};
    status['status'] = "FAILED";
    status['umrn'] = "";
    status['statusDesc'] = message;
    return status;
  }
}
