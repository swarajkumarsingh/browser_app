import 'package:dio/dio.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';

import '../../core/constants/constants.dart';
import '../preferences/preferences_service.dart';
import '../text_utils.dart';

class AdBlocker {
  Future<bool> isAd(String url) async {
    final _isAd = _isAdHost(url);
    if (_isAd) {
      await _recalculateAdStat(url);
    }
    return _isAd;
  }

  Future<void> incrementPageVisitedCount() async {
    // Update the Number of Page Visited
    final totalPageVisited = preferencesService.getInt(
        key: Constants.PREF_TOTAL_PAGE_VISITED, defaultValue: 0);
    await preferencesService.setInt(
        key: Constants.PREF_TOTAL_PAGE_VISITED, value: (totalPageVisited + 1));
  }

  Future<void> _recalculateAdStat(String url) async {
    // Incr Ad block count
    final totalAdsBlocked = preferencesService.getInt(
        key: Constants.PREF_TOTAL_ADS_BLOCKED, defaultValue: 0);
    await preferencesService.setInt(
        key: Constants.PREF_TOTAL_ADS_BLOCKED, value: totalAdsBlocked + 1);

    // Update the Size of Data Saved
    // Update the time saved.s
    try {
      final startTime = DateTime.now().second;
      final fileLength = await _getRemoteFileSize(url);
      final endTime = DateTime.now().second;

      // Save the File Size in Bytes.
      final totalAdFileSize = preferencesService.getInt(
          key: Constants.PREF_TOTAL_ADS_SIZE_SAVED, defaultValue: 0);
      await preferencesService.setInt(
          key: Constants.PREF_TOTAL_ADS_SIZE_SAVED,
          value: (totalAdFileSize + fileLength));

      // Save the Seconds Saved.
      final totalAdTimeSaved = preferencesService.getInt(
          key: Constants.PREF_TOTAL_ADS_TIME_SAVED, defaultValue: 0);
      await preferencesService.setInt(
        key: Constants.PREF_TOTAL_ADS_TIME_SAVED,
        value: (totalAdTimeSaved + (endTime - startTime)),
      );
    } catch (e) {
      logger.error(e);
    }
  }

  Future<int> _getRemoteFileSize(String url) async {
    try {
      if (!textUtils.isEmpty(url) || textUtils.isValidUrl(url)) {
        return 0;
      }

      final Dio dio = Dio();
      final Response response = await dio.head(url);

      final int contentLength =
          int.parse(response.headers[Headers.contentLengthHeader]![0]);

      return contentLength;
    } catch (e) {
      logger.error(e);
      return 0;
    }
  }

  //   private fun isAdHost(host: String): Boolean {
  //     if (TextUtils.isEmpty(host)) {
  //         return false
  //     }
  //     val index = host.indexOf(".")
  //     return index >= 0 && (AD_HOSTS.contains(host) || index + 1 < host.length && isAdHost(host.substring(index + 1)))
  // }

  bool _isAdHost(String url) {
    if (textUtils.isEmpty(url)) {
      return false;
    }

    final hosts = <String>[];
    for (final host in hosts) {
      if (host == url) {
        return true;
      }
    }
    return false;
  }
}
