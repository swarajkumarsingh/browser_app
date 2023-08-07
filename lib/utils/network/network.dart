import 'dart:async';
import 'network_impl.dart';

final networkUtils = NetworkUtilsImpl();

abstract class NetworkUtils {
  Future<bool> isNetworkConnected();
}

// Global networkCheck getter
Future<bool> get isNetworkAvailable async {
  try {
    return await networkUtils.isNetworkConnected();
  } catch (e) {
    return false;
  }
}
