// ignore_for_file: use_build_context_synchronously

import 'package:browser_app/utils/speech_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../core/common/snackbar/show_snackbar.dart';
import '../../core/common/widgets/toast.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/browser/browser_utils.dart';
import '../../utils/share_app.dart';
import '../../utils/text_utils.dart';
import '../view/webview/webview_screen.dart';

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

  Future<void> initSpeechText(WidgetRef ref) async {
    await speechService.init(ref);
  }

  void onTap(WidgetRef ref, BuildContext context, bool showSuggestions,
      TextEditingController textEditingController) {
    if (showSuggestions) {
      textEditingController.clear();
      return;
    }
    speechTextListen(ref, context);
  }

  Future<void> speechTextListen(WidgetRef ref, BuildContext context) async {
    final model = await speechService.speechTextListen(ref, context);

    if (!model.success) {
      showSnackBar(model.message);
      return;
    }

    final text = ref.watch(transcribedTextProvider);
    appRouter.push(WebviewScreen(url: text));
  }

  Future<void> pauseSpeechText(WidgetRef ref) async {
    final speechText = ref.watch(speechToTextProvider);

    await speechText.cancel();
  }

  void onSpeechResult(WidgetRef ref, SpeechRecognitionResult result) {
    logger.info('Transcribed text: ${result.recognizedWords}');
    ref
        .read(transcribedTextProvider.notifier)
        .update((state) => result.recognizedWords);
  }

  void stopListening(WidgetRef ref) {
    final speechText = ref.watch(speechToTextProvider);
    speechText.stop();
  }

  Future<void> shareUrl(String url) async {
    final result = await shareUtils.shareUrl(url);
    if (!result) {
      showToast("Failed to share");
    }
  }

  void navigateToWebviewScreen(String text) {
    // Url
    if (textUtils.isValidUrl(text)) {
      appRouter.push(WebviewScreen(
        url: browserUtils.addHttpToDomain(text),
        query: "",
      ));
      return;
    }

    // Query
    final prompt = textUtils.replaceSpaces(text);

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
