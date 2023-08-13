import 'dart:io';
import 'dart:async';

import 'utils/orientation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'my_app.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart';
import 'core/constants/http_override.dart';
import 'core/error_tracker/error_tracker.dart';

Future<void> main() async => _init();

Future<void> _init() async {
  HttpOverrides.global = MyHttpOverrides();
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize dependency injection
    await DependencyInjection.setup();

    // init firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // add error observers & handle them
    await errorTracker.handleError();

    await FlutterDisplayMode.setHighRefreshRate();

    // added PreferredOrientations
    await setPreferredOrientations();

    runApp(const AppWrapper());
  }, errorTracker.captureError);
}
