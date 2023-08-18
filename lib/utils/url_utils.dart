class URLUtil {
  URLUtil._(); // instance of its own class

  static bool isValidUrl(String url) {
    final Uri uri = Uri.parse(url);
    return uri.isAbsolute;
  }
}
