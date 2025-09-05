import 'dart:ui';

import 'package:payment_gateway/features/presentation/utils/payment_mode_enum.dart';

class PaymentStatusDataModel {
  final String imagePath;
  final String title;
  final String amount;
  final String? paymentStatusIcon;
  final String? paymentStausMsg;
  final String description;
  final String transactionId;
  final String modeOfPayment;
  final String loanNumber;
  final DateTime paymentMadeOn;
  final bool paymentStatus;
  final String primaryButtonTitle;
  final String secondaryButtonTitle;
  final VoidCallback? primaryButtonClick;
  final double topIconHeight;
  final double topIconWidth;
  final String customerName;
  final String purposeOfPayment;
  final String bankTransactionID;
  String? remainingAmount;
  String? fromScreen;
  ActionType? actionsType;

  PaymentStatusDataModel({
    required this.imagePath,
    required this.title,
    required this.paymentStatus,
    required this.amount,
    required this.topIconHeight,
    required this.topIconWidth,
    required this.paymentStatusIcon,
    required this.paymentStausMsg,
    required this.description,
    required this.transactionId,
    required this.modeOfPayment,
    required this.loanNumber,
    required this.paymentMadeOn,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.customerName,
    required this.purposeOfPayment,
    required this.bankTransactionID,
    this.remainingAmount,
    this.primaryButtonClick,
    this.actionsType,
    this.fromScreen
  });
}



