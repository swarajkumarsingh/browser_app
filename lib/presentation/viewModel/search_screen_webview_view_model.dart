// ignore_for_file: use_build_context_synchronously

import 'package:browser_app/utils/functions/functions.dart';
import 'package:flutter/material.dart';
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

  void onTap(WidgetRef ref, BuildContext context, bool showSuggestions,
      TextEditingController textEditingController) {
    if (showSuggestions) {
      textEditingController.clear();
      return;
    }
  }

  Future<void> shareUrl(String url) async {
    final result = await shareUtils.shareUrl(url);
    if (!result) {
      showToast("Failed to share");
    }
  }

  void navigateToWebviewScreen(
      WidgetRef ref, BuildContext context, String text) {
    // Url
    if (textUtils.isValidUrl(text)) {
      functions.navigateToWebviewScreen(
        ref: ref,
        url: browserUtils.addHttpToDomain(text),
        mounted: true,
      );
      return;
    }

    // Query
    final prompt = textUtils.replaceSpaces(text);
    functions.navigateToWebviewScreen(
      ref: ref,
      url: browserUtils.addQueryToGoogle(prompt),
      query: prompt,
      mounted: true,
    );
  }

  void navigateToWebviewScreen2(
      WidgetRef ref, BuildContext context, String text) {
    // Url
    if (textUtils.isValidUrl(text)) {
      functions.popToWebviewScreen(
        ref: ref,
        context: context,
        url: browserUtils.addHttpToDomain(text),
        mounted: true,
      );
      return;
    }

    // Query
    final prompt = textUtils.replaceSpaces(text);
    functions.popToWebviewScreen(
      ref: ref,
      context: context,
      url: browserUtils.addQueryToGoogle(prompt),
      query: prompt,
      mounted: true,
    );
  }

  void updateClipBoardState(WidgetRef ref, String url) async {
    ref.read(clipBoardProvider.notifier).update((state) => url);
    showSnackBar("Copied to Clipboard");
  }

  void onSubmitted(WidgetRef ref, BuildContext context, String text) {
    FocusScope.of(context).unfocus();
    navigateToWebviewScreen2(ref, context, text);
  }
}
