import 'package:dio/dio.dart';

import '../../domain/repository/webview_repository.dart';
import '../../utils/network/network.dart';
import '../data_source/online/webview_data_source.dart';
import '../remote/remote_response.dart';

class WebviewRepositoryImpl extends WebviewRepository {
  final WebviewDataSource _webviewDataSource;
  WebviewRepositoryImpl(this._webviewDataSource);

  @override
  Future<RemoteResponse<Response>> getUrlData({required String url}) async {
    if (!await isNetworkAvailable) {
      return RemoteResponse.internetConnectionError();
    }
    return await _webviewDataSource.getUrlData(url: url);
  }
  
  @override
  Future<RemoteResponse<String>> getUrlSize({required String url}) async {
       if (!await isNetworkAvailable) {
      return RemoteResponse.internetConnectionError();
    }
    return await _webviewDataSource.getUrlSize(url: url);
  }
}
