import 'dart:io';

import 'package:browser_app/domain/models/delete_file_model.dart';

final filesUtils = _FilesUtils();

class _FilesUtils {
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
