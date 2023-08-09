import 'package:flutter_logger_plus/flutter_logger_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_service.dart';

class PreferencesServiceImpl implements PreferencesService {
  final SharedPreferences sharedPreferences;

  PreferencesServiceImpl({required this.sharedPreferences});

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
  Future setString({required String key, required String value}) {
    logger.info("setString: key = $key, value = $value");
    return sharedPreferences.setString(key, value);
  }

  @override
  bool getBool({required String key, required bool defaultValue}) {
    logger.info("getBool: key = $key, defaultValue = $defaultValue");
    return sharedPreferences.getBool(key) ?? defaultValue;
  }

  @override
  int getInt({required String key, required int defaultValue}) {
    logger.info("getInt: key = $key, defaultValue = $defaultValue");
    return sharedPreferences.getInt(key) ?? defaultValue;
  }

  @override
  String getString({required String key, required String defaultValue}) {
    logger.info("getString: key = $key, defaultValue = $defaultValue");
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  @override
  bool containsKey(String key) {
    logger.info("containsKey: key = $key");
    return sharedPreferences.containsKey(key);
  }
}
