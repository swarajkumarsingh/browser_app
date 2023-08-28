import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/constants.dart';
import '../../domain/models/webview_model.dart';
import '../../utils/preferences/preferences_service.dart';
import '../../utils/screenshot_utils.dart';

final webviewDB = _WebviewDB();

class _WebviewDB {
  Future incrBrowserDownloadFile() async {
    final int value = preferencesService.getInt(
        key: Constants.PRE_BROWSER_FILES_DOWNLOADED, defaultValue: 0);

    await preferencesService.setInt(
        key: Constants.PRE_BROWSER_FILES_DOWNLOADED, value: value + 1);
  }

  Future<void> addHomeScreenScreenShotBytes(
      ScreenshotController screenshotController) async {
    final image =
        await screenShotUtils.captureHomeScreenScreenshot(screenshotController);
    final box = Hive.box(Constants.HOME_IMAGE_BOX);
    await box.add(image);
  }

  Uint8List getHomeScreenImageBytes() {
    final box = Hive.box(Constants.HOME_IMAGE_BOX);
    dynamic item;
    for (final key in box.keys) {
      final _item = box.get(key);
      item = _item;
    }
    return item;
  }

  Future<void> addTab({
    required String url,
    required bool isIncognitoMode,
    required Uint8List? screenshot,
    required String title,
    required int tabIndex,
    WebViewController? webViewController,
  }) async {
    final tabBox = Hive.box(Constants.TABS_BOX);
    await tabBox.add(
      WebViewModel(
        url: url,
        title: title,
        screenshot: screenshot,
        tabIndex: tabIndex,
        isIncognitoMode: isIncognitoMode,
      ).toMap(),
    );
  }

  Future<WebViewModel?> getTab(int tabIndex) async {
    final box = Hive.box(Constants.TABS_BOX);
    for (final key in box.keys) {
      final item = box.get(key);
      final webViewModel = WebViewModel.fromJson(item);
      if (webViewModel.tabIndex == tabIndex) {
        return await box.get(key);
      }
    }
    return null;
  }

  Future<void> updateTab({
    required String url,
    required String title,
    required int tabIndex,
    required bool isIncognitoMode,
    required Uint8List? screenshot,
    WebViewController? webViewController,
  }) async {
    final tabBox = Hive.box(Constants.TABS_BOX);
    for (final key in tabBox.keys) {
      final item = tabBox.get(key);
      final webViewModel = WebViewModel.fromJson(item);
      if (webViewModel.tabIndex == tabIndex) {
        await tabBox.delete(key);
      }
    }

    await addTab(
      url: url,
      isIncognitoMode: isIncognitoMode,
      tabIndex: tabIndex,
      screenshot: screenshot,
      title: title,
    );
  }

  Future<void> deleteTab(int key) async {
    final tabBox = Hive.box(Constants.TABS_BOX);
    await tabBox.delete(key);
  }
}
