import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/models/history_model.dart';
import '../../utils/hive/hive_constants.dart';

final searchDB = _SearchDB();

class _SearchDB {
  Future<void> addHistory(
      {required url, required query, required DateTime time}) async {
    final _shoppingBox = Hive.box(hiveConstants.historyBox);
    await _shoppingBox.add(
      HistoryModel(url: url, prompt: query, time: DateTime.now()).toMap(),
    );
  }
}
