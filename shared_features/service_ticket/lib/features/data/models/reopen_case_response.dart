class ReopenCaseResponse {
  String? code;
  String? message;
  Data? data;

  ReopenCaseResponse({this.code, this.message, this.data});

  ReopenCaseResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? statusMsg;
  String? timestamp;
  String? uniqueReqno;

  Data({this.statusMsg, this.timestamp, this.uniqueReqno});

  Data.fromJson(Map<String, dynamic> json) {
    statusMsg = json['Status_Msg'];
    timestamp = json['timestamp'];
    uniqueReqno = json['uniqueReqno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status_Msg'] = statusMsg;
    data['timestamp'] = timestamp;
    data['uniqueReqno'] = uniqueReqno;
    return data;
  }
}
