import 'package:browser_app/core/common/widgets/toast.dart';
import 'package:browser_app/data/db/downloader_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/event_tracker/event_tracker.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/files.dart';

final downloadViewModel = _DownloadViewModel();

class _DownloadViewModel {
  int maxDeleteReties = 0;

  Future<void> logScreen() async {
    await eventTracker.screen("download-screen");
  }

  int downloadListLength(WidgetRef ref) {
    final downloadedFiles = ref.watch(downloadedFileProvider);
    return downloadedFiles.isEmpty ? 0 : downloadedFiles.length;
  }

  Future<void> deleteFile(int key, String path) async {
    final model = await filesUtils.deleteFile(path);
    if (!model.success) {
      showToast(model.message);
      return;
    }

    // remove from local
    final success = await downloaderDB.deleteSingleDownloadInfoToDB(key);
    if (!success) {
      maxDeleteReties = maxDeleteReties + 1;

      if (maxDeleteReties <= 3) {
        return;
      }
      await downloaderDB.deleteSingleDownloadInfoToDB(key);
    }

    showToast(model.message);
  }
}
