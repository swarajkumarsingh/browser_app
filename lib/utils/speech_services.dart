import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/state_providers.dart';
import '../presentation/viewModel/search_screen_view_model.dart';

final speechService = _SpeechService();
class _SpeechService {
  Future<void> stopListening(WidgetRef ref, SpeechToText speechToText) async {
    final lastWords = ref.watch(dataProvider);
    await speechToText.stop();
    await searchScreenViewModel.onSubmitted(lastWords);
  }

  Future<void> startListening(WidgetRef ref, SpeechToText speechToText) async {
    await speechToText.listen(
      onResult: (result) {
        ref
            .read(dataProvider.notifier)
            .update((state) => result.recognizedWords);
      },
    );
  }
}
