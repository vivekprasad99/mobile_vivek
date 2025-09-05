class LandingPreOfferResponse {
    final String? code;
    final String? message;
    final String? responseCode;
    final List<OfferDatum>? offerData;
    final PlLeadResponse? plLeadResponse;

    LandingPreOfferResponse({
        this.code,
        this.message,
        this.responseCode,
        this.offerData,
        this.plLeadResponse,
    });

    factory LandingPreOfferResponse.fromJson(Map<String, dynamic> json) => LandingPreOfferResponse(
        code: json["code"],
        message: json["message"],
        responseCode: json["responseCode"],
        offerData: json["offerData"] == null ? [] : List<OfferDatum>.from(json["offerData"]!.map((x) => OfferDatum.fromJson(x))),
        plLeadResponse: json["plLeadResponse"] == null ? null : PlLeadResponse.fromJson(json["plLeadResponse"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "responseCode": responseCode,
        "offerData": offerData == null ? [] : List<dynamic>.from(offerData!.map((x) => x.toJson())),
        "plLeadResponse": plLeadResponse?.toJson(),
    };
}

class OfferDatum {
    final String? message;
    final bool? success;
    final String? statusCode;
    final Result? result;

    OfferDatum({
        this.message,
        this.success,
        this.statusCode,
        this.result,
    });

    factory OfferDatum.fromJson(Map<String, dynamic> json) => OfferDatum(
        message: json["message"],
        success: json["success"],
        statusCode: json["statusCode"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "statusCode": statusCode,
        "result": result?.toJson(),
    };
}

class Result {
    final String? parentHpaNo;
    final String? currentStatus;
    final String? suvidhaLoanEligibilty;
    final String? parentLoanRepaymentFrequency;
    final String? parentLoanEmiStartDate;
    final String? parentLoanRepaymnentFrequencyNumeric;
    final String? parentLoanRepaymentMode;
    final String? minimumEligibleFlatRatePa;
    final String? maximumEligibleFlatRatePa;
    final String? eligibleRepayFrequencyM;
    final String? eligibleRepayFrequencyQ;
    final String? eligibleRepayFrequencyH;
    final String? eligibleRepayModeCash;
    final String? defaultRepayMode;
    final String? minimumMoratoriumPeriod;
    final String? maximumMoratoriumPeriod;
    final String? defaultMoratoriumPeriod;
    final String? pfServiceCharge;
    final String? offerCode;
    final String? offerName;
    final String? modifiedDate;
    final String? newOffer;
    final String? offerExpiryDate;
    final String? execSap;
    final String? execName;
    final String? execNum;
    final String? managerSap;
    final String? managerName;
    final String? type;
    final String? totalPayable;
    final String? emiAmount;
    final String? defaultEligibleAmount;
    final String? maximumEligibleAmount;
    final String? minimumEligibleAmount;
    final String? defaultEligibleTenure;
    final String? maximumEligibleTenure;
    final String? minimumEligibleTenure;
    final String? defaultRepaymentFrequency;
    final String? defaultEligibleFlatRatePa;
    final String? parentLoanStartDate;
    final String? parentLoanLastDate;
    final int? mobileNo;
    final int? clusterId;
    final String? name;
    final String? dateOfBirth;
    final String? misSector;
    final String? busVertical;
    final String? branch;
    final String? stateDes;
    final String? pinCode;
    final String? manudes;
    final String? tenure;
    final String? assdes;
    final String? regno;
    final String? gender;
    final String? chsNo;
    final String? engNo;
    final String? place;
    final String? postOffice;
    final String? roadName;
    final String? landMark;
    final String? cityVillage;
    final String? taluk;
    final String? bankAcNo;
    final String? bankName;
    final String? bankBranchName;
    final String? ifscCode;
    final String? bankAccountType;
    final String? ckycAvailable;
    final String? lastPaymentOnline;
    final String? rocEmailId;
    final String? racEmailId;
    final String? branchName;
    final String? micrCode;

    Result({
        this.parentHpaNo,
        this.currentStatus,
        this.suvidhaLoanEligibilty,
        this.parentLoanRepaymentFrequency,
        this.parentLoanEmiStartDate,
        this.parentLoanRepaymnentFrequencyNumeric,
        this.parentLoanRepaymentMode,
        this.minimumEligibleFlatRatePa,
        this.maximumEligibleFlatRatePa,
        this.eligibleRepayFrequencyM,
        this.eligibleRepayFrequencyQ,
        this.eligibleRepayFrequencyH,
        this.eligibleRepayModeCash,
        this.defaultRepayMode,
        this.minimumMoratoriumPeriod,
        this.maximumMoratoriumPeriod,
        this.defaultMoratoriumPeriod,
        this.pfServiceCharge,
        this.offerCode,
        this.offerName,
        this.modifiedDate,
        this.newOffer,
        this.offerExpiryDate,
        this.execSap,
        this.execName,
        this.execNum,
        this.managerSap,
        this.managerName,
        this.type,
        this.totalPayable,
        this.emiAmount,
        this.defaultEligibleAmount,
        this.maximumEligibleAmount,
        this.minimumEligibleAmount,
        this.defaultEligibleTenure,
        this.maximumEligibleTenure,
        this.minimumEligibleTenure,
        this.defaultRepaymentFrequency,
        this.defaultEligibleFlatRatePa,
        this.parentLoanStartDate,
        this.parentLoanLastDate,
        this.mobileNo,
        this.clusterId,
        this.name,
        this.dateOfBirth,
        this.misSector,
        this.busVertical,
        this.branch,
        this.stateDes,
        this.pinCode,
        this.manudes,
        this.tenure,
        this.assdes,
        this.regno,
        this.gender,
        this.chsNo,
        this.engNo,
        this.place,
        this.postOffice,
        this.roadName,
        this.landMark,
        this.cityVillage,
        this.taluk,
        this.bankAcNo,
        this.bankName,
        this.bankBranchName,
        this.ifscCode,
        this.bankAccountType,
        this.ckycAvailable,
        this.lastPaymentOnline,
        this.rocEmailId,
        this.racEmailId,
        this.branchName,
        this.micrCode,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        parentHpaNo: json["parentHpaNo"],
        currentStatus: json["currentStatus"],
        suvidhaLoanEligibilty: json["suvidhaLoanEligibilty"],
        parentLoanRepaymentFrequency: json["parentLoanRepaymentFrequency"],
        parentLoanEmiStartDate: json["parentLoanEmiStartDate"],
        parentLoanRepaymnentFrequencyNumeric: json["parentLoanRepaymnentFrequencyNumeric"],
        parentLoanRepaymentMode: json["parentLoanRepaymentMode"],
        minimumEligibleFlatRatePa: json["minimumEligibleFlatRatePa"],
        maximumEligibleFlatRatePa: json["maximumEligibleFlatRatePa"],
        eligibleRepayFrequencyM: json["eligibleRepayFrequencyM"],
        eligibleRepayFrequencyQ: json["eligibleRepayFrequencyQ"],
        eligibleRepayFrequencyH: json["eligibleRepayFrequencyH"],
        eligibleRepayModeCash: json["eligibleRepayModeCash"],
        defaultRepayMode: json["defaultRepayMode"],
        minimumMoratoriumPeriod: json["minimumMoratoriumPeriod"],
        maximumMoratoriumPeriod: json["maximumMoratoriumPeriod"],
        defaultMoratoriumPeriod: json["defaultMoratoriumPeriod"],
        pfServiceCharge: json["pfServiceCharge"],
        offerCode: json["offerCode"],
        offerName: json["offerName"],
        modifiedDate: json["modifiedDate"],
        newOffer: json["newOffer"],
        offerExpiryDate: json["offerExpiryDate"],
        execSap: json["execSap"],
        execName: json["execName"],
        execNum: json["execNum"],
        managerSap: json["managerSap"],
        managerName: json["managerName"],
        type: json["type"],
        totalPayable: json["totalPayable"],
        emiAmount: json["emiAmount"],
        defaultEligibleAmount: json["defaultEligibleAmount"],
        maximumEligibleAmount: json["maximumEligibleAmount"],
        minimumEligibleAmount: json["minimumEligibleAmount"],
        defaultEligibleTenure: json["defaultEligibleTenure"],
        maximumEligibleTenure: json["maximumEligibleTenure"],
        minimumEligibleTenure: json["minimumEligibleTenure"],
        defaultRepaymentFrequency: json["defaultRepaymentFrequency"],
        defaultEligibleFlatRatePa: json["defaultEligibleFlatRatePa"],
        parentLoanStartDate: json["parentLoanStartDate"],
        parentLoanLastDate: json["parentLoanLastDate"],
        mobileNo: json["mobileNo"],
        clusterId: json["clusterId"],
        name: json["name"],
        dateOfBirth: json["dateOfBirth"],
        misSector: json["misSector"],
        busVertical: json["busVertical"],
        branch: json["branch"],
        stateDes: json["stateDes"],
        pinCode: json["pinCode"],
        manudes: json["manudes"],
        tenure: json["tenure"],
        assdes: json["assdes"],
        regno: json["regno"],
        gender: json["gender"],
        chsNo: json["chsNo"],
        engNo: json["engNo"],
        place: json["place"],
        postOffice: json["postOffice"],
        roadName: json["roadName"],
        landMark: json["landMark"],
        cityVillage: json["cityVillage"],
        taluk: json["taluk"],
        bankAcNo: json["bankAcNo"],
        bankName: json["bankName"],
        bankBranchName: json["bankBranchName"],
        ifscCode: json["ifscCode"],
        bankAccountType: json["bankAccountType"],
        ckycAvailable: json["ckycAvailable"],
        lastPaymentOnline: json["lastPaymentOnline"],
        rocEmailId: json["rocEmailId"],
        racEmailId: json["racEmailId"],
        branchName: json["branchName"],
        micrCode: json["micrCode"],
    );

    Map<String, dynamic> toJson() => {
        "parentHpaNo": parentHpaNo,
        "currentStatus": currentStatus,
        "suvidhaLoanEligibilty": suvidhaLoanEligibilty,
        "parentLoanRepaymentFrequency": parentLoanRepaymentFrequency,
        "parentLoanEmiStartDate": parentLoanEmiStartDate,
        "parentLoanRepaymnentFrequencyNumeric": parentLoanRepaymnentFrequencyNumeric,
        "parentLoanRepaymentMode": parentLoanRepaymentMode,
        "minimumEligibleFlatRatePa": minimumEligibleFlatRatePa,
        "maximumEligibleFlatRatePa": maximumEligibleFlatRatePa,
        "eligibleRepayFrequencyM": eligibleRepayFrequencyM,
        "eligibleRepayFrequencyQ": eligibleRepayFrequencyQ,
        "eligibleRepayFrequencyH": eligibleRepayFrequencyH,
        "eligibleRepayModeCash": eligibleRepayModeCash,
        "defaultRepayMode": defaultRepayMode,
        "minimumMoratoriumPeriod": minimumMoratoriumPeriod,
        "maximumMoratoriumPeriod": maximumMoratoriumPeriod,
        "defaultMoratoriumPeriod": defaultMoratoriumPeriod,
        "pfServiceCharge": pfServiceCharge,
        "offerCode": offerCode,
        "offerName": offerName,
        "modifiedDate": modifiedDate,
        "newOffer": newOffer,
        "offerExpiryDate": offerExpiryDate,
        "execSap": execSap,
        "execName": execName,
        "execNum": execNum,
        "managerSap": managerSap,
        "managerName": managerName,
        "type": type,
        "totalPayable": totalPayable,
        "emiAmount": emiAmount,
        "defaultEligibleAmount": defaultEligibleAmount,
        "maximumEligibleAmount": maximumEligibleAmount,
        "minimumEligibleAmount": minimumEligibleAmount,
        "defaultEligibleTenure": defaultEligibleTenure,
        "maximumEligibleTenure": maximumEligibleTenure,
        "minimumEligibleTenure": minimumEligibleTenure,
        "defaultRepaymentFrequency": defaultRepaymentFrequency,
        "defaultEligibleFlatRatePa": defaultEligibleFlatRatePa,
        "parentLoanStartDate": parentLoanStartDate,
        "parentLoanLastDate": parentLoanLastDate,
        "mobileNo": mobileNo,
        "clusterId": clusterId,
        "name": name,
        "dateOfBirth": dateOfBirth,
        "misSector": misSector,
        "busVertical": busVertical,
        "branch": branch,
        "stateDes": stateDes,
        "pinCode": pinCode,
        "manudes": manudes,
        "tenure": tenure,
        "assdes": assdes,
        "regno": regno,
        "gender": gender,
        "chsNo": chsNo,
        "engNo": engNo,
        "place": place,
        "postOffice": postOffice,
        "roadName": roadName,
        "landMark": landMark,
        "cityVillage": cityVillage,
        "taluk": taluk,
        "bankAcNo": bankAcNo,
        "bankName": bankName,
        "bankBranchName": bankBranchName,
        "ifscCode": ifscCode,
        "bankAccountType": bankAccountType,
        "ckycAvailable": ckycAvailable,
        "lastPaymentOnline": lastPaymentOnline,
        "rocEmailId": rocEmailId,
        "racEmailId": racEmailId,
        "branchName": branchName,
        "micrCode": micrCode,
    };
}

class PlLeadResponse {
    final Response? response;
    final String? serviceName;
    final String? error;
    final String? message;

    PlLeadResponse({
        this.response,
        this.serviceName,
        this.error,
        this.message,
    });

    factory PlLeadResponse.fromJson(Map<String, dynamic> json) => PlLeadResponse(
        response: json["response"] == null ? null : Response.fromJson(json["response"]),
        serviceName: json["serviceName"],
        error: json["error"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "response": response?.toJson(),
        "serviceName": serviceName,
        "error": error,
        "message": message,
    };
}

class Response {
    final Crmres? crmres;
    final dynamic errorres;

    Response({
        this.crmres,
        this.errorres,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        crmres: json["crmres"] == null ? null : Crmres.fromJson(json["crmres"]),
        errorres: json["errorres"],
    );

    Map<String, dynamic> toJson() => {
        "crmres": crmres?.toJson(),
        "errorres": errorres,
    };
}

class Crmres {
    final List<Address>? addresses;
    final List<OffersDetail>? offersDetails;
    final String? aadharcard;
    final String? alternatenumber1;
    final String? alternatenumber2;
    final String? alternatenumber3;
    final String? alternatenumber4;
    final String? bankaccountnumber;
    final String? bankaccounttype;
    final String? bankifsc;
    final String? bankname;
    final String? cibilscore;
    final String? ckycnumber;
    final String? clusterid;
    final String? customercif;
    final String? customerfullname;
    final String? customerlms;
    final String? customersegment;
    final String? dob;
    final String? fathername;
    final String? firstname;
    final String? gender;
    final String? incomeband;
    final String? incomecontiniuity;
    final String? isckyc;
    final String? iskycresuable;
    final String? ismandatereusable;
    final String? lastname;
    final String? middlename;
    final String? mothername;
    final String? pancard;
    final String? phonenumber;

    Crmres({
        this.addresses,
        this.offersDetails,
        this.aadharcard,
        this.alternatenumber1,
        this.alternatenumber2,
        this.alternatenumber3,
        this.alternatenumber4,
        this.bankaccountnumber,
        this.bankaccounttype,
        this.bankifsc,
        this.bankname,
        this.cibilscore,
        this.ckycnumber,
        this.clusterid,
        this.customercif,
        this.customerfullname,
        this.customerlms,
        this.customersegment,
        this.dob,
        this.fathername,
        this.firstname,
        this.gender,
        this.incomeband,
        this.incomecontiniuity,
        this.isckyc,
        this.iskycresuable,
        this.ismandatereusable,
        this.lastname,
        this.middlename,
        this.mothername,
        this.pancard,
        this.phonenumber,
    });

    factory Crmres.fromJson(Map<String, dynamic> json) => Crmres(
        addresses: json["Addresses"] == null ? [] : List<Address>.from(json["Addresses"]!.map((x) => Address.fromJson(x))),
        offersDetails: json["OffersDetails"] == null ? [] : List<OffersDetail>.from(json["OffersDetails"]!.map((x) => OffersDetail.fromJson(x))),
        aadharcard: json["aadharcard"],
        alternatenumber1: json["alternatenumber1"],
        alternatenumber2: json["alternatenumber2"],
        alternatenumber3: json["alternatenumber3"],
        alternatenumber4: json["alternatenumber4"],
        bankaccountnumber: json["bankaccountnumber"],
        bankaccounttype: json["bankaccounttype"],
        bankifsc: json["bankifsc"],
        bankname: json["bankname"],
        cibilscore: json["cibilscore"],
        ckycnumber: json["ckycnumber"],
        clusterid: json["clusterid"],
        customercif: json["customercif"],
        customerfullname: json["customerfullname"],
        customerlms: json["customerlms"],
        customersegment: json["customersegment"],
        dob: json["dob"],
        fathername: json["fathername"],
        firstname: json["firstname"],
        gender: json["gender"],
        incomeband: json["incomeband"],
        incomecontiniuity: json["incomecontiniuity"],
        isckyc: json["isckyc"],
        iskycresuable: json["iskycresuable"],
        ismandatereusable: json["ismandatereusable"],
        lastname: json["lastname"],
        middlename: json["middlename"],
        mothername: json["mothername"],
        pancard: json["pancard"],
        phonenumber: json["phonenumber"],
    );

    Map<String, dynamic> toJson() => {
        "Addresses": addresses == null ? [] : List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "OffersDetails": offersDetails == null ? [] : List<dynamic>.from(offersDetails!.map((x) => x.toJson())),
        "aadharcard": aadharcard,
        "alternatenumber1": alternatenumber1,
        "alternatenumber2": alternatenumber2,
        "alternatenumber3": alternatenumber3,
        "alternatenumber4": alternatenumber4,
        "bankaccountnumber": bankaccountnumber,
        "bankaccounttype": bankaccounttype,
        "bankifsc": bankifsc,
        "bankname": bankname,
        "cibilscore": cibilscore,
        "ckycnumber": ckycnumber,
        "clusterid": clusterid,
        "customercif": customercif,
        "customerfullname": customerfullname,
        "customerlms": customerlms,
        "customersegment": customersegment,
        "dob": dob,
        "fathername": fathername,
        "firstname": firstname,
        "gender": gender,
        "incomeband": incomeband,
        "incomecontiniuity": incomecontiniuity,
        "isckyc": isckyc,
        "iskycresuable": iskycresuable,
        "ismandatereusable": ismandatereusable,
        "lastname": lastname,
        "middlename": middlename,
        "mothername": mothername,
        "pancard": pancard,
        "phonenumber": phonenumber,
    };
}

class Address {
    final String? bureauaddresslastupdateddate;
    final String? district;
    final String? landmark;
    final String? remarks;
    final String? street;
    final String? addrType;
    final String? addressLine1;
    final String? addressLine2;
    final String? addressLine3;
    final String? buildingNo;
    final String? city;
    final String? pincode;
    final String? state;
    final String? taluka;

    Address({
        this.bureauaddresslastupdateddate,
        this.district,
        this.landmark,
        this.remarks,
        this.street,
        this.addrType,
        this.addressLine1,
        this.addressLine2,
        this.addressLine3,
        this.buildingNo,
        this.city,
        this.pincode,
        this.state,
        this.taluka,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        bureauaddresslastupdateddate: json["BUREAUADDRESSLASTUPDATEDDATE"],
        district: json["District"],
        landmark: json["Landmark"],
        remarks: json["Remarks"],
        street: json["Street"],
        addrType: json["addrType"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        addressLine3: json["address_line_3"],
        buildingNo: json["buildingNo"],
        city: json["city"],
        pincode: json["pincode"],
        state: json["state"],
        taluka: json["taluka"],
    );

    Map<String, dynamic> toJson() => {
        "BUREAUADDRESSLASTUPDATEDDATE": bureauaddresslastupdateddate,
        "District": district,
        "Landmark": landmark,
        "Remarks": remarks,
        "Street": street,
        "addrType": addrType,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "address_line_3": addressLine3,
        "buildingNo": buildingNo,
        "city": city,
        "pincode": pincode,
        "state": state,
        "taluka": taluka,
    };
}

class OffersDetail {
    final String? aaexpirydate;
    final String? aaincome;
    final String? aastatus;
    final String? aatries;
    final String? alternateNumber1;
    final String? alternateNumber2;
    final String? alternateNumber3;
    final String? alternateNumber4;
    final String? branchX;
    final String? brndesX;
    final String? busVerticalX;
    final String? creditexpirydate;
    final String? creditstatus;
    final String? currentInterestRate;
    final String? currentMaximumAmount;
    final String? currentMaximumTenure;
    final String? currentMinimumAmount;
    final String? currentMinimumTenure;
    final String? currentModifiedDate;
    final String? currentOfferCode;
    final String? currentOfferCreatedDate;
    final String? currentOfferExpiryDate;
    final String? currentOfferType;
    final String? currentOfferstatus;
    final String? currentProcessingFees;
    final String? customerFullname;
    final String? cvalgosriskcategory;
    final String? cvalgosriskdecile;
    final String? defaultInterestRate;
    final String? emiDueDateOfOfferLoan;
    final String? emiDueDateOfParentLoan;
    final String? execName;
    final String? execNum;
    final String? execSap;
    final String? foirlimit;
    final String? highestProcessingFeeChargeable;
    final String? highestStampDuty;
    final String? interestrate;
    final String? leadId;
    final String? leadstage;
    final String? leadstageupdatedateandtime;
    final String? loanamountselected;
    final String? loanamountselecteddate;
    final String? loantenureselected;
    final String? managerName;
    final String? managerSap;
    final String? maximumInterestRate;
    final String? maximumemi;
    final String? maximumfoir;
    final String? minimumEmi;
    final String? minimumInterestRate;
    final String? mobilenumber;
    final String? onscreenrvstatus;
    final String? onscreenrvtries;
    final String? opsbre;
    final String? processingfeestype;
    final String? productName;
    final String? repaymentFrequencyOfOffer;
    final String? repaymentFrequencyOfParentLoan;
    final String? silentrvcompleted;
    final String? stampDutyFeesType;
    final String? stampcharges;
    final String? stampdutyfees;
    final String? typeX;

    OffersDetail({
        this.aaexpirydate,
        this.aaincome,
        this.aastatus,
        this.aatries,
        this.alternateNumber1,
        this.alternateNumber2,
        this.alternateNumber3,
        this.alternateNumber4,
        this.branchX,
        this.brndesX,
        this.busVerticalX,
        this.creditexpirydate,
        this.creditstatus,
        this.currentInterestRate,
        this.currentMaximumAmount,
        this.currentMaximumTenure,
        this.currentMinimumAmount,
        this.currentMinimumTenure,
        this.currentModifiedDate,
        this.currentOfferCode,
        this.currentOfferCreatedDate,
        this.currentOfferExpiryDate,
        this.currentOfferType,
        this.currentOfferstatus,
        this.currentProcessingFees,
        this.customerFullname,
        this.cvalgosriskcategory,
        this.cvalgosriskdecile,
        this.defaultInterestRate,
        this.emiDueDateOfOfferLoan,
        this.emiDueDateOfParentLoan,
        this.execName,
        this.execNum,
        this.execSap,
        this.foirlimit,
        this.highestProcessingFeeChargeable,
        this.highestStampDuty,
        this.interestrate,
        this.leadId,
        this.leadstage,
        this.leadstageupdatedateandtime,
        this.loanamountselected,
        this.loanamountselecteddate,
        this.loantenureselected,
        this.managerName,
        this.managerSap,
        this.maximumInterestRate,
        this.maximumemi,
        this.maximumfoir,
        this.minimumEmi,
        this.minimumInterestRate,
        this.mobilenumber,
        this.onscreenrvstatus,
        this.onscreenrvtries,
        this.opsbre,
        this.processingfeestype,
        this.productName,
        this.repaymentFrequencyOfOffer,
        this.repaymentFrequencyOfParentLoan,
        this.silentrvcompleted,
        this.stampDutyFeesType,
        this.stampcharges,
        this.stampdutyfees,
        this.typeX,
    });

    factory OffersDetail.fromJson(Map<String, dynamic> json) => OffersDetail(
        aaexpirydate: json["aaexpirydate"],
        aaincome: json["aaincome"],
        aastatus: json["aastatus"],
        aatries: json["aatries"],
        alternateNumber1: json["alternate_number1"],
        alternateNumber2: json["alternate_number2"],
        alternateNumber3: json["alternate_number3"],
        alternateNumber4: json["alternate_number4"],
        branchX: json["branch_x"],
        brndesX: json["brndes_x"],
        busVerticalX: json["bus_vertical_x"],
        creditexpirydate: json["creditexpirydate"],
        creditstatus: json["creditstatus"],
        currentInterestRate: json["current_interest_rate"],
        currentMaximumAmount: json["current_maximum_amount"],
        currentMaximumTenure: json["current_maximum_tenure"],
        currentMinimumAmount: json["current_minimum_amount"],
        currentMinimumTenure: json["current_minimum_tenure"],
        currentModifiedDate: json["current_modified_date"],
        currentOfferCode: json["current_offer_code"],
        currentOfferCreatedDate: json["current_offer_created_date"],
        currentOfferExpiryDate: json["current_offer_expiry_date"],
        currentOfferType: json["current_offer_type"],
        currentOfferstatus: json["current_offerstatus"],
        currentProcessingFees: json["current_processing_fees"],
        customerFullname: json["customer_fullname"],
        cvalgosriskcategory: json["cvalgosriskcategory"],
        cvalgosriskdecile: json["cvalgosriskdecile"],
        defaultInterestRate: json["default_interest_rate"],
        emiDueDateOfOfferLoan: json["emi_due_date_of_offer_loan"],
        emiDueDateOfParentLoan: json["emi_due_date_of_parent_loan"],
        execName: json["exec_name"],
        execNum: json["exec_num"],
        execSap: json["exec_sap"],
        foirlimit: json["foirlimit"],
        highestProcessingFeeChargeable: json["highest_processing_fee_chargeable"],
        highestStampDuty: json["highest_stamp_duty"],
        interestrate: json["interestrate"],
        leadId: json["lead_id"],
        leadstage: json["leadstage"],
        leadstageupdatedateandtime: json["leadstageupdatedateandtime"],
        loanamountselected: json["loanamountselected"],
        loanamountselecteddate: json["loanamountselecteddate"],
        loantenureselected: json["loantenureselected"],
        managerName: json["manager_name"],
        managerSap: json["manager_sap"],
        maximumInterestRate: json["maximum_interest_rate"],
        maximumemi: json["maximumemi"],
        maximumfoir: json["maximumfoir"],
        minimumEmi: json["minimum_emi"],
        minimumInterestRate: json["minimum_interest_rate"],
        mobilenumber: json["mobilenumber"],
        onscreenrvstatus: json["onscreenrvstatus"],
        onscreenrvtries: json["onscreenrvtries"],
        opsbre: json["opsbre"],
        processingfeestype: json["processingfeestype"],
        productName: json["product_name"],
        repaymentFrequencyOfOffer: json["repayment_frequency_of_offer"],
        repaymentFrequencyOfParentLoan: json["repayment_frequency_of_parent_loan"],
        silentrvcompleted: json["silentrvcompleted"],
        stampDutyFeesType: json["stamp_duty_fees_type"],
        stampcharges: json["stampcharges"],
        stampdutyfees: json["stampdutyfees"],
        typeX: json["type_x"],
    );

    Map<String, dynamic> toJson() => {
        "aaexpirydate": aaexpirydate,
        "aaincome": aaincome,
        "aastatus": aastatus,
        "aatries": aatries,
        "alternate_number1": alternateNumber1,
        "alternate_number2": alternateNumber2,
        "alternate_number3": alternateNumber3,
        "alternate_number4": alternateNumber4,
        "branch_x": branchX,
        "brndes_x": brndesX,
        "bus_vertical_x": busVerticalX,
        "creditexpirydate": creditexpirydate,
        "creditstatus": creditstatus,
        "current_interest_rate": currentInterestRate,
        "current_maximum_amount": currentMaximumAmount,
        "current_maximum_tenure": currentMaximumTenure,
        "current_minimum_amount": currentMinimumAmount,
        "current_minimum_tenure": currentMinimumTenure,
        "current_modified_date": currentModifiedDate,
        "current_offer_code": currentOfferCode,
        "current_offer_created_date": currentOfferCreatedDate,
        "current_offer_expiry_date": currentOfferExpiryDate,
        "current_offer_type": currentOfferType,
        "current_offerstatus": currentOfferstatus,
        "current_processing_fees": currentProcessingFees,
        "customer_fullname": customerFullname,
        "cvalgosriskcategory": cvalgosriskcategory,
        "cvalgosriskdecile": cvalgosriskdecile,
        "default_interest_rate": defaultInterestRate,
        "emi_due_date_of_offer_loan": emiDueDateOfOfferLoan,
        "emi_due_date_of_parent_loan": emiDueDateOfParentLoan,
        "exec_name": execName,
        "exec_num": execNum,
        "exec_sap": execSap,
        "foirlimit": foirlimit,
        "highest_processing_fee_chargeable": highestProcessingFeeChargeable,
        "highest_stamp_duty": highestStampDuty,
        "interestrate": interestrate,
        "lead_id": leadId,
        "leadstage": leadstage,
        "leadstageupdatedateandtime": leadstageupdatedateandtime,
        "loanamountselected": loanamountselected,
        "loanamountselecteddate": loanamountselecteddate,
        "loantenureselected": loantenureselected,
        "manager_name": managerName,
        "manager_sap": managerSap,
        "maximum_interest_rate": maximumInterestRate,
        "maximumemi": maximumemi,
        "maximumfoir": maximumfoir,
        "minimum_emi": minimumEmi,
        "minimum_interest_rate": minimumInterestRate,
        "mobilenumber": mobilenumber,
        "onscreenrvstatus": onscreenrvstatus,
        "onscreenrvtries": onscreenrvtries,
        "opsbre": opsbre,
        "processingfeestype": processingfeestype,
        "product_name": productName,
        "repayment_frequency_of_offer": repaymentFrequencyOfOffer,
        "repayment_frequency_of_parent_loan": repaymentFrequencyOfParentLoan,
        "silentrvcompleted": silentrvcompleted,
        "stamp_duty_fees_type": stampDutyFeesType,
        "stampcharges": stampcharges,
        "stampdutyfees": stampdutyfees,
        "type_x": typeX,
    };
}
