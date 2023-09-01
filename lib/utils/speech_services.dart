// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/provider/state_providers.dart';
import '../domain/models/speech_model.dart';
import '../presentation/widgets/search/speech_to_text_dialog.dart';

final speechService = _SpeechService();

class _SpeechService {
  Future<void> init(WidgetRef ref) async {
    await SpeechToText().initialize();
    return;
  }

  Future<SpeechModel> speechTextListen(
      WidgetRef ref, BuildContext context) async {
    final speechText = ref.watch(speechToTextProvider);

    if (!await speechText.hasPermission) {
      return SpeechModel(success: false, message: "permission not allowed");
    }

    if (!speechText.isAvailable) {
      return SpeechModel(success: false, message: "speech not available");
    }

    if (speechText.hasError) {
      logger.error(speechText.lastError);
      return SpeechModel(success: false, message: "error occurred");
    }

    logger.success("1");

    showSpeechDialog(
      ref: ref,
      context: context,
      function: () {
        stopListening(ref);
        closeSpeechModel(ref);
      },
    );

    logger.success("2");

    try {
      logger.success("3");

      await speechText.listen(
        onResult: (SpeechRecognitionResult result) {
          logger.info('Transcribed text: ${result.alternates}');
          logger.info('Transcribed text: ${result.confidence}');
          logger.info('Transcribed text: ${result.finalResult}');
          logger.info('Transcribed text: ${result.hasConfidenceRating}');
          logger.info('Transcribed text: ${result.isConfident()}');
          logger.info('Transcribed text: ${result.toFinal()}');
          logger.info('Transcribed text: ${result.recognizedWords}');
          _onSpeechResult(context: context, ref: ref, result: result);
        },
        cancelOnError: true,
        // listenMode: ListenMode.search,
        // listenFor: const Duration(seconds: 3),
      );
      logger.success("4");
    } catch (e) {
      logger.error(e);
    }

    logger.success("5");

    return SpeechModel(success: true, message: 'speak');
  }

  void closeSpeechModel(WidgetRef ref) {
    ref.read(showSpeechDialogProvider.notifier).update((state) => false);
  }

  void openSpeechDialog(WidgetRef ref) {
    ref.read(showSpeechDialogProvider.notifier).update((state) => true);
  }

  void onSpeechDialogDismiss(WidgetRef ref) async {
    ref.read(transcribedTextProvider.notifier).update((state) => "");
    await stopListening(ref);
  }

  Future<void> cancelSpeechText(WidgetRef ref) async {
    final speechText = ref.watch(speechToTextProvider);
    await speechText.cancel();
  }

  void _onSpeechResult(
      {required WidgetRef ref,
      required BuildContext context,
      required SpeechRecognitionResult result}) {
    ref
        .read(transcribedTextProvider.notifier)
        .update((state) => result.recognizedWords);

    closeSpeechModel(ref);
  }

  Future<void> stopListening(WidgetRef ref) async {
    final speechText = ref.watch(speechToTextProvider);
    await speechText.stop();
  }

  Future<void> dispose(WidgetRef ref) async {
    await stopListening(ref);
    ref.read(speechToTextProvider.notifier).dispose();
  }
}
