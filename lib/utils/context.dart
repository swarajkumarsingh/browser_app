import 'package:flutter/material.dart';
import 'package:flutter_approuter/flutter_approuter.dart';

import '../core/constants/constants.dart';

final contextUtils = ContextUtils();

class ContextUtils {
  BuildContext? getContext() {
    // try to get context from scaffoldMessengerKey
    BuildContext? context = scaffoldMessengerKey.currentState?.context;
    if (context != null && context.mounted) {
      return context;
    }

    // re-try to get context with navigatorKey
    context = appRouter.getContext();
    if (context != null && context.mounted) {
      return context;
    }
    return null;
  }
}
