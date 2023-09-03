import 'package:browser_app/data/db/history_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/event_tracker/event_tracker.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/browser/browser_utils.dart';
import '../view/home/home_screen.dart';

final webviewViewModel = _WebviewViewModel();

class _WebviewViewModel {
  Future<void> init({
    required BuildContext context,
    required WidgetRef ref,
    required String url,
    required String query,
    required bool mounted,
  }) async {
    _updateTextEditingController(ref, url);
    await _initializeWebview(
        context: context, ref: ref, url: url, query: query, mounted: mounted);
    await _logScreen(url, query);
  }

  Future<void> _initializeWebview({
    required BuildContext context,
    required WidgetRef ref,
    required String url,
    required String query,
    required bool mounted,
  }) async {}

  void _updateTextEditingController(WidgetRef ref, String url) {
    ref
        .read(webviewSearchTextControllerProvider.notifier)
        .update((state) => TextEditingController(text: url));
  }

  Future<void> _logScreen(String url, String prompt) async {
    await eventTracker.screen("webview-screen", {
      "url": url,
      "prompt": prompt,
    });
  }

  Future<NavigationActionPolicy> onNavigationRequest({
    required WidgetRef ref,
    required String url,
    required BuildContext context,
  }) async {
    final fileNameController = ref.watch(webviewFileNameControllerProvider);

    return browserUtils.onNavigationRequest(
      url: url,
      context: context,
      fileNameController: fileNameController,
    );
  }

  Future<void> addHistory(String url, String query) async {
    await historyDB.addHistory(url: url, query: query);
  }

  Future<bool> onWillPop(InAppWebViewController? controller) async {
    if (controller == null) {
      return true;
    }

    if (!await controller.canGoBack()) {
      return true;
    }
    await controller.goBack();
    return false;
  }

  Future<void> navigateToHomeScreen() async {
    appRouter.push(const HomeScreen());
  }
}
