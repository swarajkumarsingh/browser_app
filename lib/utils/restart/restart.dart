import 'package:flutter/material.dart';

import 'restart_impl.dart';

final RestartClass restartUtils = RestartClassImpl();

abstract class RestartClass {
  Future<bool?> restart();
  void silentRestart([BuildContext? context]);
}
