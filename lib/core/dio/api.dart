import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

import 'dio_constants.dart';
import 'interceptors/app_interceptors.dart';

/// Usage [API]
/// final res = await Api().get('<url>');
/// if (res.statusCode != 200) {
///   errorTracker.log('sendbird_token_error: ${res.data}');
///   return null;
///  }
///  return HomeModel.fromJson(res.data);

class Api {
  final dio = createDio();

  static Dio createDio() {
    final Dio dio = Dio(
      BaseOptions(
        receiveTimeout: const Duration(milliseconds: 15000),
        connectTimeout: const Duration(milliseconds: 15000),
        sendTimeout: const Duration(milliseconds: 15000),
      ),
    );

    dio.interceptors.addAll({
      // LoggerInterceptor(),
      AppInterceptors(),
      // BearerAuthInterceptor(),
      RetryInterceptor(dio: dio, retries: dioConstants.maxRetries),
    });

    return dio;
  }

  Future<Response<T>> head<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.head<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  //  Future<Response> getCached(
  //   String url, {
  //   String? subKey,
  //   Duration duration = const Duration(days: 1),
  //   Map<String, dynamic>? queryParameters,
  //   bool forceRefresh = false,
  //   Options? options,
  // }) async {
  //   options ??= Options();
  //   final resp = await dio.get(
  //     url,
  //     queryParameters: queryParameters,
  //     options: buildCacheOptions(
  //       duration,
  //       subKey: subKey,
  //       options: options.copyWith(sendTimeout: 10000, receiveTimeout: 10000),
  //       forceRefresh: forceRefresh,
  //       maxStale: const Duration(days: 30),
  //     ),
  //   );
  //   return resp;
  // }


  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.delete<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      data: data,
    );
  }

  Future<Response<dynamic>> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return dio.download(urlPath, savePath,
        onReceiveProgress: onReceiveProgress);
  }
}
