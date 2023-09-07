import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, {bool longText = false, Color bgColor = Colors.black, Color textColor = Colors.white}) {
  Fluttertoast.showToast(
    msg: message,
    fontSize: 16.0,
    textColor: textColor,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    gravity: ToastGravity.BOTTOM,
    toastLength: longText ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
  );
}
