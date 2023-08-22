import 'package:browser_app/core/dio/api.dart';
import 'package:browser_app/utils/text_utils.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:dio/dio.dart';

import '../../../domain/models/webview/url_data_model.dart';
import '../../../utils/browser/browser_utils.dart';
import '../../remote/remote_response.dart';

class WebviewDataSource {
  Future<RemoteResponse<UrlData>> getUrlData({required String url}) async {
    RemoteResponse<UrlData> remoteResponse;
    try {
      if (textUtils.isNotValidUrl(url)) {
        remoteResponse = RemoteResponse.somethingWentWrong();
      }

      final response = await Api().head(url);

      logger.error(response.headers[Headers.contentTypeHeader]![0]);
      logger.error(response.headers[Headers.contentLengthHeader]![0]);

      final contentType = response.headers[Headers.contentTypeHeader]![0]
          .replaceAll("image/", "");

      final String size = browserUtils
          .getImageSizeInMB(response.headers[Headers.contentLengthHeader]![0]);

      remoteResponse = RemoteResponse.success(
        UrlData(
          success: true,
          url: url,
          size: size,
          contentType: contentType,
        ),
      );
    } catch (e) {
      remoteResponse = RemoteResponse.somethingWentWrong();
    }
    return remoteResponse;
  }
}
