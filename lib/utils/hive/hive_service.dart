import 'package:hive_flutter/hive_flutter.dart';

import 'hive_service_impl.dart';

final hiveService = HiveServiceImpl();
abstract class HiveService {
  Future<void> init();
  bool isBoxEmpty(Box<dynamic> box);

  int getBoxLength(Box<dynamic> box);

  int getBoxLengthFromName(String boxName);
}