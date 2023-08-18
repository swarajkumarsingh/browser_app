import 'package:browser_app/utils/text_utils.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import '../../../core/constants/status_code.dart';
import '../../../core/event_tracker/event_tracker.dart';
import '../../../domain/models/home/home.dart';
import '../../service/api_service.dart';
import '../remote_response.dart';

final homeDataSource = HomeDataSource();

class HomeDataSource {
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
}
