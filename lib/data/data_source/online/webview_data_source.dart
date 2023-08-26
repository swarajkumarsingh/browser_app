import '../../service/api_service.dart';

import '../../../utils/text_utils.dart';
import 'package:dio/dio.dart';

import '../../remote/remote_response.dart';

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
}
