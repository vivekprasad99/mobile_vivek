import 'package:flutter/material.dart';

class MfCustomStepper extends StatelessWidget {
  final List<String> step;
  final double width;
  final int curStep;
  final EdgeInsets? padding;
  final Color inactiveColor;
  final Color currentStepColor;
  final double lineWidth;
  final Function(int)? onTap;
  const MfCustomStepper(
      {super.key, required this.step,
      required this.width,
      required this.curStep,
      required this.inactiveColor,
      required this.lineWidth,
      required this.currentStepColor,
      this.padding,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding ?? const EdgeInsets.only(top: 20.0, left: 24.0, right: 24.0),
        width: width,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, children: _steps()));
  }

  List<Widget> _steps() {
    var list = <Widget>[];
    for (int i = 0; i < step.length; i++) {
      list.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: () => onTap?.call(i),
              child: Stack(children: [
                Container(
                    width: i == curStep ? 16.0 : 12.0,
                    height: i == curStep ? 16.0 : 12.0,
                    decoration: BoxDecoration(
                        color: i <= curStep ? currentStepColor : inactiveColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        border: Border.all(
                            color: Colors.pink.shade50,
                            width: i == curStep ? 3.0 : 0)))
              ])),
          InkWell(
              onTap: () => onTap?.call(i),
              child: step[i].toString().contains(" ")
                  ? Text(
                      step[i],
                      textAlign: TextAlign.center, // Align text to the center
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        step[i],
                        textAlign: TextAlign.center, // Align text to the center
                      ),
                    )),
          Container(
              height: lineWidth,
              color: i < curStep ? currentStepColor : inactiveColor)
        ],
      ));

      if (i != step.length - 1) {
        list.add(Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
              height: lineWidth,
              color: i < curStep ? currentStepColor : inactiveColor),
        )));
      }
    }
    return list;
  }
}
