class OCRVoterIDResponse {
  String? code;
  String? message;
  String? responseCode;
  List<Result>? result;

  OCRVoterIDResponse({this.code, this.message, this.responseCode, this.result});

  OCRVoterIDResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? docType;
  String? gender;
  String? dob;
  String? voterId;
  String? name;
  String? relation;
  String? pin;
  String? date;
  String? address;
  AddressSplit? addressSplit;

  Result(
      {this.docType,
        this.gender,
      this.dob,
      this.voterId,
      this.name,
      this.relation,
      this.pin,
      this.date,
      this.address,
      this.addressSplit});

  Result.fromJson(Map<String, dynamic> json) {
    docType = json['docType'];
    gender = json['gender'];
    dob = json['dob'];
    voterId = json['voterId'];
    name = json['name'];
    relation = json['relation'];
    pin = json['pin'];
    date = json['date'];
    address = json['address'];
    addressSplit = json['addressSplit'] != null
        ? AddressSplit.fromJson(json['addressSplit'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docType'] = docType;
    data['gender'] = gender;
    data['dob'] = dob;
    data['voterId'] = voterId;
    data['name'] = name;
    data['relation'] = relation;
    data['pin'] = pin;
    data['date'] = date;
    data['address'] = address;
    if (addressSplit != null) {
      data['addressSplit'] = addressSplit!.toJson();
    }
    return data;
  }
}

class AddressSplit {
  String? houseNumber;
  String? line1;
  String? line2;
  String? locality;
  String? street;
  String? landmark;
  String? city;
  String? district;
  String? state;
  String? pin;

  AddressSplit(
      {this.houseNumber,
      this.line1,
      this.line2,
      this.locality,
      this.street,
      this.landmark,
      this.city,
      this.district,
      this.state,
      this.pin});

  AddressSplit.fromJson(Map<String, dynamic> json) {
    houseNumber = json['houseNumber'];
    line1 = json['line1'];
    line2 = json['line2'];
    locality = json['locality'];
    street = json['street'];
    landmark = json['landmark'];
    city = json['city'];
    district = json['district'];
    state = json['state'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['houseNumber'] = houseNumber;
    data['line1'] = line1;
    data['line2'] = line2;
    data['locality'] = locality;
    data['street'] = street;
    data['landmark'] = landmark;
    data['city'] = city;
    data['district'] = district;
    data['state'] = state;
    data['pin'] = pin;
    return data;
  }
}
