class GetForeClosureDetailsResponse {
  final String? status;
  final String? message;
  final String code;
  final String responseCode;
  final ForeclosureDetails? data;

  GetForeClosureDetailsResponse({
    this.status,
    this.message,
    this.data,
   required this.code,
   required this.responseCode
  });

  factory GetForeClosureDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetForeClosureDetailsResponse(
        status: json["status"],
        message: json["message"],
        code: json['code'],
        responseCode: json['responseCode'],
        data: json["data"] == null
            ? null
            : ForeclosureDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "responseCode": responseCode,
        "data": data?.toJson(),
      };
}

class ForeclosureDetails {
   final String? loanAccountNumber;
   final Map<String, dynamic>? foreclosureDetails;
   final String? totalAmountToPay;
   final String? principal;
   final String? interest;
   final String? foreclosureCharges;
   final Map<String, dynamic>? otherCharges;

  ForeclosureDetails({
    this.loanAccountNumber,
    this.foreclosureDetails,
   required this.totalAmountToPay,
   required this.principal,
   required this.interest,
   required this.foreclosureCharges,
   required this.otherCharges
  });

  factory ForeclosureDetails.fromJson(Map<String, dynamic> json) {
    return ForeclosureDetails(
        loanAccountNumber: json["loanAccountNumber"] ?? "",
        foreclosureDetails: json["foreclosureDetails"] ?? <String, dynamic>{},
        totalAmountToPay: json["totalAmountToPay"] ?? '0',
        principal: json["principal"] ?? '0',
        interest: json["interest"] ?? '0',
        foreclosureCharges: json["foreclosureCharges"] ?? '0',
        otherCharges: json["otherCharges"] ?? <String, dynamic>{},
        );
  }

  Map<String, dynamic> toJson() => {
        "loanAccountNumber": loanAccountNumber,
        "foreclosureDetails": foreclosureDetails,
        "totalAmountToPay": totalAmountToPay,
        "principal": principal,
        "interest": interest,
        "foreclosureCharges": foreclosureCharges,
        "otherCharges": otherCharges,
      };

  List<Charges>? chargesList() {
    List<Charges>? charges = otherCharges?.entries
        .map(
            (entry) => Charges(name: entry.key, amount: entry.value.toString()))
        .toList();
    return charges;
  }
}

class Charges {
  String? name;
  String? amount;
  String? description;
  Charges({this.name, this.amount, this.description});
}
