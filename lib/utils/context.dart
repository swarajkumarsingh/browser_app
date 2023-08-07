import 'package:flutter/material.dart';

import '../constants/constants.dart';

final contextUtils = ContextUtils();

class ContextUtils {
  BuildContext? getContext() {
    final BuildContext? context = scaffoldMessengerKey.currentState?.context;
    if (context != null && context.mounted) {
      return context;
    }
    return null;
  }
}
