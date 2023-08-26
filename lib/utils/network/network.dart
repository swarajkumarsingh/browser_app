import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'network_impl.dart';

final networkUtils = NetworkUtilsImpl();

abstract class NetworkUtils {
  Future<bool> isNetwork();
  Future<int> getNetworkStatus();
  String? monitorNetwork(VoidCallback function);
  Stream<ConnectivityResult> connectChangeListener();
}

// Global networkCheck getter
Future<bool> get isNetworkAvailable async {
  try {
    return await networkUtils.isNetwork();
  } catch (e) {
    return false;
  }
}
