class DedupeResponse {
  String code;
  String message;
  String responseCode;
  List<String>? data;

  DedupeResponse({
    required this.code,
    required this.message,
    required this.responseCode,
    this.data,
  });

  factory DedupeResponse.fromJson(Map<String, dynamic> json) {
    return DedupeResponse(
      code: json['code'],
      message: json['message'],
      responseCode: json['responseCode'] ?? "",
      data: json['data'] != null ? List<String>.from(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'code': code,
      'message': message,
      'responseCode': responseCode,
    };
    if (data != null) {
      json['data'] = data;
    }
    return json;
  }
}


