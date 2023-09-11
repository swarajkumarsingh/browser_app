import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';
import '../../domain/models/news_model.dart';

final homeDB = _HomeDB();

class _HomeDB {
  Future<bool> saveNews(News news) async {
    final box = Hive.box(Constants.NEWS_BOX);

    if (!box.isOpen) {
      return false;
    }

    await box.clear();
    await box.add(news.toJson());
    return true;
  }

  News? getNews() {
    final box = Hive.box(Constants.NEWS_BOX);
    box.keys.map((key) {
      final item = box.get(key);
      final model = News.fromJson(item);
      return model;
    });
    return null;
  }
}
