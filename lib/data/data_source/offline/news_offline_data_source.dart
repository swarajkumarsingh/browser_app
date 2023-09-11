import '../../db/home_db.dart';
import '../../../domain/models/news_model.dart';

import '../../remote/remote_response.dart';

class NewsOfflineDataSource {
  static RemoteResponse<News> getNewsData() {
    final model = homeDB.getNews();
    if (model == null) {
      return RemoteResponse.somethingWentWrong();
    }
    return RemoteResponse.success(model);
  }
}
