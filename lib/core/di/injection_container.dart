import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/preferences/preferences_service.dart';
import '../../utils/preferences/preferences_service_impl.dart';

final getIt = GetIt.instance;
class DependencyInjection {
  static Future<void> setup() async {
    // Register SharedPreferences dependency
    getIt.registerLazySingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance(),
    );
    await getIt.isReady<SharedPreferences>(); // Add this line
    getIt.registerLazySingleton<PreferencesService>(
      () => PreferencesServiceImpl(
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );

    // Other dependencies can be registered here
    // getIt.registerSingleton<YourServiceClass>(YourServiceClass());
  }
}
