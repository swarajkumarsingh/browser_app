import 'package:dio/dio.dart';

import '../../data/remote/remote_response.dart';
import '../../data/repository/webview_repository_impl.dart';

final webviewRepository = WebviewRepositoryImpl();
abstract class WebviewRepository {
  Future<RemoteResponse<Response>> getUrlData({required String url});

  Future<RemoteResponse<String>> getUrlSize({required String url});

  Future<RemoteResponse<List<String>>> getSuggestions({required String keyword});
}
