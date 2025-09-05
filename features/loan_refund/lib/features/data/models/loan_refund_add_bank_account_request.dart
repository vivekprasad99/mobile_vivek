class LoanRefundAddBankAccountRequest {
  String? bankName;

  LoanRefundAddBankAccountRequest({this.bankName});

  LoanRefundAddBankAccountRequest.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["bankName"] = bankName;
    return data;
  }
}

