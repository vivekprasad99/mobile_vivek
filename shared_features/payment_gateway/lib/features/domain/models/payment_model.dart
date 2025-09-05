import 'package:payment_gateway/features/domain/models/payment_params/payment_product_type.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_source_system.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_type.dart';

class PaymentModel {
  final PaymentProductType productType;
  final PaymentSourceSystem sourceSystem;
  final String productNumber;
  final PaymentType paymentType;
  final String totalPaybleAmount;
  final String description;
  String? remainingAmount;
  String? fromScreen;

  PaymentModel(
      {required this.productType,
      required this.sourceSystem,
      required this.productNumber,
      required this.paymentType,
      required this.description,
      required this.totalPaybleAmount,
      this.remainingAmount,
      this.fromScreen});
}
