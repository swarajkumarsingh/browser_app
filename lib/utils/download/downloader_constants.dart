import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:path_provider/path_provider.dart';

final downloaderConstants = _DownloaderConstants();

class _DownloaderConstants {
  Future<String> getDownloadDir() async {
    return (await prepareSaveDir()) ?? "/storage/emulated/0/Download";
  }

  Future<String?> prepareSaveDir() async {
    final _localPath = (await getSavedDir());
    final savedDir = Directory(_localPath ?? "/storage/emulated/0/Download");
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
    return _localPath;
  }

  Future<String?> getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (err, st) {
        logger.error('failed to get downloads path: $err, $st');

        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }
}
