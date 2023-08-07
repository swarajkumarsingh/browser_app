import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

import '../../constants/constants.dart';
import '../../provider/generic_data_provider.dart';
import 'restart.dart';
import 'restart_widget.dart';

class RestartClassImpl extends RestartClass {
  @override
  Future<bool?> restart() async {
    final bool result = await Restart.restartApp();
    if (!result) {
      throw "Unable to restart the app";
    }
    return result;
  }

  @override
  void silentRestart([BuildContext? context]) {
    int numOfRetries = 0;

    // Some errors occurs every time, and in that case restart app goes to an infinite loop, to prevent that we take a track of restart and if it exceeds the number, we exit the app
    try {
      if (numOfRetries == maxNumberOfRestartTries ||
          numOfRetries > maxNumberOfRestartTries) {
        exit(0);
      }

      if (context != null) {
        RestartWidget.restartApp(context);
        numOfRetries++;
        return;
      }
      final BuildContext? secondaryContext = genericDataProvider.getContext();
      if (secondaryContext != null) {
        RestartWidget.restartApp(secondaryContext);
        numOfRetries++;
        return;
      }
      numOfRetries++;
      restart();
      return;
    } catch (e) {
      exit(0);
    }
  }
}
