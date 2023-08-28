import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/injection_container.dart';

final preferencesService = getIt<PreferencesService>();

abstract class PreferencesService {
  int getInt({required String key, required int defaultValue});

  bool containsKey(String key);

  bool getBool({required String key, required bool defaultValue});

  double getDouble({required String key, required double defaultValue});

  String getString({required String key, required String defaultValue});

  List<String> getStringValue(
      {required String key, required List<String> defaultValue});

  Future setStringList({required String key, required List<String> value});

  Future<bool> remove({required String key});

  Future<bool> clear();

  Future<void> reload();

  Future<SharedPreferences> provideSharedPreferences();

  Future setInt({required String key, required int value});

  Future setBool({required String key, required bool value});

  Future setString({required String key, required String value});

  Future setDouble({required String key, required double value});
}
