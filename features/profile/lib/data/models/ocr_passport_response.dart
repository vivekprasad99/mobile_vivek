class OCRPassportResponse {
  String? code;
  String? message;
  String? responseCode;
  List<Result>? result;

  OCRPassportResponse(
      {this.code, this.message, this.responseCode, this.result});

  OCRPassportResponse.fromJson(Map<String, dynamic> json) {
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
  String? gender;
  String? docType;
  String? passportNum;
  String? givenName;
  String? surname;
  String? dob;
  String? placeOfBirth;
  String? countryCode;
  String? placeOfIssue;
  String? doi;
  String? doe;
  String? type;
  String? father;
  String? mother;
  String? pin;
  String? fileNum;
  String? address;
  AddressSplit? addressSplit;
  Mrz? mrz;

  Result(
      { this.gender,
        this.docType,
        this.passportNum,
      this.givenName,
      this.surname,
      this.dob,
      this.placeOfBirth,
      this.countryCode,
      this.placeOfIssue,
      this.doi,
      this.doe,
      this.type,
      this.father,
      this.mother,
      this.pin,
      this.fileNum,
      this.address,
      this.addressSplit,
      this.mrz});

  Result.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    docType = json['docType'];
    passportNum = json['passportNum'];
    givenName = json['givenName'];
    surname = json['surname'];
    dob = json['dob'];
    placeOfBirth = json['placeOfBirth'];
    countryCode = json['countryCode'];
    placeOfIssue = json['placeOfIssue'];
    doi = json['doi'];
    doe = json['doe'];
    type = json['type'];
    father = json['father'];
    mother = json['mother'];
    pin = json['pin'];
    fileNum = json['fileNum'];
    address = json['address'];
    addressSplit = json['addressSplit'] != null
        ? AddressSplit.fromJson(json['addressSplit'])
        : null;
    mrz = json['mrz'] != null ? Mrz.fromJson(json['mrz']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['docType'] = docType;
    data['passportNum'] = passportNum;
    data['givenName'] = givenName;
    data['surname'] = surname;
    data['dob'] = dob;
    data['placeOfBirth'] = placeOfBirth;
    data['countryCode'] = countryCode;
    data['placeOfIssue'] = placeOfIssue;
    data['doi'] = doi;
    data['doe'] = doe;
    data['type'] = type;
    data['father'] = father;
    data['mother'] = mother;
    data['pin'] = pin;
    data['fileNum'] = fileNum;
    data['address'] = address;
    if (addressSplit != null) {
      data['addressSplit'] = addressSplit!.toJson();
    }
    if (mrz != null) {
      data['mrz'] = mrz!.toJson();
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

class Mrz {
  String? line2;
  String? line1;

  Mrz({this.line2, this.line1});

  Mrz.fromJson(Map<String, dynamic> json) {
    line2 = json['line2'];
    line1 = json['line1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line2'] = line2;
    data['line1'] = line1;
    return data;
  }
}
