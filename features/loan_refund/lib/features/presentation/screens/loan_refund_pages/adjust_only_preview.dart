import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_refund/features/presentation/screens/widgets/custom_card.dart';
import 'package:loan_refund/features/presentation/screens/widgets/info_card.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/data/models/sr_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';
import 'package:service_ticket/config/routes/route.dart' as sr_routes;
import '../../../../config/refund_util.dart';
import '../../../data/models/loan_refund_consent_request.dart';
import '../../cubit/loan_refund_cubit.dart';
import '../../cubit/loan_refund_state.dart';
import '../../loan_refund_viewmodel.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

// ignore_for_file: must_be_immutable
class AdjustPreviewScreen extends StatefulWidget {
  AdjustPreviewScreen(
      {super.key,
      this.loanData,
      required this.isSRRequired,
      this.srDescription,
      this.isDues,
      this.loanList,
      this.refundStatus});

  final LoanData? loanData;
  final bool isSRRequired;
  final String? srDescription;
  final bool? isDues;
  List<LoanData>? loanList;
  final String? refundStatus;

  @override
  State<AdjustPreviewScreen> createState() => _AdjustPreviewScreenState();
}

class _AdjustPreviewScreenState extends State<AdjustPreviewScreen> {
  double totaRefundAmount = 0.0;
  bool _isTNCSelected = false;
  TextEditingController remarkTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    calculateRefundAmount();
  }

  calculateRefundAmount() {
    double excessAmount = widget.loanData?.excessAmount ?? 0;
    double installmentAmount = widget.loanData?.installmentAmount ?? 0;

    if (excessAmount > installmentAmount) {
      totaRefundAmount = excessAmount - installmentAmount;
    } else {
      totaRefundAmount = excessAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: customAppbar(
              context: context,
              title: getString(
                lblAdjustFund,
              ),
              onPressed: () {
                context.pop();
              },
              actions: [
                HelpCommonWidget(categoryval: HelpConstantData.categoryRefund,subCategoryval: HelpConstantData.categoryRefund,)
              ]
          ),

          body: BlocListener<ServiceRequestCubit, ServiceRequestState>(
            listener: (context, state) {
              if (state is ServiceRequestSuccessState) {
                if (state.response.code == AppConst.codeSuccess &&
                    state.response.data != null) {
                  ServiceRequestResponse serviceRequestResponse =
                      state.response;
                  if (serviceRequestResponse.data?.isNewTicket == true) {
                    context.goNamed(
                        sr_routes.Routes.requestAcknowledgeScreen.name,
                        extra: state.response);
                  } else {
                    List<String>? serviceRequestList =
                        state.response.data?.oldTickets ?? [];
                    if (serviceRequestList.isNotEmpty) {
                      ServiceRequestResponse serviceRequestResponse =
                          state.response;
                      context.pushNamed(
                          sr_routes.Routes.serviceTicketExist.name,
                          extra: serviceRequestResponse);
                    } else {
                      showSnackBar(
                          context: context,
                          message: state.response.message ??
                              getString(msgSomethingWentWrong));
                    }
                  }
                } else {
                  showSnackBar(
                      context: context,
                      message: state.response.message ??
                          getString(msgSomethingWentWrong));
                }
              } else if (state is ServiceRequestFailureState) {
                showSnackBar(context: context, message: state.error.toString());
              }
            },
            child: MFGradientBackground(
              child: Column(
                children: [
                  ..._getWidgetsBasedOnDues(),
                  if (widget.isDues == true) const Spacer(),
                  if (widget.isDues == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            checkColor:
                                Theme.of(context).scaffoldBackgroundColor,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5.0),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {})
                                ])),
                          ),
                        )
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                      builder: (context, srState) {
                        return BlocConsumer<LoanRefundCubit, LoanRefundState>(
                          listener: (context, state) {
                            if (state is OverdueAdjustmentConsentDone) {
                              if (widget.isSRRequired) {
                                _callCreateServiceRequestAPI(context);
                              }
                            }
                          },
                          builder: (context, state) {
                            return MfCustomButton(
                              onPressed: () {
                                if (_isTNCSelected) {
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
                                      message: getString(
                                          lblRefundSelectTNCValidation));
                                }
                              },
                              leftIcon: ((state is LoanRefundLoadingState &&
                                          state.isLoading) ||
                                      (srState is ServiceRequestLoadingState && srState.isLoading))
                                  ? true
                                  : false,
                              text: getString(lblContinue),
                              outlineBorderButton: false,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      color: setColorBasedOnTheme(
                                          context: context,
                                          lightColor: AppColors.white,
                                          darkColor: AppColors.white),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  _getWidgetsBasedOnDues() {
    double totalOverAmountInAllLoans =
        LoanRefundViewModel.getTotalOverDueAmount(widget.loanList);
    if (widget.isDues == true) {
      return [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.loanData?.productCategory} | ${widget.loanData?.loanAccountNumber}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(widget.loanData?.productCategory ==
                    LoanType.personalLoan.value
                    ? widget.loanData?.totalAmount.toString() ?? ""
                    : widget.loanData?.vehicleRegistration ?? "",
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
                Text((widget.loanData?.excessAmount ?? 0).toString(),
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
                          for (var loan in (widget.loanList ?? []))
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
                        totalOverAmountInAllLoans.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        )
      ];
    } else {
      return [
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
                        "${widget.loanData?.productCategory} | ${widget.loanData?.loanAccountNumber}",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0)),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(widget.loanData?.productName ?? "",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblEmisPaid),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0)),
                    Text(
                        "${widget.loanData?.totalEmiPaid} / ${widget.loanData?.loanTenure}",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblExcessAmount),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0)),
                    Text((widget.loanData?.excessAmount ?? "").toString(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblUpcomingEMI),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0)),
                    Text((widget.loanData?.installmentAmount ?? "").toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0)),
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
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getString(lblRefundApplicable),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0),
                              ),
                              Text(
                                getString(lbl_after_adjustment),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, bottom: 10.0),
                            child: SvgPicture.asset(
                              ImageConstant.info,
                              height: 12.6.h,
                              width: 12.6.v,
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).primaryColor,
                                  BlendMode.srcIn),
                            ),
                          ),
                        ],
                      ),
                      Text(totaRefundAmount.toStringAsFixed(0)),
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
        widget.isSRRequired
            ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                        controller: remarkTextController,
                        decoration: InputDecoration(
                          labelText: getString(msgRemarksOptional),
                          hintText: getString(msgRemarksOptional),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffA1626B)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffA1626B),
                            ),
                          ),
                        ))
                  ],
                ),
              )
            : const Spacer(),
        const InfoCard(
          infoMessage: lblRefundReviewInfoMsg,
          height: 96,
          width: double.infinity,
        )
      ];
    }
  }

  _callCreateServiceRequestAPI(BuildContext context) {
    var request = SRRequest(
      superAppId: getSuperAppId(),
      customerId: widget.loanData?.cif,
      customerName: getUserName(),
      contractId: widget.loanData?.loanAccountNumber,
      lob: widget.loanData?.lob,
      mobileNumber: widget.loanData?.mobileNumber,
      productName: widget.loanData?.productName,
      description: widget.srDescription,
      sourceSystem: widget.loanData?.sourceSystem,
      productCategory: widget.loanData?.productCategory,
      refundStatus: widget.refundStatus,
      caseType: 31,
      category: "Existing Loan",
      subCategory: "Refund",
      documentLink: "",
      channel: "App",
      srType: "Request",
    );

    BlocProvider.of<ServiceRequestCubit>(context)
        .generateServiceRequest(request);
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
}
