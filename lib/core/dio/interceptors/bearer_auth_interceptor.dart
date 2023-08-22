import 'package:dio/dio.dart';

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


    // TODO: Add header values here
    options.headers['X-Authorization'] = "Add header value here";
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
