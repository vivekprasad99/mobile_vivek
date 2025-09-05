
import 'dart:convert';

PaymentOptionsResponeModel paymentOptionsResponeModelFromJson(String str) => PaymentOptionsResponeModel.fromJson(json.decode(str));

String paymentOptionsResponeModelToJson(PaymentOptionsResponeModel data) => json.encode(data.toJson());

class PaymentOptionsResponeModel {
    String status;
    Meta meta;
    String message;
    List<PaymentOption> data;

    PaymentOptionsResponeModel({
        required this.status,
        required this.meta,
        required this.message,
        required this.data,
    });

    factory PaymentOptionsResponeModel.fromJson(Map<String, dynamic> json) => PaymentOptionsResponeModel(
        status: json["status"],
        meta: Meta.fromJson(json["meta"]),
        message: json["message"],
        data: List<PaymentOption>.from(json["data"].map((x) => PaymentOption.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "meta": meta.toJson(),
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class PaymentOption {
    String paymentmode;
    String paymentgateway;

    PaymentOption({
        required this.paymentmode,
        required this.paymentgateway,
    });

    factory PaymentOption.fromJson(Map<String, dynamic> json) => PaymentOption(
        paymentmode: json["paymentmode"],
        paymentgateway: json["paymentgateway"],
    );

    Map<String, dynamic> toJson() => {
        "paymentmode": paymentmode,
        "paymentgateway": paymentgateway,
    };
}

class Meta {
    int total;
    QueryParams queryParams;

    Meta({
        required this.total,
        required this.queryParams,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        queryParams: QueryParams.fromJson(json["query_params"]),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "query_params": queryParams.toJson(),
    };
}

class QueryParams {
    String language;
    String category;

    QueryParams({
        required this.language,
        required this.category,
    });

    factory QueryParams.fromJson(Map<String, dynamic> json) => QueryParams(
        language: json["language"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "language": language,
        "category": category,
    };
}
