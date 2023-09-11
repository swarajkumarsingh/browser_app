import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

import '../core/common/snackbar/show_snackbar.dart';
import '../core/constants/constants.dart';
import '../core/constants/strings.dart';

final tts = _TTS(flutterTts);

class _TTS {
  _TTS(this._flutterTts);
  final FlutterTts _flutterTts;

  // getter for tts package
  FlutterTts get getTTS => _flutterTts;

  Future<void> init() async {
    if (Platform.isIOS) {
      await _flutterTts.setSharedInstance(true);
    }
  }

  Future<void> speak(String content) async {
    try {
      await _flutterTts.speak(content);
    } catch (e) {
      showSnackBar(Strings.errorOccurred);
    }
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
    } catch (e) {
      showSnackBar(Strings.errorOccurred);
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      showSnackBar(Strings.errorOccurred);
    }
  }
}
