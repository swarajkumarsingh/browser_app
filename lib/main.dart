import 'dart:io';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'my_app.dart';
import 'utils/orientation.dart';
import 'utils/firebase_utils.dart';
import 'utils/hive/hive_service.dart';
import 'utils/download/downloader.dart';
import 'core/di/injection_container.dart';
import 'core/constants/http_override.dart';
import 'core/error_tracker/error_tracker.dart';

Future<void> main() async => _init();

Future<void> _init() async {
  HttpOverrides.global = MyHttpOverrides();
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DependencyInjection.setup();
    await firebaseUtils.initializeApp();
    await errorTracker.handleError();
    await hiveService.init();
    await Permission.storage.request();
    await Permission.microphone.request();
    await downloader.init();
    await FlutterDisplayMode.setHighRefreshRate();
    await setPreferredOrientations();
    runApp(const AppWrapper());
  }, errorTracker.captureError);
}
