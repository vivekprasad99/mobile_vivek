class LoanRefundBankAccountDetailsResponse {
  List<BankAccountInfo>? bankAccount;

  LoanRefundBankAccountDetailsResponse({
     this.bankAccount,
  });

 LoanRefundBankAccountDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['bank_account'] != null) {
      bankAccount = <BankAccountInfo>[];
      json['bank_account'].forEach((v) {
        bankAccount!.add(BankAccountInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bankAccount != null) {
      data['loan'] = bankAccount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankAccountInfo {
  String? id;
  String? bankAccNum;
  String? accType;
  String? bankName;
  String? ifsc;

  BankAccountInfo({
    this.id,
    this.bankAccNum,
    this.accType,
    this.bankName,
    this.ifsc,
  });

  BankAccountInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankAccNum = json['bank_acc_num'];
    accType = json['acc_type'];
    bankName = json['bank_name'];
    ifsc = json['ifsc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['bank_acc_num'] = bankAccNum;
    data['acc_type'] = accType;
    data['bank_name'] = bankName;
    data['ifsc'] = ifsc;
    return data;
  }
}
