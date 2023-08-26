import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';

final commonUtils = _CommonUtils();

class _CommonUtils {
  int getRandomInt(int min, int max,
      {bool inclusiveMin = true, bool inclusiveMax = true}) {
    assert(min <= max,
        'Min must be less than or equal to Max，Invalid arguments: min=$min, max=$max');
    final int minVal = inclusiveMin ? min : min + 1;
    final int maxVal = inclusiveMax ? max : max - 1;
    return minVal + Random.secure().nextInt(maxVal - minVal + 1);
  }

  double getRandomDouble(double min, double max,
      {bool inclusiveMin = true, bool inclusiveMax = true}) {
    assert(min <= max,
        'Min must be less than or equal to Max，Invalid arguments: min=$min, max=$max');
    final double minVal = inclusiveMin ? min : min + 0.0000000001;
    final double maxVal = inclusiveMax ? max : max - 0.0000000001;
    return minVal + Random.secure().nextDouble() * (maxVal - minVal);
  }

  void exitAndroidApp() async {
    await SystemNavigator.pop();
  }

  void exitApp() {
    exit(0);
  }
}
