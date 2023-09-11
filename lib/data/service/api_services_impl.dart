import 'package:dio/dio.dart';

import '../../core/config/config.dart';
import '../../core/dio/api.dart';
import '../../utils/text_utils.dart';
import 'api_service.dart';

class ApiServiceImpl extends ApiService {
  final Api _api;
  ApiServiceImpl(this._api);

  @override
  Future<Response> getHomeData() async => _api.get(Config.baseUrl);
  
  @override
  Future<Response> getImageHead(String url) async => _api.head(url);
  
  @override
  Future<Response> getSuggestions(String keyword) async => _api.get(textUtils.addGoogleSuggestionWithKeyword(keyword), options: Options(contentType: "text/xml"));
  
  @override
  Future<Response> getNewsData(String url) async => _api.get(url);
}