import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/widgets/toast.dart';
import '../../core/event_tracker/event_tracker.dart';
import '../../data/db/history_db.dart';
import '../../utils/functions/functions.dart';
import '../../utils/share_app.dart';

final historyViewModel = _HistoryViewModel();

class _HistoryViewModel {
  Future<void> logScreen() async {
    await eventTracker.screen("history-screen");
  }

  Future<int> deleteAll() async {
    return await historyDB.deleteAll();
  }

  Future<void> deleteTodayHistory() async {
    await historyDB.deleteTodayHistory();
  }

  Future<void> deleteHistory(int key) async {
    await historyDB.deleteHistory(key);
    showToast("History Deleted");
  }

  Future<void> shareUrl(String url) async {
    final result = await shareUtils.shareUrl(url);
    if (!result) {
      showToast("Failed to share");
    }
  }

  void navigateToWebviewScreen(WidgetRef ref, BuildContext context, String url) {
    functions.navigateToWebviewScreen(
      ref: ref,
      url: url,
      mounted: true,
    );
  }
}
