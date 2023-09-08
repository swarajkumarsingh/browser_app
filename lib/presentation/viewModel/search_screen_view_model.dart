import '../../domain/repository/webview_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/common/widgets/toast.dart';
import '../../core/constants/strings.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/browser/browser_utils.dart';
import '../../utils/functions/functions.dart';
import '../../utils/speech_services.dart';
import '../../utils/text_utils.dart';

final searchScreenViewModel = _SearchScreenViewModel();

class _SearchScreenViewModel {
  final _speechToText = SpeechToText();

  Future<void> init() async {
    await _speechToText.initialize(
      onError: _onSpeechError,
      debugLogging: kDebugMode,
      finalTimeout: const Duration(seconds: 5),
      onStatus: (status) => logger.info("Speech package status: $status"),
      options: [],
    ).then((value) {
      logger.info("Speech to Text initialized");
    });
  }

  Future<List<String>> fetchSuggestions(String keyword) async {
    final suggestions = await webviewRepository.getSuggestions(keyword: keyword);
    if (!suggestions.successBool || suggestions.data == null) {
      return [];
    }

    return suggestions.data!;
  }

  void dispose() async {
    await _speechToText.stop();
  }

  void _onSpeechError(SpeechRecognitionError errorNotification) {
    if (errorNotification.permanent) {
      init();
      return;
    }

    logger.error(errorNotification.errorMsg);
    showToast(Strings.errorOccurred);
  }

  Future<void> logScreen() async {
    await eventTracker.screen("search-screen");
  }

  Future<void> onSubmitted(WidgetRef ref, String prompt) async {
    // Url
    if (textUtils.isValidUrl(prompt)) {
      final url = browserUtils.addHttpToDomain(prompt);
      functions.navigateToWebviewScreen(
        ref: ref,
        url: url,
        mounted: true,
      );
      return;
    }

    // Query
    prompt = textUtils.replaceSpaces(prompt);
    final url = browserUtils.addQueryToGoogle(prompt);
    functions.navigateToWebviewScreen(
      ref: ref,
      url: url,
      mounted: true,
    );
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

  void toggle(WidgetRef ref) {
    final listening = ref.watch(toggleMicIconProvider);
    if (listening == true) {
      ref.read(toggleMicIconProvider.notifier).update((state) => false);
      return;
    }
    ref.read(toggleMicIconProvider.notifier).update((state) => true);
  }

  Future<void> stopListening(WidgetRef ref, SpeechToText speechToText) async =>
      speechService.stopListening;

  Future<void> _startListening(
          WidgetRef ref, SpeechToText speechToText) async =>
      speechService.startListening;

  void onTap({
    required WidgetRef ref,
  }) async {
    if (await _speechToText.hasPermission == false) {
      showToast("Permission not given");
      return;
    }

    if (!_speechToText.isAvailable) {
      showToast("speech not available");
      return;
    }

    if (_speechToText.hasError) {
      showToast(Strings.errorOccurred);
      return;
    }

    try {
      if (await _speechToText.hasPermission &&
          _speechToText.isAvailable &&
          _speechToText.isNotListening) {
        await _startListening(ref, _speechToText);
        toggle(ref);
      } else if (_speechToText.isListening) {
        await stopListening(ref, _speechToText);
        toggle(ref);
      } else {
        await _speechToText.initialize();
      }
    } catch (e) {
      showToast(Strings.errorOccurred);
      rethrow;
    }
  }
}
