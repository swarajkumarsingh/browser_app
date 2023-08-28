import 'package:flutter/foundation.dart';
import 'package:screenshot/screenshot.dart';

final screenShotUtils = _ScreenShotUtils();
class _ScreenShotUtils {
    Future<Uint8List?> captureScreenshot(
      ScreenshotController screenshotController) async {
    return await screenshotController.capture(
      delay: const Duration(milliseconds: 10),
    );
  }
    Future<Uint8List?> captureHomeScreenScreenshot(
      ScreenshotController screenshotController) async {
    return await screenshotController.capture(
      delay: const Duration(milliseconds: 1500),
    );
  }
}