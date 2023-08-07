///  jh_common_utils.dart
///
///  Created by iotjin on 2020/03/25.
///  description:  公共工具类

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';

class JhCommonUtils {
  /// 获取随机整数（默认包含最大最小值）
  static int getRandomInt(int min, int max,
      {bool inclusiveMin = true, bool inclusiveMax = true}) {
    assert(min <= max,
        'Min must be less than or equal to Max，Invalid arguments: min=$min, max=$max');
    final int minVal = inclusiveMin ? min : min + 1;
    final int maxVal = inclusiveMax ? max : max - 1;
    return minVal + Random.secure().nextInt(maxVal - minVal + 1);
  }

  /// 获取随机小数（默认包含最大最小值）
  static double getRandomDouble(double min, double max,
      {bool inclusiveMin = true, bool inclusiveMax = true}) {
    assert(min <= max,
        'Min must be less than or equal to Max，Invalid arguments: min=$min, max=$max');
    final double minVal = inclusiveMin ? min : min + 0.0000000001;
    final double maxVal = inclusiveMax ? max : max - 0.0000000001;
    return minVal + Random.secure().nextDouble() * (maxVal - minVal);
  }

  /// 退出应用程序
  static void exitAndroidApp() async {
    // await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    await SystemNavigator.pop();
  }

  /// 退出应用程序
  static void exitApp() {
    exit(0);
  }

  static Timer? _debounceTimer;

  /// 防抖 (传入所要防抖的方法/回调与延迟时间)
  static void debounce(Function func, [int delay = 500]) {
    if (_debounceTimer != null) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(Duration(milliseconds: delay), () {
      func.call();
      _debounceTimer = null;
    });
  }

  /// 防抖 (传入所要防抖的方法/回调与延迟时间)
  static Null Function() debounce2(Function func, [int delay = 500]) {
    Timer? timer;
    return () {
      if (timer != null) {
        timer?.cancel();
      }
      timer = Timer(Duration(milliseconds: delay), () {
        func.call();
        timer = null;
      });
    };
  }

  /// 录入框防抖 (传入所要防抖的方法/回调与延迟时间)
  static Null Function(dynamic value) debounceInput(Function(dynamic) func,
      [int delay = 500]) {
    Timer? timer;
    return (dynamic value) {
      if (timer != null) {
        timer?.cancel();
      }
      timer = Timer(Duration(milliseconds: delay), () {
        func.call(value);
        timer = null;
      });
    };
  }

  static Timer? _throttleTimer;
  static bool _throttleFlag = true;

  /// 节流 (传入所要节流的方法/回调与延迟时间)
  static void throttle(Function func, [int delay = 500]) {
    if (_throttleFlag) {
      func.call();
      _throttleFlag = false;
      return;
    }
    if (_throttleTimer != null) {
      return;
    }
    _throttleTimer = Timer(Duration(milliseconds: delay), () {
      func.call();
      _throttleTimer = null;
    });
  }

  /// 节流 (传入所要节流的方法/回调与延迟时间)
  static Null Function() throttle2(Function func, [int delay = 500]) {
    Timer? timer;
    bool firstTime = true;
    return () {
      if (firstTime) {
        func.call();
        firstTime = false;
        return;
      }
      if (timer != null) {
        return;
      }
      timer = Timer(Duration(milliseconds: delay), () {
        func.call();
        timer = null;
      });
    };
  }

  /// 节流 (传入所要节流的方法/回调与延迟时间)
  static Null Function() throttle3(Function func, [int delay = 500]) {
    Timer? timer;
    bool isExecuting = false;
    return () {
      if (isExecuting) return;
      isExecuting = true;
      timer?.cancel();
      timer = Timer(Duration(milliseconds: delay), () {
        func.call();
        isExecuting = false;
      });
    };
  }
}
