class ServiceRequestResponse {
  String? code;
  String? message;
  String? responseCode;
  Data? data;

  ServiceRequestResponse(
      {this.code, this.message, this.responseCode, this.data});

  ServiceRequestResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isNewTicket;
  List<String>? oldTickets;
  String? serviceTicketNumber;
  String? message;

  Data(
      {this.isNewTicket,
        this.oldTickets,
        this.serviceTicketNumber,
        this.message});

  Data.fromJson(Map<String, dynamic> json) {
    isNewTicket = json['isNewTicket'];
    oldTickets = json['oldTickets'].cast<String>();
    serviceTicketNumber = json['ServiceTicket-Number'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isNewTicket'] = isNewTicket;
    data['oldTickets'] = oldTickets;
    data['ServiceTicket-Number'] = serviceTicketNumber;
    data['message'] = message;
    return data;
  }
}
