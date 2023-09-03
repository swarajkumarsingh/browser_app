import 'package:browser_app/data/db/webview_db.dart';
import 'package:browser_app/domain/models/webview_model.dart';
import 'package:browser_app/utils/preferences/preferences_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../core/constants/constants.dart';

final tabViewModel = _TabViewModel();

class _TabViewModel {
  Future<void> addTab({
    required String url,
    required String title,
    required Uint8List? screenshot,
    required int tabIndex,
    InAppWebViewController? webViewController,
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
    InAppWebViewController? webViewController,
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
