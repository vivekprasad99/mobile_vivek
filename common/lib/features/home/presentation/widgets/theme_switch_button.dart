// ignore_for_file: library_private_types_in_public_api

import 'package:core/config/resources/app_colors.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class ThemeSwitchButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  // ignore: use_super_parameters
  const ThemeSwitchButton(
      {Key? key, required this.value, required this.onChanged,})
      : super(key: key);

  @override
  _ThemeSwitchButtonState createState() => _ThemeSwitchButtonState();
}

class _ThemeSwitchButtonState extends State<ThemeSwitchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _alignmentAnimation = AlignmentTween(
      begin: !widget.value ? Alignment.centerRight : Alignment.centerLeft,
      end: !widget.value ? Alignment.centerRight : Alignment.centerLeft,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ),);
    _colorAnimation = ColorTween(
      begin: !widget.value ? AppColors.secondaryLight : AppColors.primaryLight,
      end: !widget.value ? AppColors.secondaryLight : AppColors.primaryLight,
    ).animate(_animationController);

    if (!widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(ThemeSwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.value != oldWidget.value) {
      if (!widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.value) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        widget.onChanged(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: 64.adaptSize,
            height: 32.adaptSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: _colorAnimation.value,
            ),
            child: Padding(
              padding:  EdgeInsets.all(4.5.adaptSize),
              child: Stack(
                children: [
                  Align(
                    alignment: _alignmentAnimation.value,
                    child: Container(
                      width: 24.adaptSize,
                      height: 24.adaptSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: !widget.value
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        !widget.value
                            ? Icons.wb_sunny_outlined
                            : Icons.dark_mode_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
