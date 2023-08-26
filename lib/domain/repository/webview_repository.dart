import 'package:dio/dio.dart';

import '../../data/data_source/online/webview_data_source.dart';
import '../../data/remote/remote_response.dart';
import '../../data/repository/webview_repository_impl.dart';

final webviewRepository = WebviewRepositoryImpl(WebviewDataSource());

abstract class WebviewRepository {
  Future<RemoteResponse<Response>> getUrlData({required String url});
}
