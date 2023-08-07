class URLUtil {
  URLUtil._(); // instance of its own class

  bool isValidUrl(String url) {
    final Uri uri = Uri.tryParse(url) ?? Uri.parse(url);
    return uri.isAbsolute;
  }
}
