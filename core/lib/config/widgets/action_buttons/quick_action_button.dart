import 'dart:math';

import 'package:core/config/widgets/action_buttons/quick_action.dart';
import 'package:core/config/widgets/action_buttons/quick_action_icon.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class QuickActionButton extends StatefulWidget {
  const QuickActionButton(this.action,
      {super.key,
      required this.isOpen,
      required this.index,
      required this.close});

  final QuickAction action;
  final bool isOpen;
  final int index;
  final Function() close;

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton> {
  final _radius = 80.0.adaptSize;
  final _offset = 10.0.adaptSize;

  double degToRad(double deg) {
    return pi * deg / 180.0;
  }

  double get _range => 90.0 - _offset;

  double get _alpha => _offset / 2 + widget.index * _range / 2;

  double get _radian => degToRad(_alpha);

  double get _b => sin(_radian) * _radius;

  double get _a => cos(_radian) * _radius;

  final _duration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: _duration,
      bottom: widget.isOpen ? _b : 0,
      right: widget.isOpen ? _a : 0,
      curve: Curves.easeOut,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 80),
        child: AnimatedRotation(
          turns: widget.isOpen ? 0 : 0.1,
          alignment: Alignment.center,
          curve: Curves.easeInOut,
          duration: _duration * 1.5,
          child: AnimatedOpacity(
            opacity: widget.isOpen ? 1 : 0,
            duration: _duration,
            child: AnimatedScale(
              scale: widget.isOpen ? 0.8 : 1,
              duration: _duration,
              child: InkWell(
                onTap: () {
                  widget.close();
                  widget.action.onTap();
                },
                child: Container(
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 2),
                        color: Colors.transparent),
                  ]),
                  child: QuickActionIcon(
                      backgroundColor: widget.action.backgroundColor,
                      child: widget.action.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
