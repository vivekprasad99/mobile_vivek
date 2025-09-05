class LoanRefundBankAccountDetailsRequest {
  String? loanAccountNumber;

  LoanRefundBankAccountDetailsRequest({this.loanAccountNumber});

  factory LoanRefundBankAccountDetailsRequest.fromJson(Map<String, dynamic> json) =>
      LoanRefundBankAccountDetailsRequest(loanAccountNumber: json["loan_account_number"]);

  Map<String, dynamic> toJson() => {
        "loan_account_number": loanAccountNumber,
      };}
