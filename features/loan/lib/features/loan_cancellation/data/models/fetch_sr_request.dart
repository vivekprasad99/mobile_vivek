class FetchSrRequest {
  final String? mobileNumber;
  final String? loanAccountNumber;

  FetchSrRequest({
    this.mobileNumber,
    this.loanAccountNumber,
  });

  factory FetchSrRequest.fromJson(Map<String, dynamic> json) => FetchSrRequest(
        mobileNumber: json["MobileNumber"],
        loanAccountNumber: json["loanAccountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "MobileNumber": mobileNumber,
        "loanAccountNumber": loanAccountNumber,
      };
}
