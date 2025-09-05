import 'package:common/config/routes/app_route.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_outline_button.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/config/routes/route.dart';
import 'package:lead_generation/config/routes/route.dart' as lead_gen;
import 'package:loan/features/loan_cancellation/data/models/create_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_offers_response.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';
import 'package:loan/features/loan_cancellation/presentation/loan_cancellation_wireframe/widgets/offer_slider_widget.dart';

class LoanCancellationOfferScreen extends StatelessWidget {
  final LoanCancelItem loanDetails;
  const LoanCancellationOfferScreen({super.key, required this.loanDetails});

  @override
  Widget build(BuildContext context) {
    context.read<LoanCancellationCubit>().getOffers();
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: "",
          onPressed: () {
            context.pop();
          }),
      body: BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is LoanCancellationgetOffersSuccessState) {
            return MFGradientBackground(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      getString(msgYouHaveASpecial),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 32.v,
                    ),
                    if (state.response.data?.isNotEmpty ?? false)
                      state.response.data!.length == 1
                          ? singleOfferCard(context, state.response.data!.first)
                          : OfferSliderDemo(
                              offersCard: state.response.data
                                      ?.map(
                                          (e) => multipleOfferCard(context, e))
                                      .toList() ??
                                  []),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
        builder: (context, state) {
          if (state is LoanCancellationgetOffersSuccessState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOutlinedButton(
                  height: 48.v,
                  text: getString(msgProceedWithLoanCancel),
                  margin: EdgeInsets.only(right: 15.h, left: 15.h),
                  buttonStyle: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                  ),
                  buttonTextStyle: TextStyle(
                    fontSize: AppDimens.titleSmall,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5),
                  ),
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) => WillPopScope(
                        onWillPop: () => Future.value(false),
                        child: Center(
                          child: BlocProvider(
                            create: (context) => di<LoanCancellationCubit>()
                              ..createSR(
                                CreateSrRequest(
                                  contractId: loanDetails.loanAccountNumber,
                                  customerId: loanDetails.ucic,
                                  lob: loanDetails.lob,
                                  productCategory: loanDetails.productCategory,
                                  productName: loanDetails.productName,
                                  mobileNumber: loanDetails.mobileNumber,
                                  category: "Loan application related",
                                  subCategory: "Loan Cancellation",
                                  channel: "App",
                                  requestType: "Request",
                                  srType: "Request",
                                  sourceSystem: loanDetails.sourceSystem,
                                  caseType: 40,
                                  customerName: getUserName(),
                                ),
                              ),
                            child: BlocListener<LoanCancellationCubit,
                                LoanCancellationState>(
                              listener: (context, state) {
                                if (state is CreateSrSuccessState) {
                                  Navigator.of(context).pop();
                                  if (state.response.code ==
                                      AppConst.codeSuccess) {
                                    AppRoute.router.pushNamed(
                                        Routes
                                            .loanCancelServiceTicketScreen.name,
                                        extra: state.response.data);
                                  } else {
                                    toastForFailureMessage(
                                        context: context,
                                        msg: getString(msgLcMsgSomethingWentWrong));
                                  }
                                } else if (state is CreateSrFailureState) {
                                  Navigator.of(context).pop();
                                  toastForFailureMessage(
                                      context: context,
                                      msg: getString(msgLcMsgSomethingWentWrong));
                                }
                              },
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Container singleOfferCard(BuildContext context, Offers offer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).dividerColor,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(
              223,
              122,
              121,
              1,
            ),
            Color.fromRGBO(255, 255, 255, 1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          offer.image == null
              ? SvgPicture.asset(ImageConstant.congratulationIcon)
              : Image.network(
                  headers: getCMSImageHeader(),
                  offer.image!,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(ImageConstant.offersIcon);
                  },
                ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8),
            child: Text(
              offer.title ?? "",
              style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Quicksand"),
            ),
          ),
          CustomElevatedButton(
            alignment: Alignment.center,
            height: 48.v,
            width: 156.h,
            text: getString(msgYesImInterested),
            margin: EdgeInsets.only(left: 15.h, right: 15.h),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            onPressed: () {
              context.pushNamed(lead_gen.Routes.leadGeneration.name,
                  pathParameters: {'leadType': "fixed_deposit"});
            },
          ),
        ],
      ),
    );
  }

  Widget multipleOfferCard(BuildContext context, Offers offer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: offer.image == null
              ? SvgPicture.asset(ImageConstant.offersIcon)
              : Image.network(
                  offer.image!,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(ImageConstant.offersIcon);
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 8),
          child: Text(
            offer.title ?? "",
            style: const TextStyle(
                fontSize: 22,
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w600,
                fontFamily: "Quicksand"),
          ),
        ),
        SizedBox(
          height: 46.v,
        ),
        CustomElevatedButton(
          alignment: Alignment.center,
          height: 48.v,
          width: 156.h,
          text: getString(msgYesImInterested),
          margin: EdgeInsets.only(left: 15.h, right: 15.h),
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.h),
            ),
          ),
          onPressed: () {
            context.pushNamed(lead_gen.Routes.leadGeneration.name,
                pathParameters: {'leadType': "PL"});
          },
        ),
      ],
    );
  }
}
