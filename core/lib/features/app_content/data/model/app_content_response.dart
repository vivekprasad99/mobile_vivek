class AppContentResponse {
    final String? tollFreeNumber;

    AppContentResponse({
        this.tollFreeNumber,
    });

    factory AppContentResponse.fromJson(Map<String, dynamic> json) => AppContentResponse(
        tollFreeNumber: json["toll_free_number"],
    );

    Map<String, dynamic> toJson() => {
        "toll_free_number": tollFreeNumber,
    };
}