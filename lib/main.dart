import 'dart:io';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

import 'my_app.dart';
import 'utils/orientation.dart';
import 'core/di/injection_container.dart';
import 'core/config/firebase_options.dart';
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

    // Permission request
    // await permissionHandler.storage();
    await Permission.storage.request();

    await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);

    // Set high re-fresh rate (android only)
    await FlutterDisplayMode.setHighRefreshRate();

    // added PreferredOrientations
    await setPreferredOrientations();

    runApp(const AppWrapper());
  }, errorTracker.captureError);
}
