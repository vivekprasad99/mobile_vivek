class HomeBannerResponse {
  final Meta? meta;
  final Data? data;
  const HomeBannerResponse({this.meta, this.data});
  HomeBannerResponse copyWith({Meta? meta, Data? data}) {
    return HomeBannerResponse(meta: meta ?? this.meta, data: data ?? this.data);
  }

  Map<String, Object?> toJson() {
    return {'meta': meta?.toJson(), 'data': data?.toJson()};
  }

  static HomeBannerResponse fromJson(Map<String, Object?> json) {
    return HomeBannerResponse(
        meta: json['meta'] == null
            ? null
            : Meta.fromJson(json['meta'] as Map<String, Object?>),
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, Object?>),);
  }

  @override
  String toString() {
    return '''HomeBannerResponse(
                meta:${meta.toString()},
data:${data.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is HomeBannerResponse &&
        other.runtimeType == runtimeType &&
        other.meta == meta &&
        other.data == data;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, meta, data);
  }
}

class Data {
  final List<Banners>? banners;
  const Data({this.banners});
  Data copyWith({List<Banners>? banners}) {
    return Data(banners: banners ?? this.banners);
  }

  Map<String, Object?> toJson() {
    return {
      'banners':
          banners?.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }

  static Data fromJson(Map<String, Object?> json) {
    return Data(
        banners: json['banners'] == null
            ? null
            : (json['banners'] as List)
                .map<Banners>(
                    (data) => Banners.fromJson(data as Map<String, Object?>),)
                .toList(),);
  }

  @override
  String toString() {
    return '''Data(
                banners:${banners.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Data &&
        other.runtimeType == runtimeType &&
        other.banners == banners;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, banners);
  }
}

class Banners {
  final String? bannerTitle;
  final String? bannerSubtitle;
  final String? link;
  final String? image;
  final String? bannerKey;
  final String? screenRouter;
  final String? productType;
  final String? productSubType;
  const Banners(
      {this.bannerTitle,
      this.bannerSubtitle,
      this.link,
      this.image,
      this.bannerKey,
      this.screenRouter,
      this.productType,
      this.productSubType,});
  Banners copyWith(
      {String? bannerTitle,
      String? bannerSubtitle,
      String? link,
      String? image,
      String? bannerKey,
      String? screenRouter,
      String? productType,
      String? productSubType,}) {
    return Banners(
        bannerTitle: bannerTitle ?? this.bannerTitle,
        bannerSubtitle: bannerSubtitle ?? this.bannerSubtitle,
        link: link ?? this.link,
        image: image ?? this.image,
        bannerKey: bannerKey ?? this.bannerKey,
        screenRouter: screenRouter ?? this.screenRouter,
        productType: productType ?? this.productType,
        productSubType: productSubType ?? this.productSubType,);
  }

  Map<String, Object?> toJson() {
    return {
      'banner_title': bannerTitle,
      'banner_subtitle': bannerSubtitle,
      'link': link,
      'image': image,
      'banner_key': bannerKey,
      'screen_router': screenRouter,
      'product_type': productType,
      'product_sub_type': productSubType,
    };
  }

  static Banners fromJson(Map<String, Object?> json) {
    return Banners(
        bannerTitle: json['banner_title'] == null
            ? null
            : json['banner_title'] as String,
        bannerSubtitle: json['banner_subtitle'] == null
            ? null
            : json['banner_subtitle'] as String,
        link: json['link'] == null ? null : json['link'] as String,
        image: json['image'] == null ? null : json['image'] as String,
        bannerKey:
            json['banner_key'] == null ? null : json['banner_key'] as String,
        screenRouter: json['screen_router'] == null
            ? null
            : json['screen_router'] as String,
        productType: json['product_type'] == null
            ? null
            : json['product_type'] as String,
        productSubType: json['product_sub_type'] == null
            ? null
            : json['product_sub_type'] as String,);
  }

  @override
  String toString() {
    return '''Banners(
                bannerTitle:$bannerTitle,
bannerSubtitle:$bannerSubtitle,
link:$link,
image:$image,
bannerKey:$bannerKey,
screenRouter:$screenRouter,
productType:$productType,
productSubType:$productSubType
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Banners &&
        other.runtimeType == runtimeType &&
        other.bannerTitle == bannerTitle &&
        other.bannerSubtitle == bannerSubtitle &&
        other.link == link &&
        other.image == image &&
        other.bannerKey == bannerKey &&
        other.screenRouter == screenRouter &&
        other.productType == productType &&
        other.productSubType == productSubType;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, bannerTitle, bannerSubtitle, link, image,
        bannerKey, screenRouter, productType, productSubType,);
  }
}

class Meta {
  final int? total;
  final QueryParams? queryParams;
  const Meta({this.total, this.queryParams});
  Meta copyWith({int? total, QueryParams? queryParams}) {
    return Meta(
        total: total ?? this.total,
        queryParams: queryParams ?? this.queryParams,);
  }

  Map<String, Object?> toJson() {
    return {'total': total, 'query_params': queryParams?.toJson()};
  }

  static Meta fromJson(Map<String, Object?> json) {
    return Meta(
        total: json['total'] == null ? null : json['total'] as int,
        queryParams: json['query_params'] == null
            ? null
            : QueryParams.fromJson(
                json['query_params'] as Map<String, Object?>,),);
  }

  @override
  String toString() {
    return '''Meta(
                total:$total,
queryParams:${queryParams.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Meta &&
        other.runtimeType == runtimeType &&
        other.total == total &&
        other.queryParams == queryParams;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, total, queryParams);
  }
}

class QueryParams {
  final String? language;
  const QueryParams({this.language});
  QueryParams copyWith({String? language}) {
    return QueryParams(language: language ?? this.language);
  }

  Map<String, Object?> toJson() {
    return {'language': language};
  }

  static QueryParams fromJson(Map<String, Object?> json) {
    return QueryParams(
        language: json['language'] == null ? null : json['language'] as String,);
  }

  @override
  String toString() {
    return '''QueryParams(
                language:$language
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is QueryParams &&
        other.runtimeType == runtimeType &&
        other.language == language;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, language);
  }
}
