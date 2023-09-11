import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'network.dart';

class NetworkUtilsImpl extends NetworkUtils {
  @override
  Stream<ConnectivityResult> connectChangeListener() async* {
    final Connectivity connectivity = Connectivity();

    await for (final ConnectivityResult result
        in connectivity.onConnectivityChanged) {
      yield result;
    }
  }

  @override
  Future<int> getNetworkStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
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
