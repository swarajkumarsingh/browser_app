import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/common/widgets/toast.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/db/downloader_db.dart';
import '../../data/db/webview_db.dart';
import '../../domain/models/download_model.dart';
import '../../domain/models/download_save_model.dart';
import '../../domain/models/downloading_model.dart';
import '../permission_utils.dart';
import '../text_utils.dart';
import 'downloader_constants.dart';
import 'downloader_utils.dart';

final downloader = Downloader();

class Downloader {
  Future<void> init() async {
    await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
  }

  Future<DownloadModel> downloadFile({
    int? timeout,
    String? savedDir,
    String? fileName,
    bool? allowCellular,
    required String url,
    bool? showNotification,
    bool? saveInPublicStorage,
    bool? requiresStorageNotLow,
    Map<String, String>? headers,
    bool? openFileFromNotification,
    required String imageContentType,
  }) async {
    try {
      if (!FlutterDownloader.initialized) {
        return DownloadModel(
          url: url,
          success: false,
          message: "FlutterDownloader not initialized",
          taskId: null,
        );
      }

      if (await Permission.storage.request().isDenied) {
        await permissionHandler.storage();
        return DownloadModel(
          url: url,
          success: false,
          message: "Storage permission not granted",
          taskId: null,
        );
      }

      if (await Permission.storage.request().isPermanentlyDenied) {
        return DownloadModel(
          url: url,
          success: false,
          message: "Open settings to grant storage permission",
          taskId: null,
        );
      }

      Timer? _timer;
      final randomImageName = downloaderUtils.generateRandomImageName();
      final downloadsDir = await downloaderConstants.getDownloadDir();
      final fileLocation = "$downloadsDir/$fileName.$imageContentType";

      if (await doesFileExist(fileLocation)) {
        fileName = "$fileName$randomImageName";
      }

      final savedDir = (await downloaderConstants.getDownloadDir());
      final newFileName = textUtils.isEmpty(fileName)
          ? "$randomImageName.$imageContentType"
          : "$fileName.$imageContentType";

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir,
        headers: headers ?? {},
        fileName: newFileName,
        saveInPublicStorage: true,
        timeout: timeout ?? 15000,
        allowCellular: allowCellular ?? true,
        showNotification: showNotification ?? true,
        requiresStorageNotLow: requiresStorageNotLow ?? true,
        openFileFromNotification: openFileFromNotification ?? true,
      );

      await eventTracker.log("downloads_start", {
        "taskId": taskId,
        "url": url,
      });

      await webviewDB.incrBrowserDownloadFile();

      // Check every second if the download is completed
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final task = await downloader.loadTasksWithRawQuery(
            "SELECT * FROM task WHERE task_id = '$taskId'");

        switch (task![0].status) {
          case DownloadTaskStatus.running:
            final model = DownloadingModel(
              filename: newFileName,
              size: null,
              url: url,
              taskId: task[0].taskId,
              progress: task[0].progress,
            );
            logger.info(
              "${model.taskId}: ${model.progress}",
            );
            await downloaderDB.updateDownloading(model);
            break;
          case DownloadTaskStatus.complete:
            _timer!.cancel();
            final downloadSaveModel = DownloadSaveModel(
              filename: newFileName,
              size: null,
              type: imageContentType,
              savedPath: "$savedDir/$newFileName",
            );

            await downloaderDB.removeFromDownloading(task[0].taskId);
            await downloaderDB.addSingleDownloadInfoToDB(downloadSaveModel);
            showToast("Download completed");
            break;

          case DownloadTaskStatus.failed:
            await downloaderDB.removeFromDownloading(task[0].taskId);
            _timer!.cancel();
            showToast("Download failed");
            break;
          default:
            null;
        }
      });

      return DownloadModel(
        url: url,
        message: "File start downloading",
        taskId: taskId.toString(),
        success: true,
      );
    } catch (e) {
      logger.error(e);
      return DownloadModel(
          url: url, success: false, message: e.toString(), taskId: null);
    }
  }

  Future<bool> doesFileExist(String filePath) async {
    final File file = File(filePath);
    return await file.exists();
  }

  Future<List<DownloadTask>?> loadTasks() async {
    try {
      return await FlutterDownloader.loadTasks();
    } catch (e) {
      return null;
    }
  }

  Future<bool> openFile(String taskId) async {
    try {
      return await FlutterDownloader.open(taskId: taskId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> cancelTask(String taskId) async {
    try {
      await FlutterDownloader.cancel(taskId: taskId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> pauseTask(String taskId) async {
    try {
      await FlutterDownloader.pause(taskId: taskId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resumeTask(String taskId) async {
    try {
      await FlutterDownloader.resume(taskId: taskId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> retryTask(String taskId) async {
    try {
      await FlutterDownloader.retry(taskId: taskId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeTask(String taskId, {bool? shouldDeleteContent}) async {
    try {
      await FlutterDownloader.remove(
          taskId: taskId, shouldDeleteContent: shouldDeleteContent ?? false);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cancelAll() async {
    try {
      await FlutterDownloader.cancelAll();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<DownloadTask>?> loadTasksWithRawQuery(String query) async {
    try {
      return await FlutterDownloader.loadTasksWithRawQuery(query: query);
    } catch (e) {
      return null;
    }
  }
}
