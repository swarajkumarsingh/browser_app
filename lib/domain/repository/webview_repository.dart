import 'package:browser_app/data/data_source/online/webview_data_source.dart';
import 'package:browser_app/data/repository/webview_repository_impl.dart';

import '../../data/remote/remote_response.dart';
import '../models/webview/url_data_model.dart';

final webviewRepository = WebviewRepositoryImpl(WebviewDataSource());

abstract class WebviewRepository {
  Future<RemoteResponse<UrlData>> getUrlData({required String url});
}
