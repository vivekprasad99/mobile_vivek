class GetPresetUriRequest {
  String? fileName;
  String? useCase;
  String? superAppId;
  String? source;

  GetPresetUriRequest({this.fileName,this.useCase,this.superAppId,this.source});

  GetPresetUriRequest.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    useCase = json['usecase'];
    superAppId = json['superAppId'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileName'] = fileName;
    data['usecase'] = useCase;
    data['superAppId'] = superAppId;
    data['source'] = source;
    return data;
  }
}