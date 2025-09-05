class GetLoansResponse {
  final String? code;
  final String? message;
  final String? responseCode;
  final List<Data>? data;
  const GetLoansResponse(
      {this.code, this.message, this.responseCode, this.data,});
  GetLoansResponse copyWith(
      {String? code, String? message, String? responseCode, List<Data>? data,}) {
    return GetLoansResponse(
        code: code ?? this.code,
        message: message ?? this.message,
        responseCode: responseCode ?? this.responseCode,
        data: data ?? this.data,);
  }

  Map<String, Object?> toJson() {
    return {
      'code': code,
      'message': message,
      'responseCode': responseCode,
      'data': data?.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }

  static GetLoansResponse fromJson(Map<String, Object?> json) {
    return GetLoansResponse(
        code: json['code'] == null ? null : json['code'] as String,
        message: json['message'] == null ? null : json['message'] as String,
        responseCode: json['responseCode'] == null
            ? null
            : json['responseCode'] as String,
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map<Data>(
                    (data) => Data.fromJson(data as Map<String, Object?>),)
                .toList(),);
  }

  @override
  String toString() {
    return '''GetLoansResponse(
                code:$code,
message:$message,
responseCode:$responseCode,
data:${data.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is GetLoansResponse &&
        other.runtimeType == runtimeType &&
        other.code == code &&
        other.message == message &&
        other.responseCode == responseCode &&
        other.data == data;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, code, message, responseCode, data);
  }
}

class Data {
  final String? ucic;
  final String? mobileNumber;
  final dynamic tenantId;
  final String? cif;
  final String? coApplicantCIF;
  final String? applicantName;
  final String? coApplicantName;
  final String? branchId;
  final String? loanAccountNumber;
  final double? totalAmount;
  final double? totalPendingAmount;
  final double? interestRate;
  final double? installmentAmount;
  final double? excessAmount;
  final String? startDate;
  final String? endDate;
  final String? nextDuedate;
  final String? loanStatus;
  final int? dpd;
  final String? lob;
  final dynamic nocStatus;
  final String? mandateStatus;
  final String? productName;
  final String? vehicleRegistration;
  final String? sourceSystem;
  final String? productCategory;
  const Data(
      {this.ucic,
      this.mobileNumber,
      this.tenantId,
      this.cif,
      this.coApplicantCIF,
      this.applicantName,
      this.coApplicantName,
      this.branchId,
      this.loanAccountNumber,
      this.totalAmount,
      this.totalPendingAmount,
      this.interestRate,
      this.installmentAmount,
      this.excessAmount,
      this.startDate,
      this.endDate,
      this.nextDuedate,
      this.loanStatus,
      this.dpd,
      this.lob,
      this.nocStatus,
      this.mandateStatus,
      this.productName,
      this.vehicleRegistration,
      this.sourceSystem,
      this.productCategory,});
  Data copyWith(
      {String? ucic,
      String? mobileNumber,
      dynamic tenantId,
      String? cif,
      String? coApplicantCIF,
      String? applicantName,
      String? coApplicantName,
      String? branchId,
      String? loanAccountNumber,
      double? totalAmount,
      double? totalPendingAmount,
      double? interestRate,
      double? installmentAmount,
      double? excessAmount,
      String? startDate,
      String? endDate,
      String? nextDuedate,
      String? loanStatus,
      int? dpd,
      String? lob,
      dynamic nocStatus,
      String? mandateStatus,
      String? productName,
      String? vehicleRegistration,
      String? sourceSystem,
      String? productCategory,}) {
    return Data(
        ucic: ucic ?? this.ucic,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        tenantId: tenantId ?? this.tenantId,
        cif: cif ?? this.cif,
        coApplicantCIF: coApplicantCIF ?? this.coApplicantCIF,
        applicantName: applicantName ?? this.applicantName,
        coApplicantName: coApplicantName ?? this.coApplicantName,
        branchId: branchId ?? this.branchId,
        loanAccountNumber: loanAccountNumber ?? this.loanAccountNumber,
        totalAmount: totalAmount ?? this.totalAmount,
        totalPendingAmount: totalPendingAmount ?? this.totalPendingAmount,
        interestRate: interestRate ?? this.interestRate,
        installmentAmount: installmentAmount ?? this.installmentAmount,
        excessAmount: excessAmount ?? this.excessAmount,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        nextDuedate: nextDuedate ?? this.nextDuedate,
        loanStatus: loanStatus ?? this.loanStatus,
        dpd: dpd ?? this.dpd,
        lob: lob ?? this.lob,
        nocStatus: nocStatus ?? this.nocStatus,
        mandateStatus: mandateStatus ?? this.mandateStatus,
        productName: productName ?? this.productName,
        vehicleRegistration: vehicleRegistration ?? this.vehicleRegistration,
        sourceSystem: sourceSystem ?? this.sourceSystem,
        productCategory: productCategory ?? this.productCategory,);
  }

  Map<String, Object?> toJson() {
    return {
      'ucic': ucic,
      'mobileNumber': mobileNumber,
      'tenantId': tenantId,
      'cif': cif,
      'coApplicantCIF': coApplicantCIF,
      'applicantName': applicantName,
      'coApplicantName': coApplicantName,
      'branchId': branchId,
      'loanAccountNumber': loanAccountNumber,
      'totalAmount': totalAmount,
      'totalPendingAmount': totalPendingAmount,
      'interestRate': interestRate,
      'installmentAmount': installmentAmount,
      'excessAmount': excessAmount,
      'startDate': startDate,
      'endDate': endDate,
      'nextDuedate': nextDuedate,
      'loanStatus': loanStatus,
      'dpd': dpd,
      'lob': lob,
      'nocStatus': nocStatus,
      'mandateStatus': mandateStatus,
      'productName': productName,
      'vehicleRegistration': vehicleRegistration,
      'sourceSystem': sourceSystem,
      'productCategory': productCategory,
    };
  }

  static Data fromJson(Map<String, Object?> json) {
    return Data(
        ucic: json['ucic'] == null ? null : json['ucic'] as String,
        mobileNumber: json['mobileNumber'] == null
            ? null
            : json['mobileNumber'] as String,
        tenantId: json['tenantId'] as dynamic,
        cif: json['cif'] == null ? null : json['cif'] as String,
        coApplicantCIF: json['coApplicantCIF'] == null
            ? null
            : json['coApplicantCIF'] as String,
        applicantName: json['applicantName'] == null
            ? null
            : json['applicantName'] as String,
        coApplicantName: json['coApplicantName'] == null
            ? null
            : json['coApplicantName'] as String,
        branchId: json['branchId'] == null ? null : json['branchId'] as String,
        loanAccountNumber: json['loanAccountNumber'] == null
            ? null
            : json['loanAccountNumber'] as String,
        totalAmount:
            json['totalAmount'] == null ? null : json['totalAmount'] as double,
        totalPendingAmount: json['totalPendingAmount'] == null
            ? null
            : json['totalPendingAmount'] as double,
        interestRate: json['interestRate'] == null
            ? null
            : json['interestRate'] as double,
        installmentAmount: json['installmentAmount'] == null
            ? null
            : json['installmentAmount'] as double,
        excessAmount: json['excessAmount'] == null
            ? null
            : json['excessAmount'] as double,
        startDate:
            json['startDate'] == null ? null : json['startDate'] as String,
        endDate: json['endDate'] == null ? null : json['endDate'] as String,
        nextDuedate:
            json['nextDuedate'] == null ? null : json['nextDuedate'] as String,
        loanStatus:
            json['loanStatus'] == null ? null : json['loanStatus'] as String,
        dpd: json['dpd'] == null ? null : json['dpd'] as int,
        lob: json['lob'] == null ? null : json['lob'] as String,
        nocStatus: json['nocStatus'] as dynamic,
        mandateStatus: json['mandateStatus'] == null
            ? null
            : json['mandateStatus'] as String,
        productName:
            json['productName'] == null ? null : json['productName'] as String,
        vehicleRegistration: json['vehicleRegistration'] == null
            ? null
            : json['vehicleRegistration'] as String,
        sourceSystem: json['sourceSystem'] == null
            ? null
            : json['sourceSystem'] as String,
        productCategory: json['productCategory'] == null
            ? null
            : json['productCategory'] as String,);
  }

  @override
  String toString() {
    return '''Data(
                ucic:$ucic,
mobileNumber:$mobileNumber,
tenantId:$tenantId,
cif:$cif,
coApplicantCIF:$coApplicantCIF,
applicantName:$applicantName,
coApplicantName:$coApplicantName,
branchId:$branchId,
loanAccountNumber:$loanAccountNumber,
totalAmount:$totalAmount,
totalPendingAmount:$totalPendingAmount,
interestRate:$interestRate,
installmentAmount:$installmentAmount,
excessAmount:$excessAmount,
startDate:$startDate,
endDate:$endDate,
nextDuedate:$nextDuedate,
loanStatus:$loanStatus,
dpd:$dpd,
lob:$lob,
nocStatus:$nocStatus,
mandateStatus:$mandateStatus,
productName:$productName,
vehicleRegistration:$vehicleRegistration,
sourceSystem:$sourceSystem,
productCategory:$productCategory
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Data &&
        other.runtimeType == runtimeType &&
        other.ucic == ucic &&
        other.mobileNumber == mobileNumber &&
        other.tenantId == tenantId &&
        other.cif == cif &&
        other.coApplicantCIF == coApplicantCIF &&
        other.applicantName == applicantName &&
        other.coApplicantName == coApplicantName &&
        other.branchId == branchId &&
        other.loanAccountNumber == loanAccountNumber &&
        other.totalAmount == totalAmount &&
        other.totalPendingAmount == totalPendingAmount &&
        other.interestRate == interestRate &&
        other.installmentAmount == installmentAmount &&
        other.excessAmount == excessAmount &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.nextDuedate == nextDuedate &&
        other.loanStatus == loanStatus &&
        other.dpd == dpd &&
        other.lob == lob &&
        other.nocStatus == nocStatus &&
        other.mandateStatus == mandateStatus &&
        other.productName == productName &&
        other.vehicleRegistration == vehicleRegistration &&
        other.sourceSystem == sourceSystem &&
        other.productCategory == productCategory;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        ucic,
        mobileNumber,
        tenantId,
        cif,
        coApplicantCIF,
        applicantName,
        coApplicantName,
        branchId,
        loanAccountNumber,
        totalAmount,
        totalPendingAmount,
        interestRate,
        installmentAmount,
        excessAmount,
        startDate,
        endDate,
        nextDuedate,
        loanStatus,
        dpd,);
  }
}
