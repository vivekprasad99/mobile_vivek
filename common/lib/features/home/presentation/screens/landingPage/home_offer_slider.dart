import 'package:core/config/resources/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lead_generation/config/routes/route.dart' as lead_gen;

import 'package:core/config/network/network_utils.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/utils/size_utils.dart';
import 'package:common/features/home/data/models/landing_page_banner_response.dart';
import 'package:core/utils/utils.dart';
import 'package:profile/config/routes/route.dart';

class HomeOffersSlider extends StatefulWidget {
  const HomeOffersSlider({super.key, required this.homeBanner});

  final List<Banners> homeBanner;

  @override
  State<HomeOffersSlider> createState() => _HomeOffersSliderState();
}

class _HomeOffersSliderState extends State<HomeOffersSlider> {
  final CarouselController carouselController = CarouselController();
  final ValueNotifier<int> carouselIndexNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final displayBanners = isCustomer()
        ? widget.homeBanner
            .where((banner) => !banner.screenRouter!.contains('settings'))
            .toList()
        : widget.homeBanner;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: CarouselSlider(
                items: displayBanners
                    .map((item) => _buildBannerItem(context, item))
                    .toList(),
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 3,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  initialPage: 0,
                  onPageChanged: (index, _) {
                    carouselIndexNotifier.value = index;
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<int>(
                valueListenable: carouselIndexNotifier,
                builder: (context, index, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < displayBanners.length; i++)
                        GestureDetector(
                          onTap: () => carouselController.animateToPage(i),
                          child: Container(
                            width: index == i ? 10 : 10,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == i
                                  ? Theme.of(context).primaryColor
                                  : AppColors.primaryLight4,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBannerItem(BuildContext context, Banners item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, left: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200.h,
                child: Text(
                  item.bannerTitle ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
              SizedBox(height: 3.v),
              SizedBox(
                width: 200.h,
                child: Text(
                  item.bannerSubtitle ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              SizedBox(height: 12.v),
              InkWell(
                child: Row(
                  children: [
                    Text(
                      item.bannerKey ?? "",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).highlightColor,
                          ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).highlightColor,
                      size: 18.h,
                    ),
                  ],
                ),
                onTap: () => _handleBannerTap(item),
              ),
            ],
          ),
        ),
        const Spacer(),
        (item.image == null || item.image!.isEmpty)
            ? SvgPicture.asset(ImageConstant.offersIcon)
            : SizedBox(
                width: 115.adaptSize,
                height: double.infinity,
                child: Image.network(
                  item.image!,
                  headers: getCMSImageHeader(),
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(
                      ImageConstant.offersIcon,
                      width: 100.h,
                     height: double.infinity,
                    );
                  },
                ),
              ),
      ],
    );
  }

  void _handleBannerTap(Banners item) {
    if (item.screenRouter!.contains('settings') && isCustomer() == false) {
      context.pushNamed(Routes.myProfileData.name);
    } else {
      final leadType = _getLeadType(item.productSubType);
      context.pushNamed(lead_gen.Routes.leadGeneration.name,
          pathParameters: {'leadType': leadType},);
    }
  }

  String _getLeadType(String? productSubType) {
    switch (productSubType) {
      case "personal":
        return "personal";
      case "fixed_deposit":
        return "fixed_deposit";
      case "vehicle_top_up":
        return "vehicle_top_up";
      case "personal_top_up":
        return "personal_top_up";
      default:
        return "common";
    }
  }
}
