import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';

import '../../data/provider/state_providers.dart';
import '../../presentation/view/webview/webview_screen.dart';
import '../../presentation/viewModel/webview_screen_view_model.dart';

final functions = _Functions();

class _Functions {

    Future<List<String>> fetchSuggestions(String keyword) async {
    final response = await Dio().get(
        "http://google.com/complete/search?q=$keyword&output=toolbar",
        options: Options(contentType: "text/xml"));

    if (response.statusCode == 200) {
      final responseBody = response.data;
      final xmlDocument = XmlDocument.parse(responseBody);

      logger.success(xmlDocument);

      final suggestions = xmlDocument.findAllElements('suggestion');
      return suggestions
          .map((element) => element.getAttribute('data') ?? '')
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  void navigateToWebviewScreen({
    required WidgetRef ref,
    required String url,
    required bool mounted,
    String query = "",
  }) async {

    await webviewViewModel.init(
        ref: ref, url: url, query: query, mounted: mounted);

    appRouter.push(WebviewScreen(
      url: url,
      query: query,
    ));
  }

  void popToWebviewScreen({
    required WidgetRef ref,
    required BuildContext context,
    required String url,
    required bool mounted,
    String query = "",
  }) async {
    final controller = ref.watch(webviewControllerProvider);

    if (controller == null) {
      return;
    }

    await controller.loadRequest(Uri.parse(url));
    appRouter.pop();
  }
}
