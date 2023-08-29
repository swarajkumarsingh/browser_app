import 'package:browser_app/utils/browser/browser_utils.dart';
import 'package:dio/dio.dart';

import '../../../utils/text_utils.dart';
import '../../remote/remote_response.dart';
import '../../service/api_service.dart';

class WebviewDataSource {
  Future<RemoteResponse<Response>> getUrlData({required String url}) async {
    RemoteResponse<Response> remoteResponse;
    try {
      if (textUtils.isNotValidUrl(url)) {
        remoteResponse = RemoteResponse.somethingWentWrong();
      }

      final response = await apiService.getImageHead(url);
      remoteResponse = RemoteResponse.success(response);
    } catch (e) {
      remoteResponse = RemoteResponse.somethingWentWrong();
    }
    return remoteResponse;
  }

  Future<RemoteResponse<String>> getUrlSize({required String url}) async {
    RemoteResponse<String> remoteResponse;
    try {
      final response = await getUrlData(url: url);
      final size = browserUtils.calculateImageSizeInMB(
          response.data!.headers[Headers.contentLengthHeader]![0]);

      remoteResponse = RemoteResponse.success(size);
    } catch (e) {
      remoteResponse = RemoteResponse.somethingWentWrong();
    }
    return remoteResponse;
  }
}
