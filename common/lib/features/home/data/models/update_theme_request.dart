class UpdateThemeRequest {
  final String? superAppId;
  final String? theme;
  final String? source;
  const UpdateThemeRequest({this.superAppId, this.theme, this.source});
  UpdateThemeRequest copyWith({String? superAppId, String? theme, String? source}) {
    return UpdateThemeRequest(
        superAppId: superAppId ?? this.superAppId,
        theme: theme ?? this.theme,
        source: source ?? this.source,);
  }

  Map<String, Object?> toJson() {
    return {'superAppId': superAppId, 'theme': theme, 'source': source};
  }

  static UpdateThemeRequest fromJson(Map<String, Object?> json) {
    return UpdateThemeRequest(
        superAppId: json['superAppId'] == null
            ? null
            : json['superAppId'] as String,
        theme: json['theme'] == null ? null : json['theme'] as String,
        source: json['source'] == null ? null : json['source'] as String,);
  }

  @override
  String toString() {
    return '''UpdateThemeRequest(
                superAppId:$superAppId,
theme:$theme,
source:$source
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateThemeRequest &&
        other.runtimeType == runtimeType &&
        other.superAppId == superAppId &&
        other.source == source &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, superAppId, theme, theme);
  }
}
