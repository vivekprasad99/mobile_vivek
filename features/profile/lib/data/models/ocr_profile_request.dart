class OCRProfileRequest {
  String? fileB64;
  String? docType;
  String? source;

  OCRProfileRequest(
      {this.fileB64,
      this.docType,
      this.source});

  OCRProfileRequest.fromJson(Map<String, dynamic> json) {
    fileB64 = json['fileB64'];
    docType = json['docType'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileB64'] = fileB64;
    data['docType'] = docType;
    data['source'] = source;
    return data;
  }
}
