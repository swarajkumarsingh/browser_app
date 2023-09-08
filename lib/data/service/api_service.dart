import 'package:dio/dio.dart';

import '../../core/dio/api.dart';
import 'api_services_impl.dart';

final ApiService apiService = ApiServiceImpl(Api());
abstract class ApiService {
  Future<Response> getHomeData();
  Future<Response> getImageHead(String url);
  Future<Response> getSuggestions(String keyword);
  Future<Response> getNewsData(String url);
}
