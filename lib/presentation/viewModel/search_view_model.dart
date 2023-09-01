import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../../core/common/snackbar/show_snackbar.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/browser/browser_utils.dart';
import '../../utils/speech_services.dart';
import '../../utils/text_utils.dart';
import '../view/webview/webview_screen.dart';

final searchScreenViewModel = _SearchScreenViewModel();

class _SearchScreenViewModel {
  Future<void> logScreen() async {
    await eventTracker.screen("search-screen");
  }

  Future<void> initSpeechText(WidgetRef ref) async {
    await speechService.init(ref);
  }

  Future<void> onSubmitted(String prompt) async {
    // Url
    if (textUtils.isValidUrl(prompt)) {
      final url = browserUtils.addHttpToDomain(prompt);
      appRouter.push(WebviewScreen(url: url, query: ""));
      return;
    }

    // Query
    prompt = textUtils.replaceSpaces(prompt);
    final url = browserUtils.addQueryToGoogle(prompt);
    appRouter.push(WebviewScreen(url: url, query: prompt));
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

  Future<void> speechTextListen(WidgetRef ref, BuildContext context) async {
    final model = await speechService.speechTextListen(ref, context);

    if (!model.success) {
      showSnackBar(model.message);
      return;
    }

    // final text = ref.watch(transcribedTextProvider);
    // await onSubmitted(text);
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

  void onTap(
      {required WidgetRef ref,
      required BuildContext context,}) {
    speechTextListen(ref, context);
  }
}
