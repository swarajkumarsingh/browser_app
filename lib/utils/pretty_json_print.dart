import 'dart:convert';

import 'package:flutter_logger_plus/flutter_logger_plus.dart';


///Helps printing formatted server response
String prettyJson(dynamic json, {int indent = 2}) {
  final spaces = ' ' * indent;
  final encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

void prettyJsonPrint(dynamic json, {int indent = 2}) {
  logger.info(prettyJson(json, indent: indent));
}
