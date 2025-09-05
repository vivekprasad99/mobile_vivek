import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/presentation/screens/theme/custom_text_style.dart';
import 'package:product_details/presentation/screens/theme/theme_helper.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';
// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({super.key, this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgNavHome,
      activeIcon: ImageConstant.imgNavHome,
      title: getString(lblHome),
      type: BottomBarEnum.home,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavProducts,
      activeIcon: ImageConstant.imgNavProducts,
      title: getString(lblProducts),
      type: BottomBarEnum.products,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavPay,
      activeIcon: ImageConstant.imgNavPay,
      title: getString(lblPayNow),
      type: BottomBarEnum.pay,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavCalculators,
      activeIcon: ImageConstant.imgNavCalculators,
      title: getString(lblEmiCalculator),
      type: BottomBarEnum.calculators,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgNavServices,
      activeIcon: ImageConstant.imgNavServices,
      title: getString(lblHome),
      type: BottomBarEnum.services,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.v,
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        boxShadow: [
          BoxShadow(
            color: appTheme.gray500.withOpacity(0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              1,
              0,
            ),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].icon,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  color: appTheme.gray600,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 9.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.labelLargeGray600.copyWith(
                      color: appTheme.gray600,
                    ),
                  ),
                ),
              ],
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].activeIcon,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  color: appTheme.red700,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 9.v),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.labelLargeRed700.copyWith(
                      color: appTheme.red700,
                    ),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
      ),
    );
  }
}

enum BottomBarEnum {
  home,
  products,
  pay,
  calculators,
  services,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  String icon;

  String activeIcon;

  String? title;

  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
