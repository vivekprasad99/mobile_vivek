class GetPrivacyPolicyResponse {
  final String? status;
  final String? message;
  final String? data;
  GetPrivacyPolicyResponse({this.status, this.message, this.data});

  factory GetPrivacyPolicyResponse.fromJson(Map<String, dynamic> json) =>
      GetPrivacyPolicyResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
