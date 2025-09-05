
import 'dart:convert';

CamspayResponseQrModel camspayResponseQrModelFromJson(String str) => CamspayResponseQrModel.fromJson(json.decode(str));

String camspayResponseQrModelToJson(CamspayResponseQrModel data) => json.encode(data.toJson());

class CamspayResponseQrModel {
    Status status;

    CamspayResponseQrModel({
        required this.status,
    });

    factory CamspayResponseQrModel.fromJson(Map<String, dynamic> json) => CamspayResponseQrModel(
        status: Status.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status.toJson(),
    };
}

class Status {
    bool errorflag;
    String errorcode;
    String errormsg;
    List<QrResponse> data;

    Status({
        required this.errorflag,
        required this.errorcode,
        required this.errormsg,
        required this.data,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        errorflag: json["errorflag"],
        errorcode: json["errorcode"],
        errormsg: json["errormsg"],
        data: List<QrResponse>.from(json["data"].map((x) => QrResponse.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "errorflag": errorflag,
        "errorcode": errorcode,
        "errormsg": errormsg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class QrResponse {
    String custname;
    String merchantid;
    String subbillerid;
    String custid;
    String trxnno;
    String camspayrefno;
    String customerrefno;
    String trxnrefno;
    String banktrxnno;
    String bankname;
    String trxnstatus;
    String trxnstatusdesc;
    String amount;
    String trxndate;
    String trxnnote;
    String vpa;
    String transactedaccno;
    String transactedaccholdername;
    String ifsc;
    dynamic upipayeevpa;
    String accountno;
    String payoutstatus;
    String payoutrefno;
    String devicetype;
    String paymenttype;
    String transactionifsc;
    String transactionaccountno;
    String trxnStatus;
    String trxnStatusDesc;

    QrResponse({
        required this.custname,
        required this.merchantid,
        required this.subbillerid,
        required this.custid,
        required this.trxnno,
        required this.camspayrefno,
        required this.customerrefno,
        required this.trxnrefno,
        required this.banktrxnno,
        required this.bankname,
        required this.trxnstatus,
        required this.trxnstatusdesc,
        required this.amount,
        required this.trxndate,
        required this.trxnnote,
        required this.vpa,
        required this.transactedaccno,
        required this.transactedaccholdername,
        required this.ifsc,
        required this.upipayeevpa,
        required this.accountno,
        required this.payoutstatus,
        required this.payoutrefno,
        required this.devicetype,
        required this.paymenttype,
        required this.transactionifsc,
        required this.transactionaccountno,
        required this.trxnStatus,
        required this.trxnStatusDesc,
    });

    factory QrResponse.fromJson(Map<String, dynamic> json) => QrResponse(
        custname: json["custname"] ?? '',
        merchantid: json["merchantid"] ?? '',
        subbillerid: json["subbillerid"] ?? '',
        custid: json["custid"] ?? '',
        trxnno: json["trxnno"] ?? '',
        camspayrefno: json["camspayrefno"] ?? '',
        customerrefno: json["customerrefno"] ?? '',
        trxnrefno: json["trxnrefno"] ?? '',
        banktrxnno: json["banktrxnno"] ?? '',
        bankname: json["bankname"] ?? '',
        trxnstatus: json["trxnstatus"] ?? '',
        trxnstatusdesc: json["trxnstatusdesc"] ?? '',
        amount: json["amount"] ?? '',
        trxndate: json["trxndate"] ?? '',
        trxnnote: json["trxnnote"] ?? '',
        vpa: json["vpa"] ?? '',
        transactedaccno: json["transactedaccno"] ?? '',
        transactedaccholdername: json["transactedaccholdername"] ?? '',
        ifsc: json["ifsc"] ?? '',
        upipayeevpa: json["upipayeevpa"] ?? '',
        accountno: json["accountno"] ?? '',
        payoutstatus: json["payoutstatus"] ?? '',
        payoutrefno: json["payoutrefno"] ?? '',
        devicetype: json["devicetype"] ?? '',
        paymenttype: json["paymenttype"] ?? '',
        transactionifsc: json["transactionifsc"] ?? '',
        transactionaccountno: json["transactionaccountno"] ?? '',
        trxnStatus: json["trxn_status"] ?? '',
        trxnStatusDesc: json["trxn_status_desc"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "custname": custname,
        "merchantid": merchantid,
        "subbillerid": subbillerid,
        "custid": custid,
        "trxnno": trxnno,
        "camspayrefno": camspayrefno,
        "customerrefno": customerrefno,
        "trxnrefno": trxnrefno,
        "banktrxnno": banktrxnno,
        "bankname": bankname,
        "trxnstatus": trxnstatus,
        "trxnstatusdesc": trxnstatusdesc,
        "amount": amount,
        "trxndate": trxndate,
        "trxnnote": trxnnote,
        "vpa": vpa,
        "transactedaccno": transactedaccno,
        "transactedaccholdername": transactedaccholdername,
        "ifsc": ifsc,
        "upipayeevpa": upipayeevpa,
        "accountno": accountno,
        "payoutstatus": payoutstatus,
        "payoutrefno": payoutrefno,
        "devicetype": devicetype,
        "paymenttype": paymenttype,
        "transactionifsc": transactionifsc,
        "transactionaccountno": transactionaccountno,
        "trxn_status": trxnStatus,
        "trxn_status_desc": trxnStatusDesc,
    };
}
