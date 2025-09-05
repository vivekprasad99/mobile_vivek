class PaymentResponse {
  final String? code;
  final String? message;
  final List<PaymentHistory>? paymentHistory;
  final String? responseCode;

  PaymentResponse({
    this.code,
    this.message,
    this.paymentHistory,
    this.responseCode,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        code: json["code"],
        message: json["message"],
        paymentHistory: json["paymentHistory"] == null
            ? []
            : List<PaymentHistory>.from(
                json["paymentHistory"]!.map((x) => PaymentHistory.fromJson(x))),
        responseCode: json["responseCode"],        
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "paymentHistory": paymentHistory == null
            ? []
            : List<dynamic>.from(paymentHistory!.map((x) => x.toJson())),
        "responseCode": responseCode,    
      };
}

class PaymentHistory {
  final String? date;
  final int? receiptNumber;
  final double? instalmentAmount;
  final String? modeofPayment;

  PaymentHistory({
    this.date,
    this.receiptNumber,
    this.instalmentAmount,
    this.modeofPayment,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        date: json["date"],
        receiptNumber: json["receiptNumber"],
        instalmentAmount: json["instalmentAmount"],
        modeofPayment: json["modeofPayment"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "receiptNumber": receiptNumber,
        "instalmentAmount": instalmentAmount,
        "modeofPayment": modeofPayment,
      };
}
