import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/constants.dart';
import '../../data/db/webview_db.dart';
import '../../domain/models/webview_model.dart';
import '../../utils/preferences/preferences_service.dart';

final tabViewModel = _TabViewModel();

class _TabViewModel {
  Future<void> addTab({
    required String url,
    required String title,
    required Uint8List? screenshot,
    required int tabIndex,
    WebViewController? webViewController,
  }) async {
    await webviewDB.addTab(
      url: url,
      title: title,
      tabIndex: tabIndex,
      screenshot: screenshot,
      isIncognitoMode: false,
      webViewController: webViewController,
    );

    await preferencesService.setInt(
        key: Constants.CURRENT_TAB_INDEX_BOX, value: tabIndex);
  }

  Future<WebViewModel?> getTab(int tabIndex) async {
    return webviewDB.getTab(tabIndex);
  }

  Future<void> updateTab({
    required String url,
    required String title,
    required Uint8List? screenshot,
    required int tabIndex,
    WebViewController? webViewController,
  }) async {
    await webviewDB.updateTab(
      url: url,
      title: title,
      screenshot: screenshot,
      isIncognitoMode: false,
      tabIndex: tabIndex,
      webViewController: webViewController,
    );
  }
}
