class SaveBranchResponse {
  final String? code;
  final String? message;
  final String? responseCode;

  SaveBranchResponse({
    this.code,
    this.message,
    this.responseCode,
  });

  SaveBranchResponse copyWith({
    String? code,
    String? message,
    String? responseCode,
  }) =>
      SaveBranchResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        responseCode: responseCode ?? this.responseCode,
      );

  factory SaveBranchResponse.fromJson(Map<String, dynamic> json) =>
      SaveBranchResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
      };
}
