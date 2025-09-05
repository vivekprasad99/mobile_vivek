import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:common/features/rate_us/presentation/widget/rate_us_dialog_box.dart';
import 'package:common/features/rate_us/utils/helper/constant_data.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/routes/app_route_cubit.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noc/config/routes/route.dart';

class DeliverySuccessScreen extends StatelessWidget {
  final bool? isFromBranch;
  const DeliverySuccessScreen({super.key, this.isFromBranch});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocListener<RateUsCubit, RateUsState>(
          listener: (context, state) {
            if (state is RateUsSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                if (state.response.rateUsStatus ?? false) {
                  showRateUsPopup(context, ConstantData.nocSuccessfulDeliveryAddresss);
                } else {
                  context
                      .read<AppRouteCubit>()
                      .navigateToHomeScreen(from: Routes.deliverysuccess.path);
                }
              } else {
                toastForFailureMessage(
                    context: context,
                    msg: getString(
                        state.response.responseCode ?? msgNocMsgSomethingWentWrong));
              }
            } else if (state is RateUsFailureState) {
              showSnackBar(
                  context: context, message: getFailureMessage(state.failure));
            }
          },
          child: MFGradientBackground(
          horizontalPadding: 16,
          verticalPadding: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.v),
              SvgPicture.asset(
                ImageConstant.imgCongratulationIcon,
                height: 88.v,
                width: 48.h,
                colorFilter: ColorFilter.mode(
                    setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.primaryLight5),
                    BlendMode.srcIn),
              ),
              SizedBox(height: 17.v),
              Text(
                getString(lblThankYou),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 17.v),
              Container(
                height: 40.v,
                width: 328.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
                  child: Column(
                    children: [
                      Text(
                        getString(lblNocAddressThanks),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const Text(""),
                      if (isFromBranch == true)
                        Text(
                          getString(noteNocValidity),
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 17.v),
              SizedBox(height: 50.v),
              const Spacer(),
              SizedBox(height: 10.v),
              CustomElevatedButton(
                  text: getString(lblHome),
                  rightIcon: Container(
                    margin: EdgeInsets.only(left: 24.h),
                  ),
                  buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      )),
                  buttonTextStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.white),
                  onPressed: () {
                    checkLastRatingDate(context,ConstantData.nocSuccessfulDeliveryAddresss);
                  }),
              SizedBox(height: 20.v),
            ],
          ),
        ),
),
      ),
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
              context.read<AppRouteCubit>().navigateToHomeScreen(
                  from: Routes.deliverysuccess.path);
              toastForSuccessMessage(
                  context: context,
                  msg: getString(labelThankForYourFeedback),
                  bottomPadding: MediaQuery.of(context).size.height * 0.80);
            },
          ),
        );
      },
    );
  }
}
