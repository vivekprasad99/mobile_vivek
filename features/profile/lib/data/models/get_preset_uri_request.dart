class GetPresetUriRequest {
  String? fileName;
  String? useCase;

  GetPresetUriRequest({this.fileName,this.useCase});

  GetPresetUriRequest.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    useCase = json['useCase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileName'] = fileName;
    data['useCase'] = useCase;
    return data;
  }
}