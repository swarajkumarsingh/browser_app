import 'package:flutter/foundation.dart';

class Config {
  const Config._();

  // ENV variables
  static String salt = "odhaiufh3q94979fhsdifhsf";
  static String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  static const String applicationName = "Browser App";
  static const String packageName = "com.example.browser_app";
  static const String packageNameIOS = "com.example.browser_app";
}

const bool isInProduction = kDebugMode == true ? false : true;
