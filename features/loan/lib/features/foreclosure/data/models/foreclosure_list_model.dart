class ForeClosureListModel {
  String? ucic;
  String? tenantId;
  String? cif;
  String? coApplicantCif;
  String? branchId;
  String? productName;
  double? installmentAmount;
  String? loanNumber;
  double? totalAmountOverDue;
  double? totalOutstandingAmount;
  double? totalPenaltyAmount;
  double? totalBounceCharge;
  String? startDate;
  String? endDate;
  String? nocStatus;
  bool? flpAvailabilityFlag;
  bool? isRuleOnePassed;
  bool? isForeClosureActive;
  String? sourcecSystem;
  double? excessAmount;
  bool? isLockingPeriodActive;
  bool? isFreezingPeriodActive;
  ForeClosureListModel({
    this.ucic,
    this.tenantId,
    this.cif,
    this.coApplicantCif,
    this.branchId,
    this.productName,
    this.installmentAmount,
    this.loanNumber,
    this.totalAmountOverDue,
    this.totalOutstandingAmount,
    this.totalPenaltyAmount,
    this.totalBounceCharge,
    this.startDate,
    this.endDate,
    this.nocStatus,
    this.flpAvailabilityFlag,
    this.isRuleOnePassed,
    this.isForeClosureActive,
    this.sourcecSystem,
    this.excessAmount,
    this.isLockingPeriodActive,
    this.isFreezingPeriodActive,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ucic': ucic,
      'tenantId': tenantId,
      'cif': cif,
      'coApplicantCif': coApplicantCif,
      'branchId': branchId,
      'productName': productName,
      'installmentAmount': installmentAmount,
      'loanNumber': loanNumber,
      'totalAmountOverDue': totalAmountOverDue,
      'totalOutstandingAmount': totalOutstandingAmount,
      'totalPenaltyAmount': totalPenaltyAmount,
      'totalBounceCharge': totalBounceCharge,
      'startDate': startDate,
      'endDate': endDate,
      'nocStatus': nocStatus,
      'flpAvailabilityFlag': flpAvailabilityFlag,
      'isRuleOnePassed': isRuleOnePassed,
      'isForeClosureActive': isForeClosureActive,
      'sourcecSystem': sourcecSystem,
      'excessAmount': excessAmount,
      'isLockingPeriodActive': isLockingPeriodActive,
      'isFreezingPeriodActive': isFreezingPeriodActive,
    };
  }

  factory ForeClosureListModel.fromJson(Map<String, dynamic> map) {
    return ForeClosureListModel(
      ucic: map['ucic'] != null ? map['ucic'] as String : null,
      tenantId: map['tenantId'] != null ? map['tenantId'] as String : null,
      cif: map['cif'] != null ? map['cif'] as String : null,
      coApplicantCif: map['coApplicantCif'] != null
          ? map['coApplicantCif'] as String
          : null,
      branchId: map['branchId'] != null ? map['branchId'] as String : null,
      productName:
          map['productName'] != null ? map['productName'] as String : null,
      installmentAmount: map['installmentAmount'] != null
          ? map['installmentAmount'] as double
          : null,
      loanNumber:
          map['loanNumber'] != null ? map['loanNumber'] as String : null,
      totalAmountOverDue: map['totalAmountOverDue'] != null
          ? map['totalAmountOverDue'] as double
          : null,
      totalOutstandingAmount: map['totalOutstandingAmount'] != null
          ? map['totalOutstandingAmount'] as double
          : null,
      totalPenaltyAmount: map['totalPenaltyAmount'] != null
          ? map['totalPenaltyAmount'] as double
          : null,
      totalBounceCharge: map['totalBounceCharge'] != null
          ? map['totalBounceCharge'] as double
          : null,
      startDate: map['startDate'] != null ? map['startDate'] as String : null,
      endDate: map['endDate'] != null ? map['endDate'] as String : null,
      nocStatus: map['nocStatus'] != null ? map['nocStatus'] as String : null,
      flpAvailabilityFlag: map['flpAvailabilityFlag'] != null
          ? map['flpAvailabilityFlag'] as bool
          : null,
      isRuleOnePassed: map['isRuleOnePassed'] != null
          ? map['isRuleOnePassed'] as bool
          : null,
      isForeClosureActive: map['isForeClosureActive'] != null
          ? map['isForeClosureActive'] as bool
          : null,
      sourcecSystem:
          map['sourcecSystem'] != null ? map['sourcecSystem'] as String : null,
      excessAmount:
          map['excessAmount'] != null ? map['excessAmount'] as double : null,
      isLockingPeriodActive: map['isLockingPeriodActive'] != null
          ? map['isLockingPeriodActive'] as bool
          : null,
      isFreezingPeriodActive: map['isFreezingPeriodActive'] != null
          ? map['isFreezingPeriodActive'] as bool
          : null,
    );
  }
}
