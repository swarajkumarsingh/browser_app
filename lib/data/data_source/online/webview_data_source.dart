import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;

import '../../../utils/text_utils.dart';
import '../../service/api_service.dart';
import '../../remote/remote_response.dart';
import '../../../utils/browser/browser_utils.dart';

class WebviewOnlineDataSource {
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

  Future<RemoteResponse<List<String>>> getSuggestions(
      {required String keyword}) async {
    try {
      final response = await apiService.getSuggestions(keyword);
      if (response.statusCode != 200) {
        return RemoteResponse.somethingWentWrong();
      }

      final responseBody = response.data;
      final xmlDocument = xml.XmlDocument.parse(responseBody);
      final suggestionsXml = xmlDocument.findAllElements('suggestion');
      final suggestions = suggestionsXml
          .map((element) => element.getAttribute('data') ?? '')
          .toList();

      return RemoteResponse.success(suggestions);
    } catch (e) {
      return RemoteResponse.somethingWentWrong();
    }
  }
}
