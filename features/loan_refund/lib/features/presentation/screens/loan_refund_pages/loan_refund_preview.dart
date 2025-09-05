import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_refund/features/presentation/screens/widgets/custom_card.dart';
import 'package:loan_refund/features/presentation/screens/widgets/info_card.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/data/models/sr_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';
import 'package:service_ticket/config/routes/route.dart' as sr_routes;
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
class LoanRefundPreview extends StatefulWidget {
  final LoanData loanData;
  final String srDescription;
  final String refundStatus;
  final double? revisedRefund;
  final bool? isDues;
  const LoanRefundPreview(
      {super.key,
      required this.loanData,
      required this.srDescription,
      required this.refundStatus,
      this.revisedRefund,
      this.isDues});

  @override
  State<LoanRefundPreview> createState() => _LoanRefundPreviewState();
}

class _LoanRefundPreviewState extends State<LoanRefundPreview> {

  TextEditingController remarkTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ServiceRequestCubit, ServiceRequestState>(
        listener: (context, state) {
          if (state is ServiceRequestSuccessState) {
            if (state.response.code == AppConst.codeSuccess &&
                state.response.data != null) {
              ServiceRequestResponse serviceRequestResponse = state.response;
              if (serviceRequestResponse.data?.isNewTicket == true) {
                context.goNamed(sr_routes.Routes.requestAcknowledgeScreen.name,
                    extra: state.response);
              } else {
                List<String>? serviceRequestList =
                    state.response.data?.oldTickets ?? [];
                if (serviceRequestList.isNotEmpty) {
                  ServiceRequestResponse serviceRequestResponse =
                      state.response;
                  context.pushNamed(sr_routes.Routes.serviceTicketExist.name,
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
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: customAppbar(
              context: context,
              title: getString(
                lblRefundReview,
              ),
              onPressed: () {
                context.pop();
              },
              actions: [
                HelpCommonWidget(categoryval: HelpConstantData.categoryRefund,subCategoryval: HelpConstantData.categoryRefund,)
              ]
            ),
            body: MFGradientBackground(
              child: Column(
                children: [
                  CustomCard(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.cardLight,
                        darkColor: AppColors.cardDark),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getString(msgLoanAccountNumber2),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0)),
                              Text(widget.loanData.loanAccountNumber!,
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
                              Text(widget.loanData.excessAmount.toString(),
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
                              Text( (widget.isDues ?? false) ? widget.loanData.installmentAmount.toString() : '-',
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
                                Theme.of(context).primaryColor,
                                BlendMode.srcIn),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: getString(lblRefundApplicable),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0),
                                      ),
                                      WidgetSpan(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: SvgPicture.asset(
                                            ImageConstant.info,
                                            height: 12.6.h,
                                            width: 12.6.v,
                                            colorFilter: ColorFilter.mode(
                                                Theme.of(context).primaryColor,
                                                BlendMode.srcIn),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(widget.revisedRefund.toString()),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                            controller: remarkTextController,
                            decoration: InputDecoration(
                              labelText: getString(msgRemarksOptional),
                              hintText: getString(msgRemarksOptional),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffA1626B)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffA1626B),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  const InfoCard(
                    infoMessage: lblRefundReviewInfoMsg,
                    height: 96,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                      builder: (context, state) {
                        return MfCustomButton(
                          onPressed: () {
                            _callCreateServiceRequestAPI(context);
                          },
                          leftIcon: (state is ServiceRequestLoadingState &&
                                  state.isLoading)
                              ? true
                              : false,
                          text: getString(lblRefundReviewCreateRequest),
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MfCustomButton(
                      onPressed: () {
                        context.pop();
                      },
                      text: getString(lblCancel),
                      outlineBorderButton: true,
                      textStyle: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                              color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.white),
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  _callCreateServiceRequestAPI(BuildContext context) {
    var request = SRRequest(
      superAppId: getSuperAppId(),
      customerId: getUCIC(),
      contractId: widget.loanData.loanAccountNumber,
      lob: widget.loanData.lob,
      mobileNumber: widget.loanData.mobileNumber,
      productName: widget.loanData.productName,
      remarks: remarkTextController.text,
      description: widget.srDescription,
      sourceSystem: widget.loanData.sourceSystem,
      productCategory: widget.loanData.productCategory,
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
}
