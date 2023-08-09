import 'package:dio/dio.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

class BearerAuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    ///* Send token on every request
    // final GenericDataProvider genericDataProvider =
    //     GenericDataProviderImpl();

    // Get token
    // final token = await genericDataProvider.getToken();

    // if (token == null) {
    //   logger.error('Auth token is null');
    //   return handler.next(options);
    // }
    //  options.headers.putIfAbsent('Authorization', () => token);

    logger.info(
        "Sending ${options.method.toUpperCase()} request to ${options.uri}");

    // TODO: Add header values here
    options.headers['X-Authorization'] = "Add header value here";
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.info(
        "Receiving Response ${response.requestOptions.method.toLowerCase()} ${response.statusCode} ...");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.info("Error Occurred ${err.type} ${err.error} ${err.message}");
    handler.next(err);
  }
}
