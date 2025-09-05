import 'package:carousel_slider/carousel_slider.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';

class OfferSliderDemo extends StatefulWidget {
  const OfferSliderDemo({super.key, required this.offersCard});

  final List<Widget> offersCard;

  @override
  State<OfferSliderDemo> createState() => _OfferSliderDemoState();
}

class _OfferSliderDemoState extends State<OfferSliderDemo> {
  CarouselController buttonCarouselController = CarouselController();
  int currentIndex = 0;

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
                  });
                },
              ),
              itemCount: widget.offersCard.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(currentIndex == itemIndex ? 8 : 0),
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
      ],
    );
  }
}
