import 'package:browser_app/data/provider/state_providers.dart';
import 'package:browser_app/presentation/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/viewModel/webview_view_model.dart';

final functions = _Functions();

class _Functions {
  void navigateToWebviewScreen({
    required WidgetRef ref,
    required String url,
    required bool mounted,
    String query = "",
  }) async {
    final controller = ref.watch(webviewControllerProvider);

    if (controller == null) {
      return;
    }

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
