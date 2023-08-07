import 'package:dio/dio.dart';

import '../common/snackbar/show_snackbar.dart';

final dioErrorUtil = _DioErrorUtil();

class _DioErrorUtil {
  // general methods:------------------------------------------------------------
  static String _handleError(DioException error) {
    String errorDescription = "";
    switch (error.type) {
      case DioExceptionType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioExceptionType.connectionError:
        errorDescription =
            "Connection to API server failed due to internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        errorDescription =
            "Received invalid status code: ${error.response?.statusCode}";
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
      default:
        errorDescription = "Unexpected error occurred";
    }
    return errorDescription;
  }

  void handleError(DioException error) {
    final String errorMessage = _handleError(error);
    showSnackBar(errorMessage);
  }
}
