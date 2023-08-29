import '../view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/snackbar/show_snackbar.dart';
import '../../core/common/widgets/toast.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/browser/browser_utils.dart';
import '../../utils/share_app.dart';
import '../../utils/text_utils.dart';

final searchScreenWebviewViewModel = _SearchScreenWebviewViewModel();

class _SearchScreenWebviewViewModel {
  Future<void> logScreen(String url, String prompt) async {
    await eventTracker.screen("search-screen-webview", {
      "url": url,
      "prompt": prompt,
    });
  }

  void onChanged(WidgetRef ref, String value) {
    if (textUtils.isEmpty(value)) {
      ref
          .read(searchScreenWebviewShowSuggestionsProvider.notifier)
          .update((state) => false);
      return;
    }
    ref
        .read(searchScreenWebviewShowSuggestionsProvider.notifier)
        .update((state) => true);
  }

  void onTap(
      bool showSuggestions, TextEditingController textEditingController) {
    if (showSuggestions) {
      textEditingController.clear();
    }
  }

    Future<void> shareUrl(String url) async {
    final result = await shareUtils.shareUrl(url);
    if (!result) {
      showToast("Failed to share");
    }
  }

  void navigateToWebviewScreen(String clipBoardText) {
    // Url
    if (textUtils.isValidUrl(clipBoardText)) {
      appRouter.push(WebviewScreen(
        url: browserUtils.addHttpToDomain(clipBoardText),
        query: "",
      ));
      return;
    }

    // Query
    final prompt = textUtils.replaceSpaces(clipBoardText);

    appRouter.push(WebviewScreen(
      url: browserUtils.addQueryToGoogle(prompt),
      query: prompt,
    ));
  }

  void updateClipBoardState(WidgetRef ref, String url) async {
    ref.read(clipBoardProvider.notifier).update((state) => url);
    showSnackBar("Copied to Clipboard");
  }

  void onSubmitted(BuildContext context, String prompt) {
    FocusScope.of(context).unfocus();

    // Url
    if (textUtils.isValidUrl(prompt)) {
      appRouter.push(WebviewScreen(
        url: browserUtils.addHttpToDomain(prompt),
      ));
      return;
    }

    // Query
    prompt = textUtils.replaceSpaces(prompt);

    appRouter.push(WebviewScreen(
      url: browserUtils.addQueryToGoogle(prompt),
      query: prompt,
    ));
  }
}
