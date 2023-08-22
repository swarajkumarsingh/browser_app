import 'package:browser_app/domain/repository/webview_repository.dart';

import '../../domain/models/webview/url_data_model.dart';
import '../../utils/network/network.dart';
import '../data_source/online/webview_data_source.dart';
import '../remote/remote_response.dart';

class WebviewRepositoryImpl extends WebviewRepository {
  final WebviewDataSource _webviewDataSource;
  WebviewRepositoryImpl(this._webviewDataSource);

  @override
  Future<RemoteResponse<UrlData>> getUrlData({required String url}) async {
    if (!await isNetworkAvailable) {
      return RemoteResponse.internetConnectionError();
    }
    return await _webviewDataSource.getUrlData(url: url);
  }
}
