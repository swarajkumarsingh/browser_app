import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../core/event_tracker/event_tracker.dart';

final shareUtils = _ShareUtils();
class _ShareUtils {
  Future<bool> shareUrl(String url) async {
    try {
      final result = await Share.shareWithResult(url);

      if (result.status == ShareResultStatus.success ||
          result.status == ShareResultStatus.dismissed) {
        await eventTracker.logShare(aParams: {
          "success": true,
          "url": url,
        });
        return true;
      }

      await eventTracker.logShare(aParams: {
        "success": false,
        "url": url,
      });

      return false;
    } catch (e) {
      logger.error("Share Error: $e");
      return false;
    }
  }
}
