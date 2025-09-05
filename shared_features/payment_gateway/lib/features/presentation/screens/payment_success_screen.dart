
import 'package:common/config/routes/app_route.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:common/features/rate_us/presentation/widget/rate_us_dialog_box.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_gateway/config/routes/route.dart';
import 'package:payment_gateway/features/presentation/cubit/payment_cubit.dart';
import 'package:payment_gateway/features/presentation/utils/payment_mode_enum.dart';
import 'package:payment_gateway/features/presentation/utils/services/payment_screen_feed_model.dart';
import 'package:payment_gateway/features/presentation/utils/services/services.dart';
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:common/features/rate_us/utils/helper/constant_data.dart';
// ignore_for_file: must_be_immutable
class PaymentSuccessScreen extends StatelessWidget {
  PaymentSuccessScreen({super.key, required this.paymentData});

  final PaymentStatusDataModel paymentData;

  bool showMoreDetails = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RateUsCubit, RateUsState>(
      listener: (context, state) {
        if (state is RateUsSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            if ((state.response.rateUsStatus ?? false) &&
                paymentData.paymentStatus) {
              showRateUsPopup(
                  context,
                  paymentData.fromScreen?.toLowerCase() == "foreclosure"
                      ? ConstantData.foreclosurePaymentCompleted
                      : (paymentData.fromScreen == 'loan_cancellation'
                          ? ConstantData.loanCancellationPaymentCompleted
                          : ConstantData.payment));
            } else {
              while (AppRoute.router.canPop()) {
                AppRoute.router.pop();
              }
              AppRoute.router.pushReplacementNamed(
                common_routes.Routes.home.name,
              );
            }
          } else {
            toastForFailureMessage(
                context: context,
                msg: getString(
                    state.response.responseCode ?? msgPaymentSomethingWentWrong));
          }
        } else if (state is RateUsFailureState) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure));
        }
      },
      child: PopScope(
        canPop: false,
        child: SafeArea(
            child: Scaffold(
          body: MFGradientBackground(
            verticalPadding: 0,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 84.v,
                        ),
                        SvgPicture.asset(
                          paymentData.imagePath,
                          height: paymentData.topIconHeight.v,
                          width: paymentData.topIconWidth.h,
                          colorFilter: ColorFilter.mode(
                              setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.secondaryLight,
                                  darkColor: AppColors.primaryLight5),
                              BlendMode.srcIn),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            paymentData.title,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        BlocBuilder<PaymentGatewayCubit, PaymentGatewayState>(
                          buildWhen: (previous, current) =>
                              current is ShowTransactionMoreDetailsState,
                          builder: (context, state) {
                            if (state is ShowTransactionMoreDetailsState) {
                              showMoreDetails = state.showMoreDetails;
                            }
                            return Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            inputFiledAmountFormatter(
                                                paymentData.amount),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              context
                                                  .read<PaymentGatewayCubit>()
                                                  .setTransactionMoreDetailsState(
                                                      !showMoreDetails);
                                            },
                                            child: Icon(
                                              showMoreDetails
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 8.h,
                                      ),
                                      Row(
                                        children: [
                                          if (paymentData.paymentStatusIcon !=
                                              null)
                                            SvgPicture.asset(
                                              paymentData.paymentStatusIcon!,
                                              height: 16.v,
                                              width: 16.h,
                                              colorFilter: ColorFilter.mode(
                                                  paymentData.paymentStatus
                                                      ? AppColors
                                                          .successGreenColor
                                                      : AppColors
                                                          .textFieldErrorColor,
                                                  BlendMode.srcIn),
                                            ),
                                          if (paymentData.paymentStatusIcon !=
                                              null)
                                            SizedBox(
                                              width: 5.h,
                                            ),
                                          if (paymentData.paymentStausMsg !=
                                              null)
                                            Text(
                                              paymentData.paymentStausMsg!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16.v,
                                      ),
                                      Text(paymentData.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                      SizedBox(
                                        height: showMoreDetails ? 12.v : 16.v,
                                      ),
                                      if (showMoreDetails) ...[
                                        Divider(
                                          height: 1.v,
                                          color: AppColors.primaryLight6,
                                        ),
                                        SizedBox(
                                          height: 16.v,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  paymnetDescriptionCards(
                                                      context,
                                                      getString(
                                                          lblTransactionId),
                                                      paymentData
                                                          .transactionId),
                                                  SizedBox(
                                                    height: 16.v,
                                                  ),
                                                  paymnetDescriptionCards(
                                                      context,
                                                      getString(
                                                          lblModeOfPayment),
                                                      paymentData
                                                          .modeOfPayment),
                                                  SizedBox(
                                                    height: 16.v,
                                                  ),
                                                  paymnetDescriptionCards(
                                                      context,
                                                      getString(lblPaymentCustomerName),
                                                      paymentData.customerName),
                                                  if (paymentData
                                                      .bankTransactionID
                                                      .isNotEmpty) ...[
                                                    SizedBox(
                                                      height: 16.v,
                                                    ),
                                                    paymnetDescriptionCards(
                                                        context,
                                                        getString(
                                                            lblBankTransactionId),
                                                        paymentData
                                                            .bankTransactionID),
                                                  ]
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  paymnetDescriptionCards(
                                                      context,
                                                      getString(
                                                          lblLoanNumberPayment),
                                                      paymentData.loanNumber),
                                                  SizedBox(
                                                    height: 16.v,
                                                  ),
                                                  paymnetDescriptionCards(
                                                      context,
                                                      getString(
                                                          lblPaymentMadeOn),
                                                      '${dateFormatter(paymentData.paymentMadeOn)} at ${timeFormatter(paymentData.paymentMadeOn)}'),
                                                  if (paymentData
                                                      .purposeOfPayment
                                                      .isNotEmpty) ...[
                                                    SizedBox(
                                                      height: 16.v,
                                                    ),
                                                    paymnetDescriptionCards(
                                                        context,
                                                        getString(
                                                            lblPurposeOfPayment),
                                                        paymentData.purposeOfPayment ==
                                                                "EMI"
                                                            ? getString(
                                                                lblEMIPayment)
                                                            : paymentData
                                                                .purposeOfPayment),
                                                  ],
                                                  if (paymentData
                                                          .remainingAmount !=
                                                      null && paymentData.paymentStatus) ...[
                                                    SizedBox(
                                                      height: 16.v,
                                                    ),
                                                    paymnetDescriptionCards(
                                                        context,
                                                        getString(
                                                            lblInstallmentPending),
                                                        rupeeFormatter(paymentData
                                                                .remainingAmount ??
                                                            '0')),
                                                  ]
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.v,
                                        ),
                                      ],
                                    ],
                                  ),
                                ));
                          },
                        ),
                        SizedBox(
                          height: 16.v,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            downloadShareActionWidget(
                                context,
                                ImageConstant.downloadIcon,
                                getString(lblDownload), () {
                              paymentData.actionsType = ActionType.download;
                              context.pushNamed(Routes.paymentReceipt.name,
                                  extra: paymentData);
                            }),
                            SizedBox(
                              width: 16.h,
                            ),
                            downloadShareActionWidget(
                                context, null, getString(lblShare), () {
                              paymentData.actionsType = ActionType.share;
                              context.pushNamed(Routes.paymentReceipt.name,
                                  extra: paymentData);
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //MY-TODO - remove this condition when transaction history ready for integration.
                if ("Go to payment history" != paymentData.primaryButtonTitle)
                  MfCustomButton(
                    outlineBorderButton: false,
                    onPressed: paymentData.primaryButtonClick ?? () {},
                    text: paymentData.primaryButtonTitle,
                  ),

                SizedBox(
                  height: 16.v,
                ),
                MfCustomButton(
                  outlineBorderButton: true,
                  onPressed: () {
                    checkLastRatingDate(
                        context,
                        paymentData.fromScreen?.toLowerCase() == "foreclosure"
                            ? ConstantData.foreclosurePaymentCompleted
                            : (paymentData.fromScreen == 'loan_cancellation'
                                ? ConstantData.loanCancellationPaymentCompleted
                                : ConstantData.payment));
                  },
                  text: paymentData.secondaryButtonTitle,
                ),

                SizedBox(
                  height: 16.v,
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget downloadShareActionWidget(BuildContext context, String? iconPath,
      String title, void Function() ontap) {
    return InkWell(
      onTap: ontap,
      child: Row(
        children: [
          iconPath == null
              ? Icon(
                  Icons.share_outlined,
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.primaryLight5),
                  size: 16,
                )
              : SvgPicture.asset(
                  iconPath,
                  height: 18.v,
                  width: 18.h,
                  colorFilter: ColorFilter.mode(
                      setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.primaryLight5),
                      BlendMode.srcIn),
                ),
          SizedBox(
            width: 8.h,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.primaryLight5)),
          )
        ],
      ),
    );
  }

  Column paymnetDescriptionCards(
      BuildContext context, String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          desc,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  void checkLastRatingDate(BuildContext context, String featureType) async {
    RateUsRequest rateUsRequest =
        RateUsRequest(superAppId: getSuperAppId(), feature: featureType);
    BlocProvider.of<RateUsCubit>(context).getRateUs(rateUsRequest);
  }

  void showRateUsPopup(BuildContext context, String featureType) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => di<RateUsCubit>(),
          child: RateUsDialogBox(
            featureType,
            onTap: (BuildContext dialogContex) {
              Navigator.of(dialogContex).pop();
              while (AppRoute.router.canPop()) {
                AppRoute.router.pop();
              }
              AppRoute.router.pushReplacementNamed(
                common_routes.Routes.home.name,
              );
            },
          ),
        );
      },
    );
  }
}
