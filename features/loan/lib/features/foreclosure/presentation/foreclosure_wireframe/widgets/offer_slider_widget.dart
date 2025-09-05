import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class OfferSliderDemo extends StatefulWidget {
  const OfferSliderDemo({super.key, required this.offersCard,required this.dialogContext,required this.onPressed});

  final List<Widget> offersCard;
  final BuildContext? dialogContext;
  final VoidCallback onPressed;

  @override
  State<OfferSliderDemo> createState() => _OfferSliderDemoState();
}

class _OfferSliderDemoState extends State<OfferSliderDemo> {
  CarouselController buttonCarouselController = CarouselController();
  int currentIndex = 0;
  int centerItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: CarouselSlider.builder(
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                height: 350,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                    centerItemIndex = index;
                  });
                },
              ),
              itemCount: widget.offersCard.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return SizedBox(
                    height: 295.v,
                    width: 244.h,
                    child: widget.offersCard[itemIndex]);
              }),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              buttonCarouselController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            },
            icon: const Icon(
              Icons.chevron_right,
              size: 30,
              color: AppColors.primaryLight,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {
              buttonCarouselController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: AppColors.primaryLight,
            ),
          ),
        ),
        if (currentIndex == centerItemIndex)
          Positioned(
            bottom: 12,
            child: CustomElevatedButton(
              alignment: Alignment.center,
              height: 42.v,
              width: 156.h,
              text: getString(lblYesInterested),
              margin: EdgeInsets.only(left: 15.h, right: 15.h),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
              onPressed: widget.onPressed
            ),
          ),
      ],
    );
  }
}
