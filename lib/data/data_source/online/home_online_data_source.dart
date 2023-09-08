import '../../db/home_db.dart';
import '../../../domain/models/news_model.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import '../../../core/constants/status_code.dart';
import '../../../core/event_tracker/event_tracker.dart';
import '../../../domain/models/home.dart';
import '../../../utils/text_utils.dart';
import '../../remote/remote_response.dart';
import '../../service/api_service.dart';

class HomeOnlineDataSource {
  Future<RemoteResponse<Home>> getHomeData() async {
    RemoteResponse<Home> remoteResponse;
    try {
      final Trace customTrace = eventTracker.startTrace("simu-event");
      await customTrace.start();

      final response = await apiService.getHomeData();
      customTrace.setMetric("fetched-api", 1);

      if (response.statusCode != STATUS_OK ||
          textUtils.isEmpty(response.data) ||
          response.data == null) {
        return RemoteResponse.somethingWentWrong();
      }

      final home = Home.fromJson(response.data[0]);
      remoteResponse = RemoteResponse.success(home);
      await customTrace.stop();
      logger.info("Reported log");
    } catch (e) {
      remoteResponse = RemoteResponse.somethingWentWrong();
      logger.error(e);
    }

    return remoteResponse;
  }

  Future<RemoteResponse<News>> getNewsData(String url) async {
    final Trace customTrace = eventTracker.startTrace("news-fetch-event");
    try {
      await customTrace.start();

      final response = await apiService.getNewsData(url);
      customTrace.setMetric("fetched-api-results", 1);

      if (response.statusCode != STATUS_OK ||
          textUtils.isEmpty(response.data) ||
          response.data == null) {
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
