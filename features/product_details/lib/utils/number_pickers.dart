import 'package:flutter/cupertino.dart';

class NumbersPicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final int increment;
  final ValueChanged<int> onChanged;

  const NumbersPicker({super.key, 
    this.initialValue = 0,
    this.minValue = 0,
    this.maxValue = 100,
    this.increment = 1,
    required this.onChanged,
  });

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumbersPicker> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: (_value - widget.minValue) ~/ widget.increment,
      ),
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        setState(() {
          _value = widget.minValue + index * widget.increment;
          widget.onChanged(_value);
        });
      },
      children: List.generate(
        ((widget.maxValue - widget.minValue) ~/ widget.increment) + 1,
        (index) => Text(
          '${widget.minValue + index * widget.increment}',
        ),
      ),
    );
  }
}
