import 'package:browser_app/data/provider/state_providers.dart';
import 'package:browser_app/presentation/view/webview/webview_screen.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/viewModel/webview_view_model.dart';

final functions = _Functions();

class _Functions {
  Future<void> navigateToWebviewScreen({
    required WidgetRef ref,
    required String url,
    required bool mounted,
    String query = "",
  }) async {
    // final controller = ref.watch(webviewControllerProvider);

    await webviewViewModel.init(
        ref: ref, url: url, query: query, mounted: mounted);

    appRouter.push(WebviewScreen(
      url: url,
      query: query,
    ));
  }

  void removeNavigateToWebviewScreen({
    required WidgetRef ref,
    required String url,
    required bool mounted,
    String query = "",
  }) async {
    await webviewViewModel.init(
        ref: ref, url: url, query: query, mounted: mounted);

    appRouter.pushAndRemoveUntil(WebviewScreen(
      url: url,
      query: query,
    ));
  }

  void popToWebviewScreen({
    required WidgetRef ref,
    required String url,
    required bool mounted,
    String query = "",
  }) async {
    final controller = ref.watch(webviewControllerProvider);

    if (controller == null) {
      await webviewViewModel.init(
          ref: ref, url: url, query: query, mounted: mounted);
      appRouter.pop();
    }

    await controller!.loadRequest(Uri.parse(url));
    appRouter.pop();
  }
}
