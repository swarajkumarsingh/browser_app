import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/models/delete_file_model.dart';
import 'download/downloader_utils.dart';

final filesUtils = _FilesUtils();

class _FilesUtils {
  String randomId() {
    return downloaderUtils.generateRandomImageName();
  }

  /// 将 base64 转换为图片，存储到临时文件
  Future<String> writeImageFromBase64(String base64, String ext) async {
    final directory = await getApplicationDocumentsDirectory();
    // 确保目录存在
    await Directory('${directory.path}/cache').create(recursive: true);

    final file = File('${directory.path}/cache/temp_${randomId()}.$ext');
    await file.writeAsBytes(base64Decode(base64));
    return file.path.substring(directory.path.length + 1);
  }

  String filenameWithoutExt(String filePath) {
    final int slashIndex = filePath.lastIndexOf('/');
    final int dotIndex = filePath.lastIndexOf('.');
    if (dotIndex < 0 || dotIndex < slashIndex) {
      return filePath.substring(slashIndex + 1);
    } else {
      return filePath.substring(slashIndex + 1, dotIndex);
    }
  }

  Future<File> writeTempFile(String path, Uint8List bytes) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$path');
    return await file.writeAsBytes(bytes);
  }

  Future<Uint8List> readTempFile(String path) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$path');
    return await file.readAsBytes();
  }

  Future<void> writeStringFileToDocumentsDirectory(
      String path, String content) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$path');
      logger.info('${directory.path}/$path');
      await file.writeAsString(content);
    } catch (e) {
      logger.info('写入文件失败: $e');
    }
  }

  Future<String> readStringFileFromDocumentsDirectory(String path) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$path');
      return await file.readAsString();
    } catch (e) {
      return '';
    }
  }

  Future<void> removeExternalFile(String externalFilepath) async {
    // Get the external file
    final File externalFile = File(externalFilepath);

    // Check if the external file exists
    if (!await externalFile.exists()) {
      return;
    }

    await externalFile.delete();
  }

  Future<String> copyExternalFileToAppDocs(String externalFilePath) async {
    // Get the external file
    final File externalFile = File(externalFilePath);

    // Check if the external file exists
    if (!await externalFile.exists()) {
      throw Exception('External file not found at: $externalFilePath');
    }

    // Get the ApplicationDocumentsDirectory
    final Directory appDocsDir = await getApplicationDocumentsDirectory();

    // Generate a UUID for the new file name
    final String uuid = downloaderUtils.generateRandomImageName();

    // Get the file extension
    final String fileExtension = externalFile.path.split('.').last;

    // Create a new file in the ApplicationDocumentsDirectory with the UUID as its name
    final File newFile = File('${appDocsDir.path}/$uuid.$fileExtension');

    // Copy the external file to the new file in the ApplicationDocumentsDirectory
    await externalFile.copy(newFile.path);

    // print('File copied to: ${newFile.path}');
    return newFile.path;
  }

  Future<DeleteFileModel> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return DeleteFileModel(success: true, message: "file deleted");
      }
      return DeleteFileModel(success: true, message: "file deleted");
    } catch (e) {
      return DeleteFileModel(success: false, message: "error occurred");
    }
  }
}
