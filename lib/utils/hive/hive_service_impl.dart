import 'package:hive_flutter/hive_flutter.dart';

import 'hive_constants.dart';
import 'hive_service.dart';

class HiveServiceImpl extends HiveService {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(hiveConstants.historyBox);
  }

  @override
  bool isBoxEmpty(Box box) {
    return box.keys.isEmpty;
  }
}
