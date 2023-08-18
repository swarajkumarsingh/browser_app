import 'package:browser_app/utils/extensions/string_extension.dart';
import 'package:browser_app/utils/url_utils.dart';

final textUtils = _TextUtils();

class _TextUtils {
  bool promptIsUrl(String url) {
    if (!url.containsSpaces && url.containsDot && URLUtil.isValidUrl(url)) {
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

  // replace spaces with (+) symbol
  String replaceSpaces(String value) {
    if (value.containsSpaces) {
      value = value.replaceAll(" ", "+");
    }
    return value;
  }
}
