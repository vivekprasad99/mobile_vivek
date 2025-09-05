class SaveDeliveryReq {
    final String contractNumber;
    final String flag;
    final String address;

    SaveDeliveryReq({
        required this.contractNumber,
        required this.flag,
        required this.address,
    });

    factory SaveDeliveryReq.fromJson(Map<String, dynamic> json) => SaveDeliveryReq(
        contractNumber: json["contractNumber"],
        flag: json["flag"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "contractNumber": contractNumber,
        "flag": flag,
        "address": address,
    };
}
