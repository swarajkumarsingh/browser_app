import 'package:browser_app/data/db/webview_db.dart';
import 'package:browser_app/domain/models/webview_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

final clipBoardProvider = StateProvider<String>((ref) => "");
final webviewScreenLoadingProvider = StateProvider<bool>((ref) => false);
final searchScreenShowSuggestionsProvider = StateProvider<bool>((ref) => false);
final webviewControllerProvider = StateProvider<WebViewController?>((ref) => null);
final searchScreenWebviewShowSuggestionsProvider = StateProvider<bool>((ref) => false);
final webviewFileNameControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController(text: ""));
final webviewSearchTextControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController(text: ""));
final downloadedFileProvider = StateProvider<List<DownloadTask>>((ref) => <DownloadTask>[]);
final tabsListProvider = StateProvider<List<WebViewModel>>((ref) => <WebViewModel>[WebViewModel(url: "https://google.com/", tabIndex: 1, title: "Google", isIncognitoMode: false, screenshot: webviewDB.getHomeScreenImageBytes())]);