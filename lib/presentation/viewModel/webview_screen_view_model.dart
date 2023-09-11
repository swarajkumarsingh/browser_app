// ignore_for_file: depend_on_referenced_packages

import 'package:browser_app/core/constants/strings.dart';
import 'package:browser_app/data/db/history_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../core/common/snackbar/show_snackbar.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/browser/browser_utils.dart';
import '../view/home/home_screen.dart';

final webviewViewModel = _WebviewViewModel();

class _WebviewViewModel {
  Future<void> init({
    required WidgetRef ref,
    required String url,
    required String query,
    required bool mounted,
  }) async {
    _updateTextEditingController(ref, url);
    await initializeWebview(ref: ref, url: url, query: query, mounted: mounted);
    await _logScreen(url, query);
  }

  Future<void> initializeWebview({
    required WidgetRef ref,
    required String url,
    required String query,
    required bool mounted,
  }) async {
    ref.read(webviewControllerProvider.notifier).update((state) {
      return null;
    });

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    try {
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);

      await controller.setBackgroundColor(Colors.white);

      await controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int _) => _onProgress(ref, _, controller),
          onPageStarted: _onPageStarted,
          onPageFinished: (String _) => _onPageFinished(_, ref),
          onWebResourceError: (WebResourceError _) async => _onWebResourceError,
          onNavigationRequest: (NavigationRequest _) =>
              _onNavigationRequest(ref: ref, request: _, mounted: mounted),
          onUrlChange: (UrlChange _) async => _onUrlChange(ref, _, url),
        ),
      );

      await controller.addJavaScriptChannel('Toaster',
          onMessageReceived: _onMessageReceived);

      await addHistory(url, query);

      await controller.loadRequest(Uri.parse(url));

      if (controller.platform is AndroidWebViewController) {
        await AndroidWebViewController.enableDebugging(true);
        await (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }
    } catch (e) {
      logger.error(e);
      showSnackBar(Strings.errorOccurred);
    }

    ref.read(webviewControllerProvider.notifier).update((state) {
      return controller;
    });
  }

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

  Future<NavigationDecision> _onNavigationRequest({
    required WidgetRef ref,
    required NavigationRequest request,
    required bool mounted,
  }) async {
    final fileNameController = ref.watch(webviewFileNameControllerProvider);

    return browserUtils.onNavigationRequest(
      request: request,
      fileNameController: fileNameController,
      mounted: mounted,
    );
  }

  Future<void> addHistory(String url, String query) async {
    await historyDB.addHistory(url: url, query: query);
  }

  Future<void> _onWebResourceError(WebResourceError error) async {
    logger.error('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');

    await eventTracker.log("webResourceError", {
      "code": error.errorCode,
      "description": error.description,
      "errorType": error.errorType,
      "isForMainFrame": error.isForMainFrame,
    });
  }

  void _onMessageReceived(JavaScriptMessage message) async {
    showSnackBar(message.message);
  }

  void _onPageStarted(String url) async {
    logger.info('Page started loading: $url');
  }

  void _onProgress(
      WidgetRef ref, int progress, WebViewController controller) async {
    logger.info('WebView is loading (progress : $progress%)');
    if (progress < 70) {
      ref.read(webviewScreenLoadingProvider.notifier).update((state) => true);
      return;
    }

    ref.read(webviewScreenLoadingProvider.notifier).update((state) => false);
  }

  void _onPageFinished(String url, WidgetRef ref) async {
    ref.read(webviewScreenLoadingProvider.notifier).update((state) => false);
    logger.info('Page finished loading: $url');
  }

  Future<void> _onUrlChange(WidgetRef ref, UrlChange change, String url) async {
    logger.info('url change to ${change.url}');
    ref
        .read(webviewSearchTextControllerProvider.notifier)
        .update((state) => TextEditingController(text: change.url ?? url));
  }

  Future<bool> onWillPop(WidgetRef ref) async {
    final controller = ref.watch(webviewControllerProvider);

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
    appRouter.pushAndRemoveUntil(const HomeScreen());
  }
}
