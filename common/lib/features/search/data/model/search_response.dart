import 'package:hive/hive.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:profile/data/models/customer_info_args.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/utils/utils.dart';
part 'search_response.g.dart';

class SearchResponse {
  Meta? meta;
  List<SearchData>? data;

  SearchResponse({this.meta, this.data});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data!.add(SearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? total;
  String? query;

  Meta({this.total, this.query});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['query'] = query;
    return data;
  }
}

@HiveType(typeId: 0)
class SearchData {
  
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? screenRouter;

  @HiveField(2)
  String? type;

  @HiveField(3)
  String? answer;

  @HiveField(4)
  String? faqQuestion;

  @HiveField(5)
  dynamic extra;

  @HiveField(6)
  List<String>? searchList;

  @HiveField(7)
  bool? canPop;

  @HiveField(8)
  String? productType;

  @HiveField(9)
  String? productSubType;

  @HiveField(10)
  String? category;

  @HiveField(11)
  ExtraConversion? extraConversion;

  @HiveField(12,defaultValue: false)
  bool? isUser;

  SearchData({
    this.title,
    this.screenRouter,
    this.type,
    this.answer,
    this.extra,
    this.faqQuestion,
    this.searchList,
    this.canPop,
    this.productType,
    this.productSubType,
    this.category,
    this.extraConversion,
    this.isUser,
  });

  SearchData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    screenRouter = json['screen_router'];
    type = json['type'];
    answer = json['answer'];
    faqQuestion = json['faq_question'];
    canPop = json['canPop'];
    searchList = json["searchList"] == null
        ? []
        : List<String>.from(json["searchList"]!.map((x) => x));
    productType = json['product_type'];
    productSubType = json['product_sub_type'];
    category = json['search_list_category'];
    if (json['extraArguments'] != null) {
      extraConversion = ExtraConversion.fromJson(json['extraArguments']);
      if (extraConversion?.intVal != null) {
        extra = extraConversion?.intVal;
      } else if (extraConversion?.boolVal != null) {
        extra = extraConversion?.boolVal;
      } else if (extraConversion?.stringVal != null) {
        extra = extraConversion?.stringVal;
      } else if (extraConversion?.prodcuctFeatureDetailRequest != null) {
        extra = LoansTabBarArguments.fromJson(json['extraArguments']['productFeatureDetail']).toJson();
      } else if (extraConversion?.servicesNavigationRequest != null) {
        extra = ServicesNavigationRequest.fromJson(json['extraArguments']['servicesNavigationRequest']).toJson();
      }
    } else {
      extra = json['extra'];
    }
    isUser = json['is_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['screen_router'] = screenRouter;
    data['type'] = type;
    data['answer'] = answer;
    data['faq_question'] = faqQuestion;
    data['canPop'] = canPop;
    data['product_type'] = productType;
    data['product_sub_type'] = productSubType;
    data['search_list_category'] = category;
    data['searchList'] = searchList;

    if (extraConversion != null) {
      data['extraArguments'] = extraConversion!.toJson();
      if (extraConversion?.intVal != null) {
        data['extra'] = extraConversion?.intVal;
      } else if (extraConversion?.boolVal != null) {
        data['extra'] = extraConversion?.boolVal;
      } else if (extraConversion?.stringVal != null) {
        data['extra'] = extraConversion?.stringVal;
      } else if (extraConversion?.prodcuctFeatureDetailRequest != null) {
        data['extra'] = extraConversion?.prodcuctFeatureDetailRequest!.toJson();
      } else if (extraConversion?.servicesNavigationRequest != null) {
        data['extra'] = extraConversion?.servicesNavigationRequest!.toJson();
      }
    } else {
      data['extra'] = extra;
    }
    data['is_user'] = isUser;
    
    return data;
  }
}

@HiveType(typeId: 1)
class ExtraConversion {
  @HiveField(0)
  int? intVal;
  @HiveField(1)
  bool? boolVal;
  @HiveField(2)
  String? stringVal;
  @HiveField(3)
  LoansTabBarArguments? prodcuctFeatureDetailRequest;
  @HiveField(4)
  ServicesNavigationRequest? servicesNavigationRequest;

  ExtraConversion(
      {this.intVal,
      this.boolVal,
      this.stringVal,
      this.prodcuctFeatureDetailRequest,
      this.servicesNavigationRequest,});

  ExtraConversion.fromJson(Map<String, dynamic> json) {
    // intVal = json['intVal'];
    if (json['intVal'] != null) {
      if (json['intVal'] is String) {
        intVal = int.tryParse(json['intVal']);
      } else {
        intVal = json['intVal'];
      }
    } else {
      intVal = null;
    }
    boolVal = json['boolVal'];
    stringVal = json['stringVal'];
    prodcuctFeatureDetailRequest = json['productFeatureDetail'] != null
        ? LoansTabBarArguments.fromJson(
            json['productFeatureDetail'],)
        : null;
    servicesNavigationRequest = json['servicesNavigationRequest'] != null
        ? ServicesNavigationRequest.fromJson(
            json['servicesNavigationRequest'],)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['intVal'] = intVal;
    data['boolVal'] = boolVal;
    data['stringVal'] = stringVal;
    if (prodcuctFeatureDetailRequest != null) {
      data['productFeatureDetail'] =
          prodcuctFeatureDetailRequest!.toJson();
    }
    if (servicesNavigationRequest != null) {
      data['servicesNavigationRequest'] =
          servicesNavigationRequest!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 2)
class LoansTabBarArguments {
  @HiveField(0)
  LoanType? loanTypeData;
  @HiveField(1)
  String? productType;
  @HiveField(2)
  String? productSubType;
  @HiveField(3)
  bool? isFromSearch;

  LoansTabBarArguments(
      {this.loanTypeData,
      this.productType,
      this.productSubType,
      this.isFromSearch,});

  LoansTabBarArguments.fromJson(Map<dynamic, dynamic> json) {
    isFromSearch = json['isFromSearch'];
    productType = json['product_type'];
    productSubType = json['product_sub_type'];
    loanTypeData = json['loanTypeData'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['product_type'] = productType;
    data['product_sub_type'] = productSubType;
    data['isFromSearch'] = isFromSearch;
    data['loanTypeData'] = loanTypeData;
    return data;
  }
}


@HiveType(typeId: 3)
class ServicesNavigationRequest {
  @HiveField(0)
  bool? isFromSearch;
  @HiveField(1)
  String? cardName;
  @HiveField(2)
  String? cardType;
  @HiveField(3)
  ProfileInfo? myProfileResponse;
  @HiveField(4)
  AddressType? addressType;
  @HiveField(5)
  String? fromRoute;
  @HiveField(6)
  CustomerInfoArg? customerInfoArg;

  ServicesNavigationRequest({this.cardName, this.cardType,this.isFromSearch,this.myProfileResponse,this.addressType,this.fromRoute, this.customerInfoArg});

  ServicesNavigationRequest.fromJson(Map<dynamic, dynamic> json) {
    cardName = json['cardName'];
    cardType = json['cardType'];
    isFromSearch = json['isFromSearch'];
    addressType = json['addressType'];
    fromRoute = json['fromRoute'];
    myProfileResponse = json['myProfileResponse'] != null
        ? ProfileInfo.fromJson(
            json['myProfileResponse'],)
        : null;
    customerInfoArg = json['customerInfoArg'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['cardName'] = cardName;
    data['cardType'] = cardType;
    data['isFromSearch'] = isFromSearch;
    data['fromRoute'] = fromRoute;
    data['addressType'] = addressType;
    data['customerInfoArg'] = customerInfoArg;
    if (myProfileResponse != null) {
      data['myProfileResponse'] =
          myProfileResponse!.toJson();
    }
    return data;
  }
}

