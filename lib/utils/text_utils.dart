import 'extensions/string_extension.dart';
import 'url_utils.dart';

final textUtils = _TextUtils();

class _TextUtils {
  String addGoogleSuggestionWithKeyword(String keyword) =>
      "http://google.com/complete/search?q=$keyword&output=toolbar";

  bool isValidUrl(String url) {
    if (!url.containsSpaces && url.containsDot && URLUtil.isValidUrl(url)) {
      return true;
    }
    return false;
  }

  String replaceDotWithSpace(String value) {
    return value.replaceAll(".", "");
  }

  String replaceQuestionMarkWithSpace(String value) {
    return value.replaceAll("?", "");
  }

  bool isImage(String url) {
    final low = url.toLowerCase();
    return low.endsWith('.jpg') ||
        low.endsWith('.jpeg') ||
        low.endsWith('.png') ||
        low.endsWith('.gif') ||
        low.endsWith('.webp');
  }

  bool isNotValidUrl(String url) {
    if (!isValidUrl(url)) {
      return true;
    }
    return false;
  }

  bool isEmpty(String? value) {
    if (value == null || value.toString().isEmpty) {
      return true;
    }
    return false;
  }

  bool isNotEmpty(String? value) {
    if (!isEmpty(value)) {
      return true;
    }
    return false;
  }

  // replace spaces with (+) symbol
  String replaceSpaces(String value) {
    if (value.containsSpaces) {
      value = value.replaceAll(" ", "+");
    }
    return value;
  }
}
