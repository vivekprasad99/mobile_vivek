import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/images.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/string_resource/config.dart';
import 'package:core/utils/size_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product/presentation/utils/strings_constants.dart';
import '../../data/models/product_feature_response.dart';
import 'package:lead_generation/config/routes/route.dart' as lead_gen;

class ProductOffersSlider extends StatefulWidget {
  const ProductOffersSlider({super.key, required this.productBanner});

  final List<ProductBanner> productBanner;

  @override
  State<ProductOffersSlider> createState() => _ProductOffersSliderState();
}

class _ProductOffersSliderState extends State<ProductOffersSlider> {
  final CarouselController carouselController = CarouselController();
  int carouselIndex = 0;

  @override
  void initState() {
    super.initState();
    late final String ucic = getUCIC();
    if (ucic.isEmpty) {
      for (ProductBanner e in widget.productBanner) {
        if (e.link?.contains("vehicle_top_up") ?? false) {
          widget.productBanner.remove(e);
        }
        if (e.link?.contains("personal_top_up") ?? false) {
          widget.productBanner.remove(e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayBanners = isCustomer()
        ? widget.productBanner
            .where((banner) => !banner.title!.contains(StringsConstants.mobilelink))
            .toList()
        : widget.productBanner;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8.h)),
              child: CarouselSlider(
                  items: displayBanners
                      .map((item) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 12.h, left: 12.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200.h,
                                      child: Text(
                                        item.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 3.v),
                                    SizedBox(
                                      width: 200.h,
                                      child: Text(item.subTitle!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                    ),
                                    SizedBox(height: 12.v),
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Text(
                                            getString(lblProductFeatureAvailNow),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .highlightColor),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Theme.of(context)
                                                .highlightColor,
                                            size: 18,
                                            weight: 700,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        // context.pushNamed(name);
                                        if (item.link?.contains(
                                                "vehicle_top_up_offer") ??
                                            false) {
                                          context.pushNamed(
                                              lead_gen
                                                  .Routes.leadGeneration.name,
                                              pathParameters: {
                                                'leadType': "vehicle_top_up",
                                              });
                                        } else if (item.link?.contains(
                                                "personal_top_up_offer") ??
                                            false) {
                                          context.pushNamed(
                                              lead_gen
                                                  .Routes.leadGeneration.name,
                                              pathParameters: {
                                                'leadType': "personal_top_up",
                                              });
                                        } else if (item.link?.contains(
                                                "internal:/pre_approved_offer") ??
                                            false) {
                                          context.pushNamed(
                                              lead_gen
                                                  .Routes.leadGeneration.name,
                                              pathParameters: {
                                                'leadType': "personal",
                                              });
                                        } else if (item.link?.contains(
                                                "new_car_loan_offer") ??
                                            false) {
                                          context.pushNamed(
                                              lead_gen
                                                  .Routes.leadGeneration.name,
                                              pathParameters: {
                                                'leadType': "new_car",
                                              });
                                        } else if (item.link
                                                ?.contains("home_loan_offer") ??
                                            false) {
                                          context.pushNamed(
                                              lead_gen
                                                  .Routes.leadGeneration.name,
                                              pathParameters: {
                                                'leadType': "home",
                                              });
                                        }
                                        // if(item.)
                                      },
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              item.image != null && item.image!.isNotEmpty
                                  ? Image.network(
                                      width: 118.h,
                                      height: double.infinity,
                                      item.image.toString(),
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          Images.offersImage,
                                          fit: BoxFit.fill,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      Images.offersImage,
                                      fit: BoxFit.fill,
                                    ),
                            ],
                          ))
                      .toList(),
                  options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    aspectRatio: 3,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        carouselIndex = index;
                      });
                    },
                  )),
            ),
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: displayBanners.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => carouselController.animateToPage(entry.key),
                      child: Container(
                        width: carouselIndex == entry.key ? 10 : 10,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: carouselIndex == entry.key
                                ? Theme.of(context).primaryColor
                                : AppColors.primaryLight4),
                      ),
                    );
                  }).toList(),
                ))
          ],
        )
      ],
    );
  }
}
