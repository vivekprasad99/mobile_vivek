import 'package:core/config/resources/app_colors.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class MfCustomCircularProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String? title;
  final TextStyle? titleStyle;
  final TextStyle? stepTextStyle;
  final EdgeInsetsGeometry? containerPadding;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? completedColor;
  final Color? ongoingColor;
  final Color? remainingColor;
  final double? stepSize;
  final double? width;
  final double? height;
  final double? padding;
  const MfCustomCircularProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    this.titleStyle,
    this.stepTextStyle,
    this.containerPadding,
    this.selectedColor,
    this.unselectedColor,
    this.completedColor,
    this.ongoingColor,
    this.remainingColor,
    this.stepSize,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: containerPadding ??
          EdgeInsets.symmetric(horizontal: 14.h, vertical: 2.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Circular Step Progress Indicator
          CircularStepProgressIndicator(
            totalSteps: totalSteps,
            currentStep: currentStep,
            stepSize: stepSize ?? 7,
            selectedColor: selectedColor ?? AppColors.primaryLight2,
            unselectedColor: unselectedColor ?? AppColors.primaryLight6,
            customColor: (index) {
              if (index < currentStep - 1) {
                return AppColors.primaryLight2; // Red for completed steps
              } else if (index == currentStep - 1) {
                return AppColors.primaryLight4; // Green for ongoing step
              } else {
                return remainingColor ??
                    AppColors.primaryLight6; // Blue for remaining steps
              }
            },
            padding: padding ?? 0,
            width: width ?? 60.h,
            height: height ?? 60.v,
            roundedCap: (_, __) => true,
            child: Center(
              child: Text(
                "$currentStep/$totalSteps",
                style: stepTextStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(width: 20), // Step description
          Text(
            title ?? "",
            style: titleStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

