import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'custom_snackbar.dart';

/// A custom snackbar used to show info.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showInfoSnackBar({
  required String text,
  String? subText,
  SnackBarAction? snackBarAction,
}) {
  final BuildContext? context = scaffoldMessengerKey.currentContext;

  if (context != null) {
    final ThemeData theme = Theme.of(context);

    return showCustomSnackBar(
      text: text,
      subText: subText,
      iconData: Icons.info,
      iconAndTextColor: theme.colorScheme.surface,
      action: snackBarAction,
    );
  } else {
    return null;
  }
}
