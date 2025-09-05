import 'package:common/features/language_selection/data/models/base_cms_response.dart';

class FAQResponse extends BaseCMSResponse {
  Data? data;

  FAQResponse({this.data});

  FAQResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : Data();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Categories>? categories;

  Data({this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? faqType;
  String? title;
  List<ProductTypes>? productTypes;
  List<GeneralTypes>? generalTypes;
  List<VideoTypes>? videoTypes;

  Categories(
      {this.faqType,
      this.title,
      this.productTypes,
      this.generalTypes,
      this.videoTypes});

  Categories.fromJson(Map<String, dynamic> json) {
    faqType = json['faq_type'];
    title = json['title'];
    if (json['product_types'] != null) {
      productTypes = <ProductTypes>[];
      json['product_types'].forEach((v) {
        productTypes!.add(ProductTypes.fromJson(v));
      });
    }
    if (json['general_types'] != null) {
      generalTypes = <GeneralTypes>[];
      json['general_types'].forEach((v) {
        generalTypes!.add(GeneralTypes.fromJson(v));
      });
    }
    if (json['video_types'] != null) {
      videoTypes = <VideoTypes>[];
      json['video_types'].forEach((v) {
        videoTypes!.add(VideoTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['faq_type'] = faqType;
    data['title'] = title;
    if (productTypes != null) {
      data['product_types'] = productTypes!.map((v) => v.toJson()).toList();
    }

    if (videoTypes != null) {
      data['video_types'] = videoTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductTypes {
  String? productType;
  String? title;
  List<SubTypes>? subTypes;

  ProductTypes({this.productType, this.title, this.subTypes});

  ProductTypes.fromJson(Map<String, dynamic> json) {
    productType = json['product_type'];
    title = json['title'];
    if (json['sub_types'] != null) {
      subTypes = <SubTypes>[];
      json['sub_types'].forEach((v) {
        subTypes!.add(SubTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_type'] = productType;
    data['title'] = title;
    if (subTypes != null) {
      data['sub_types'] = subTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubTypes {
  String? productSubType;
  String? title;
  String? screenTitle;
  String? image;
  List<Types>? types;

  SubTypes(
      {this.productSubType,
      this.title,
      this.screenTitle,
      this.image,
      this.types});

  SubTypes.fromJson(Map<String, dynamic> json) {
    productSubType = json['product_sub_type'];
    title = json['title'];
    screenTitle = json['screen_title'];
    image = json['image'];
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(Types.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_sub_type'] = productSubType;
    data['title'] = title;
    data['screen_title'] = screenTitle;
    data['image'] = image;
    if (types != null) {
      data['types'] = types!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeneralTypes {
  int? id;
  String? header;
  List<Faq>? faq;

  GeneralTypes({this.id, this.header});

  GeneralTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(Faq.fromJson(v));
      });
    }
  }
}

class Types {
  int? id;
  String? header;
  List<Faq>? faq;

  Types({this.id, this.header, this.faq});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(Faq.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['header'] = header;
    if (faq != null) {
      data['faq'] = faq!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Faq {
  int? id;
  String? question;
  String? answer;

  Faq({this.id, this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}

class VideoTypes {
  int? id;
  String? header;
  List<Videos>? videos;

  VideoTypes({this.id, this.header, this.videos});

  VideoTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['header'] = header;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  int? id;
  String? title;
  String? subTitle;
  String? thumbnail;
  String? videoUrl;

  Videos({this.id, this.title, this.subTitle, this.thumbnail, this.videoUrl});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    thumbnail = json['thumbnail'];
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['sub_title'] = subTitle;
    data['thumbnail'] = thumbnail;
    data['video_url'] = videoUrl;
    return data;
  }
}
