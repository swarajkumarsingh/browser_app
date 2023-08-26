import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/event_tracker/event_tracker.dart';
import '../../data/db/search_db.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/browser/browser_utils.dart';
import '../../utils/text_utils.dart';
import '../view/webview/webview_screen.dart';

final searchScreenViewModel = _SearchScreenViewModel();

class _SearchScreenViewModel {
  Future<void> logScreen() async {
    await eventTracker.screen("search-screen");
  }

  Future<void> onSubmitted(String prompt) async {
    // Url
    if (textUtils.isValidUrl(prompt)) {
      final url = browserUtils.addHttpToDomain(prompt);
      await searchDB.addHistory(url: url, query: url, time: DateTime.now());
      appRouter.push(WebviewScreen(url: url, prompt: ""));
      return;
    }

    // Query
    final oldPrompt = prompt;
    prompt = textUtils.replaceSpaces(prompt);
    final url = browserUtils.addQueryToGoogle(prompt);
    await searchDB.addHistory(url: url, query: oldPrompt, time: DateTime.now());
    appRouter.push(WebviewScreen(url: url, prompt: prompt));
  }

  void onChanged(WidgetRef ref, String value) {
    if (value.isEmpty) {
      ref
          .read(searchScreenShowSuggestionsProvider.notifier)
          .update((state) => false);
      return;
    }
    ref
        .read(searchScreenShowSuggestionsProvider.notifier)
        .update((state) => true);
  }

  void onTap(
      {required WidgetRef ref,
      required bool showSuggestions,
      required TextEditingController textEditingController}) {
    if (showSuggestions) {
      textEditingController.clear();
      ref
          .read(searchScreenShowSuggestionsProvider.notifier)
          .update((state) => false);
    }
  }
}
