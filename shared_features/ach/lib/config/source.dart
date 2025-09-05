class Source {
  String? title;
  String? description;
  Function? onSuccessPennyDrop;
  Function? onSuccessMandate;
  Purpose? purpose;
  String? callBackRoute;

  Source(
      {this.title,
      this.description,
      this.onSuccessPennyDrop,
      this.onSuccessMandate,
      this.purpose,
      this.callBackRoute});
}

enum Purpose { pennyDrop, mandate }
