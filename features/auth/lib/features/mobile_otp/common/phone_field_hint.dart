import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';

class CustomPhoneFieldHint extends StatelessWidget {
  final bool autoFocus;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final CustomFloatingTextField? child;
  final bool isFormWidget;

  const CustomPhoneFieldHint({
    super.key,
    this.child,
    this.controller,
    this.inputFormatters,
    this.decoration,
    this.autoFocus = false,
    this.focusNode,
    this.isFormWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return _PhoneFieldHint(
        key: key,
        inputFormatters: inputFormatters,
        controller: controller,
        decoration: decoration,
        autoFocus: autoFocus,
        focusNode: focusNode,
        isFormWidget: isFormWidget,
        child: child);
  }
}

class _PhoneFieldHint extends StatefulWidget {
  final bool autoFocus, enabled;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator? validator;
  final bool isFormWidget;
  final InputDecoration? decoration;
  final CustomFloatingTextField? child;

  const _PhoneFieldHint({
    super.key,
    this.child,
    this.controller,
    this.inputFormatters,
    this.validator,
    this.isFormWidget = false,
    this.decoration,
    this.autoFocus = false,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<StatefulWidget> createState() {
    return _PhoneFieldHintState();
  }
}

class _PhoneFieldHintState extends State<_PhoneFieldHint> {
  final SmsAutoFill _autoFill = SmsAutoFill();
  late TextEditingController _controller;
  late List<TextInputFormatter> _inputFormatters;
  late FocusNode _focusNode;
  bool _hintShown = false;
  bool _isUsingInternalController = false;
  bool _isUsingInternalFocusNode = false;

  @override
  void initState() {
    _controller = widget.controller ??
        widget.child?.controller ??
        _createInternalController();
    // _inputFormatters = widget.inputFormatters ?? widget.child?.inputFormatters ?? [];
    _focusNode = widget.focusNode ??
        widget.child?.focusNode ??
        _createInternalFocusNode();
    _focusNode.addListener(() async {
      if (_focusNode.hasFocus && !_hintShown) {
        _hintShown = true;
        scheduleMicrotask(() {
          _askPhoneHint();
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration ??
        InputDecoration(
          suffixIcon: Platform.isAndroid
              ? IconButton(
                  icon: const Icon(Icons.phonelink_setup),
                  onPressed: () async {
                    _hintShown = true;
                    await _askPhoneHint();
                  },
                )
              : null,
        );

    return widget.child ??
        _createField(widget.isFormWidget, decoration, widget.validator);
  }

  @override
  void dispose() {
    if (_isUsingInternalController) {
      _controller.dispose();
    }

    if (_isUsingInternalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Widget _createField(bool isFormWidget, InputDecoration decoration,
      FormFieldValidator? validator) {
    return isFormWidget
        ? _createTextFormField(decoration, validator)
        : _createTextField(decoration);
  }

  Widget _createTextField(InputDecoration decoration) {
    return TextField(
      enabled: widget.enabled,
      autofocus: widget.autoFocus,
      focusNode: _focusNode,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: _inputFormatters,
      decoration: decoration,
      controller: _controller,
      keyboardType: TextInputType.phone,
    );
  }

  Widget _createTextFormField(
      InputDecoration decoration, FormFieldValidator? validator) {
    return TextFormField(
      enabled: widget.enabled,
      validator: validator,
      autofocus: widget.autoFocus,
      focusNode: _focusNode,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: _inputFormatters,
      decoration: decoration,
      controller: _controller,
      keyboardType: TextInputType.phone,
    );
  }

  Future<void> _askPhoneHint() async {
    String? hint = await _autoFill.hint;
    _controller.value = TextEditingValue(text: hint ?? '');
  }

  TextEditingController _createInternalController() {
    _isUsingInternalController = true;
    return TextEditingController(text: '');
  }

  FocusNode _createInternalFocusNode() {
    _isUsingInternalFocusNode = true;
    return FocusNode();
  }
}
