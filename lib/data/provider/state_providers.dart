import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../db/webview_db.dart';
import '../../domain/models/webview_model.dart';

final dataProvider = StateProvider<String>((ref) => "");
final toggleMicIconProvider = StateProvider<bool>((ref) => false);

final clipBoardProvider = StateProvider<String>((ref) => "");

final searchScreenShowSuggestionsProvider = StateProvider<bool>((ref) => false);

final downloadedFileProvider = StateProvider<List<DownloadTask>>((ref) => <DownloadTask>[]);

final webviewScreenLoadingProvider = StateProvider<bool>((ref) => false);
final webviewControllerProvider = StateProvider<WebViewController?>((ref) => null);
final webviewFileNameControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController(text: ""));
final webviewSearchTextControllerProvider = StateProvider<TextEditingController>((ref) => TextEditingController(text: ""));

final tabsListProvider = StateProvider<List<WebViewModel>>((ref) => <WebViewModel>[WebViewModel(url: "https://google.com/", tabIndex: 1, title: "Google", isIncognitoMode: false, screenshot: webviewDB.getHomeScreenImageBytes())]);