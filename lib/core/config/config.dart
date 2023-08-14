import 'package:flutter/foundation.dart';

class Config {
  const Config._();

  // ENV variables
  static String salt = "odhaiufh3q94979fhsdifhsf";
  static String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  static const String applicationName = "Dictionary";
  static const String packageName = "com.production.dictionary";
  static const String packageNameIOS = "com.production.dictionary";
}

const bool isInProduction = kDebugMode == true ? false : true;
