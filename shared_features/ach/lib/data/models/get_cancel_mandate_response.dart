
class GetCancelMandateReasonResponse{

  String? status;
  String? message;
  String? responseCode;
  List<CancelReason>? data;

  GetCancelMandateReasonResponse({this.status, this.message, this.responseCode, this.data});

  GetCancelMandateReasonResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    responseCode = json['responseCode'];
    if (json['data'] != null) {
      data = <CancelReason>[];
      json['data'].forEach((v) {
        data!.add(CancelReason.fromJson(v));
      });
    }
  }
}

class CancelReason {
  final String? cancelReasonTitle;
  final String? cancelReasonDesc;
  final bool? canCancel;
  final bool? canHold;
  final bool? canUpdate;

  CancelReason({
    this.cancelReasonTitle,
    this.cancelReasonDesc,
    this.canCancel,
    this.canHold,
    this.canUpdate,
  });

  factory CancelReason.fromJson(Map<String, dynamic> json) =>
      CancelReason(
        cancelReasonTitle: json["cancel_reason_title"],
        cancelReasonDesc: json["cancel_reason_desc"],
        canCancel: json["can_cancel"],
        canHold: json["can_hold"],
        canUpdate: json["can_update"],
      );

  Map<String, dynamic> toJson() =>
      {
        "cancel_reason_title": cancelReasonTitle,
        "cancel_reason_desc": cancelReasonDesc,
        "can_cancel": canCancel,
        "can_hold": canHold,
        "can_update": canUpdate,
      };
}

