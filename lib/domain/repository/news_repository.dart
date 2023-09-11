import '../models/news_model.dart';

import '../../data/remote/remote_response.dart';
import '../../data/repository/news_repository_impl.dart';

final newsRepository = NewsRepositoryImpl();
abstract class NewsRepository {
  Future<RemoteResponse<News>> getNewsUrl();
}
