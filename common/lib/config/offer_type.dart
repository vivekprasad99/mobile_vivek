enum OfferType { plLead, plSuvidha, personalized, generic }

enum OfferApiKeyType { offerFlatRate, offerAmount, offerTenure, offerExpiry }

extension OfferTypeExtension on OfferType {
  String get value {
    switch (this) {
      case OfferType.plLead:
        return 'pl-lead';
      case OfferType.plSuvidha:
        return 'pl-suvidha';
      case OfferType.personalized:
        return 'personalized_offers';
      case OfferType.generic:
        return 'generic_offers';
      default:
        return '';
    }
  }
}

extension OfferApiKeyTypeExtension on OfferApiKeyType {
  String get value {
    switch (this) {
      case OfferApiKeyType.offerFlatRate:
        return 'offer_flat_rate';
      case OfferApiKeyType.offerAmount:
        return 'offer_amount';
      case OfferApiKeyType.offerTenure:
        return 'offer_tenure';
      case OfferApiKeyType.offerExpiry:
        return 'offer_expiry';
      default:
        return '';
    }
  }
}
