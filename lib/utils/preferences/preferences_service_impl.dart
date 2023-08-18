import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_service.dart';

class PreferencesServiceImpl implements PreferencesService {
  final SharedPreferences sharedPreferences;

  PreferencesServiceImpl({required this.sharedPreferences});

  @override
  bool containsKey(String key) {
    logger.info("containsKey: key = $key");
    return sharedPreferences.containsKey(key);
  }

  @override
  Future<bool> clear() async {
    return sharedPreferences.clear();
  }

  @override
  Future<void> reload() async {
    return sharedPreferences.reload();
  }

  @override
  Future<bool> remove({required String key}) async {
    return sharedPreferences.remove(key);
  }

  @override
  Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  @override
  Future setBool({required String key, required bool value}) {
    logger.info("setBool: key = $key, value = $value");
    return sharedPreferences.setBool(key, value);
  }

  @override
  Future setInt({required String key, required int value}) {
    logger.info("setInt: key = $key, value = $value");
    return sharedPreferences.setInt(key, value);
  }

  @override
  Future setDouble({required String key, required double value}) {
    logger.info("setInt: key = $key, value = $value");
    return sharedPreferences.setDouble(key, value);
  }

  @override
  Future setString({required String key, required String value}) {
    logger.info("setString: key = $key, value = $value");
    return sharedPreferences.setString(key, value);
  }

  @override
  Future setStringList({required String key, required List<String> value}) {
    logger.info("setString: key = $key, value = $value");
    return sharedPreferences.setStringList(key, value);
  }

  @override
  bool getBool({required String key, required bool defaultValue}) {
    logger.info("getBool: key = $key, defaultValue = $defaultValue");
    return sharedPreferences.getBool(key) ?? defaultValue;
  }

  @override
  int getInt({required String key, required int defaultValue}) {
    final res = sharedPreferences.getInt(key) ?? defaultValue;
    logger.info("getInt: key = $key, value = $res");
    return res;
  }

  @override
  double getDouble({required String key, required double defaultValue}) {
    logger.info("getInt: key = $key, defaultValue = $defaultValue");
    return sharedPreferences.getDouble(key) ?? defaultValue;
  }

  @override
  String getString({required String key, required String defaultValue}) {
    logger.info("getString: key = $key, defaultValue = $defaultValue");
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  @override
  List<String> getStringValue(
      {required String key, required List<String> defaultValue}) {
    logger.info("getString: key = $key, defaultValue = $defaultValue");
    return sharedPreferences.getStringList(key) ?? defaultValue;
  }
}
