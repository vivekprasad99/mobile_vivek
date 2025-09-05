import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_refund/config/routes/route.dart';

class LoanRefundServiceRequestSuccess extends StatelessWidget {
  const LoanRefundServiceRequestSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MFGradientBackground(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 116.0),
                      child: SvgPicture.asset(
                        ImageConstant.confirmationNumber,
                        height: 44.33.h,
                        width: 35.v,
                        colorFilter: ColorFilter.mode(
                            setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.primaryLight5),
                            BlendMode.srcIn),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        height: 80,
                        width: 328,
                        child: Text(
                          getString(lblServiceRequestGenerated),
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 32.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.cardLight,
                                darkColor: AppColors.cardDark),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.cardLight,
                            darkColor: AppColors.cardDark),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    ImageConstant.filledCheckCircle,
                                    height: 16.h,
                                    width: 16.v,
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context).primaryColor,
                                        BlendMode.srcIn),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    getString(lblServiceTicketNumber),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SvgPicture.asset(
                                    ImageConstant.imgCopy,
                                    height: 16.h,
                                    width: 16.v,
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context).primaryColor,
                                        BlendMode.srcIn),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                getString(lblServiceRequestContactoonMessage),
                                style: Theme.of(context).textTheme.labelMedium,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              homeButton(context)
            ],
          ),
        ),
      ),
    );
  }
}

Widget homeButton(BuildContext context) {
  return MfCustomButton(
    onPressed: () {
      context.pushNamed(Routes.loanRefund.name);
    },
    text: getString(lblHome),
    outlineBorderButton: false,
    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: const Color(0xffFFFFFF),
        fontWeight: FontWeight.w700,
        fontSize: 14.0),
  );
}
