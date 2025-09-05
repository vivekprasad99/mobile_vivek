class ValidateAadhaarOtpRes {
  String? code;
  String? message;
  String? responseCode;
  String? inputName;
  String? aadhaarName;
  double? matchScore;
  String? dob;
  String? gender;
  String? maskedVID;
  String? maskedAadhaar;
  String? profileImage;
  AadhaarAddress? aadhaarAddress;

  ValidateAadhaarOtpRes(
      {this.code,
        this.message,
        this.responseCode,
        this.inputName,
        this.aadhaarName,
        this.matchScore,
        this.dob,
        this.gender,
        this.maskedVID,
        this.maskedAadhaar,
        this.profileImage,
        this.aadhaarAddress});

  ValidateAadhaarOtpRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    inputName = json['inputName'];
    aadhaarName = json['aadhaarName'];
    matchScore = json['matchScore'];
    dob = json['dob'];
    gender = json['gender'];
    maskedVID = json['maskedVID'];
    maskedAadhaar = json['maskedAadhaar'];
    profileImage = json['profileImage'];
    aadhaarAddress = json['aadhaarAddress'] != null
        ? AadhaarAddress.fromJson(json['aadhaarAddress'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    data['inputName'] = inputName;
    data['aadhaarName'] = aadhaarName;
    data['matchScore'] = matchScore;
    data['dob'] = dob;
    data['gender'] = gender;
    data['maskedVID'] = maskedVID;
    data['maskedAadhaar'] = maskedAadhaar;
    data['profileImage'] = profileImage;
    if (aadhaarAddress != null) {
      data['aadhaarAddress'] = aadhaarAddress!.toJson();
    }
    return data;
  }
}

class AadhaarAddress {
  String? landmark;
  String? district;
  String? vtcName;
  String? location;
  String? postOffice;
  String? state;
  String? country;
  String? combinedAddress;
  String? pincode;

  AadhaarAddress(
      {this.landmark,
        this.district,
        this.vtcName,
        this.location,
        this.postOffice,
        this.state,
        this.country,
        this.combinedAddress,
        this.pincode});

  AadhaarAddress.fromJson(Map<String, dynamic> json) {
    landmark = json['landmark'];
    district = json['district'];
    vtcName = json['vtcName'];
    location = json['location'];
    postOffice = json['postOffice'];
    state = json['state'];
    country = json['country'];
    combinedAddress = json['combinedAddress'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['landmark'] = landmark;
    data['district'] = district;
    data['vtcName'] = vtcName;
    data['location'] = location;
    data['postOffice'] = postOffice;
    data['state'] = state;
    data['country'] = country;
    data['combinedAddress'] = combinedAddress;
    data['pincode'] = pincode;
    return data;
  }
}