import 'package:dio/dio.dart';

import '../../../utils/network/network.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // reject re-try request if user is not connected to internet
    final bool result = await isNetworkAvailable;
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
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
