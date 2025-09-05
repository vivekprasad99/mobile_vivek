import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/coach_marks/widgets/calculator_service_coach_widget.dart';
import 'package:core/config/widgets/coach_marks/widgets/floating_coach_widget.dart';
import 'package:core/config/widgets/coach_marks/widgets/loan_intro_coach_widget.dart';
import 'package:core/config/widgets/coach_marks/widgets/menu_intro_coach_widget.dart';
import 'package:core/config/widgets/coach_marks/widgets/product_pay_coach_widget.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
class IntroScreen extends StatefulWidget {
  final VoidCallback onTap;

  const IntroScreen({required this.onTap, super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int pageValue = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(25, 6, 7, 0.7),
          ),
          child: Stack(
            children: [
              _buildButtonWidget(context),
              pageValue == 4
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 10.adaptSize,left: 10.adaptSize,right: 10.adaptSize),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MfCustomButton(
                            onPressed: () {
                              widget.onTap();
                            },
                            text: getString(lblHome),
                            outlineBorderButton: false),
                      ),
                    )
                  : const SizedBox.shrink(),
              if (pageValue == 0)
                Positioned(
                    right: size.width > 400 ? -1 : -3,
                    bottom: MediaQuery.of(context).size.height *
                        (size.height > 900
                            ? 0.09
                            : (size.height > 700 ? 0.1 : .11)),
                    child: const BuildFloatingScreen()),
              if (pageValue == 1)
                const Align(
                    alignment: Alignment.bottomCenter,
                    child: BuildProductPayScreen()),
              if (pageValue == 2)
                const Positioned(
                    bottom: 0, right: 0, child: BuildCalculatorService()),
              if (pageValue == 3)
                const Positioned(
                    child: Align(
                        alignment: Alignment.topCenter, child: BuildLoanIntro())),
              if (pageValue == 4)
                const Positioned(
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: BuildMenuIntro())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWidget(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: pageValue == 3 || pageValue == 4
            ? Alignment.bottomCenter
            : Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: pageValue == 3 || pageValue == 4 ? 80.adaptSize : 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pageValue != 0
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          if (pageValue > 0) {
                            pageValue--;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.background,
                            size: 13.h,
                          ),
                          SizedBox(width: 8.adaptSize,),
                          Text(
                            getString(labelPrevious),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.background,
                                ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                margin: EdgeInsets.all(15.adaptSize),
                child: SizedBox(
                  height: 7.0,
                  child: Row(
                    children: List.generate(5, (index) {
                      return Container(
                        width: 10,
                        height: 7.0,
                        margin: EdgeInsets.symmetric(horizontal: 3.adaptSize),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: index == pageValue
                              ? AppColors.background
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              pageValue != 4
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          pageValue++;
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            getString(labelNext),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.background,
                                ),
                          ),
                            SizedBox(width: 8.adaptSize,),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.background,
                            size: 13.h,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}