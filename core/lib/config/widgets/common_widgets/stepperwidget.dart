import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
// ignore_for_file: must_be_immutable
class StepperWidget extends StatelessWidget {
  final List<String> step;
  final double width;
  int curStep;
  EdgeInsets? padding;
  final Color currentStepColor;
  final Color inactiveColor;
  final double lineWidth;
  Function(int)? onTap;
  StepperWidget(
      {super.key, required this.step,
      required this.width,
      required this.curStep,
      required this.inactiveColor,
      required this.currentStepColor,
      required this.lineWidth,
      this.padding,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: 16,
              margin: const EdgeInsets.only(left: 30, right:35),
              child: Row(
                children: [
                  for (int i = 0; i < step.length - 1; i++)
                    Expanded(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                color:  i < step.indexOf(step[curStep])? currentStepColor : inactiveColor,
                )
                      ),
                    ),
                ],
              ),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: step.map((stage) {
              return Column(
                children: [
                   Container(
            width: step.indexOf(stage)== curStep ? 16.0 : 12.0,
            height:step.indexOf(stage)== curStep ? 16.0 : 12.0,
            decoration: BoxDecoration(
                color: step.indexOf(stage)<= curStep ? currentStepColor : inactiveColor,
                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                border: Border.all(
                    color: Colors.pink.shade50,
                    width:step.indexOf(stage)== curStep ? 3.0 : 0))),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 70,
                    height: 40,
                    child: Text(
                      stage,
                      textAlign: TextAlign.center,
                      style:titlesTextstyle(context,step.indexOf(stage))
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          ],
        ),
      ],
    );
  }
titlesTextstyle(context,index){
if (curStep == index) {
 return Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600,color: setColorBasedOnTheme(context: context, lightColor: AppColors.primaryLight, darkColor: AppColors.white),);
} else if (curStep < index) {
 return Theme.of(context).textTheme.labelSmall?.copyWith(color: setColorBasedOnTheme(context: context, lightColor: AppColors.sliderColor, darkColor: AppColors.shadowDark),);
} else {
 return Theme.of(context).textTheme.labelSmall?.copyWith(color: setColorBasedOnTheme(context: context, lightColor: AppColors.primaryLight, darkColor: AppColors.white),);
}

}
}