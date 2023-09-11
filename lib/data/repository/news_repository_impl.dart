import '../data_source/offline/news_offline_data_source.dart';
import '../data_source/online/news_online_data_source.dart';
import '../../domain/models/news_model.dart';
import '../../domain/repository/news_repository.dart';

import '../../utils/network/network.dart';
import '../remote/remote_response.dart';

class NewsRepositoryImpl extends NewsRepository {
  @override
  Future<RemoteResponse<News>> getNewsUrl() async {
    if (!await isNetworkAvailable) {
      return NewsOfflineDataSource.getNewsData();
    }
    return await NewsOnlineDataSource.getNewsData();
  }
}
