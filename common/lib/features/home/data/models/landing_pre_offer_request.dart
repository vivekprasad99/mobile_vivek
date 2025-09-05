class LandingPreOfferRequest {
  final String? ucic;
  final String? mobileNumber;
  const LandingPreOfferRequest({this.ucic, this.mobileNumber});
  LandingPreOfferRequest copyWith({String? ucic, String? mobileNumber}) {
    return LandingPreOfferRequest(
        ucic: ucic ?? this.ucic,
        mobileNumber: mobileNumber ?? this.mobileNumber,);
  }

  Map<String, Object?> toJson() {
    return {'ucic': ucic, 'mobileNumber': mobileNumber};
  }

  static LandingPreOfferRequest fromJson(Map<String, Object?> json) {
    return LandingPreOfferRequest(
        ucic: json['ucic'] == null ? null : json['ucic'] as String,
        mobileNumber: json['mobileNumber'] == null
            ? null
            : json['mobileNumber'] as String,);
  }

  @override
  String toString() {
    return '''LandingPreOfferRequest(
                ucic:$ucic,
mobileNumber:$mobileNumber
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is LandingPreOfferRequest &&
        other.runtimeType == runtimeType &&
        other.ucic == ucic &&
        other.mobileNumber == mobileNumber;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, ucic, mobileNumber);
  }
}
