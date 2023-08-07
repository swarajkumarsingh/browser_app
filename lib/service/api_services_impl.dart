import 'package:dio/dio.dart';

import '../config.dart';
import '../dio/api.dart';
import 'api_service.dart';

class ApiServiceImpl extends ApiService {
  final Api _api;
  ApiServiceImpl(this._api);

  @override
  Future<Response> getHomeData() async => _api.get(Config.baseUrl);
}