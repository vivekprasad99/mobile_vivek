class GetLoanListReq {
  final String? ucic;

  GetLoanListReq({
    this.ucic,
  });

  factory GetLoanListReq.fromJson(Map<String, dynamic> json) => GetLoanListReq(
        ucic: json["ucic"],
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
      };
}
