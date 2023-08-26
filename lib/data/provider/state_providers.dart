import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

final clipBoardProvider = StateProvider<String>((ref) => "");
final webviewScreenLoadingProvider = StateProvider<bool>((ref) => false);
final searchScreenShowSuggestionsProvider = StateProvider<bool>((ref) => false);
final webviewControllerProvider = StateProvider<WebViewController?>((ref) => null);
final searchScreenWebviewShowSuggestionsProvider = StateProvider<bool>((ref) => false);
final webviewSearchTextControllerProvider =StateProvider<TextEditingController>((ref) => TextEditingController(text: ""));
final webviewFileNameControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController(text: ""));