import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, [bool longText = false]) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: longText ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
