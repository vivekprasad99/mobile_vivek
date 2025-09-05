import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.buttonColor = const Color.fromRGBO(50, 47, 53, 1),
    this.borderColor = Colors.black,
    this.height = 40,
    this.borderRadius = 100,
    this.width,
    this.textColor = Colors.white,
    required this.onPressed,
    required this.text,
    this.textStyle,
    super.key,
  });

  final double height;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;
  final String text;
  final GestureTapCallback onPressed;
  final double? width;
  final double borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        alignment: Alignment.center,
        height: height,
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          text,
          style: textStyle ??
              Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: textColor,
                  ),
        ),
      ),
    );
  }
}
