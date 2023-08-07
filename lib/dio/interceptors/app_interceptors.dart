import 'package:dio/dio.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import '../../utils/network/network.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    logger.info(
        "Sending ${options.method.toUpperCase()} request to ${options.uri}");

    // reject re-try request if user is not connected to internet
    final bool result = await networkUtils.isNetworkConnected();
    if (result == false) {
      return handler.reject(
        DioException.connectionError(
          requestOptions: options,
          reason: "Connection to API server failed due to internet connection",
        ),
      );
    }
    return handler.next(options);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    logger.info(
        "Receiving response Method: ${response.requestOptions.method.toUpperCase()} StatusCode: ${response.statusCode} ...");
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.error("Error Occurred ${err.type} ${err.error} ${err.message}");

    return handler.next(err);
  }
}
