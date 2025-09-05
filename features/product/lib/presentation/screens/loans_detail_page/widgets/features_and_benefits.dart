import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:core/utils/size_utils.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';
import 'package:product/presentation/cubit/product_feature_state.dart';
import 'package:product/presentation/utils/image_constant.dart';
import 'package:product/presentation/widgets/product_offers_slider.dart';

class FeaturesAndBenefits extends StatelessWidget {
  const FeaturesAndBenefits(this.tabDetails, {super.key});

  final TabDetails? tabDetails;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductFeatureCubit>(context).productFeature(
        productFeatureRequest: ProductFeatureRequest(ucic: getUCIC()));
    return BlocBuilder<ProductFeatureCubit, ProductFeatureState>(
      buildWhen: (context, state) {
        return true;
      },
      builder: (context, state) {
        List<ProductBanner> productBanners = [];
        if (state is ProductFeatureSuccessState) {
          productBanners =  state.response.productBanner ?? [];
        }
        return Column(
          children: [
            ListView.builder(
                itemCount: tabDetails?.featuresTitle?.length,
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
                        Text(tabDetails?.featuresTitle?[index].toString() ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontSize: 11.adaptSize,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor)),
                        Text(tabDetails?.featuresTitle?[index].toString() ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontSize: 11.adaptSize,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor)),
                        SizedBox(
                          height: 25.h,
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              color: AppColors.sliderColor,
            ),
            SizedBox(
              height: 18.h,
            ),
            ProductOffersSlider(productBanner: productBanners)
          ],
        );
      },
    );
  }
}
