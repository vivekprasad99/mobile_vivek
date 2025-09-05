import 'package:core/config/constant.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/data/models/get_foreclosure_details.dart';
import 'package:loan/features/foreclosure/data/models/get_fund_of_source_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/data/models/get_reasons_response.dart';
import 'package:loan/features/foreclosure/data/models/service_request.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';
import 'package:loan/features/foreclosure/presentation/foreclosure_wireframe/widgets/custom_drop_down.dart';
import 'package:loan/features/foreclosure/presentation/foreclosure_wireframe/widgets/offers_screen.dart';
import 'package:payment_gateway/features/domain/models/payment_model.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_type.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import '../../../data/models/get_offers_response.dart';
import 'package:payment_gateway/config/routes/route.dart' as payment_routes;
import 'package:service_ticket/config/routes/route.dart' as service_request;

// ignore_for_file: must_be_immutable
class ForeclosureDetailScreen extends StatefulWidget {
  ForeclosureDetailScreen({
    super.key,
    this.loanDetails,
  });

  LoanDetails? loanDetails;

  @override
  State<ForeclosureDetailScreen> createState() =>
      _ForeclosureDetailScreenState();
}

class _ForeclosureDetailScreenState extends State<ForeclosureDetailScreen> {
  String? selectedValue = "";

  bool showMoreDetails = false;
  ForeclosureDetails? foreclosureDetails;
  Reasons? selectedReason;
  List<FundOfSource>? fundOfSource;

  @override
  Widget build(BuildContext buildContext) {
    GetLoanDetailsRequest foreclosureDetailRequest = GetLoanDetailsRequest(
        loanNumber: widget.loanDetails?.loanNumber, //
        sourceSystem: widget.loanDetails?.sourceSystem, //
        productCategory: widget.loanDetails?.productCategory); //

    BlocProvider.of<ForeclosureCubit>(buildContext)
        .getForeClosureDetails(foreclosureDetailRequest);

    GetLoanDetailsRequest request = GetLoanDetailsRequest();
    BlocProvider.of<ForeclosureCubit>(context).getReasons(request);
    BlocProvider.of<ForeclosureCubit>(context).getFundOfSource(request);

    return BlocListener<ForeclosureCubit, ForeclosureState>(
      listener: (context, state) {
        if (state is GetOffersSuccessState) {
          List<Offers>? offers = state.response.data;
          if (offers != null && offers.isNotEmpty) {
            _dialogBuilder(
                context, offers, widget.loanDetails!, selectedReason);
          }
        } else if (state is PreApprovedOffersSuccessState) {
          List<Offers>? preApprovedOffers = state.response.data;
          if (preApprovedOffers!.isNotEmpty) {
            _dialogBuilder(context, preApprovedOffers, widget.loanDetails!,
                selectedReason);
          }
        } else if (state is CreateForeclosureSRSuccessState) {
            // Check if the response code is success and data is not null
            if (state.response.code == AppConst.codeSuccess &&
                state.response.data != null) {
              ServiceRequestResponse serviceRequestResponse =
                  state.response;
              if (serviceRequestResponse.data?.isNewTicket == true) {
                context.goNamed(
                  service_request.Routes.requestAcknowledgeScreen.name,
                  extra: state.response,
                );
              } else {
                List<String>? serviceRequestList =
                    state.response.data?.oldTickets ?? [];
                if (serviceRequestList.isNotEmpty) {
                  context.pushNamed(
                    service_request.Routes.serviceTicketExist.name,
                    extra: serviceRequestResponse,
                  );
                } else {
                  showSnackBar(
                    context: context,
                    message: state.response.message ??
                        getString(msgSomethingWentWrong),
                  );
                }
              }
            } else {
              showSnackBar(
                context: context,
                message: state.response.message ??
                    getString(msgSomethingWentWrong),
              );
            }

        } else if (state is GetForeClosureDetailsFailureState) {
          showSnackBar(
              context: context, message: getString(msgSomethingWentWrong));
        }
      },
      child: Scaffold(
          appBar: customAppbar(
            context: buildContext,
            title: getString(lblPaymentDetails),
            onPressed: () {
              Navigator.pop(buildContext);
            },

          ),
          body: MFGradientBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildForClosureBasicDetails(widget.loanDetails, buildContext),
                SizedBox(height: 10.v),
                Divider(
                  color: Theme.of(buildContext).dividerColor,
                ),
                SizedBox(height: 10.v),
                Text(
                  getString(msgForeclosureAmount),
                  style: Theme.of(buildContext).textTheme.bodySmall?.copyWith(
                        letterSpacing: 0.5,
                      ),
                ),
                SizedBox(height: 4.v),
                BlocBuilder<ForeclosureCubit, ForeclosureState>(
                  builder: (context, state) {
                    if (state is GetForeClosureDetailsSuccessState) {
                      foreclosureDetails = state.response.data;
                    }
                    return Text(
                        "₹${foreclosureDetails?.totalAmountToPay ?? 0} ",
                        style: Theme.of(buildContext)
                            .textTheme
                            .titleLarge
                            ?.copyWith(letterSpacing: 0.16, fontSize: 20));
                  },
                ),
                SizedBox(height: 10.v),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10, top: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8.h,
                      ),
                      color: Theme.of(buildContext).cardColor),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber,
                          color: Color.fromRGBO(230, 134, 0, 1)),
                      SizedBox(width: 10.h),
                      Text(
                        getString(msgDisclaimerPaymentForeclosure),
                        style: Theme.of(buildContext).textTheme.labelSmall,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.v),
                _buildDropDown(showMoreDetails),
              ],
            ),
          )),
    );
  }

  _buildDropDown(bool showMoreDetails) {
    String buttonTitle = "";
    return BlocBuilder<ForeclosureCubit, ForeclosureState>(
        builder: (context, state) {
      if (state is OfferRejectedState) {
        buttonTitle = getString(lblPaymentReceipt);
      }
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ForeclosureCubit, ForeclosureState>(
                buildWhen: (previous, current) =>
                    current is GetReasonsSuccessState,
                builder: (context, state) {
                  if (state is GetReasonsSuccessState) {
                    List<Reasons>? reason = state.response;
                    return CustomDropDown(
                      themeData: Theme.of(context).copyWith(
                        canvasColor: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.white,
                          darkColor: AppColors.shadowDark,
                        ),
                      ),
                      // width: 328.h,
                      filled: false,

                      borderDecoration: UnderlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(
                          color: Theme.of(context).unselectedWidgetColor,
                          width: 2,
                        ),
                      ),
                      icon: Center(
                          child: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).primaryColor,
                      )),
                      hintText: getString(msgSelectReason),
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: AppColors.secondaryLight5,
                              )),
                      items: reason,
                      onChanged: (value) {
                        context
                            .read<ForeclosureCubit>()
                            .selectReason(value, value.name!);
                        selectedValue = value.name;
                        selectedReason = value;
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
            SizedBox(height: 18.v),
            BlocBuilder<ForeclosureCubit, ForeclosureState>(
              builder: (context, state) {

                if (state is GetForeClosureDetailsSuccessState) {
                  foreclosureDetails = state.response.data;
                } else if (state is FundOfSourceSuccessState) {
                  fundOfSource = state.response;
                }

                if (selectedReason?.id != null && foreclosureDetails != null) {
                  return showPriceBreakupWidget(
                      (selectedReason?.id ?? 0),
                      widget.loanDetails ?? LoanDetails(),
                      state is OfferRejectedState ? true : false,
                      state is ShowDetailsState ? true : false,
                      showMoreDetails,
                      foreclosureDetails,
                      fundOfSource);
                }
                return Container();
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: CustomElevatedButton(
                    height: 42.v,
                    width: 328.h,
                    text: getString(lblProceed),
                    leftIcon: (state is LoadingState && state.isloading)
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.h),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Container(),
                    onPressed: () {
                      //Proceed button scenario
                      if (selectedReason?.id == 2 && buttonTitle.isEmpty) {
                        //show FD offers
                        _callOfferAPI(context);
                      } else {
                        if (widget.loanDetails!.isRuleOnePassed == true) {
                          if (widget.loanDetails?.loanNumber == null) {
                            showSnackBar(
                                context: context,
                                message: getString(lblErrorGeneric));
                            return;
                          }
                          context.pushNamed(
                            payment_routes.Routes.choosePaymentMode.name,
                            extra: PaymentModel(
                                productType: context
                                    .read<ForeclosureCubit>()
                                    .getPaymentProductType(
                                        productCategory: widget
                                            .loanDetails?.productCategory),
                                sourceSystem: context
                                    .read<ForeclosureCubit>()
                                    .getSourceSystem(
                                        sourceSystem:
                                            widget.loanDetails?.sourceSystem),
                                productNumber: widget.loanDetails!.loanNumber!,
                                paymentType: PaymentType.forceclose,
                                fromScreen: 'foreclosure',
                                totalPaybleAmount:
                                    widget.loanDetails!.totalPendingAmount ??
                                        '1.0',
                                description:
                                    "Foreclosure | ${widget.loanDetails?.productName}"),
                          );
                        } else {
                          //show pre-approved offers
                          _callPreApprovedOfferAPI(context);
                        }
                      }
                    },
                    buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: selectedValue!.isNotEmpty
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).disabledColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.h),
                        )),
                    buttonTextStyle: selectedValue!.isNotEmpty
                        ? Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.white)
                        : Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).unselectedWidgetColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

Widget showPriceBreakupWidget(
    int selectedReasonId,
    LoanDetails loanDetails,
    bool isOfferRejected,
    bool isShowMoreState,
    bool showMoreDetails,
    ForeclosureDetails? foreClosureDetails,
    List<FundOfSource>? fundOfSource) {
  //show breakups only if reason is not "Sufficient fund available with me"
  if ((loanDetails.isRuleOnePassed == true && selectedReasonId != 2) ||
      isOfferRejected ||
      isShowMoreState) {
    return BlocBuilder<ForeclosureCubit, ForeclosureState>(
      buildWhen: (previous, current) =>
          current is ShowDetailsState || current is FundOfSourceSuccessState,
      builder: (context, state) {
        return Column(children: [
          _buildPriceBreakups(
              showMoreDetails, foreClosureDetails, context, state),
          showSourceOfFundsWidget(context, fundOfSource)
        ]);
      },
    );
  } else {
    return Container();
  }
}

Widget showSourceOfFundsWidget(
    BuildContext context, List<FundOfSource>? fundOfSource) {
  return CustomDropDown(
    themeData: Theme.of(context).copyWith(
      canvasColor: setColorBasedOnTheme(
        context: context,
        lightColor: AppColors.white,
        darkColor: AppColors.shadowDark,
      ),
    ),
    // width: 328.h,
    filled: false,

    borderDecoration: UnderlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(
        color: Theme.of(context).unselectedWidgetColor,
        width: 2,
      ),
    ),
    icon: Center(
        child: Icon(
      Icons.arrow_drop_down,
      color: Theme.of(context).primaryColor,
    )),
    hintText: getString(lblSourceOfFunds),
    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.primaryLight,
          darkColor: AppColors.secondaryLight5,
        )),
    items: fundOfSource,
    onChanged: (value) {},
  );
}

Widget _buildForClosureBasicDetails(
    LoanDetails? loanDetails, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "${loanDetails?.productCategory.toString()} | ",
                style: Theme.of(context).textTheme.titleSmall),
            TextSpan(
                text: loanDetails?.loanNumber.toString(),
                style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
        textAlign: TextAlign.left,
      ),
      SizedBox(height: 3.v),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getString(loanAmount),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.5)),
          Text(" ₹${loanDetails?.totalAmount.toString()}",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.5)),
        ],
      )
    ],
  );
}

/// Section Widget

Widget _buildPriceBreakups(
    bool showMoreDetails,
    ForeclosureDetails? foreClosureDetails,
    BuildContext context,
    ForeclosureState state) {
  List<Charges>? charges = foreClosureDetails?.chargesList();

  if (state is ShowDetailsState) {
    showMoreDetails = state.showDetails;
  }
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5.h, vertical: 5.v),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          8.h,
        ),
        color: Theme.of(context).cardColor),
    child: Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0, bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(lblBreakUp),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: 0.16),
          ),
          SizedBox(height: 10.v),
          _buildAmountInRupees(context,
              amountInRupees: getString(lblPrincipal),
              price: (foreClosureDetails?.principal).toString()),
          SizedBox(height: 10.v),
          _buildAmountInRupees(
            context,
            amountInRupees: getString(lblInterest),
            price: (foreClosureDetails?.interest).toString(),
          ),
          SizedBox(height: 10.v),
          _buildAmountInRupees(
            context,
            amountInRupees: getString(lblForeclosureCharges),
            price: (foreClosureDetails?.foreclosureCharges).toString(),
          ),
          SizedBox(height: 15.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  context
                      .read<ForeclosureCubit>()
                      .showDetails(!showMoreDetails);
                },
                child: Row(
                  children: [
                    Text(
                      'Charges',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(letterSpacing: 0.5),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "details",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.secondaryLight,
                            darkColor: AppColors.secondaryLight5,
                          ),
                          fontWeight: FontWeight.w400,
                          fontSize: 11),
                    ),
                    Icon(
                      showMoreDetails ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.secondaryLight,
                      size: 14,
                    ),
                  ],
                ),
              ),
              Text(
                _sumOtherCharges(charges),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(letterSpacing: 0.5),
              ),
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          if (showMoreDetails) ..._otherCharges(context, charges),
          Divider(
            color: AppColors.backgroundLightGradient2,
            thickness: 2.v,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    getString(lblTotal),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(letterSpacing: 0.1),
                  ),
                  SizedBox(
                    width: 10.v,
                  ),
                ],
              ),
              Text(
                (foreClosureDetails?.totalAmountToPay ?? 0).toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildAmountInRupees(
  BuildContext context, {
  required String amountInRupees,
  required String price,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(
            amountInRupees,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(letterSpacing: 0.5),
          ),
          SizedBox(
            width: 10.v,
          ),
        ],
      ),
      Text(price, style: Theme.of(context).textTheme.labelSmall),
    ],
  );
}

String _sumOtherCharges(List<Charges>? charges) {
  double? total = charges?.fold(0,
      (double? sum, item) => (sum ?? 0.0) + (double.parse(item.amount ?? "")));
  return (total ?? 0.0).toString();
}

List<Widget> _otherCharges(BuildContext context, List<Charges>? charges) {
  Iterable<Widget>? outsideCharges = charges?.map(
    (e) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(e.name!,
                    style: Theme.of(context).textTheme.bodySmall)),
            Text(e.amount!, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
      ],
    ),
  );
  return outsideCharges == null ? [] : outsideCharges.toList();
}


Future<void> _dialogBuilder(
  BuildContext mContext,
  List<Offers> offers,
  LoanDetails loanDetails,
  Reasons? selectedReason,
) {
  return showDialog<void>(
    context: mContext,
    builder: (BuildContext dialogContext) {
      return BlocProvider(
        create: (context) => di<ForeclosureCubit>(),
        child: Dialog.fullscreen(
          child: OffersScreen(
            loanDetails: loanDetails,
            offers: offers,
            offerContext: dialogContext,
            selectedReasonId: selectedReason?.id,
            onRejected: (dialogContext) {
              if (loanDetails.isRuleOnePassed == true) {
                if (selectedReason != null) {
                  BlocProvider.of<ForeclosureCubit>(mContext)
                      .updateStateAfterDismiss();
                }
              } else {
                //call Service Request API
                _callCreateServiceRequestAPI(mContext, loanDetails);
              }
            },
          ),
        ),
      );
    },
  );
}

_callCreateServiceRequestAPI(BuildContext context, LoanDetails loanDetails) {
  var request = ServiceRequest(
      superAppId: getSuperAppId(),
      caseType: CaseType.foreclosureCaseType,
      customerName: getUserName(),
      customerId: loanDetails.cif,
      contractId: loanDetails.loanNumber,
      lob: loanDetails.lob,
      productName: loanDetails.productName,
      productCategory: loanDetails.productCategory,
      mobileNumber: loanDetails.mobileNumber,
      sourceSystem: loanDetails.sourceSystem,
      channel: "App",
      description: "Foreclosure");

  BlocProvider.of<ForeclosureCubit>(context).createForeclosureSR(request);
}

_callOfferAPI(BuildContext context) {
  GetLoanDetailsRequest request = GetLoanDetailsRequest();
  BlocProvider.of<ForeclosureCubit>(context).getOffers(request);
}

_callPreApprovedOfferAPI(BuildContext context) {
  GetLoanDetailsRequest request = GetLoanDetailsRequest();
  BlocProvider.of<ForeclosureCubit>(context).getPreApprovedOffers(request);
}
