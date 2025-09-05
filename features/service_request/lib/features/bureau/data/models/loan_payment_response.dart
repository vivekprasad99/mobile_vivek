class PaymentResponse {
  String code;
  String message;
  String responseCode;
  List<PaymentHistory>? paymentHistory;

  PaymentResponse({
    required this.code,
    required this.message,
    required this.responseCode,
    this.paymentHistory,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      code: json['code'],
      message: json['message'],
      responseCode: json['responseCode'],
      paymentHistory: json['paymentHistory'] != null
          ? (json['paymentHistory'] as List)
              .map((i) => PaymentHistory.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'code': code,
      'message': message,
      'responseCode': responseCode,
    };
    if (paymentHistory != null) {
      data['paymentHistory'] = paymentHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentHistory {
  String lastPaymentDate;
  int receiptNumber;
  double instalmentAmount;
  String modeOfPayment;

  PaymentHistory({
    required this.lastPaymentDate,
    required this.receiptNumber,
    required this.instalmentAmount,
    required this.modeOfPayment,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      lastPaymentDate: json['date'],
      receiptNumber: json['receiptNumber'],
      instalmentAmount: json['instalmentAmount'].toDouble(),
      modeOfPayment: json['modeofPayment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': lastPaymentDate,
      'receiptNumber': receiptNumber,
      'instalmentAmount': instalmentAmount,
      'modeofPayment': modeOfPayment,
    };
  }
}
