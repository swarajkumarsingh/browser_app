import '../models/news_model.dart';

import '../../data/remote/remote_response.dart';
import '../../data/repository/home_repository_impl.dart';
import '../models/home.dart';

final HomeRepository homeRepository = HomeRepositoryImpl();

abstract class HomeRepository {
  Future<RemoteResponse<Home>> getHomeData();
  Future<RemoteResponse<News>> getNewsData(String url);
}
