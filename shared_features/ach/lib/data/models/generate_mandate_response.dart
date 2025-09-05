class GenerateMandateResponse {
  String? code;
  String? message;
  String? responseCode;
  AggregatorResponse? aggregatorResponse;

  GenerateMandateResponse({this.code, this.message,this.responseCode, this.aggregatorResponse});

  GenerateMandateResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    responseCode = json['responseCode'];
    aggregatorResponse = json['data'] != null ? AggregatorResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['responseCode'] = responseCode;
    if (aggregatorResponse != null) {
      data['data'] = aggregatorResponse!.toJson();
    }
    return data;
  }
}

class AggregatorResponse {
  String? url;
  String? responseUrl;
  String? redirectUrl;
  String? source;
  String? transactionId;

  AggregatorResponse({this.url, this.responseUrl, this.redirectUrl, this.source, this.transactionId});

  AggregatorResponse.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    responseUrl = json['responseUrl'];
    redirectUrl = json['redirectUrl'];
    source = json['source'];
    transactionId = json['transactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['responseUrl'] = responseUrl;
    data['redirectUrl'] = redirectUrl;
    data['source'] = source;
    data['transactionId'] = transactionId;
    return data;
  }
}
