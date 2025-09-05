import 'dart:convert';

CamspayResponseDcModel camspayResponseDcModelFromJson(String str) =>
    CamspayResponseDcModel.fromJson(json.decode(str));

String camspayResponseDcModelToJson(CamspayResponseDcModel data) =>
    json.encode(data.toJson());

class CamspayResponseDcModel {
  String accountholdername;
  String accountno;
  String amount;
  String bankname;
  String banktrxnrefno;
  String camspayrefno;
  String cardtype;
  String ifsc;
  String linkid;
  String msg;
  String msgdesc;
  Req req;
  String resc;
  String resdatetime;
  String trxndate;
  String trxnid;
  String trxnpt;
  String version;

  CamspayResponseDcModel({
    required this.accountholdername,
    required this.accountno,
    required this.amount,
    required this.bankname,
    required this.banktrxnrefno,
    required this.camspayrefno,
    required this.cardtype,
    required this.ifsc,
    required this.linkid,
    required this.msg,
    required this.msgdesc,
    required this.req,
    required this.resc,
    required this.resdatetime,
    required this.trxndate,
    required this.trxnid,
    required this.trxnpt,
    required this.version,
  });

  factory CamspayResponseDcModel.fromJson(Map<String, dynamic> json) =>
      CamspayResponseDcModel(
        accountholdername: json["accountholdername"] ?? '',
        accountno: json["accountno"] ?? '',
        amount: json["amount"] ?? '',
        bankname: json["bankname"] ?? '',
        banktrxnrefno: json["banktrxnrefno"] ?? '',
        camspayrefno: json["camspayrefno"] ?? '',
        cardtype: json["cardtype"] ?? '',
        ifsc: json["ifsc"] ?? '',
        linkid: json["linkid"] ?? '',
        msg: json["msg"] ?? '',
        msgdesc: json["msgdesc"] ?? '',
        req: Req.fromJson(json["req"]),
        resc: json["resc"] ?? '',
        resdatetime: json["resdatetime"] ?? '',
        trxndate: json["trxndate"] ?? '',
        trxnid: json["trxnid"] ?? '',
        trxnpt: json["trxnpt"] ?? '',
        version: json["version"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "accountholdername": accountholdername,
        "accountno": accountno,
        "amount": amount,
        "bankname": bankname,
        "banktrxnrefno": banktrxnrefno,
        "camspayrefno": camspayrefno,
        "cardtype": cardtype,
        "ifsc": ifsc,
        "linkid": linkid,
        "msg": msg,
        "msgdesc": msgdesc,
        "req": req.toJson(),
        "resc": resc,
        "resdatetime": resdatetime,
        "trxndate": trxndate,
        "trxnid": trxnid,
        "trxnpt": trxnpt,
        "version": version,
      };
}

class Req {
  String accno;
  String amount;
  String applicationname;
  String bankcode;
  String cardholdername;
  String currency;
  dynamic custid;
  String devicetype;
  String expirymonth;
  String expiryyear;
  String failureurl;
  String ifsc;
  String remarks;
  String reqdt;
  String successurl;
  String trxnid;

  Req({
    required this.accno,
    required this.amount,
    required this.applicationname,
    required this.bankcode,
    required this.cardholdername,
    required this.currency,
    required this.custid,
    required this.devicetype,
    required this.expirymonth,
    required this.expiryyear,
    required this.failureurl,
    required this.ifsc,
    required this.remarks,
    required this.reqdt,
    required this.successurl,
    required this.trxnid,
  });

  factory Req.fromJson(Map<String, dynamic> json) => Req(
        accno: json["accno"] ?? '',
        amount: json["amount"] ?? '',
        applicationname: json["applicationname"] ?? '',
        bankcode: json["bankcode"] ?? '',
        cardholdername: json["cardholdername"] ?? '',
        currency: json["currency"] ?? '',
        custid: json["custid"] ?? '',
        devicetype: json["devicetype"] ?? '',
        expirymonth: json["expirymonth"] ?? '',
        expiryyear: json["expiryyear"] ?? '',
        failureurl: json["failureurl"] ?? '',
        ifsc: json["ifsc"] ?? '',
        remarks: json["remarks"] ?? '',
        reqdt: json["reqdt"] ?? '',
        successurl: json["successurl"] ?? '',
        trxnid: json["trxnid"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "accno": accno,
        "amount": amount,
        "applicationname": applicationname,
        "bankcode": bankcode,
        "cardholdername": cardholdername,
        "currency": currency,
        "custid": custid,
        "devicetype": devicetype,
        "expirymonth": expirymonth,
        "expiryyear": expiryyear,
        "failureurl": failureurl,
        "ifsc": ifsc,
        "remarks": remarks,
        "reqdt": reqdt,
        "successurl": successurl,
        "trxnid": trxnid,
      };
}
