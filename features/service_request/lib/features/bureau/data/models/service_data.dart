import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:service_request/features/bureau/data/models/bureau_response.dart';

class ServiceDataModel {
  final Set<Bureau> selectedBureaus;
  final String selectedReason;
  final String selectedProduct;
  final LoanItem? loanItem;

  ServiceDataModel(
      {required this.selectedBureaus,
      required this.selectedReason,
      required this.loanItem,
      required this.selectedProduct});
}

class UploadDataModel {
  final String imagePath;
  final int index;
  final bool isPayment;

  UploadDataModel(
      {required this.imagePath, required this.index, required this.isPayment});
}
