class PreApprovedOffersResponse {
  final Meta? meta;
  final Data? data;

  PreApprovedOffersResponse({
    this.meta,
    this.data,
  });

  factory PreApprovedOffersResponse.fromJson(Map<String, dynamic> json) =>
      PreApprovedOffersResponse(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data?.toJson(),
      };

  where(bool Function(dynamic offer) param0) {}
}

class Data {
  final List<OfferDetail>? offersList;

  Data({
    this.offersList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        offersList: json["offers_list"] == null
            ? []
            : List<OfferDetail>.from(
                json["offers_list"]!.map((x) => OfferDetail.fromJson(x)),),
      );

  Map<String, dynamic> toJson() => {
        "offers_list": offersList == null
            ? []
            : List<dynamic>.from(offersList!.map((x) => x.toJson())),
      };
}

class OfferDetail {
  final String? offerType;
  final String? offerName;
   final List<String>? header;
  final String? subHeader;
  final String? offerStartDate;
  final String? offerEndDate;
  final String? offerId;
  final String? image;
  final String? buttonName;
  final List<OfferDetailTab>? offerDetailTabs;
  final String? offerSubType;

  OfferDetail({
    this.offerType,
    this.offerName,
    this.header,
    this.subHeader,
    this.offerStartDate,
    this.offerEndDate,
    this.offerId,
    this.image,
    this.buttonName,
    this.offerDetailTabs,
    this.offerSubType,
  });

  factory OfferDetail.fromJson(Map<String, dynamic> json) => OfferDetail(
        offerType: json["offer_type"],
        offerName: json["offer_name"],
        header: json["header"] == null ? [] : List<String>.from(json["header"]!.map((x) => x)),
        subHeader: json["sub_header"],
        offerStartDate: json["offer_start_date"],
        offerEndDate: json["offer_end_date"],
        offerId: json["offer_id"],
        image: json["image"],
        buttonName: json["button_name"],
        offerDetailTabs: json["offer_detail_tabs"] == null
            ? []
            : List<OfferDetailTab>.from(json["offer_detail_tabs"]!
                .map((x) => OfferDetailTab.fromJson(x)),),
        offerSubType: json["offer_sub_type"],
      );

  Map<String, dynamic> toJson() => {
        "offer_type": offerType,
        "offer_name": offerName,
       "header": header == null ? [] : List<dynamic>.from(header!.map((x) => x)),
        "sub_header": subHeader,
        "offer_start_date": offerStartDate,
        "offer_end_date": offerEndDate,
        "offer_id": offerId,
        "image": image,
        "button_name": buttonName,
        "offer_detail_tabs": offerDetailTabs == null
            ? []
            : List<dynamic>.from(offerDetailTabs!.map((x) => x.toJson())),
        "offer_sub_type": offerSubType,
      };
}

class OfferDetailTab {
  final String? tabTitle;
  final TabDetails? tabDetails;

  OfferDetailTab({
    this.tabTitle,
    this.tabDetails,
  });

  factory OfferDetailTab.fromJson(Map<String, dynamic> json) => OfferDetailTab(
        tabTitle: json["tab_title"] ?? '',
        tabDetails: json["tab_details"] == null
            ? null
            : TabDetails.fromJson(json["tab_details"]),
      );

  Map<String, dynamic> toJson() => {
        "tab_title": tabTitle,
        "tab_details": tabDetails?.toJson(),
      };
}

class TabDetails {
  final String? title;
  final String? loanAmount;
  final String? tenure;
  final String? emiTenureMin;
  final String? emiTenureMax;
  final String? roi;
  final List<String>? featuresList;
  final List<String>? eligibilityList;

  TabDetails({
    this.title,
    this.loanAmount,
    this.tenure,
    this.emiTenureMin,
    this.emiTenureMax,
    this.roi,
    this.featuresList,
    this.eligibilityList,
  });

  factory TabDetails.fromJson(Map<String, dynamic> json) => TabDetails(
        title: json["title"] ?? '',
        loanAmount: json["loan_amount"] ?? '',
        tenure: json["tenure"] ?? '',
        emiTenureMin: json["emi_tenure_min"] ?? '',
        emiTenureMax: json["emi_tenure_max"] ?? '',
        roi: json["roi"],
        featuresList: json["features_list"] == null
            ? []
            : List<String>.from(json["features_list"]!.map((x) => x)),
        eligibilityList: json["eligibility_list"] == null
            ? []
            : List<String>.from(json["eligibility_list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title ?? '',
        "loan_amount": loanAmount ?? '',
        "tenure": tenure ?? '',
        "emi_tenure_min": emiTenureMin ?? '',
        "emi_tenure_max": emiTenureMax ?? '',
        "roi": roi ?? '',
        "features_list": featuresList == null
            ? []
            : List<dynamic>.from(featuresList!.map((x) => x)),
        "eligibility_list": eligibilityList == null
            ? []
            : List<dynamic>.from(eligibilityList!.map((x) => x)),
      };
}

class Meta {
  final int? total;
  final QueryParams? queryParams;

  Meta({
    this.total,
    this.queryParams,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        queryParams: json["query_params"] == null
            ? null
            : QueryParams.fromJson(json["query_params"]),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "query_params": queryParams?.toJson(),
      };
}

class QueryParams {
  final String? language;

  QueryParams({
    this.language,
  });

  factory QueryParams.fromJson(Map<String, dynamic> json) => QueryParams(
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
