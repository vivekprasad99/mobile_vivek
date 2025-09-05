class ActiveLoanListRequest {
  final String? ucic;

  ActiveLoanListRequest({
    this.ucic,
  });

  factory ActiveLoanListRequest.fromJson(Map<String, dynamic> json) =>
      ActiveLoanListRequest(
        ucic: json["ucic"],
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
      };
}
