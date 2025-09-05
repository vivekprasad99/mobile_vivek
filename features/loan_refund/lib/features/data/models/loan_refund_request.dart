class LoanRefundRequest {
  String? ucic;

  LoanRefundRequest({this.ucic});

  factory LoanRefundRequest.fromJson(Map<String, dynamic> json) =>
      LoanRefundRequest(ucic: json["ucic"]);

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
      };
}
