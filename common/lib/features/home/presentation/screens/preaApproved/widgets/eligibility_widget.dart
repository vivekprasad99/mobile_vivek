import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:common/features/home/presentation/cubit/landing_page_state.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class OfferEligibility extends StatelessWidget {
  const OfferEligibility({super.key, this.offerTabDetails});

  final TabDetails? offerTabDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingPageCubit, LandingPageState>(
      buildWhen: (context, state) {
        return true;
      },
      builder: (context, state) {
        return Column(
          children: [
            ListView.builder(
                itemCount: offerTabDetails?.eligibilityList?.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 225.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ImageConstant.verifiedImage,
                          height: 16.adaptSize,
                          width: 16.adaptSize,
                          colorFilter: ColorFilter.mode(
                              setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.primaryLight5),
                              BlendMode.srcIn),
                        ),
                        SizedBox(
                          width: 10.v,
                        ),
                        Text(
                            offerTabDetails?.eligibilityList?[index]
                                    .toString() ??
                                '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontSize: 11.adaptSize,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor,),),
                        SizedBox(
                          height: 25.h,
                        ),
                      ],
                    ),
                  );
                },),
            SizedBox(
              height: 10.h,
            ),
          ],
        );
      },
    );
  }
}
