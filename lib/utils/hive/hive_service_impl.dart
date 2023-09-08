import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';
import 'hive_service.dart';

class HiveServiceImpl extends HiveService {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(Constants.NEWS_BOX);
    await Hive.openBox(Constants.TABS_BOX);
    await Hive.openBox(Constants.HISTORY_BOX);
    await Hive.openBox(Constants.DARK_MODE_BOX);
    await Hive.openBox(Constants.HOME_IMAGE_BOX);
    await Hive.openBox(Constants.CURRENT_TAB_INDEX_BOX);
    await Hive.openBox(Constants.DOWNLOAD_SAVE_BOX);
    await Hive.openBox(Constants.DOWNLOADING_SAVE_BOX);
  }

  @override
  bool isBoxEmpty(Box box) {
    return box.keys.isEmpty;
  }

  @override
  int getBoxLength(Box<dynamic> box) {
    if (box.length == box.keys.length) {
      return box.length;
    }
    return 0;
  }

  @override
  int getBoxLengthFromName(String boxName) {
    final box = Hive.box(boxName);
    return getBoxLength(box);
  }
}
