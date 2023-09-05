import 'package:browser_app/domain/models/webview_model.dart';
import 'package:browser_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/provider/state_providers.dart';
import '../../utils/functions/functions.dart';

final tabViewModel = _TabViewModel();

class _TabViewModel {
  Future<void> addTab({
    required WidgetRef ref,
    required String url,
    required String title,
    required Uint8List? screenshot,
    WebViewController? webViewController,
  }) async {
    functions.removeNavigateToWebviewScreen(
      ref: ref,
      url: url,
      mounted: true,
    );

    final list = ref.read(tabsListProvider);
    final webViewModel = WebViewModel(
        url: url,
        id: utils.getRandomTabId(),
        title: title,
        isIncognitoMode: false,
        screenshot: screenshot);
    ref
        .read(tabsListProvider.notifier)
        .update((state) => [...list, webViewModel]);

    // TODO add to DB
  }

  Future<void> deleteTab(WidgetRef ref, String id) async {
    final tabsList = ref.watch(tabsListProvider);
    final indexToRemove = tabsList.indexWhere((tab) => tab.id == id);

    if (indexToRemove == -1) return;

    tabsList.removeAt(indexToRemove);
    ref.read(tabsListProvider.notifier).update((state) => [...tabsList]);
    // TODO delete from DB
  }

  Future<void> updateScreenShot(
      WidgetRef ref, String id, Uint8List imageBytes) async {
    final tabsList = ref.watch(tabsListProvider);

    final index = tabsList.indexWhere((tab) => tab.id == id);

    if (index == -1) return;

    // tabsList[index]
  }
}
