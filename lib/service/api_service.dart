import 'package:dio/dio.dart';

import '../dio/api.dart';
import 'api_services_impl.dart';

final ApiService apiService = ApiServiceImpl(Api());
abstract class ApiService {
  Future<Response> getHomeData();
}
