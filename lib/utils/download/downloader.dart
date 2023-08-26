import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/download_model.dart';
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
    required String url,
    String? fileName,
    required String imageContentType,
    Map<String, String>? headers,
    String? savedDir,
    bool? showNotification,
    bool? allowCellular,
    bool? requiresStorageNotLow,
    bool? saveInPublicStorage,
    bool? openFileFromNotification,
    int? timeout,
  }) async {
    try {
      if (!FlutterDownloader.initialized) {
        return DownloadModel(
          success: false,
          message: "FlutterDownloader not initialized",
          taskId: null,
        );
      }

      if (await Permission.storage.request().isDenied) {
        await permissionHandler.storage();
        return DownloadModel(
          success: false,
          message: "Storage permission not granted",
          taskId: null,
        );
      }

      if (await Permission.storage.request().isPermanentlyDenied) {
        return DownloadModel(
          success: false,
          message: "Open settings to grant storage permission",
          taskId: null,
        );
      }

      final _randomImageName = downloaderUtils.generateRandomImageName();

      final downloadsDir = await downloaderConstants.getDownloadDir();
      final fileLocation = "$downloadsDir/$fileName.$imageContentType";

      if (await doesFileExist(fileLocation)) {
        fileName = "$fileName$_randomImageName";
      }

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: (await downloaderConstants.getDownloadDir()),
        headers: headers ?? {},
        fileName: textUtils.isEmpty(fileName)
            ? "$_randomImageName.$imageContentType"
            : "$fileName.$imageContentType",
        saveInPublicStorage: true,
        timeout: timeout ?? 15000,
        allowCellular: allowCellular ?? true,
        showNotification: showNotification ?? true,
        requiresStorageNotLow: requiresStorageNotLow ?? true,
        openFileFromNotification: openFileFromNotification ?? true,
      );

      return DownloadModel(
        message: "File start downloading",
        taskId: taskId.toString(),
        success: true,
      );
    } catch (e) {
      logger.error(e);
      return DownloadModel(success: false, message: e.toString(), taskId: null);
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
