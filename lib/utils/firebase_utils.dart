import 'package:firebase_core/firebase_core.dart';

import '../core/config/firebase_options.dart';

final firebaseUtils = _FirebaseUtils();
class _FirebaseUtils {
  Future<void> initializeApp() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}
