import 'dart:io';

import 'network.dart';


class NetworkUtilsImpl extends NetworkUtils {
  @override
  Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return true;
  }
}
