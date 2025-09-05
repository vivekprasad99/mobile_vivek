

class UpdateMandateReasonResp{

  String? status;
  String? message;
  String? responseCode;
  List<UpdateMandateReason>? data;

  UpdateMandateReasonResp({this.status, this.message, this.responseCode, this.data});

  UpdateMandateReasonResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    responseCode = json['responseCode'];
    if (json['data'] != null) {
      data = <UpdateMandateReason>[];
      json['data'].forEach((v) {
        data!.add(UpdateMandateReason.fromJson(v));
      });
    }
  }
}

class UpdateMandateReason {
  final String? id;
  final String? value;
  final bool? otherIssue;

  UpdateMandateReason({
    this.id,
    this.value,
    this.otherIssue
  });

  factory UpdateMandateReason.fromJson(Map<String, dynamic> json) =>
      UpdateMandateReason(
        id: json["id"],
        value: json["value"],
        otherIssue: json["otherIssue"],
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "value": value,
        "otherIssue": otherIssue,
      };
}
