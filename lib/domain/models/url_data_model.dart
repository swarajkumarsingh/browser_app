class UrlDataModel {
  final String url;
  final bool success;
  final String size;
  final String contentType;
  UrlDataModel({
    this.url = "",
    required this.success,
    this.size = "",
    this.contentType = "",
  });
}
