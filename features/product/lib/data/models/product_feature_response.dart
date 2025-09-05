class ProductFeatureResponse {
  final List<ProductBanner>? productBanner;
  final List<ProductFeature>? productFeature;

  ProductFeatureResponse({
    this.productBanner,
    this.productFeature,
  });

  factory ProductFeatureResponse.fromJson(Map<String, dynamic> json) =>
      ProductFeatureResponse(
        productBanner: json["product_banner"] == null
            ? []
            : List<ProductBanner>.from(
                json["product_banner"]!.map((x) => ProductBanner.fromJson(x))),
        productFeature: json["product_feature"] == null
            ? []
            : List<ProductFeature>.from(json["product_feature"]!
                .map((x) => ProductFeature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_banner": productBanner == null
            ? []
            : List<dynamic>.from(productBanner!.map((x) => x.toJson())),
        "product_feature": productFeature == null
            ? []
            : List<dynamic>.from(productFeature!.map((x) => x.toJson())),
      };
}

class ProductBanner {
  final String? image;
  final String? title;
  final String? link;
  final String? subTitle;

  ProductBanner({
    this.image,
    this.title,
    this.link,
    this.subTitle,
  });

  factory ProductBanner.fromJson(Map<String, dynamic> json) => ProductBanner(
      image: json["image"],
      title: json["banner_title"],
      link: json["link"],
      subTitle: json["banner_subtitle"]);

  Map<String, dynamic> toJson() => {
        "image": image,
        "banner_title": title,
        "link": link,
        "banner_subtitle": subTitle,
      };
}

class ProductFeature {
  final String? productTitle;
  final String? productType;
  final List<LoanType>? types;

  ProductFeature({
    this.productTitle,
    this.productType,
    this.types,
  });

  factory ProductFeature.fromJson(Map<String, dynamic> json) => ProductFeature(
        productTitle: json["product_title"],
        productType: json["product_type"],
        types: json["types"] == null
            ? []
            : List<LoanType>.from(json["types"]!.map((x) => LoanType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_title": productTitle,
        "product_type": productType,
        "types": types == null
            ? []
            : List<dynamic>.from(types!.map((x) => x.toJson())),
      };
}

class LoanType {
  final String? typeTitle;
  final String? productSubType;
  final String? loanImage;
  final List<LoanTab>? loanTabs;
  final String? investmentTypeTitle;
  final String? fixedDepositImage;
  final List<FixedDepositTab>? fixedDepositTabs;
  final String? mutualFundsImage;
  final List<dynamic>? mutualFundsTabs;
  final String? insuranceTypeTitle;
  final String? motorInsuranceImage;
  final List<dynamic>? motorTabs;
  final String? healthInsuranceImage;
  final List<dynamic>? healthTabs;
  final String? lifeInsuranceImage;
  final List<dynamic>? lifeTabs;
  final String? vertical;

  LoanType({
    this.typeTitle,
    this.productSubType,
    this.loanImage,
    this.loanTabs,
    this.investmentTypeTitle,
    this.fixedDepositImage,
    this.fixedDepositTabs,
    this.mutualFundsImage,
    this.mutualFundsTabs,
    this.insuranceTypeTitle,
    this.motorInsuranceImage,
    this.motorTabs,
    this.healthInsuranceImage,
    this.healthTabs,
    this.lifeInsuranceImage,
    this.lifeTabs,
    this.vertical,
  });

  factory LoanType.fromJson(Map<String, dynamic> json) => LoanType(
      typeTitle: json["type_name"],
      productSubType: json["product_sub_type"],
      loanImage: json["image"],
      loanTabs: json["tabs_details"] == null
          ? []
          : List<LoanTab>.from(
              json["tabs_details"]!.map((x) => LoanTab.fromJson(x))),
      investmentTypeTitle: json["investment_type_title"],
      fixedDepositImage: json["fixed_deposit_image"],
      fixedDepositTabs: json["fixed_deposit_tabs"] == null
          ? []
          : List<FixedDepositTab>.from(json["fixed_deposit_tabs"]!
              .map((x) => FixedDepositTab.fromJson(x))),
      mutualFundsImage: json["mutual_funds_image"],
      mutualFundsTabs: json["mutual_funds_tabs"] == null
          ? []
          : List<dynamic>.from(json["mutual_funds_tabs"]!.map((x) => x)),
      insuranceTypeTitle: json["insurance_type_title"],
      motorInsuranceImage: json["motor_insurance_image"],
      motorTabs: json["motor_tabs"] == null
          ? []
          : List<dynamic>.from(json["motor_tabs"]!.map((x) => x)),
      healthInsuranceImage: json["health_insurance_image"],
      healthTabs: json["health_tabs"] == null
          ? []
          : List<dynamic>.from(json["health_tabs"]!.map((x) => x)),
      lifeInsuranceImage: json["life_insurance_image"],
      lifeTabs: json["life_tabs"] == null
          ? []
          : List<dynamic>.from(json["life_tabs"]!.map((x) => x)),
      vertical: json['vertical_name']);

  Map<String, dynamic> toJson() => {
        "type_name": typeTitle,
        "product_sub_type": productSubType,
        "image": loanImage,
        "tabs_details": loanTabs == null
            ? []
            : List<dynamic>.from(loanTabs!.map((x) => x.toJson())),
        "investment_type_title": investmentTypeTitle,
        "fixed_deposit_image": fixedDepositImage,
        "fixed_deposit_tabs": fixedDepositTabs == null
            ? []
            : List<dynamic>.from(fixedDepositTabs!.map((x) => x.toJson())),
        "mutual_funds_image": mutualFundsImage,
        "mutual_funds_tabs": mutualFundsTabs == null
            ? []
            : List<dynamic>.from(mutualFundsTabs!.map((x) => x)),
        "insurance_type_title": insuranceTypeTitle,
        "motor_insurance_image": motorInsuranceImage,
        "motor_tabs": motorTabs == null
            ? []
            : List<dynamic>.from(motorTabs!.map((x) => x)),
        "health_insurance_image": healthInsuranceImage,
        "health_tabs": healthTabs == null
            ? []
            : List<dynamic>.from(healthTabs!.map((x) => x)),
        "life_insurance_image": lifeInsuranceImage,
        "life_tabs":
            lifeTabs == null ? [] : List<dynamic>.from(lifeTabs!.map((x) => x)),
        'vertical_name': vertical,
      };
}

class FixedDepositTab {
  final String? tabTitle;
  final OverviewDetails? overviewDetails;
  final FeaturesAndBenefitsDetails? featuresAndBenefitsDetails;
  final FdCalculatorDetails? fdCalculatorDetails;
  final FaqsDetails? faqsDetails;
  final ApplyDetails? applyDetails;
  final EligibilityDocumentsDetails? eligibilityDocumentsDetails;

  FixedDepositTab({
    this.tabTitle,
    this.overviewDetails,
    this.featuresAndBenefitsDetails,
    this.fdCalculatorDetails,
    this.faqsDetails,
    this.applyDetails,
    this.eligibilityDocumentsDetails,
  });

  factory FixedDepositTab.fromJson(Map<String, dynamic> json) =>
      FixedDepositTab(
        tabTitle: json["tab_title"],
        overviewDetails: json["overview_details"] == null
            ? null
            : OverviewDetails.fromJson(json["overview_details"]),
        featuresAndBenefitsDetails:
            json["features_and_benefits_details"] == null
                ? null
                : FeaturesAndBenefitsDetails.fromJson(
                    json["features_and_benefits_details"]),
        fdCalculatorDetails: json["fd_calculator_details"] == null
            ? null
            : FdCalculatorDetails.fromJson(json["fd_calculator_details"]),
        faqsDetails: json["faqs_details"] == null
            ? null
            : FaqsDetails.fromJson(json["faqs_details"]),
        applyDetails: json["apply_details"] == null
            ? null
            : ApplyDetails.fromJson(json["apply_details"]),
        eligibilityDocumentsDetails:
            json["eligibility_documents_details"] == null
                ? null
                : EligibilityDocumentsDetails.fromJson(
                    json["eligibility_documents_details"]),
      );

  Map<String, dynamic> toJson() => {
        "tab_title": tabTitle,
        "overview_details": overviewDetails?.toJson(),
        "features_and_benefits_details": featuresAndBenefitsDetails?.toJson(),
        "fd_calculator_details": fdCalculatorDetails?.toJson(),
        "faqs_details": faqsDetails?.toJson(),
        "apply_details": applyDetails?.toJson(),
        "eligibility_documents_details": eligibilityDocumentsDetails?.toJson(),
      };
}

class ApplyDetails {
  final String? title;
  final String? description;
  final List<OverviewDetails>? applySteps;

  ApplyDetails({
    this.title,
    this.description,
    this.applySteps,
  });

  factory ApplyDetails.fromJson(Map<String, dynamic> json) => ApplyDetails(
        title: json["title"],
        description: json["description"],
        applySteps: json["apply_steps"] == null
            ? []
            : List<OverviewDetails>.from(
                json["apply_steps"]!.map((x) => OverviewDetails.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "apply_steps": applySteps == null
            ? []
            : List<dynamic>.from(applySteps!.map((x) => x.toJson())),
      };
}

class OverviewDetails {
  final String? title;
  final String? description;
  final String? image;

  OverviewDetails({
    this.title,
    this.description,
    this.image,
  });

  factory OverviewDetails.fromJson(Map<String, dynamic> json) =>
      OverviewDetails(
        title: json["title"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
      };
}

class EligibilityDocumentsDetails {
  final String? title;
  final String? description;
  final OverviewDetails? maturedBaseDetails;
  final OverviewDetails? addressProof;
  final OverviewDetails? otherDocuments;
  final String? disclaimer;

  EligibilityDocumentsDetails({
    this.title,
    this.description,
    this.maturedBaseDetails,
    this.addressProof,
    this.otherDocuments,
    this.disclaimer,
  });

  factory EligibilityDocumentsDetails.fromJson(Map<String, dynamic> json) =>
      EligibilityDocumentsDetails(
        title: json["title"],
        description: json["description"],
        maturedBaseDetails: json["matured_base_details"] == null
            ? null
            : OverviewDetails.fromJson(json["matured_base_details"]),
        addressProof: json["address_proof"] == null
            ? null
            : OverviewDetails.fromJson(json["address_proof"]),
        otherDocuments: json["other_documents"] == null
            ? null
            : OverviewDetails.fromJson(json["other_documents"]),
        disclaimer: json["disclaimer"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "matured_base_details": maturedBaseDetails?.toJson(),
        "address_proof": addressProof?.toJson(),
        "other_documents": otherDocuments?.toJson(),
        "disclaimer": disclaimer,
      };
}

class FaqsDetails {
  final String? title;
  final String? description;
  final List<Faq>? faqs;

  FaqsDetails({
    this.title,
    this.description,
    this.faqs,
  });

  factory FaqsDetails.fromJson(Map<String, dynamic> json) => FaqsDetails(
        title: json["title"],
        description: json["description"],
        faqs: json["faqs"] == null
            ? []
            : List<Faq>.from(json["faqs"]!.map((x) => Faq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "faqs": faqs == null
            ? []
            : List<dynamic>.from(faqs!.map((x) => x.toJson())),
      };
}

class Faq {
  final String? title;
  final String? description;

  Faq({
    this.title,
    this.description,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}

class FdCalculatorDetails {
  final String? title;
  final String? description;
  final EmiDetails? emiDetails;

  FdCalculatorDetails({
    this.title,
    this.description,
    this.emiDetails,
  });

  factory FdCalculatorDetails.fromJson(Map<String, dynamic> json) =>
      FdCalculatorDetails(
        title: json["title"],
        description: json["description"],
        emiDetails: json["emi_details"] == null
            ? null
            : EmiDetails.fromJson(json["emi_details"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "emi_details": emiDetails?.toJson(),
      };
}

class EmiDetails {
  final String? minLoanAmount;
  final String? maxLoanAmount;
  final String? minRateOfInterest;
  final String? maxRateOfInterest;
  final String? minTenure;
  final String? maxTenure;

  EmiDetails({
    this.minLoanAmount,
    this.maxLoanAmount,
    this.minRateOfInterest,
    this.maxRateOfInterest,
    this.minTenure,
    this.maxTenure,
  });

  factory EmiDetails.fromJson(Map<String, dynamic> json) => EmiDetails(
        minLoanAmount: json["minLoanAmount"],
        maxLoanAmount: json["maxLoanAmount"],
        minRateOfInterest: json["minRateOfInterest"],
        maxRateOfInterest: json["maxRateOfInterest"],
        minTenure: json["minTenure"],
        maxTenure: json["maxTenure"],
      );

  Map<String, dynamic> toJson() => {
        "minLoanAmount": minLoanAmount,
        "maxLoanAmount": maxLoanAmount,
        "minRateOfInterest": minRateOfInterest,
        "maxRateOfInterest": maxRateOfInterest,
        "minTenure": minTenure,
        "maxTenure": maxTenure,
      };
}

class FeaturesAndBenefitsDetails {
  final String? title;
  final OverviewDetails? assuredReturnss;
  final OverviewDetails? highInterestRates;

  FeaturesAndBenefitsDetails({
    this.title,
    this.assuredReturnss,
    this.highInterestRates,
  });

  factory FeaturesAndBenefitsDetails.fromJson(Map<String, dynamic> json) =>
      FeaturesAndBenefitsDetails(
        title: json["title"],
        assuredReturnss: json["assured_returnss"] == null
            ? null
            : OverviewDetails.fromJson(json["assured_returnss"]),
        highInterestRates: json["high_interest_rates"] == null
            ? null
            : OverviewDetails.fromJson(json["high_interest_rates"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "assured_returnss": assuredReturnss?.toJson(),
        "high_interest_rates": highInterestRates?.toJson(),
      };
}

class LoanTab {
  final String? tabTitle;
  final TabDetails? tabDetails;

  LoanTab({
    this.tabTitle,
    this.tabDetails,
  });

  factory LoanTab.fromJson(Map<String, dynamic> json) => LoanTab(
        tabTitle: json["tab_title"],
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
  final String? description;
  final String? link;
  final String? image;
  final List<String>? featuresTitle;
  final EmiDetails? emiDetails;
  final List<Faq>? faqs;
  final List<OverviewDetails>? applySteps;
  final List<OverviewDetails>? documents;
  final String? disclaimer;

  TabDetails({
    this.title,
    this.description,
    this.link,
    this.image,
    this.featuresTitle,
    this.emiDetails,
    this.faqs,
    this.applySteps,
    this.documents,
    this.disclaimer,
  });

  factory TabDetails.fromJson(Map<String, dynamic> json) => TabDetails(
        title: json["title"],
        description: json["description"],
        link: json["link"],
        image: json["image"],
        featuresTitle: json["features_title"] == null
            ? []
            : List<String>.from(json["features_title"]!.map((x) => x)),
        emiDetails: json["emi_details"] == null
            ? null
            : EmiDetails.fromJson(json["emi_details"]),
        faqs: json["faqs"] == null
            ? []
            : List<Faq>.from(json["faqs"]!.map((x) => Faq.fromJson(x))),
        applySteps: json["apply_steps"] == null
            ? []
            : List<OverviewDetails>.from(
                json["apply_steps"]!.map((x) => OverviewDetails.fromJson(x))),
        documents: json["documents"] == null
            ? []
            : List<OverviewDetails>.from(
                json["documents"]!.map((x) => OverviewDetails.fromJson(x))),
        disclaimer: json["disclaimer"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "link": link,
        "image": image,
        "features_title": featuresTitle == null
            ? []
            : List<dynamic>.from(featuresTitle!.map((x) => x)),
        "emi_details": emiDetails?.toJson(),
        "faqs": faqs == null
            ? []
            : List<dynamic>.from(faqs!.map((x) => x.toJson())),
        "apply_steps": applySteps == null
            ? []
            : List<dynamic>.from(applySteps!.map((x) => x.toJson())),
        "documents": documents == null
            ? []
            : List<dynamic>.from(documents!.map((x) => x.toJson())),
        "disclaimer": disclaimer,
      };
}
