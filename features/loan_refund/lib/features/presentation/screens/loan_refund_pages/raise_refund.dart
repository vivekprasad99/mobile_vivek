import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/fetch_bank_account_req.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/routes/extension.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_request.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_cubit.dart';
import 'package:loan_refund/features/presentation/screens/widgets/custom_card.dart';
import 'package:loan_refund/features/presentation/screens/widgets/info_card.dart';
import 'package:ach/config/source.dart';
import 'package:ach/data/models/update_mandate_info.dart';
import 'package:ach/config/routes/route.dart' as ach_routes;
import '../../../../config/refund_util.dart';
import '../../../../config/routes/route.dart';
import '../../cubit/loan_refund_state.dart';
import '../../loan_refund_viewmodel.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
class RaiseRefund extends StatefulWidget {
  const RaiseRefund(
      {super.key,
      required this.loanList,
      required this.loanData,
      required this.refundAmount});

  final List<LoanData> loanList;
  final LoanData loanData;
  final double refundAmount;

  @override
  State<RaiseRefund> createState() => _RaiseRefundState();
}

class _RaiseRefundState extends State<RaiseRefund> {
  double finalRevisedRefundAmount = 0.0;
  TextEditingController remarkTextController = TextEditingController();
  bool _isTNCSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: customAppbar(
              context: context,
              title: getString(
                lblRaiseFund,
              ),
              onPressed: () {
                context.pop();
              },
              actions: [
                HelpCommonWidget(categoryval: HelpConstantData.categoryRefund,subCategoryval: HelpConstantData.categoryRefund,)
              ]),
          body: BlocListener<LoanRefundCubit, LoanRefundState>(
            listener: (context, state) {
              if (state is AdjustOnly) {
                //scenario 2
                context.pushNamed(Routes.adjustPreviewScreen.name, extra: {
                  'loanData': state.selectedLoan,
                  'is_sr_required': false,
                  'sr_desc': state.srMessage
                });
              } else if (state is AdjustWithSR) {
                // scenario 11
                context.pushNamed(Routes.adjustPreviewScreen.name, extra: {
                  'loanData': state.selectedLoan,
                  'is_sr_required': true,
                  'sr_desc': state.srMessage,
                  'refundStatus': context
                      .read<LoanRefundCubit>()
                      .loanRefundViewModel
                      .getRefundType(state)
                });
              } else if (state is RefundWithPennyDropAndSR) {
                // Scenario 1, 4, 5
                finalRevisedRefundAmount = widget.refundAmount;
                //_initPennyDrop(state);
                if (state.selectedLoan != null) {
                  _fetchApplicantName(state, forPennyDropOnly: true);
                }
              } else if (state is AdjustWithHoldACHSR) {
                // scenario 6, 14
                finalRevisedRefundAmount = widget.refundAmount;
                //_initPennyDrop(state, isAdjust: true);
                if (state.selectedLoan != null) {
                  _fetchApplicantName(state,
                      forPennyDropOnly: true, isAdjust: true);
                }
              } else if (state is AdjustAndRefundWithPennyDropAndHoldACHSR) {
                //scenario 7
                finalRevisedRefundAmount = state.refundAmountAfterAdjust;
                //_initPennyDrop(state);
                if (state.selectedLoan != null) {
                  _fetchApplicantName(state, forPennyDropOnly: true);
                }
              } else if (state is RefundAndAdjustWithPennyDropAndSR) {
                // scenario 9, 12, 13  // show dues list in review
                finalRevisedRefundAmount = state.refundAmountAfterAdjust;
                //_initPennyDrop(state);
                if (state.selectedLoan != null) {
                  _fetchApplicantName(state, forPennyDropOnly: true);
                }
              } else if (state is RefundWithCreateMandateAndSR) {
                finalRevisedRefundAmount = widget.refundAmount;
                //scenario 3, 10
                //initMandate
                _fetchApplicantName(state);
              } else if (state is RefundAndAdjustWithPennyDropAndHoldACHSR) {
                // scenario 15
                finalRevisedRefundAmount = state.refundAmountAfterAdjust;
                //_initPennyDrop(state);
                if (state.selectedLoan != null) {
                  _fetchApplicantName(state, forPennyDropOnly: true);
                }
              } else if (state is RefundAndAdjustWithCreateMandateAndSR) {
                // scenario 11  // show dues list in review
                finalRevisedRefundAmount = state.refundAmountAfterAdjust;
                //initMandate
                if (state.selectedLoan != null) {
                  _fetchApplicantName(state);
                }
              } else if (state is FetchApplicantNameSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  var loanData = state.loanRefundState?.selectedLoan;
                  loanData?.applicantName =
                      state.response.data?.applicantName ?? "";
                  loanData?.coApplicantName =
                      state.response.data?.coApplicantName ?? "";
                  state.loanRefundState?.selectedLoan = loanData;
                  BlocProvider.of<LoanRefundCubit>(context).fetchBankAccount(
                      FetchBankAccountRequest(
                          loanAccountNumber: loanData?.loanAccountNumber ?? "",
                          ucic: loanData?.ucic ?? "",
                          cif: loanData?.cif ?? "",
                          superAppId: getSuperAppId(),
                          source: AppConst.source),
                      state.loanRefundState,
                      state.forPennyDropOnly,
                      state.forAdjust);
                } else {
                  toastForFailureMessage(
                      context: context, msg: getString(msgSomethingWentWrong));
                }
              } else if (state is FetchApplicantNameFailureState) {
                toastForFailureMessage(
                    context: context, msg: getString(msgSomethingWentWrong));
              } else if (state is FetchBankAccountSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  if (state.response.data != null &&
                      state.response.data!.isNotEmpty) {
                    pushAddedBankScreen(context, state);
                  } else {
                    pushSelectBankScreen(context, state);
                  }
                } else {
                  toastForFailureMessage(
                      context: context, msg: getString(msgSomethingWentWrong));
                }
              }
              else if(state is LoanRefundLoadingState){
                if (state.isLoading) {
                  showLoaderDialog(context, getString(lblLoading));
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
              else if (state is FetchBankAccountFailureState) {
                toastForFailureMessage(
                    context: context, msg: getString(msgSomethingWentWrong));
              }
            },
            child: BlocBuilder<LoanRefundCubit, LoanRefundState>(
                buildWhen: (previous, current) =>
                    current is OverdueAdjustmentConsentDone,
                builder: (context, state) {
                  return MFGradientBackground(
                      child: _isThereDueWithLoans() &&
                              state is! OverdueAdjustmentConsentDone
                          ? _buildRaiseRefundWithDues()
                          : _buildRaiseRefundWithNoDues(state));
                }),
          )),
    );
  }

  void pushAddedBankScreen(
      BuildContext context, FetchBankAccountSuccessState state) async {
    final result = await context
        .pushNamed(ach_routes.Routes.addedBanksScreen.name, extra: {
      "loanData": state.loanRefundState?.selectedLoan,
      "bankData": state.response.data,
      "updateMandateInfo": UpdateMandateInfo(),
      "source": Source(
          purpose: (state.forPennyDropOnly ?? false)
              ? Purpose.pennyDrop
              : Purpose.mandate,
          title: getString(lblRefund),
          description: 'Refund is applicable',
          onSuccessMandate: () {},
          onSuccessPennyDrop: () {})
    });

    if (result == successNavigation) {
      if ((state.forPennyDropOnly == true) && (state.forAdjust == true)) {
        _pushAdjustPreviewScreen(state.loanRefundState);
      } else {
        _pushRefundPreviewScreen(state.loanRefundState);
      }
    }
  }

  void pushSelectBankScreen(
      BuildContext context, FetchBankAccountSuccessState state) async {
    final result = await context
        .pushNamed(ach_routes.Routes.selectBankScreen.name, extra: {
      "loanData": state.loanRefundState?.selectedLoan,
      "selectedApplicant": '',
      "updateMandateInfo": UpdateMandateInfo(),
      "source": Source(
          purpose: (state.forPennyDropOnly ?? false)
              ? Purpose.pennyDrop
              : Purpose.mandate,
          title: getString(lblRefund),
          description: 'Refund is applicable',
          onSuccessMandate: () {},
          onSuccessPennyDrop: () {})
    });

    if (result == successNavigation) {
      if ((state.forPennyDropOnly == true) && (state.forAdjust == true)) {
        _pushAdjustPreviewScreen(state.loanRefundState);
      } else {
        _pushRefundPreviewScreen(state.loanRefundState);
      }
    }
  }

  bool _isThereDueWithLoans() {
    context
        .read<LoanRefundCubit>()
        .loanRefundViewModel
        .setLoanList(widget.loanList);
    return context
        .read<LoanRefundCubit>()
        .loanRefundViewModel
        .isThereADueWithLoans();
  }

  bool _showUpcomingEMIAndAdjustLabel(LoanData loanData) {
    context.read<LoanRefundCubit>().loanRefundViewModel.selectedLoan = loanData;
    return context
        .read<LoanRefundCubit>()
        .loanRefundViewModel
        .showUpcomingEMI();
  }

  _buildRaiseRefundWithNoDues(state) {
    return Column(
      children: [
        CustomCard(
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.cardLight,
              darkColor: AppColors.cardDark),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                        "${widget.loanData.productCategory} | ${widget.loanData.loanAccountNumber}",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(widget.loanData.productName ?? "",
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblEmisPaid),
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                        "${widget.loanData.totalEmiPaid}/${widget.loanData.loanTenure}",
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        (state is OverdueAdjustmentConsentDone && _showUpcomingEMIAndAdjustLabel(widget.loanData))
                            ? getString(lblExcessAmountAfterAdjustment)
                            : getString(lblExcessAmount),
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                        state is OverdueAdjustmentConsentDone
                            ? _getExcessAmountAfterAdjustment()
                            : (widget.loanData.excessAmount ?? "").toString(),
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblUpcomingEMI),
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                        _showUpcomingEMIAndAdjustLabel(widget.loanData)
                            ? (widget.loanData.installmentAmount ?? "")
                                .toString()
                            : '-',
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SvgPicture.asset(
                  ImageConstant.line,
                  height: 16.h,
                  width: 16.v,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor, BlendMode.srcIn),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showRefundAmount(_isAdjustmentApplicableAndRefundMoreThanMinAmount()),
                      Text(widget.refundAmount.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const InfoCard(
          infoMessage: lblRefundReviewInfoMsg,
          height: 96,
          width: double.infinity,
        ),
        if (_isAdjustmentApplicableAndRefundMoreThanMinAmount())
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: MfCustomButton(
                onPressed: () {
                  context
                      .read<LoanRefundCubit>()
                      .doRefund(widget.loanData, forceAdjust: true);
                },
                text: getString(context
                    .read<LoanRefundCubit>()
                    .loanRefundViewModel
                    .getAdjustLabelName(widget.loanList, widget.loanData)),
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.white,
                          darkColor: AppColors.white),
                    ),
              )),
        if (context
            .read<LoanRefundCubit>()
            .loanRefundViewModel
            .isRefundMoreThanMinAmount(widget.refundAmount))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MfCustomButton(
              onPressed: () {
                context.read<LoanRefundCubit>().doRefund(widget.loanData);
              },
              text: getString(lblrefundFundOnlyText),
              outlineBorderButton: true,
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.white)),
            ),
          )
      ],
    );
  }

  Row showRefundAmount(bool isAdjustApplicable) {
    var infoImageBottom = isAdjustApplicable ? 10.0 : 0.0;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblRefundApplicable),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (isAdjustApplicable)
              Text(
                getString(lbl_after_adjustment),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0, bottom: infoImageBottom),
          child: SvgPicture.asset(
            ImageConstant.info,
            height: 12.6.h,
            width: 12.6.v,
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  String _getExcessAmountAfterAdjustment() {
    String value = ((widget.loanData.excessAmount ?? 0) -
            LoanRefundViewModel.getTotalOverDueAmount(widget.loanList))
        .toString();
    return value;
  }

  bool _isAdjustmentApplicableAndRefundMoreThanMinAmount() {
    var flag = context
            .read<LoanRefundCubit>()
            .loanRefundViewModel
            .isRefundMoreThanMinAmount(widget.refundAmount) &&
        context
            .read<LoanRefundCubit>()
            .loanRefundViewModel
            .isAdjustmentApplicable(widget.loanData);
    return flag;
  }

  _buildRaiseRefundWithDues() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.loanData.productCategory} | ${widget.loanData.loanAccountNumber}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                    widget.loanData.productCategory ==
                            LoanType.personalLoan.value
                        ? widget.loanData.totalAmount.toString()
                        : widget.loanData.vehicleRegistration ?? "",
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 15),
                Divider(
                  color: Theme.of(context).dividerColor,
                ),
                const SizedBox(height: 15),
                Text(
                  getString(lblExcessAmount),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text((widget.loanData.excessAmount ?? 0).toString(),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 15),
                Text(
                  getString(lblExcessAdjustmentsAfterBreakup),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 15),
                Text(
                  getString(lblExcessAdjustedAgainstDue),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: SizedBox(
                    height: 190.v,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for (var loan in widget.loanList)
                            _buildLoanItem(loan),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.v),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getString(lblExcessAfterDues),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        widget.refundAmount.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
                activeColor: Theme.of(context).primaryColor,
                checkColor: Theme.of(context).scaffoldBackgroundColor,
                visualDensity: const VisualDensity(
                  vertical: -4,
                  horizontal: -4,
                ),
                value: _isTNCSelected,
                onChanged: (value) async {
                  setState(() {
                    _isTNCSelected = value ?? false;
                  });
                }),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: RichText(
                    text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(letterSpacing: 0.4),
                        children: <TextSpan>[
                      TextSpan(
                        text: getString(lblRefundsTNC),
                      ),
                      TextSpan(
                          text: "",
                          style: Theme.of(context).textTheme.labelSmall,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {})
                    ])),
              ),
            )
          ],
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: MfCustomButton(
              onPressed: () {
                if (_isTNCSelected) {
                  //call consent API
                  LoanRefundConsentRequest request =
                  LoanRefundConsentRequest(
                      superAppId: getSuperAppId(),
                      feature: 'RefundConsent',
                      consentFlag: true);
                  context
                      .read<LoanRefundCubit>()
                      .doConsent(request: request);
                } else {
                  showSnackBar(
                      context: context,
                      message: getString(lblRefundSelectTNCValidation));
                }
              },
              text: getString(lblContinue),
              outlineBorderButton: false,
              textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.white,
                      darkColor: AppColors.white),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0),
            ))
      ],
    );
  }

  ListTile _buildLoanItem(LoanData? loan) {
    return ListTile(
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight6,
                darkColor: AppColors.shadowDark),
            borderRadius: BorderRadius.circular(8)),
        child: SvgPicture.asset(
          ImageConstant.imgVehicleLoanIconLight,
        ),
      ),
      title: Text(
        loan?.productName ?? "",
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        loan?.loanAccountNumber ?? "",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Text(
        loan?.totalAmountOverdue ?? "",
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  void _fetchApplicantName(LoanRefundState loanRefundState,
      {bool forPennyDropOnly = false, bool isAdjust = false}) {
    LoanData loanData = loanRefundState.selectedLoan ?? LoanData();
    BlocProvider.of<LoanRefundCubit>(context).fetchApplicantName(
        FetchApplicantNameReq(
            loanNumber: loanData.loanAccountNumber ?? "",
            ucic: loanData.ucic ?? "",
            cif: loanData.cif ?? "",
            sourceSystem: loanData.sourceSystem ?? "",
            superAppId: getSuperAppId(),
            source: AppConst.source),
        loanRefundState,
        forPennyDropOnly,
        isAdjust);
  }

  void _pushRefundPreviewScreen(LoanRefundState? state) {
    context.pushNamed(Routes.navigateToRefundPreview.name, extra: {
      'loanData': state?.selectedLoan,
      'revisedRefund': finalRevisedRefundAmount,
      'srDesc': context
          .read<LoanRefundCubit>()
          .loanRefundViewModel
          .getSrMessage(state),
      'refundStatus': context
          .read<LoanRefundCubit>()
          .loanRefundViewModel
          .getRefundType(state),
      'isDues': false
      // show installmentAmount value NA if isDues is false. (scenario 3)
    });
  }

  void _pushAdjustPreviewScreen(LoanRefundState? state) {
    context.pushNamed(Routes.adjustPreviewScreen.name, extra: {
      'loanData': state?.selectedLoan,
      'sr_desc': context
          .read<LoanRefundCubit>()
          .loanRefundViewModel
          .getSrMessage(state),
      'refundStatus': context
          .read<LoanRefundCubit>()
          .loanRefundViewModel
          .getRefundType(state),
      'is_sr_required': true
    });
  }
}
