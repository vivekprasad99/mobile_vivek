import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key,
      required this.titile,
      this.subTitle,
      this.textstyle,
      this.subtextstyle,
      this.spacer,
      this.isVisible = true,
      this.height,
      this.width,
      this.color,
      this.leftPadding});

  final String titile;
  final String? subTitle;
  final TextStyle? textstyle;
  final TextStyle? subtextstyle;
  final double? spacer, height, width, leftPadding;
  final bool isVisible;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.transparent,
      height: height ?? 50,
      width: width ?? 206,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: leftPadding ?? 0.0),
            child: Text(
              titile,
              style: textstyle ??
                  Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xff691A1E), fontWeight: FontWeight.w600, fontSize: 12.0, height: 5),
            ),
          ),
          SizedBox(
            height: spacer ?? 5,
          ),
          Visibility(
            visible: isVisible,
            child: Text(
              subTitle ?? "",
              style: subtextstyle ??
                  Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xff691A1E), fontWeight: FontWeight.w400, fontSize: 12.0, height: 5),
            ),
          ),
        ],
      ),
    );
  }
}
