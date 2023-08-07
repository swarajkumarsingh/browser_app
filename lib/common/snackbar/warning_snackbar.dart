import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'custom_snackbar.dart';

const Color warningColor = Color(0xFFF18C33);

/// A custom snackbar used to show success.
ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showWarningSnackBar({
  required String text,
  String? subText,
}) {
  final BuildContext? context = scaffoldMessengerKey.currentContext;

  if (context != null) {
    return showCustomSnackBar(
      text: text,
      subText: subText,
      iconData: Icons.warning_rounded,
      duration: const Duration(seconds: 30),
      // Using custom colors.
      iconAndTextColor: warningColor,
    );
  } else {
    return null;
  }
}
