import '../data_source/offline/webview_offline_data_source.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/webview_repository.dart';
import '../../utils/network/network.dart';
import '../data_source/online/webview_data_source.dart';
import '../remote/remote_response.dart';

class WebviewRepositoryImpl extends WebviewRepository {
  @override
  Future<RemoteResponse<Response>> getUrlData({required String url}) async {
    if (!await isNetworkAvailable) {
      return RemoteResponse.internetConnectionError();
    }
    return await WebviewOnlineDataSource().getUrlData(url: url);
  }

  @override
  Future<RemoteResponse<String>> getUrlSize({required String url}) async {
    if (!await isNetworkAvailable) {
      return RemoteResponse.internetConnectionError();
    }
    return await WebviewOnlineDataSource().getUrlSize(url: url);
  }

  @override
  Future<RemoteResponse<List<String>>> getSuggestions(
      {required String keyword}) async {
    if (!await isNetworkAvailable) {
      return WebviewOfflineDataSource().getSuggestions(keyword: keyword);
    }
    return await WebviewOnlineDataSource().getSuggestions(keyword: keyword);
  }
}
