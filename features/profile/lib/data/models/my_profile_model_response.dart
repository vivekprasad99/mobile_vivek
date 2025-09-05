class MyProfileResponse {
  String? code;
  String? message;
  String? responseCode;
  ProfileInfo? data;

  MyProfileResponse({this.code, this.message, this.responseCode, this.data});

  MyProfileResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    data = json['data'] != null ? ProfileInfo.fromJson(json['data']) : null;
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

class ProfileInfo {
  String? code;
  String? message;
  String? responseCode;
  String? customerName;
  String? mobileNumber;
  String? dob;
  String? emailID;
  String? aadhaarNumber;
  String? pan;
  String? gender;
  bool? addressUpdateAllowed;
  bool? otherUpdateAllowed;
  PermanentAddr? permanentAddr;
  PermanentAddr? communicationAddr;

  ProfileInfo(
      {this.code,
      this.message,
      this.responseCode,
      this.customerName,
      this.mobileNumber,
      this.dob,
      this.emailID,
      this.aadhaarNumber,
      this.pan,
      this.gender,
      this.addressUpdateAllowed,
      this.otherUpdateAllowed,
      this.permanentAddr,
      this.communicationAddr});

  ProfileInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    customerName = json['customerName'];
    mobileNumber = json['mobileNumber'];
    dob = json['dob'];
    emailID = json['emailID'];
    aadhaarNumber = json['aadhaarNumber'];
    pan = json['pan'];
    gender = json['gender'];
    addressUpdateAllowed = json['addressUpdateAllowed'];
    otherUpdateAllowed = json['otherUpdateAllowed'];
    permanentAddr = json['permanentAddr'] != null
        ? PermanentAddr.fromJson(json['permanentAddr'])
        : null;
    communicationAddr = json['communicationAddr'] != null
        ? PermanentAddr.fromJson(json['communicationAddr'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['customerName'] = customerName;
    data['mobileNumber'] = mobileNumber;
    data['dob'] = dob;
    data['emailID'] = emailID;
    data['aadhaarNumber'] = aadhaarNumber;
    data['pan'] = pan;
    data['gender'] = gender;
    data['addressUpdateAllowed'] = addressUpdateAllowed;
    data['otherUpdateAllowed'] = otherUpdateAllowed;
    if (permanentAddr != null) {
      data['permanentAddr'] = permanentAddr!.toJson();
    }
    if (communicationAddr != null) {
      data['communicationAddr'] = communicationAddr!.toJson();
    }
    return data;
  }
}

class PermanentAddr {
  String? city;
  String? state;
  String? postalCode;
  String? fullAddress;

  PermanentAddr({this.city, this.state, this.postalCode, this.fullAddress});

  PermanentAddr.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    fullAddress = json['fullAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['state'] = state;
    data['postalCode'] = postalCode;
    data['fullAddress'] = fullAddress;
    return data;
  }
}
