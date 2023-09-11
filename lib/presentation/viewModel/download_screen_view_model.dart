import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/widgets/toast.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/db/downloader_db.dart';
import '../../data/provider/state_providers.dart';
import '../../utils/download/downloader.dart';
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

  Future<void> cancelDownload(String taskId) async {
    final success = await downloader.cancelTask(taskId);
    if (!success) {
      showToast("unable to cancel download");
    }
    await downloaderDB.removeFromDownloading(taskId);
    showToast("download canceled");
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
