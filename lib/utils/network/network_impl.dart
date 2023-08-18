import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'network.dart';

class NetworkUtilsImpl extends NetworkUtils {
  @override
  Stream<ConnectivityResult> connectChangeListener() async* {
    final Connectivity connectivity = Connectivity();

    // 遍历onConnectivityChanged 构成的 Stream<ConnectivityResult>
    await for (final ConnectivityResult result
        in connectivity.onConnectivityChanged) {
      // 状态发生改变后将状态值添加到Stream数据流中
      yield result;
    }
  }

  @override
  Future<int> getNetworkStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // 网络类型为移动网络
      return 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // 网络类型为WIFI
      return 2;
    } else {
      return 0;
    }
  }

  @override
  Future<bool> isNetwork() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  String? monitorNetwork(VoidCallback function) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult event) {
      function();
    });
    return null;
  }
}
