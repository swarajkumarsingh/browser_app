import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';
import '../../domain/models/download_save_model.dart';
import '../../domain/models/downloading_model.dart';

final downloaderDB = _DownloaderDB();

class _DownloaderDB {
  Future<void> addDownloadInfoToDB(List<DownloadTask> downloadTasks) async {
    for (final task in downloadTasks) {
      final savedPath = "${task.savedDir}/${task.filename}";
      final downloadSaveModel = DownloadSaveModel(
        filename: task.filename.toString(),
        type: "",
        size: null,
        savedPath: savedPath,
      );

      final box = Hive.box(Constants.DOWNLOAD_SAVE_BOX);
      await box.add(downloadSaveModel.toJson());
    }
  }

  bool checkIfDownloadingModelAlreadyPresent(String taskId) {
    final box = Hive.box(Constants.DOWNLOADING_SAVE_BOX);
    for (final key in box.keys) {
      final model = DownloadingModel.fromJson(box.get(key));
      if (model.taskId == taskId) {
        return true;
      }
    }
    return false;
  }

  Future<bool> updateProgressOnly(String taskId, DownloadingModel model) async {
    try {
      final box = Hive.box(Constants.DOWNLOADING_SAVE_BOX);

      for (final key in box.keys) {
        if (model.taskId == taskId) {
          await box.put(key, model.toJson());
          return true;
        }
      }
      return false;
    } catch (e) {
      logger.error(e);
      return false;
    }
  }

  Future<bool> updateDownloading(DownloadingModel model) async {
    try {
      if (checkIfDownloadingModelAlreadyPresent(model.taskId)) {
        return await updateProgressOnly(model.taskId, model);
      }
      final box = Hive.box(Constants.DOWNLOADING_SAVE_BOX);
      await box.add(model.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromDownloading(String taskId) async {
    try {
      final box = Hive.box(Constants.DOWNLOADING_SAVE_BOX);
      for (final key in box.keys) {
        final model = DownloadingModel.fromJson(box.get(key));
        if (model.taskId == taskId) {
          await box.delete(key);
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  List<DownloadSaveModel> getDownloadInfoToDB() {
    final List<DownloadSaveModel> list = [];
    final box = Hive.box(Constants.DOWNLOAD_SAVE_BOX);

    for (final key in box.keys) {
      final item = box.get(key);
      final model = DownloadSaveModel.fromJson(item);
      list.add(model);
    }

    return list;
  }

  DownloadSaveModel getSingleDownloadInfoToDB(int key) {
    final box = Hive.box(Constants.DOWNLOAD_SAVE_BOX);
    final item = box.get(key);
    return DownloadSaveModel.fromJson(item);
  }

  Future<bool> deleteSingleDownloadInfoToDB(int key) async {
    try {
      final box = Hive.box(Constants.DOWNLOAD_SAVE_BOX);
      await box.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> addSingleDownloadInfoToDB(
      DownloadSaveModel downloadSaveModel) async {
    final box = Hive.box(Constants.DOWNLOAD_SAVE_BOX);
    await box.add(downloadSaveModel.toJson());
  }
}
