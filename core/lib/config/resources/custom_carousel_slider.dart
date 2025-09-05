import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/resources/custom_outline_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_3d/gallery3d.dart';

class CustomSlider extends StatelessWidget {
  final String headline;
  final List<String> imageUrlList;
  final int currentIndex;
  final Gallery3DController controller;
  final Function(int) onUpdateIndex;
  final Function? onPressed;
  final Function() onPressedProceed;

  const CustomSlider({
    required this.headline,
    required this.imageUrlList,
    required this.currentIndex,
    required this.controller,
    required this.onUpdateIndex,
     this.onPressed,
     required this.onPressedProceed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            headline,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height:20 ,),

        Expanded(
          child: Stack(
            children: [
              buildGallery3D(context),
              Positioned.fill(
                top: 160,
                left: 10,
                right: 10,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          int newIndex = currentIndex - 1;
                          if (newIndex < 0) {
                            newIndex = imageUrlList.length - 1; // Wrap around to the last index
                          }
                          controller.animateTo(newIndex);
                          onUpdateIndex(newIndex);

                        },
                        child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 35),
                      ),
                      GestureDetector(
                        onTap: () {
                          int newIndex = currentIndex + 1;
                          if (newIndex >= imageUrlList.length) {
                            newIndex = 0;
                          }
                          onUpdateIndex(newIndex);
                          controller.animateTo(newIndex);
                        },
                        child: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 35),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Center(
          child: CustomOutlinedButton(
            height: 48.v,
            width: 328.h,
            text: getString(msgNoProceedWith),
            margin: EdgeInsets.only(right: 5.h),
            buttonStyle: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).highlightColor,
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
                color: Theme.of(context).highlightColor),
            onPressed: onPressedProceed,
          ),
        ),
        const SizedBox(height:20 ,),
      ],
    );
  }


  Widget buildGallery3D(BuildContext context) {
    return Gallery3D(
        padding: const EdgeInsets.all(20),
        controller: controller,
        width: MediaQuery.of(context).size.width,
        isClip: true,
        onItemChanged: (index) {
          onUpdateIndex(index);
        },
        itemConfig: const GalleryItemConfig(
          width: 300,
          height: 380,
          radius: 10,
          isShowTransformMask: true,
        ),
        onClickItem: (index) {
        },
        itemBuilder: (context, index) {
          final bool isCenter = index == currentIndex;
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  height: 380,
                  imageUrlList[index],
                  fit: BoxFit.fill,
                ),
              ),
              if (isCenter)  Positioned(
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () =>onPressedProceed,
                  child: const Text('Button'),
                ),
              ),
            ],
          );
        });
  }
}
