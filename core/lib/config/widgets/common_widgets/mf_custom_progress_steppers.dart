import 'package:core/config/resources/app_colors.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class MfCircularProgressWidget extends StatelessWidget {
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

  const MfCircularProgressWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.titleStyle,
    required this.stepTextStyle,
    required this.containerPadding,
    required this.selectedColor,
    required this.unselectedColor,
    required this.completedColor,
    required this.ongoingColor,
    required this.remainingColor,
    required this.stepSize,
    required this.width,
    required this.height,
    required this.padding,
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
            // Adjust the step size (thickness) as desired
            selectedColor: selectedColor ?? AppColors.primaryLight2,
            // Red for completed steps
            unselectedColor: unselectedColor ?? AppColors.primaryLight6,
            customColor: (index) {
              // Determine the color for each step
              if (index < currentStep) {
                return completedColor ??
                    AppColors.primaryLight2; // color for  completed steps
              } else if (index == currentStep) {
                return ongoingColor ??
                    AppColors.primaryLight4; // color for ongoing steps
              } else {
                return remainingColor ??
                    AppColors.primaryLight6; // color for remaining steps
              }
            },
            padding: padding ?? 0,
            // No padding between steps
            width: width ?? 60.h,
            // Width of the circular indicator
            height: height ?? 60.v,
            // Height of the circular indicator
            roundedCap: (_, __) => true,
            // Yellow for remaining steps
            child: Center(
              child: Text(
                "$currentStep/$totalSteps",
                style: stepTextStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
            ), // Rounded ends of the segments
          ),
          const SizedBox(width: 20),
          // Step description
          Text(
            title ?? "",
            style: titleStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: 20),
          // Display remaining steps
        ],
      ),
    );
  }
}
