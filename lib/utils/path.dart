import 'package:path_provider/path_provider.dart';

final path = _Path();

class _Path {
  Future<String> getApplicationCacheDirectoryPath() async {
    final res = await getApplicationCacheDirectory();
    return res.path;
  }

  Future<String> getApplicationDocumentsDirectoryPath() async {
    final res = await getApplicationDocumentsDirectory();
    return res.path;
  }

  Future<String> getApplicationSupportDirectoryPath() async {
    final res = await getApplicationSupportDirectory();
    return res.path;
  }

  Future<String?> getDownloadsDirectoryPath() async {
    final res = await getDownloadsDirectory();
    return res!.path;
  }

  Future<String?> getExternalStorageDirectoryPath() async {
    final res = await getExternalStorageDirectory();
    return res!.path;
  }

  Future<String> getLibraryDirectoryPath() async {
    final res = await getLibraryDirectory();
    return res.path;
  }

  Future<String> getTemporaryDirectoryPath() async {
    final res = await getTemporaryDirectory();
    return res.path;
  }
}
