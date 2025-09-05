class GetLoansCancellationRequest {
  final String? ucic;

  GetLoansCancellationRequest({
    this.ucic,
  });

  factory GetLoansCancellationRequest.fromJson(Map<String, dynamic> json) =>
      GetLoansCancellationRequest(
        ucic: json["ucic"],
      );

  Map<String, dynamic> toJson() => {
        "ucic": ucic,
      };
}