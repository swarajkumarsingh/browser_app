import 'package:flutter/material.dart';

import '../../constants/constants.dart';

void showSnackBar(String message) {
  final SnackBar snackBar = SnackBar(content: Text(message));
  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}
