class HelpResponse {
  Data? data;

  HelpResponse({this.data});

  HelpResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class Data {
  List<Category>? categories;

  Data({this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
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

class Category {
  String? faqType;
  String? title;
  List<ProductType>? productTypes;

  Category({this.faqType, this.title, this.productTypes});

  Category.fromJson(Map<String, dynamic> json) {
    faqType = json['faq_type'];
    title = json['title'];
    if (json['product_types'] != null) {
      productTypes = <ProductType>[];
      json['product_types'].forEach((v) {
        productTypes!.add(ProductType.fromJson(v));
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
    return data;
  }
}

class ProductType {
  String? productType;
  String? title;
  List<SubType>? subTypes;

  ProductType({this.productType, this.title, this.subTypes});

  ProductType.fromJson(Map<String, dynamic> json) {
    productType = json['product_type'];
    title = json['title'];
    if (json['sub_types'] != null) {
      subTypes = <SubType>[];
      json['sub_types'].forEach((v) {
        subTypes!.add(SubType.fromJson(v));
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

class SubType {
  String? productSubType;
  String? title;
  String? screenTitle;
  String? image;
  List<Type>? types;

  SubType({this.productSubType, this.title, this.screenTitle, this.image, this.types});

  SubType.fromJson(Map<String, dynamic> json) {
    productSubType = json['product_sub_type'];
    title = json['title'];
    screenTitle = json['screen_title'];
    image = json['image'];
    if (json['types'] != null) {
      types = <Type>[];
      json['types'].forEach((v) {
        types!.add(Type.fromJson(v));
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

class Type {
  int? id;
  String? header;
  List<FAQ>? faq;

  Type({this.id, this.header, this.faq});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    if (json['faq'] != null) {
      faq = <FAQ>[];
      json['faq'].forEach((v) {
        faq!.add(FAQ.fromJson(v));
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

class FAQ {
  int? id;
  String? question;
  String? answer;

  FAQ({this.id, this.question, this.answer});

  FAQ.fromJson(Map<String, dynamic> json) {
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
