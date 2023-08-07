import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'custom_snackbar.dart';

/// A custom snackbar used to show errors.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showErrorSnackBar({
  required String text,
  String? subText,
  required SnackBarAction action,
}) {
  final ScaffoldMessengerState? scaffold = scaffoldMessengerKey.currentState;

  if (scaffold != null) {
    final BuildContext context = scaffold.context;

    final ThemeData theme = Theme.of(context);

    return showCustomSnackBar(
      text: text,
      subText: subText,
      iconData: Icons.cancel,
      iconAndTextColor: theme.colorScheme.error,
      duration: const Duration(seconds: 30),
      action: action,
    );
  } else {
    return null;
  }
}
