import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';
import '../../domain/models/history_model.dart';
import '../../utils/date/date_time_util.dart';

final historyDB = _HistoryDB();

class _HistoryDB {
  Future<void> addHistory(
      {required url, required query}) async {
    final _shoppingBox = Hive.box(Constants.HISTORY_BOX);
    await _shoppingBox.add(
      HistoryModel(url: url, prompt: query, time: DateTime.now()).toMap(),
    );
  }

  Future<int> deleteAll() async {
    final historyBox = Hive.box(Constants.HISTORY_BOX);
    return await historyBox.clear();
  }

  Future<void> deleteTodayHistory() async {
    final historyBox = Hive.box(Constants.HISTORY_BOX);
    for (final key in historyBox.keys) {
      final item = historyBox.get(key);
      final homeModel = HistoryModel.fromJson(item);
      if (homeModel.time.isToday) {
        await historyBox.delete(key);
      }
    }
  }

  Future<void> deleteHistory(int key) async {
    final historyBox = Hive.box(Constants.HISTORY_BOX);
    await historyBox.delete(key);
  }
}
