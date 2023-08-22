import 'package:browser_app/utils/browser/browser_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/event_tracker/event_tracker.dart';
import '../../view/home/home_screen.dart';

final webviewViewModel = _WebviewViewModel();

class _WebviewViewModel {
  Future<NavigationDecision> onNavigationRequest({
    required NavigationRequest request,
    required BuildContext context,
    required TextEditingController fileNameController,
    required bool mounted,
  }) async {
    return browserUtils.onNavigationRequest(
      request: request,
      context: context,
      fileNameController: fileNameController,
      mounted: mounted,
    );
  }

  Future<void> onWebResourceError(WebResourceError error) async {
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

  Future<void> onMessageReceived(BuildContext context, JavaScriptMessage message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.message)),
    );
  }

  void onPageStarted(String url) async {
    logger.info('Page started loading: $url');
  }

  Future<bool> onWillPop(WebViewController? controller) async {
    if (controller == null) {
      return true;
    }

    if (!await controller.canGoBack()) {
      return true;
    }
    await controller.goBack();
    logger.info("Back button pressed");
    return false;
  }

  void navigateToHomeScreen() {
    appRouter.push(const HomeScreen());
  }
}
