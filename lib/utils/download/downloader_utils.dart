import 'dart:io';
import 'dart:math';

final downloaderUtils = _DownloaderUtils();

class _DownloaderUtils {
  String generateRandomImageName() {
    final random = Random();
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final String randomString = String.fromCharCodes(Iterable.generate(
        10, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    return 'browser_$randomString';
  }

  bool checkIfFileExistsWithExtensions(
      {required String directoryPath,
      required String fileName,
      required List<String> extensions}) {
    final bool exists =
        _fileExistsWithExtensions(directoryPath, fileName, extensions);

    if (exists) {
      return true;
    } else {
      return false;
    }
  }

  bool _fileExistsWithExtensions(
      String directoryPath, String fileName, List<String> extensions) {
    for (final extension in extensions) {
      final File file = File('$directoryPath/$fileName$extension');
      if (file.existsSync()) {
        return true;
      }
    }
    return false;
  }
}
