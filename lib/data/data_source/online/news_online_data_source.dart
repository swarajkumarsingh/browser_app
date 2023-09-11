import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import '../../db/home_db.dart';
import '../../service/api_service.dart';
import '../../remote/remote_response.dart';
import '../../../core/constants/constants.dart';
import '../../../domain/models/news_model.dart';
import '../../../core/constants/status_code.dart';
import '../../../core/event_tracker/event_tracker.dart';

class NewsOnlineDataSource {
  static Future<RemoteResponse<News>> getNewsData() async {
    final Trace customTrace = eventTracker.startTrace("news-fetch-event");
    try {
      await customTrace.start();

      final response = await apiService.getNewsData(newsApiUrl);
      customTrace.setMetric("fetched-api-results", 1);

      if (response.statusCode != STATUS_OK) {
        await customTrace.stop();
        return RemoteResponse.somethingWentWrong();
      }

      final news = News.fromJson(response.data);
      await homeDB.saveNews(news);
      await customTrace.stop();
      return RemoteResponse.success(news);
    } catch (e) {
      logger.error("e: $e");
      await customTrace.stop();
      return RemoteResponse.somethingWentWrong();
    }
  }
}
