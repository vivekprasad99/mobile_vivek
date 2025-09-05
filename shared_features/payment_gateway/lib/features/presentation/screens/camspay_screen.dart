import 'package:flutter/material.dart';
import 'package:camspaypro/camspaypro.dart';
// ignore_for_file: must_be_immutable
class Payment extends StatefulWidget {
  String? jsonString;

  String? merRefId;

  String? encKey;

  String? data;
  Color? startColor;
  Color? endColor;
  Color? toolbarColor;
  String? toolbarTitle;

  Payment(this.data, this.merRefId, this.startColor, this.endColor,
      this.toolbarColor, this.toolbarTitle,
      {super.key});

  @override
  State<StatefulWidget> createState() {
    return PaymentState();
  }
}

class PaymentState extends State<Payment> {
  PaymentState();

  @override
  void initState() {
    PaymentWidgets().init(
        context,
        widget.data!,
        merchantRefid: widget.merRefId,
        setStateFuntion,
        stColor: widget.startColor,
        edColor: widget.endColor,
        toolbarColor: widget.toolbarColor,
        toolbarTitle: widget.toolbarTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PaymentWidgets(
            context: context,
            setStateFuntion: setStateFuntion,
            onCompletion: callBackFunction),
      ),
    );
  }

  setStateFuntion() {
    setState(() {});
  }

  callBackFunction(String returnValue) {
    Navigator.pop(context, returnValue);
  }
}